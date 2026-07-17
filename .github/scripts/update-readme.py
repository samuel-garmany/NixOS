#!/usr/bin/env python3
import json
import sys
import re
import subprocess
import os

def safe_id(s):
    return re.sub(r'[^a-zA-Z0-9]', '_', s)

def get_flake_outputs():
    try:
        result = subprocess.run(["nix", "flake", "show", "--json"], capture_output=True, text=True)
        if result.returncode == 0:
            return json.loads(result.stdout)
    except Exception:
        pass
    return {}

def get_flake_inputs():
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
    return inputs

def get_local_dirs():
    local_dirs = {}
    valid_top_levels = [d for d in os.listdir('.') if os.path.isdir(d) and not d.startswith('.')]
    
    for d in valid_top_levels:
        has_nix = False
        items = set()
        for root, dirs, files in os.walk(d):
            if any(f.endswith('.nix') for f in files):
                has_nix = True
            
            if root == d:
                for item in dirs + files:
                    if not item.startswith('.'):
                        items.add(item.replace('.nix', ''))
        
        if has_nix:
            local_dirs[d] = sorted(list(items))
            
    return local_dirs

def main():
    outputs = get_flake_outputs()
    inputs = get_flake_inputs()
    local_dirs = get_local_dirs()

    lines = []
    lines.append("```mermaid")
    lines.append("graph LR")
    
    # Styling - Aesthetic NixOS Colors + Modern flat design
    lines.append("  classDef flake fill:#5277C3,stroke:#fff,stroke-width:2px,color:#fff,font-weight:bold,rx:10,ry:10;")
    lines.append("  classDef input fill:#E3F2FD,stroke:#5277C3,stroke-width:2px,color:#1565C0,rx:5,ry:5;")
    lines.append("  classDef local fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20,rx:5,ry:5;")
    lines.append("  classDef output fill:#FFF3E0,stroke:#E65100,stroke-width:2px,color:#E65100,rx:5,ry:5;")
    
    # Core Evaluator Node
    lines.append("  Flake(\"flake.nix\"):::flake")
    
    # 1. Inputs
    if inputs:
        lines.append("")
        lines.append("  subgraph Inputs [\"Flake Inputs\"]")
        lines.append("    direction TB")
        for i in sorted(inputs):
            lines.append(f"    in_{safe_id(i)}([\"{i}\"]):::input")
        lines.append("  end")
        lines.append("  Inputs --> Flake")

    # 2. Local Repository
    if local_dirs:
        lines.append("")
        lines.append("  subgraph Local [\"Local Repository\"]")
        lines.append("    direction TB")
        
        for d, items in local_dirs.items():
            if not items:
                lines.append(f"    loc_{safe_id(d)}[\"<b>{d}/</b>\"]:::local")
                continue
                
            item_str = ", ".join(items)
            if len(item_str) > 50:
                words = item_str.split(", ")
                wrapped = []
                current_line = []
                current_len = 0
                for w in words:
                    if current_len + len(w) > 40 and current_line:
                        wrapped.append(", ".join(current_line))
                        current_line = [w]
                        current_len = len(w)
                    else:
                        current_line.append(w)
                        current_len += len(w) + 2
                if current_line:
                    wrapped.append(", ".join(current_line))
                item_str = ",<br/>".join(wrapped)
                
            lines.append(f"    loc_{safe_id(d)}[\"<b>{d}/</b><br/><small>{item_str}</small>\"]:::local")
            
        lines.append("  end")
        lines.append("  Local --> Flake")

    # 4. Outputs
    if outputs:
        lines.append("")
        lines.append("  subgraph Outputs [\"Flake Outputs\"]")
        lines.append("    direction TB")
        
        for out_type, out_val in outputs.items():
            if isinstance(out_val, dict):
                lines.append(f"    subgraph out_{safe_id(out_type)} [\"{out_type}\"]")
                lines.append("      direction TB")
                for k, v in out_val.items():
                    if isinstance(v, dict) and 'type' not in v:
                        for k2 in v.keys():
                            flake_attr = f"{k}.{k2}"
                            out_id = f"out_{safe_id(out_type)}_{safe_id(k)}_{safe_id(k2)}"
                            lines.append(f"      {out_id}(\"{flake_attr}\"):::output")
                    else:
                        flake_attr = f"{k}"
                        out_id = f"out_{safe_id(out_type)}_{safe_id(k)}"
                        lines.append(f"      {out_id}(\"{flake_attr}\"):::output")
                lines.append("    end")
        lines.append("  end")
        lines.append("  Flake --> Outputs")

    lines.append("```")
    mermaid_text = "\n".join(lines)

    # --- Write to README ---
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
