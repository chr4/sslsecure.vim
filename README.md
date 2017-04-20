# sslsecure.vim

## Description

Plugin for the [Vim](http://www.vim.org/) editor, that marks insecure SSL/TLS cipher suites and protocol as errors.

When configuring or programming SSL/TLS servers, at some point a SSL/TLS cipher suite and a list of supported protocols have to be chosen.

Unfortunately, not all configuration options are safe. :(

**This plugin highlights insecure SSL/TLS options as errors right in your editor!**


## Features

- Mark insecure SSL ciphers as errors
- Mark insecure SSL protocols as errors
- Works with all configuration files (web servers, mail servers, ...)
- Works with all source code (independently on the used programming language)
- Works on top of regular syntax highlighting


## Screenshots

Note: DO NOT USE the displayed ciphers. They are insecure and might not even work - the purpose is to show off the highlighting options of this plugin.

### Web Servers
nginx
![nginx](https://chr4.org/images/sslsecure_nginx.png)

Apache2
![Apache2](https://chr4.org/images/sslsecure_apache.png)

Lighttpd
![Lighttpd](https://chr4.org/images/sslsecure_lighttpd.png)

### Mail Servers
Postfix
![Postfix](https://chr4.org/images/sslsecure_postfix.png)

Exim
![Exim](https://chr4.org/images/sslsecure_exim.png)

Dovecot
![Dovecot](https://chr4.org/images/sslsecure_dovecot.png)

### Load Balancers
HAProxy
![HAProxy](https://chr4.org/images/sslsecure_haproxy.png)

### FTP Servers
ProFTPd
![ProFTPd](https://chr4.org/images/sslsecure_proftpd.png)

### Databases
PostgreSQL
![PostgreSQL](https://chr4.org/images/sslsecure_postgresql.png)

MySQL
![MySQL](https://chr4.org/images/sslsecure_mysql.png)

### Programming languages
C
![C](https://chr4.org/images/sslsecure_c.png)

Go
![Go](https://chr4.org/images/sslsecure_go.png)

Rust (CipherSuites from [Rustls](https://github.com/ctz/rustls/blob/master/src/msgs/enums.rs#L982))
![Rust](https://chr4.org/images/sslsecure_rust.png)

Java
![Java](https://chr4.org/images/sslsecure_java.png)


## Feedback

I'm neither a mathematician, nor a cryptographer. If you are one and you have feedback to this plugin, find a flaw, please open an [issue](https://github.com/chr4/sslsecure.vim/issues).


## References

- [Blog post](https://chr4.org/blog/2017/04/27/sslsecure-dot-vim/) to introducing this plugin, with further information.


## Installation

Just plug it into your favorite Vim package manager:

```vim
" Plug
Plug 'chr4/sslsecure.vim

" Dein.vim
call dein#add('chr4/sslsecure.vim')

" Vundle
Plugin 'chr4/sslsecure.vim'
```
