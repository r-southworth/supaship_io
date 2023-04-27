create table user_profiles (
    user_id uuid primary key references auth.users (id) not null,
    username text unique not null
    CONSTRAINT proper_username CHECK (username~*'^[a-zA-Z0-9_]+$')
    CONSTRAINT username_length CHECK (char_length(username) > 3 and char_length(username) < 15)
);

alter table user_profiles enable row level security;

CREATE POLICY "All can see" ON "public"."user_profiles"
AS PERMISSIVE FOR SELECT 
to public
USING (true);

CREATE POLICY "users can insert" ON "public"."user_profiles"
AS PERMISSIVE FOR INSERT
to public
WITH CHECK (auth.uid() = user_id);


CREATE POLICY "owners can update" ON "public"."user_profiles"
AS PERMISSIVE FOR UPDATE
to public
USING (auth.uid()=user_id)
WITH CHECK (auth.uid()=user_id);
