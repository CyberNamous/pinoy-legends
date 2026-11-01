-- Default migration data. Reapplying does not overwrite existing content.
-- All real credentials, staff identities, links and announcements are intentionally absent.
INSERT OR IGNORE INTO settings(key,value) VALUES('site_title','PINOY LEGENDS');
INSERT OR IGNORE INTO settings(key,value) VALUES('tagline','A Filipino Dream. A Legendary Battle.');
INSERT OR IGNORE INTO settings(key,value) VALUES('discord_url','');
INSERT OR IGNORE INTO settings(key,value) VALUES('official_email','');
INSERT OR IGNORE INTO settings(key,value) VALUES('appeals_contact','');
INSERT OR IGNORE INTO settings(key,value) VALUES('youtube_url','');
INSERT OR IGNORE INTO settings(key,value) VALUES('facebook_url','');
INSERT OR IGNORE INTO settings(key,value) VALUES('tiktok_url','');
INSERT OR IGNORE INTO settings(key,value) VALUES('x_url','');
INSERT OR IGNORE INTO settings(key,value) VALUES('creator_url','');
INSERT OR IGNORE INTO settings(key,value) VALUES('creator_title','Create with the community');
INSERT OR IGNORE INTO settings(key,value) VALUES('creator_body','Creator Program details will be published by the team. The application link has not been configured yet.');
INSERT OR IGNORE INTO settings(key,value) VALUES('download_mode','Coming soon');
INSERT OR IGNORE INTO settings(key,value) VALUES('download_url','');
INSERT OR IGNORE INTO settings(key,value) VALUES('testing_status','Coming soon');
INSERT OR IGNORE INTO settings(key,value) VALUES('logo_key','');
INSERT OR IGNORE INTO settings(key,value) VALUES('banner_key','');
INSERT OR IGNORE INTO settings(key,value) VALUES('content_version','initial');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('hero',1,0,'{"label": "A new generation of 5v5 MOBA", "title": "Fight for your lane. Play for your pride.", "body": "A new 5v5 mobile MOBA experience built around strategic team play, unique heroes, and competitive battles.", "button_label": "Join the Testing →", "button_url": "", "image_key": ""}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('announcement_bar',1,1,'{}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('pinned',1,2,'{}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('feed',1,3,'{"title": "From the team"}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('about',1,4,'{"label": "About the game", "title": "A Filipino-made MOBA experience", "body": "Pinoy Legends is an independent game project, proudly created for players who love strategy, teamwork, and competitive gameplay.", "button_label": "Learn more", "button_url": ""}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('featured',1,5,'{"featured_ids": []}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('development',1,6,'{"title": "Building the battlefield.", "phase": "Game Development", "progress": 0}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('updates',1,7,'{"title": "Stay updated", "body": "Get the latest news, patch notes, and announcements."}');
INSERT OR IGNORE INTO sections(key,visible,sort_order,content) VALUES('community',1,8,'{"title": "Be part of the journey", "body": "Join our official Discord server and connect with the community.", "button_label": "Join Discord", "button_url": ""}');
INSERT OR IGNORE INTO nav_items(key,label,visible,sort_order) VALUES('home','Home',1,0);
INSERT OR IGNORE INTO nav_items(key,label,visible,sort_order) VALUES('news','News',1,1);
INSERT OR IGNORE INTO nav_items(key,label,visible,sort_order) VALUES('heroes','Heroes',1,2);
INSERT OR IGNORE INTO nav_items(key,label,visible,sort_order) VALUES('creators','Creators',1,3);
INSERT OR IGNORE INTO nav_items(key,label,visible,sort_order) VALUES('staff','Staff',1,4);
INSERT OR IGNORE INTO nav_items(key,label,visible,sort_order) VALUES('download','Download',0,5);
INSERT OR IGNORE INTO heroes(id,name,role,description,visible,sort_order) VALUES(1,'[Hero name — Tank]','Tank','[Owner to supply hero description and artwork]',0,0);
INSERT OR IGNORE INTO heroes(id,name,role,description,visible,sort_order) VALUES(2,'[Hero name — Mage]','Mage','[Owner to supply hero description and artwork]',0,1);
INSERT OR IGNORE INTO heroes(id,name,role,description,visible,sort_order) VALUES(3,'[Hero name — Marksman]','Marksman','[Owner to supply hero description and artwork]',0,2);
INSERT OR IGNORE INTO heroes(id,name,role,description,visible,sort_order) VALUES(4,'[Hero name — Assassin]','Assassin','[Owner to supply hero description and artwork]',0,3);
INSERT OR IGNORE INTO heroes(id,name,role,description,visible,sort_order) VALUES(5,'[Hero name — Support]','Support','[Owner to supply hero description and artwork]',0,4);
INSERT OR IGNORE INTO heroes(id,name,role,description,visible,sort_order) VALUES(6,'[Hero name — Fighter]','Fighter','[Owner to supply hero description and artwork]',0,5);
INSERT OR IGNORE INTO legal_pages(slug,title,body) VALUES('terms','Terms of Use','Draft — review required before public launch.

Pinoy Legends is an independent Filipino-made 5v5 mobile MOBA currently in development. Features, testing schedules and availability may change. This website does not promise access to testing or a finished game.

Use this website respectfully. Do not impersonate staff, abuse other players, submit unlawful content, or try to disrupt the service. Feedback must not contain sensitive personal information. You retain ownership of your feedback and allow the team to read and use it to improve the project.

Discord login is optional for public browsing. When you log in, we store your Discord ID, username and avatar hash to recognize you, show your profile and authorize staff access. Do not share your session or attempt to access another account. Admin access can be suspended or revoked by the Owner.

Art, logos and other project materials remain the property of their respective owners. Do not claim ownership of another person''s work. External services, including Discord and application forms, operate under their own terms.

No game download is offered unless an official link is published. Watch for impersonators. Appeals are handled through the appeals contact listed on Contact Us, not the feedback form.

The service is provided as available, subject to applicable law. These terms do not remove any rights that cannot legally be waived. The Owner must review these draft terms, legal identity, jurisdiction, age requirements and contact details before launch. See Contact Us for currently configured contact options.');
INSERT OR IGNORE INTO legal_pages(slug,title,body) VALUES('privacy','Privacy Policy','Draft — review required before public launch.

What we store: When you choose Discord login, we request the identify scope only. We store your Discord ID, username and avatar hash in Cloudflare D1 to recognize your account, display your profile and apply server-side staff permissions. We do not request your email, contacts, guild list or messages. Discord access tokens are used during login only and are not stored after login completes.

Sessions: A signed, Secure, HttpOnly, SameSite=Lax cookie keeps you logged in for up to seven days. A short-lived state cookie protects the Discord login flow for ten minutes. Logout deletes the current server session and cookie. These cookies are necessary for login, not advertising.

Feedback: If you submit the contact form, we store the type, message, optional Discord name, status and submission time so staff can review it. Do not include passwords, private account details or other sensitive information. Appeals go to the separately listed appeals contact.

Operations: Staff actions are recorded with the acting staff account, action, area, item and time for accountability. Uploaded managed images are stored only in Cloudflare R2; D1 contains image metadata and object keys, not image bytes. A per-request IP address is used transiently to derive a daily HMAC rate-limit key; this application does not persist raw IP addresses. Expired rate-limit records are removed during later requests.

Providers: Cloudflare hosts and secures the service and may process network information under its own policies. If the Owner enables Turnstile, its spam verification is used on feedback. Google Fonts supplies Inter and receives the network information needed to deliver the font. Discord hosts login and avatars. External social and application links take you to services with their own privacy practices. We use no third-party analytics or advertising trackers.

Retention and choices: Expired sessions are cleaned during later logins. User accounts and feedback are retained for project operation until the Owner removes them or establishes a reviewed retention schedule. Audit entries are retained for security accountability. The Owner can review and remove records through the Cloudflare D1 Dashboard; contact the configured official email to request access, correction or deletion, subject to applicable law and necessary security retention.

Before launch, the Owner must review this draft and publish the responsible entity, lawful basis, appropriate retention periods, age requirements, rights process and working privacy contact. The current contact options are on Contact Us.');
