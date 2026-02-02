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
            N'Flame Pokémon. Evolves from Charmeleon.',
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
            N'Mouse Pokémon.',
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
            N'Dragon Pokémon. Evolves from Dragonair.',
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
            N'Legendary Pokémon.',
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
