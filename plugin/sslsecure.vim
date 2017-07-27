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
function s:genmatch(keyword, eop, exclude) abort
  " _DES :+DES :DES
  call matchadd('insecureSSLProtocol', '\v(_|:\+?)\m\zs' . a:keyword . '\ze' . '\(' . s:delimiter . '\|' . s:end . '\)')

  " DES-MD5: but do not highlight !DES-MD5: (at the beginning of a suite)
  call matchadd('insecureSSLProtocol', s:begin . '[^!]\([0-9A-Za-z]\+[+-]\)\+\zs' . a:keyword . '\ze' . s:delimiter)

  " Match :AES128-MD5: and :AES128+MD5: (in the middle of pattern)
  call matchadd('insecureSSLProtocol', ':\([0-9A-Za-z]\+[+-]\)\+\zs' . a:keyword . '\ze' . s:delimiter . '\S')

  " :AES-MD5 or :AES-CBC-MD5 (at the end of suite)
  " Do not allow alpha-numeric characters before s:end, to match '-MD5";' and others properly.
  call matchadd('insecureSSLProtocol', ':\([0-9A-Za-z]\+[+-]\)\+\zs' . a:keyword . '\ze' . '[^0-9A-Za-z]*' . s:end)

  " ^keyword, "keyword, 'keyword
  " Checks for \S at the end, so 'MD5: ' is not highlighted in prose text.
  call matchadd('insecureSSLProtocol', s:begin . '\zs' . a:keyword . '\ze' . s:delimiter . '\S')
endfunction

" Generate patterns to highlight insecure ciphers.
" Reference: https://www.openssl.org/docs/man1.0.2/apps/ciphers.html
"
" Protocol matching condition
let s:protocol = '\v(TLS|tls|SSL|ssl)[A-Za-z0-9\._-]*([Pp]rotocol|[Oo]ption)\m.*'

function s:addmatches() abort
  if exists('w:sslsecure_applied')
    return
  endif

  let w:sslsecure_applied = 1
  call s:genmatch('SSLv3', '', '')
  call s:genmatch('SSLv2', '', '')
  call s:genmatch('HIGH', '', '')
  call s:genmatch('MEDIUM', '', '')
  call s:genmatch('LOW', '', '')
  call s:genmatch('DEFAULT', '', '')
  call s:genmatch('COMPLEMENTOFDEFAULT', '', '')
  call s:genmatch('ALL', '', '')
  call s:genmatch('COMPLEMENTOFALL', '', '')

  " SHA ciphers are only used in HMAC with all known OpenSSL/ LibreSSL cipher suites and MAC
  " usage is still considered safe
  " call s:genmatch('SHA', '\D', '') " Match SHA without matching SHA256+
  " call s:genmatch('SHA1', '', '')
  call s:genmatch('MD5', '', '')
  call s:genmatch('RC2', '', '')
  call s:genmatch('RC4' , '', '')
  call s:genmatch('3DES', '', '')
  call s:genmatch('DES', '', '')
  call s:genmatch('aDSS', '', '')
  call s:genmatch('DSS', '', 'a')
  call s:genmatch('PSK', '', '')
  call s:genmatch('IDEA', '', '')
  call s:genmatch('SEED', '', '')
  call s:genmatch('EXP[0-9A-Za-z]*', '', '')
  call s:genmatch('aGOST[0-9A-Za-z]*', '', '')
  call s:genmatch('kGOST[0-9A-Za-z]*', '', '')
  call s:genmatch('GOST[0-9A-Za-z]*', '', 'ak')
  call s:genmatch('[kae]\?FZA', '', '')
  call s:genmatch('ECB', '', '')
  call s:genmatch('[aes]\?NULL', '', '')

  " Anonymous cipher suites should never be used
  call s:genmatch('anon', '', '')       " Keyword used by e.g. rustls
  call s:genmatch('DH', '[^E]', 'ECa')  " Try to match DH without DHE, EDH, EECDH, etc.
  call s:genmatch('ECDH', '[^E]', 'EA') " Do not match EECDH, ECDHE
  call s:genmatch('ADH', '', '')
  call s:genmatch('kDHE', '', '')
  call s:genmatch('kEDH', '', '')
  call s:genmatch('kECDHE', '', '')
  call s:genmatch('kEECDH', '', '')
  call s:genmatch('AECDH', '', '[^E]')

  " Check for insecure protocols after keywords that could specify TLS/ SSL protocols
  call matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv2')
  call matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv3')

  " Golang uses `MinVersion: tls.VersionSSL30`
  call matchadd('insecureSSLProtocol', 'tls\.\zsVersionSSL30')

  " HAProxy bind option
  call matchadd('insecureSSLProtocol', s:protocol . '\zsforce-sslv3')

  " TLSv1 is vulnerable to the BEAST attack. Should be disabled if possible.
  " TODO: TLSv1.0 is not matched yet
  " call matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cTLSv1\ze[^\.]')
endfunction

" Put all autocmd statements into an augroup
augroup sslsecure
  autocmd!
  autocmd BufWinEnter * call s:addmatches()
augroup END

" Highlight both groups as errors
hi link insecureSSLCipher Error
hi link insecureSSLProtocol Error
