--
-- Структура таблицы 's_pickupoints'
--
DROP TABLE IF EXISTS `s_pickuppoints`;
CREATE TABLE `s_pickuppoints` (
  `id` int(20) NOT NULL,
  `body` varchar(255),
  `pickuppoint_url` varchar(255),
  `name` varchar(255) NOT NULL,
  `metro_station` varchar(255),
  `address` varchar(255) NOT NULL,
  `latitude` varchar(255),
  `longitude` varchar(255),
  `photo` varchar(255),
  `url` varchar(255) NOT NULL,
  `worktime` varchar(255) NOT NULL,
  `phone` varchar(255),
  `summ_limit` decimal(10,2) DEFAULT '0',
  `weight_limit` int(6) DEFAULT '0',
  `sides_limit` int(6) DEFAULT '0',
  `dimensions_limit` decimal(6,3) DEFAULT '0',
  `size_limit` int(6) DEFAULT NULL DEFAULT '0',
  `enabled` int(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
--
-- Индексы таблицы `s_pickupoints`
--
ALTER TABLE `s_pickuppoints`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `s_pickupoints`
--
ALTER TABLE `s_pickuppoints`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=0;