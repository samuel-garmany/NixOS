#!/usr/bin/env python3
import json
import sys
import re
import subprocess
import os

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

    # Generate Mindmap
    lines = []
    lines.append("```mermaid")
    lines.append("mindmap")
    lines.append("  root((flake.nix))")
    
    # Use accurate flake terminology (lowercase attributes)
    if inputs:
        lines.append("    inputs")
        for i in sorted(inputs):
            lines.append(f"      {i}")
            
    # Differentiate local repository structure from flake outputs
    if hosts or modules:
        lines.append("    Local Repository")
        
        if hosts:
            lines.append("      ./hosts")
            for h in sorted(hosts):
                lines.append(f"        {h}")
                
        if modules:
            lines.append("      ./modules")
            for cat in sorted(modules.keys()):
                if cat == "modules":
                    cat_name = "(root)"
                else:
                    cat_name = cat
                lines.append(f"        {cat_name}")
                for mod in sorted(modules[cat]):
                    lines.append(f"          {mod}")
                
    if outputs:
        lines.append("    outputs")
        for out_type, out_val in outputs.items():
            lines.append(f"      {out_type}")
            if isinstance(out_val, dict):
                for k, v in out_val.items():
                    lines.append(f"        {k}")
                    if isinstance(v, dict) and 'type' not in v:
                        # Print system-specific sub-keys (like devShells.x86_64-linux.pyqt)
                        for k2 in v.keys():
                            lines.append(f"          {k2}")
    
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
