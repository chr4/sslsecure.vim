" Author: Chris Aumann <me@chr4.org>
" Version: 1.0.0
" Description: Plugin that marks insecure SSL/TLS cipher-suites and protocol options as errors.

if exists('g:loaded_sslsecure')
  finish
endif
let g:loaded_sslsecure = 1


let s:pre = '\([:_-]\zs'
let s:mid = '\|\([^!]\|^\)\zs'
let s:post = '\ze[:_-]\S\)'

" Mark insecure SSL Ciphers (Note: List might not not complete)
" Reference: https://www.openssl.org/docs/man1.0.2/apps/ciphers.html
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'SSLv3' . s:mid . 'SSLv3' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'SSLv2' . s:mid . 'SSLv2' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'HIGH' . s:mid . 'HIGH' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'MEDIUM' . s:mid . 'MEDIUM' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'LOW' . s:mid . 'LOW' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'DEFAULT' . s:mid . 'DEFAULT' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'COMPLEMENTOFDEFAULT' . s:mid . 'COMPLEMENTOFDEFAULT' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'ALL' . s:mid . 'ALL' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'COMPLEMENTOFALL' . s:mid . 'COMPLEMENTOFALL' . s:post)

autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'SHA\ze\(\D\|$\)' . s:mid . 'SHA' . s:post) " Match SHA without matching SHA256+
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'SHA1\ze' . s:mid . 'SHA1' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'MD5' . s:mid . 'MD5' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'RC2' . s:mid . 'RC2' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'RC4' . s:mid . 'RC4' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . '3DES' . s:mid . '3DES' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'DES\|\([^!3]\|^\)\zsDES' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'aDSS' . s:mid . 'aDSS' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'DSS\|\([^!a]\|^\)\zsDSS' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'PSK' . s:mid . 'PSK' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'IDEA' . s:mid . 'IDEA' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'SEED' . s:mid . 'SEED' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'EXP\w*' . s:mid . 'EXP\w*' . s:post) " Match all EXPORT ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'aGOST\w*' . s:mid . 'aGOST\w*' . s:post) " Match all GOST ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'kGOST\w*' . s:mid . 'kGOST\w*' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'GOST\w*\|\([^!ak]\|^\)\zsGOST\w*' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . '[kae]\?FZA' . s:mid . '[kae]\?FZA' . s:post) " Not implemented ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'ECB' . s:mid . 'ECB' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . '[aes]NULL' . s:mid . '[aes]NULL' . s:post)

" Anonymous cipher suites should never be used
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'DH\ze\([^E]\|$\)\|\([^!ECa]\|^\)\zsDH' . s:post) " Try to match DH without DHE, EDH, EECDH, etc.
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'ECDH\ze\([^E]\|$\)\|\([^!EA]\|^\)\zsECDH' . s:post) " Do not match EECDH, ECDHE
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'ADH' . s:mid . 'ADH' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'kDHE' . s:mid . 'kDHE' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'kEDH' . s:mid . 'kEDH' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'kECDHE' . s:mid . 'kECDHE' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'kEECDH' . s:mid . 'kEECDH' . s:post)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('insecureSSLCipher', s:pre . 'AECDH\|\([^!E]\|^\)\zsAECDH' . s:post)


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
