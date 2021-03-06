# Author:        Jennifer Liddle <js10@sanger.ac.uk>
# Maintainer:    Jennifer Liddle <js10@sanger.ac.uk>
# Created:       25th February 2014
#
package npg_tracking::data::snv;

use strict;
use warnings;
use Moose;

our $VERSION = do { my ($r) = q$Revision: 16549 $ =~ /(\d+)/smx; $r; };

with qw/
          npg_tracking::glossary::run
          npg_tracking::glossary::lane
          npg_tracking::glossary::tag
          npg_tracking::data::snv::find
       /;

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=head1 NAME

npg_tracking::data::snv

=head1 VERSION

$Revision: 16549 $

=head1 SYNOPSIS

=head1 DESCRIPTION

A wrapper class for finding the location of VCF files.

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item warnings

=item strict

=item Moose

=item npg_tracking::glossary::run

=item npg_tracking::glossary::lane

=item npg_tracking::glossary::tag

=item npg_tracking::data::snv::find

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Author: Jennifer Liddle E<lt>js10@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2014 GRL, by Jennifer Liddle

This file is part of NPG.

NPG is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
