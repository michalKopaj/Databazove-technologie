-- Star schema: mydb
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb4;
USE `mydb`;

-- -----------------------------------------------------
-- Dimenzia: dm_user
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dm_user` (
  `iddm_user` INT NOT NULL,
  `gender` VARCHAR(45) NULL,
  `zip_code` VARCHAR(45) NULL,
  `age_group` VARCHAR(45) NULL,
  PRIMARY KEY (`iddm_user`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Dimenzia: dim_time
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_time` (
  `iddim_time` INT NOT NULL AUTO_INCREMENT,
  `rated_at` TIME NOT NULL,
  `second` INT NOT NULL,
  `minute` INT NOT NULL,
  `hour` INT NOT NULL,
  `time_of_day` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddim_time`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabuľka faktov: fact_ratings
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`fact_ratings` (
  `idfact_ratings` INT NOT NULL AUTO_INCREMENT,
  `rating` DOUBLE NOT NULL,
  `rating_count` INT NULL,
  `ratings_percentage` INT NULL,
  `dm_user_iddm_user` INT NOT NULL,
  `dim_time_iddim_time` INT NOT NULL,
  PRIMARY KEY (`idfact_ratings`),
  INDEX `fk_fact_ratings_dm_user_idx` (`dm_user_iddm_user`),
  INDEX `fk_fact_ratings_dim_time_idx` (`dim_time_iddim_time`),
  CONSTRAINT `fk_fact_ratings_dm_user`
    FOREIGN KEY (`dm_user_iddm_user`)
    REFERENCES `mydb`.`dm_user` (`iddm_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_ratings_dim_time`
    FOREIGN KEY (`dim_time_iddim_time`)
    REFERENCES `mydb`.`dim_time` (`iddim_time`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
