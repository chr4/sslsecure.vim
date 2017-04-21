" Author: Chris Aumann <me@chr4.org>
" Version: 1.0.0
" Description: Plugin that marks insecure SSL/TLS cipher-suites and protocol options as errors.

if exists('g:loaded_sslsecure')
  finish
endif
let g:loaded_sslsecure = 1


" Mark insecure SSL Ciphers (Note: List might not not complete)
" Reference: https://www.openssl.org/docs/man1.0.2/apps/ciphers.html
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsSSLv3\|\([^!]\|^\)\zsSSLv3\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsSSLv2\|\([^!]\|^\)\zsSSLv2\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsHIGH\|\([^!]\|^\)\zsHIGH\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsMEDIUM\|\([^!]\|^\)\zsMEDIUM\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsLOW\|\([^!]\|^\)\zsLOW\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsDEFAULT\|\([^!]\|^\)\zsDEFAULT\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsCOMPLEMENTOFDEFAULT\|\([^!]\|^\)\zsCOMPLEMENTOFDEFAULT\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsALL\|\([^!]\|^\)\zsALL\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsCOMPLEMENTOFALL\|\([^!]\|^\)\zsCOMPLEMENTOFALL\ze[:_-]\)')

autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsSHA\ze\(\D\|$\)\|\([^!]\|^\)\zsSHA\ze[:_-]\)') " Match SHA without matching SHA256+
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsSHA1\ze\|\([^!]\|^\)\zsSHA1\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsMD5\|\([^!]\|^\)\zsMD5\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsRC2\|\([^!]\|^\)\zsRC2\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsRC4\|\([^!]\|^\)\zsRC4\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zs3DES\|\([^!]\|^\)\zs3DES\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsDES\|\([^!3]\|^\)\zsDES\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsaDSS\|\([^!]\|^\)\zsaDSS\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsDSS\|\([^!a]\|^\)\zsDSS\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsPSK\|\([^!]\|^\)\zsPSK\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsIDEA\|\([^!]\|^\)\zsIDEA\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsSEED\|\([^!]\|^\)\zsSEED\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsEXP\w*\|\([^!]\|^\)\zsEXP\w*\ze[:_-]\)') " Match all EXPORT ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsaGOST\w*\|\([^!]\|^\)\zsaGOST\w*\ze[:_-]\)') " Match all GOST ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zskGOST\w*\|\([^!]\|^\)\zskGOST\w*\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsGOST\w*\|\([^!ak]\|^\)\zsGOST\w*\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zs[kae]\?FZA\|\([^!]\|^\)\zs[kae]\?FZA\ze[:_-]\)') " Not implemented ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsECB\|\([^!]\|^\)\zsECB\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zs[aes]NULL\|\([^!]\|^\)\zs[aes]NULL\ze[:_-]\)')

" Anonymous cipher suites should never be used
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsDH\ze\([^E]\|$\)\|\([^!ECa]\|^\)\zsDH\ze[:_-]\)') " Try to match DH without DHE, EDH, EECDH, etc.
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsECDH\ze\([^E]\|$\)\|\([^!EA]\|^\)\zsECDH\ze[:_-]\)') " Do not match EECDH, ECDHE
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsADH\|\([^!]\|^\)\zsADH\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zskDHE\|\([^!]\|^\)\zskDHE\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zskEDH\|\([^!]\|^\)\zskEDH\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zskECDHE\|\([^!]\|^\)\zskECDHE\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zskEECDH\|\([^!]\|^\)\zskEECDH\ze[:_-]\)')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', '\([:_-]\zsAECDH\|\([^!E]\|^\)\zsAECDH\ze[:_-]\)')


" Protocol matching condition
let s:protocol = '\(TLS\|tls\|SSL\|ssl\)[\._-]\?\([Pp]rotocol\|[Oo]ption\).*'

" Check for insecure protocols after keywords that could specify TLS/ SSL protocols
" TODO: -SSLv3 is highlighted from insecureSSLCipher rules above (Apache notation)
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv2')
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv3')

" TLSv1 is vulnerable to the BEAST attack. Should be disabled if possible.
" TODO: TLSv1.0 is not matched yet
" autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cTLSv1\ze[^\.]')


" Highlighting
hi link insecureSSLCipher Error
hi link insecureSSLProtocol Error
