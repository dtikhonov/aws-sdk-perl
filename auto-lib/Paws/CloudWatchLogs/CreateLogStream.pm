
package Paws::CloudWatchLogs::CreateLogStream {
  use Moose;
  has logGroupName => (is => 'ro', isa => 'Str', required => 1);
  has logStreamName => (is => 'ro', isa => 'Str', required => 1);

  use MooseX::ClassAttribute;

  class_has _api_call => (isa => 'Str', is => 'ro', default => 'CreateLogStream');
  class_has _returns => (isa => 'Str', is => 'ro');
  class_has _result_key => (isa => 'Str', is => 'ro');
}
1;