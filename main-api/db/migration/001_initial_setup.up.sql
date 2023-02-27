CREATE TABLE IF NOT EXISTS `subjects`
(
    `id`            int                                                           NOT NULL AUTO_INCREMENT,
    `slug`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `name`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `description`   text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NOT NULL,
    `category`      enum ('all','primary','junior','senior','primary-junior','secondary') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'all',
    `image`         text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Subject image',
    `status`        int                                                           NOT NULL                                                 DEFAULT '1',
    `school_id`     int                                                                                                                    DEFAULT NULL,
    `approved`      int                                                           NOT NULL                                                 DEFAULT '0',
    `approved_by`   int                                                                                                                    DEFAULT NULL,
    `diagnostic`    int                                                                                                                    DEFAULT '0' COMMENT 'If 1, It means the subject should be available for diagnostic',
    `text_to_voice` int                                                                                                                    DEFAULT '0' COMMENT 'If the read_to_me should be enabled or not.',
    `summer_school` tinyint                                                                                                                DEFAULT '0',
    `created_at`    timestamp                                                     NOT NULL                                                 DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    timestamp                                                     NULL                                                     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `department`    enum ('science','commercial','art') COLLATE utf8mb4_unicode_ci                                                         DEFAULT NULL,
    `creator_id`    int                                                                                                                    DEFAULT NULL COMMENT 'Id of the user who created it',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subject_topics`
(
    `id`           int                                                                              NOT NULL AUTO_INCREMENT,
    `subject_id`   int                                                                              NOT NULL,
    `creator_id`   int                                                                                       DEFAULT NULL,
    `class_id`     int                                                                                       DEFAULT NULL,
    `school_id`    int                                                                                       DEFAULT NULL,
    `slug`         varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                    NOT NULL,
    `topic`        varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                    NOT NULL,
    `description`  mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `week_number`  smallint                                                                         NOT NULL COMMENT 'It contains numbers. 1 stands for week one, 5 stands for week 5',
    `term`         enum ('first','second','third') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `exam_type_id` int                                                                              NOT NULL,
    `image`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `status`       int                                                                              NOT NULL DEFAULT '1',
    `created_at`   timestamp                                                                        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `subject_id` (`subject_id`),
    CONSTRAINT `subject_topics_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `academy_calendar`
(
    `id`                int                                                          NOT NULL AUTO_INCREMENT,
    `session`           varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `title`             varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `first_term_start`  date                                                         NOT NULL,
    `first_term_end`    date                                                         NOT NULL,
    `second_term_start` date                                                         NOT NULL,
    `second_term_end`   date                                                         NOT NULL,
    `third_term_start`  date                                                         NOT NULL,
    `third_term_end`    date                                                         NOT NULL,
    `year`              varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `status`            tinyint                                                           DEFAULT '1',
    `created_at`        timestamp                                                    NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`        timestamp                                                    NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user`
(
    `id`                   int                                                                                                   NOT NULL AUTO_INCREMENT,
    `username`             varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                  DEFAULT NULL,
    `code`                 varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                   DEFAULT NULL,
    `firstname`            varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                   DEFAULT NULL,
    `lastname`             varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                   DEFAULT NULL,
    `phone`                varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                   DEFAULT NULL,
    `image`                varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                  DEFAULT NULL,
    `type`                 enum ('student','teacher','parent','school','tutor') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `auth_key`             varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                          NOT NULL,
    `password_hash`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                         NOT NULL,
    `password_reset_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                  DEFAULT NULL,
    `email`                varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                  DEFAULT NULL,
    `class`                int                                                                                                            DEFAULT NULL COMMENT 'This is student temporary class while the child is yet to be connected to school',
    `status`               smallint                                                                                              NOT NULL DEFAULT '10' COMMENT '10 for active, 9 for inactive and 0 for deleted',
    `subscription_expiry`  datetime                                                                                                       DEFAULT NULL,
    `subscription_plan`    enum ('free','trial','basic','premium') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                       DEFAULT NULL,
    `created_at`           int                                                                                                   NOT NULL,
    `updated_at`           int                                                                                                   NOT NULL,
    `verification_token`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                  DEFAULT NULL,
    `oauth_provider`       enum ('facebook','google','twitter') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                          DEFAULT NULL,
    `token`                text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `token_expires`        datetime                                                                                                       DEFAULT NULL,
    `oauth_uid`            varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                  DEFAULT NULL,
    `last_accessed`        timestamp                                                                                             NULL     DEFAULT NULL COMMENT 'Last time the website was accessed',
    `is_boarded`           int                                                                                                   NOT NULL DEFAULT '0',
    `mode`                 enum ('practice','exam','topic','summer') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                     DEFAULT 'practice' COMMENT 'This is used to know if student is in catchup practice or exam mode, or topics',
    `verification_status`  tinyint                                                                                                        DEFAULT '0' COMMENT 'This holds the account verification status',
    `department`           enum ('science','commercial','art') COLLATE utf8mb4_unicode_ci                                                 DEFAULT NULL,
    `wallet`               double(10, 2)                                                                                                  DEFAULT '0.00',
    `device_id`            varchar(100) COLLATE utf8mb4_unicode_ci                                                                        DEFAULT NULL COMMENT 'Firebase issued id for mobile device',
    PRIMARY KEY (`id`),
    UNIQUE KEY `email` (`email`),
    UNIQUE KEY `username` (`username`),
    UNIQUE KEY `password_reset_token` (`password_reset_token`),
    KEY `phone` (`phone`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This holds information of gradely users.';

CREATE TABLE IF NOT EXISTS `account_verification_log`
(
    `id`          int                                                          NOT NULL AUTO_INCREMENT,
    `user_id`     int                                                          NOT NULL,
    `channel`     enum ('email','phone') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `code`        varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `code_expiry` datetime                                                     NOT NULL,
    `token`       varchar(255) COLLATE utf8mb4_unicode_ci                                 DEFAULT NULL COMMENT 'This is used to validate user verification',
    `type`        enum ('account','password','contact') COLLATE utf8mb4_unicode_ci        DEFAULT NULL COMMENT 'If the code is for account verification, password reset or contact verification.',
    `created_at`  timestamp                                                    NULL       DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                                                    NULL       DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `token_UNIQUE` (`token`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `admin_sent_email`
(
    `id`             int       NOT NULL AUTO_INCREMENT,
    `admin_id`       int       NOT NULL COMMENT 'The person sending the email',
    `receiver_id`    int                                                           DEFAULT NULL COMMENT 'Registered user receiving the email',
    `receiver_name`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `receiver_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `subject`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email subject',
    `body`           text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Email body',
    `created_at`     timestamp NULL                                                DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `articles`
(
    `id`                   int                                                     NOT NULL AUTO_INCREMENT,
    `title`                varchar(100) COLLATE utf8mb4_unicode_ci                 NOT NULL COMMENT 'Title of the article\n',
    `subtitle`             varchar(200) COLLATE utf8mb4_unicode_ci                          DEFAULT NULL COMMENT 'Additional text content for the article',
    `group_id`             varchar(100) COLLATE utf8mb4_unicode_ci                          DEFAULT NULL COMMENT 'String id for identifying the group an article belongs to',
    `creator_id`           int                                                     NOT NULL COMMENT 'The creator of the article',
    `image`                varchar(200) COLLATE utf8mb4_unicode_ci                          DEFAULT NULL,
    `body`                 varchar(500) COLLATE utf8mb4_unicode_ci                          DEFAULT NULL,
    `reciever_types`       json                                                             DEFAULT NULL COMMENT 'json array of types of receivers, they include school, student, teacher, and parent',
    `destination_type`     enum ('internal','external') COLLATE utf8mb4_unicode_ci NOT NULL,
    `reference_link`       varchar(300) COLLATE utf8mb4_unicode_ci                          DEFAULT NULL COMMENT 'Link used to reference the location of the article',
    `visibility_open_date` timestamp                                               NULL     DEFAULT NULL COMMENT 'Open date for the visibility of the article',
    `visibility_end_date`  timestamp                                               NULL     DEFAULT NULL COMMENT 'Close date for the visibility of the article',
    `created_at`           timestamp                                               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           timestamp                                               NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `avatar`
(
    `id`          int                                                   NOT NULL AUTO_INCREMENT,
    `image`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `name`        varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   DEFAULT NULL,
    `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `status`      int                                                            DEFAULT '1',
    `created_at`  timestamp                                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                                             NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `banners`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `admin_id`   int       NOT NULL COMMENT 'The person that posted it',
    `title`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Title of the banner',
    `image`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'This is the name or full url of the image',
    `link`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Where you will be redirected to when you click on the email.',
    `type`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  DEFAULT 'catchup' COMMENT 'How to classify where the image will show',
    `created_at` timestamp NULL                                                DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL                                                DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `campaign_live_class`
(
    `id`           int                                                           NOT NULL AUTO_INCREMENT,
    `tutor_name`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
    `tutor_image`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `tutor_email`  varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
    `tutor_access` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                        DEFAULT NULL,
    `class_name`   varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `start_at`     timestamp                                                     NULL                                  DEFAULT CURRENT_TIMESTAMP,
    `ended_at`     timestamp                                                     NULL                                  DEFAULT NULL,
    `status`       enum ('pending','ongoing','completed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
    `class`        int                                                                                                 DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `catchup`
(
    `id`             int                                                                           NOT NULL AUTO_INCREMENT,
    `student_id`     int                                                                           NOT NULL,
    `subject_id`     int                                                                           NOT NULL DEFAULT '1',
    `exam_type_id`   int                                                                                    DEFAULT NULL,
    `class_id`       int                                                                                    DEFAULT NULL,
    `school_id`      int                                                                                    DEFAULT NULL,
    `question_count` int                                                                           NOT NULL COMMENT 'how many question to be attempted',
    `duration`       int                                                                           NOT NULL DEFAULT '0' COMMENT 'duration is in minutes',
    `type`           enum ('catchup','diagnosis') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'catchup',
    `generator_id`   int                                                                                    DEFAULT NULL COMMENT 'i''m using "generator_id" instead of "parent_id" to avoid restriction incase teachers will be allowed to generate catchup/diagnostic test.',
    `status`         int                                                                           NOT NULL DEFAULT '0' COMMENT '0 means incomplete and 1 means completed',
    `created_at`     timestamp                                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `catchup_difficulty`
(
    `id`         int                                                                            NOT NULL AUTO_INCREMENT,
    `catchup_id` int                                                                            NOT NULL,
    `difficulty` enum ('easy','medium','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'hard',
    `created_at` timestamp                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `catchup_id` (`catchup_id`),
    CONSTRAINT `catchup_difficulty_ibfk_1` FOREIGN KEY (`catchup_id`) REFERENCES `catchup` (`id`) ON DELETE CASCADE,
    CONSTRAINT `catchup_difficulty_ibfk_2` FOREIGN KEY (`catchup_id`) REFERENCES `catchup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `catchup_questions`
(
    `id`          int                                                                            NOT NULL AUTO_INCREMENT,
    `quiz_id`     int                                                                            NOT NULL,
    `question_id` int                                                                            NOT NULL,
    `difficulty`  enum ('easy','medium','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `duration`    int                                                                            NOT NULL,
    `created_at`  timestamp                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `quiz_id` (`quiz_id`),
    CONSTRAINT `catchup_questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `catchup` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `catchup_topics`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `catchup_id` int       NOT NULL,
    `topic_id`   int       NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `catchup_id` (`catchup_id`),
    KEY `topic_id` (`topic_id`),
    CONSTRAINT `catchup_topics_ibfk_2` FOREIGN KEY (`catchup_id`) REFERENCES `catchup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `catchup_topics_ibfk_3` FOREIGN KEY (`topic_id`) REFERENCES `subject_topics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cities`
(
    `id`         int          NOT NULL AUTO_INCREMENT,
    `state`      varchar(100) NOT NULL,
    `alias`      varchar(100) NOT NULL,
    `name`       varchar(100) NOT NULL,
    `country`    varchar(100) NOT NULL,
    `created_at` timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = latin1
  ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `tutor_session`
(
    `id`               int                                                                                                 NOT NULL AUTO_INCREMENT,
    `requester_id`     int                                                                                                 NOT NULL,
    `student_id`       int                                                                                                          DEFAULT NULL,
    `title`            varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                DEFAULT NULL,
    `repetition`       enum ('once','daily','workdays','weekly') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          NOT NULL DEFAULT 'once',
    `class`            int                                                                                                          DEFAULT NULL,
    `subject_id`       int                                                                                                          DEFAULT NULL,
    `session_count`    int                                                                                                 NOT NULL DEFAULT '1',
    `curriculum_id`    int                                                                                                          DEFAULT NULL,
    `category`         varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                        NOT NULL COMMENT 'Either paid, covid19 or class',
    `availability`     datetime                                                                                                     DEFAULT NULL,
    `is_school`        int                                                                                                 NOT NULL DEFAULT '0',
    `preferred_client` enum ('zoom','daily','jitsi','bbb') COLLATE utf8mb4_unicode_ci                                               DEFAULT 'bbb',
    `meeting_token`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'For daily.co, this is used to set the host',
    `meeting_room`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                DEFAULT NULL COMMENT 'this is use to determine the room for this class',
    `meta`             text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Any additional data',
    `participant_type` enum ('single','multiple') COLLATE utf8mb4_unicode_ci                                                        DEFAULT 'multiple' COMMENT 'If type is single, it means it is for one student, if it is multiple, it means it is for multiple students and their id are stored in tutor_session_participant',
    `status`           enum ('pending','ongoing','completed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
    `extra_meta`       json                                                                                                         DEFAULT NULL,
    `created_at`       timestamp                                                                                           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `session_ended`    timestamp                                                                                           NULL     DEFAULT NULL COMMENT 'When the meeting ends',
    `recording`        json                                                                                                         DEFAULT NULL COMMENT 'This is the object from the recording',
    `payment`          enum ('free','paid') COLLATE utf8mb4_unicode_ci                                                              DEFAULT NULL,
    `amount`           double(10, 2)                                                                                                DEFAULT NULL COMMENT 'This is the amount of the service',
    `currency`         enum ('NGN','USD') COLLATE utf8mb4_unicode_ci                                                                DEFAULT NULL,
    `topic_id`         int                                                                                                          DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `class_attendance`
(
    `id`             int       NOT NULL AUTO_INCREMENT,
    `session_id`     int       NOT NULL,
    `user_id`        int       NOT NULL COMMENT 'id of user attending a meeting',
    `type`           enum ('host','attendee') DEFAULT NULL,
    `token`          text COMMENT 'Meeting token used to join the session',
    `joined_at`      timestamp NOT NULL       DEFAULT CURRENT_TIMESTAMP,
    `joined_updated` timestamp NULL           DEFAULT NULL,
    `ended_at`       timestamp NULL           DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `session_id` (`session_id`),
    CONSTRAINT `class_attendance_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `tutor_session` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `class_subject_unenrolled`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `class_id`   int                DEFAULT NULL,
    `subject_id` int                DEFAULT NULL,
    `student_id` int       NOT NULL,
    `removed_by` int       NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL     DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `schools`
(
    `id`                      int                                                                              NOT NULL AUTO_INCREMENT,
    `user_id`                 int                                                                                       DEFAULT NULL,
    `slug`                    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                    NOT NULL,
    `name`                    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `abbr`                    varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                     NOT NULL,
    `logo`                    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `banner`                  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `wallpaper`               varchar(255) COLLATE utf8mb4_unicode_ci                                                   DEFAULT NULL,
    `tagline`                 varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `about`                   text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `address`                 varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `city`                    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `state`                   varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `country`                 varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `postal_code`             varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `website`                 varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `establish_date`          varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `contact_name`            varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `contact_role`            varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `contact_email`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `contact_image`           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `phone`                   varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `phone2`                  varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `school_email`            varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `school_type`             varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `created_at`              timestamp                                                                        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`              timestamp                                                                        NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `naming_format`           enum ('year','ss','montessori') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'year' COMMENT 'SS is primary, junior and senior secondary school naming format. Yeah is for year1 to year12.',
    `timezone`                varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `boarding_type`           varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `subscription_plan`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              DEFAULT NULL,
    `subscription_expiry`     timestamp                                                                        NULL     DEFAULT NULL,
    `basic_subscription`      int                                                                                       DEFAULT '0' COMMENT 'Basic license count',
    `premium_subscription`    int                                                                                       DEFAULT '0' COMMENT 'Premium license count',
    `teacher_auto_join_class` tinyint                                                                                   DEFAULT '1' COMMENT 'Allow teacher to join school class automatically',
    `student_auto_join_class` tinyint                                                                                   DEFAULT '1' COMMENT 'Allow student to join school class automatically',
    `is_tutor`                int                                                                                       DEFAULT NULL COMMENT 'Is this school is a tutor school',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `global_class`
(
    `id`          int                                                          NOT NULL AUTO_INCREMENT,
    `class_id`    varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `status`      int                                                          NOT NULL DEFAULT '0',
    `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `classes`
(
    `id`              int                                                           NOT NULL AUTO_INCREMENT,
    `school_id`       int                                                                    DEFAULT NULL COMMENT 'school_id is Null if there is no school but there is a teacher class',
    `creator_id`      int                                                                    DEFAULT NULL COMMENT 'For teacher who does not belong to any school',
    `global_class_id` int                                                           NOT NULL,
    `slug`            varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `class_name`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g Senior secondary School 1',
    `abbreviation`    varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
    `class_code`      varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT 'e.g HBY/SSS1',
    `created_at`      timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      timestamp                                                     NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `class_code` (`class_code`),
    KEY `global_class_id` (`global_class_id`),
    KEY `school_id` (`school_id`),
    CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`global_class_id`) REFERENCES `global_class` (`id`) ON DELETE CASCADE,
    CONSTRAINT `classes_ibfk_2` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE,
    CONSTRAINT `classes_ibfk_3` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `class_subjects`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `subject_id` int       NOT NULL,
    `class_id`   int       NOT NULL,
    `school_id`  int       NOT NULL,
    `status`     int       NOT NULL DEFAULT '1',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `class_id` (`class_id`),
    KEY `school_id` (`school_id`),
    KEY `subject_id` (`subject_id`),
    CONSTRAINT `class_subjects_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
    CONSTRAINT `class_subjects_ibfk_3` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `class_subjects_ibfk_4` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `comprehension`
(
    `id`         int          NOT NULL AUTO_INCREMENT,
    `title`      varchar(200) NOT NULL,
    `body`       text         NOT NULL,
    `status`     int          NOT NULL DEFAULT '1',
    `topic_id`   int                   DEFAULT NULL,
    `citation`   varchar(255)          DEFAULT NULL,
    `created_by` int          NOT NULL,
    `updated_by` int                   DEFAULT NULL,
    `created_at` timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `content_management_backup`
(
    `id`               int                                                           NOT NULL AUTO_INCREMENT,
    `staff_id`         int                                                           NOT NULL,
    `previous_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `new_content`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `action_name`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g create, update, delete',
    `created_at`       timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `content_review`
(
    `id`          int                                                          NOT NULL AUTO_INCREMENT,
    `content_id`  int                                                          NOT NULL,
    `type`        enum ('question','topic','video') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'question',
    `reviewer_id` int                                                          NOT NULL,
    `status`      int                                                                   DEFAULT NULL,
    `created_at`  timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                                                    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `country`
(
    `id`       int                                                           NOT NULL AUTO_INCREMENT,
    `sortname` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL,
    `name`     varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `slug`     varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `slug` (`slug`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `coupon`
(
    `id`                  int                                                                                             NOT NULL AUTO_INCREMENT,
    `code`                varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                    NOT NULL COMMENT 'The coupon code',
    `percentage`          int                                                                                             NOT NULL COMMENT 'The percentage of the coupon',
    `is_time_bound`       varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                    NOT NULL DEFAULT '0' COMMENT '0 means this coupon doesn’t have time limit',
    `start_time`          varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                             DEFAULT NULL COMMENT 'When coupon should be open to use',
    `end_time`            varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                             DEFAULT NULL COMMENT 'When usage should end',
    `coupon_payment_type` enum ('all','catchup','tutor','summer_school') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all' COMMENT 'All means it can be used for catchup or tutor, and their respective type',
    `status`              int                                                                                                      DEFAULT '1' COMMENT '1 means it is valid, 0 means it has been disabled',
    `created_at`          timestamp                                                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`          timestamp                                                                                       NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `created_by`          int                                                                                                      DEFAULT NULL,
    `updated_by`          int                                                                                                      DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cron_reference`
(
    `id`             int                                                                                                      NOT NULL AUTO_INCREMENT,
    `type`           enum ('weekly_class_report','homework_recommendations') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `json_data`      json                                                                                                              DEFAULT NULL,
    `class_id`       int                                                                                                               DEFAULT NULL,
    `subject_id`     int                                                                                                               DEFAULT NULL,
    `reference_data` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                     DEFAULT NULL,
    `created_at`     timestamp                                                                                                NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     timestamp                                                                                                NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `deleted_account`
(
    `id`                   int                                                                                           NOT NULL AUTO_INCREMENT,
    `user_id`              int                                                                                           NOT NULL,
    `username`             varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                          DEFAULT NULL,
    `firstname`            varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                           DEFAULT NULL,
    `lastname`             varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                           DEFAULT NULL,
    `phone`                varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                           DEFAULT NULL,
    `image`                varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                          DEFAULT NULL,
    `type`                 enum ('student','teacher','parent','school') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `auth_key`             varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                  NOT NULL,
    `password_hash`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                 NOT NULL,
    `password_reset_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                          DEFAULT NULL,
    `email`                varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                 NOT NULL,
    `gender`               enum ('female','male') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                DEFAULT NULL,
    `dob`                  smallint                                                                                               DEFAULT NULL COMMENT 'day of birth',
    `mob`                  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                           DEFAULT NULL COMMENT 'month of birth',
    `yob`                  smallint                                                                                               DEFAULT NULL COMMENT 'year of birth',
    `status`               smallint                                                                                      NOT NULL DEFAULT '10' COMMENT '10 for active, 9 for inactive and 0 for deleted',
    `created_at`           int                                                                                           NOT NULL,
    `updated_at`           int                                                                                           NOT NULL,
    `verification_token`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                          DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `email` (`email`),
    UNIQUE KEY `username` (`username`),
    UNIQUE KEY `password_reset_token` (`password_reset_token`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `event`
(
    `id`          int                                                           NOT NULL AUTO_INCREMENT,
    `title`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'This is the title of the event',
    `sub_title`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci      DEFAULT NULL COMMENT 'Incase there is a shorter description',
    `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `link`        text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'This is for external link of event',
    `images`      json                                                               DEFAULT NULL COMMENT 'This is json data type and it accept multiple image link',
    `videos`      json                                                               DEFAULT NULL COMMENT 'This is json data type and it accept multiple video link',
    `location`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci      DEFAULT NULL COMMENT 'Maybe online or physical address',
    `organiser`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci      DEFAULT NULL COMMENT 'Name of the organiser',
    `start_date`  timestamp                                                     NULL DEFAULT NULL COMMENT 'When the event starts',
    `end_date`    timestamp                                                     NULL DEFAULT NULL COMMENT 'When the event ends',
    `created_by`  int                                                           NOT NULL,
    `updated_by`  int                                                                DEFAULT NULL,
    `created_at`  timestamp                                                     NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                                                     NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `exam_type`
(
    `id`          int                                                           NOT NULL AUTO_INCREMENT,
    `slug`        varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `name`        varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `title`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NOT NULL,
    `general`     tinyint                                                       NOT NULL DEFAULT '0' COMMENT 'General is 1 if the curriculum should be checked on school setup',
    `country`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `school_id`   int                                                                    DEFAULT NULL,
    `approved`    int                                                           NOT NULL DEFAULT '0' COMMENT 'If approved is one, it means it should be available for every school on the platform',
    `approved_by` int                                                                    DEFAULT NULL COMMENT 'ID of the admin that approved it',
    `is_exam`     int                                                                    DEFAULT '0',
    `is_catchup`  tinyint                                                                DEFAULT '0' COMMENT 'To determine if the topics and questions should be available in catchup',
    `class`       enum ('primary','junior','senior') COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `created_at`  timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                                                     NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `exam_subjects`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `exam_id`    int                                                          DEFAULT NULL,
    `subject_id` int                                                          DEFAULT NULL,
    `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `updated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `created_at` timestamp NULL                                               DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL                                               DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `exam_subjects__exam_idx` (`exam_id`),
    KEY `exam_subjects__subjects_idx` (`subject_id`),
    CONSTRAINT `exam_subjects__exam` FOREIGN KEY (`exam_id`) REFERENCES `exam_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `exam_subjects__subjects` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='Lists of exams that has specific subjects';

CREATE TABLE IF NOT EXISTS `feature_user_logger`
(
    `id`         int                                                                                                 NOT NULL AUTO_INCREMENT,
    `name`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                        NOT NULL,
    `user_id`    int                                                                                                 NOT NULL,
    `type`       enum ('all','school','teacher','parent','student') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `value`      varchar(100) COLLATE utf8mb4_unicode_ci                                                                  DEFAULT NULL,
    `created_at` timestamp                                                                                           NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `feed`
(
    `id`              int                                                           NOT NULL AUTO_INCREMENT,
    `user_id`         int                                                           NOT NULL,
    `reference_id`    int                                                                                                                                                                    DEFAULT NULL COMMENT 'it is a post created for homework or live class or any other activities that is not just a plain text post.',
    `subject_id`      varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                                                                           DEFAULT NULL COMMENT 'If the post is related to a subject',
    `description`     mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'This is body of post',
    `type`            enum ('post','announcement','homework','lesson','live_class','poll','article','recommendation','performance','share') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Post is plain text, homework is homework related post, lesson is live class, recommendation is for recommendation post',
    `likes`           int                                                                                                                                                                    DEFAULT NULL,
    `token`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Is a unique string for each post. Case be used to share or access post.',
    `class_id`        int                                                                                                                                                                    DEFAULT NULL COMMENT 'class_id from classes table.',
    `global_class_id` int                                                                                                                                                                    DEFAULT NULL,
    `view_by`         enum ('all','school','teacher','class','parent','student') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                            DEFAULT NULL COMMENT 'Who can see it. school means all member of school, teacher, student, parent. \\nTeacher means teachers in class only. \\nClass means teachers, students and parents in class. \\nParent means parents of students in a class only. Student on teacher end means to be seen by student only.',
    `views`           int                                                                                                                                                                    DEFAULT '0',
    `status`          int                                                           NOT NULL                                                                                                 DEFAULT '1' COMMENT '1 means post can be seem, 0 means post should not be seen.',
    `created_at`      timestamp                                                     NOT NULL                                                                                                 DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      timestamp                                                     NULL                                                                                                     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `tag`             enum ('text','image','video','document','game','recommendation') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                      DEFAULT NULL,
    `admin_id`        int                                                                                                                                                                    DEFAULT NULL COMMENT 'If the event was created by admin',
    `term`            enum ('first','second','third') COLLATE utf8mb4_unicode_ci                                                                                                             DEFAULT NULL COMMENT 'Term record was created',
    PRIMARY KEY (`id`),
    UNIQUE KEY `token_UNIQUE` (`token`),
    KEY `feed_global_class_idx` (`global_class_id`),
    CONSTRAINT `feed_ibfk_1` FOREIGN KEY (`global_class_id`) REFERENCES `global_class` (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This holds the feeds to be seen among all types of user.';

CREATE TABLE IF NOT EXISTS `feed_comment`
(
    `id`         int                                                                                         NOT NULL AUTO_INCREMENT,
    `feed_id`    int                                                                                         NOT NULL COMMENT 'This serves as feed_id, video_id, comment_id',
    `user_id`    int                                                                                         NOT NULL,
    `comment`    mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                 NOT NULL,
    `type`       enum ('feed','video','comment','document') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'feed' COMMENT 'This is a comment to feed, video and reply to comment',
    `attachment` text COLLATE utf8mb4_unicode_ci COMMENT 'This is comment attachment',
    `status`     int                                                                                         NOT NULL DEFAULT '1',
    `created_at` timestamp                                                                                   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp                                                                                   NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `feed_like`
(
    `id`         int                                                                                                        NOT NULL AUTO_INCREMENT,
    `parent_id`  int                                                                                                        NOT NULL,
    `user_id`    int                                                                                                        NOT NULL,
    `type`       enum ('feed','comment','video','reply','game','document') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `status`     int                                                                                                        NOT NULL DEFAULT '1' COMMENT '1 mean like, 0 means dislike',
    `created_at` timestamp                                                                                                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp                                                                                                  NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='Manages the user likes on every post';

CREATE TABLE IF NOT EXISTS `file_log`
(
    `id`               int                                                                               NOT NULL AUTO_INCREMENT,
    `user_id`          int                                                                               NOT NULL,
    `file_id`          int                                                                                        DEFAULT NULL,
    `file_url`         text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `type`             enum ('video','document','game') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'video' COMMENT 'This is to know the type of file.',
    `subject_id`       int                                                                                        DEFAULT NULL,
    `topic_id`         int                                                                                        DEFAULT NULL,
    `class_id`         int                                                                                        DEFAULT NULL,
    `total_duration`   varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                               DEFAULT NULL,
    `current_duration` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                               DEFAULT NULL,
    `is_completed`     int                                                                                        DEFAULT '0',
    `source`           enum ('catchup','feed') COLLATE utf8mb4_unicode_ci                                         DEFAULT 'catchup' COMMENT 'This is for source of the video that is getting logged',
    `created_at`       timestamp                                                                         NULL     DEFAULT CURRENT_TIMESTAMP,
    `updated_at`       timestamp                                                                         NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This is activities of videos and other file type. It can be used to monitor opened file, and other user traces';

CREATE TABLE IF NOT EXISTS `homeworks`
(
    `id`                      int                                                                                                                            NOT NULL AUTO_INCREMENT,
    `student_id`              int                                                                                                                                     DEFAULT NULL,
    `teacher_id`              int                                                                                                                                     DEFAULT NULL,
    `subject_id`              int                                                                                                                            NOT NULL,
    `class_id`                int                                                                                                                                     DEFAULT NULL,
    `school_id`               int                                                                                                                                     DEFAULT NULL,
    `exam_type_id`            int                                                                                                                                     DEFAULT NULL COMMENT 'It is null by default but the curriculum should be update at the point of updating questions or publishing practice.',
    `slug`                    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                                  NOT NULL,
    `title`                   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                                  NOT NULL,
    `description`             text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `topic_id`                int                                                                                                                                     DEFAULT NULL,
    `curriculum_id`           int                                                                                                                            NOT NULL,
    `access_status`           enum ('active','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                      NOT NULL DEFAULT 'active',
    `open_date`               datetime                                                                                                                                DEFAULT NULL,
    `close_date`              datetime                                                                                                                                DEFAULT NULL,
    `duration`                int                                                                                                                                     DEFAULT NULL COMMENT 'Duration should be in minutes ',
    `type`                    enum ('homework','practice','diagnostic','recommendation','catchup','lesson') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'homework' COMMENT 'Homework is students regular take home. Practice is students self created assessment. Diagnostic is an auto-generated assessment to know the level of the child. Recommendation is a suggested/recommended practice/material/videos to help improve their level of knowledge. Catchup is a gamified practice. Lesson is a material created by teacher for student to learn.',
    `tag`                     enum ('homework','exam','quiz') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                        DEFAULT NULL COMMENT 'Tag is used to identify homework sub category. Maybe it is an homework, quiz or exam',
    `status`                  int                                                                                                                            NOT NULL DEFAULT '1',
    `review_status`           tinyint                                                                                                                                 DEFAULT NULL COMMENT 'Null means, it has not been reviewed, 0 means it was rejected, 1 means it has been approved',
    `reviewed_by`             int                                                                                                                                     DEFAULT NULL,
    `reference_type`          enum ('homework','catchup','recommendation','class','daily') COLLATE utf8mb4_unicode_ci                                                 DEFAULT NULL,
    `reference_id`            int                                                                                                                                     DEFAULT NULL,
    `selected_student`        int                                                                                                                                     DEFAULT '0' COMMENT 'If 0, all student in the class will participate it, else, only selected student will participate.',
    `bulk_creation_reference` varchar(50) COLLATE utf8mb4_unicode_ci                                                                                                  DEFAULT NULL COMMENT 'When you select multiple classes, this will be used to identify the group',
    `is_custom_topic`         int                                                                                                                                     DEFAULT '0' COMMENT '0 means the topics is from subject_topics, 1 means the question is created while in custom curriculum in school and the topic is from school_topic',
    `is_proctor`              int                                                                                                                                     DEFAULT '0',
    `mode`                    enum ('practice','exam') COLLATE utf8mb4_unicode_ci                                                                                     DEFAULT 'practice',
    `session`                 varchar(50) COLLATE utf8mb4_unicode_ci                                                                                                  DEFAULT NULL COMMENT 'Session which the homework was created',
    `publish_status`          int                                                                                                                            NOT NULL DEFAULT '0',
    `publish_at`              datetime                                                                                                                                DEFAULT NULL,
    `publish_result`          int                                                                                                                                     DEFAULT '1' COMMENT 'This determine if result should be published or not',
    `term`                    enum ('first','second','third') COLLATE utf8mb4_unicode_ci                                                                              DEFAULT NULL,
    `review_remark`           text COLLATE utf8mb4_unicode_ci,
    `can_start`               int                                                                                                                                     DEFAULT '1' COMMENT 'If you can start the assessment or not',
    `created_at`              timestamp                                                                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`              timestamp                                                                                                                      NULL     DEFAULT NULL,
    `can_see_score`           int                                                                                                                                     DEFAULT '1',
    `can_see_answer`          int                                                                                                                                     DEFAULT '1',
    PRIMARY KEY (`id`),
    KEY `homework_reviewed_by_idx` (`reviewed_by`),
    KEY `homework_student_idx` (`student_id`),
    KEY `homework_teacher_idx` (`teacher_id`),
    KEY `homework_subject_idx` (`subject_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This homework table will all quiz.';

CREATE TABLE IF NOT EXISTS `homework_questions`
(
    `id`          int                                                                            NOT NULL AUTO_INCREMENT,
    `teacher_id`  int                                                                                     DEFAULT NULL COMMENT 'teacher_id could be for teacher and student',
    `homework_id` int                                                                            NOT NULL,
    `question_id` int                                                                            NOT NULL,
    `difficulty`  enum ('easy','medium','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `duration`    smallint                                                                       NOT NULL,
    `max_score`   int                                                                            NOT NULL DEFAULT '1' COMMENT 'The max a student can score in this questions',
    `created_at`  timestamp                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `homework_id` (`homework_id`),
    CONSTRAINT `homework_questions_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homeworks` (`id`) ON DELETE CASCADE,
    CONSTRAINT `homework_questions_ibfk_3` FOREIGN KEY (`homework_id`) REFERENCES `homeworks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `homework_selected_student`
(
    `id`          int       NOT NULL AUTO_INCREMENT,
    `homework_id` int       NOT NULL,
    `student_id`  int       NOT NULL,
    `teacher_id`  int                                                 DEFAULT NULL,
    `type`        enum ('homework','feed') COLLATE utf8mb4_unicode_ci DEFAULT 'homework' COMMENT 'This is for determining the source of the selection.',
    `created_at`  timestamp NULL                                      DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp NULL                                      DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This table is lists of selected student to participate in homework';

CREATE TABLE IF NOT EXISTS `invite_log`
(
    `id`                int                                                           NOT NULL AUTO_INCREMENT,
    `receiver_email`    varchar(100) COLLATE utf8mb4_unicode_ci                                DEFAULT NULL,
    `receiver_name`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `receiver_type`     varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
    `receiver_phone`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci           DEFAULT NULL,
    `receiver_class`    varchar(200) COLLATE utf8mb4_unicode_ci                                DEFAULT NULL,
    `receiver_subject`  int                                                                    DEFAULT NULL,
    `receiver_subjects` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL COMMENT 'Used to invite teacher to multiple subjects',
    `sender_type`       varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
    `sender_id`         int                                                           NOT NULL,
    `sender_school_id`  int                                                                    DEFAULT NULL,
    `token`             varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `extra_data`        text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `status`            int                                                           NOT NULL DEFAULT '0',
    `created_at`        timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `last_accessed_url`
(
    `id`         int          NOT NULL AUTO_INCREMENT,
    `user_id`    int          NOT NULL,
    `controller` varchar(50)  NOT NULL,
    `action`     varchar(50)  NOT NULL,
    `module`     varchar(50)           DEFAULT NULL,
    `url`        varchar(255) NOT NULL,
    `created_at` timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `learning_area`
(
    `id`          int                                                           NOT NULL AUTO_INCREMENT,
    `class_id`    int                                                           NOT NULL,
    `subject_id`  int                                                           NOT NULL,
    `topic_id`    int                                                           NOT NULL,
    `topic`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `slug`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `week`        int                                                           NOT NULL COMMENT 'This is the week the learning area should be taught',
    `is_school`   int                                                                DEFAULT '0' COMMENT 'This means the learning area is created for custom curriculum by a school',
    `created_at`  timestamp                                                     NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                                                     NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='Learning area is a sub-topics category. Used to breakdown topic into multiple areas';

CREATE TABLE IF NOT EXISTS `learning_recommendation`
(
    `id`            int                                                                                          NOT NULL AUTO_INCREMENT,
    `title`         varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                NOT NULL,
    `type`          enum ('practice','video','remedial','game') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `tag`           enum ('video','material') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                            DEFAULT NULL COMMENT 'We have multiple source for videos, tag will let us know which table the data is coming from. Video is video_content and material is practice_material table',
    `subject_id`    int                                                                                          NOT NULL,
    `topic_id`      int                                                                                                   DEFAULT NULL,
    `resource_id`   int                                                                                                   DEFAULT NULL COMMENT 'Id of the file I am sharing',
    `source_type`   enum ('homework','class','gradely') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NOT NULL,
    `source_id`     int                                                                                                   DEFAULT NULL,
    `receiver_type` enum ('single','multiple','all') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci            NOT NULL,
    `availability`  datetime                                                                                              DEFAULT NULL COMMENT 'Time for remedial to take place',
    `creator_id`    int                                                                                                   DEFAULT NULL,
    `status`        int                                                                                                   DEFAULT '1',
    `created_at`    timestamp                                                                                    NULL     DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    timestamp                                                                                    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `category`      enum ('practice','exam') COLLATE utf8mb4_unicode_ci                                          NOT NULL DEFAULT 'practice',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `learning_recommendation_receiver`
(
    `id`                int       NOT NULL AUTO_INCREMENT,
    `recommendation_id` int       NOT NULL,
    `student_id`        int       NOT NULL,
    `is_taken`          int       NOT NULL DEFAULT '0',
    `created_at`        timestamp NULL     DEFAULT CURRENT_TIMESTAMP,
    `updated_at`        timestamp NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `learning_recommendation_receiver__recommendations_idx` (`recommendation_id`),
    CONSTRAINT `learning_recommendation_receiver__recommendations` FOREIGN KEY (`recommendation_id`) REFERENCES `learning_recommendation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `learning_recommendations_mastery_report`
(
    `id`                        int       NOT NULL AUTO_INCREMENT,
    `user_id`                   int       NOT NULL,
    `subject_id`                int                                                          DEFAULT NULL,
    `start_recommendation_id`   int                                                          DEFAULT NULL COMMENT 'Id from learning_recommendations table',
    `end_recommendation_id`     int                                                          DEFAULT NULL COMMENT 'Id from learning_recommendations table on the last set of recommendation',
    `start_recommendation_date` datetime  NOT NULL,
    `end_recommendation_date`   datetime                                                     DEFAULT NULL,
    `start_mastery`             int       NOT NULL                                           DEFAULT '0' COMMENT 'The mastery point when new set recommendations was given',
    `end_mastery`               int                                                          DEFAULT NULL COMMENT 'The mastery point when recommendations set was completed\n',
    `improvement`               int                                                          DEFAULT NULL COMMENT 'Improvement value when recommendation set was completed',
    `improvement_direction`     varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Direction is either up or down',
    `created_at`                timestamp NULL                                               DEFAULT CURRENT_TIMESTAMP,
    `updated_at`                timestamp NULL                                               DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`, `user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `messages`
(
    `id`             int         NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
    `sender_id`      int         NOT NULL,
    `receiver_id`    int              DEFAULT NULL,
    `channel`        varchar(20) NOT NULL COMMENT '"id" or "email" or "phone"',
    `contact`        varchar(100)     DEFAULT NULL COMMENT 'email or phone',
    `body`           text        NOT NULL,
    `receiver_type`  varchar(20)      DEFAULT NULL,
    `reference_type` varchar(20) NOT NULL COMMENT '"student" or "class" or “tutor”',
    `reference_id`   int         NOT NULL COMMENT '"student_id" or "class_id"',
    `created_at`     timestamp   NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `migration`
(
    `version`    varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `apply_time` int DEFAULT NULL,
    PRIMARY KEY (`version`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `newsletter`
(
    `id`         int                                                           NOT NULL AUTO_INCREMENT,
    `email`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at` timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `offers`
(
    `id`             int          NOT NULL AUTO_INCREMENT,
    `slug`           varchar(200) NOT NULL,
    `title`          varchar(200) NOT NULL,
    `file`           varchar(255) NOT NULL,
    `download_count` int          NOT NULL DEFAULT '0',
    `created_at`     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `options`
(
    `name`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT 'This will be the keyword for the setting to be set and get. E.g name = school_trial and value 30 means school trial is 30days',
    `value`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The value to the named keyword',
    `created_by` int                                                                DEFAULT NULL,
    `updated_by` int                                                                DEFAULT NULL,
    `created_at` timestamp                                                     NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp                                                     NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `parents`
(
    `id`               int                                                          NOT NULL AUTO_INCREMENT,
    `parent_id`        int                                                          NOT NULL,
    `student_id`       int                                                          NOT NULL,
    `code`             varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         DEFAULT NULL,
    `inviter`          varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `status`           int                                                          NOT NULL DEFAULT '0',
    `role`             varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'guardian',
    `invitation_token` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `created_at`       timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `partners_callback`
(
    `id`               int                                                          NOT NULL AUTO_INCREMENT,
    `partner`          varchar(100) COLLATE utf8mb4_unicode_ci                      NOT NULL,
    `response`         json                                                         NOT NULL,
    `url`              text COLLATE utf8mb4_unicode_ci                              NOT NULL,
    `method`           varchar(20) COLLATE utf8mb4_unicode_ci                       NOT NULL,
    `msisdn`           varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `transaction_id`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `transaction_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at`       timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `payment_events`
(
    `id`                 int                                                           NOT NULL AUTO_INCREMENT,
    `event_name`         varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `authorization_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `customer`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `data`               text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NOT NULL,
    `created_at`         timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `payment_plan`
(
    `id`              int                                                                   NOT NULL AUTO_INCREMENT,
    `type`            enum ('catchup','tutor','bundle','summer') COLLATE utf8mb4_unicode_ci NOT NULL,
    `slug`            varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                   DEFAULT NULL,
    `title`           varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                   DEFAULT NULL,
    `price`           decimal(10, 2)                                                                 DEFAULT NULL,
    `sub_title`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                  DEFAULT NULL,
    `description`     varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                  DEFAULT NULL COMMENT 'Description of this current plan',
    `curriculum`      varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                   DEFAULT NULL COMMENT 'If the plan is curriculum based. I.e tutor is curriculum based. ',
    `months_duration` int                                                                            DEFAULT NULL COMMENT 'This is how many month is this duration. I.e 1  = 1 month, 3 = 3 month, 12 = 1 year, etc',
    `status`          int                                                                   NOT NULL DEFAULT '1',
    `default`         int                                                                            DEFAULT '0',
    `created_at`      timestamp                                                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      timestamp                                                             NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `practice_material`
(
    `id`             int                                                                                       NOT NULL AUTO_INCREMENT,
    `practice_id`    int                                                                                                DEFAULT NULL COMMENT 'This id is id from homework table or feed.id if type is feed',
    `user_id`        int                                                                                       NOT NULL,
    `title`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             NOT NULL COMMENT 'The name seen ',
    `filename`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                     NOT NULL,
    `filetype`       enum ('image','video','link','document') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `description`    mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `filesize`       varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                       DEFAULT NULL COMMENT 'e.g 100kb',
    `downloadable`   int                                                                                                DEFAULT '1',
    `download_count` int                                                                                                DEFAULT '0',
    `extension`      varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                              NOT NULL COMMENT 'e.g png, jpg, mp4, pdf, etc',
    `type`           enum ('feed','practice') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                 NOT NULL DEFAULT 'feed' COMMENT 'The file could either belong to practice assessment or feed.',
    `raw`            mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'This contains the object received from the cloud client. It is json encoded in database.',
    `tag`            varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                       DEFAULT NULL COMMENT 'e.g lesson, exam, homework, live_class.',
    `token`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                      DEFAULT NULL,
    `thumbnail`      text COLLATE utf8mb4_unicode_ci,
    `created_at`     timestamp                                                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     timestamp                                                                                 NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `token_UNIQUE` (`token`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This table holds information of files shared on homework, live class, posts and finds generally';

CREATE TABLE IF NOT EXISTS `practice_topics`
(
    `id`          int       NOT NULL AUTO_INCREMENT,
    `practice_id` int       NOT NULL,
    `topic_id`    int       NOT NULL,
    `created_at`  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `practice_id` (`practice_id`),
    KEY `topic_id` (`topic_id`),
    CONSTRAINT `practice_topics_ibfk_1` FOREIGN KEY (`practice_id`) REFERENCES `homeworks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `practice_topics_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `subject_topics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `proctor_feedback`
(
    `id`            int       NOT NULL AUTO_INCREMENT,
    `user_id`       int       NOT NULL,
    `proctor_id`    int       NOT NULL,
    `assessment_id` int       NOT NULL,
    `type`          enum ('reject_submission','admin_report','report_error') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `report`        text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'They will be comma separated values. e.g Cheating, Impersonation',
    `details`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `is_emailed`    int                                                                                                       DEFAULT '0' COMMENT 'If it has been emailed to the person uncharge',
    `is_treated`    int                                                                                                       DEFAULT '0' COMMENT 'If it has been treated by the person uncharge',
    `created_at`    timestamp NULL                                                                                            DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `proctor_report`
(
    `id`              int                                                          NOT NULL AUTO_INCREMENT,
    `assessment_id`   int                                                          NOT NULL,
    `student_id`      int                                                          NOT NULL,
    `integrity`       int                                                                   DEFAULT '0',
    `assessment_type` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'exam',
    `created_at`      timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `proctor_report__homework_idx` (`assessment_id`),
    CONSTRAINT `proctor_report__homework` FOREIGN KEY (`assessment_id`) REFERENCES `homeworks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This holds proctor report of assessment';

CREATE TABLE IF NOT EXISTS `proctor_report_details`
(
    `id`            int                                                                             NOT NULL AUTO_INCREMENT,
    `report_id`     int                                                                                      DEFAULT NULL,
    `user_id`       int                                                                             NOT NULL,
    `assessment_id` int                                                                             NOT NULL,
    `file_type`     enum ('image','audio','video') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `name`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                           NOT NULL,
    `extension`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                    NOT NULL,
    `size`          varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                             DEFAULT NULL,
    `integrity`     int                                                                                      DEFAULT '0' COMMENT 'This holds the integrity score of a practice',
    `url`           text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                           NOT NULL,
    `raw`           text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `created_at`    timestamp                                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `proctor_report_idx` (`report_id`),
    CONSTRAINT `proctor_report` FOREIGN KEY (`report_id`) REFERENCES `proctor_report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This holds assessment monitoring Information of student during practice';

CREATE TABLE IF NOT EXISTS `promo_benefit`
(
    `id`         int                                                                         NOT NULL AUTO_INCREMENT,
    `user_id`    int                                                                         NOT NULL COMMENT 'This is user.id or school.id',
    `user_type`  enum ('parent','school') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT 'To know the user type which determine where the user_id should reference to',
    `coupon`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                NOT NULL COMMENT 'This is coupon code from coupon table',
    `source`     enum ('coupon','referral') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'coupon' COMMENT 'This tells if the benefit is from coupon or referral',
    `status`     int                                                                         NOT NULL DEFAULT '1',
    `created_at` timestamp                                                                   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp                                                                   NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `questions`
(
    `id`                int                                                                                       NOT NULL AUTO_INCREMENT,
    `teacher_id`        int                                                                                                DEFAULT NULL,
    `homework_id`       int                                                                                                DEFAULT NULL,
    `subject_id`        int                                                                                       NOT NULL,
    `class_id`          varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                       DEFAULT NULL,
    `school_id`         int                                                                                                DEFAULT NULL,
    `question`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                     NOT NULL,
    `option_a`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `option_b`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `option_c`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `option_d`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `option_e`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `answer`            mediumtext COLLATE utf8mb4_unicode_ci COMMENT 'Answer should either be A, B, C, D, or E FOr multiple options and 1=true/0=false for boolean true/false questions',
    `type`              enum ('multiple','bool','essay','short') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'multiple' COMMENT 'Multiple is for a-d, bool is 1 and 0, essay receives input text or attachment, short is for SHORT ANSWER',
    `topic_id`          int                                                                                       NOT NULL,
    `learning_area_id`  int                                                                                                DEFAULT NULL COMMENT 'This contains the sub-categories of topics.',
    `exam_type_id`      int                                                                                       NOT NULL,
    `image`             text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `difficulty`        enum ('easy','medium','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci            NOT NULL,
    `duration`          smallint                                                                                  NOT NULL COMMENT 'duration is in seconds',
    `explanation`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `clue`              text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'This give clue to the question',
    `category`          enum ('homework','catchup','exam') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci       NOT NULL DEFAULT 'homework',
    `comprehension_id`  int                                                                                                DEFAULT NULL,
    `video_explanation` text COLLATE utf8mb4_unicode_ci COMMENT 'Url to the video that explain this question',
    `file_upload`       int                                                                                                DEFAULT NULL COMMENT 'If essay answer can be uploaded rather than written',
    `word_limit`        int                                                                                                DEFAULT NULL COMMENT 'Is there is limit of words to be inputted',
    `score`             int                                                                                                DEFAULT '1' COMMENT 'If this question should carry separate score value',
    `status`            int                                                                                       NOT NULL DEFAULT '1',
    `is_custom_topic`   int                                                                                                DEFAULT '0' COMMENT '0 means the topics is from subject_topics, 1 means the question is created while in custom curriculum in school and the topic is from school_topic',
    `created_at`        timestamp                                                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `year`              varchar(4) COLLATE utf8mb4_unicode_ci                                                              DEFAULT NULL COMMENT 'Year of an exam',
    `updated_at`        timestamp                                                                                 NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `comprehension_id` (`comprehension_id`),
    CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`comprehension_id`) REFERENCES `comprehension` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `quiz_summary`
(
    `id`              int                                                                                                        NOT NULL AUTO_INCREMENT,
    `homework_id`     int                                                                                                        NOT NULL,
    `subject_id`      int                                                                                                        NOT NULL,
    `student_id`      int                                                                                                        NOT NULL,
    `teacher_id`      int                                                                                                                 DEFAULT NULL,
    `class_id`        int                                                                                                        NOT NULL,
    `type`            enum ('homework','catchup','diagnostic','recommendation') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'homework' COMMENT 'it is either homework or catchup',
    `total_questions` int                                                                                                        NOT NULL,
    `correct`         int                                                                                                                 DEFAULT NULL,
    `failed`          int                                                                                                                 DEFAULT NULL,
    `skipped`         int                                                                                                                 DEFAULT NULL,
    `ungraded`        int                                                                                                                 DEFAULT NULL COMMENT 'Count of attempt that is yet to be graded. e.g essay count',
    `term`            enum ('first','second','third') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                           NOT NULL,
    `submit`          int                                                                                                        NOT NULL DEFAULT '0',
    `topic_id`        int                                                                                                                 DEFAULT NULL,
    `mode`            enum ('practice','exam') COLLATE utf8mb4_unicode_ci                                                                 DEFAULT 'practice',
    `session`         varchar(50) COLLATE utf8mb4_unicode_ci                                                                              DEFAULT NULL,
    `max_score`       int                                                                                                                 DEFAULT NULL COMMENT 'This is the maximum score you can get from assessment',
    `computed`        int                                                                                                                 DEFAULT '0' COMMENT 'This is to state if assessment is computed',
    `submit_at`       timestamp                                                                                                  NULL     DEFAULT NULL,
    `created_at`      timestamp                                                                                                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `quiz_summary_details`
(
    `id`                int                                                   NOT NULL AUTO_INCREMENT,
    `quiz_id`           int                                                   NOT NULL,
    `homework_id`       int                                                   NOT NULL,
    `student_id`        int                                                   NOT NULL,
    `question_id`       int                                                   NOT NULL,
    `selected`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `answer`            text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `topic_id`          int                                                            DEFAULT NULL,
    `time_spent`        int                                                            DEFAULT NULL COMMENT 'This is the time spent to answer a question. Duration is in seconds.',
    `is_correct`        tinyint                                                        DEFAULT NULL COMMENT 'If the answer is correct or not',
    `score`             tinyint                                                        DEFAULT NULL COMMENT 'Score earned by student',
    `max_score`         tinyint                                                        DEFAULT NULL COMMENT 'This is the maximum a student can score',
    `answer_attachment` text COLLATE utf8mb4_unicode_ci COMMENT 'For essay or any question type that requires you provide attachment',
    `is_graded`         tinyint                                                        DEFAULT NULL COMMENT 'Null means it is not essay, 0 means it needs to be graded but yet to be graded and 1 means it has been graded.',
    `graded_by`         int                                                            DEFAULT NULL,
    `created_at`        timestamp                                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`        timestamp                                             NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `quiz_summary_details_ibfk_1` (`quiz_id`),
    CONSTRAINT `quiz_summary_details_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz_summary` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rating`
(
    `id`           int                                                                   NOT NULL AUTO_INCREMENT,
    `user_id`      int                                                                   NOT NULL,
    `type`         enum ('class','app') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `rating`       int                                                                   NOT NULL,
    `message`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `reference_id` int                                                                   NOT NULL COMMENT 'Live class id or app id. Any id to know exactly what was rated.',
    `created_at`   timestamp                                                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `recommendations`
(
    `id`             int       NOT NULL AUTO_INCREMENT,
    `student_id`     int                                                                                                    DEFAULT NULL,
    `category`       enum ('weekly','daily','homework','video','remedial') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'daily' COMMENT 'Weekly or daily practice/video recommendation interval',
    `is_taken`       int                                                                                                    DEFAULT '0' COMMENT 'If this recommendation has been consumed',
    `reference_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                           DEFAULT NULL COMMENT 'e.g homework, diagnostic',
    `reference_id`   int                                                                                                    DEFAULT NULL COMMENT 'Id of the assessment',
    `type`           enum ('single','mix','practice','video') COLLATE utf8mb4_unicode_ci                                    DEFAULT NULL COMMENT 'This is used to identify if recommendation is practice, video or tutor',
    `resource_count` int                                                                                                    DEFAULT NULL COMMENT 'Question count or video count',
    `raw`            json                                                                                                   DEFAULT NULL COMMENT 'This contains the whole content of each recommendation',
    `created_at`     timestamp NULL                                                                                         DEFAULT CURRENT_TIMESTAMP COMMENT 'Let you know if recommendation has been created for today our this week',
    `updated_at`     timestamp NULL                                                                                         DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This is a periodic recommendation generated to students';

CREATE TABLE IF NOT EXISTS `recommendation_topics`
(
    `id`                int       NOT NULL AUTO_INCREMENT,
    `recommendation_id` int       NOT NULL,
    `subject_id`        int       NOT NULL,
    `student_id`        int       NOT NULL,
    `object_id`         int                                                                        DEFAULT NULL,
    `object_type`       enum ('practice','video') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'This is to let us know if the action is practice or video',
    `is_done`           int                                                                        DEFAULT '0',
    `created_at`        timestamp NOT NULL                                                         DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `recommendation_topics__subject_idx` (`subject_id`),
    KEY `recommendation_topics__recommendation_idx` (`recommendation_id`),
    CONSTRAINT `recommendation_topics__recommendation` FOREIGN KEY (`recommendation_id`) REFERENCES `recommendations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `recommendation_topics__subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `recommended_resources`
(
    `id`             int                                                          NOT NULL AUTO_INCREMENT,
    `creator_id`     int                                                          NOT NULL COMMENT 'The person creating or recommending the resources. E.g teacher_id',
    `receiver_id`    int                                                          NOT NULL COMMENT 'This is id of the student receiving the resources.',
    `resources_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g video, document, practice, etc',
    `resources_id`   int                                                          NOT NULL COMMENT 'Id of the resources recommended to the student',
    `reference_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci      DEFAULT NULL COMMENT 'e.g homework, practice, class, etc.',
    `reference_id`   int                                                               DEFAULT NULL COMMENT 'The is action that led to the recommendation of the resources. e.g homework_id, class_id, etc',
    `created_at`     timestamp                                                    NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `remarks`
(
    `id`          int                                                                          NOT NULL AUTO_INCREMENT,
    `type`        enum ('homework','student') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `creator_id`  int                                                                          NOT NULL COMMENT 'The user giving remark',
    `receiver_id` int                                                                          NOT NULL COMMENT 'The receiver could either be student, homework, etc',
    `remark`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                        NOT NULL,
    `subject_id`  int                                                                                   DEFAULT NULL,
    `level`       enum ('remark','comment') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci            DEFAULT 'remark',
    `remark_id`   int                                                                                   DEFAULT NULL,
    `created_at`  timestamp                                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                                                                    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `reminder`
(
    `id`            int         NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
    `user_id`       int         NOT NULL,
    `day`           enum ('sunday','monday','tuesday','wednesday','thursday','friday','saturday') DEFAULT NULL COMMENT 'Days of the week',
    `type`          varchar(50) NOT NULL,
    `created_at`    timestamp   NULL                                                              DEFAULT CURRENT_TIMESTAMP,
    `send_at`       time                                                                          DEFAULT NULL COMMENT 'this is when the user wants the reminder to be sent',
    `last_reminded` timestamp   NULL                                                              DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `report_error`
(
    `id`           int       NOT NULL AUTO_INCREMENT,
    `user_id`      int       NOT NULL,
    `school`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `class`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `reference_id` int                                                           DEFAULT NULL,
    `title`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `description`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `type`         enum ('question','feed','comment') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `status`       int       NOT NULL                                            DEFAULT '1',
    `emailed`      int                                                           DEFAULT '0' COMMENT '0 means this error has not been sent via email to it’s manager, 1 mean error has been reported',
    `created_at`   timestamp NOT NULL                                            DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `request_call`
(
    `id`          int       NOT NULL AUTO_INCREMENT,
    `user_id`     int                                                                   DEFAULT NULL,
    `email`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `phone`       varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `subject`     varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         DEFAULT NULL,
    `title`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `type`        enum ('call','demo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'call',
    `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `name`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         DEFAULT NULL COMMENT 'Name of the requesting requesting',
    `school_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         DEFAULT NULL COMMENT 'Name of school requesting demo',
    `role`        varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL COMMENT 'Role of the person requesting',
    `school_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL COMMENT 'What type of school. e.g primary, secondary or both',
    `demo_date`   datetime                                                              DEFAULT NULL COMMENT 'Preferred demo date',
    `created_at`  timestamp NULL                                                        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `review`
(
    `id`                 int       NOT NULL AUTO_INCREMENT,
    `session_id`         int       NOT NULL,
    `receiver_id`        int       NOT NULL,
    `sender_id`          int       NOT NULL,
    `receiver_type`      varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The user receiving the review. e.g tutor, student',
    `sender_type`        varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Type of user sending it. e.g student, parent',
    `rate`               int       NOT NULL COMMENT 'Student rating tutor',
    `review`             text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Student message on the rating',
    `topic_taught`       int                                                          DEFAULT NULL COMMENT 'Topic tutor taught the student',
    `recommended_topic`  varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tutor recommendation to the student',
    `tutor_rate_student` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tutor feedback to the student',
    `tutor_comment`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Tutor comment on a student',
    `created_at`         timestamp NOT NULL                                           DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_admin`
(
    `id`         int                                                          NOT NULL AUTO_INCREMENT,
    `school_id`  int                                                          NOT NULL,
    `user_id`    int                                                          NOT NULL,
    `level`      varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `status`     int                                                          NOT NULL DEFAULT '1',
    `created_at` timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    CONSTRAINT `school_admin_ibfk_2` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `school_admin_ibfk_4` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_calendar`
(
    `id`                int                                                           NOT NULL AUTO_INCREMENT,
    `school_id`         int                                                           NOT NULL,
    `session_name`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `year`              int                                                           NOT NULL COMMENT 'Year of the school session for the calendar',
    `first_term_start`  date                                                          NOT NULL,
    `first_term_end`    date                                                          NOT NULL,
    `second_term_start` date                                                          NOT NULL,
    `second_term_end`   date                                                          NOT NULL,
    `third_term_start`  date                                                          NOT NULL,
    `third_term_end`    date                                                          NOT NULL,
    `status`            int                                                           NOT NULL DEFAULT '1',
    `created_at`        timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    CONSTRAINT `school_calendar_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE,
    CONSTRAINT `school_calendar_ibfk_2` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_class_curriculum`
(
    `id`          int                                                                              NOT NULL AUTO_INCREMENT,
    `school_id`   int                                                                              NOT NULL,
    `class_id`    int                                                                              NOT NULL,
    `subject_id`  int                                                                              NOT NULL,
    `week_number` smallint                                                                         NOT NULL COMMENT 'It contains numbers. 1 stands for week one, 5 stands for week 5',
    `topic_id`    int                                                                              NOT NULL,
    `term`        enum ('first','second','third') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `year`        int                                                                              NOT NULL,
    `status`      int                                                                              NOT NULL DEFAULT '1',
    `created_at`  timestamp                                                                        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    CONSTRAINT `school_class_curriculum_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_curriculum`
(
    `id`            int       NOT NULL AUTO_INCREMENT,
    `school_id`     int       NOT NULL,
    `curriculum_id` int       NOT NULL,
    `created_at`    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    KEY `curriculum_id` (`curriculum_id`),
    CONSTRAINT `school_curriculum_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `school_curriculum_ibfk_2` FOREIGN KEY (`curriculum_id`) REFERENCES `exam_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `school_custom_class`
(
    `id`          int                                                           NOT NULL AUTO_INCREMENT,
    `school_id`   int                                                           NOT NULL,
    `class_name`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at`  timestamp                                                     NULL DEFAULT CURRENT_TIMESTAMP,
    `class_level` json                                                          NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_naming_format`
(
    `id`         int                                                          NOT NULL AUTO_INCREMENT,
    `slug`       varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `title`      varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `status`     int                                                          NOT NULL DEFAULT '1',
    `created_at` timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp                                                    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_options`
(
    `id`           int                                                                  NOT NULL AUTO_INCREMENT,
    `school_id`    int                                                                  NOT NULL,
    `class_naming` enum ('jss','year') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at`   timestamp                                                            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    CONSTRAINT `school_options_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_role`
(
    `id`         int                                                          NOT NULL AUTO_INCREMENT,
    `slug`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `title`      varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `status`     int                                                          NOT NULL DEFAULT '1',
    `created_at` timestamp                                                    NULL     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `slug_UNIQUE` (`slug`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='This is to lists the roles of school access';

CREATE TABLE IF NOT EXISTS `school_subject`
(
    `id`                  int       NOT NULL AUTO_INCREMENT,
    `school_id`           int       NOT NULL,
    `subject_id`          int       NOT NULL,
    `custom_subject_name` varchar(100)       DEFAULT NULL COMMENT 'This is the name of the subject the school prefer to use.',
    `status`              int       NOT NULL DEFAULT '1',
    `created_at`          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    KEY `subject_id` (`subject_id`),
    CONSTRAINT `school_subject_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `school_subject_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_teachers`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `teacher_id` int       NOT NULL,
    `school_id`  int       NOT NULL,
    `status`     int       NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    CONSTRAINT `school_teachers_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE,
    CONSTRAINT `school_teachers_ibfk_2` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `school_topic`
(
    `id`            int                                                                              NOT NULL AUTO_INCREMENT,
    `topic`         varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                    NOT NULL,
    `topic_id`      int                                                                                       DEFAULT NULL,
    `school_id`     int                                                                                       DEFAULT NULL,
    `subject_id`    int                                                                              NOT NULL,
    `class_id`      int                                                                              NOT NULL,
    `curriculum_id` int                                                                                       DEFAULT NULL,
    `position`      int                                                                                       DEFAULT NULL,
    `term`          enum ('first','second','third') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `week`          int                                                                                       DEFAULT NULL,
    `creator_id`    int                                                                                       DEFAULT NULL COMMENT 'Id of the person that created the topic',
    `created_at`    timestamp                                                                        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    timestamp                                                                        NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_topic__subject_idx` (`subject_id`),
    KEY `school_topic__class_idx` (`class_id`),
    KEY `school_topic__curriculum_idx` (`curriculum_id`),
    KEY `school_topic__school_idx` (`school_id`),
    KEY `school_topic__topics_idx` (`topic_id`),
    CONSTRAINT `school_topic__class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `school_topic__curriculum` FOREIGN KEY (`curriculum_id`) REFERENCES `exam_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `school_topic__school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `school_topic__subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `school_topic__topics` FOREIGN KEY (`topic_id`) REFERENCES `subject_topics` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `school_type`
(
    `id`          int                                                          NOT NULL,
    `slug`        varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `title`       varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `class_range` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `status`      int                                                          NOT NULL DEFAULT '1',
    `created_at`  timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `security_questions`
(
    `id`         int                                                   NOT NULL AUTO_INCREMENT,
    `question`   text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `updated_at` timestamp                                             NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `security_question_answer`
(
    `id`         int                                                           NOT NULL AUTO_INCREMENT,
    `user_id`    int                                                           NOT NULL,
    `question`   int                                                           NOT NULL COMMENT 'This question ID is dependent on security_questions table',
    `answer`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at` timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `question` (`question`),
    CONSTRAINT `security_question_answer_ibfk_2` FOREIGN KEY (`question`) REFERENCES `security_questions` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = COMPACT;

CREATE TABLE IF NOT EXISTS `short_links`
(
    `id`          int                                                           NOT NULL AUTO_INCREMENT,
    `destination` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NOT NULL,
    `short_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `click_count` int                                                           NOT NULL DEFAULT '0',
    `last_click`  datetime                                                               DEFAULT NULL,
    `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'describe what the link is going if it is general link',
    `status`      int                                                           NOT NULL DEFAULT '1',
    `created_at`  timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `states`
(
    `id`         int                                                           NOT NULL AUTO_INCREMENT,
    `name`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `country_id` int                                                           NOT NULL DEFAULT '1',
    `slug`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `country`    varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `country` (`country`),
    KEY `slug` (`slug`),
    CONSTRAINT `states_ibfk_1` FOREIGN KEY (`country`) REFERENCES `country` (`slug`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

CREATE TABLE IF NOT EXISTS `student_additional_topics`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `student_id` int       NOT NULL COMMENT 'Student that is taking additional topic',
    `class_id`   int       NOT NULL,
    `subject_id` int       NOT NULL,
    `topic_id`   int       NOT NULL COMMENT 'This id of the additional topics',
    `status`     int       NOT NULL COMMENT 'This determine of topic is included or excluded',
    `updated_by` int       NOT NULL COMMENT 'Who updated this topic',
    `topic_mode` enum ('practice','exam') COLLATE utf8mb4_unicode_ci DEFAULT 'practice',
    `created_at` timestamp NOT NULL                                  DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `student_additiional_topics__user_idx` (`student_id`),
    KEY `student_additiional_topics__topic_idx` (`topic_id`),
    KEY `student_additiional_topics__updater_idx` (`updated_by`),
    KEY `student_additiional_topics__class_idx` (`class_id`),
    KEY `student_additiional_topics__subjects_idx` (`subject_id`),
    CONSTRAINT `student_additiional_topics__class` FOREIGN KEY (`class_id`) REFERENCES `global_class` (`id`),
    CONSTRAINT `student_additiional_topics__subjects` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `student_additiional_topics__topic` FOREIGN KEY (`topic_id`) REFERENCES `subject_topics` (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `student_exam_config`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `student_id` int       NOT NULL,
    `exam_id`    int       NOT NULL,
    `subject_id` int       NOT NULL,
    `status`     int       NOT NULL DEFAULT '1',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_at`  timestamp NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `student_school`
(
    `id`                    int       NOT NULL AUTO_INCREMENT,
    `student_id`            int       NOT NULL,
    `school_id`             int                                                          DEFAULT NULL,
    `class_id`              int                                                          DEFAULT NULL,
    `invite_code`           varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `status`                int       NOT NULL                                           DEFAULT '0',
    `current_class`         int       NOT NULL                                           DEFAULT '1' COMMENT 'This is to know if this is current class of a child. 1 mean child is in this class, 0 means this is not current class of a child. Can be use for promoting of a child.',
    `subscription_status`   enum ('basic','premium') COLLATE utf8mb4_unicode_ci          DEFAULT NULL COMMENT 'Basic is lms, premium is lms with catchup',
    `is_active_class`       int                                                          DEFAULT '1',
    `promoted_by`           int                                                          DEFAULT NULL,
    `promoted_from`         int                                                          DEFAULT NULL COMMENT 'The previous class the student is promoted from',
    `promoted_at`           timestamp NULL                                               DEFAULT NULL,
    `session`               varchar(50) COLLATE utf8mb4_unicode_ci                       DEFAULT NULL COMMENT 'Session of the student',
    `in_summer_school`      tinyint                                                      DEFAULT NULL COMMENT '1 if the child is in summer school and 0 if not. Default is 0.',
    `summer_payment_status` enum ('unpaid','paid') COLLATE utf8mb4_unicode_ci            DEFAULT NULL,
    `created_at`            timestamp NOT NULL                                           DEFAULT CURRENT_TIMESTAMP,
    `updated_at`            timestamp NULL                                               DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `school_id` (`school_id`),
    KEY `class_id` (`class_id`),
    CONSTRAINT `student_school_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE,
    CONSTRAINT `student_school_ibfk_3` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `student_summer_school`
(
    `id`                    int       NOT NULL AUTO_INCREMENT,
    `student_id`            int       NOT NULL,
    `parent_id`             int                                               DEFAULT NULL,
    `class_id`              int                                               DEFAULT NULL,
    `global_class`          int                                               DEFAULT NULL,
    `school_id`             int       NOT NULL,
    `subjects`              json      NOT NULL COMMENT 'This is the course they want to study',
    `summer_payment_status` enum ('unpaid','paid') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `payment_date`          timestamp NULL                                    DEFAULT NULL,
    `payment_reference_id`  int                                               DEFAULT NULL COMMENT 'Id from subscription table',
    `status`                tinyint                                           DEFAULT '0',
    `created_at`            timestamp NULL                                    DEFAULT CURRENT_TIMESTAMP,
    `updated_at`            timestamp NULL                                    DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subject_image`
(
    `id`         int                                                   NOT NULL AUTO_INCREMENT,
    `subject_id` int                                                   NOT NULL,
    `exam_id`    int                                                   NOT NULL,
    `image`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   DEFAULT NULL,
    `created_at` timestamp                                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `subject_image__exam_idx` (`exam_id`),
    KEY `subject_image__subject_idx` (`subject_id`),
    CONSTRAINT `subject_image__exam` FOREIGN KEY (`exam_id`) REFERENCES `exam_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `subject_image__subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subscribe_parents`
(
    `id`           int                                                           NOT NULL AUTO_INCREMENT,
    `user_id`      int                                                                    DEFAULT NULL,
    `school_name`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `role`         varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `email`        varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
    `phone`        varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
    `parent_count` int                                                           NOT NULL,
    `created_at`   timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subscriptions`
(
    `id`                 int                                                                            NOT NULL AUTO_INCREMENT,
    `user_id`            int                                                                            NOT NULL,
    `payment_details_id` int                                                                                                                DEFAULT NULL COMMENT 'ID of the card details used',
    `reference_id`       int                                                                                                                DEFAULT NULL COMMENT 'e.g tutor_id or any id to reference this payment',
    `price`              decimal(10, 2)                                                                 NOT NULL COMMENT 'Price to be paid',
    `quantity`           int                                                                            NOT NULL COMMENT 'number of children you pay for',
    `duration`           enum ('day','week','month','monthly','quarterly','yearly','payg') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'month, year or pays(e.g tutor session)',
    `duration_count`     int                                                                            NOT NULL COMMENT 'This could be number of month/year you paying for subscription, it also means number of session you paying for if you using payg(like tutors session)',
    `total`              decimal(10, 2)                                                                 NOT NULL COMMENT 'This is total amount to be paid after adding all children and all applying coupon',
    `payment`            enum ('unpaid','paid') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci        NOT NULL                            DEFAULT 'unpaid' COMMENT 'Paid or unpaid',
    `amount_paid`        decimal(10, 2)                                                                                                     DEFAULT NULL COMMENT 'Actual paid amount after all calculation',
    `transaction_id`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                       DEFAULT NULL COMMENT 'Unique id for this payment',
    `plan_code`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                      DEFAULT NULL COMMENT 'Incase you are using gateway automatic subscription',
    `plan`               enum ('basic','premium','payg','subscription') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                    DEFAULT NULL COMMENT 'Basic & Premium is access to regular paid service. \r\npayg is a one time payment for a service, e.g you paid for tutor want. \r\nsubscription is continuous interval payment for a service, e.g every week, month, etc tutor service.',
    `type`               enum ('subscription','tutor') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL                            DEFAULT 'subscription' COMMENT 'Subscription is for regular monthly subscription while tutor is a PAYG service for tutor session.',
    `meta`               text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'You can put any additional data here',
    `renew_status`       int                                                                                                                DEFAULT '0' COMMENT 'Automatically renew my subscription at the end of the current subscription cycle',
    `coupon`             varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                                                       DEFAULT NULL COMMENT 'If coupon provided',
    `payment_plan_id`    int                                                                                                                DEFAULT NULL COMMENT 'This is ID of the payment from payment_plan table',
    `status`             int                                                                            NOT NULL                            DEFAULT '1' COMMENT '1 means subscription is active and it is default, 0 means subscription has been disabled.',
    `created_at`         timestamp                                                                      NOT NULL                            DEFAULT CURRENT_TIMESTAMP,
    `paid_at`            datetime                                                                                                           DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subscription_children`
(
    `id`              int                                                                     NOT NULL AUTO_INCREMENT,
    `subscription_id` int                                                                     NOT NULL,
    `subscriber_id`   int                                                                     NOT NULL,
    `student_id`      int                                                                     NOT NULL,
    `payment_status`  enum ('unpaid','paid') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unpaid',
    `expiry`          datetime                                                                         DEFAULT NULL,
    `created_at`      timestamp                                                               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `subscription_id` (`subscription_id`),
    CONSTRAINT `subscription_children_ibfk_1` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subscription_payment_details`
(
    `id`                 int                                                           NOT NULL AUTO_INCREMENT,
    `user_id`            int                                                           NOT NULL,
    `email`              varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `customer_code`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci          DEFAULT NULL,
    `selected`           int                                                           NOT NULL DEFAULT '0',
    `payment_channel`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'paystack',
    `authorization_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `bin`                varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `last4`              varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `exp_month`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `exp_year`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `channel`            varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `card_type`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `bank`               varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `country_code`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `brand`              varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `reusable`           int                                                           NOT NULL,
    `signature`          varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at`         timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subscription_plan`
(
    `id`             int                                                                       NOT NULL AUTO_INCREMENT,
    `name`           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci             NOT NULL,
    `code`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci             NOT NULL,
    `plan`           enum ('basic','premium') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g basic, premium, etc',
    `duration`       enum ('month','year') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci    NOT NULL,
    `duration_count` int                                                                       NOT NULL,
    `quantity`       int                                                                       NOT NULL,
    `amount`         decimal(10, 2)                                                            NOT NULL,
    `created_at`     timestamp                                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `teacher_academy_form`
(
    `id`             int                                                                        NOT NULL AUTO_INCREMENT,
    `type`           enum ('teacher','school') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `name`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci              NOT NULL,
    `email`          varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci               NOT NULL,
    `phone`          varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci               NOT NULL,
    `school_name`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                   DEFAULT NULL,
    `role`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci                   DEFAULT NULL,
    `teacher_count`  int                                                                             DEFAULT '0',
    `payment_status` tinyint                                                                         DEFAULT '0',
    `paid_at`        timestamp                                                                  NULL DEFAULT NULL,
    `created_at`     timestamp                                                                  NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     timestamp                                                                  NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `teacher_class`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `teacher_id` int       NOT NULL,
    `school_id`  int       NOT NULL,
    `class_id`   int       NOT NULL,
    `status`     int       NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `class_id` (`class_id`),
    KEY `teacher_id` (`teacher_id`),
    CONSTRAINT `teacher_class_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
    CONSTRAINT `teacher_class_ibfk_4` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `teacher_class_ibfk_7` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `teacher_class_subjects`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `teacher_id` int       NOT NULL,
    `subject_id` int       NOT NULL,
    `class_id`   int       NOT NULL,
    `school_id`  int       NOT NULL,
    `status`     int       NOT NULL DEFAULT '1',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `subject_id` (`subject_id`),
    KEY `class_id` (`class_id`),
    KEY `school_id` (`school_id`),
    CONSTRAINT `teacher_class_subjects_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `teacher_class_subjects_ibfk_3` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
    CONSTRAINT `teacher_class_subjects_ibfk_5` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `teacher_class_subjects_ibfk_7` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `timezone`
(
    `id`   int                                                          NOT NULL AUTO_INCREMENT,
    `area` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'This is like the continent or a name that group series of timezone',
    `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'This is the actual name of the timezone and it is also the primary key',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutor_availability`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `user_id`    int       NOT NULL,
    `day`        varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Monday to Sunday',
    `period`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Morning, afternoon or evening',
    `status`     int                                                          DEFAULT '1' COMMENT 'Is this period is still active or not',
    `created_at` timestamp NULL                                               DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL                                               DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `tutor_profile`
(
    `id`                 int       NOT NULL AUTO_INCREMENT,
    `tutor_id`           int       NOT NULL,
    `verified`           int                                     DEFAULT '0',
    `video_sample`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `satisfaction`       int                                     DEFAULT '1',
    `availability`       int                                     DEFAULT '1' COMMENT 'This is availability status, 1 mean user is available and it is default, 0 means user is not available and should not be available in search',
    `created_at`         timestamp NOT NULL                      DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         timestamp NULL                          DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `display_name`       varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL,
    `headline`           text COLLATE utf8mb4_unicode_ci,
    `bio`                text COLLATE utf8mb4_unicode_ci,
    `contact_phone`      varchar(14) COLLATE utf8mb4_unicode_ci  DEFAULT NULL,
    `contact_email`      varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL,
    `contact_address`    varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `contact_state`      varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL,
    `contact_country`    varchar(50) COLLATE utf8mb4_unicode_ci  DEFAULT NULL,
    `class_id`           json                                    DEFAULT NULL COMMENT '[1,2,4]',
    `curriculum_id`      json                                    DEFAULT NULL COMMENT '[1,2,4]',
    `subject_id`         json                                    DEFAULT NULL COMMENT '[1,2,4]',
    `private_fee`        json                                    DEFAULT NULL COMMENT '{“currency”:”NGN”,”amount”:3000.00}',
    `available_calendar` json                                    DEFAULT NULL COMMENT '[{“day”:”Monday”,”period”:”morning”},{“day”:”Tuesday”,”period”:”afternoon”},{“day”:”Wednesday”,”period”:”evening”},{“day”:”Thursday”,”period”:”night”}]',
    `language`           json                                    DEFAULT NULL COMMENT '[{“language”:”Yoruba Language”,”level”:”Expert”}]',
    `education`          json                                    DEFAULT NULL COMMENT '[\n{“school”:”Obefemi Awolowo University”,”course”:”Computer Science”,”degree”:”BSc”,”graduation_year”:2009,”ongoing”:0},\n{“school”:”National Open university”,”course”:”Information technology”,”degree”:”Master”,”graduation_year”:2013,”ongoing”:1}\n]',
    `cv`                 text COLLATE utf8mb4_unicode_ci,
    `id_card`            json                                    DEFAULT NULL COMMENT '{“type”:”National identity card”,”file”:”https://…”}',
    `experience`         json                                    DEFAULT NULL COMMENT '[{“school”:”Obefemi Awolowo University”,”course”:”Computer Science”,”degree”:”BSc”,”graduation_year”:2009,”ongoing”:0},{“school”:”National Open university”,”course”:”Information technology”,”degree”:”Master”,”graduation_year”:2013,”ongoing”:1}]',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutor_session_links`
(
    `id`           int                                                           NOT NULL AUTO_INCREMENT,
    `tutor_id`     int                                                           NOT NULL,
    `token`        varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `usage_status` tinyint                                                                DEFAULT '0',
    `created_at`   timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`   timestamp                                                     NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `token_UNIQUE` (`token`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutor_session_participant`
(
    `id`             int       NOT NULL AUTO_INCREMENT,
    `session_id`     int       NOT NULL,
    `participant_id` int       NOT NULL COMMENT 'Expected to be student id',
    `status`         int       NOT NULL DEFAULT '1' COMMENT 'One means you can access it, 0 means you cannot access it which in most cases it is related to payment.',
    `created_at`     timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `session__id_idx` (`session_id`),
    CONSTRAINT `session__id` FOREIGN KEY (`session_id`) REFERENCES `tutor_session` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutor_session_timing`
(
    `id`         int                                                          NOT NULL AUTO_INCREMENT,
    `session_id` int                                                          NOT NULL,
    `day`        varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `time`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at` timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `session_id` (`session_id`),
    CONSTRAINT `tutor_session_timing_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `tutor_session` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutor_subject`
(
    `id`            int       NOT NULL AUTO_INCREMENT,
    `tutor_id`      int       NOT NULL,
    `curriculum_id` int                DEFAULT NULL,
    `subject_id`    int                DEFAULT NULL,
    `class`         int                DEFAULT NULL,
    `status`        int       NOT NULL DEFAULT '1',
    `created_at`    timestamp NULL     DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    timestamp NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;



CREATE TABLE IF NOT EXISTS `user_preference`
(
    `id`                       int                                                          NOT NULL AUTO_INCREMENT,
    `user_id`                  int                                                                   DEFAULT NULL,
    `weekly_progress_report`   int                                                                   DEFAULT '1',
    `product_update`           int                                                                   DEFAULT '1',
    `offer`                    int                                                                   DEFAULT '1',
    `sms`                      int                                                                   DEFAULT '1',
    `whatsapp`                 int                                                                   DEFAULT '1',
    `newsletter`               int                                                                   DEFAULT '1',
    `reminder`                 int                                                                   DEFAULT '1',
    `updated`                  timestamp                                                    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `sound_effects`            int                                                          NOT NULL DEFAULT '1' COMMENT '1 represents on, 0 represents off',
    `catchup_sound_effects`    int                                                          NOT NULL DEFAULT '1' COMMENT '1 represents on, 0 represents off',
    `pause_all_notifications`  int                                                          NOT NULL DEFAULT '0' COMMENT '1 represents on, 0 represents off',
    `download_over_wifi_only`  int                                                          NOT NULL DEFAULT '1' COMMENT '1 represents on, 0 represents off',
    `video_quality`            enum ('auto','hd','medium','low') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'auto',
    `load_high_quality_images` enum ('wifi','both','never') COLLATE utf8mb4_unicode_ci      NOT NULL DEFAULT 'wifi' COMMENT 'both represents either cellular or wifi',
    `video_autoplay`           enum ('wifi','both','never') COLLATE utf8mb4_unicode_ci      NOT NULL DEFAULT 'wifi' COMMENT 'both represents either cellular or wifi',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_profile`
(
    `id`                        int       NOT NULL AUTO_INCREMENT,
    `user_id`                   int       NOT NULL,
    `dob`                       smallint                                                      DEFAULT NULL COMMENT 'Date of birth',
    `mob`                       int                                                           DEFAULT NULL COMMENT 'Month of birth',
    `yob`                       smallint                                                      DEFAULT NULL COMMENT 'Year of birth',
    `gender`                    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  DEFAULT NULL,
    `address`                   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `city`                      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `state`                     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `country`                   varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `about`                     mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `postal_code`               varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  DEFAULT NULL,
    `is_boarded`                int       NOT NULL                                            DEFAULT '0' COMMENT 'This is used to check if account is boarded. 0=not boarded, 1 means default onboarding has be boarded, if another level of onboarding comes up, we can set their number to 2 and for other subsequent onboarding that comes up.',
    `password_updated_time`     timestamp NULL                                                DEFAULT NULL,
    `password_updated_location` varchar(100) COLLATE utf8mb4_unicode_ci                       DEFAULT NULL,
    `password_updated_device`   varchar(255) COLLATE utf8mb4_unicode_ci                       DEFAULT NULL,
    `signup_source`             varchar(100) COLLATE utf8mb4_unicode_ci                       DEFAULT NULL,
    `set_goal`                  tinyint                                                       DEFAULT '0' COMMENT 'Be default, goal is set to 0, updating the goal allow user goal to be updated to 1. This is Catchup goal related',
    `created_at`                timestamp NOT NULL                                            DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_referral_links`
(
    `id`         int                                                                       NOT NULL AUTO_INCREMENT,
    `user_id`    int                                                                       NOT NULL COMMENT 'This is user.id or school.id',
    `user_type`  enum ('parent','school') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'To know the user type which determine where the user_id should reference to',
    `token`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci             NOT NULL COMMENT 'A unique token for every user',
    `status`     int                                                                       NOT NULL DEFAULT '1',
    `created_at` timestamp                                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp                                                                 NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_referral_signups`
(
    `id`          int                                                          NOT NULL AUTO_INCREMENT,
    `referral_id` int                                                          NOT NULL,
    `user_id`     varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at`  timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `user_referral_signups__links_idx` (`referral_id`),
    CONSTRAINT `user_referral_signups__links` FOREIGN KEY (`referral_id`) REFERENCES `user_referral_links` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_type_app_permission`
(
    `id`         int       NOT NULL AUTO_INCREMENT,
    `user_type`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `app_name`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `status`     int                                                          DEFAULT '1',
    `created_at` timestamp NULL                                               DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL                                               DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT ='To determine if the user account type can access certain application';

CREATE TABLE IF NOT EXISTS `video_content`
(
    `id`               int                        NOT NULL AUTO_INCREMENT,
    `category`         varchar(100)               NOT NULL,
    `subject_id`       int                                 DEFAULT NULL,
    `topic_id`         int                                 DEFAULT NULL,
    `content_id`       int                                 DEFAULT NULL,
    `title`            varchar(255)               NOT NULL,
    `slug`             varchar(255)               NOT NULL,
    `image`            text,
    `new_title`        varchar(255)                        DEFAULT NULL COMMENT 'This is modified title different from the source.',
    `content_length`   int                                 DEFAULT NULL,
    `content_type`     varchar(20)                NOT NULL DEFAULT 'video',
    `token`            varchar(100)                        DEFAULT NULL COMMENT 'This is a unique string for each video',
    `owner`            enum ('gradely','wizitup') NOT NULL DEFAULT 'wizitup',
    `size`             varchar(50)                         DEFAULT NULL,
    `path`             text,
    `class_id`         int                                 DEFAULT NULL,
    `learning_area_id` int                                 DEFAULT NULL,
    `created_by`       int                                 DEFAULT NULL,
    `updated_by`       int                                 DEFAULT NULL,
    `created_at`       timestamp                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`       timestamp                  NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `etag`             varchar(100)                        DEFAULT NULL COMMENT 'Identify the video on s3',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `video_assign`
(
    `id`         int          NOT NULL AUTO_INCREMENT,
    `content_id` int          NOT NULL,
    `topic_id`   int          NOT NULL COMMENT 'Gradely topic id',
    `difficulty` varchar(100) NOT NULL,
    `status`     int          NOT NULL DEFAULT '1' COMMENT 'this enable or disable',
    `created_by` int          NOT NULL,
    `updated_by` int                   DEFAULT NULL,
    `created_at` timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `topic_id` (`topic_id`),
    KEY `content_id` (`content_id`),
    CONSTRAINT `video_assign_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `subject_topics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `video_assign_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `video_content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `video_category`
(
    `id`          int                        NOT NULL AUTO_INCREMENT,
    `name`        varchar(100)               NOT NULL,
    `slug`        varchar(100)               NOT NULL,
    `description` text,
    `status`      int                        NOT NULL DEFAULT '1',
    `created_at`  timestamp                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  timestamp                  NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `created_by`  int                                 DEFAULT NULL,
    `updated_by`  int                                 DEFAULT NULL,
    `vendor`      enum ('gradely','wizitup') NOT NULL DEFAULT 'gradely',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `video_instructor`
(
    `id`                 int       NOT NULL AUTO_INCREMENT,
    `partner_subject_id` int                DEFAULT NULL,
    `profile_id`         int                DEFAULT NULL COMMENT 'ID if the content or tutor is from third party',
    `firstname`          varchar(100)       DEFAULT NULL,
    `lastname`           varchar(100)       DEFAULT NULL,
    `image`              text,
    `user_id`            int                DEFAULT NULL COMMENT 'If the profile is gradely created profile',
    `subject_id`         int                DEFAULT NULL COMMENT 'gradely subject id',
    `created_by`         int                DEFAULT NULL,
    `updated_by`         int                DEFAULT NULL,
    `created_at`         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         timestamp NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `video_subject`
(
    `id`                 int          NOT NULL AUTO_INCREMENT,
    `category`           varchar(100) NOT NULL,
    `subject_id`         int                   DEFAULT NULL COMMENT 'ID of gradely subject',
    `partner_subject_id` int                   DEFAULT NULL COMMENT 'ID of third party subject',
    `title`              varchar(255) NOT NULL,
    `slug`               varchar(255) NOT NULL,
    `image`              text         NOT NULL,
    `duration_in_days`   int                   DEFAULT NULL,
    `amount`             varchar(50)           DEFAULT NULL,
    `is_free`            int                   DEFAULT NULL,
    `number_of_topics`   int                   DEFAULT NULL,
    `number_of_videos`   int                   DEFAULT NULL,
    `number_of_notes`    int                   DEFAULT NULL,
    `created_by`         int                   DEFAULT NULL,
    `updated_by`         int                   DEFAULT NULL,
    `created_at`         timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         timestamp    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `video_topic`
(
    `id`                 int          NOT NULL AUTO_INCREMENT,
    `category`           varchar(100) NOT NULL,
    `subject_id`         int                   DEFAULT NULL COMMENT 'Gradely subject ID',
    `partner_subject_id` int                   DEFAULT NULL COMMENT 'Third party subject id',
    `topic_id`           int                   DEFAULT NULL COMMENT 'gradely topic id',
    `partner_topic_id`   int                   DEFAULT NULL,
    `title`              varchar(255)          DEFAULT NULL,
    `slug`               varchar(255)          DEFAULT NULL,
    `image`              text,
    `number_of_notes`    int                   DEFAULT NULL,
    `number_of_videos`   int                   DEFAULT NULL,
    `created_by`         int                   DEFAULT NULL,
    `updated_by`         int                   DEFAULT NULL,
    `created_at`         timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         timestamp    NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
