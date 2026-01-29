
---------------------------------------------
-- 0) Database
---------------------------------------------
CREATE DATABASE tcg;
GO
USE tcg;
GO

---------------------------------------------
-- 1) Collections (Sets)
---------------------------------------------
CREATE TABLE tbl_collections
(
    id                        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    collection_set_name       NVARCHAR(200)     NOT NULL,  -- original: "collection set name"
    release_date              DATE              NULL,      -- original: "release Date"
    total_cards_in_collection INT               NULL       -- original: "totalCardsInCollection"
        CONSTRAINT CK_tbl_collections_total_cards_nonneg CHECK (total_cards_in_collection IS NULL OR total_cards_in_collection >= 0)
);

CREATE UNIQUE INDEX UX_tbl_collections_name
    ON tbl_collections (collection_set_name);
GO

---------------------------------------------
-- 2) Lookup table: Types (normalized from your CHECK list)
---------------------------------------------
CREATE TABLE tbl_types
(
    id   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(30)      NOT NULL UNIQUE
);
GO

---------------------------------------------
-- 3) Lookup table: Stages (normalized from your CHECK list)
---------------------------------------------
CREATE TABLE tbl_stages
(
    id   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(30)      NOT NULL UNIQUE
);
GO

---------------------------------------------
-- 4) Cards (now using FKs: type_id, stage_id)
---------------------------------------------
CREATE TABLE tbl_cards
(
    id                        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,   -- original: id
    collection_id             INT               NOT NULL,               -- FK to collections (set)
    card_number_in_collection NVARCHAR(20)      NOT NULL,               -- original: cardNumberINCollection

    hp                        INT               NULL,                   -- original: hp
        CONSTRAINT CK_tbl_cards_hp_nonneg CHECK (hp IS NULL OR hp >= 0),

    name                      NVARCHAR(200)     NOT NULL,               -- original: name

    type_id                   INT               NULL,                   -- replaces: type
    stage_id                  INT               NULL,                   -- replaces: stage

    info                      NVARCHAR(MAX)     NULL,                   -- original: info

    attack                    NVARCHAR(400)     NULL,                   -- original: attack
    damage                    NVARCHAR(50)      NULL,                   -- original: damage

    weakness                  NVARCHAR(50)      NULL,                   -- original: weak
    resistance                NVARCHAR(50)      NULL,                   -- original: ressils

    retreat_cost              INT               NULL,                   -- original: reatreat
        CONSTRAINT CK_tbl_cards_retreat_nonneg CHECK (retreat_cost IS NULL OR retreat_cost >= 0)
);

-- FK to collections
ALTER TABLE tbl_cards
ADD CONSTRAINT FK_tbl_cards_collections
    FOREIGN KEY (collection_id) REFERENCES tbl_collections (id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE;

-- FKs to lookup tables (allow NULL to mirror your previous NULL-ability)
ALTER TABLE tbl_cards
ADD CONSTRAINT FK_tbl_cards_type
    FOREIGN KEY (type_id) REFERENCES tbl_types (id)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE tbl_cards
ADD CONSTRAINT FK_tbl_cards_stage
    FOREIGN KEY (stage_id) REFERENCES tbl_stages (id)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

-- Ensure unique card number inside a collection
CREATE UNIQUE INDEX UX_tbl_cards_collection_cardnumber
    ON dbo.tbl_cards (collection_id, card_number_in_collection);

-- Helpful search indexes
CREATE INDEX IX_tbl_cards_name     ON dbo.tbl_cards (name);
CREATE INDEX IX_tbl_cards_type_id  ON dbo.tbl_cards (type_id);
CREATE INDEX IX_tbl_cards_stage_id ON dbo.tbl_cards (stage_id);
GO
