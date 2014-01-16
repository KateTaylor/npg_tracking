#########
# Author:        kt6
# Last Modified: $Date: $
# Id:            $Id: $
# Source:        $Source: $
# $HeadURL: $
#

use strict;
use warnings;
use Perl::Critic;
use Perl::Tidy;
use Test::More;
use English qw(-no_match_vars);

if ( !$ENV{TEST_AUTHOR} ) {
  my $msg = 'Author test.  Set $ENV{TEST_AUTHOR} to a true value to run.';
  plan( skip_all => $msg );
}

eval { require Perl::Tidy; };

if ($EVAL_ERROR) {
  plan skip_all => 'Perl::Tidy not installed';
}
else {
  my @files = grep { $_ !~ /npg_tracking\/Schema/ && $_ !~ /Monitor/ }
    Perl::Critic::Utils::all_perl_files( 'lib' );

  my $std_error_str;
  foreach my $file ( sort @files ) {
    my $ret = Perl::Tidy::perltidy( argv => "-pbp -nst -i=2 -b $file", stderr => \$std_error_str,);
    my $error = defined $ret ? $ret : 0;
    is($error, 0, "file $file tidied");

      # perl 5.14.2 tidy sometimes adds a space at the end for the line when splitting lines
      # use this fix until lenny is completely gone for development

      system("sed -i 's/ \$//' $file");     
  }

  done_testing( scalar @files );
}

1;
