#########
# Author:        rmp
# Maintainer:    $Author: gq1 $
# Created:       2007-03-28
# Last Modified: $Date: 2010-05-04 15:28:42 +0100 (Tue, 04 May 2010) $
# Id:            $Id: instrument_annotation.pm 9207 2010-05-04 14:28:42Z gq1 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg/view/instrument_annotation.pm $
#
package npg::view::instrument_annotation;
use base qw(npg::view::annotation);
use strict;
use warnings;
use File::Type;
use English qw(-no_match_vars);
use Carp;
use npg::model::instrument_annotation;

use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$LastChangedRevision: 9207 $ =~ /(\d+)/smx; $r; };

sub add_ajax {
  my $self    = shift;
  my $cgi     = $self->util->cgi();
  my $model   = $self->model();
  $model->{id_instrument} = $cgi->param('id_instrument');
  return;
}

1;

__END__

=head1 NAME

npg::view::instrument_annotation - view handling for instrument_annotationes

=head1 VERSION

$LastChangedRevision: 9207 $

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 add_ajax - set up id_instrument from CGI block

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item base

=item npg::view::annotation

=item npg::model::instrument_annotation

=item strict

=item warnings

=item File::Type

=item English

=item Carp

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Roger Pettett, E<lt>rmp@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2008 GRL, by Roger Pettett

This file is part of NPG.

NPG is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/ .

=cut
