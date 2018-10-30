unit class Judo;

BEGIN my %waza =
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
            ma-sutemi-waza => {
                tomoe-nage => {
                    number => 1,
                    name => 'Tomoe-nage',
                    kanji => '巴投',
                },
                sumi-gaeshi => {
                    number => 2,
                    name => 'Sumi-gaeshi',
                    kanji => '隅返',
                },
                hikikomi-gaeshi => {
                    number => 3,
                    name => 'Hikikomi-gaeshi',
                    kanji => '引込返',
                },
                tawara-gaeshi => {
                    number => 4,
                    name => 'Tawara-gaeshi',
                    kanji => '俵返',
                },
                ura-nage => {
                    number => 5,
                    name => 'Ura-nage',
                    kanji => '裏投',
                },
            },
            yoko-sutemi-waza =>{
                yoko-otoshi => {
                    number => 1,
                    name => 'Yoko-otoshi',
                    kanji => '横落',
                },
                tani-otoshi => {
                    number => 2,
                    name => 'Tani-otoshi',
                    kanji => '谷落',
                },
                hane-makikomi => {
                    number => 3,
                    name => 'Hane-makikomi',
                    kanji => '跳巻込',
                },
                soto-makikomi => {
                    number => 4,
                    name => 'Soto-makikomi',
                    kanji => '外巻込',
                },
                uchi-makikomi => {
                    number => 5,
                    name => 'Uchi-makikomi',
                    kanji => '内巻込',
                },
                uki-waza => {
                    number => 6,
                    name => 'Uki-waza',
                    kanji => '浮技',
                },
                yoko-wakare => {
                    number => 7,
                    name => 'Yoko-wakare',
                    kanji => '横分',
                },
                yoko-guruma => {
                    number => 8,
                    name => 'Yoko-guruma',
                    kanji => '横車',
                },
                yoko-gake => {
                    number => 9,
                    name => 'Yoko-gake',
                    kanji => '横掛',
                },
                daki-wakare => {
                    number => 10,
                    name => 'Daki-wakare',
                    kanji => '抱分',
                },
                o-soto-makikomi => {
                    number => 11,
                    name => 'O-soto-makikomi',
                    kanji => '大外巻込',
                },
                uchi-mata-makikomi => {
                    number => 12,
                    name => 'Uchi-mata-makikomi',
                    kanji => '内股巻込',
                },
                harai-makikomi => {
                    number => 13,
                    name => 'Harai-makikomi',
                    kanji => '払巻込',
                },
                ko-uchi-makikomi => {
                    number => 14,
                    name => 'Ko-uchi-makikomi',
                    kanji => '小内巻込',
                },
                kani-basami => {
                    number => 15,
                    name => 'Kani-basami',
                    kanji => '蟹挟',
                },
                kawazu-gake => {
                    number => 16,
                    name => 'Kawazu-gake',
                    kanji => '河津掛',
                },

            },


    },
    katame-waza => {
        kanji => '固技',
        osaekomi-waza =>{
            kesa-gatame => {
                   number => 1,
                    name => 'Kesa-gatame',
                    kanji => '袈裟固',
            },
            kuzure-kesa-gatame => {
                   number => 2,
                    name => 'Kuzure-kesa-gatame',
                    kanji => '崩袈裟固',
            },
            ushiro-kesa-gatame => {
                   number => 3,
                    name => 'Ushiro-kesa-gatame',
                    kanji => '後袈裟固',
            },
            kata-gatame => {
                   number => 4,
                    name => 'Kata-gatame',
                    kanji => '肩固',
            },
            kami-shiho-gatame => {
                   number => 5,
                    name => 'Kami-shiho-gatame',
                    kanji => '上四方固',
            },
            kuzure-kami-shiho-gatame => {
                   number => 6,
                    name => 'Kuzure-kami-shiho-gatame',
                    kanji => '崩上四方固',
            },
            yoko-shiho-gatame => {
                   number => 7,
                    name => 'Yoko-shiho-gatame',
                    kanji => '横四方固',
            },
            tate-shiho-gatame => {
                   number => 8,
                    name => 'Tate-shiho-gatame',
                    kanji => '縦四方固',
            },
            uki-gatame => {
                   number => 9,
                    name => 'Uki-gatame',
                    kanji => '浮固',
            },
            ura-gatame => {
                   number => 10,
                    name => 'Ura-gatame',
                    kanji => '裏固',
            },
        },
        shime-waza => {
            nami-juji-jime => {
                number => 1,
                name => 'Nami-juji-jime',
                kanji => '並十字絞',

            },
            gyaku-juji-jime => {
                number => 2,
                name => 'Gyaku-juji-jime',
                kanji => '逆十字絞',
            },
            kata-juji-jime => {
                number => 3,
                name => 'Kata-juji-jime',
                kanji => '片十字絞',
            },
            hadaka-jime => {
                number => 4,
                name => 'Hadaka-jime',
                kanji => '裸絞',
            },
            okuri-eri-jime => {
                number => 5,
                name => 'Okuri-eri-jime',
                kanji => '送襟絞',
            },
            kataha-jime => {
                number => 6,
                name => 'Kataha-jime',
                kanji => '片羽絞',
            },
            katate-jime => {
                number => 7,
                name => 'Katate-jime',
                kanji => '片手絞',
            },
            ryote-jime => {
                number => 8,
                name => 'Ryote-jime',
                kanji => '両手絞',
            },
            sode-guruma-jime => {
                number => 9,
                name => 'Sode-guruma-jime',
                kanji => '袖車絞',
            },
            tsukkomi-jime => {
                number => 10,
                name => 'Tsukkomi-jime',
                kanji => '突込絞',
            },
            sankaku-jime => {
                number => 11,
                name => 'Sankaku-jime',
                kanji => '三角絞',
            },
            do-jime => {
                number => 12,
                name => 'Do-jime',
                kanji => '胴絞',
            },
        },
        kansetsu-waza => {
            ude-garami => {
                number => 1,
                name => 'Ude-garami',
                kanji => '腕緘',
            },
            ude-hishigi-juji-gatame => {
                number => 2,
                name => 'Ude-hishigi-juji-gatame',
                kanji => '腕挫十字固',
            },
            ude-hishigi-ude-gatame => {
                number => 3,
                name => 'Ude-hishigi-ude-gatame',
                kanji => '腕挫腕固',
            },
            ude-hishigi-hiza-gatame => {
                number => 4,
                name => 'Ude-hishigi-hiza-gatame',
                kanji => '腕挫膝固',
            },
            ude-hishigi-waki-gatame => {
                number => 5,
                name => 'Ude-hishigi-waki-gatame',
                kanji => '腕挫腋固',
            },
            ude-hishigi-hara-gatame => {
                number => 6,
                name => 'Ude-hishigi-hara-gatame',
                kanji => '腕挫腹固',
            },
            ude-hishigi-ashi-gatame => {
                number => 7,
                name => 'Ude-hishigi-hara-gatame',
                kanji => '腕挫脚固',
            },
            ude-hishigi-te-gatame => {
                number => 8,
                name => 'Ude-hishigi-te-gatame',
                kanji => '腕挫手固',
            },
            ude-hishigi-sankaku-gatame => {
                number => 9,
                name => 'Ude-hishigi-sankaku-gatame',
                kanji => '腕挫三角固',
            },
            ashi-garami => {
                number => 10,
                name => 'Ashi-garami',
                kanji => '足緘',
            },
        },
    }
;

method waza() { %waza }
