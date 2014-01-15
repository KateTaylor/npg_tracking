#########
# Author:        rmp
# Maintainer:    $Author: gq1 $
# Created:       2007-03-28
# Last Modified: $Date: 2010-05-04 15:28:42 +0100 (Tue, 04 May 2010) $
# Id:            $Id: usergroup.pm 9207 2010-05-04 14:28:42Z gq1 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg/model/usergroup.pm $
#
package npg::model::usergroup;
use strict;
use warnings;
use base qw(npg::model);
use English qw(-no_match_vars);
use Carp;
use npg::model::user;
use npg::model::event_type;

use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$Revision: 9207 $ =~ /(\d+)/smx; $r; };

__PACKAGE__->mk_accessors( fields() );

sub fields { return qw(id_usergroup groupname is_public description); }

sub init {
  my $self = shift;
  if ( $self->{'groupname'}
    && !$self->{'id_usergroup'} )
  {
    my $query = q(SELECT id_usergroup
                  FROM   usergroup
                  WHERE  groupname = ?);
    my $ref = [];
    eval {
      $ref
          = $self->util->dbh->selectall_arrayref( $query, {},
        $self->groupname() );
    } or do {
      carp $EVAL_ERROR;
      return;
    };

    if ( @{$ref} ) {
      $self->{'id_usergroup'} = $ref->[0]->[0];
    }
  }
  return 1;
}

sub usergroups {
  my $self = shift;
  my $ref  = $self->gen_getall();
  return $ref;
}

sub public_usergroups {
  my $self = shift;
  return [ grep { $_->is_public() } @{ $self->usergroups() } ];
}

sub users {
  my ( $self, $users ) = @_;

  if ( !$self->{'users'} ) {
    my $pkg   = 'npg::model::user';
    my $query = q(SELECT id_user
                  FROM   user2usergroup uug
                  WHERE  uug.id_usergroup = ?);
    $self->{'users'}
        = $self->gen_getarray( $pkg, $query, $self->id_usergroup() );
  }

  return $self->{'users'};
}

sub event_types {
  my $self = shift;

  if ( !$self->{'event_types'} ) {
    my $pkg   = q(npg::model::event_type);
    my $query = qq(SELECT @{[join q(, ), map { "et.$_" } $pkg->fields()]}
                   FROM   @{[$pkg->table()]}    et,
                          event_type_subscriber ets
                   WHERE  ets.id_usergroup  = ?
                   AND    ets.id_event_type = et.id_event_type);
    $self->{'event_types'}
        = $self->gen_getarray( $pkg, $query, $self->id_usergroup() );
  }

  return $self->{'event_types'};
}

1;

__END__

=head1 NAME

npg::model::usergroup - data model for user groups

=head1 VERSION

$Revision: 9207 $

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 fields - array of accessor names

  my @aFields = npg::model::usergroup->fields();
  my @aFields = $oUsergroup->fields();

=head2 init - support loading by group name as well as id_usergroup

=head2 public_usergroups - arrayref of npg::model::usergroups where is_public=1

  my $arPublicUsergroups = $oUsergroup->public_usergroups();

=head2 usergroups - arrayref of all npg::model::usergroups

  my $arAllUsergroups = $oUsergroup->usergroups();

=head2 visible

  my $bVisible = $oUsergroup->visible();

=head2 users - arrayref of npg::model::user members of this group

  my $arUsers = $oUsergroup->users();

=head2 event_types - arrayref of npg::model::event_types to which this user group is subscribed

  my $arEventTypes = $oUsergroup->event_types();

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

=item npg::model::user

=item npg::model::event_type

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
