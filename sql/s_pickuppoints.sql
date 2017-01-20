-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 20, 2017 at 12:12 PM
-- Server version: 10.1.19-MariaDB
-- PHP Version: 5.6.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `simpla`
--

-- --------------------------------------------------------

--
-- Table structure for table `s_pickuppoints`
--
DROP TABLE IF EXISTS `s_pickuppoints`;

CREATE TABLE `s_pickuppoints` (
  `id` int(20) NOT NULL,
  `body` longtext,
  `pickuppoint_url` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `metro_station` varchar(255) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `web_site` varchar(255) NOT NULL,
  `worktime` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `summ_limit` decimal(10,2) DEFAULT '0.00',
  `weight_limit` int(6) DEFAULT '0',
  `sides_limit` int(6) DEFAULT '0',
  `dimensions_limit` decimal(6,3) DEFAULT '0.000',
  `size_limit` int(6) DEFAULT '0',
  `enabled` int(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `s_pickuppoints`
--

INSERT INTO `s_pickuppoints` (`id`, `body`, `pickuppoint_url`, `name`, `metro_station`, `address`, `latitude`, `longitude`, `photo`, `url`, `web_site`, `worktime`, `phone`, `summ_limit`, `weight_limit`, `sides_limit`, `dimensions_limit`, `size_limit`, `enabled`) VALUES
(2, '', NULL, 'ПУНКТ ВЫДАЧИ ИНТЕРНЕТ ЗАКАЗОВ М.МОСКОВСКАЯ', 'Московская', '196066, Санкт-Петербург, Алтайская улица, 16 ', '59.8497', '30.327115', NULL, 'punkt-vydachi-internet-zakazov-mmoskovskaya', '', 'пн-вс с 10-22', '8 (812) 407-20-24', '0.00', 10, 150, '0.125', 0, 1),
(3, '', NULL, 'ПУНКТ ВЫДАЧИ ИНТЕРНЕТ ЗАКАЗОВ М.ПИОНЕРСКАЯ', 'Пионерская', '197438, Санкт-Петербург, Коломяжский проспект, 15к2 ', '60.001109', '30.299734', NULL, 'punkt-vydachi-internet-zakazov-mpionerskaya', '', 'пн-вс 10-21', '8 (812) 407-36-20', '0.00', 10, 150, '0.125', 0, 1),
(4, '', NULL, 'ПУНКТ ВЫДАЧИ ИНТЕРНЕТ ЗАКАЗОВ М.ОЗЕРКИ', 'Озерки', '194354, Санкт-Петербург, проспект Энгельса, 113к1 ', '60.037836', '30.325633', NULL, 'punkt-vydachi-internet-zakazov-mozerki', '', 'пн-вс 10-20', '8 (812) 407-36-20', '0.00', 20, 200, '0.296', 100, 1),
(5, '', NULL, 'ПУНКТ ВЫДАЧИ ИНТЕРНЕТ ЗАКАЗОВ DPD 1', 'Всеволожск', 'г. Всеволожск, улица Плоткина, 21к1 ', '60.024239', '30.642837', NULL, 'punkt-vydachi-internet-zakazov-dpd-1', '', 'пн-вс 10-21', '8 (812) 407-20-24', '0.00', 7, 180, '0.216', 60, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `s_pickuppoints`
--
ALTER TABLE `s_pickuppoints`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `s_pickuppoints`
--
ALTER TABLE `s_pickuppoints`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
