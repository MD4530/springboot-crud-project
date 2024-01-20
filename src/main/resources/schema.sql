CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

CREATE TABLE IF NOT EXISTS Coins
(
    coinId          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userId          UUID    NOT NULL,
    issueTime       timestamptz      DEFAULT (now()),
    coinAmount      INTEGER NOT NULL,
    transactionType varchar NOT NULL,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PartnerUser
(
    partnerUserId UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    userId        UUID NOT NULL,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

-- DELETE OLD RECORDS AFTER 3 MONTHS. SETUP CRON JOB IN RDS
CREATE TABLE IF NOT EXISTS FcmToken
(
    fcmTokenId UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    userId     UUID        NOT NULL,
    token      varchar     NOT NULL UNIQUE,
    updateAt   timestamptz NOT NULL    DEFAULT (now()),
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

DO
$$
BEGIN
CREATE TYPE tokenType AS ENUM ('confirmation', 'forgotPassword', 'forgotUsername');
EXCEPTION
        WHEN duplicate_object THEN null;
END
$$;

CREATE TABLE IF NOT EXISTS PlayerToken
(
    tokenId     UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    tokenType   varchar                    NOT NULL ,
    code6Digit varchar                     NOT NULL ,
    createdAt   timestamptz                DEFAULT (now()),
    isConfirmed boolean                DEFAULT false,
    userId      UUID REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS UserProfile
(
    s3Id             UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    entityObjectType varchar,
    extension        varchar,
    userId           UUID REFERENCES Users (userId) ON DELETE CASCADE
    );

-- Friend List

CREATE TABLE IF NOT EXISTS CompleteFriends
(
    friendId   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fromUserId UUID NOT NULL,
    toUserId   UUID NOT NULL,
    createdAt  timestamptz      DEFAULT (now()),
    updatedAt  timestamptz      DEFAULT (now()),
    FOREIGN KEY (fromUserId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (toUserId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS FriendQueue
(
    friendQueueId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fromUserId    UUID NOT NULL,
    toUserId      UUID NOT NULL,
    createdAt     timestamptz      DEFAULT (now()),
    updatedAt     timestamptz      DEFAULT (now()),
    FOREIGN KEY (fromUserId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (toUserId) REFERENCES Users (userId) ON DELETE CASCADE
    );

-- MATCHMAKING SURVEY

CREATE TABLE IF NOT EXISTS MF_QuestionType
(
    questionTypeId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    typeName       varchar
    );

CREATE TABLE IF NOT EXISTS MF_Question
(
    questionId     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    questionTypeId UUID       NOT NULL,
    questionOrder  int UNIQUE NOT NULL,
    questionText   varchar    NOT NULL,
    pgQuestionText varchar    NOT NULL,
    questionTitle  varchar,
    FOREIGN KEY (questionTypeId) REFERENCES MF_QuestionType (questionTypeId) ON DELETE CASCADE
    );


CREATE TABLE IF NOT EXISTS MF_ResponseChoice
(
    responseChoiceId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    questionId       UUID NOT NULL,
    responseText     varchar,
    responseOrder    int,
    FOREIGN KEY (questionId) REFERENCES MF_Question (questionId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS MF_OfferedAnswer
(
    offeredResponseId   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    questionId          UUID NOT NULL,
    userId              UUID NOT NULL,
    responseChoiceId    UUID NOT NULL,
    updatedAt           timestamptz      DEFAULT (now()),
    heuristicMultiplier int              DEFAULT 1,
    FOREIGN KEY (questionId) REFERENCES MF_Question (questionId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (responseChoiceId) REFERENCES MF_ResponseChoice (responseChoiceId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS MatchQueue
(
    matchQueueId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fromUserId   UUID NOT NULL,
    toUserId     UUID NOT NULL,
    createdAt    timestamptz      DEFAULT (now()),
    updatedAt    timestamptz      DEFAULT (now()),
    FOREIGN KEY (fromUserId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (toUserId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS RejectedMatches
(
    rejectedMatchesId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fromUserId        UUID NOT NULL,
    toUserId          UUID NOT NULL,
    updatedAt         timestamptz      DEFAULT (now()),
    FOREIGN KEY (fromUserId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (toUserId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS CompleteMatches
(
    matchesId  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fromUserId UUID NOT NULL,
    toUserId   UUID NOT NULL,
    createdAt  timestamptz      DEFAULT (now()),
    updatedAt  timestamptz      DEFAULT (now()),
    FOREIGN KEY (fromUserId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (toUserId) REFERENCES Users (userId) ON DELETE CASCADE
    );

-- PARTY INTEGRATION

CREATE TABLE IF NOT EXISTS PlatformFamily
(
    platformFamilyId     UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    igdbPlatformFamilyId Integer UNIQUE NOT NULL,
    platformFamilyName   varchar        NOT NULL
    );

CREATE TABLE IF NOT EXISTS PlatformType
(
    platformId       UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    igdbPlatformId   Integer UNIQUE NOT NULL,
    platformFamilyId UUID           NOT NULL,
    FOREIGN KEY (platformFamilyId) REFERENCES PlatformFamily (platformFamilyId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS GameData
(
    gameDataId           UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    userId               UUID    NOT NULL,
    igdbPlatformFamilyId Integer,
    igdbGameId           Integer NOT NULL,
    isFavorite           boolean,
    gameName             varchar NOT NULL,
    coverPicUrl          varchar,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (igdbPlatformFamilyId) REFERENCES PlatformFamily (igdbPlatformFamilyId) ON DELETE CASCADE
    );

-- LFG

CREATE TABLE IF NOT EXISTS LfgPost
(
    lfgId         UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    createdBy     UUID NOT NULL,
    lfgPhotoUrl   varchar,
    igdbPlatformFamilyId    INTEGER NOT NULL,
    igdbGameId    Integer NOT NULL,
    coverPicUrl   varchar,
    screenshotPicUrl varchar,
    gameName      varchar NOT NULL,
    lfgActivity   varchar,
    lfgPostTitle  varchar NOT NULL,
    startedAt     timestamptz               DEFAULT (now()),
    membersNeeded int              NOT NULL,
    shareLink     varchar,
    mic           boolean          NOT NULL DEFAULT false,
    FOREIGN KEY (createdBy) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (igdbPlatformFamilyId) REFERENCES PlatformFamily (igdbPlatformFamilyId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS LfgBroadcast
(
    broadcastId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lfgPostId   UUID NOT NULL,
    userId      UUID NOT NULL,
    FOREIGN KEY (lfgPostId) REFERENCES LfgPost (lfgId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS LfgQueue
(
    lfgQueueId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lfgPostId  UUID    NOT NULL,
    userId     UUID    NOT NULL,
    mic        boolean NOT NULL DEFAULT false,
    FOREIGN KEY (lfgPostId) REFERENCES LfgPost (lfgId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

-- MESSAGING

DO
$$
BEGIN
CREATE TYPE ChatType AS ENUM ('friend', 'lfg', 'playground');
EXCEPTION
        WHEN duplicate_object THEN null;
END
$$;

CREATE TABLE IF NOT EXISTS Chat
(
    chatId     UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    fromUserId UUID    NOT NULL,
    toUserId   UUID    NOT NULL,
    chatTitle  varchar,
    chatType   varchar NOT NULL,
    createdAt  timestamptz             DEFAULT (now()),
    FOREIGN KEY (fromUserId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (toUserId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS ChatGroup
(
    chatGroupId UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    creatorId   UUID    NOT NULL,
    chatTitle   varchar,
    chatType    varchar NOT NULL,
    chatPicUrl  varchar,
    createdAt   timestamptz             DEFAULT (now()),
    FOREIGN KEY (creatorId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS ChatGroupMembers
(
    chatGroupMembersId UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    chatGroupId        UUID NOT NULL,
    userId             UUID NOT NULL,
    FOREIGN KEY (chatGroupId) REFERENCES ChatGroup (chatGroupId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS ChatGroupMessage
(
    chatGroupMessageId UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    chatGroupId        UUID NOT NULL,
    senderId           UUID NOT NULL,
    messageStr         varchar,
    createdAt          timestamptz             DEFAULT (now()),
    imgUrl             varchar,
    vidUrl             varchar,
    FOREIGN KEY (chatGroupId) REFERENCES ChatGroup (chatGroupId) ON DELETE CASCADE,
    FOREIGN KEY (senderId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS ChatMessage
(
    messageId  UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    chatId     UUID NOT NULL,
    senderId   UUID,
    messageStr varchar,
    createdAt  timestamptz             DEFAULT (now()),
    imgUrl     varchar,
    vidUrl     varchar,
    FOREIGN KEY (chatId) REFERENCES Chat (chatId) ON DELETE CASCADE,
    FOREIGN KEY (senderId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS ChatMessageProfile
(
    s3Id      UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    mimeType  varchar,
    extension varchar,
    messageId UUID,
    FOREIGN KEY (messageId) REFERENCES ChatMessage (messageId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS ChatGroupMessageProfile
(
    s3Id               UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    mimeType           varchar,
    extension          varchar,
    chatGroupMessageId UUID,
    FOREIGN KEY (chatGroupMessageId) REFERENCES ChatGroupMessage (chatGroupMessageId) ON DELETE CASCADE
    );

-- SEEN MESSAGES TO BE
-- IMPLEMENTED LATER

CREATE TABLE IF NOT EXISTS Playground
(
    pgId        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    createdBy   UUID NOT NULL,
    chatGroupId UUID NOT NULL,
    pgType      varchar,
    pgPicUrl    varchar,
    pgName      varchar,
    pgDesc      varchar,
    FOREIGN KEY (createdBy) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (chatGroupId) REFERENCES ChatGroup (chatGroupId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgPartner
(
    pgPartnerId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pgId        UUID    NOT NULL,
    pgCategory  varchar NOT NULL,
    FOREIGN KEY (pgId) REFERENCES Playground (pgId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgProfile
(
    s3Id             UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    entityObjectType varchar,
    extension        varchar,
    pgId             UUID REFERENCES Playground (pgId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PG_OfferedAnswer
(
    offeredResponseId   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    questionId          UUID NOT NULL,
    userId              UUID NOT NULL,
    pgId                UUID NOT NULL,
    responseChoiceId    UUID NOT NULL,
    updatedAt           timestamptz      DEFAULT (now()),
    heuristicMultiplier int              DEFAULT 1,
    FOREIGN KEY (questionId) REFERENCES MF_Question (questionId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (pgId) REFERENCES Playground (pgId) ON DELETE CASCADE,
    FOREIGN KEY (responseChoiceId) REFERENCES MF_ResponseChoice (responseChoiceId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgMember
(
    pgMemberId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pgId       UUID NOT NULL,
    userId     UUID NOT NULL,
    FOREIGN KEY (pgId) REFERENCES Playground (pgId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgBulletin
(
    pgBulletinId   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pgId           UUID    NOT NULL,
    createdBy      UUID    NOT NULL,
    bulletinTitle  varchar NOT NULL,
    bulletinBody   varchar,
    createdAt      timestamptz      DEFAULT (now()),
    updatedAt      timestamptz      DEFAULT (now()),
    pgBulletinType varchar NOT NULL,
    imgUrl         varchar,
    vidUrl         varchar,
    bulletinUrl    varchar,
    shareLink      varchar,
    FOREIGN KEY (pgId) REFERENCES Playground (pgId) ON DELETE CASCADE,
    FOREIGN KEY (createdBy) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgBulletinProfile
(
    s3Id         UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    mimeType     varchar,
    extension    varchar,
    pgBulletinId UUID REFERENCES PgBulletin (pgBulletinId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgBulletinComment
(
    pgCommentId     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parentCommentId UUID,
    pgBulletinId    UUID NOT NULL,
    createdBy       UUID NOT NULL,
    commentBody     varchar,
    createdAt       timestamptz      DEFAULT (now()),
    updatedAt       timestamptz      DEFAULT (now()),
    FOREIGN KEY (pgBulletinId) REFERENCES PgBulletin (pgBulletinId) ON DELETE CASCADE,
    FOREIGN KEY (createdBy) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (parentCommentId) REFERENCES PgBulletinComment (pgCommentId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgBulletinScore
(
    pgBulletinScoreId UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    pgBulletinId      UUID             NOT NULL,
    userId            UUID             NOT NULL,
    postValue         int,
    FOREIGN KEY (pgBulletinId) REFERENCES PgBulletin (pgBulletinId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgCommentScore
(
    pgCommentScoreId UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    pgCommentId      UUID             NOT NULL,
    userId           UUID             NOT NULL,
    commentValue     int,
    FOREIGN KEY (pgCommentId) REFERENCES PgBulletinComment (pgCommentId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgLeaderboard
(
    pgLeaderboardId        UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    pgId                   UUID             NOT NULL,
    leaderboardName        varchar          NOT NULL,
    leaderboardDescription varchar,
    FOREIGN KEY (pgId) REFERENCES Playground (pgId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgLeaderboardMember
(
    pgLeaderboardMemberId UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    pgLeaderboardId       UUID             NOT NULL,
    userId                UUID             NOT NULL,
    rank                  int              NOT NULL,
    score                 varchar          NOT NULL,
    UNIQUE (pgLeaderboardId, rank),
    FOREIGN KEY (pgLeaderboardId) REFERENCES PgLeaderboard (pgLeaderboardId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

DO
$$
BEGIN
CREATE TYPE PgEventType AS ENUM ('calendar', 'poll');
EXCEPTION
        WHEN duplicate_object THEN null;
END
$$;

CREATE TABLE IF NOT EXISTS PgEvent
(
    eventId          UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    pgId             UUID             NOT NULL,
    createdBy        UUID             NOT NULL,
    eventType        varchar          NOT NULL,
    eventTitle       varchar          NOT NULL,
    eventDescription VARCHAR,
    eventPhotosUrl   VARCHAR,
    startTime        timestamptz      NOT NULL DEFAULT (NOW()),
    endTime          timestamptz,
    FOREIGN KEY (pgId) REFERENCES Playground (pgId) ON DELETE CASCADE,
    FOREIGN KEY (createdBy) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgEventProfile
(
    s3Id      UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    mimeType  varchar,
    extension varchar,
    eventId UUID,
    FOREIGN KEY (eventId) REFERENCES PgEvent (eventId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgEventMember
(
    pgEventMembersId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eventId          UUID NOT NULL,
    userId           UUID NOT NULL,
    FOREIGN KEY (eventId) REFERENCES PgEvent (eventId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgEventPollResponseChoice
(
    responseChoiceId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eventId          UUID NOT NULL,
    responseText     VARCHAR,
    FOREIGN KEY (eventId) REFERENCES PgEvent (eventId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS PgEventPollVotedAnswer
(
    offeredResponseId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eventId           UUID NOT NULL,
    userId            UUID NOT NULL,
    responseChoiceId  UUID NOT NULL,
    updatedAt         timestamptz      DEFAULT (NOW()),
    FOREIGN KEY (eventId) REFERENCES PgEvent (eventId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (responseChoiceId) REFERENCES PgEventPollResponseChoice (responseChoiceId) ON DELETE CASCADE
    );


-- pro-matchmaking
CREATE TABLE IF NOT EXISTS Traits(
    traitId        UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
    traitName      varchar(30)    NOT NULL
    );

CREATE TABLE IF NOT EXISTS UserTrait(
                                        userId                  UUID NOT NULL,
                                        traitId                 UUID NOT NULL,
                                        PRIMARY KEY(userId, traitId),
    traitCreateDate         timestamptz             DEFAULT (now()),
    FOREIGN KEY (userId)    REFERENCES Users (userId) ON DELETE CASCADE,
    FOREIGN KEY (traitId)   REFERENCES Traits (traitId) ON DELETE CASCADE
    );


-- Table For pro-matchmaking
CREATE TABLE IF NOT EXISTS Traits(
                                     traitId        UUID PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
                                     traitName      varchar(30)    NOT NULL,
                                     traitdetails  varchar (30)
);

CREATE TABLE IF NOT EXISTS UserTrait(
                                        userId                  UUID NOT NULL,
                                        traitId                 UUID NOT NULL,
                                        PRIMARY KEY(userId, traitId),
                                        traitCreateDate         timestamptz             DEFAULT (now()),
                                        FOREIGN KEY (userId)    REFERENCES Users (userId) ON DELETE CASCADE,
                                        FOREIGN KEY (traitId)   REFERENCES Traits (traitId) ON DELETE CASCADE
);
