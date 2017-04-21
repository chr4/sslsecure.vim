" Author: Chris Aumann <me@chr4.org>
" Version: 1.0.0
" Description: Plugin that marks insecure SSL/TLS cipher-suites and protocol options as errors.

if exists('g:loaded_sslsecure')
  finish
endif
let g:loaded_sslsecure = 1

" Cipher matching condition (a simpler one would be '[Cc]iphers\?.*')
let s:cipher = '\(\(server[\.-_]\)\?\(TLS\|tls\|SSL\|ssl\)[a-z\._-]*\|^\s*\)[Cc]iphers\?.*'

" Mark insecure SSL Ciphers (Note: List might not not complete)
" Reference: https://www.openssl.org/docs/man1.0.2/apps/ciphers.html
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsSSLv3')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsSSLv2')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsHIGH')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsMEDIUM')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsLOW')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsDEFAULT')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsCOMPLEMENTOFDEFAULT')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsALL')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsCOMPLEMENTOFALL')

autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsSHA\ze\D')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsSHA1\ze\D')  " Match SHA1 without matching SHA256+
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsMD5')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsRC2')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsRC4')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zs3DES')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!3]\zsDES')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsaDSS')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!a]\zsDSS')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zs\w*PSK')     " TODO: Matching is complicated
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsIDEA')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsSEED')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsEXP\w*')     " Match all EXPORT ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsaGOST\w*')   " Match all GOST ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zskGOST\w*')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!ak]\zsGOST\w*')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zs[kae]\?FZA') " Not implemented
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsECB')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zs[aes]NULL')

" Anonymous cipher suites should never be used
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!ECa]\zsDH\ze[^E]')  " Try to match DH without DHE, EDH, EECDH, etc.
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!EA]\zsECDH\ze[^E]') " Do not match EECDH, ECDHE
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zsADH')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zskDHE')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zskEDH')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zskECDHE')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!]\zskEECDH')
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:cipher . '[^!E]\zsAECDH')


" Protocol matching condition
let s:protocol = '\(TLS\|tls\|SSL\|ssl\)[\._-]\?\([Pp]rotocol\|[Oo]ption\).*'

" Check for insecure protocols after keywords that could specify TLS/ SSL protocols
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv2')
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv3')

" TLSv1 is vulnerable to the BEAST attack. Should be disabled if possible.
" TODO: TLSv1.0 is not matched yet
" autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cTLSv1\ze[^\.]')


" Highlighting
hi link insecureSSLCipher Error
hi link insecureSSLProtocol Error
