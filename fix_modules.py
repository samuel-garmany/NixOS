import os
import glob
import re

def fix_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # If it is options.nix, skip
    if "options.nixos" in content and "deferredModule" in content:
        return
        
    # We want to find the first line like { config, pkgs, lib, ... }:
    # and the line config.nixos.base = { or config.nixos.desktop = { or config.nixos.laptop = {
    
    # We will just use regex to swap the signature and the assignment.
    
    # Match the signature at the top. It can have various forms, e.g. { pkgs, config, ... }:
    # We will match anything from the start of the file that looks like { ... }:
    
    match = re.search(r'^\s*({[^}]+}:\s*)\n+{\n\s*(config\.nixos\.(base|desktop|laptop)\s*=\s*{)', content, re.MULTILINE)
    
    if match:
        signature = match.group(1)
        assignment = match.group(2)
        
        new_header = f"{{\n  {assignment} {signature}"
        
        new_content = content[:match.start()] + new_header + content[match.end():]
        
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Fixed {filepath}")
    else:
        print(f"Skipped {filepath} (no match)")

for root, _, files in os.walk('modules'):
    for f in files:
        if f.endswith('.nix'):
            fix_file(os.path.join(root, f))
