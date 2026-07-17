#!/usr/bin/env python3
import json
import sys
import re
import subprocess
import os

def safe_id(s):
    return re.sub(r'[^a-zA-Z0-9]', '_', s)

def main():
    outputs = {}
    try:
        result = subprocess.run(["nix", "flake", "show", "--json"], capture_output=True, text=True)
        if result.returncode == 0:
            outputs = json.loads(result.stdout)
    except Exception as e:
        pass

    inputs = []
    try:
        result = subprocess.run(["nix", "flake", "metadata", "--json"], capture_output=True, text=True)
        if result.returncode == 0:
            meta = json.loads(result.stdout)
            root_inputs = meta.get("locks", {}).get("nodes", {}).get("root", {}).get("inputs", {})
            inputs = sorted(list(root_inputs.keys()))
    except:
        pass

    if not inputs:
        try:
            with open("flake.nix") as f:
                content = f.read()
                match = re.search(r'inputs\s*=\s*\{([^}]+)\}', content)
                if match:
                    for line in match.group(1).split('\n'):
                        line = line.strip()
                        if line and not line.startswith('#') and '=' in line:
                            name = line.split('=')[0].split('.')[0].strip()
                            if name and name not in inputs and name not in ('inputs', 'url'):
                                inputs.append(name)
        except:
            pass

    modules = {}
    if os.path.exists("modules"):
        for root, dirs, files in os.walk("modules"):
            for file in files:
                if file.endswith(".nix"):
                    category = os.path.basename(root)
                    if category not in modules:
                        modules[category] = []
                    modules[category].append(file)

    hosts = []
    if os.path.exists("hosts"):
        for item in os.listdir("hosts"):
            if os.path.isdir(os.path.join("hosts", item)):
                hosts.append(item)

    lines = []
    lines.append("```mermaid")
    lines.append("graph TD")
    
    # Styling - NixOS Official Colors (#5277C3 and #7EBAE4)
    lines.append("  classDef flake fill:#5277C3,stroke:#fff,stroke-width:2px,color:#fff,font-weight:bold,rx:10,ry:10;")
    lines.append("  classDef input fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:5,ry:5;")
    lines.append("  classDef local fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:5,ry:5;")
    lines.append("  classDef output fill:#5277C3,stroke:#7EBAE4,stroke-width:2px,color:#fff,rx:5,ry:5;")
    
    lines.append("  Flake[flake.nix]:::flake")
    
    if inputs:
        lines.append("")
        lines.append("  subgraph Inputs [Flake Inputs]")
        lines.append("    direction TB")
        for i in sorted(inputs):
            lines.append(f"    in_{safe_id(i)}[{i}]:::input")
        lines.append("  end")
        lines.append("  Inputs --> Flake")

    if hosts or modules:
        lines.append("")
        lines.append("  subgraph Local [Local Repository]")
        lines.append("    direction TB")
        
        if hosts:
            lines.append("    subgraph h_Hosts [Hosts]")
            lines.append("      direction TB")
            for h in sorted(hosts):
                lines.append(f"      h_{safe_id(h)}[{h}]:::local")
            lines.append("    end")
            
        if modules:
            lines.append("    subgraph m_Modules [Modules]")
            lines.append("      direction TB")
            for cat in sorted(modules.keys()):
                cat_name = "(Root)" if cat == "modules" else cat.capitalize()
                lines.append(f"      subgraph cat_{safe_id(cat)} [{cat_name}]")
                lines.append("        direction TB")
                for mod in sorted(modules[cat]):
                    lines.append(f"        m_{safe_id(cat)}_{safe_id(mod)}[{mod}]:::local")
                lines.append("      end")
            lines.append("    end")
        
        lines.append("  end")
        lines.append("  Local --> Flake")

    # Outputs
    if outputs:
        lines.append("")
        lines.append("  subgraph Outputs [Flake Outputs]")
        lines.append("    direction TB")
        
        for out_type, out_val in outputs.items():
            if isinstance(out_val, dict):
                for k, v in out_val.items():
                    if isinstance(v, dict) and 'type' not in v:
                        for k2 in v.keys():
                            flake_attr = f"{out_type}.{k}.{k2}"
                            out_id = f"out_{safe_id(out_type)}_{safe_id(k)}_{safe_id(k2)}"
                            lines.append(f"    {out_id}[{flake_attr}]:::output")
                    else:
                        flake_attr = f"{out_type}.{k}"
                        out_id = f"out_{safe_id(out_type)}_{safe_id(k)}"
                        lines.append(f"    {out_id}[{flake_attr}]:::output")
        lines.append("  end")
        lines.append("  Flake --> Outputs")

    lines.append("```")
    mermaid_text = "\n".join(lines)

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
