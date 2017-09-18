unit class Judo;

method waza () {
    my %waza :=  {
        kanji => '技',
        nage-waza => {
            kanji => '投技',
                te-waza => {
                    seoi-nage => {
                        number => 1,
                        name => 'Seoi-nage',
                        kanji => '背負投',
                    },
                    ippon-seoi-nage => {
                        number => 2,
                        name => 'Ippon-seoi-nage',
                        kanji => '一本背負投',
                    },
                    seoi-otoshi => {
                        number => 3,
                        name => 'Seoi-otoshi',
                        kanji => '背負落',
                    },
                    tai-otoshi => {
                        number => 4,
                        name => 'Tai-otoshi',
                        kanji => '体落',
                    },
                    kata-guruma => {
                        number => 5,
                        name => 'Kata-guruma',
                        kanji => '肩車',
                    },
                    sukui-nage => {
                        number => 6,
                        name => 'Sukui-nage',
                        kanji => '掬投',
                    },
                    obi-otoshi => {
                        number => 7,
                        name => 'Obi-otoshi',
                        kanji => '帯落',
                    },
                    uki-otoshi => {
                        number => 8,
                        name => 'Uki-otoshi',
                        kanji => '浮落',
                    },
                    sumi-otoshi => {
                        number => 9,
                        name => 'Sumi-otoshi',
                        kanji => '隅落',
                    },
                    yama-arashi => {
                        number => 10,
                        name => 'Yama-arashi',
                        kanji => '山嵐',
                    },
                    obi-tori-gaeshi => {
                        number => 11,
                        name => 'Obi-tori-gaeshi',
                        kanji => '帯取返',
                    },
                    morote-gari => {
                        number => 12,
                        name => 'Morote-gari',
                        kanji => '双手刈'
                    },
                    kuchiki-taoshi => {
                        number => 13,
                        name => 'Kuchiki-taoshi',
                        kanji => '朽木倒',
                    },
                    kibisu-gaeshi => {
                        number => 14,
                        name => 'Kibisu-gaeshi',
                        kanji => '踵返',
                    },
                    uchi-mata-sukashi => {
                        number => 15,
                        name => 'Uchi-mata-sukashi',
                        kanji => '内股すかし',
                    },
                    ko-uchi-gaeshi => {
                        number => 16,
                        name => 'Ko-uchi-gaeshi',
                        kanji => '小内返'
                    },
                },
                koshi-waza => {
                    uki-goshi => {
                        number => 1,
                        name => "Uki-goshi",
                        kanji =>"浮腰",
                    },
                    o-goshi => {
                        number => 2,
                        name => "O-goshi",
                        kanji =>"大腰",
                    },
                    koshi-guruma => {
                        number => 3,
                        name => "Koshi-guruma",
                        kanji =>"腰車",
                    },
                    tsurikomi-goshi => {
                        number => 4,
                        name => "Tsurikomi-goshi",
                        kanji =>"釣込腰",
                    },
                    sode-tsurikomi-goshi => {
                        number => 5,
                        name => "Sode-tsurikomi-goshi",
                        kanji =>"袖釣込腰",
                    },
                    harai-goshi => {
                        number => 6,
                        name => "Harai-goshi",
                        kanji =>"払腰",
                    },
                    tsuri-goshi => {
                        number => 7,
                        name => "Tsuri-goshi",
                        kanji =>"釣腰",
                    },
                    hane-goshi => {
                        number => 8,
                        name => "Hane-goshi",
                        kanji =>"跳腰",
                    },
                    utsuri-goshi => {
                        number => 9,
                        name => "Utsuri-goshi",
                        kanji =>"移腰",
                    },
                    ushiro-goshi => {
                        number => 10,
                        name => "Ushiro-goshi",
                        kanji =>"後腰",
                    },
                },
        },


    }
    
    return %waza;
}
