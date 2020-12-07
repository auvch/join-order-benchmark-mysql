drop table if exists my_job_result;

create table my_job_result(
  query_name varchar(64),
  query_start datetime,
  query_time_ms bigint
);
-- ### QUERY 10a ##########################################
-- ### Warmup 
-- SELECT MIN(chn.name) AS uncredited_voiced_character, MIN(t.title) AS russian_movie FROM char_name AS chn, cast_info AS ci, company_name AS cn, company_type AS ct, movie_companies AS mc, role_type AS rt, title AS t WHERE ci.note  like '%(voice)%' and ci.note like '%(uncredited)%' AND cn.country_code  = '[ru]' AND rt.role  = 'actor' AND t.production_year > 2005 AND t.id = mc.movie_id AND t.id = ci.movie_id AND ci.movie_id = mc.movie_id AND chn.id = ci.person_role_id AND rt.id = ci.role_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;
-- ### Test run 
select current_timestamp(6) into @query_start;
set @query_name='10a';
SELECT MIN(chn.name) AS uncredited_voiced_character, MIN(t.title) AS russian_movie FROM char_name AS chn, cast_info AS ci, company_name AS cn, company_type AS ct, movie_companies AS mc, role_type AS rt, title AS t WHERE ci.note  like '%(voice)%' and ci.note like '%(uncredited)%' AND cn.country_code  = '[ru]' AND rt.role  = 'actor' AND t.production_year > 2005 AND t.id = mc.movie_id AND t.id = ci.movie_id AND ci.movie_id = mc.movie_id AND chn.id = ci.person_role_id AND rt.id = ci.role_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;
set @query_time_ms= timestampdiff(microsecond, @query_start, current_timestamp(6))/1000;
insert into my_job_result values(@query_name, @query_start, @query_time_ms);
-- ### QUERY 10b ##########################################
-- ### Warmup 
-- SELECT MIN(chn.name) AS ch, MIN(t.title) AS russian_mov_with_actor_producer FROM char_name AS chn, cast_info AS ci, company_name AS cn, company_type AS ct, movie_companies AS mc, role_type AS rt, title AS t WHERE ci.note  like '%(producer)%' AND cn.country_code  = '[ru]' AND rt.role  = 'actor' AND t.production_year > 2010 AND t.id = mc.movie_id AND t.id = ci.movie_id AND ci.movie_id = mc.movie_id AND chn.id = ci.person_role_id AND rt.id = ci.role_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;
-- ### Test run 
select current_timestamp(6) into @query_start;
set @query_name='10b';
SELECT MIN(chn.name) AS ch, MIN(t.title) AS russian_mov_with_actor_producer FROM char_name AS chn, cast_info AS ci, company_name AS cn, company_type AS ct, movie_companies AS mc, role_type AS rt, title AS t WHERE ci.note  like '%(producer)%' AND cn.country_code  = '[ru]' AND rt.role  = 'actor' AND t.production_year > 2010 AND t.id = mc.movie_id AND t.id = ci.movie_id AND ci.movie_id = mc.movie_id AND chn.id = ci.person_role_id AND rt.id = ci.role_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;
set @query_time_ms= timestampdiff(microsecond, @query_start, current_timestamp(6))/1000;
insert into my_job_result values(@query_name, @query_start, @query_time_ms);
