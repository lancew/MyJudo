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
                },
        },

    }
    
    return %waza;
}
