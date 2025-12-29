-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 29, 2025 at 03:04 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `easyfood_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int(11) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `shop_name` varchar(30) NOT NULL,
  `shop_image` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 29, 2025 at 03:04 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `easyfood_db`
--

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `label`, `latitude`, `longitude`, `details`) VALUES
(1, 1, 'Rumah', -6.2000000, 106.8166660, 'Jl. Mawar No. 123');

-- --------------------------------------------------------

--
-- Table structure for table `customer_order`
--

CREATE TABLE `customer_order` (
  `id` int(11) NOT NULL,
  `order_id` varchar(30) NOT NULL,
  `customer` varchar(50) NOT NULL,
  `date_order` date NOT NULL,
  `product_ordered` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `total_price` decimal(10,0) NOT NULL,
  `status_order` varchar(50) NOT NULL,
  `is_archived` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_order`
--

INSERT INTO `customer_order` (`id`, `order_id`, `customer`, `date_order`, `product_ordered`, `quantity`, `total_price`, `status_order`, `is_archived`) VALUES
(181, 'ORD-07B879A3F9', 'ade rizky', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'WAITING_PAYMENT', 0),
(182, 'ORD-40FA4B3D66', 'ade rizky', '2025-12-29', 'Ayam Geprek Original', 4, 88000, 'WAITING_PAYMENT', 0),
(183, 'ORD-B1D982DA30', 'ade rizky', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'WAITING_PAYMENT', 0),
(184, 'ORD-041F626100', 'ade rizky', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'WAITING_PAYMENT', 0),
(185, 'ORD-16AEC90C4F', 'ade rizky', '2025-12-29', 'Ayam Geprek Original', 1, 22000, 'WAITING_PAYMENT', 0),
(186, 'ORD-16AEC90C4F', 'ade rizky', '2025-12-29', 'Cheese Pizza', 1, 50000, 'WAITING_PAYMENT', 0),
(187, 'ORD-E27E5DFC49', 'ade rizky', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'WAITING_PAYMENT', 0),
(188, 'ORD-3C8045F2EC', 'sadewa', '2025-12-29', 'Geprek Original', 2, 44000, 'WAITING_SPLIT_PAYMENT', 0),
(189, 'ORD-3C8045F2EC', 'sadewa', '2025-12-29', 'Geprek Sambal Matah', 1, 25000, 'WAITING_SPLIT_PAYMENT', 0),
(190, 'ORD-A1CBCADA37', 'sadewa', '2025-12-29', 'Ayam Geprek Original', 6, 132000, 'WAITING_PAYMENT', 0),
(191, 'ORD-BC2804E5FF', 'sadewa', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'WAITING_PAYMENT', 0),
(192, 'ORD-3CB5E30347', 'sadewa', '2025-12-29', 'Ayam Geprek Original', 3, 66000, 'WAITING_PAYMENT', 0),
(193, 'ORD-4DC88974EB', 'ade rizky', '2025-12-29', 'Ayam Geprek Original', 3, 66000, 'WAITING_PAYMENT', 0),
(194, 'ORD-2A185135B8', 'sadewa', '2025-12-29', 'Vegan Burger', 1, 30000, 'Delivered', 0),
(195, 'ORD-2A185135B8', 'sadewa', '2025-12-29', 'Salad Bowl', 2, 50000, 'Delivered', 0),
(196, 'ORD-8A0BF2A93A', 'sadewa', '2025-12-29', 'Vegan Burger', 2, 60000, 'Order_Confirmed', 0),
(197, 'ORD-4A4421D1EE', 'sadewa', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'WAITING_SPLIT_PAYMENT', 0),
(198, 'ORD-4A4421D1EE', 'sadewa', '2025-12-29', 'Ayam Geprek Keju', 1, 27000, 'WAITING_SPLIT_PAYMENT', 0),
(199, 'ORD-5B7AC5EEBB', 'sadewa', '2025-12-29', 'Chicken Burger', 1, 26000, 'Order_Confirmed', 0),
(200, 'ORD-D50A7748C1', 'sadewa', '2025-12-29', 'Gurame Bakar', 3, 225000, 'WAITING_PAYMENT', 0),
(201, 'ORD-A9C64BC542', 'sadewa', '2025-12-29', 'Chicken Burger', 5, 130000, 'WAITING_SPLIT_PAYMENT', 0),
(202, 'ORD-A9C64BC542', 'sadewa', '2025-12-29', 'Cheese Burger', 1, 32000, 'WAITING_SPLIT_PAYMENT', 0),
(203, 'ORD-2C306CF6F6', 'sadewa', '2025-12-29', 'Ayam Geprek Sambal Ijo', 3, 75000, 'WAITING_SPLIT_PAYMENT', 0),
(204, 'ORD-2C306CF6F6', 'sadewa', '2025-12-29', 'Ayam Geprek Keju', 1, 27000, 'WAITING_SPLIT_PAYMENT', 0),
(205, 'ORD-1358B8F4CF', 'sadewa', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'WAITING_SPLIT_PAYMENT', 0),
(206, 'ORD-7F51F00012', 'sadewa', '2025-12-29', 'Ayam Geprek Original', 2, 44000, 'Delivered', 0),
(207, 'ORD-606C06B9BD', 'orang hitam', '2025-12-29', 'Americano', 1, 15000, 'Order_Confirmed', 0),
(208, 'ORD-606C06B9BD', 'orang hitam', '2025-12-29', 'Es Kopi Susu', 2, 36000, 'Order_Confirmed', 0);

-- --------------------------------------------------------

--
-- Table structure for table `customer_order_items`
--

CREATE TABLE `customer_order_items` (
  `id` int(11) NOT NULL,
  `order_id` varchar(30) DEFAULT NULL,
  `menu_name` varchar(100) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_order_items`
--

INSERT INTO `customer_order_items` (`id`, `order_id`, `menu_name`, `qty`, `price`) VALUES
(224, 'ORD-07B879A3F9', 'Ayam Geprek Original', 2, 22000.00),
(225, 'ORD-40FA4B3D66', 'Ayam Geprek Original', 4, 22000.00),
(226, 'ORD-B1D982DA30', 'Ayam Geprek Original', 2, 22000.00),
(227, 'ORD-041F626100', 'Ayam Geprek Original', 2, 22000.00),
(228, 'ORD-16AEC90C4F', 'Ayam Geprek Original', 1, 22000.00),
(229, 'ORD-16AEC90C4F', 'Cheese Pizza', 1, 50000.00),
(230, 'ORD-E27E5DFC49', 'Ayam Geprek Original', 2, 22000.00),
(231, 'ORD-3C8045F2EC', 'Geprek Original', 2, 22000.00),
(232, 'ORD-3C8045F2EC', 'Geprek Sambal Matah', 1, 25000.00),
(233, 'ORD-A1CBCADA37', 'Ayam Geprek Original', 6, 22000.00),
(234, 'ORD-BC2804E5FF', 'Ayam Geprek Original', 2, 22000.00),
(235, 'ORD-3CB5E30347', 'Ayam Geprek Original', 3, 22000.00),
(236, 'ORD-4DC88974EB', 'Ayam Geprek Original', 3, 22000.00),
(237, 'ORD-2A185135B8', 'Vegan Burger', 1, 30000.00),
(238, 'ORD-2A185135B8', 'Salad Bowl', 2, 25000.00),
(239, 'ORD-8A0BF2A93A', 'Vegan Burger', 2, 30000.00),
(240, 'ORD-4A4421D1EE', 'Ayam Geprek Original', 2, 22000.00),
(241, 'ORD-4A4421D1EE', 'Ayam Geprek Keju', 1, 27000.00),
(242, 'ORD-5B7AC5EEBB', 'Chicken Burger', 1, 26000.00),
(243, 'ORD-D50A7748C1', 'Gurame Bakar', 3, 75000.00),
(244, 'ORD-A9C64BC542', 'Chicken Burger', 5, 26000.00),
(245, 'ORD-A9C64BC542', 'Cheese Burger', 1, 32000.00),
(246, 'ORD-2C306CF6F6', 'Ayam Geprek Sambal Ijo', 3, 25000.00),
(247, 'ORD-2C306CF6F6', 'Ayam Geprek Keju', 1, 27000.00),
(248, 'ORD-1358B8F4CF', 'Ayam Geprek Original', 2, 22000.00),
(249, 'ORD-7F51F00012', 'Ayam Geprek Original', 2, 22000.00),
(250, 'ORD-606C06B9BD', 'Americano', 1, 15000.00),
(251, 'ORD-606C06B9BD', 'Es Kopi Susu', 2, 18000.00);

-- --------------------------------------------------------

--
-- Table structure for table `customer_order_master`
--

CREATE TABLE `customer_order_master` (
  `id` int(11) NOT NULL,
  `order_id` varchar(30) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status_order` varchar(30) DEFAULT NULL,
  `is_split` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_order_master`
--

INSERT INTO `customer_order_master` (`id`, `order_id`, `user_id`, `store_id`, `driver_id`, `total_price`, `status_order`, `is_split`, `created_at`) VALUES
(152, 'ORD-07B879A3F9', 2, 1, 15, 59517.82, 'WAITING_PAYMENT', 0, '2025-12-29 11:01:47'),
(153, 'ORD-40FA4B3D66', 2, 1, 15, 103517.82, 'WAITING_PAYMENT', 0, '2025-12-29 11:55:43'),
(154, 'ORD-B1D982DA30', 2, 1, 8, 64917.06, 'WAITING_PAYMENT', 0, '2025-12-29 12:20:35'),
(155, 'ORD-041F626100', 2, 1, 11, 64507.38, 'WAITING_PAYMENT', 0, '2025-12-29 12:24:14'),
(156, 'ORD-16AEC90C4F', 2, 1, 15, 87517.82, 'WAITING_PAYMENT', 0, '2025-12-29 12:36:26'),
(157, 'ORD-E27E5DFC49', 2, 1, 19, 73575.93, 'WAITING_PAYMENT', 0, '2025-12-29 13:00:47'),
(158, 'ORD-3C8045F2EC', 6, 22, 13, 74962.99, 'WAITING_SPLIT_PAYMENT', 1, '2025-12-29 14:45:42'),
(159, 'ORD-A1CBCADA37', 6, 1, 19, 161575.93, 'WAITING_PAYMENT', 0, '2025-12-29 15:09:56'),
(160, 'ORD-BC2804E5FF', 6, 1, 15, 59517.82, 'WAITING_PAYMENT', 0, '2025-12-29 15:47:13'),
(161, 'ORD-3CB5E30347', 6, 1, 13, 94824.25, 'WAITING_PAYMENT', 0, '2025-12-29 15:47:42'),
(162, 'ORD-4DC88974EB', 2, 1, 20, 94052.68, 'WAITING_PAYMENT', 0, '2025-12-29 16:21:44'),
(163, 'ORD-2A185135B8', 6, 2, 15, 91857.83, 'Delivered', 0, '2025-12-29 17:21:13'),
(164, 'ORD-8A0BF2A93A', 6, 2, 7, 74914.32, 'Order_Confirmed', 0, '2025-12-29 17:41:12'),
(165, 'ORD-4A4421D1EE', 6, 1, 15, 86517.82, 'WAITING_SPLIT_PAYMENT', 1, '2025-12-29 18:13:39'),
(166, 'ORD-5B7AC5EEBB', 6, 3, 6, 35314.49, 'Order_Confirmed', 0, '2025-12-29 18:17:12'),
(167, 'ORD-D50A7748C1', 6, 15, 15, 231006.26, 'WAITING_PAYMENT', 0, '2025-12-29 18:17:54'),
(168, 'ORD-A9C64BC542', 6, 3, 6, 171314.49, 'WAITING_SPLIT_PAYMENT', 1, '2025-12-29 18:18:12'),
(169, 'ORD-2C306CF6F6', 6, 1, 24, 130242.80, 'WAITING_SPLIT_PAYMENT', 1, '2025-12-29 18:19:25'),
(170, 'ORD-1358B8F4CF', 6, 1, 6, 65664.95, 'WAITING_SPLIT_PAYMENT', 1, '2025-12-29 18:31:26'),
(171, 'ORD-7F51F00012', 6, 1, 15, 59517.82, 'Delivered', 0, '2025-12-29 18:41:57'),
(172, 'ORD-606C06B9BD', 7, 4, 6, 58686.30, 'Order_Confirmed', 0, '2025-12-29 20:21:46');

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `vehicle` enum('Bike','Car') DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`id`, `name`, `rating`, `vehicle`, `is_active`, `latitude`, `longitude`) VALUES
(3, 'Andi Driver', 4.9, 'Bike', 1, -6.2, 106.816666),
(4, 'Siti Driver', 4.8, 'Car', 1, -6.21, 106.82),
(5, 'Budi Driver', 4.7, 'Bike', 1, -6.195, 106.812),
(6, 'Joko Driver', 4.8, 'Bike', 1, -7.797068, 110.370529),
(7, 'Sri Driver', 4.9, 'Car', 1, -7.782773, 110.364908),
(8, 'Agus Driver', 4.7, 'Bike', 1, -7.801744, 110.364748),
(9, 'Rini Driver', 4.6, 'Car', 1, -7.790322, 110.355214),
(10, 'Bayu Driver', 4.8, 'Bike', 1, -7.77558, 110.37529),
(11, 'Dewi Driver', 4.5, 'Car', 1, -7.815601, 110.353248),
(12, 'Eko Driver', 4.7, 'Bike', 0, -7.80335, 110.39128),
(13, 'Fitri Driver', 4.9, 'Car', 1, -7.767903, 110.408103),
(14, 'Gunawan Driver', 4.4, 'Bike', 1, -7.822919, 110.389631),
(15, 'Hani Driver', 4.6, 'Car', 1, -7.810487, 110.324676),
(16, 'Rizki Amikom', 4.9, 'Bike', 1, -7.760854, 110.408257),
(17, 'Dian Amikom', 4.8, 'Car', 1, -7.76231, 110.40652),
(18, 'Fajar Amikom', 4.7, 'Bike', 1, -7.7635, 110.4098),
(19, 'Maya Amikom', 4.6, 'Car', 1, -7.7592, 110.411),
(20, 'Budi Amikom', 4.8, 'Bike', 1, -7.765, 110.4045),
(21, 'Sari Amikom', 4.5, 'Car', 1, -7.7615, 110.413),
(22, 'Aji Amikom', 4.7, 'Bike', 0, -7.758, 110.4075),
(23, 'Rina Amikom', 4.9, 'Car', 1, -7.7642, 110.4105),
(24, 'Hendra Amikom', 4.4, 'Bike', 1, -7.76, 110.405),
(25, 'Lisa Amikom', 4.6, 'Car', 1, -7.7628, 110.4123);

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `store_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`id`, `store_id`, `name`, `price`, `image`) VALUES
(1, 1, 'Ayam Geprek Original', 22000.00, 'assets/images/geprek-menu.png'),
(2, 1, 'Ayam Geprek Keju', 27000.00, 'assets/images/geprek-keju.png'),
(3, 1, 'Ayam Geprek Sambal Ijo', 25000.00, 'assets/images/geprek-ijo.png'),
(4, 2, 'Vegan Burger', 30000.00, 'assets/images/vegan-burger.png'),
(5, 2, 'Salad Bowl', 25000.00, 'assets/images/salad.png'),
(6, 2, 'Vegan Noodle', 28000.00, 'assets/images/vegan-noodle.png'),
(7, 3, 'Beef Burger', 28000.00, 'assets/images/beef-burger.png'),
(8, 3, 'Cheese Burger', 32000.00, 'assets/images/cheese-burger.png'),
(9, 3, 'Chicken Burger', 26000.00, 'assets/images/chicken-burger.png'),
(10, 4, 'Es Kopi Susu', 18000.00, 'assets/images/kopi-susu.png'),
(11, 4, 'Americano', 15000.00, 'assets/images/americano.png'),
(12, 4, 'Cappuccino', 22000.00, 'assets/images/cappuccino.png'),
(13, 5, 'Bakso Urat', 23000.00, 'assets/images/bakso-urat.png'),
(14, 5, 'Bakso Telur', 26000.00, 'assets/images/bakso-telur.png'),
(15, 5, 'Bakso Komplit', 30000.00, 'assets/images/bakso-komplit.png'),
(16, 1, 'Pepperoni Pizza', 55000.00, 'pepperoni.jpg'),
(17, 1, 'Cheese Pizza', 50000.00, 'cheese.jpg'),
(18, 1, 'Margherita Pizza', 60000.00, 'margherita.jpg'),
(19, 2, 'Whopper', 55000.00, 'whopper.jpg'),
(20, 2, 'Cheese Burger', 45000.00, 'cheese-burger.jpg'),
(21, 6, 'Gudeg Komplit', 35000.00, 'assets/images/gudeg-komplit.png'),
(22, 6, 'Gudeng Krecek', 30000.00, 'assets/images/gudeg-krecek.png'),
(23, 6, 'Gudeg Telur', 25000.00, 'assets/images/gudeg-telur.png'),
(24, 6, 'Areh Gudeg', 10000.00, 'assets/images/areh.png'),
(25, 6, 'Sambal Goreng Krecek', 15000.00, 'assets/images/sambal-krecek.png'),
(26, 7, 'Nasi Kucing', 5000.00, 'assets/images/nasi-kucing.png'),
(27, 7, 'Sate Usus', 3000.00, 'assets/images/sate-usus.png'),
(28, 7, 'Tempe Bacem', 4000.00, 'assets/images/tempe-bacem.png'),
(29, 7, 'Teh Poci', 5000.00, 'assets/images/teh-poci.png'),
(30, 7, 'Kopi Jos', 7000.00, 'assets/images/kopi-jos.png'),
(31, 8, 'Bakmi Goreng Jogja', 25000.00, 'assets/images/bakmi-goreng.png'),
(32, 8, 'Bakmi Godog Jogja', 23000.00, 'assets/images/bakmi-godog.png'),
(33, 8, 'Bakmi Ayam Jamur', 28000.00, 'assets/images/bakmi-ayam.png'),
(34, 8, 'Pangsit Goreng', 15000.00, 'assets/images/pangsit.png'),
(35, 8, 'Bakmi Special', 32000.00, 'assets/images/bakmi-special.png'),
(36, 9, 'Sate Klathak 10 Tusuk', 40000.00, 'assets/images/sate-klathak.png'),
(37, 9, 'Sate Klathak 20 Tusuk', 75000.00, 'assets/images/sate-klathak-banyak.png'),
(38, 9, 'Nasi Liwet', 10000.00, 'assets/images/nasi-liwet.png'),
(39, 9, 'Tahu/Tempe Bacem', 8000.00, 'assets/images/tahu-tempe.png'),
(40, 9, 'Es Teh Manis', 5000.00, 'assets/images/es-teh.png'),
(41, 10, 'Es Teh Poci Besar', 10000.00, 'assets/images/teh-poci-besar.png'),
(42, 10, 'Es Teh Poci Kecil', 7000.00, 'assets/images/teh-poci-kecil.png'),
(43, 10, 'Teh Poci Hangat', 8000.00, 'assets/images/teh-poci-hangat.png'),
(44, 10, 'Kopi Poci', 12000.00, 'assets/images/kopi-poci.png'),
(45, 10, 'Jahe Wangi', 15000.00, 'assets/images/jahe-wangi.png'),
(46, 11, 'Nasi Langgi Komplit', 35000.00, 'assets/images/langgi-komplit.png'),
(47, 11, 'Nasi Langgi Ayam', 30000.00, 'assets/images/langgi-ayam.png'),
(48, 11, 'Nasi Langgi Sapi', 40000.00, 'assets/images/langgi-sapi.png'),
(49, 11, 'Sambal Goreng Ati', 12000.00, 'assets/images/sambal-ati.png'),
(50, 11, 'Tahu Telur', 10000.00, 'assets/images/tahu-telur.png'),
(51, 12, 'Soto Kadipiro Special', 28000.00, 'assets/images/soto-kadipiro.png'),
(52, 12, 'Soto Ayam', 25000.00, 'assets/images/soto-ayam.png'),
(53, 12, 'Soto Sapi', 32000.00, 'assets/images/soto-sapi.png'),
(54, 12, 'Kerupuk Kulit', 5000.00, 'assets/images/kerupuk-kulit.png'),
(55, 12, 'Nasi Putih', 5000.00, 'assets/images/nasi-putih.png'),
(56, 13, 'Wedang Ronde', 15000.00, 'assets/images/wedang-ronde.png'),
(57, 13, 'Wedang Uwuh', 12000.00, 'assets/images/wedang-uwuh.png'),
(58, 14, 'Wedang Jahe', 10000.00, 'assets/images/wedang-jahe.png'),
(59, 13, 'Ronde Kuah Jahe', 18000.00, 'assets/images/ronde-jahe.png'),
(60, 13, 'Klepon', 8000.00, 'assets/images/klepon.png'),
(61, 14, 'Pizza Keju Jogja', 45000.00, 'assets/images/pizza-keju.png'),
(62, 14, 'Pizza Sosis Bakar', 50000.00, 'assets/images/pizza-sosis.png'),
(63, 14, 'Pizza Gudeg', 55000.00, 'assets/images/pizza-gudeg.png'),
(64, 14, 'Garlic Bread', 20000.00, 'assets/images/garlic-bread.png'),
(65, 14, 'French Fries', 25000.00, 'assets/images/french-fries.png'),
(66, 15, 'Gurame Bakar', 75000.00, 'assets/images/gurame-bakar.png'),
(67, 15, 'Cumi Goreng Tepung', 60000.00, 'assets/images/cumi-goreng.png'),
(68, 15, 'Udang Saus Tiram', 65000.00, 'assets/images/udang-tiram.png'),
(69, 15, 'Kepiting Saos Padang', 95000.00, 'assets/images/kepiting-padang.png'),
(70, 15, 'Nasi Goreng Seafood', 35000.00, 'assets/images/nasi-goreng-seafood.png'),
(71, 16, 'Nasi Campur Amikom', 20000.00, 'assets/images/nasi-campur.png'),
(72, 16, 'Nasi + Ayam Goreng', 18000.00, 'assets/images/nasi-ayam.png'),
(73, 16, 'Nasi + Tempe/Tahu', 15000.00, 'assets/images/nasi-tempe.png'),
(74, 16, 'Es Teh Manis', 5000.00, 'assets/images/es-teh.png'),
(75, 16, 'Air Mineral', 3000.00, 'assets/images/air-mineral.png'),
(76, 17, 'Kopi Debug', 15000.00, 'assets/images/kopi-debug.png'),
(77, 17, 'Kopi Algorithm', 18000.00, 'assets/images/kopi-algo.png'),
(78, 17, 'Kopi Database', 20000.00, 'assets/images/kopi-db.png'),
(79, 17, 'Kopi Java', 17000.00, 'assets/images/kopi-java.png'),
(80, 17, 'Kopi Python', 16000.00, 'assets/images/kopi-python.png'),
(81, 18, 'Burger Binary', 25000.00, 'assets/images/burger-binary.png'),
(82, 18, 'Burger Loop', 28000.00, 'assets/images/burger-loop.png'),
(83, 18, 'Burger Array', 30000.00, 'assets/images/burger-array.png'),
(84, 18, 'French Fries Code', 15000.00, 'assets/images/fries-code.png'),
(85, 18, 'Soft Drink Variable', 10000.00, 'assets/images/drink-var.png'),
(86, 19, 'Mie Setan Level 1', 15000.00, 'assets/images/mie-level1.png'),
(87, 19, 'Mie Setan Level 5', 20000.00, 'assets/images/mie-level5.png'),
(88, 19, 'Mie Setan Level 10', 25000.00, 'assets/images/mie-level10.png'),
(89, 19, 'Mie Setan Level Max', 30000.00, 'assets/images/mie-levelmax.png'),
(90, 19, 'Es Teh Anti Setan', 8000.00, 'assets/images/teh-anti.png'),
(91, 20, 'Seblak Kerupuk', 12000.00, 'assets/images/seblak-kerupuk.png'),
(92, 20, 'Seblak Ceker', 15000.00, 'assets/images/seblak-ceker.png'),
(93, 20, 'Seblak Komplit', 20000.00, 'assets/images/seblak-komplit.png'),
(94, 20, 'Seblak Makaroni', 13000.00, 'assets/images/seblak-makaroni.png'),
(95, 20, 'Es Teh Seblak', 7000.00, 'assets/images/teh-seblak.png'),
(96, 21, 'Martabak Coklat Keju', 30000.00, 'assets/images/martabak-coklat.png'),
(97, 21, 'Martabak Kacang', 25000.00, 'assets/images/martabak-kacang.png'),
(98, 21, 'Martabak Special', 35000.00, 'assets/images/martabak-special.png'),
(99, 21, 'Martabak Mini', 15000.00, 'assets/images/martabak-mini.png'),
(100, 21, 'Teh Tarik Martabak', 12000.00, 'assets/images/teh-tarik.png'),
(101, 22, 'Geprek Original', 22000.00, 'assets/images/geprek-original.png'),
(102, 22, 'Geprek Keju', 27000.00, 'assets/images/geprek-keju.png'),
(103, 22, 'Geprek Mozarella', 35000.00, 'assets/images/geprek-mozarella.png'),
(104, 22, 'Geprek Sambal Matah', 25000.00, 'assets/images/geprek-matah.png'),
(105, 22, 'Nasi Putih', 5000.00, 'assets/images/nasi-putih.png'),
(106, 23, 'Es Teh Manis Biasa', 5000.00, 'assets/images/teh-biasa.png'),
(107, 23, 'Es Teh Manis Jumbo', 8000.00, 'assets/images/teh-jumbo.png'),
(108, 23, 'Es Teh Lemon', 10000.00, 'assets/images/teh-lemon.png'),
(109, 23, 'Es Jeruk', 12000.00, 'assets/images/es-jeruk.png'),
(110, 23, 'Air Mineral', 3000.00, 'assets/images/air-mineral.png'),
(111, 24, 'Nasi Goreng Spesial', 20000.00, 'assets/images/nasgor-special.png'),
(112, 24, 'Nasi Goreng Ayam', 18000.00, 'assets/images/nasgor-ayam.png'),
(113, 24, 'Nasi Goreng Seafood', 25000.00, 'assets/images/nasgor-seafood.png'),
(114, 24, 'Nasi Goreng Vegetarian', 15000.00, 'assets/images/nasgor-vegan.png'),
(115, 24, 'Telur Ceplok', 5000.00, 'assets/images/telur-ceplok.png'),
(116, 25, 'Soto Ayam', 18000.00, 'assets/images/soto-ayam.png'),
(117, 25, 'Soto Sapi', 22000.00, 'assets/images/soto-sapi.png'),
(118, 25, 'Soto Komplit', 25000.00, 'assets/images/soto-komplit.png'),
(119, 25, 'Nasi Putih', 5000.00, 'assets/images/nasi-putih.png'),
(120, 25, 'Kerupuk', 3000.00, 'assets/images/kerupuk.png');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `delivery_fee` decimal(10,2) DEFAULT NULL,
  `paid_amount` decimal(10,2) DEFAULT 0.00,
  `split_bill` tinyint(1) DEFAULT 0,
  `address_id` int(11) DEFAULT NULL,
  `status` enum('pending','confirmed','preparing','on_the_way','delivered','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `driver_assigned_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `menu_item_id` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_people`
--

CREATE TABLE `order_people` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_people_items`
--

CREATE TABLE `order_people_items` (
  `id` int(11) NOT NULL,
  `person_id` int(11) DEFAULT NULL,
  `menu_item_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_split`
--

CREATE TABLE `order_split` (
  `id` int(11) NOT NULL,
  `order_id` varchar(30) DEFAULT NULL,
  `person_name` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `is_paid` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_split`
--

INSERT INTO `order_split` (`id`, `order_id`, `person_name`, `amount`, `is_paid`) VALUES
(175, 'ORD-3C8045F2EC', 'You', 44000.00, 0),
(176, 'ORD-3C8045F2EC', 'ade', 25000.00, 1),
(177, 'ORD-4A4421D1EE', 'You', 44000.00, 1),
(178, 'ORD-4A4421D1EE', 'ade', 27000.00, 0),
(179, 'ORD-A9C64BC542', 'You', 78000.00, 0),
(180, 'ORD-A9C64BC542', 'ade', 84000.00, 1),
(181, 'ORD-2C306CF6F6', 'You', 25000.00, 0),
(182, 'ORD-2C306CF6F6', 'ade', 77000.00, 1),
(183, 'ORD-1358B8F4CF', 'You', 22000.00, 0),
(184, 'ORD-1358B8F4CF', 'ade', 22000.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `order_status_log`
--

CREATE TABLE `order_status_log` (
  `id` int(11) NOT NULL,
  `order_id` varchar(30) NOT NULL,
  `status` varchar(50) NOT NULL,
  `changed_at` datetime DEFAULT current_timestamp(),
  `driver_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `method` enum('cash','ewallet','qris','bank_transfer','credit_card') DEFAULT NULL,
  `provider` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `status` enum('pending','success','failed') DEFAULT 'pending',
  `paid_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_stock` int(11) NOT NULL,
  `product_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stores`
--

CREATE TABLE `stores` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `latitude` float(10,6) DEFAULT NULL,
  `longitude` float(10,6) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `category` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stores`
--

INSERT INTO `stores` (`id`, `name`, `logo`, `latitude`, `longitude`, `is_active`, `category`) VALUES
(1, 'Ayam Geprek Mantap', 'assets/images/geprek.png', -7.770000, 110.300003, 1, NULL),
(2, 'Vegan Delight', 'assets/images/vegan.png', -7.780000, 110.320000, 1, 'Vegan'),
(3, 'Burger Bang Jago', 'assets/images/burger.png', -7.795000, 110.389999, 1, NULL),
(4, 'Kopi Senja', 'assets/images/coffee.png', -7.785000, 110.370003, 1, NULL),
(5, 'Bakso Pak Kumis', 'assets/images/bakso.png', -7.805000, 110.360001, 1, NULL),
(6, 'Gudeg Yu Djum', 'assets/images/gudeg.png', -7.800000, 110.360001, 1, 'Traditional'),
(7, 'Angkringan Lik Man', 'assets/images/angkringan.png', -7.790000, 110.370003, 1, 'Street Food'),
(8, 'Bakmi Jogja Mbah Hadi', 'assets/images/bakmi.png', -7.785000, 110.365005, 1, 'Noodles'),
(9, 'Sate Klathak Pak Bari', 'assets/images/sate.png', -7.810000, 110.350006, 1, 'BBQ'),
(10, 'Es Teh Poci Mbak Lis', 'assets/images/esteh.png', -7.795000, 110.355003, 1, 'Drinks'),
(11, 'Nasi Langgi Bu Rum', 'assets/images/nasilanggi.png', -7.775000, 110.380005, 1, 'Rice'),
(12, 'Soto Kadipiro Pak Dhe', 'assets/images/soto.png', -7.820000, 110.340004, 1, 'Soup'),
(13, 'Wedang Ronde Bu Jum', 'assets/images/wedang.png', -7.805000, 110.375000, 1, 'Dessert'),
(14, 'Pizza Jogja Slice', 'assets/images/pizza.png', -7.785000, 110.389999, 1, 'Western'),
(15, 'Seafood Laut Biru', 'assets/images/seafood.png', -7.815000, 110.325005, 1, 'Seafood'),
(16, 'Warung Amikom', 'assets/images/warung-amikom.png', -7.762000, 110.408501, 1, 'Cafeteria'),
(17, 'Kopi Coding Amikom', 'assets/images/kopi-coding.png', -7.761800, 110.409203, 1, 'Coffee'),
(18, 'Burger IT Amikom', 'assets/images/burger-it.png', -7.763200, 110.407799, 1, 'Burger'),
(19, 'Mie Setan Amikom', 'assets/images/mie-setan.png', -7.760500, 110.410004, 1, 'Noodles'),
(20, 'Seblak Amikom', 'assets/images/seblak.png', -7.761200, 110.411499, 1, 'Street Food'),
(21, 'Martabak IT Amikom', 'assets/images/martabak-it.png', -7.759800, 110.408798, 1, 'Dessert'),
(22, 'Ayam Geprek IT', 'assets/images/geprek-it.png', -7.763800, 110.409500, 1, 'Chicken'),
(23, 'Es Teh Programmer', 'assets/images/esteh-programmer.png', -7.762500, 110.406799, 1, 'Drinks'),
(24, 'Nasi Goreng Code', 'assets/images/nasgor-code.png', -7.761000, 110.407303, 1, 'Rice'),
(25, 'Soto Algorithm', 'assets/images/soto-algo.png', -7.764000, 110.407997, 1, 'Soup');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`) VALUES
(1, 'Budi Santoso', 'budi@mail.com', 'password123', '2025-12-24 13:46:45'),
(2, 'ade rizky', 'adeedun@gmail.com', 'scrypt:32768:8:1$Mht3q8SAoI6VEIKG$f44b722fb50ee67c98d8156cd03fbffdb1159222959236bb0f53ffebce1a9606fc4340922e977c5b6978e35077a054a64e577906b2303c0fea47119dfdf80ae9', '2025-12-25 15:35:55'),
(4, 'orang', 'manusia@gmail.com', 'pbkdf2:sha256:600000$91tbFqkuuDxVobtp$bbadf5c42e9c8a4f29f4534fb40b2ae2b3c50cff25d0db6c0cbed982848552e8', '2025-12-28 15:52:12'),
(5, 'tarnished', 'yeolde@gmail.com', 'pbkdf2:sha256:600000$HJoHEXUvWafA4ZuR$8ba57529365e943118609c4e4c2af2412a62045ac193cd1715466d91c5b86c9a', '2025-12-28 15:55:11'),
(6, 'sadewa', 'sadewa@gmail.com', 'pbkdf2:sha256:600000$amOuYnnv4o5LbkxG$818128ca8ee6ce9568f342b471c591725e5696cbb15705f62f26a3468eabcd23', '2025-12-29 07:44:53'),
(7, 'orang hitam', 'hitam@gmail.com', 'pbkdf2:sha256:600000$wdPjBghgwfTBCo7j$10bb6937703a3ffc181059793b38f081e08f8e2d9d5270ec202854268196fcf7', '2025-12-29 13:18:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_order_items`
--
ALTER TABLE `customer_order_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_order_master`
--
ALTER TABLE `customer_order_master`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_id` (`order_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `store_id` (`store_id`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `store_id` (`store_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `store_id` (`store_id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `address_id` (`address_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `menu_item_id` (`menu_item_id`);

--
-- Indexes for table `order_people`
--
ALTER TABLE `order_people`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_people_items`
--
ALTER TABLE `order_people_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`person_id`),
  ADD KEY `menu_item_id` (`menu_item_id`);

--
-- Indexes for table `order_split`
--
ALTER TABLE `order_split`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_status_log`
--
ALTER TABLE `order_status_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `idx_changed_at` (`changed_at`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `person_id` (`person_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stores`
--
ALTER TABLE `stores`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT for table `customer_order_items`
--
ALTER TABLE `customer_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=252;

--
-- AUTO_INCREMENT for table `customer_order_master`
--
ALTER TABLE `customer_order_master`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_people`
--
ALTER TABLE `order_people`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_people_items`
--
ALTER TABLE `order_people_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_split`
--
ALTER TABLE `order_split`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=185;

--
-- AUTO_INCREMENT for table `order_status_log`
--
ALTER TABLE `order_status_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stores`
--
ALTER TABLE `stores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `customer_order_master`
--
ALTER TABLE `customer_order_master`
  ADD CONSTRAINT `customer_order_master_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `customer_order_master_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);

--
-- Constraints for table `order_people`
--
ALTER TABLE `order_people`
  ADD CONSTRAINT `order_people_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `order_people_items`
--
ALTER TABLE `order_people_items`
  ADD CONSTRAINT `order_people_items_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `order_people` (`id`),
  ADD CONSTRAINT `order_people_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `order_people` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT for table `customer_order_items`
--
ALTER TABLE `customer_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=252;

--
-- AUTO_INCREMENT for table `customer_order_master`
--
ALTER TABLE `customer_order_master`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_people`
--
ALTER TABLE `order_people`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_people_items`
--
ALTER TABLE `order_people_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_split`
--
ALTER TABLE `order_split`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=185;

--
-- AUTO_INCREMENT for table `order_status_log`
--
ALTER TABLE `order_status_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stores`
--
ALTER TABLE `stores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `customer_order_master`
--
ALTER TABLE `customer_order_master`
  ADD CONSTRAINT `customer_order_master_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `customer_order_master_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);

--
-- Constraints for table `order_people`
--
ALTER TABLE `order_people`
  ADD CONSTRAINT `order_people_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `order_people_items`
--
ALTER TABLE `order_people_items`
  ADD CONSTRAINT `order_people_items_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `order_people` (`id`),
  ADD CONSTRAINT `order_people_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `order_people` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
