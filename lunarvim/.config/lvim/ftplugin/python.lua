if vim.fn.expand('%', false, false) == '/home/py/repo/crypto-trading-comp/-' then
   require 'lspconfig'.setup {
      cmd = 'podman run -it -p 8888:8888/tcp -p 8000:8000 -v "$HOME/repo/crypto-trading-comp":/srv --rm --name temppy3.7 localhost/py3.7:latest pylsp'
   }
end
