unit class Judo;

method waza () {
    return {
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
                },
                koshi-waza => {},
                ashi-waza => {},
                ma-sutemi-waza => {},
                yoko-sutemi-waza => {},
        },

    };
}
