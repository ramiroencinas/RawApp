unit module RaWapp;

use Configuration;
use Response;

sub rawapp(:$server-ip, :$server-port, :$default-html, :%webservices) is export {

  # check default-public-file
  my $current-html-file-path = "$current-dir/public/$default-html";
  if !($current-html-file-path).IO.e { die "Default public file not found: $current-html-file-path"; }

  # concurrent loop for listen, incoming processing and response
  react {
    say "\nListening in $server-ip:$server-port...";
    # creates listening socket and return $conn as a Supply
    whenever IO::Socket::Async.listen($server-ip,$server-port) -> $conn {
      # when a TCP stream arrives at the $conn Supply,
      # it converts it in binary format (blob) with the :bin named parameter
      whenever $conn.Supply(:bin) -> $buf {
        my $peerip = $conn.peer-host;
        my $response = response(:$peerip, :$buf, :$current-dir, :$default-html, :%webservices);
          await $conn.write: $response.encode('UTF-8'); # await waits to write all the packets and .encode returns binary format (blob)
          $conn.close;  
      }
    }
  }
}

sub rawapp-ssl(:$server-ip, :$server-port, :$default-html, :%webservices, :%ssl-config) is export {

  use IO::Socket::Async::SSL;

  # check default-public-file
  my $current-html-file-path = "$current-dir/public/$default-html";
  if !($current-html-file-path).IO.e { die "Default public file not found: $current-html-file-path"; }

  # concurrent loop for listen, incoming processing and response
  react {
    say "\nListening in $server-ip:$server-port...";
    # creates listening socket and return $conn as a Supply
    whenever IO::Socket::Async::SSL.listen($server-ip,$server-port, |%ssl-config) -> $conn {
      # when a TCP stream arrives at the $conn Supply,
      # it converts it in binary format (blob) with the :bin named parameter
      whenever $conn.Supply(:bin) -> $buf {
        my $peerip = $conn.peer-host;
        my $response = response(:$peerip, :$buf, :$current-dir, :$default-html, :%webservices);
        $conn.write: $response.encode('UTF-8'); # .encode returns binary format (blob)
        $conn.close;
      }
    }
  }
}
