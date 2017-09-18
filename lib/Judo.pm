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
                ashi-waza => {
                    de-ashi-harai => {
                        number => 1,
                        name => 'De-ashi-harai',
                        kanji => '出足払',
                    },
                    hiza-guruma => {
                        number => 2,
                        name => 'Hiza-guruma',
                        kanji => '膝車',
                    },
                    sasae-tsurikomi-ashi => {
                        number => 3,
                        name => 'Sasae-tsurikomi-ashi',
                        kanji => '支釣込足',
                    },
                    o-soto-gari => {
                        number => 4,
                        name => 'O-soto-gari',
                        kanji => '大外刈',
                    },
                    o-uchi-gari => {
                        number => 5,
                        name => 'O-uchi-gari',
                        kanji => '大内刈',
                    },
                    ko-soto-gari => {
                        number => 6,
                        name => 'Ko-soto-gari',
                        kanji => '小外刈',
                    },
                    ko-uchi-gari => {
                        number => 7,
                        name => 'Ko-uchi-gari',
                        kanji => '小内刈',
                    },
                    okuri-ashi-harai => {
                        number => 8,
                        name => 'Okuri-ashi-harai',
                        kanji => '送足払',
                    },
                    uchi-mata => {
                        number => 9,
                        name => 'Uchi-mata',
                        kanji => '内股',
                    },
                    ko-soto-gake => {
                        number => 10,
                        name => 'Ko-soto-gake',
                        kanji => '小外掛',
                    },
                    ashi-guruma => {
                        number => 11,
                        name => 'Ashi-guruma',
                        kanji => '足車',
                    },
                    harai-tsurikomi-ashi => {
                        number => 12,
                        name => 'Harai-tsurikomi-ashi',
                        kanji => '払釣込足',
                    },
                    o-guruma => {
                        number => 13,
                        name => 'O-guruma',
                        kanji => '大車',
                    },
                    o-soto-guruma => {
                        number => 14,
                        name => 'O-soto-guruma',
                        kanji => '大外車',
                    },
                    o-soto-otoshi => {
                        number => 15,
                        name => 'O-soto-otoshi',
                        kanji => '大外落',
                    },
                    tsubame-gaeshi => {
                        number => 16,
                        name => 'Tsubame-gaeshi',
                        kanji => '燕返',
                    },
                    o-soto-gaeshi => {
                        number => 17,
                        name => 'O-soto-gaeshi',
                        kanji => '大外返',
                    },
                    o-uchi-gaeshi => {
                        number => 18,
                        name => 'O-uchi-gaeshi',
                        kanji => '大内返',
                    },
                    hane-goshi-gaeshi => {
                        number => 19,
                        name => 'Hane-goshi-gaeshi',
                        kanji => '跳腰返',
                    },
                    harai-goshi-gaeshi => {
                        number => 20,
                        name => 'Harai-goshi-gaeshi',
                        kanji => '払腰返',
                    },
                    uchi-mata-gaeshi => {
                        number => 21,
                        name => 'Uchi-mata-gaeshi',
                        kanji => '内股返',
                    },
                },

        },


    }
    
    return %waza;
}
