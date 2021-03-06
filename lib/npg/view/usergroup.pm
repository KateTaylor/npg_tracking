#########
# Author:        rmp
# Maintainer:    $Author: gq1 $
# Created:       2007-11-09
# Last Modified: $Date: 2010-05-04 15:28:42 +0100 (Tue, 04 May 2010) $
# Id:            $Id: usergroup.pm 9207 2010-05-04 14:28:42Z gq1 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg/view/usergroup.pm $
#
package npg::view::usergroup;
use strict;
use warnings;
use base qw(npg::view);

use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$LastChangedRevision: 9207 $ =~ /(\d+)/smx; $r; };

sub new {
  my ($class, @args) = @_;
  my $self  = $class->SUPER::new(@args);
  my $model = $self->model();
  my $id    = $model->id_usergroup();

  if($id && $id !~ /^\d+$/smx) {
    $model->groupname($id);
    $model->id_usergroup(0);
    $model->init();
  }

  return $self;
}

1;

__END__

=head1 NAME

npg::view::usergroup

=head1 VERSION

$LastChangedRevision: 9207 $

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 new - handling for groups-by-group name

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

strict
warnings
base
npg::view

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Roger Pettett, E<lt>rmp@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2007 GRL, by Roger Pettett

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
