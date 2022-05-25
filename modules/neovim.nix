{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.modules.neovim;
in
{
  options = {
    modules.neovim = {
      enable = mkEnableOption "Enable neovim";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true; # symlink vim
      plugins = with pkgs.vimPlugins; [
        vim-nix
        # bufferline
        # lualine
        # nvim-tree
        vim-surround
        gruvbox
        nerdcommenter
      ];
      extraConfig = ''
        set number
        colorscheme gruvbox
        set mouse=a
        let mapleader = " "

        " Default to highlighting whole lines. Use shift V for highlighting smaller regions.
        nnoremap v V
        nnoremap V v
        vnoremap v V
        vnoremap V v

        " Fancy save/esc commands
        inoremap ;d <Esc>
        vnoremap ;d <Esc>
        nnoremap ;d <Esc>
        inoremap ;f <C-O>:write<Cr>
        nnoremap ;f :write<CR>
        nnoremap ;q :q<CR>
        nnoremap ;Q :qall<CR>

        " up & down arrow keys scroll the page in normal mode
        map <Up> <C-Y>
        map <Down> <C-E>

        " copy to clipboard
        set clipboard=unnamed,unnamedplus
        vnoremap ;y "*y
        nnoremap ;y "*y

        " switch auto tabbing off for pasting
        set pastetoggle=<F2>

        function! MoveFile(newspec)
             let old = expand('%')
             " could be improved:
             if (old == a:newspec)
                 return 0
             endif
             exe 'sav' fnameescape(a:newspec)
             call delete(old)
        endfunction

        command! -nargs=1 -complete=file -bar MoveFile call MoveFile('<args>')
      '';
    };
  };
}
