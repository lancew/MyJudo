use v6.c;
use Test;

use lib 'lib';
use Judo;

subtest {
    my %waza = Judo.waza;

    subtest {
        is %waza<nage-waza>.keys.sort,
            'ashi-waza kanji koshi-waza ma-sutemi-waza te-waza yoko-sutemi-waza',
            'All Nage waza keys present';

        subtest {
            is %waza<nage-waza><te-waza>.keys.sort,
            'ippon-seoi-nage kata-guruma kibisu-gaeshi ko-uchi-gaeshi kuchiki-taoshi morote-gari obi-otoshi obi-tori-gaeshi seoi-nage seoi-otoshi sukui-nage sumi-otoshi tai-otoshi uchi-mata-sukashi uki-otoshi yama-arashi',
            'All Te-Waza techniques present';
            done-testing;
        }, 'te-waza';

        subtest {
            is %waza<nage-waza><koshi-waza>.keys.sort,
            'hane-goshi harai-goshi koshi-guruma o-goshi sode-tsurikomi-goshi tsuri-goshi tsurikomi-goshi uki-goshi ushiro-goshi utsuri-goshi',
            'All Koshi-Waza techniques present';
            done-testing;
        }, 'koshi-waza';

        subtest {
            is %waza<nage-waza><ashi-waza>.keys.sort,
            'ashi-guruma de-ashi-harai hane-goshi-gaeshi harai-goshi-gaeshi harai-tsurikomi-ashi hiza-guruma ko-soto-gake ko-soto-gari ko-uchi-gari o-guruma o-soto-gaeshi o-soto-gari o-soto-guruma o-soto-otoshi o-uchi-gaeshi o-uchi-gari okuri-ashi-harai sasae-tsurikomi-ashi tsubame-gaeshi uchi-mata uchi-mata-gaeshi',
            'All Ashi-Waza techniques present';
            done-testing;
        }, 'ashi-waza';

        done-testing;
    }

    done-testing;
}, 'waza()';

done-testing;
