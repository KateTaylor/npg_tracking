#########
# Author:        gq1
# Maintainer:    $Author: dj3 $
# Created:       2010-06-09
# Last Modified: $Date: 2010-06-18 09:27:18 +0100 (Fri, 18 Jun 2010) $
# Id:            $Id: run_read.pm 9670 2010-06-18 08:27:18Z dj3 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg/model/run_read.pm $
#
package npg::model::run_read;
use strict;
use warnings;
use base qw(npg::model);
use English qw(-no_match_vars);
use Carp;

use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$Revision: 9670 $ =~ /(\d+)/smx; $r; };

__PACKAGE__->mk_accessors(fields());
__PACKAGE__->has_a([qw(run)]);

sub fields {
  return qw(id_run_read
            id_run
            intervention
            read_order
            expected_cycle_count
           );
}

1;
__END__

=head1 NAME

npg::model::run_read

=head1 VERSION

$Revision: 9670 $

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 fields - accessors for this table/class

  my @aFields = $oPkg->fields();
  my @aFields = npg::model::<pkg>->fields();

=head2 run - npg::model::run containing this run_read

  my $oRun = $oRunRead->run();

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item strict

=item warnings

=item base

=item npg::model

=item English

=item Carp

=item npg::model::run

=item Readonly

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Guoying Qi, E<lt>gq1@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2010 GRL, by Guoying Qi

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
