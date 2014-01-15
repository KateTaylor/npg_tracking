#########
# Author:        ajb
# Maintainer:    $Author: ajb $
# Created:       2011-08-15
# Last Modified: $Date: 2011-08-19 10:50:30 +0100 (Fri, 19 Aug 2011) $
# Id:            $Id: cost_code.pm 13963 2011-08-19 09:50:30Z ajb $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg/model/cost_code.pm $
#
package npg::model::cost_code;
use strict;
use warnings;
use English qw(-no_match_vars);
use Carp;
use base qw(npg::model);
use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$LastChangedRevision: 13963 $ =~ /(\d+)/smx; $r; };

use npg::model::cost_group;

__PACKAGE__->mk_accessors( fields() );
__PACKAGE__->has_all();
__PACKAGE__->has_a('cost_group');

sub fields {
  return qw{
      id_cost_code
      cost_code
      id_cost_group
  };
}

sub init {
  my $self = shift;

  if ( !$self->{id_cost_code} && $self->{cost_code} ) {
    my $query = q(SELECT id_cost_code
                  FROM   cost_code
                  WHERE  cost_code = ?);
    my $ref = [];
    eval {
      $ref
          = $self->util->dbh->selectall_arrayref( $query, {},
        $self->cost_code() );
    } or do {
      carp $EVAL_ERROR;
      return;
    };

    if ( @{$ref} ) {
      $self->{id_cost_code} = $ref->[0]->[0];
    }
  }

  return $self;
}

sub groupname {
  my ($self) = @_;
  return $self->cost_group()->name();
}

1;
__END__

=head1 NAME

npg::model::cost_code

=head1 VERSION

$LastChangedRevision: 13963 $

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 fields

list of column names from the database table

=head2 init

enables cost_code to be used to instantiate the object, and retrieves the corresponding id_cost_code

=head2 groupname

returns the name of the cost_group this cost code is for

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item strict

=item warnings

=item English

=item Carp

=item base

=item npg::model

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

$Author: ajb $

=head1 LICENSE AND COPYRIGHT

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
