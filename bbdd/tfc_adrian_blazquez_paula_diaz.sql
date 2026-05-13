-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-05-2026 a las 20:24:52
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tfc_minijuegos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juego`
--

CREATE TABLE `juego` (
  `id_juego` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `juego`
--

INSERT INTO `juego` (`id_juego`, `nombre`, `descripcion`, `icono`) VALUES
(1, 'ahorcado', 'Adivina la palabra letra por letra antes de completar el dibujo del ahorcado.', NULL),
(2, 'PPT', 'Juego de manos para dos personas donde piedra rompe tijera, tijera corta papel y papel envuelve piedra', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partida`
--

CREATE TABLE `partida` (
  `id_partida` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `fecha_partida` datetime DEFAULT NULL,
  `puntuacion` int(11) DEFAULT NULL,
  `resultado` varchar(30) DEFAULT NULL,
  `tiempo_segundos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puntuacion_ranking`
--

CREATE TABLE `puntuacion_ranking` (
  `id_puntuacion_ranking` int(11) NOT NULL,
  `id_ranking` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `puntuacion` int(11) DEFAULT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `posicion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ranking_diario`
--

CREATE TABLE `ranking_diario` (
  `id_ranking` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `fecha_registro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombre_usuario`, `email`, `password_hash`, `fecha_registro`) VALUES
(1, 'Pau24', 'PauPrueba@email.com', '$2y$10$JxTKRzC2kcPgFHj3eqEAkuK27wqA2CYeMMN2ttbCnPzP7lG3.Dogm', '2026-04-15 21:52:11'),
(2, 'Adridri', 'AdriPrueba@email.com', '$2y$10$r590wkLxexVDgpwivMFWnOm86BeE6tuAM9Ap8.NKURkTcfeJc1Z8y', '2026-04-17 02:01:44');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `juego`
--
ALTER TABLE `juego`
  ADD PRIMARY KEY (`id_juego`);

--
-- Indices de la tabla `partida`
--
ALTER TABLE `partida`
  ADD PRIMARY KEY (`id_partida`),
  ADD KEY `fk_partida_usuario` (`id_usuario`),
  ADD KEY `fk_partida_juego` (`id_juego`);

--
-- Indices de la tabla `puntuacion_ranking`
--
ALTER TABLE `puntuacion_ranking`
  ADD PRIMARY KEY (`id_puntuacion_ranking`),
  ADD UNIQUE KEY `unique_usuario_ranking` (`id_ranking`,`id_usuario`),
  ADD KEY `fk_usuario_ranking` (`id_usuario`),
  ADD KEY `fk_diario_ranking` (`id_ranking`);

--
-- Indices de la tabla `ranking_diario`
--
ALTER TABLE `ranking_diario`
  ADD PRIMARY KEY (`id_ranking`),
  ADD KEY `fk_juego_ranking` (`id_juego`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`,`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `juego`
--
ALTER TABLE `juego`
  MODIFY `id_juego` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `partida`
--
ALTER TABLE `partida`
  MODIFY `id_partida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT de la tabla `puntuacion_ranking`
--
ALTER TABLE `puntuacion_ranking`
  MODIFY `id_puntuacion_ranking` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ranking_diario`
--
ALTER TABLE `ranking_diario`
  MODIFY `id_ranking` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `partida`
--
ALTER TABLE `partida`
  ADD CONSTRAINT `fk_partida_juego1` FOREIGN KEY (`id_juego`) REFERENCES `juego` (`id_juego`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_partida_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `puntuacion_ranking`
--
ALTER TABLE `puntuacion_ranking`
  ADD CONSTRAINT `fk_puntuacion_ranking_ranking_diario1` FOREIGN KEY (`id_ranking`) REFERENCES `ranking_diario` (`id_ranking`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_puntuacion_ranking_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ranking_diario`
--
ALTER TABLE `ranking_diario`
  ADD CONSTRAINT `fk_ranking_diario_juego1` FOREIGN KEY (`id_juego`) REFERENCES `juego` (`id_juego`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
