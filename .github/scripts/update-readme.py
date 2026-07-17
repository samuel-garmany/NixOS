#!/usr/bin/env python3
import json
import sys
import re
import subprocess
import os

def safe_id(s):
    return re.sub(r'[^a-zA-Z0-9]', '_', s)

def main():
    # 1. Get flake outputs
    outputs = {}
    try:
        result = subprocess.run(["nix", "flake", "show", "--json"], capture_output=True, text=True)
        if result.returncode == 0:
            outputs = json.loads(result.stdout)
    except Exception as e:
        print(f"Warning: could not get flake show: {e}", file=sys.stderr)

    # 2. Get inputs from flake metadata
    inputs = []
    try:
        result = subprocess.run(["nix", "flake", "metadata", "--json"], capture_output=True, text=True)
        if result.returncode == 0:
            meta = json.loads(result.stdout)
            root_inputs = meta.get("locks", {}).get("nodes", {}).get("root", {}).get("inputs", {})
            inputs = sorted(list(root_inputs.keys()))
    except Exception as e:
        print(f"Warning: could not get flake metadata: {e}", file=sys.stderr)

    if not inputs:
        try:
            with open("flake.nix") as f:
                content = f.read()
                match = re.search(r'inputs\s*=\s*\{([^}]+)\}', content)
                if match:
                    input_block = match.group(1)
                    for line in input_block.split('\n'):
                        line = line.strip()
                        if line and not line.startswith('#') and '=' in line:
                            name = line.split('=')[0].split('.')[0].strip()
                            if name and name not in inputs and name not in ('inputs', 'url'):
                                inputs.append(name)
        except:
            pass

    # 3. Get modules
    modules = {}
    if os.path.exists("modules"):
        for root, dirs, files in os.walk("modules"):
            for file in files:
                if file.endswith(".nix"):
                    category = os.path.basename(root)
                    name = file[:-4]
                    if category not in modules:
                        modules[category] = []
                    modules[category].append(name)

    # 4. Get hosts
    hosts = []
    if os.path.exists("hosts"):
        for item in os.listdir("hosts"):
            if os.path.isdir(os.path.join("hosts", item)):
                hosts.append(item)

    # Generate Flowchart
    lines = []
    lines.append("```mermaid")
    lines.append("graph LR")
    
    # Styling
    lines.append("  classDef flake fill:#3b82f6,stroke:#1e3a8a,stroke-width:3px,color:#fff,font-weight:bold,rx:10,ry:10;")
    lines.append("  classDef input fill:#10b981,stroke:#064e3b,color:#fff,rx:5,ry:5;")
    lines.append("  classDef local fill:#f59e0b,stroke:#78350f,color:#fff,rx:5,ry:5;")
    lines.append("  classDef output fill:#8b5cf6,stroke:#4c1d95,color:#fff,rx:5,ry:5;")
    
    # Core Evaluator Node
    lines.append("  Flake[flake.nix]:::flake")
    
    # Inputs Subgraph
    if inputs:
        lines.append("")
        lines.append("  subgraph Inputs [Flake Inputs]")
        lines.append("    direction TB")
        for i in sorted(inputs):
            lines.append(f"    in_{safe_id(i)}[{i}]:::input")
        lines.append("  end")
        lines.append("  Inputs --> Flake")

    # Local Repository Subgraph
    if hosts or modules:
        lines.append("")
        lines.append("  subgraph Local [Local Repository]")
        lines.append("    direction TB")
        
        if hosts:
            lines.append("    subgraph Hosts")
            lines.append("      direction TB")
            for h in sorted(hosts):
                lines.append(f"      h_{safe_id(h)}[{h}]:::local")
            lines.append("    end")
            
        if modules:
            lines.append("    subgraph Modules")
            lines.append("      direction TB")
            for cat in sorted(modules.keys()):
                cat_name = "(Root)" if cat == "modules" else cat.capitalize()
                lines.append(f"      m_{safe_id(cat)}[{cat_name}]:::local")
            lines.append("    end")
        
        lines.append("  end")
        lines.append("  Local --> Flake")

    # Outputs Subgraph
    if outputs:
        lines.append("")
        lines.append("  subgraph Outputs [Flake Outputs]")
        lines.append("    direction TB")
        for out_type, out_val in outputs.items():
            if isinstance(out_val, dict):
                for k, v in out_val.items():
                    if isinstance(v, dict) and 'type' not in v:
                        for k2 in v.keys():
                            lines.append(f"    out_{safe_id(out_type)}_{safe_id(k)}_{safe_id(k2)}[{out_type}.{k}.{k2}]:::output")
                    else:
                        lines.append(f"    out_{safe_id(out_type)}_{safe_id(k)}[{out_type}.{k}]:::output")
        lines.append("  end")
        lines.append("  Flake --> Outputs")

    lines.append("```")
    mermaid_text = "\n".join(lines)

    # Update README.md
    readme_path = "README.md"
    try:
        with open(readme_path, "r") as f:
            content = f.read()
            
        start_marker = "<!-- FLAKE_MAP_START -->"
        end_marker = "<!-- FLAKE_MAP_END -->"
        
        pattern = re.compile(f"({start_marker}).*?({end_marker})", re.DOTALL)
        
        if not pattern.search(content):
            print("Markers not found in README.md", file=sys.stderr)
            sys.exit(1)
            
        new_content = pattern.sub(rf"\1\n{mermaid_text}\n\2", content)
        
        with open(readme_path, "w") as f:
            f.write(new_content)
            
        print("Successfully updated README.md")
    except Exception as e:
        print(f"Failed to update README.md: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
