with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "vim-dirtytalk-spell";
  src = fetchFromGitHub {
    owner = "psliwka";
    repo = "vim-dirtytalk";
    rev = "aa57ba902b04341a04ff97214360f56856493583";
    sha256 = "sha256-azU5jkv/fD/qDDyCU1bPNXOH6rmbDauG9jDNrtIXc0Y=";
  };
  nativeBuildInputs = [ neovim ];
  buildPhase = ''
    mkdir -p spell
    cat wordlists/*.words > spell/programming.utf-8.add
    # mkspell requires a utf-8 locale. Let's just use C.UTF-8 or similar
    export LC_ALL=C.utf8
    nvim --headless -n -c "mkspell! spell/programming.utf-8.spl spell/programming.utf-8.add" -c "q"
  '';
  installPhase = ''
    mkdir -p $out/spell
    cp spell/programming.utf-8.spl $out/spell/
    cp spell/programming.utf-8.add $out/spell/
  '';
}
