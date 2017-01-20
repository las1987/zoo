-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 20, 2017 at 12:19 PM
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
-- Table structure for table `s_pickuppoints_options`
--
--
-- Структура таблицы 's_pickupoints'
--
DROP TABLE IF EXISTS `s_pickuppoints_options`;

CREATE TABLE `s_pickuppoints_options` (
  `id` int(20) NOT NULL,
  `pickuppoint_id` int(11) NOT NULL,
  `summ_min_value` decimal(10,2) DEFAULT NULL,
  `summ_max_value` decimal(10,2) DEFAULT NULL,
  `pickup_price_value` decimal(6,2) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `s_pickuppoints_options`
--

INSERT INTO `s_pickuppoints_options` (`id`, `pickuppoint_id`, `summ_min_value`, `summ_max_value`, `pickup_price_value`) VALUES
(6, 5, '0.00', '1499.00', '300.00'),
(1, 2, '0.00', '1499.00', '200.00'),
(7, 5, '1500.00', '3000.00', '250.00'),
(8, 4, '0.00', '1499.00', '150.00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `s_pickuppoints_options`
--
ALTER TABLE `s_pickuppoints_options`
  ADD PRIMARY KEY (`id`, `pickuppoint_id`),
  ADD KEY `pickuppoint_id` (`pickuppoint_id`);

--
-- AUTO_INCREMENT for dumped tables
--

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
