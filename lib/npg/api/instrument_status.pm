#########
# Author:        rmp
# Maintainer:    $Author: mg8 $
# Created:       2007-03-28
# Last Modified: $Date: 2012-03-01 10:36:10 +0000 (Thu, 01 Mar 2012) $
# Id:            $Id: instrument_status.pm 15277 2012-03-01 10:36:10Z mg8 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg/api/instrument_status.pm $
#
package npg::api::instrument_status;
use strict;
use warnings;
use base qw(npg::api::base);
use Carp;
use English qw{-no_match_vars};
use npg::api::instrument;
use Readonly;

Readonly::Scalar our $VERSION => do { my ($r) = q$LastChangedRevision: 15277 $ =~ /(\d+)/mxs; $r; };

__PACKAGE__->mk_accessors(fields(), 'name');
__PACKAGE__->hasa(qw(instrument));

sub fields {
  return qw(id_instrument_status id_instrument date id_instrument_status_dict id_user iscurrent description comment);
}

sub uptimes {
  my ($self) = @_;
  if (!$self->{uptimes}) {
    my $util       = $self->util();
    my $pkg        = ref $self;
    my ($obj_type) = ($pkg) =~ /([^:]+)$/smx;
    my $obj_uri    = sprintf '%s/%s/up/down.xml', $util->base_uri(), $obj_type;

    my $xml_obj  = $util->parser->parse_string($util->get($obj_uri,[]));
    my @instruments = $xml_obj->getElementsByTagName('instrument');

    foreach my $i (@instruments) {
      my $temp = { name => $i->getAttribute('name'), statuses => [] };
      my @statuses = $i->getElementsByTagName('status');
      foreach my $s (@{$i->getElementsByTagName('instrument_status')}) {
        push @{$temp->{statuses}}, {
          date => $s->getAttribute('date'),
          description => $s->getAttribute('description'),
        };
      }
      $i = $temp;
    }
    $self->{uptimes} = \@instruments;
  }
  return $self->{uptimes};
}

1;
__END__

=head1 NAME

npg::api::instrument_status - An interface onto npg.instrument_status

=head1 VERSION

$LastChangedRevision: 15277 $

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 new - constructor inherited from npg::api::base

  Takes optional util.

  my $oInstrumentStatus = npg::api::instrument_status->new();

  my $oInstrumentStatus = npg::api::instrument_status->new({
    'id_instrument_status' => $iIdInstrumentStatus,
    'util'          => $oUtil,
  });


  my $oInstrumentStatus = npg::api::instrument_status->new({
    'id_instrument'             => $iIdInstrument,
    'id_instrument_status_dict' => $iIdInstrumentStatus,
   #'date', 'id_user' and 'iscurrent' are omitted for creation as the web application sets them
  });
  $oInstrumentStatus->create();

=head2 fields - accessors for this table/class

  my @aFields = $oPkg->fields();
  my @aFields = npg::api::<pkg>->fields();

=head2 id_instrument_status - Get/set accessor: primary key of this object

  my $iIdInstrumentStatus = $oInstrumentStatus->id_instrument_status();
  $oInstrumentStatus->id_instrument_status($i);

=head2 id_instrument - Get/set accessor: ID of the instrument to which this status belongs

  my $iIdInstrument = $oInstrumentStatus->id_instrument();
  $oInstrumentStatus->id_instrument($i);

=head2 date - Get/set accessor: date of this status

  my $sDate = $oInstrumentStatus->date();
  $oInstrumentStatus->date($s);

=head2 id_instrument_status_dict - Get/set accessor: dictionary type ID of this status

  my $iIdInstrumentStatusDict = $oInstrumentStatus->id_instrument_status_dict();
  $oInstrumentStatus->id_instrument_status_dict($i);

=head2 id_user - Get/set accessor: user ID of the operator for this status

  my $iIdUser = $oInstrumentStatus->id_user();
  $oInstrumentStatus->id_user($i);

=head2 iscurrent - Get accessor: whether or not this status is current for its instrument

  my $bIsCurrent = $oInstrumentStatus->iscurrent();
  $oInstrumentStatus->iscurrent($b);

=head2 comment - Get accessor: the comment of this status from its dictionary type ID

  my $sComment = $oInstrumentStatus->comment();

=head2 instrument - npg::api::instrument to which this status belongs

  my $oInstrument = $oInstrumentStatus->instrument();

=head2 uptimes - get accessor to return an arrayref of instruments, each of which is a has object containing the name and an arrayref of up/down statuses, fetched via XML from NPG web service

  my $aInstruments = $oInstrumentStatus->uptimes();

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

npg::api::base

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Roger Pettett, E<lt>rmp@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2007 GRL, by Roger Pettett

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
