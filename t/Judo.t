use Test;
use lib q{.};
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

subtest {
    my %flat = Judo.flattened_waza;

    is %flat<seoi-nage><kanji>, '背負投', 'flattened lookup finds seoi-nage';
    is %flat<ude-hishigi-ashi-gatame><kanji>, '腕挫脚固', 'flattened lookup finds ude-hishigi-ashi-gatame';
    is %flat<do-jime><kanji>, '胴絞', 'flattened lookup finds do-jime';
    nok %flat<kanji>, 'flattened lookup does not contain kanji keys';
    nok %flat<non-existent-technique>, 'missing technique is not found';
    done-testing;
}, 'flattened_waza()';

subtest {
    is Judo.kanji_for('seoi-nage'), '背負投', 'kanji_for finds seoi-nage';
    is Judo.kanji_for('do-jime'), '胴絞', 'kanji_for finds do-jime';
    is Judo.kanji_for('non-existent'), '', 'kanji_for returns empty string for unknown technique';
    done-testing;
}, 'kanji_for()';

subtest {
    my @types = Judo.training_types;
    is @types.elems, 5, 'training_types returns 5 types';
    ok @types.grep('randori-tachi-waza'), 'contains randori-tachi-waza';
    ok @types.grep('randori-ne-waza'), 'contains randori-ne-waza';
    ok @types.grep('uchi-komi'), 'contains uchi-komi';
    ok @types.grep('nage-komi'), 'contains nage-komi';
    ok @types.grep('kata'), 'contains kata';
    done-testing;
}, 'training_types()';

done-testing;