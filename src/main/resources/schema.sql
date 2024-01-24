
CREATE TABLE IF NOT EXISTS Users
(
    userId        UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    userName      varchar(30)    NOT NULL,
    fullName      varchar(255)   NOT NULL,
    email         varchar UNIQUE NOT NULL,
    password      varchar,
    passwordHash  varchar        NOT NULL,
    description   varchar,
    flairId       UUID UNIQUE,
    createdAt     timestamptz             DEFAULT (now()),
    updatedAt     timestamptz             DEFAULT (now()),
    profilePicUrl varchar,
    dateOfBirth   timestamptz    NOT NULL,
    enabled       BOOLEAN                 DEFAULT FALSE,
    locked        BOOLEAN                 DEFAULT FALSE,
    admin         BOOLEAN                 DEFAULT FALSE
);