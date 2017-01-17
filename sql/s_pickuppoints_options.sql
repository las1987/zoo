--
-- Структура таблицы 's_pickupoints_options'
--
DROP TABLE IF EXISTS `s_pickuppoints_options`;
CREATE TABLE `s_pickuppoints_options` (
  `id` int(20) NOT NULL,
  `pickuppoint_id` int(11) NOT NULL,
  `summ_min_value` decimal(10,2),
  `summ_max_value` decimal(10,2),
  `pickup_price_value` decimal(6,2) DEFAULT NULL
  
  
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

--
-- Индексы таблицы `s_pickupoints_options`
--
ALTER TABLE `s_pickuppoints_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pickuppoint_id` (`pickuppoint_id`);

  --
-- AUTO_INCREMENT для таблицы `s_pickupoints_options`
--
 ALTER TABLE `s_pickuppoints_options`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=0;