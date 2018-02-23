use v6.c;
use Test;

use lib 'lib';
use DBIish;
use MyJudo;

my $mj = MyJudo.new(
    dbh => DBIish.connect("SQLite", :database<db/test.db>)
);

subtest {
    _clean_tables;
    $mj.add_new_user(
        user_name => 'test',
        password  => 'secret',
        email     => 'test@test.com',
    );

    my $sth = $mj.dbh.prepare('SELECT id,username,email from users');
    $sth.execute;
    my %user = $sth.row(:hash);

    is-deeply %user, {
        id => 1,
        username => 'test',
        email => 'test@test.com',
    }, 'New user is added';

    done-testing;
}, 'add_new_user';

subtest {
    _clean_tables;

    $mj.add_sensei(
        family_name => 'last',
        given_name  => 'first',
    );

    my $sth = $mj.dbh.prepare('SELECT * from sensei');
    $sth.execute;
    my %sensei = $sth.row(:hash);

    is-deeply %sensei, {
        family_name => 'Last',
            given_name  => 'First',
            id          => 1,
            their_sensei => Any,
    }, 'Sensei record is correct';
    done-testing;
}, 'add_sensei';

todo '';    subtest { done-testing; }, 'get_admin_dashboard_data';

subtest {
    _clean_tables;

    $mj.add_sensei(
        family_name => 'last',
        given_name  => 'first',
    );

    my %sensei = $mj.get_sensei_by_name(family_name => 'last', given_name => 'first');
    is-deeply %sensei, {
        family_name => 'Last',
            given_name  => 'First',
            id          => 1,
            their_sensei => Any,
    }, 'Sensei record is correct';

    done-testing;
}, 'get_sensei_by_name';

subtest {
    _clean_tables;

    $mj.add_new_user(
        user_name => 'jane_bloggs',
        password  => 'secret',
        email     => 'test@test.com',
    );

    my $dt = Date.new(DateTime.now);
    my $now = $dt.Str;
    my $month = $dt.truncated-to('month').earlier(month => 1).Str;
    my $month2 = $dt.truncated-to('month').earlier(month => 2).Str;
    my $month3 = $dt.truncated-to('month').earlier(month => 3).Str;
    my $years2 = $dt.truncated-to('month').earlier(year => 2).Str;

    _add_training_sessions();

    my @sessions = $mj.get_training_sessions(user_id => 1);

    is-deeply @sessions, [
        {:date($now),:id(1),:techniques("tai-otoshi,seoi-nage"),:types('ne-waza-randori'),:user_id(1)},
        {:date($month),:id(2),:techniques("tai-otoshi,obi-otoshi"),:types('ne-waza-randori'),:user_id(1)},
    #    {:date($month2),:id(3),:techniques("tai-otoshi,uki-otoshi"),:types('ne-waza-randori'),:user_id(1)},
    #    {:date($month3),:id(4),:techniques("tai-otoshi,ura-gatame"),:types('ne-waza-randori'),:user_id(1)},
        {:date($years2),:id(3),:techniques("tai-otoshi,ashi-garami"),:types('ne-waza-randori'),:user_id(1)},
    ], 'Sessions returned are correct';

done-testing;
}, 'get_training_sessions';

subtest {
    _clean_tables;
    $mj.add_new_user(
        user_name => 'jbloggs',
        password  => 'secret_pasword',
    );

    _add_training_sessions();

    my %data = $mj.get_user_data(user_name => 'jbloggs');

    is-deeply %data, {
        id => 1,
        sessions => 3,
        sessions_this_month => 1,
        sessions_last_month => 1,
        sessions_this_year  => 2,
        techniques          => {
            :ashi-garami(1),
            :obi-otoshi(1),
            :seoi-nage(1),
            :tai-otoshi(3),
         #   :uki-otoshi(1),
         #   :ura-gatame(1),
        },
        techniques_this_month => {
            :seoi-nage(1),
            :tai-otoshi(1),
        },
        techniques_last_month => {
            :obi-otoshi(1),
            :tai-otoshi(1),
        },
        techniques_this_year  => {
            :obi-otoshi(1),
            :seoi-nage(1),
            :tai-otoshi(2),
        #    :uki-otoshi(1),
        #    :ura-gatame(1),
        },
        user_name             => 'jbloggs',
    }, 'User data is correct';

        done-testing;
}, 'get_user_data';

subtest {
    _clean_tables;

    $mj.add_new_user(
        user_name => 'user1',
        password  => 'secret_pasword',
    );
    $mj.add_sensei(
        family_name => 'last',
        given_name  => 'first',
    );

    nok $mj.is_user_linked_to_sensei(
        user_id => 1,
            sensei_id => 1,
    ), 'Sensei not shown as linked';

        $mj.link_user_to_sensei(
        user_id => 1,
            sensei_id => 1,
    );

    ok $mj.is_user_linked_to_sensei(
        user_id => 1,
            sensei_id => 1,
    ), 'Sensei is shown as linked after being linked';

    done-testing;
}, 'is_user_linked_to_sensei';

subtest {
    _clean_tables;

    nok $mj.is_username_taken(user_name => 'user1'), 'Username does not exist before being inserted';

    $mj.add_new_user(
        user_name => 'user1',
        password  => 'secret_pasword',
    );

    ok $mj.is_username_taken(user_name => 'user1'), 'Username exists after being inserted';
    done-testing;
}, 'is_username_taken';

subtest {
    _clean_tables;

    $mj.add_new_user(
        user_name => 'jbloggs2',
        password  => 'secret_pasword',
    );
    my %user = $mj.get_user_data(user_name => 'jbloggs2');

    $mj.add_sensei(
        family_name => 'Smith',
            given_name  => 'John',
    );
    my %sensei = $mj.get_sensei_by_name(family_name => 'Smith', given_name => 'John' );

    $mj.link_user_to_sensei(
        user_id => 1,
        sensei_id => 1,
    );

    my %data = $mj.get_user_data(user_name => 'jbloggs2');

    is-deeply %data, {
        id => 1,
        sessions => 0,
        sessions_this_month => 0,
        sessions_last_month => 0,
        sessions_this_year  => 0,
    #    techniques          => {},
    #    techniques_this_month => {},
    #    techniques_last_month => {},
    #    techniques_this_year  => {},
        user_name             => 'jbloggs2',
    }, 'User data is correct';

    done-testing;
}, 'link_user_to_sensei';

subtest {
    _clean_tables;

    $mj.training_session_add(
        date => '2017-12-12',
        user_id => 1,
        techniques => 'tai-otoshi,seoi-nage',
        training_types => 'ne-waza-randori',
    );

    my $sth = $mj.dbh.prepare('SELECT * FROM sessions');
    $sth.execute;
    my @sessions = $sth.allrows(:array);

    is-deeply @sessions, [[1,"2017-12-12",1,"tai-otoshi,seoi-nage","ne-waza-randori"],], 'Session is added';

    done-testing;
}, 'training_session_add';

subtest {
    _clean_tables;
    $mj.add_new_user(
        user_name => 'test_user',
        password  => 'secret',
    );

    $mj.dbh.do("INSERT INTO sessions
                  (date, user_id, techniques)
                  VALUES ('2017-01-01',1,'')");

    ok $mj.training_session_exists( user_id => 1, date => '2017-01-01'), 'Return true if session is on this day for this user';
    nok $mj.training_session_exists( user_id => 1, date => '2017-12-12'), 'Return false if session is on this day for this user';

    done-testing;
}, 'training_session_exists';


subtest {
    _clean_tables;

    $mj.add_new_user(
        user_name => 'tester',
        password  => 'abc123',
        email     => 'test@test.com',
    );

    nok $mj.valid_user_credentials(
        user_name => 'tester',
        password  => 'abcdefg',
    ), 'Incorrect password returns false as expected';

    ok $mj.valid_user_credentials(
        user_name => 'tester',
        password  => 'abc123',
    ), 'Correct password returns true as expected';

    ok $mj.valid_user_credentials(
        user_name => 'test@test.com',
        password  => 'abc123',
    ), 'Correct password returns true as expected';

    done-testing;
}, 'valid_user_credentials';


done-testing;

sub _clean_tables {
    $mj.dbh.do('DELETE FROM users;');
    $mj.dbh.do('DELETE FROM sensei;');
    $mj.dbh.do('DELETE FROM sensei_sensei;');
    $mj.dbh.do('DELETE FROM sessions;');
    $mj.dbh.do('DELETE FROM users_sensei;');
}

sub _add_training_sessions {
    my $dt = Date.new(DateTime.now);
    my $now = $dt.Str;
    my $month = $dt.truncated-to('month').earlier(month => 1).Str;
    my $month2 = $dt.truncated-to('month').earlier(month => 2).Str;
    my $month3 = $dt.truncated-to('month').earlier(month => 3).Str;
    my $years2 = $dt.truncated-to('month').earlier(year => 2).Str;

    $mj.training_session_add(
        date => $now,
        user_id => 1,
        techniques => 'tai-otoshi,seoi-nage',
        training_types => 'ne-waza-randori',
    );
    $mj.training_session_add(
        date => $month,
        user_id => 1,
        techniques => 'tai-otoshi,obi-otoshi',
        training_types => 'ne-waza-randori',
    );
#    $mj.training_session_add(
#        date => $month2,
#        user_id => 1,
#        techniques => 'tai-otoshi,uki-otoshi',
#        training_types => 'ne-waza-randori',
#    );
#    $mj.training_session_add(
#        date => $month3,
#        user_id => 1,
#        techniques => 'tai-otoshi,ura-gatame',
#        training_types => 'ne-waza-randori',
#    );
    $mj.training_session_add(
        date => $years2,
        user_id => 1,
        techniques => 'tai-otoshi,ashi-garami',
        training_types => 'ne-waza-randori',
    );
}
