" Author: Chris Aumann <me@chr4.org>
" Version: 1.0.0
" Description: Plugin that marks insecure SSL/TLS cipher-suites and protocol options as errors.

if exists('g:loaded_sslsecure')
  finish
endif
let g:loaded_sslsecure = 1


" Define beginning and ending patterns. Besides beginning and end of line:
" Whitespaces, quotes, comma, dot, semicolon, brackets
" Note: colon and underscore are used by the cipherstrings!
"
" TODO: Prevent :MD5 from being highlighted in prose.
"       This can be achieved by removing \s (and maybe $) from the s:end,
"       but might result in other cipher strings being missed.
let s:begin = "\\v(^|\\s|'|\"|,|\\.|;|\\{|\\[|\\()\\m"
let s:end   = "\\v($|\\s|'|\"|,|\\.|;|\\}|\\]|\\))\\m"
let s:delimiter = '[:+_-]'

" This function highlights a keyword according to the rules specified above
function s:genmatch(keyword, eop, exclude)
  " _DES :+DES :DES
  call matchadd('insecureSSLProtocol', '\v(_|:\+?)\m\zs' . a:keyword . '\ze' . '\(' . s:delimiter . '\|' . s:end . '\)')

  " MD5-SHA: but do not highlight !MD5-SHA: (at the beginning of a suite)
  call matchadd('insecureSSLProtocol', s:begin . '[^!]\([0-9A-Za-z]\+[+-]\)\+\zs' . a:keyword . '\ze' . s:delimiter)

  " Match :AES128-SHA: and :AES128+SHA: (in the middle of pattern)
  call matchadd('insecureSSLProtocol', ':\([0-9A-Za-z]\+[+-]\)\+\zs' . a:keyword . '\ze' . s:delimiter . '\S')

  " :AES-SHA or :AES-CBC-MD5 (at the end of suite)
  " Do not allow alpha-numeric characters before s:end, to match '-SHA";' and others properly.
  call matchadd('insecureSSLProtocol', ':\([0-9A-Za-z]\+[+-]\)\+\zs' . a:keyword . '\ze' . '[^0-9A-Za-z]*' . s:end)

  " ^keyword, "keyword, 'keyword
  " Checks for \S at the end, so "SHA: " is not highlighted in prose text.
  call matchadd('insecureSSLProtocol', s:begin . '\zs' . a:keyword . '\ze' . s:delimiter . '\S')
endfunction


" Generate patterns to highlight insecure ciphers.
" Reference: https://www.openssl.org/docs/man1.0.2/apps/ciphers.html
autocmd BufWinEnter * call s:genmatch('SSLv3', '', '')
autocmd BufWinEnter * call s:genmatch('SSLv2', '', '')
autocmd BufWinEnter * call s:genmatch('HIGH', '', '')
autocmd BufWinEnter * call s:genmatch('MEDIUM', '', '')
autocmd BufWinEnter * call s:genmatch('LOW', '', '')
autocmd BufWinEnter * call s:genmatch('DEFAULT', '', '')
autocmd BufWinEnter * call s:genmatch('COMPLEMENTOFDEFAULT', '', '')
autocmd BufWinEnter * call s:genmatch('ALL', '', '')
autocmd BufWinEnter * call s:genmatch('COMPLEMENTOFALL', '', '')

autocmd BufWinEnter * call s:genmatch('SHA', '\D', '') " Match SHA without matching SHA256+
autocmd BufWinEnter * call s:genmatch('SHA1', '', '')
autocmd BufWinEnter * call s:genmatch('MD5', '', '')
autocmd BufWinEnter * call s:genmatch('RC2', '', '')
autocmd BufWinEnter * call s:genmatch('RC4' , '', '')
autocmd BufWinEnter * call s:genmatch('3DES', '', '')
autocmd BufWinEnter * call s:genmatch('DES', '', '')
autocmd BufWinEnter * call s:genmatch('aDSS', '', '')
autocmd BufWinEnter * call s:genmatch('DSS', '', 'a')
autocmd BufWinEnter * call s:genmatch('PSK', '', '')
autocmd BufWinEnter * call s:genmatch('IDEA', '', '')
autocmd BufWinEnter * call s:genmatch('SEED', '', '')
autocmd BufWinEnter * call s:genmatch('EXP[0-9A-Za-z]*', '', '')
autocmd BufWinEnter * call s:genmatch('aGOST[0-9A-Za-z]*', '', '')
autocmd BufWinEnter * call s:genmatch('kGOST[0-9A-Za-z]*', '', '')
autocmd BufWinEnter * call s:genmatch('GOST[0-9A-Za-z]*', '', 'ak')
autocmd BufWinEnter * call s:genmatch('[kae]\?FZA', '', '')
autocmd BufWinEnter * call s:genmatch('ECB', '', '')
autocmd BufWinEnter * call s:genmatch('[aes]NULL', '', '')

" Anonymous cipher suites should never be used
autocmd BufWinEnter * call s:genmatch('DH', '[^E]', 'ECa') " Try to match DH without DHE, EDH, EECDH, etc.
autocmd BufWinEnter * call s:genmatch('ECDH', '[^E]', 'EA') " Do not match EECDH, ECDHE
autocmd BufWinEnter * call s:genmatch('ADH', '', '')
autocmd BufWinEnter * call s:genmatch('kDHE', '', '')
autocmd BufWinEnter * call s:genmatch('kEDH', '', '')
autocmd BufWinEnter * call s:genmatch('kECDHE', '', '')
autocmd BufWinEnter * call s:genmatch('kEECDH', '', '')
autocmd BufWinEnter * call s:genmatch('AECDH', '', '[^E]')


" Protocol matching condition
let s:protocol = '\(TLS\|tls\|SSL\|ssl\)[\._-]\?\([Pp]rotocol\|[Oo]ption\).*'

" Check for insecure protocols after keywords that could specify TLS/ SSL protocols
autocmd BufWinEnter * call matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv2')
autocmd BufWinEnter * call matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv3')

" TLSv1 is vulnerable to the BEAST attack. Should be disabled if possible.
" TODO: TLSv1.0 is not matched yet
" autocmd BufWinEnter * cal matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cTLSv1\ze[^\.]')


" Highlight both groups as errors
hi link insecureSSLCipher Error
hi link insecureSSLProtocol Error
