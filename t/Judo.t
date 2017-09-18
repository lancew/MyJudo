use v6.c;
use Test;

use lib 'lib';
use Judo;

subtest {
    my %waza = Judo.waza;
    subtest {
        is %waza<nage-waza>.keys,
            'kanji te-waza',
            'All Nage waza keys present';

        subtest {
            is %waza<nage-waza><te-waza>.keys,
            'seoi-otoshi kibisu-gaeshi morote-gari sumi-otoshi uki-otoshi tai-otoshi ko-uchi-gaeshi obi-tori-gaeshi seoi-nage uchi-mata-sukashi kuchiki-taoshi obi-otoshi yama-arashi sukui-nage ippon-seoi-nage kata-guruma',
            'All Te-Waza techniques present';
            done-testing;
        }, 'te-waza';

        done-testing;
    }

    done-testing;
}, 'waza()';

done-testing;