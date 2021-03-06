
CREATE TABLE base.conference_room_role (
  conference_id INTEGER NOT NULL,
  conference_room_id INTEGER NOT NULL,
  event_role TEXT NOT NULL,
  amount INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE conference_room_role (
  FOREIGN KEY (conference_id) REFERENCES conference (conference_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (conference_room_id) REFERENCES conference_room (conference_room_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (event_role) REFERENCES event_role (event_role) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (conference_id, conference_room_id, event_role)
) INHERITS( base.conference_room_role );

CREATE TABLE log.conference_room_role (
) INHERITS( base.logging, base.conference_room_role );

CREATE INDEX log_conference_room_role_conference_room_id_idx ON log.conference_room_role( conference_room_id );
CREATE INDEX log_conference_room_role_log_transaction_id_idx ON log.conference_room_role( log_transaction_id );

