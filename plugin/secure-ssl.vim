" Mark insecure SSL Ciphers (Note: List might not not complete)
" Reference: https://www.openssl.org/docs/man1.0.2/apps/ciphers.html
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsSSLv3', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsSSLv2', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsHIGH', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsMEDIUM', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsLOW', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsDEFAULT', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsCOMPLEMENTOFDEFAULT', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsALL', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsCOMPLEMENTOFALL', 1)

autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsSHA\ze\D', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsSHA1\ze\D', 1)  " Match SHA1 without matching SHA256+
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsMD5', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsRC2', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsRC4', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zs3DES', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!3]\zsDES', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsaDSS', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!a]\zsDSS', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zs\w*PSK', 1)     " TODO: Matching is complicated
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsIDEA', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsSEED', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsEXP\w*', 1)     " Match all EXPORT ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsaGOST\w*', 1)   " Match all GOST ciphers
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zskGOST\w*', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!ak]\zsGOST\w*', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zs[kae]\?FZA', 1) " Not implemented
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsECB', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zs[aes]NULL', 1)

" Anonymous cipher suites should never be used
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!ECa]\zsDH\ze[^E]', 1)  " Try to match DH without DHE, EDH, EECDH, etc.
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!EA]\zsECDH\ze[^E]', 1) " Do not match EECDH, ECDHE
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zsADH', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zskDHE', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zskEDH', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zskECDHE', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!]\zskEECDH', 1)
autocmd BufWinEnter * let w:insecureSSLCipher=matchadd('Error', '\ccipher.*\C[^!E]\zsAECDH', 1)


" Check for insecure protocols after keywords that could specify TLS/ SSL protocols
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('Error', '\c\(tls\|ssl\).*\(protocol\|option\).*[^!-]\zsSSlv2', 1)
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('Error', '\c\(tls\|ssl\).*\(protocol\|option\).*[^!-]\zsSSlv3', 1)

" TLSv1 is vulnerable to the BEAST attack. Should be disabled if possible.
" TODO: TLSv1.0 is not matched yet
" autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('Error', '\c\(tls\|ssl\).*\(protocol\|option\).*[^!-]\zsTLSv1\ze[^\.]', 1)
