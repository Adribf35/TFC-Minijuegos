-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tfc_minijuegos
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tfc_minijuegos
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tfc_minijuegos` DEFAULT CHARACTER SET utf8 ;
USE `tfc_minijuegos` ;

-- -----------------------------------------------------
-- Table `tfc_minijuegos`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tfc_minijuegos`.`usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `fecha_registro` DATETIME NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `usuario_email_unicos` (`nombre_usuario` ASC, `email` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tfc_minijuegos`.`juego`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tfc_minijuegos`.`juego` (
  `id_juego` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `icono` VARCHAR(100) NULL,
  PRIMARY KEY (`id_juego`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tfc_minijuegos`.`partida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tfc_minijuegos`.`partida` (
  `id_partida` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `id_juego` INT NOT NULL,
  `fecha_partida` DATETIME NULL,
  `puntuacion` INT NULL,
  `resultado` VARCHAR(30) NULL,
  `tiempo_segundos` INT NULL,
  PRIMARY KEY (`id_partida`),
  INDEX `fk_partida_usuario` (`id_usuario` ASC) ,
  INDEX `fk_partida_juego` (`id_juego` ASC) ,
  CONSTRAINT `fk_partida_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `tfc_minijuegos`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_partida_juego1`
    FOREIGN KEY (`id_juego`)
    REFERENCES `tfc_minijuegos`.`juego` (`id_juego`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tfc_minijuegos`.`ranking_diario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tfc_minijuegos`.`ranking_diario` (
  `id_ranking` INT NOT NULL AUTO_INCREMENT,
  `id_juego` INT NOT NULL,
  `fecha` DATE NULL,
  `activo` TINYINT NULL,
  PRIMARY KEY (`id_ranking`),
  INDEX `fk_juego_ranking` (`id_juego` ASC) ,
  CONSTRAINT `fk_ranking_diario_juego1`
    FOREIGN KEY (`id_juego`)
    REFERENCES `tfc_minijuegos`.`juego` (`id_juego`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tfc_minijuegos`.`puntuacion_ranking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tfc_minijuegos`.`puntuacion_ranking` (
  `id_puntuacion_ranking` INT NOT NULL AUTO_INCREMENT,
  `id_ranking` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `puntuacion` INT NULL,
  `fecha_envio` DATETIME NULL,
  `posicion` INT NULL,
  PRIMARY KEY (`id_puntuacion_ranking`),
  INDEX `fk_usuario_ranking` (`id_usuario` ASC) ,
  INDEX `fk_diario_ranking` (`id_ranking` ASC) ,
  UNIQUE INDEX `unique_usuario_ranking` (`id_ranking` ASC, `id_usuario` ASC) ,
  CONSTRAINT `fk_puntuacion_ranking_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `tfc_minijuegos`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_puntuacion_ranking_ranking_diario1`
    FOREIGN KEY (`id_ranking`)
    REFERENCES `tfc_minijuegos`.`ranking_diario` (`id_ranking`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
