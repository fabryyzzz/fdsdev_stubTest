CREATE TABLE IF NOT EXISTS `fdsdev_stubtest` (
  `date` varchar(50) DEFAULT NULL,
  `player` varchar(50) DEFAULT NULL,
  `identifier` varchar(60) DEFAULT NULL,
  `dob` varchar(50) DEFAULT NULL,
  `result` varchar(50) DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  KEY `Indice 1` (`id`),
  KEY `Indice 2` (`player`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `fdsdev_gunpowderdata` (
  `identifier` varchar(60) DEFAULT NULL,
  `stato` varchar(50) DEFAULT NULL,
  `shootday` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
