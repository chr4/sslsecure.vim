" Check for insecure ciphers after keywords that contain 'cipher' (case insensitive)
autocmd BufWinEnter * syn region cipherBlock start=+\ccipher+ end=+$+ contains=insecureSSLCipher

" Mark insecure SSL Ciphers (Note: List might not not complete)
" Reference: https://www.openssl.org/docs/man1.0.2/apps/ciphers.html
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsSSLv3'               contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsSSLv2'               contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsHIGH'                contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsMEDIUM'              contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsLOW'                 contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsDEFAULT'             contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsCOMPLEMENTOFDEFAULT' contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsALL'                 contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsCOMPLEMENTOFALL'     contained

autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsSHA\ze\D'   contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsSHA1\ze\D'  contained " Match SHA1 without matching SHA256+
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsMD5'        contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsRC2'        contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsRC4'        contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zs3DES'       contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!3]\zsDES'       contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsaDSS'       contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!a]\zsDSS'       contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zs\w*PSK'     contained " TODO: Matching is complicated
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsIDEA'       contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsSEED'       contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsEXP\w*'     contained " Match all EXPORT ciphers
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsaGOST\w*'   contained " Match all GOST ciphers
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zskGOST\w*'   contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!ak]\zsGOST\w*'  contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zs[kae]\?FZA' contained  " Not implemented
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsECB'        contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zs[aes]NULL'  contained

" Anonymous cipher suites should never be used
autocmd BufWinEnter * syn match insecureSSLCipher '[^!ECa]\zsDH\ze[^E]'  contained " Try to match DH without DHE, EDH, EECDH, etc.
autocmd BufWinEnter * syn match insecureSSLCipher '[^!EA]\zsECDH\ze[^E]' contained " Do not match EECDH, ECDHE
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zsADH'           contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zskDHE'          contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zskEDH'          contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zskECDHE'        contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!]\zskEECDH'        contained
autocmd BufWinEnter * syn match insecureSSLCipher '[^!E]\zsAECDH'        contained


" Check for insecure protocols after keywords that could specify TLS/ SSL protocols
autocmd BufWinEnter * syn region cipherBlock start=+\c\(tls\|ssl\).*\(protocol\|option\)+ end=+$+ contains=insecureSSLProtocol

autocmd BufWinEnter * syn match insecureSSLProtocol '[^!-]\zs\cSSlv2' contained
autocmd BufWinEnter * syn match insecureSSLProtocol '[^!-]\zs\cSSlv3' contained
" autocmd BufWinEnter * syn match insecureSSLProtocol '[^!-]\zs\cTLSv1\.[1-9]' contained

" Highlight as Error
hi link insecureSSLCipher Error
hi link insecureSSLProtocol Error
