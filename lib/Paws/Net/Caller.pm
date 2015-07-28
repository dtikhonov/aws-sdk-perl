package Paws::Net::Caller {
  use Moose;
  use Carp qw(croak);
  with 'Paws::Net::CallerRole';

  has debug              => ( is => 'rw', required => 0, default => sub { 0 } );
  has ua => (is => 'rw', required => 1, lazy => 1,
    default     => sub {
        use LWP::UserAgent;
        my $ua = LWP::UserAgent->new;
        $ua->env_proxy;
        push @{ $ua->requests_redirectable }, 'POST';
        return $ua;
    }
  );

  sub do_call {
    my ($self, $service, $call_object) = @_;

    my $requestObj = $service->prepare_request_for_call($call_object); 

    my $headers = $requestObj->header_hash;
    # HTTP::Tiny derives the Host header from the URL. It's an error to set it.
    delete $headers->{Host};

    my $method = lc $requestObj->method;
    my $response = $self->ua->$method(
      $requestObj->url,
        %$headers,
        (defined $requestObj->content)?(Content => $requestObj->content):(),
    );

    my $res = $service->handle_response($call_object, $response->code, $response->content, $response->headers);
    if (not ref($res)){
      return $res;
    } elsif ($res->isa('Paws::Exception')) {
      $res->throw;
    } else {
      return $res;
    }
  }
}

1;
