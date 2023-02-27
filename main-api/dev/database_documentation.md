## Database Documentation
`Gradely` Database is the primary database for the application. It contains all the data that is used by the application. It is a MySql database that has various tables and relationships between them.

### Tables
#### `academy_calendar`
This table contains the calendar for the school year. It also contains the start and end date for the school year. It has a single value for the current session.

#### `avatar`
This table contains the avatars for the students. It is a lookup table.

#### `cities`
This table contains the list of cities in Nigeria(At the moment). It is a lookup table.

#### `country`
This table contains the list of countries in the world. It is a lookup table.

#### `exam_type`
This table contains the list of exam types. You can add more exam types to this table.

#### `global_class`
This table contains the list of global classes. It is categorization of all classes. e.g Year 1. It is not the same as the actual class name.

#### `school_role`
This table contains the list of roles that a user can have in a school. e.g owner, principal, etc.

#### `security_questions`
This table contains the list of security questions that a user can use to reset their password. It is a lookup table.

#### `states`
This table contains the list of states in Nigeria(At the moment). It is a lookup table.

#### `subjects`
This table contains the list of subjects that a student can study. It has different parameters that will enable you segment them into different class level.

#### `subject_topics`
This table contains the list of topics that a subject can have. Teachers can add more topics to this table during assessment creation.

#### `timezone`
This table contains the list of timezones in the world. It is a lookup table.

## TODO
- [ ] Add more documentation
- [ ] Add more tables
- [ ] Add more relationships
- [ ] Add more information about the tables
- [ ] Add more information about the relationships