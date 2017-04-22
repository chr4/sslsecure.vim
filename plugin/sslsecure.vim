" Author: Chris Aumann <me@chr4.org>
" Version: 1.0.0
" Description: Plugin that marks insecure SSL/TLS cipher-suites and protocol options as errors.

if exists('g:loaded_sslsecure')
  finish
endif
let g:loaded_sslsecure = 1


" Try to detect cipher suite strings.
" 1. Open bracket to match keywords with both, pre- and appended delimiters
" 2. Look for one of those delimiters: :_-
"    When the keyword follows the delimiter directly, this means it can't be negated with an !
" 3. When found, highlight the keyword in the next pattern
let s:pre = '\([:_-]\zs'

" Sometimes it's necessary to add additional conditions to describe a keyword's end-pattern.
" The end-of-pattern function ends highlighting of the keyword, but makes sure either end-of-line or
" a special pattern follows the keyword.
"
" Example:
" Make sure that the SHA keyword only triggers when a non-digit follows.
" This prevents highlighting of more secure SHA ciphers like SHA256 or SHA512
"
"     s:genmatch('SHA', '\D', '')
fun! s:eop(pattern)
  " If no pattern is given, just return an empty string
  if empty(a:pattern)
    return '\ze'
  endif

  return '\ze\(' . a:pattern . '\|$\)'
endfun

" Cipher suites are detected if a keyword either has a prepended or appended delimiter.
" To match both cases, we need to construct a (:xxx|xxx:) matching pattern.
" The mid() function generates those.
"
" 1. Seperate the :xxx and xxx: pattern using a |
" 2. Do not highlight when keyword is negated with a !
" 3. Do not highlight keyword at the beginning of line, so prose like this is unaffected:
"    "SHA: An insecure cipher."
" 4. Start highlighting the next keyword
"
" In some cases, it's necessary to exclude certian matches on the xxx: side of the pattern.
"
" Example:
" Ensure that the DES within !3DES isn't highlighted
"
"     s:genmatch('3DES', '', '')
"     s:genmatch('DES', '', '3')
fun! s:mid(exclude)
  return '\|\([^!' . a:exclude . ']\|^\)\zs'
endfun

" 1. Look for a keyword that ends with one of these delimiters :_-
" 2. End highlighting.
" 3. Cipher suites never end with a delimiter, therefore make sure a non-whitespace character follows
" 4. Close the bracket to match keywords with both, pre- and appended delimiters
let s:post = '\ze[:_-]\S\)'


" This function highlights a keyword according to the rules specified above
function s:genmatch(keyword, eop, mid)
  " Simplified version of the generated pattern: (:keyword|keyword:)
  call matchadd('insecureSSLProtocol', s:pre . a:keyword . s:eop(a:eop) . s:mid(a:mid) . a:keyword . s:post)
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
autocmd BufWinEnter * call s:genmatch('EXP\w*', '', '')
autocmd BufWinEnter * call s:genmatch('aGOST\w*', '', '')
autocmd BufWinEnter * call s:genmatch('kGOST\w*', '', '')
autocmd BufWinEnter * call s:genmatch('GOST\w*', '', 'ak')
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
" TODO: -SSLv3 is highlighted from insecureSSLCipher rules above (Apache notation)
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv2')
autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cSSlv3')

" TLSv1 is vulnerable to the BEAST attack. Should be disabled if possible.
" TODO: TLSv1.0 is not matched yet
" autocmd BufWinEnter * let w:insecureSSLProtocol=matchadd('insecureSSLProtocol', s:protocol . '[^!-]\zs\cTLSv1\ze[^\.]')


" Highlight both groups as errors
hi link insecureSSLCipher Error
hi link insecureSSLProtocol Error
