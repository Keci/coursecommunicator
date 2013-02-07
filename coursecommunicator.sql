-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 07. Februar 2013 um 19:02
-- Server Version: 5.5.8
-- PHP-Version: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `coursecommunicator`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auth_group`
--

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Daten für Tabelle `auth_group`
--


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auth_group_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_425ae3c4` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Daten für Tabelle `auth_group_permissions`
--


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auth_permission`
--

CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_1bb8f392` (`content_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=46 ;

--
-- Daten für Tabelle `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add permission', 1, 'add_permission'),
(2, 'Can change permission', 1, 'change_permission'),
(3, 'Can delete permission', 1, 'delete_permission'),
(4, 'Can add group', 2, 'add_group'),
(5, 'Can change group', 2, 'change_group'),
(6, 'Can delete group', 2, 'delete_group'),
(7, 'Can add user', 3, 'add_user'),
(8, 'Can change user', 3, 'change_user'),
(9, 'Can delete user', 3, 'delete_user'),
(10, 'Can add content type', 4, 'add_contenttype'),
(11, 'Can change content type', 4, 'change_contenttype'),
(12, 'Can delete content type', 4, 'delete_contenttype'),
(13, 'Can add session', 5, 'add_session'),
(14, 'Can change session', 5, 'change_session'),
(15, 'Can delete session', 5, 'delete_session'),
(16, 'Can add site', 6, 'add_site'),
(17, 'Can change site', 6, 'change_site'),
(18, 'Can delete site', 6, 'delete_site'),
(19, 'Can add post', 7, 'add_post'),
(20, 'Can change post', 7, 'change_post'),
(21, 'Can delete post', 7, 'delete_post'),
(22, 'Can add tag', 8, 'add_tag'),
(23, 'Can change tag', 8, 'change_tag'),
(24, 'Can delete tag', 8, 'delete_tag'),
(25, 'Can add post tag', 9, 'add_posttag'),
(26, 'Can change post tag', 9, 'change_posttag'),
(27, 'Can delete post tag', 9, 'delete_posttag'),
(28, 'Can add log entry', 10, 'add_logentry'),
(29, 'Can change log entry', 10, 'change_logentry'),
(30, 'Can delete log entry', 10, 'delete_logentry'),
(31, 'Can add avatar', 11, 'add_avatar'),
(32, 'Can change avatar', 11, 'change_avatar'),
(33, 'Can delete avatar', 11, 'delete_avatar'),
(34, 'Can add user', 12, 'add_user'),
(35, 'Can change user', 12, 'change_user'),
(36, 'Can delete user', 12, 'delete_user'),
(37, 'Can add api access', 13, 'add_apiaccess'),
(38, 'Can change api access', 13, 'change_apiaccess'),
(39, 'Can delete api access', 13, 'delete_apiaccess'),
(40, 'Can add api key', 14, 'add_apikey'),
(41, 'Can change api key', 14, 'change_apikey'),
(42, 'Can delete api key', 14, 'delete_apikey'),
(43, 'Can add post vote', 15, 'add_postvote'),
(44, 'Can change post vote', 15, 'change_postvote'),
(45, 'Can delete post vote', 15, 'delete_postvote');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auth_user`
--

CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Daten für Tabelle `auth_user`
--

INSERT INTO `auth_user` (`id`, `username`, `first_name`, `last_name`, `email`, `password`, `is_staff`, `is_active`, `is_superuser`, `last_login`, `date_joined`) VALUES
(2, 'daniel', '', '', 'e0825310@student.tuwien.ac.at', 'pbkdf2_sha256$10000$SCEXwsFwmdS8$F3a/nBbeX2Ajl1UFL3mGapQIAn5sHTkxD3SL8UtcxzQ=', 1, 1, 1, '2013-01-30 20:24:20', '2013-01-05 16:05:23');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auth_user_groups`
--

CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_403f60f` (`user_id`),
  KEY `auth_user_groups_425ae3c4` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Daten für Tabelle `auth_user_groups`
--


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auth_user_user_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_403f60f` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Daten für Tabelle `auth_user_user_permissions`
--


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `django_admin_log`
--

CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_403f60f` (`user_id`),
  KEY `django_admin_log_1bb8f392` (`content_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Daten für Tabelle `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `user_id`, `content_type_id`, `object_id`, `object_repr`, `action_flag`, `change_message`) VALUES
(1, '2013-01-05 16:22:16', 2, 11, '1', 'Avatar object', 1, ''),
(2, '2013-01-05 16:22:18', 2, 11, '2', 'Avatar object', 1, ''),
(3, '2013-01-05 16:22:20', 2, 11, '3', 'Avatar object', 1, ''),
(4, '2013-01-05 16:22:23', 2, 11, '4', 'Avatar object', 1, ''),
(5, '2013-01-05 16:23:54', 2, 12, '1', 'User object', 1, ''),
(6, '2013-01-05 16:24:27', 2, 12, '2', 'User object', 1, ''),
(7, '2013-01-05 16:25:08', 2, 12, '3', 'User object', 1, ''),
(8, '2013-01-05 16:25:48', 2, 12, '4', 'User object', 1, ''),
(9, '2013-01-05 16:54:54', 2, 7, '1', 'Post object', 1, ''),
(10, '2013-01-05 16:55:38', 2, 7, '2', 'Post object', 1, '');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `django_content_type`
--

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Daten für Tabelle `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `name`, `app_label`, `model`) VALUES
(1, 'permission', 'auth', 'permission'),
(2, 'group', 'auth', 'group'),
(3, 'user', 'auth', 'user'),
(4, 'content type', 'contenttypes', 'contenttype'),
(5, 'session', 'sessions', 'session'),
(6, 'site', 'sites', 'site'),
(7, 'post', 'posts', 'post'),
(8, 'tag', 'posts', 'tag'),
(9, 'post tag', 'posts', 'posttag'),
(10, 'log entry', 'admin', 'logentry'),
(11, 'avatar', 'users', 'avatar'),
(12, 'user', 'users', 'user'),
(13, 'api access', 'tastypie', 'apiaccess'),
(14, 'api key', 'tastypie', 'apikey'),
(15, 'post vote', 'posts', 'postvote');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `django_session`
--

CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_3da3d3d8` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('7ea628e6fe102643c362df4f476bfd2f', 'Y2RiMjA0YzVlODEzZWNiNjUwZGZjMjA1ZmMyYzEyYTljZmQ0OGZlYTqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQJ1Lg==\n', '2013-01-19 16:05:35'),
('a1e810f4dff2579ff28627bdf78aa656', 'Y2RiMjA0YzVlODEzZWNiNjUwZGZjMjA1ZmMyYzEyYTljZmQ0OGZlYTqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQJ1Lg==\n', '2013-01-20 12:57:43'),
('b1a4200fa5e02a442e9b5127dfdf5cd5', 'Y2RiMjA0YzVlODEzZWNiNjUwZGZjMjA1ZmMyYzEyYTljZmQ0OGZlYTqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQJ1Lg==\n', '2013-02-13 20:24:21'),
('c6191683e787efb1e47348f7fe1b87e4', 'Y2RiMjA0YzVlODEzZWNiNjUwZGZjMjA1ZmMyYzEyYTljZmQ0OGZlYTqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQJ1Lg==\n', '2013-02-13 20:24:14');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `django_site`
--

CREATE TABLE IF NOT EXISTS `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `django_site`
--

INSERT INTO `django_site` (`id`, `domain`, `name`) VALUES
(1, 'example.com', 'example.com');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `posts_post`
--

CREATE TABLE IF NOT EXISTS `posts_post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentpost_id` int(11) DEFAULT NULL,
  `username_id` int(11) NOT NULL,
  `pubdate` datetime NOT NULL,
  `text` longtext NOT NULL,
  `votes` int(11) NOT NULL,
  `goodpost` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_post_7cea4864` (`parentpost_id`),
  KEY `posts_post_5ee6f4a4` (`username_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=70 ;

--
-- Daten für Tabelle `posts_post`
--

INSERT INTO `posts_post` (`id`, `parentpost_id`, `username_id`, `pubdate`, `text`, `votes`, `goodpost`) VALUES
(1, NULL, 1, '2013-01-05 16:54:41', 'Test Test Test - das ist ein Testeintrag ... lg johndoe', 8, 0),
(2, 1, 2, '2013-01-05 17:30:24', 'hast du gut gemacht', 2, 0),
(3, 1, 3, '2013-01-06 17:10:21', 'finde ich auch! aber ich hätte eine frage: wie hast du den beitrag erstellt? ich finde das nirgends und kenne mich hier noch gar nicht aus :/', 4, 2),
(4, 1, 4, '2013-01-06 18:11:12', 'ich habe die lösung nun gefunden! man muss rechts oben auf das comment icon klicken - dann erscheint automatisch das formular zum erstellen eines neuen beitrags. so einfach ist das :) ', 0, 1),
(5, NULL, 4, '2013-01-07 12:12:25', 'wie geht es euch?', 21, 0),
(6, NULL, 3, '2013-01-08 09:00:10', 'was gibt es neues? was gibt es neues? was gibt es neues? was gibt es neues? was gibt es neues? was gibt es neues? was gibt es neues? was gibt es neues?', 8, 0),
(13, 6, 1, '2013-01-09 17:14:06', 'nix.', 0, 0),
(65, NULL, 1, '2013-02-03 15:07:46', 'hallo, dieser beitrag ist ein test!', 0, 0),
(66, 65, 1, '2013-02-03 15:08:01', 'und das hier ist eine antwort!', 0, 0),
(67, 65, 1, '2013-02-04 08:34:21', 'noch eine antwort', 0, 0),
(68, 65, 1, '2013-02-04 08:47:47', 'another answer', 1, 0),
(69, 1, 1, '2013-02-04 08:48:01', 'testantwort', 0, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `posts_posttag`
--

CREATE TABLE IF NOT EXISTS `posts_posttag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_posttag_699ae8ca` (`post_id`),
  KEY `posts_posttag_3747b463` (`tag_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Daten für Tabelle `posts_posttag`
--

INSERT INTO `posts_posttag` (`id`, `post_id`, `tag_id`) VALUES
(1, 1, 1),
(2, 1, 4),
(3, 5, 2),
(4, 5, 5),
(5, 6, 2),
(15, 65, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `posts_postvote`
--

CREATE TABLE IF NOT EXISTS `posts_postvote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `username_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_postvote_699ae8ca` (`post_id`),
  KEY `posts_postvote_5ee6f4a4` (`username_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Daten für Tabelle `posts_postvote`
--

INSERT INTO `posts_postvote` (`id`, `post_id`, `username_id`) VALUES
(1, 13, 1),
(2, 6, 1),
(3, 65, 1),
(4, 68, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `posts_tag`
--

CREATE TABLE IF NOT EXISTS `posts_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Daten für Tabelle `posts_tag`
--

INSERT INTO `posts_tag` (`id`, `name`) VALUES
(1, 'announcement'),
(2, 'question'),
(3, 'discussion'),
(4, 'bsptag1'),
(5, 'bsptag2');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tastypie_apiaccess`
--

CREATE TABLE IF NOT EXISTS `tastypie_apiaccess` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `request_method` varchar(10) NOT NULL,
  `accessed` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Daten für Tabelle `tastypie_apiaccess`
--


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tastypie_apikey`
--

CREATE TABLE IF NOT EXISTS `tastypie_apikey` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key` varchar(256) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Daten für Tabelle `tastypie_apikey`
--


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `users_avatar`
--

CREATE TABLE IF NOT EXISTS `users_avatar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cssclass` varchar(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Daten für Tabelle `users_avatar`
--

INSERT INTO `users_avatar` (`id`, `cssclass`) VALUES
(1, 'a'),
(2, 'b'),
(3, 'c'),
(4, 'd');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `users_user`
--

CREATE TABLE IF NOT EXISTS `users_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `avatar_id` int(11) NOT NULL,
  `email` varchar(75) NOT NULL,
  `statement` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `users_user_705e5827` (`avatar_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Daten für Tabelle `users_user`
--

INSERT INTO `users_user` (`id`, `name`, `avatar_id`, `email`, `statement`) VALUES
(1, 'johndoe', 1, 'johndoe123@johndoe123.com', 'what would i know?'),
(2, 'maxmustermann', 4, 'maxmustermann123@maxmustermann123.com', 'what goes around comes around ...'),
(3, 'jackson', 3, 'jackson4781@jackson4781.com', 'hmm ...'),
(4, '0825310', 2, 'e0825310@student.tuwien.ac.at', 'lalalala');

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `group_id_refs_id_3cea63fe` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `permission_id_refs_id_5886d21f` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Constraints der Tabelle `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `content_type_id_refs_id_728de91f` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints der Tabelle `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `group_id_refs_id_f116770` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `user_id_refs_id_7ceef80f` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints der Tabelle `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `user_id_refs_id_dfbab7d` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints der Tabelle `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `content_type_id_refs_id_288599e6` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `user_id_refs_id_c8665aa` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints der Tabelle `posts_post`
--
ALTER TABLE `posts_post`
  ADD CONSTRAINT `parentpost_id_refs_id_4d404993` FOREIGN KEY (`parentpost_id`) REFERENCES `posts_post` (`id`),
  ADD CONSTRAINT `username_id_refs_id_7dc1565f` FOREIGN KEY (`username_id`) REFERENCES `users_user` (`id`);

--
-- Constraints der Tabelle `posts_posttag`
--
ALTER TABLE `posts_posttag`
  ADD CONSTRAINT `post_id_refs_id_779b622c` FOREIGN KEY (`post_id`) REFERENCES `posts_post` (`id`),
  ADD CONSTRAINT `tag_id_refs_id_4ba1edc5` FOREIGN KEY (`tag_id`) REFERENCES `posts_tag` (`id`);

--
-- Constraints der Tabelle `posts_postvote`
--
ALTER TABLE `posts_postvote`
  ADD CONSTRAINT `post_id_refs_id_1a1bcd15` FOREIGN KEY (`post_id`) REFERENCES `posts_post` (`id`),
  ADD CONSTRAINT `username_id_refs_id_c00b4f9` FOREIGN KEY (`username_id`) REFERENCES `users_user` (`id`);

--
-- Constraints der Tabelle `tastypie_apikey`
--
ALTER TABLE `tastypie_apikey`
  ADD CONSTRAINT `user_id_refs_id_56bfdb62` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints der Tabelle `users_user`
--
ALTER TABLE `users_user`
  ADD CONSTRAINT `avatar_id_refs_id_72a978f9` FOREIGN KEY (`avatar_id`) REFERENCES `users_avatar` (`id`);
