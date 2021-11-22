unit module WriteLog;

# write live log to terminal
sub write-log (:$peerip?, :$method?, :$path?, :$get-params?, :$body?, :$error?) is export {

  my $response = "\n*Request data:*\nDateTime: " ~ DateTime.now ~ "\n";

  $response ~= $error if $error;

  if $method {
    given $method {
      when $_ eq "GET"  { $response ~= "IP Client: $peerip\nMethod: $method\nPath: $path\nGET params: $get-params\n"; }
      when $_ eq "POST" { $response ~= "IP Client: $peerip\nMethod: $method\nPath: $path\nPOST body: $body\n"; }
    }
  }
  say $response;
}
