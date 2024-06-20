-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 16 Jun 2024 pada 09.21
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `housing-co`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePayment` (IN `uid` INT)   BEGIN
    DELETE FROM payment WHERE UID = uid AND status = 'pending';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_payment` (IN `p_UID` INT, IN `p_Bank_name` VARCHAR(100), IN `p_amount` INT, IN `p_Loan_details` VARCHAR(10000), IN `p_cheque_number` INT, IN `p_payment_opt` VARCHAR(10000))   BEGIN
    UPDATE payment
    SET Bank_name = p_Bank_name,
        amount = p_amount,
        Loan_details = p_Loan_details,
        cheque_number = p_cheque_number,
        payment_opt = p_payment_opt
    WHERE UID = p_UID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCompletedOrders` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_pid INT;
    DECLARE v_name_org VARCHAR(50);
    DECLARE v_contact_no DECIMAL(11, 0);
    DECLARE v_email_id VARCHAR(50);
    DECLARE v_order_id INT;
    DECLARE v_order_date DATE;
    
    DECLARE order_cursor CURSOR FOR
        SELECT pm.pid, pm.name_org, pm.contact_no, pm.email_id, o.order_id, o.order_date
        FROM packers_movers pm
        JOIN orders o ON pm.pid = o.pid
        WHERE o.status = 'completed';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN order_cursor;
    
    read_loop: LOOP
        FETCH order_cursor INTO v_pid, v_name_org, v_contact_no, v_email_id, v_order_id, v_order_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Here you can perform any actions you need with the fetched data
        -- For demonstration purposes, we'll just select the data
        SELECT v_pid, v_name_org, v_contact_no, v_email_id, v_order_id, v_order_date;
    END LOOP;
    
    CLOSE order_cursor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessOrdersAndDelete` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_pid INT;
    DECLARE v_name_org VARCHAR(50);
    DECLARE v_contact_no DECIMAL(11, 0);
    DECLARE v_email_id VARCHAR(50);
    DECLARE v_order_id INT;
    DECLARE v_order_date DATE;
    
    DECLARE order_cursor CURSOR FOR
        SELECT pm.pid, pm.name_org, pm.contact_no, pm.email_id, o.order_id, o.order_date
        FROM packers_movers pm
        JOIN orders o ON pm.pid = o.pid
        WHERE o.status = 'completed';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN order_cursor;
    
    read_loop: LOOP
        FETCH order_cursor INTO v_pid, v_name_org, v_contact_no, v_email_id, v_order_id, v_order_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Perform actions with the fetched data (e.g., select, delete)
        -- For demonstration, let's first select the data
        SELECT v_pid, v_name_org, v_contact_no, v_email_id, v_order_id, v_order_date;
        
        -- Then delete the order
        DELETE FROM orders WHERE order_id = v_order_id;
    END LOOP;
    
    CLOSE order_cursor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateFlat` (IN `p_flat_id` INT, IN `p_uid` INT, IN `p_bid` INT, IN `p_location` VARCHAR(100), IN `p_city` VARCHAR(100), IN `p_description` VARCHAR(500), IN `p_amenities` VARCHAR(500), IN `p_area` DOUBLE, IN `p_image` VARCHAR(500), IN `p_image1` VARCHAR(500), IN `p_image2` VARCHAR(500), IN `p_image3` VARCHAR(500))   BEGIN
    UPDATE flat
    SET uid = p_uid,
        bid = p_bid,
        location = p_location,
        city = p_city,
        description = p_description,
        amenities = p_amenities,
        area = p_area,
        image = p_image,
        image1 = p_image1,
        image2 = p_image2,
        image3 = p_image3
    WHERE flat_id = p_flat_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `before_delete_packer_mover`
--

CREATE TABLE `before_delete_packer_mover` (
  `pid` int(11) DEFAULT NULL,
  `name_org` varchar(100) DEFAULT NULL,
  `contact_no` varchar(15) DEFAULT NULL,
  `email_id` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `before_delete_packer_mover`
--

INSERT INTO `before_delete_packer_mover` (`pid`, `name_org`, `contact_no`, `email_id`) VALUES
(2, 'pqrs', '7977261097', 'manas.sinkar@spit.ac.in'),
(5, 'Spacetoon', '99999999999', 'giraldonainggolan@gmail.com'),
(3, 'uyy', '99999999999', 'manas@gmail.com');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `cardrent`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `cardrent` (
`flat_id` int(11)
,`location` varchar(100)
,`city` varchar(100)
,`rent_amount` int(11)
,`image` varchar(500)
,`time` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `cardsale`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `cardsale` (
`flat_id` int(11)
,`location` varchar(100)
,`city` varchar(100)
,`totalcost` double
,`image` varchar(500)
,`time` timestamp
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `feedbackbuilder`
--

CREATE TABLE `feedbackbuilder` (
  `val` int(50) NOT NULL,
  `name` varchar(500) NOT NULL,
  `email` varchar(500) NOT NULL,
  `question` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `feedbackuser`
--

CREATE TABLE `feedbackuser` (
  `val` int(50) NOT NULL,
  `name` varchar(500) NOT NULL,
  `email` varchar(500) NOT NULL,
  `question` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `feedbackuser`
--

INSERT INTO `feedbackuser` (`val`, `name`, `email`, `question`) VALUES
(2, 'Jaydeep', 'jv@gmail.com', 'hkajhfkjsdf');

-- --------------------------------------------------------

--
-- Struktur dari tabel `flat`
--

CREATE TABLE `flat` (
  `flat_id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `bid` int(11) DEFAULT NULL,
  `location` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  `amenities` varchar(500) NOT NULL,
  `area` double NOT NULL,
  `image` varchar(500) NOT NULL,
  `image1` varchar(500) NOT NULL,
  `image2` varchar(500) NOT NULL,
  `image3` varchar(500) NOT NULL,
  `time` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `flat`
--

INSERT INTO `flat` (`flat_id`, `uid`, `bid`, `location`, `city`, `description`, `amenities`, `area`, `image`, `image1`, `image2`, `image3`, `time`) VALUES
(1, 1, NULL, 'Andheri', 'Mumbai', 'Best flat', 'Swimming pool', 450, 'img/img5.jpg', 'img/img5.jpg', 'img/img5.jpg', 'img/img5.jpg', '2019-04-15 03:27:48'),
(2, 1, NULL, 'Mira road', 'Mumbai', 'Near Station', 'gym and parking', 500, 'img/img10.jpg', 'img/img10.jpg', 'img/img10.jpg', 'img/img10.jpg', '2019-04-15 03:30:16'),
(3, 1, NULL, 'Borivali', 'Mumbai', 'Awesome', 'Best parking', 450, 'img/img16.jpg', 'img/img16.jpg', 'img/img16.jpg', 'img/img16.jpg', '2019-04-15 03:33:16'),
(4, 1, NULL, 'Virar', 'Mumbai', 'Near station', 'Gym and pool', 450, 'img/img18.jpg', 'img/img18.jpg', 'img/img18.jpg', 'img/img18.jpg', '2019-04-15 03:34:39'),
(6, 1, NULL, 'Malad', 'Mumbai', 'Very awesome flat', 'Swimming Pool', 550, 'img/img10.jpg', 'img/img10.jpg', 'img/img10.jpg', 'img/img10.jpg', '2019-04-15 05:27:52'),
(7, NULL, 4, 'Telang', 'Tangerang', 'Clasik', 'Kamar, WC, Perpustakaan', 1, 'https://www.google.com/imgres?q=rumah&amp;imgurl=https%3A%2F%2Flh7-us.googleusercontent.com%2FYoctBTzOG06ud1TNFl1CfXKB7MKQvQLklfhFusaxfhmtDloTCVqlNVPAwXlfK1aG53tqfw6rrufMFtl2yFCJTk95xA7SzxQma9EibCgWyGGGfCRA5XWxlfVBwBjdbBhmo_rad1p1m45REbbe0DdfRcw&amp;imgrefurl=https%3A%2F%2Fwww.mitra10.com%2Fblog%2Fmodel-rumah-minimalis-terbaru&amp;docid=c1izEe7HDIojBM&amp;tbnid=MUoYH_d-veBiyM&amp;vet=12ahUKEwjN1OaMtdqGAxUJTWwGHbkKAEIQM3oECBgQAA..i&amp;w=736&amp;h=736&amp;hcb=2&amp;ved=2ahUKEwjN1OaMtdqGAxUJTWwGHb', 'https://www.google.com/imgres?q=rumah&amp;imgurl=https%3A%2F%2Fasset.kompas.com%2Fcrops%2F2dxHFNYo1p3WEonRM9VnEBM6w8c%3D%2F0x0%3A780x520%2F780x390%2Fdata%2Fphoto%2F2023%2F08%2F21%2F64e2ec07a40f4.jpg&amp;imgrefurl=https%3A%2F%2Fbiz.kompas.com%2Fread%2F2023%2F08%2F21%2F115255128%2Finspirasi-rumah-minimalis-modern-sarat-kesederhanaan-fungsional-dan-estetika&amp;docid=6SMMA0GFfWfYwM&amp;tbnid=GjhLFkI5XOFO9M&amp;vet=12ahUKEwjN1OaMtdqGAxUJTWwGHbkKAEIQM3oECF8QAA..i&amp;w=780&amp;h=390&amp;hcb=2&amp;ved', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUSExMWFhUVGRgXGBcVFyAVGBgYFxgXGBgYGxgYHikgGB0lGxcXITEhJSorLi4uGB8zODMsNygtLisBCgoKDg0OGxAQGy0mHyUyLS0tLS0vLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAOEA4QMBIgACEQEDEQH/xAAcAAABBQEBAQAAAAAAAAAAAAAGAgMEBQcAAQj/xABLEAACAQIDBAYFBwoEBQQDAAABAhEAAwQSIQUxQVEGEyJhcZEygaGxwQcUIyRCUoIzYmNyc5KistHwFVPS4RZDs8LxNESTo2R0lP/EABkBAAMBAQEAAAAAAAAAAAAAAAECAwQABf/EAC4RAAICAgEDBAEEAAcBAAAAAAABAhEDIRIxQVEEEyIy8GFxkaFCUmKBscHRI//aA', 'https://www.google.com/imgres?q=rumah&amp;imgurl=https%3A%2F%2Fwww.99.co%2Fid%2Fpanduan%2Fwp-content%2Fuploads%2F2022%2F11%2Fbentuk-rumah-sederhana-di-kampung-1120x630.jpg&amp;imgrefurl=https%3A%2F%2Fwww.99.co%2Fid%2Fpanduan%2Fbentuk-rumah-sederhana-di-kampung%2F&amp;docid=qTSTaDNHi4CDmM&amp;tbnid=Tvho39FPZ8uRoM&amp;vet=12ahUKEwjN1OaMtdqGAxUJTWwGHbkKAEIQM3oECGQQAA..i&amp;w=1120&amp;h=630&amp;hcb=2&amp;ved=2ahUKEwjN1OaMtdqGAxUJTWwGHbkKAEIQM3oECGQQAA', '2024-06-14 06:01:30'),
(11, NULL, 4, 'bandung', 'bekasi', 'Clasik', 'kamar', 1, 'https://www.google.com/url?sa=i&amp;url=https%3A%2F%2Fwww.mitra10.com%2Fblog%2Fmodel-rumah-minimalis-terbaru&amp;psig=AOvVaw03FhOfCHd8S_5Nltvry7K5&amp;ust=1718431172494000&amp;source=images&amp;cd=vfe&amp;opi=89978449&amp;ved=0CBIQjRxqFwoTCMC5t4u12oYDFQAAAAAdAAAAABAm', 'https://www.google.com/url?sa=i&amp;url=https%3A%2F%2Fwww.mitra10.com%2Fblog%2Fmodel-rumah-minimalis-terbaru&amp;psig=AOvVaw03FhOfCHd8S_5Nltvry7K5&amp;ust=1718431172494000&amp;source=images&amp;cd=vfe&amp;opi=89978449&amp;ved=0CBIQjRxqFwoTCMC5t4u12oYDFQAAAAAdAAAAABAm', 'https://www.google.com/url?sa=i&amp;url=https%3A%2F%2Fwww.mitra10.com%2Fblog%2Fmodel-rumah-minimalis-terbaru&amp;psig=AOvVaw03FhOfCHd8S_5Nltvry7K5&amp;ust=1718431172494000&amp;source=images&amp;cd=vfe&amp;opi=89978449&amp;ved=0CBIQjRxqFwoTCMC5t4u12oYDFQAAAAAdAAAAABAm', 'https://www.google.com/url?sa=i&amp;url=https%3A%2F%2Fwww.mitra10.com%2Fblog%2Fmodel-rumah-minimalis-terbaru&amp;psig=AOvVaw03FhOfCHd8S_5Nltvry7K5&amp;ust=1718431172494000&amp;source=images&amp;cd=vfe&amp;opi=89978449&amp;ved=0CBIQjRxqFwoTCMC5t4u12oYDFQAAAAAdAAAAABAm', '2024-06-14 06:07:09'),
(12, NULL, 4, 'papua', 'hilma', 'Clasik', 'kamar', 1, 'https://asset.kompas.com/crops/2dxHFNYo1p3WEonRM9VnEBM6w8c=/0x0:780x520/780x390/data/photo/2023/08/21/64e2ec07a40f4.jpg', 'https://asset.kompas.com/crops/2dxHFNYo1p3WEonRM9VnEBM6w8c=/0x0:780x520/780x390/data/photo/2023/08/21/64e2ec07a40f4.jpg', 'https://asset.kompas.com/crops/2dxHFNYo1p3WEonRM9VnEBM6w8c=/0x0:780x520/780x390/data/photo/2023/08/21/64e2ec07a40f4.jpg', 'https://asset.kompas.com/crops/2dxHFNYo1p3WEonRM9VnEBM6w8c=/0x0:780x520/780x390/data/photo/2023/08/21/64e2ec07a40f4.jpg', '2024-06-14 06:09:17'),
(17, NULL, 4, 'bdg', 'American', 'Clasik', 'kamar', 1, 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMWFhUXGR4YGBcYGRobGhsZHxgZGxgdGB8YHSgiGB8lHxsYITEiJSkrLi4uHiAzODMtNygtLysBCgoKDg0OGxAQGi0mICUtLS0vLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALQBGAMBIgACEQEDEQH/xAAcAAACAgMBAQAAAAAAAAAAAAAEBQMGAAIHAQj/xABFEAACAQIEAwUEBggFBAEFAAABAhEDIQAEEjEFQVEGEyJhcTKBkbEjQqHB0fAHFDNSYrLh8RUkcoKiQ3OSwtIWNFNjs//EABkBAAMBAQEAAAAAAAAAAAAAAAECAwQABf/EACkRAAICAgIBAwMEAwAAAAAAAAABAhEDIRIxQQQTIjJCURRhcYEjM5H/2gAMAwEAAhEDEQA/A', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMWFhUXGR4YGBcYGRobGhsZHxgZGxgdGB8YHSgiGB8lHxsYITEiJSkrLi4uHiAzODMtNygtLysBCgoKDg0OGxAQGi0mICUtLS0vLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALQBGAMBIgACEQEDEQH/xAAcAAACAgMBAQAAAAAAAAAAAAAEBQMGAAIHAQj/xABFEAACAQIEAwUEBggFBAEFAAABAhEDIQAEEjEFQVEGEyJhcTKBkbEjQqHB0fAHFDNSYrLh8RUkcoKiQ3OSwtIWNFNjs//EABkBAAMBAQEAAAAAAAAAAAAAAAECAwQABf/EACkRAAICAgIBAwMEAwAAAAAAAAABAhEDIRIxQQQTIjJCURRhcYEjM5H/2gAMAwEAAhEDEQA/A', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMWFhUXGR4YGBcYGRobGhsZHxgZGxgdGB8YHSgiGB8lHxsYITEiJSkrLi4uHiAzODMtNygtLysBCgoKDg0OGxAQGi0mICUtLS0vLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALQBGAMBIgACEQEDEQH/xAAcAAACAgMBAQAAAAAAAAAAAAAEBQMGAAIHAQj/xABFEAACAQIEAwUEBggFBAEFAAABAhEDIQAEEjEFQVEGEyJhcTKBkbEjQqHB0fAHFDNSYrLh8RUkcoKiQ3OSwtIWNFNjs//EABkBAAMBAQEAAAAAAAAAAAAAAAECAwQABf/EACkRAAICAgIBAwMEAwAAAAAAAAABAhEDIRIxQQQTIjJCURRhcYEjM5H/2gAMAwEAAhEDEQA/A', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMWFhUXGR4YGBcYGRobGhsZHxgZGxgdGB8YHSgiGB8lHxsYITEiJSkrLi4uHiAzODMtNygtLysBCgoKDg0OGxAQGi0mICUtLS0vLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALQBGAMBIgACEQEDEQH/xAAcAAACAgMBAQAAAAAAAAAAAAAEBQMGAAIHAQj/xABFEAACAQIEAwUEBggFBAEFAAABAhEDIQAEEjEFQVEGEyJhcTKBkbEjQqHB0fAHFDNSYrLh8RUkcoKiQ3OSwtIWNFNjs//EABkBAAMBAQEAAAAAAAAAAAAAAAECAwQABf/EACkRAAICAgIBAwMEAwAAAAAAAAABAhEDIRIxQQQTIjJCURRhcYEjM5H/2gAMAwEAAhEDEQA/A', '2024-06-15 13:27:35'),
(18, NULL, 4, 'cfsfg', 'dfd', 'Clasik', 'kamar', 2, 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxITEhUSEhIWFhUWGBcXGBgYFxoYHxgZGBUYFxYYFhgaHSggGRslHRcYITEiJSkrLi4uGB8zODMtNygvLisBCgoKDg0OGhAQGzYlICItLS0tLisvLS0tLS0tLS0tLS0tLS0tLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALcBEwMBIgACEQEDEQH/xAAcAAAABwEBAAAAAAAAAAAAAAAAAQIDBAUGBwj/xABGEAACAQIEAwUFBQUGBQMFAAABAhEAAwQSITEFQVEGEyJhcTKBkaGxByPB0fAUQlKS4TNicoLS8RU0VKLCFlPiFyRzg6P/xAAaAQACAwEBAAAAAAAAAAAAAAABAwACBAUG/8QAMREAAgICAAUCBAUEAwEAAAAAAAECEQMhBBIxQVETIhRhcZEygaHR8AVCscFDUuEj/9oAD', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxITEhUSEhIWFhUWGBcXGBgYFxoYHxgZGBUYFxYYFhgaHSggGRslHRcYITEiJSkrLi4uGB8zODMtNygvLisBCgoKDg0OGhAQGzYlICItLS0tLisvLS0tLS0tLS0tLS0tLS0tLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALcBEwMBIgACEQEDEQH/xAAcAAAABwEBAAAAAAAAAAAAAAAAAQIDBAUGBwj/xABGEAACAQIEAwUFBQUGBQMFAAABAhEAAwQSITEFQVEGEyJhcTKBkaGxByPB0fAUQlKS4TNicoLS8RU0VKLCFlPiFyRzg6P/xAAaAQACAwEBAAAAAAAAAAAAAAABAwACBAUG/8QAMREAAgICAAUCBAUEAwEAAAAAAAECEQMhBBIxQVETIhRhcZEygaHR8AVCscFDUuEj/9oAD', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxITEhUSEhIWFhUWGBcXGBgYFxoYHxgZGBUYFxYYFhgaHSggGRslHRcYITEiJSkrLi4uGB8zODMtNygvLisBCgoKDg0OGhAQGzYlICItLS0tLisvLS0tLS0tLS0tLS0tLS0tLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALcBEwMBIgACEQEDEQH/xAAcAAAABwEBAAAAAAAAAAAAAAAAAQIDBAUGBwj/xABGEAACAQIEAwUFBQUGBQMFAAABAhEAAwQSITEFQVEGEyJhcTKBkaGxByPB0fAUQlKS4TNicoLS8RU0VKLCFlPiFyRzg6P/xAAaAQACAwEBAAAAAAAAAAAAAAABAwACBAUG/8QAMREAAgICAAUCBAUEAwEAAAAAAAECEQMhBBIxQVETIhRhcZEygaHR8AVCscFDUuEj/9oAD', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxITEhUSEhIWFhUWGBcXGBgYFxoYHxgZGBUYFxYYFhgaHSggGRslHRcYITEiJSkrLi4uGB8zODMtNygvLisBCgoKDg0OGhAQGzYlICItLS0tLisvLS0tLS0tLS0tLS0tLS0tLS8tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIALcBEwMBIgACEQEDEQH/xAAcAAAABwEBAAAAAAAAAAAAAAAAAQIDBAUGBwj/xABGEAACAQIEAwUFBQUGBQMFAAABAhEAAwQSITEFQVEGEyJhcTKBkaGxByPB0fAUQlKS4TNicoLS8RU0VKLCFlPiFyRzg6P/xAAaAQACAwEBAAAAAAAAAAAAAAABAwACBAUG/8QAMREAAgICAAUCBAUEAwEAAAAAAAECEQMhBBIxQVETIhRhcZEygaHR8AVCscFDUuEj/9oAD', '2024-06-15 13:28:33');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `flat_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `flat_view` (
`flat_id` int(11)
,`uid` int(11)
,`bid` int(11)
,`location` varchar(100)
,`city` varchar(100)
,`description` varchar(500)
,`amenities` varchar(500)
,`area` double
,`image` varchar(500)
,`image1` varchar(500)
,`image2` varchar(500)
,`image3` varchar(500)
,`time` timestamp
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `login`
--

CREATE TABLE `login` (
  `UID` int(100) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `surname` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `phone` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `login`
--

INSERT INTO `login` (`UID`, `username`, `password`, `name`, `surname`, `email`, `phone`) VALUES
(1, 'arya', 'arya12345', 'Manas', 'Sinkar', 'manas.sinkar@gmail.com', 9022942188),
(2, 'jaydeep', 'jaydeep12345', 'Jaydeep', 'Vaghasiya', 'jaydeep@gmail.com', 9854545452),
(3, 'parththosani', 'parth12345', 'Parth', 'Thosani', 'parth@gmail.com', 9854512541),
(4, 'fiscal', 'aldo123456', 'Giraldo', 'nainggolan', 'giraldonainggolan@gmail.com', 1234567890);

-- --------------------------------------------------------

--
-- Struktur dari tabel `login_builder`
--

CREATE TABLE `login_builder` (
  `BID` int(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `lno` int(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `emailid` varchar(100) NOT NULL,
  `phoneno` decimal(10,0) NOT NULL,
  `nameorg` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `login_builder`
--

INSERT INTO `login_builder` (`BID`, `username`, `lno`, `password`, `emailid`, `phoneno`, `nameorg`) VALUES
(1, 'manasbuilder', 12345, 'manas12345', 'manas@gmail.com', 9022942188, 'Manas Builders'),
(2, 'jaydeep', 56789, 'jaydeep12345', 'jaydeep@gmail.com', 9565112574, 'Jaydeep Builders'),
(3, 'parthbuilder', 13579, 'parth12345', 'parth@gmail.com', 9885846564, 'Parth Builders'),
(4, 'fiscal', 1234567891, 'aldo123456', 'giraldonainggolan@gmail.com', 1234567891, 'aldo'),
(5, 'admin', 1234567891, 'aldo123456', 'cintanainggolan123@gmail.com', 1234567891, 'aldo');

-- --------------------------------------------------------

--
-- Struktur dari tabel `packers_movers`
--

CREATE TABLE `packers_movers` (
  `pid` int(11) NOT NULL,
  `name_org` varchar(50) NOT NULL,
  `contact_no` decimal(11,0) NOT NULL,
  `email_id` varchar(50) NOT NULL,
  `last_update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `packers_movers`
--

INSERT INTO `packers_movers` (`pid`, `name_org`, `contact_no`, `email_id`, `last_update_time`) VALUES
(4, 'parth', 7208201778, 'thosaniparth@gmail.com', '2024-06-14 00:25:27'),
(8, 'ugweugwej', 99999999999, 'sbdjkbsjkdjskbj@gmail.com', '2024-06-14 07:36:20');

--
-- Trigger `packers_movers`
--
DELIMITER $$
CREATE TRIGGER `before_packer_mover_delete` BEFORE DELETE ON `packers_movers` FOR EACH ROW BEGIN
    INSERT INTO before_delete_packer_mover (pid, name_org, contact_no, email_id)
    VALUES (OLD.pid, OLD.name_org, OLD.contact_no, OLD.email_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_packers_movers_update` BEFORE UPDATE ON `packers_movers` FOR EACH ROW BEGIN
  SET NEW.last_update_time = CURRENT_TIMESTAMP;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `packers_movers_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `packers_movers_view` (
`pid` int(11)
,`name_org` varchar(50)
,`contact_no` decimal(11,0)
,`email_id` varchar(50)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `payment`
--

CREATE TABLE `payment` (
  `UID` int(11) NOT NULL,
  `Bank_name` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `Loan_details` text DEFAULT NULL,
  `cheque_number` varchar(50) DEFAULT NULL,
  `payment_opt` varchar(50) DEFAULT NULL,
  `buyer` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `payment`
--

INSERT INTO `payment` (`UID`, `Bank_name`, `amount`, `Loan_details`, `cheque_number`, `payment_opt`, `buyer`) VALUES
(1, 'bri', 50.00, '1234', '978', '0', 'Manas');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `payment_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `payment_view` (
`UID` int(11)
,`buyer` varchar(255)
,`Bank_name` varchar(255)
,`amount` decimal(10,2)
,`Loan_details` text
,`cheque_number` varchar(50)
,`payment_opt` varchar(50)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `rent`
--

CREATE TABLE `rent` (
  `flat_id` int(11) NOT NULL,
  `rent_amount` int(11) NOT NULL,
  `deposit_amount` int(11) NOT NULL,
  `time_period` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `rent`
--

INSERT INTO `rent` (`flat_id`, `rent_amount`, `deposit_amount`, `time_period`) VALUES
(3, 15000, 50000, 5),
(4, 20000, 60000, 7);

-- --------------------------------------------------------

--
-- Struktur dari tabel `sale`
--

CREATE TABLE `sale` (
  `flat_id` int(11) NOT NULL,
  `totalcost` double NOT NULL,
  `rate` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `sale`
--

INSERT INTO `sale` (`flat_id`, `totalcost`, `rate`) VALUES
(1, 3600000, 8000),
(2, 4500000, 9000),
(6, 11000000, 20000),
(7, 1000000, 1000000),
(11, 1000, 1000),
(12, 2000, 2000),
(17, 1000, 1000),
(18, 200, 100);

-- --------------------------------------------------------

--
-- Struktur dari tabel `upcoming_projects`
--

CREATE TABLE `upcoming_projects` (
  `upid` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `location` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `comp_time` int(15) NOT NULL,
  `nameorg` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `upcoming_projects`
--

INSERT INTO `upcoming_projects` (`upid`, `bid`, `location`, `city`, `comp_time`, `nameorg`) VALUES
(3, 4, 'Telang', 'Tangerang', 3, '');

--
-- Trigger `upcoming_projects`
--
DELIMITER $$
CREATE TRIGGER `autoid` BEFORE INSERT ON `upcoming_projects` FOR EACH ROW BEGIN
DECLARE new_id INT;
SELECT upid INTO new_id FROM upcoming_projects ORDER BY upid DESC;
SET new.upid=new_id+1;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `upcoming_projects_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `upcoming_projects_view` (
`upid` int(11)
,`bid` int(11)
,`location` varchar(100)
,`city` varchar(100)
,`comp_time` int(15)
,`nameorg` varchar(255)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `cardrent`
--
DROP TABLE IF EXISTS `cardrent`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cardrent`  AS SELECT `flat`.`flat_id` AS `flat_id`, `flat`.`location` AS `location`, `flat`.`city` AS `city`, `rent`.`rent_amount` AS `rent_amount`, `flat`.`image` AS `image`, `flat`.`time` AS `time` FROM (`flat` join `rent` on(`flat`.`flat_id` = `rent`.`flat_id`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `cardsale`
--
DROP TABLE IF EXISTS `cardsale`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cardsale`  AS SELECT `flat`.`flat_id` AS `flat_id`, `flat`.`location` AS `location`, `flat`.`city` AS `city`, `sale`.`totalcost` AS `totalcost`, `flat`.`image` AS `image`, `flat`.`time` AS `time` FROM (`flat` join `sale` on(`flat`.`flat_id` = `sale`.`flat_id`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `flat_view`
--
DROP TABLE IF EXISTS `flat_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `flat_view`  AS SELECT `flat`.`flat_id` AS `flat_id`, `flat`.`uid` AS `uid`, `flat`.`bid` AS `bid`, `flat`.`location` AS `location`, `flat`.`city` AS `city`, `flat`.`description` AS `description`, `flat`.`amenities` AS `amenities`, `flat`.`area` AS `area`, `flat`.`image` AS `image`, `flat`.`image1` AS `image1`, `flat`.`image2` AS `image2`, `flat`.`image3` AS `image3`, `flat`.`time` AS `time` FROM `flat` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `packers_movers_view`
--
DROP TABLE IF EXISTS `packers_movers_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `packers_movers_view`  AS SELECT `packers_movers`.`pid` AS `pid`, `packers_movers`.`name_org` AS `name_org`, `packers_movers`.`contact_no` AS `contact_no`, `packers_movers`.`email_id` AS `email_id` FROM `packers_movers` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `payment_view`
--
DROP TABLE IF EXISTS `payment_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `payment_view`  AS SELECT `payment`.`UID` AS `UID`, `payment`.`buyer` AS `buyer`, `payment`.`Bank_name` AS `Bank_name`, `payment`.`amount` AS `amount`, `payment`.`Loan_details` AS `Loan_details`, `payment`.`cheque_number` AS `cheque_number`, `payment`.`payment_opt` AS `payment_opt` FROM `payment` WHERE `payment`.`amount` > 1000 ;

-- --------------------------------------------------------

--
-- Struktur untuk view `upcoming_projects_view`
--
DROP TABLE IF EXISTS `upcoming_projects_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `upcoming_projects_view`  AS SELECT `upcoming_projects`.`upid` AS `upid`, `upcoming_projects`.`bid` AS `bid`, `upcoming_projects`.`location` AS `location`, `upcoming_projects`.`city` AS `city`, `upcoming_projects`.`comp_time` AS `comp_time`, `upcoming_projects`.`nameorg` AS `nameorg` FROM `upcoming_projects` ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `flat`
--
ALTER TABLE `flat`
  ADD PRIMARY KEY (`flat_id`),
  ADD UNIQUE KEY `address` (`location`);

--
-- Indeks untuk tabel `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`UID`);

--
-- Indeks untuk tabel `login_builder`
--
ALTER TABLE `login_builder`
  ADD PRIMARY KEY (`BID`);

--
-- Indeks untuk tabel `packers_movers`
--
ALTER TABLE `packers_movers`
  ADD PRIMARY KEY (`pid`);

--
-- Indeks untuk tabel `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`UID`);

--
-- Indeks untuk tabel `rent`
--
ALTER TABLE `rent`
  ADD PRIMARY KEY (`flat_id`);

--
-- Indeks untuk tabel `sale`
--
ALTER TABLE `sale`
  ADD PRIMARY KEY (`flat_id`);

--
-- Indeks untuk tabel `upcoming_projects`
--
ALTER TABLE `upcoming_projects`
  ADD PRIMARY KEY (`upid`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `flat`
--
ALTER TABLE `flat`
  MODIFY `flat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `login`
--
ALTER TABLE `login`
  MODIFY `UID` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `login_builder`
--
ALTER TABLE `login_builder`
  MODIFY `BID` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `packers_movers`
--
ALTER TABLE `packers_movers`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `payment`
--
ALTER TABLE `payment`
  MODIFY `UID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `rent`
--
ALTER TABLE `rent`
  ADD CONSTRAINT `rent_ibfk_1` FOREIGN KEY (`flat_id`) REFERENCES `flat` (`flat_id`);

--
-- Ketidakleluasaan untuk tabel `sale`
--
ALTER TABLE `sale`
  ADD CONSTRAINT `sale_ibfk_1` FOREIGN KEY (`flat_id`) REFERENCES `flat` (`flat_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
