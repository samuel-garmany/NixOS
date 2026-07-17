#!/usr/bin/env python3
import json
import sys
import re
import subprocess
import os

def safe_id(s):
    return re.sub(r'[^a-zA-Z0-9]', '_', s)

def clean_pkg_name(p):
    m = re.match(r'^([a-zA-Z0-9_-]+?)-[0-9]', p)
    return m.group(1) if m else p

def get_nix_eval(cmd):
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            return json.loads(result.stdout)
    except:
        pass
    return None

def get_host_details(host):
    details = {}
    
    # 1. System Packages
    cmd_sys_pkgs = ["nix", "eval", f".#nixosConfigurations.{host}.config.environment.systemPackages", "--apply", "map (p: p.name)", "--json"]
    sys_pkgs = get_nix_eval(cmd_sys_pkgs)
    if sys_pkgs:
        cleaned = sorted(list(set(clean_pkg_name(p) for p in sys_pkgs)), key=lambda x: x.lower())
        details['System Packages'] = cleaned

    # 2. Home Manager Users & Packages
    cmd_hm_users = ["nix", "eval", f".#nixosConfigurations.{host}.config.home-manager.users", "--apply", "builtins.attrNames", "--json"]
    hm_users = get_nix_eval(cmd_hm_users)
    if hm_users:
        details['Home-Manager'] = {}
        for u in hm_users:
            cmd_hm_pkgs = ["nix", "eval", f".#nixosConfigurations.{host}.config.home-manager.users.{u}.home.packages", "--apply", "map (p: p.name)", "--json"]
            hm_pkgs = get_nix_eval(cmd_hm_pkgs)
            if hm_pkgs:
                cleaned = sorted(list(set(clean_pkg_name(p) for p in hm_pkgs)), key=lambda x: x.lower())
                details['Home-Manager'][u] = cleaned

    # 3. Systemd Services
    cmd_services = ["nix", "eval", f".#nixosConfigurations.{host}.config.systemd.services", "--apply", "builtins.attrNames", "--json"]
    services = get_nix_eval(cmd_services)
    if services:
        # Filter out common base systemd services to reduce noise if needed, or just sort them
        # Let's just sort alphabetically to keep it fully dynamic
        cleaned = sorted(list(set(services)), key=lambda x: x.lower())
        details['Background Services'] = cleaned

    return details

def format_list(title, items, limit=5):
    if not items:
        return ""
    html = f"<hr/><i>{title}:</i><br/>"
    display = items[:limit]
    html += "<br/>".join([f"- {p}" for p in display])
    if len(items) > limit:
        html += f"<br/><i>... (+{len(items)-limit} more)</i>"
    return html

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
    lines.append("graph TD")
    
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
                            flake_attr = f"{out_type}.{k}.{k2}"
                            label_html = f"<b>{flake_attr}</b>"
                            
                            if out_type == "devShells":
                                cmd = ["nix", "eval", f".#{flake_attr}.nativeBuildInputs", "--apply", "map (p: p.name)", "--json"]
                                pkgs = get_nix_eval(cmd)
                                if pkgs:
                                    cleaned = sorted(list(set(clean_pkg_name(p) for p in pkgs)), key=lambda x: x.lower())
                                    label_html += format_list("Build Inputs", cleaned)
                                    
                            lines.append(f"    out_{safe_id(out_type)}_{safe_id(k)}_{safe_id(k2)}[\"{label_html}\"]:::output")
                    else:
                        flake_attr = f"{out_type}.{k}"
                        label_html = f"<b>{flake_attr}</b>"
                        
                        if out_type == "nixosConfigurations":
                            host = k
                            details = get_host_details(host)
                            
                            if 'System Packages' in details:
                                label_html += format_list("System Packages", details['System Packages'], 4)
                            if 'Home-Manager' in details:
                                for u, pkgs in details['Home-Manager'].items():
                                    label_html += format_list(f"HM Packages ({u})", pkgs, 4)
                            if 'Background Services' in details:
                                label_html += format_list("Background Services", details['Background Services'], 4)
                                
                        lines.append(f"    out_{safe_id(out_type)}_{safe_id(k)}[\"{label_html}\"]:::output")
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
