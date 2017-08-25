use v6.c;
use Test;

use lib 'lib';
use MyJudo;


is-deeply MyJudo.get_user_data(user_name => 'lancew'), 
{
     first_session => Date.new('2015-12-24').Date,
            hours     => 122,
            latest_session => Date.new('2016-12-24').Date,
            sessions  => 22,
            techniques => [
                { name => 'Seoi Nage', sessions => '10'},
                { name => 'Taio Toshi', sessions => '9'},
                { name => 'O Soto Gari', sessions => '8'},
                { name => 'Yoko Shiho Gatame', sessions => '55'},
            ],
            user_name => 'lancew',
}, 'get_user_data() - Returned correct user details';

done-testing;