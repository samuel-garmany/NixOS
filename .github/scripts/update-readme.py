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
    
    cmd_sys_pkgs = ["nix", "eval", f".#nixosConfigurations.{host}.config.environment.systemPackages", "--apply", "map (p: p.name)", "--json"]
    sys_pkgs = get_nix_eval(cmd_sys_pkgs)
    if sys_pkgs:
        details['System Packages'] = list(set(clean_pkg_name(p) for p in sys_pkgs))

    cmd_hm_users = ["nix", "eval", f".#nixosConfigurations.{host}.config.home-manager.users", "--apply", "builtins.attrNames", "--json"]
    hm_users = get_nix_eval(cmd_hm_users)
    if hm_users:
        details['Home-Manager'] = {}
        for u in hm_users:
            cmd_hm_pkgs = ["nix", "eval", f".#nixosConfigurations.{host}.config.home-manager.users.{u}.home.packages", "--apply", "map (p: p.name)", "--json"]
            hm_pkgs = get_nix_eval(cmd_hm_pkgs)
            if hm_pkgs:
                details['Home-Manager'][u] = list(set(clean_pkg_name(p) for p in hm_pkgs))

    cmd_services = ["nix", "eval", f".#nixosConfigurations.{host}.config.systemd.services", "--apply", "builtins.attrNames", "--json"]
    services = get_nix_eval(cmd_services)
    if services:
        details['Background Services'] = list(set(services))

    return details

def sort_devshell_pkgs(pkgs, shell_name):
    # Score based on how closely it relates to the shell name
    # e.g., for 'pyqt', 'python3' gets high score.
    parts = re.split(r'[^a-zA-Z0-9]', shell_name)
    def score(p):
        s = 0
        p_lower = p.lower()
        if shell_name.lower() in p_lower:
            s += 10
        for part in parts:
            if len(part) > 2 and part.lower() in p_lower:
                s += 5
        return s
    
    # Sort by score (desc), then length (asc), then alphabetical
    return sorted(pkgs, key=lambda p: (-score(p), len(p), p.lower()))

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
                    name = file[:-4]
                    if category not in modules:
                        modules[category] = []
                    modules[category].append(name)

    hosts = []
    if os.path.exists("hosts"):
        for item in os.listdir("hosts"):
            if os.path.isdir(os.path.join("hosts", item)):
                hosts.append(item)

    # Pre-evaluate hosts to find unique packages
    host_details = {}
    all_sys_pkgs = {}
    for h in hosts:
        details = get_host_details(h)
        host_details[h] = details
        if 'System Packages' in details:
            all_sys_pkgs[h] = set(details['System Packages'])

    lines = []
    lines.append("```mermaid")
    lines.append("graph TD")
    
    # Styling - NixOS Official Colors (#5277C3 and #7EBAE4)
    lines.append("  classDef flake fill:#5277C3,stroke:#fff,stroke-width:2px,color:#fff,font-weight:bold,rx:10,ry:10;")
    lines.append("  classDef input fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:5,ry:5;")
    lines.append("  classDef local fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:5,ry:5;")
    lines.append("  classDef output fill:#5277C3,stroke:#7EBAE4,stroke-width:2px,color:#fff,rx:5,ry:5;")
    lines.append("  classDef detail fill:#f3f4f6,stroke:#5277C3,stroke-width:1px,color:#111,rx:5,ry:5;")
    lines.append("  classDef item fill:#ffffff,stroke:#9ca3af,stroke-width:1px,color:#111,rx:3,ry:3;")
    
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
                    lines.append(f"        m_{safe_id(cat)}_{safe_id(mod)}[{mod}.nix]:::local")
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
                        # e.g. devShells.x86_64-linux.pyqt
                        for k2 in v.keys():
                            flake_attr = f"{out_type}.{k}.{k2}"
                            out_id = f"out_{safe_id(out_type)}_{safe_id(k)}_{safe_id(k2)}"
                            lines.append(f"    {out_id}[{flake_attr}]:::output")
                            
                            if out_type == "devShells":
                                cmd = ["nix", "eval", f".#{flake_attr}.nativeBuildInputs", "--apply", "map (p: p.name)", "--json"]
                                pkgs = get_nix_eval(cmd)
                                if pkgs:
                                    cleaned = list(set(clean_pkg_name(p) for p in pkgs))
                                    sorted_pkgs = sort_devshell_pkgs(cleaned, k2)
                                    
                                    cat_id = f"{out_id}_deps"
                                    lines.append(f"    {cat_id}[Build Inputs]:::detail")
                                    lines.append(f"    {out_id} --- {cat_id}")
                                    
                                    display_pkgs = sorted_pkgs[:4]
                                    for idx, p in enumerate(display_pkgs):
                                        p_id = f"{cat_id}_p{idx}"
                                        lines.append(f"    {p_id}[{p}]:::item")
                                        lines.append(f"    {cat_id} --- {p_id}")
                                        
                                    if len(sorted_pkgs) > 4:
                                        p_id = f"{cat_id}_more"
                                        lines.append(f"    {p_id}[...+ {len(sorted_pkgs)-4} more]:::item")
                                        lines.append(f"    {cat_id} --- {p_id}")
                    else:
                        # e.g. nixosConfigurations.desktop
                        flake_attr = f"{out_type}.{k}"
                        out_id = f"out_{safe_id(out_type)}_{safe_id(k)}"
                        lines.append(f"    {out_id}[{flake_attr}]:::output")
                        
                        if out_type == "nixosConfigurations":
                            host = k
                            details = host_details.get(host, {})
                            
                            # Determine unique packages vs common
                            other_hosts_pkgs = set()
                            for oh, opkgs in all_sys_pkgs.items():
                                if oh != host:
                                    other_hosts_pkgs.update(opkgs)
                                    
                            my_pkgs = set(details.get('System Packages', []))
                            unique_pkgs = sorted(list(my_pkgs - other_hosts_pkgs), key=len)
                            common_pkgs = sorted(list(my_pkgs.intersection(other_hosts_pkgs)), key=len)
                            
                            # System Packages Node
                            if my_pkgs:
                                cat_id = f"{out_id}_syspkgs"
                                lines.append(f"    {cat_id}[System Packages]:::detail")
                                lines.append(f"    {out_id} --- {cat_id}")
                                
                                display_pkgs = unique_pkgs[:3] + common_pkgs[:2]
                                for idx, p in enumerate(display_pkgs):
                                    p_id = f"{cat_id}_p{idx}"
                                    flag = "⭐ " if p in unique_pkgs else ""
                                    lines.append(f"    {p_id}[{flag}{p}]:::item")
                                    lines.append(f"    {cat_id} --- {p_id}")
                                    
                                if len(my_pkgs) > len(display_pkgs):
                                    p_id = f"{cat_id}_more"
                                    lines.append(f"    {p_id}[...+ {len(my_pkgs)-len(display_pkgs)} more]:::item")
                                    lines.append(f"    {cat_id} --- {p_id}")

                            # Home-Manager
                            if 'Home-Manager' in details:
                                for u, pkgs in details['Home-Manager'].items():
                                    cat_id = f"{out_id}_hm_{safe_id(u)}"
                                    lines.append(f"    {cat_id}[HM Packages: {u}]:::detail")
                                    lines.append(f"    {out_id} --- {cat_id}")
                                    
                                    sorted_hm = sorted(pkgs, key=len)
                                    display_hm = sorted_hm[:3]
                                    for idx, p in enumerate(display_hm):
                                        p_id = f"{cat_id}_p{idx}"
                                        lines.append(f"    {p_id}[{p}]:::item")
                                        lines.append(f"    {cat_id} --- {p_id}")
                                        
                                    if len(pkgs) > len(display_hm):
                                        p_id = f"{cat_id}_more"
                                        lines.append(f"    {p_id}[...+ {len(pkgs)-len(display_hm)} more]:::item")
                                        lines.append(f"    {cat_id} --- {p_id}")

                            # Services
                            if 'Background Services' in details:
                                cat_id = f"{out_id}_services"
                                lines.append(f"    {cat_id}[Services]:::detail")
                                lines.append(f"    {out_id} --- {cat_id}")
                                
                                sorted_srv = sorted(details['Background Services'], key=len)
                                display_srv = sorted_srv[:3]
                                for idx, p in enumerate(display_srv):
                                    p_id = f"{cat_id}_p{idx}"
                                    lines.append(f"    {p_id}[{p}]:::item")
                                    lines.append(f"    {cat_id} --- {p_id}")
                                    
                                if len(details['Background Services']) > len(display_srv):
                                    p_id = f"{cat_id}_more"
                                    lines.append(f"    {p_id}[...+ {len(details['Background Services'])-len(display_srv)} more]:::item")
                                    lines.append(f"    {cat_id} --- {p_id}")

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
