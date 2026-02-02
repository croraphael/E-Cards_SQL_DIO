CREATE VIEW vw_cards_detalhada
AS
SELECT
    c.id,

    -- Collection
    col.collection_set_name     AS collection_name,
    col.release_date,
    col.total_cards_in_collection,

    -- Card info
    c.card_number_in_collection,
    c.name,
    c.hp,
    c.info,
    c.attack,
    c.damage,
    c.weakness,
    c.resistance,
    c.retreat_cost,

    -- Lookup values
    t.name  AS type_name,
    s.name  AS stage_name

FROM tbl_cards c
INNER JOIN tbl_collections col
    ON col.id = c.collection_id
LEFT JOIN tbl_types t
    ON t.id = c.type_id
LEFT JOIN tbl_stages s
    ON s.id = c.stage_id;
GO
