#!/usr/bin/env python3
import json
import sys
import re
import subprocess

def parse_node(name, node, parent, edges, nodes):
    node_id = f"node_{len(nodes)}"
    nodes[node_id] = name
    
    if parent is not None:
        edges.append((parent, node_id))
    
    if isinstance(node, dict):
        if 'type' in node:
            nodes[node_id] = f"{name}\\n({node['type']})"
        else:
            for k, v in node.items():
                parse_node(k, v, node_id, edges, nodes)

def main():
    try:
        # Run nix flake show --json
        result = subprocess.run(["nix", "flake", "show", "--json"], capture_output=True, text=True, check=False)
        if result.returncode != 0:
            print(f"Error running nix flake show: {result.stderr}", file=sys.stderr)
            sys.exit(1)
        
        data = json.loads(result.stdout)
    except Exception as e:
        print(f"Failed to get or parse flake json: {e}", file=sys.stderr)
        sys.exit(1)
        
    edges = []
    nodes = {}
    
    parse_node("flake", data, None, edges, nodes)
    
    mermaid_lines = []
    mermaid_lines.append("```mermaid")
    mermaid_lines.append("graph TD")
    for nid, name in nodes.items():
        mermaid_lines.append(f'    {nid}["{name}"]')
    for src, dst in edges:
        mermaid_lines.append(f"    {src} --> {dst}")
    mermaid_lines.append("```")
    mermaid_text = "\n".join(mermaid_lines)

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
