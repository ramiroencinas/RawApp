# RawApp
[![Build Status](https://travis-ci.org/ramiroencinas/rawapp.svg?branch=master)](https://travis-ci.org/ramiroencinas/rawapp)

A Raku concurrent web application module

## Features:

- Public folder to host front-end structure (html, js, css and text based files).
- Routes with the corresponding webservices using Raku Modules.
- GET and POST HTTP methods.
- 200, 400, 404, 413 and 500 HTTP status response codes.
- Concurrent tranfers with IO::Socket::Async Class.
- SSL support with IO::Socket::Async::SSL (See SSL Notes below)

## Required Raku modules:

- URI
- IO::Socket::Async::SSL (for SSL support)

## Example:
(Go to demo folder for a full example)
```raku
use lib '../lib';
use RawApp;

use lib 'webservices';
use Webservices;

%*ENV{'RAKUDO_MAX_THREADS'} = 50;

my $server-ip = "0.0.0.0";
my $server-port = 3000;
my $default-html = "index.html";

my %webservices;
# key = route, value = ( corresponding sub of the Webservices module, content-type )
%webservices{'/ws1'}        = ( &ws1, 'html' );
%webservices{'/ws2'}        = ( &ws2, 'json' );
%webservices{'/ws-fileops'} = ( &ws-fileops, 'html' );

rawapp(:$server-ip, :$server-port, :$default-html, :%webservices);
```

## How to use

- Creates a folder to hold the web solution and within it...
- Creates `public` and `webservices` folders.
- Creates the main server Raku script like the example above, and name it: `rawapp.raku` (for example).
- In `rawapp.raku`:
  - Set the max number of threads in `%*ENV{'RAKUDO_MAX_THREADS'}`
  - Set `$server-ip` and `$server-port` variables like the example.
  - Set `$default-html` variable with the name of the default html file located in the `/public` folder.
  - Creates a hash ( %webservices in the example ). This hash will contain the webservices, one per hash item. Each item of this hash will contain the webservice route ( /ws1 in the example ) as the key. The corresponding value will contain a list of two values:
    - The reference to the corresponding subrutine ( &ws1 in the example ). Each subrutine reference must have its corresponding subrutine in the `/webservices/Webservices.rakumod` module.
    - The content type of the corresponding subroutine return. The content type can be any of those that are found as key in the hash of the /lib/ContentType.rakumod module.

- Use the `/public` folder to host the front-end structure (html, js, css, etc.)
- Use the `/webservices/Webservices.rakumod` module to write your webservices (a subrutine per webservice).

- Run with: `raku rawapp.raku`
- Run web-client in http://localhost:3000
- Enjoy!

## SSL Notes

For now only works on systems where openssl can be installed (like Linux).   
In the `demo` folder, type:

`openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt`

to auto generate `server.crt` and `server.key` files.
 
Then:
- Take a look at `/demo/rawapp-ssl.raku`
- Try running `raku rawapp-ssl.raku`
- Run web-client in https://localhost:4433
- Confirm SSL exception.
- Enjoy encrypted transfers!
