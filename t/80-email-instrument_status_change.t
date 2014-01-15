# $Id: 80-email-instrument_status_change.t 16269 2012-11-26 09:53:48Z mg8 $
use strict;
use warnings;
use DateTime;
use DateTime::Format::MySQL;
use Perl6::Slurp;
use Test::More tests => 21;
use Test::Deep;
use Test::Exception::LessClever;
use Test::MockModule;

use t::dbic_util;
use t::util;

use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$Revision: 16269 $ =~ /(\d+)/msx; $r; };

local $ENV{dev} = 'test';
my $schema = t::dbic_util->new->test_schema();
my $util   = t::util->new();
$util->catch_email($util);

my $ist = $schema->resultset('InstrumentStatus');
$ist->update( { 'iscurrent' => 0, } );
$ist->populate(
    [
        {
            id_instrument_status      => 50,
            id_instrument             => 8,
            id_instrument_status_dict => 2,
            date                      => '2008-02-25 08:19:04',
            id_user                   => 9,
            comment                   => 'Auto focus failure',
            iscurrent                 => 0,
        },
        {
            id_instrument_status      => 51,
            id_instrument             => 6,
            id_instrument_status_dict => 2,
            date                      => '2008-02-25 08:19:04',
            id_user                   => 9,
            comment                   => undef,
            iscurrent                 => 1,
        },
        {
            id_instrument_status      => 52,
            id_instrument             => 3,
            id_instrument_status_dict => 1,
            date                      => '2008-04-12 08:29:04',
            id_user                   => 9,
            comment                   => undef,
            iscurrent                 => 1,
        },
        {
            id_instrument_status      => 56,
            id_instrument             => 67,
            id_instrument_status_dict => 6,
            date                      => '2010-04-12 09:29:54',
            id_user                   => 9,
            comment                   => undef,
            iscurrent                 => 1,
        },
        {
            id_instrument_status      => 57,
            id_instrument             => 68,
            id_instrument_status_dict => 6,
            date                      => '2010-04-12 09:29:54',
            id_user                   => 9,
            comment                   => undef,
            iscurrent                 => 1,
        },
        {
            id_instrument_status      => 58,
            id_instrument             => 4,
            id_instrument_status_dict => 6,
            date                      => '2010-10-05 11:10:40',
            id_user                   => 9,
            comment                   => undef,
            iscurrent                 => 1,
        }
    ]
);

my @test;

use_ok('npg::email::event::status_change::instrument');

lives_ok {
    $test[0] = npg::email::event::status_change::instrument->new(
        {
            event_row         => $schema->resultset('Event')->find(27),
            schema_connection => $schema,
        }
    );
}
'Can create with event row object';

lives_ok {
    $test[1] = npg::email::event::status_change::instrument->new(
        {
            id_event    => 25,
            _connection => $schema,
        }
    );
}
'Can create with id_event';

throws_ok {
    npg::email::event::status_change::instrument->new(
        {
            event_row         => $schema->resultset('Event')->find(25),
            id_event          => 27,
            schema_connection => $schema,
        }
    );
}
qr{Mismatched event_row and id_event constructor arguments}ms,
  'If both are supplied they must agree';

throws_ok {
    my $fail = npg::email::event::status_change::instrument->new(
        {
            id_event          => 23,
            schema_connection => $schema,
        }
    );
    $fail->entity();
}
qr{Constructor argument is not a npg_tracking::Schema::Result::InstrumentStatus event}ms,
  'Event must be an instrument status event';

like(
    $test[0]->template(),
    qr/instrument_status_change[.]tt2/msx,
    'Template looks right'
);

is( $test[0]->id_event(), 27, 'Return the correct id_event' );
is( $test[0]->entity->id_instrument_status(),
    50, 'Return correct id_instrument_status' );
is( $test[0]->id_instrument(), 8,      'Return correct id_instrument' );
is( $test[0]->name(),          q{IL5}, 'Return correct instrument name' );
is( $test[0]->status_description(), 'down',
    'Return correct description field' );
my $watchers = $test[0]->watchers(q{engineers});
is( $test[0]->watchers(), $watchers, q{watchers cached on this object} );
cmp_bag(
    $watchers,
    [ 'joe_engineer@sanger.ac.uk', ],
    'Return correct list of watchers'
);

isnt( $test[0]->dev(), 'live', '$dev is NOT set to \'live\'' );

my $email_template;
lives_ok { $email_template = $test[0]->compose_email() } 'Compose email works';

my $email =
q{This email was generated from a test as part of the development process of the NPD group. If you are reading this, the test failed as the email should not have 'escaped' and actually have been sent. (Or it was you that was running the test.)

Please ignore the contents below, and apologies for the inconvenience.


Instrument IL5 now has a status of "down" in NPG tracking.

The following comment was added to this status change:

Auto focus failure

You can get more detail about the instrument through NPG:

http://npg.sanger.ac.uk/perl/npg/instrument/IL5

This email was automatically generated by New Pipeline Development monitoring system.
};
my @expected_lines = split /\n/xms, $email;
my @obtained_lines = split /\n/xms, $test[0]->next_email();
is_deeply( \@obtained_lines, \@expected_lines, q{generated email is correct} );

lives_ok {
    $test[0]->run();
}
q{run method ok};

$email = $util->parse_email( $util->{emails}->[0] );
is(
    $email->{subject},
    q{Instrument IL5 is at "down"} . qq{\n},
    q{subject is correct}
);
is(
    $email->{to},
    q{joe_engineer@sanger.ac.uk} . qq{\n},
    q{joe_engineer is the recipient}
);
is( $email->{from}, q{srpipe@sanger.ac.uk} . qq{\n}, q{from is correct} );
@obtained_lines = split /\n/xms, $email->{annotation};
is_deeply( \@obtained_lines, \@expected_lines, q{email body is correct} );

1;
