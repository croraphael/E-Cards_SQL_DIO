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
    N'Seed Pokémon. Evolves from Ivysaur.',
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
    N'Mantis Pokémon.',
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
    N'Shadow Pokémon. Evolves from Haunter.',
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
    N'Armor Pokémon. Brutal strength.',
    N'Crushing Blow', N'110',
    N'Grass', N'Psychic', 3
FROM t_colls c
WHERE c.collection_set_name = N'Obsidian Flames'
AND NOT EXISTS (
    SELECT 1 FROM tbl_cards x
    WHERE x.collection_id = c.id
      AND x.card_number_in_collection = N'45/197'
);
