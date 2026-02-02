USE tcg;
GO

        /* ============================================
        1) Seed: Types
        ============================================ */
        ;WITH src(name) AS (
            SELECT N'Grass' UNION ALL
            SELECT N'Fire' UNION ALL
            SELECT N'Water' UNION ALL
            SELECT N'Lightning' UNION ALL
            SELECT N'Psychic' UNION ALL
            SELECT N'Fighting' UNION ALL
            SELECT N'Darkness' UNION ALL
            SELECT N'Metal' UNION ALL
            SELECT N'Colorless' UNION ALL
            SELECT N'Dragon' UNION ALL
            SELECT N'Fairy'
        )
        INSERT INTO tbl_types (name)
        SELECT name
        FROM src
        WHERE NOT EXISTS (
            SELECT 1 FROM tbl_types t WHERE t.name = src.name
        );

        /* ============================================
        2) Seed: Stages
        ============================================ */
        ;WITH src(name) AS (
            SELECT N'Basic' UNION ALL
            SELECT N'Stage 1' UNION ALL
            SELECT N'Stage 2' UNION ALL
            SELECT N'V' UNION ALL
            SELECT N'VSTAR' UNION ALL
            SELECT N'VMAX' UNION ALL
            SELECT N'GX' UNION ALL
            SELECT N'MEGA' UNION ALL
            SELECT N'ex' UNION ALL
            SELECT N'Terastal' UNION ALL
            SELECT N'BREAK' UNION ALL
            SELECT N'LV.X' UNION ALL
            SELECT N'Baby' UNION ALL
            SELECT N'Other'
        )
        INSERT INTO tbl_stages (name)
        SELECT s.name
        FROM src s
        WHERE NOT EXISTS (
            SELECT 1 FROM tbl_stages st WHERE st.name = s.name
        );

        /* ============================================
        3) Seed: Collections (Sets)
            (Example data; adjust dates/totals to your preference)
        ============================================ */
        ;WITH src(collection_set_name, release_date, total_cards_in_collection) AS (
            SELECT N'Base Set',           '1999-01-09', 102 UNION ALL
            SELECT N'Jungle',             '1999-06-16', 64  UNION ALL
            SELECT N'Fossil',             '1999-10-10', 62  UNION ALL
            SELECT N'Scarlet & Violet',   '2023-03-31', 258 UNION ALL
            SELECT N'Paldea Evolved',     '2023-06-09', 279 UNION ALL
            SELECT N'Obsidian Flames',    '2023-08-11', 230
        )
        INSERT INTO tbl_collections (collection_set_name, release_date, total_cards_in_collection)
        SELECT s.collection_set_name, s.release_date, s.total_cards_in_collection
        FROM src s
        WHERE NOT EXISTS (
            SELECT 1
            FROM tbl_collections c
            WHERE c.collection_set_name = s.collection_set_name
        );

        /* ============================================
        4) Seed: Sample Cards
            - Uses lookups for type_id, stage_id, and collection_id
            - Respects unique (collection_id, card_number_in_collection)
        ============================================ */

        /* Helper: inline table-valued expressions for mapping names to IDs */
        ;WITH
        t_types AS (
            SELECT id, name FROM tbl_types
        ),
        t_stages AS (
            SELECT id, name FROM tbl_stages
        ),
        t_coll AS (
            SELECT id, collection_set_name FROM tbl_collections
        )

        /* ---------- Base Set cards ---------- */
        INSERT INTO tbl_cards
        (
            collection_id, card_number_in_collection,
            hp, name, type_id, stage_id, info, attack, damage,
            weakness, resistance, retreat_cost
        )
        SELECT
            c.id, N'4/102', -- Charizard (example number)
            120, N'Charizard',
            (SELECT id FROM t_types  WHERE name = N'Fire'),
            (SELECT id FROM t_stages WHERE name = N'Stage 2'),
            N'Flame PokÃ©mon. Evolves from Charmeleon.',
            N'Fire Spin', N'100',
            N'Water', N'', 3
        FROM t_coll c
        WHERE c.collection_set_name = N'Base Set'
        AND NOT EXISTS (
                SELECT 1 FROM tbl_cards x
                WHERE x.collection_id = c.id AND x.card_number_in_collection = N'4/102'
        );

        ;WITH
        t_types AS (
            SELECT id, name FROM tbl_types
        ),
        t_stages AS (
            SELECT id, name FROM tbl_stages
        ),
        t_coll AS (
            SELECT id, collection_set_name FROM tbl_collections
        )

        INSERT INTO tbl_cards
        (
            collection_id, card_number_in_collection,
            hp, name, type_id, stage_id, info, attack, damage,
            weakness, resistance, retreat_cost
        )
        SELECT
            c.id, N'58/102', -- Pikachu
            40, N'Pikachu',
            (SELECT id FROM t_types  WHERE name = N'Lightning'),
            (SELECT id FROM t_stages WHERE name = N'Basic'),
            N'Mouse PokÃ©mon.',
            N'Thunder Jolt', N'30',
            N'Fighting', N'', 1
        FROM t_coll c
        WHERE c.collection_set_name = N'Base Set'
        AND NOT EXISTS (
                SELECT 1 FROM tbl_cards x
                WHERE x.collection_id = c.id AND x.card_number_in_collection = N'58/102'
        );

        /* ---------- Jungle cards ---------- */
        ;WITH
        t_types AS (
            SELECT id, name FROM tbl_types
        ),
        t_stages AS (
            SELECT id, name FROM tbl_stages
        ),
        t_coll AS (
            SELECT id, collection_set_name FROM tbl_collections
        )

        INSERT INTO tbl_cards
        (
            collection_id, card_number_in_collection,
            hp, name, type_id, stage_id, info, attack, damage,
            weakness, resistance, retreat_cost
        )
        SELECT
            c.id, N'1/64', -- Jolteon (example)
            70, N'Jolteon',
            (SELECT id FROM t_types  WHERE name = N'Lightning'),
            (SELECT id FROM t_stages WHERE name = N'Stage 1'),
            N'Evolves from Eevee.',
            N'Pin Missile', N'20x',
            N'Fighting', N'', 1
        FROM t_coll c
        WHERE c.collection_set_name = N'Jungle'
        AND NOT EXISTS (
                SELECT 1 FROM tbl_cards x
                WHERE x.collection_id = c.id AND x.card_number_in_collection = N'1/64'
        );

        /* ---------- Fossil cards ---------- */
        ;WITH
        t_types AS (
            SELECT id, name FROM tbl_types
        ),
        t_stages AS (
            SELECT id, name FROM tbl_stages
        ),
        t_coll AS (
            SELECT id, collection_set_name FROM tbl_collections
        )

        INSERT INTO tbl_cards
        (
            collection_id, card_number_in_collection,
            hp, name, type_id, stage_id, info, attack, damage,
            weakness, resistance, retreat_cost
        )
        SELECT
            c.id, N'15/62', -- Dragonite (example)
            100, N'Dragonite',
            (SELECT id FROM t_types  WHERE name = N'Colorless'),
            (SELECT id FROM t_stages WHERE name = N'Stage 2'),
            N'Dragon PokÃ©mon. Evolves from Dragonair.',
            N'Slam', N'40x',
            N'Colorless', N'', 2
        FROM t_coll c
        WHERE c.collection_set_name = N'Fossil'
        AND NOT EXISTS (
                SELECT 1 FROM tbl_cards x
                WHERE x.collection_id = c.id AND x.card_number_in_collection = N'15/62'
        );

        /* ---------- Scarlet & Violet cards ---------- */
        ;WITH
        t_types AS (
            SELECT id, name FROM tbl_types
        ),
        t_stages AS (
            SELECT id, name FROM tbl_stages
        ),
        t_coll AS (
            SELECT id, collection_set_name FROM tbl_collections
        )

        INSERT INTO tbl_cards
        (
            collection_id, card_number_in_collection,
            hp, name, type_id, stage_id, info, attack, damage,
            weakness, resistance, retreat_cost
        )
        SELECT
            c.id, N'201/198', -- Gardevoir ex (illustrative secret)
            310, N'Gardevoir ex',
            (SELECT id FROM t_types  WHERE name = N'Psychic'),
            (SELECT id FROM t_stages WHERE name = N'ex'),
            N'Tera mechanics appear in this block.',
            N'Miracle Force', N'190',
            N'Metal', N'', 2
        FROM t_coll c
        WHERE c.collection_set_name = N'Scarlet & Violet'
        AND NOT EXISTS (
                SELECT 1 FROM tbl_cards x
                WHERE x.collection_id = c.id AND x.card_number_in_collection = N'201/198'
        );

        /* ---------- Paldea Evolved cards ---------- */
        ;WITH
        t_types AS (
            SELECT id, name FROM tbl_types
        ),
        t_stages AS (
            SELECT id, name FROM tbl_stages
        ),
        t_coll AS (
            SELECT id, collection_set_name FROM tbl_collections
        )

        INSERT INTO tbl_cards
        (
            collection_id, card_number_in_collection,
            hp, name, type_id, stage_id, info, attack, damage,
            weakness, resistance, retreat_cost
        )
        SELECT
            c.id, N'279/279', -- example secret
            230, N'Chien-Pao ex',
            (SELECT id FROM t_types  WHERE name = N'Water'),
            (SELECT id FROM t_stages WHERE name = N'ex'),
            N'Legendary PokÃ©mon.',
            N'Hail Blade', N'60x',
            N'Metal', N'', 2
        FROM t_coll c
        WHERE c.collection_set_name = N'Paldea Evolved'
        AND NOT EXISTS (
                SELECT 1 FROM tbl_cards x
                WHERE x.collection_id = c.id AND x.card_number_in_collection = N'279/279'
        );

        /* ---------- Obsidian Flames cards ---------- */
        ;WITH
        t_types AS (
            SELECT id, name FROM tbl_types
        ),
        t_stages AS (
            SELECT id, name FROM tbl_stages
        ),
        t_coll AS (
            SELECT id, collection_set_name FROM tbl_collections
        )
        
        INSERT INTO tbl_cards
        (
            collection_id, card_number_in_collection,
            hp, name, type_id, stage_id, info, attack, damage,
            weakness, resistance, retreat_cost
        )
        SELECT
            c.id, N'125/197', -- Charizard ex (example)
            330, N'Charizard ex',
            (SELECT id FROM t_types  WHERE name = N'Fire'),
            (SELECT id FROM t_stages WHERE name = N'ex'),
            N'Tera: Darkness type variant exists in set.',
            N'Burning Darkness', N'80+',
            N'Water', N'', 2
        FROM t_coll c
        WHERE c.collection_set_name = N'Obsidian Flames'
        AND NOT EXISTS (
                SELECT 1 FROM tbl_cards x
                WHERE x.collection_id = c.id AND x.card_number_in_collection = N'125/197'
        );

GO

;WITH
t_types AS (
    SELECT id, name FROM tbl_types
),
t_stages AS (
    SELECT id, name FROM tbl_stages
),
t_colls AS (
    SELECT id, collection_set_name FROM tbl_collections
)
INSERT INTO tbl_cards
(
    collection_id, card_number_in_collection,
    hp, name, type_id, stage_id,
    info, attack, damage,
    weakness, resistance, retreat_cost
)
SELECT
    c.id, N'15/102', -- Venusaur
    100, N'Venusaur',
    (SELECT id FROM t_types  WHERE name = N'Grass'),
    (SELECT id FROM t_stages WHERE name = N'Stage 2'),
    N'Seed PokÃ©mon. Evolves from Ivysaur.',
    N'Solar Beam', N'60',
    N'Fire', N'', 2
FROM t_colls c
WHERE c.collection_set_name = N'Base Set'
AND NOT EXISTS (
    SELECT 1 FROM tbl_cards x
    WHERE x.collection_id = c.id
      AND x.card_number_in_collection = N'15/102'
);

;WITH
t_types AS (
    SELECT id, name FROM tbl_types
),
t_stages AS (
    SELECT id, name FROM tbl_stages
),
t_colls AS (
    SELECT id, collection_set_name FROM tbl_collections
)
INSERT INTO tbl_cards
(
    collection_id, card_number_in_collection,
    hp, name, type_id, stage_id,
    info, attack, damage,
    weakness, resistance, retreat_cost
)
SELECT
    c.id, N'10/64', -- Scyther
    70, N'Scyther',
    (SELECT id FROM t_types  WHERE name = N'Grass'),
    (SELECT id FROM t_stages WHERE name = N'Basic'),
    N'Mantis PokÃ©mon.',
    N'Slash', N'30',
    N'Fire', N'Fighting', 1
FROM t_colls c
WHERE c.collection_set_name = N'Jungle'
AND NOT EXISTS (
    SELECT 1 FROM tbl_cards x
    WHERE x.collection_id = c.id
      AND x.card_number_in_collection = N'10/64'
);

;WITH
t_types AS (
    SELECT id, name FROM tbl_types
),
t_stages AS (
    SELECT id, name FROM tbl_stages
),
t_colls AS (
    SELECT id, collection_set_name FROM tbl_collections
)
INSERT INTO tbl_cards
(
    collection_id, card_number_in_collection,
    hp, name, type_id, stage_id,
    info, attack, damage,
    weakness, resistance, retreat_cost
)
SELECT
    c.id, N'5/62', -- Gengar
    80, N'Gengar',
    (SELECT id FROM t_types  WHERE name = N'Psychic'),
    (SELECT id FROM t_stages WHERE name = N'Stage 2'),
    N'Shadow PokÃ©mon. Evolves from Haunter.',
    N'Dark Mind', N'30',
    N'Darkness', N'Fighting', 0
FROM t_colls c
WHERE c.collection_set_name = N'Fossil'
AND NOT EXISTS (
    SELECT 1 FROM tbl_cards x
    WHERE x.collection_id = c.id
      AND x.card_number_in_collection = N'5/62'
);

;WITH
t_types AS (
    SELECT id, name FROM tbl_types
),
t_stages AS (
    SELECT id, name FROM tbl_stages
),
t_colls AS (
    SELECT id, collection_set_name FROM tbl_collections
)
INSERT INTO tbl_cards
(
    collection_id, card_number_in_collection,
    hp, name, type_id, stage_id,
    info, attack, damage,
    weakness, resistance, retreat_cost
)
SELECT
    c.id, N'45/197', -- Tyranitar
    180, N'Tyranitar',
    (SELECT id FROM t_types  WHERE name = N'Darkness'),
    (SELECT id FROM t_stages WHERE name = N'Stage 2'),
    N'Armor PokÃ©mon. Brutal strength.',
    N'Crushing Blow', N'110',
    N'Grass', N'Psychic', 3
FROM t_colls c
WHERE c.collection_set_name = N'Obsidian Flames'
AND NOT EXISTS (
    SELECT 1 FROM tbl_cards x
    WHERE x.collection_id = c.id
      AND x.card_number_in_collection = N'45/197'
);

GO

;WITH
t_types AS (
    SELECT id, name FROM tbl_types
),
t_stages AS (
    SELECT id, name FROM tbl_stages
),
t_colls AS (
    SELECT id, collection_set_name FROM tbl_collections
),
src AS (
    SELECT *
    FROM (VALUES
        -- Base Set
        (N'Base Set', N'1/102',  40,  N'Bulbasaur',  N'Grass',      N'Basic',   N'Seed PokÃ©mon.', N'Tackle', N'10', N'Fire', N'', 1),
        (N'Base Set', N'2/102',  60,  N'Ivysaur',    N'Grass',      N'Stage 1', N'Evolves from Bulbasaur.', N'Vine Whip', N'30', N'Fire', N'', 2),
        (N'Base Set', N'7/102',  80,  N'Squirtle',   N'Water',      N'Basic',   N'Tiny Turtle PokÃ©mon.', N'Bubble', N'10', N'Lightning', N'', 1),
        (N'Base Set', N'9/102',  100, N'Blastoise',  N'Water',      N'Stage 2', N'Shellfish PokÃ©mon.', N'Hydro Pump', N'60+', N'Lightning', N'', 3),

        -- Jungle
        (N'Jungle',   N'6/64',   60,  N'Paras',      N'Grass',      N'Basic',   N'Mushroom PokÃ©mon.', N'Scratch', N'20', N'Fire', N'', 1),
        (N'Jungle',   N'7/64',   90,  N'Parasect',   N'Grass',      N'Stage 1', N'Evolves from Paras.', N'Spore', N'30', N'Fire', N'', 2),
        (N'Jungle',   N'12/64',  70,  N'Exeggcute',  N'Grass',      N'Basic',   N'Egg PokÃ©mon.', N'Hypnosis', N'', N'Fire', N'Psychic', 1),
        (N'Jungle',   N'35/64',  90,  N'Kangaskhan', N'Colorless',  N'Basic',   N'Parent PokÃ©mon.', N'Comet Punch', N'20x', N'Fighting', N'', 3),

        -- Fossil
        (N'Fossil',   N'16/62',  70,  N'Kabuto',     N'Fighting',   N'Basic',   N'Shellfish PokÃ©mon.', N'Scratch', N'10', N'Grass', N'', 1),
        (N'Fossil',   N'17/62',  120, N'Kabutops',   N'Fighting',   N'Stage 2', N'Evolves from Kabuto.', N'Sharp Sickle', N'50', N'Grass', N'', 2),
        (N'Fossil',   N'18/62',  60,  N'Aerodactyl', N'Colorless',  N'Other',   N'Fossil PokÃ©mon.', N'Wing Attack', N'30', N'Lightning', N'Fighting', 2),
        (N'Fossil',   N'29/62',  50,  N'Omanyte',    N'Water',      N'Basic',   N'Spiral PokÃ©mon.', N'Water Gun', N'10', N'Grass', N'', 1),

        -- Scarlet & Violet
        (N'Scarlet & Violet', N'12/198', 70,  N'Sprigatito', N'Grass', N'Basic', N'Grass Cat PokÃ©mon.', N'Leafage', N'20', N'Fire', N'', 1),
        (N'Scarlet & Violet', N'14/198', 110, N'Floragato',  N'Grass', N'Stage 1', N'Evolves from Sprigatito.', N'Magical Leaf', N'40', N'Fire', N'', 2),
        (N'Scarlet & Violet', N'38/198', 60,  N'Fuecoco',    N'Fire',  N'Basic', N'Fire Croc PokÃ©mon.', N'Ember', N'30', N'Water', N'', 1),
        (N'Scarlet & Violet', N'41/198', 130, N'Crocalor',   N'Fire',  N'Stage 1', N'Evolves from Fuecoco.', N'Heat Breath', N'50', N'Water', N'', 2),

        -- Paldea Evolved
        (N'Paldea Evolved', N'61/279', 90,  N'Frigibax',   N'Dragon', N'Basic', N'Ice Fin PokÃ©mon.', N'Bite', N'30', N'Metal', N'', 1),
        (N'Paldea Evolved', N'63/279', 160, N'Baxcalibur',N'Dragon', N'Stage 2', N'Evolves from Arctibax.', N'Glaive Rush', N'160', N'Metal', N'', 3),

        -- Obsidian Flames
        (N'Obsidian Flames', N'33/197', 120, N'Houndoom',  N'Darkness', N'Stage 1', N'Dark PokÃ©mon.', N'Dark Fang', N'50', N'Grass', N'Psychic', 2),
        (N'Obsidian Flames', N'78/197', 90,  N'Clefairy',  N'Fairy',    N'Basic', N'Fairy PokÃ©mon.', N'Metronome', N'', N'Metal', N'Darkness', 1)
    ) AS v(
        collection_set_name,
        card_number_in_collection,
        hp,
        name,
        type_name,
        stage_name,
        info,
        attack,
        damage,
        weakness,
        resistance,
        retreat_cost
    )
)
INSERT INTO tbl_cards
(
    collection_id,
    card_number_in_collection,
    hp,
    name,
    type_id,
    stage_id,
    info,
    attack,
    damage,
    weakness,
    resistance,
    retreat_cost
)
SELECT
    c.id,
    s.card_number_in_collection,
    s.hp,
    s.name,
    t.id,
    st.id,
    s.info,
    s.attack,
    s.damage,
    s.weakness,
    s.resistance,
    s.retreat_cost
FROM src s
JOIN t_colls  c  ON c.collection_set_name = s.collection_set_name
JOIN t_types  t  ON t.name = s.type_name
JOIN t_stages st ON st.name = s.stage_name
WHERE NOT EXISTS (
    SELECT 1
    FROM tbl_cards x
    WHERE x.collection_id = c.id
      AND x.card_number_in_collection = s.card_number_in_collection
);

GO

