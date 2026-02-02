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
        (N'Base Set', N'1/102',  40,  N'Bulbasaur',  N'Grass',      N'Basic',   N'Seed Pokémon.', N'Tackle', N'10', N'Fire', N'', 1),
        (N'Base Set', N'2/102',  60,  N'Ivysaur',    N'Grass',      N'Stage 1', N'Evolves from Bulbasaur.', N'Vine Whip', N'30', N'Fire', N'', 2),
        (N'Base Set', N'7/102',  80,  N'Squirtle',   N'Water',      N'Basic',   N'Tiny Turtle Pokémon.', N'Bubble', N'10', N'Lightning', N'', 1),
        (N'Base Set', N'9/102',  100, N'Blastoise',  N'Water',      N'Stage 2', N'Shellfish Pokémon.', N'Hydro Pump', N'60+', N'Lightning', N'', 3),

        -- Jungle
        (N'Jungle',   N'6/64',   60,  N'Paras',      N'Grass',      N'Basic',   N'Mushroom Pokémon.', N'Scratch', N'20', N'Fire', N'', 1),
        (N'Jungle',   N'7/64',   90,  N'Parasect',   N'Grass',      N'Stage 1', N'Evolves from Paras.', N'Spore', N'30', N'Fire', N'', 2),
        (N'Jungle',   N'12/64',  70,  N'Exeggcute',  N'Grass',      N'Basic',   N'Egg Pokémon.', N'Hypnosis', N'', N'Fire', N'Psychic', 1),
        (N'Jungle',   N'35/64',  90,  N'Kangaskhan', N'Colorless',  N'Basic',   N'Parent Pokémon.', N'Comet Punch', N'20x', N'Fighting', N'', 3),

        -- Fossil
        (N'Fossil',   N'16/62',  70,  N'Kabuto',     N'Fighting',   N'Basic',   N'Shellfish Pokémon.', N'Scratch', N'10', N'Grass', N'', 1),
        (N'Fossil',   N'17/62',  120, N'Kabutops',   N'Fighting',   N'Stage 2', N'Evolves from Kabuto.', N'Sharp Sickle', N'50', N'Grass', N'', 2),
        (N'Fossil',   N'18/62',  60,  N'Aerodactyl', N'Colorless',  N'Other',   N'Fossil Pokémon.', N'Wing Attack', N'30', N'Lightning', N'Fighting', 2),
        (N'Fossil',   N'29/62',  50,  N'Omanyte',    N'Water',      N'Basic',   N'Spiral Pokémon.', N'Water Gun', N'10', N'Grass', N'', 1),

        -- Scarlet & Violet
        (N'Scarlet & Violet', N'12/198', 70,  N'Sprigatito', N'Grass', N'Basic', N'Grass Cat Pokémon.', N'Leafage', N'20', N'Fire', N'', 1),
        (N'Scarlet & Violet', N'14/198', 110, N'Floragato',  N'Grass', N'Stage 1', N'Evolves from Sprigatito.', N'Magical Leaf', N'40', N'Fire', N'', 2),
        (N'Scarlet & Violet', N'38/198', 60,  N'Fuecoco',    N'Fire',  N'Basic', N'Fire Croc Pokémon.', N'Ember', N'30', N'Water', N'', 1),
        (N'Scarlet & Violet', N'41/198', 130, N'Crocalor',   N'Fire',  N'Stage 1', N'Evolves from Fuecoco.', N'Heat Breath', N'50', N'Water', N'', 2),

        -- Paldea Evolved
        (N'Paldea Evolved', N'61/279', 90,  N'Frigibax',   N'Dragon', N'Basic', N'Ice Fin Pokémon.', N'Bite', N'30', N'Metal', N'', 1),
        (N'Paldea Evolved', N'63/279', 160, N'Baxcalibur',N'Dragon', N'Stage 2', N'Evolves from Arctibax.', N'Glaive Rush', N'160', N'Metal', N'', 3),

        -- Obsidian Flames
        (N'Obsidian Flames', N'33/197', 120, N'Houndoom',  N'Darkness', N'Stage 1', N'Dark Pokémon.', N'Dark Fang', N'50', N'Grass', N'Psychic', 2),
        (N'Obsidian Flames', N'78/197', 90,  N'Clefairy',  N'Fairy',    N'Basic', N'Fairy Pokémon.', N'Metronome', N'', N'Metal', N'Darkness', 1)
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
