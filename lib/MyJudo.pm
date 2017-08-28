unit class MyJudo;


method get_user_data(:$user_name) {
        my $user := {
            first_session => Date.new('2015-12-24').Date,
            hours     => 122,
            latest_session => Date.new('2016-12-24').Date,
            sessions  => 22,
            techniques => [
                { name => 'Seoi-nage', sessions => '10'},
            ],
            user_name => $user_name,
         }
         return $user;
    }
