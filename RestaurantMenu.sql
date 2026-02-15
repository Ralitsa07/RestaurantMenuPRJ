IF DB_ID('RestaurantMenu') IS NULL
    CREATE DATABASE RestaurantMenu;
GO
USE RestaurantMenu;
GO

-- 2) DROP TABLES (if exist)
IF OBJECT_ID('Review','U') IS NOT NULL DROP TABLE Review;
IF OBJECT_ID('MenuItem','U') IS NOT NULL DROP TABLE MenuItem;
IF OBJECT_ID('MenuSection','U') IS NOT NULL DROP TABLE MenuSection;
IF OBJECT_ID('DishIngredient','U') IS NOT NULL DROP TABLE DishIngredient;
IF OBJECT_ID('Ingredient','U') IS NOT NULL DROP TABLE Ingredient;
IF OBJECT_ID('Dish','U') IS NOT NULL DROP TABLE Dish;
IF OBJECT_ID('Users','U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Category','U') IS NOT NULL DROP TABLE Category;
GO


CREATE TABLE Category (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Description VARCHAR(200) NULL
);

CREATE TABLE Dish (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(80) NOT NULL,
    Description VARCHAR(300) NULL,
    Price DECIMAL(7,2) NOT NULL,
    CategoryId INT NOT NULL,
    IsActive BIT NOT NULL
);

CREATE TABLE Ingredient (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(80) NOT NULL,
    Unit VARCHAR(20) NOT NULL,    
    IsAllergen BIT NOT NULL
);

CREATE TABLE DishIngredient (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DishId INT NOT NULL,
    IngredientId INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL
);

CREATE TABLE MenuSection (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(60) NOT NULL,
    IsActive BIT NOT NULL
);

CREATE TABLE MenuItem (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MenuSectionId INT NOT NULL,
    DishId INT NOT NULL,
    IsVisible BIT NOT NULL,
    Note VARCHAR(200) NULL
);

-- Dish -> Category
ALTER TABLE Dish
ADD CONSTRAINT FK_Dish_Category
FOREIGN KEY (CategoryId) REFERENCES Category(ID);

-- DishIngredient -> Dish
ALTER TABLE DishIngredient
ADD CONSTRAINT FK_DishIngredient_Dish
FOREIGN KEY (DishId) REFERENCES Dish(ID)
ON DELETE CASCADE;

-- DishIngredient -> Ingredient
ALTER TABLE DishIngredient
ADD CONSTRAINT FK_DishIngredient_Ingredient
FOREIGN KEY (IngredientId) REFERENCES Ingredient(ID)
ON DELETE CASCADE;

-- MenuItem -> MenuSection
ALTER TABLE MenuItem
ADD CONSTRAINT FK_MenuItem_MenuSection
FOREIGN KEY (MenuSectionId) REFERENCES MenuSection(ID)
ON DELETE CASCADE;

-- MenuItem -> Dish
ALTER TABLE MenuItem
ADD CONSTRAINT FK_MenuItem_Dish
FOREIGN KEY (DishId) REFERENCES Dish(ID)
ON DELETE CASCADE;
GO


/*CREATE TABLE Users (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Email VARCHAR(120) NOT NULL,
    PasswordHash VARCHAR(200) NOT NULL,
    Role VARCHAR(30) NOT NULL
);

CREATE TABLE Review (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Rating INT NOT NULL,
    Comment VARCHAR(500) NULL,
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
    UserId INT NOT NULL,
    DishId INT NOT NULL
);*/

-- 4) FOREIGN KEYS
ALTER TABLE Dish ADD FOREIGN KEY (CategoryId) REFERENCES Category(ID);
ALTER TABLE DishIngredient ADD FOREIGN KEY (DishId) REFERENCES Dish(ID);
ALTER TABLE DishIngredient ADD FOREIGN KEY (IngredientId) REFERENCES Ingredient(ID);
ALTER TABLE MenuItem ADD FOREIGN KEY (MenuSectionId) REFERENCES MenuSection(ID);
ALTER TABLE MenuItem ADD FOREIGN KEY (DishId) REFERENCES Dish(ID);
ALTER TABLE Review ADD FOREIGN KEY (UserId) REFERENCES Users(ID);
ALTER TABLE Review ADD FOREIGN KEY (DishId) REFERENCES Dish(ID);
GO

/* =========================
   5) INSERT DATA (MORE)
   ========================= */

INSERT INTO Category (Name, Description) VALUES
('Salads','Fresh salads'),
('Starters','Soups and starters'),
('Main Dishes','Main courses'),
('Desserts','Sweet desserts'),
('Drinks','Beverages');

-- Dishes (25)  -> DishId will be 1..25
INSERT INTO Dish (Name, Description, Price, CategoryId, IsActive) VALUES
-- Salads (1)
('Shopska Salad','Tomato, cucumber, sirene',8.90,1,1),          -- 1
('Caesar Salad','Chicken, parmesan, croutons',12.90,1,1),       -- 2
('Greek Salad','Tomato, cucumber, feta, olives',10.90,1,1),     -- 3
('Tuna Salad','Greens, tuna, corn, egg',12.50,1,1),             -- 4
('Avocado Bowl','Avocado, quinoa, cherry tomato',13.40,1,1),    -- 5

-- Starters (2)
('Tarator','Cold yogurt soup',6.90,2,1),                        -- 6
('Chicken Soup','Homemade chicken soup',7.90,2,1),              -- 7
('French Fries','Crispy fries',6.20,2,1),                       -- 8
('Garlic Bread','Bread with garlic butter',5.50,2,1),           -- 9
('Bruschetta','Tomato and basil toast',7.50,2,1),               --10

-- Main Dishes (3)
('Grilled Chicken','Chicken fillet with salad',16.90,3,1),      --11
('Pork Kavarma','Pork stew with onions',18.90,3,1),             --12
('Beef Meatballs','Grilled meatballs with fries',17.90,3,1),    --13
('Spaghetti Carbonara','Cream, bacon, parmesan',16.90,3,1),     --14
('Vegetarian Pasta','Pasta with vegetables',15.50,3,1),         --15
('BBQ Ribs','Slow cooked ribs',24.90,3,1),                      --16
('Grilled Trout','Trout with lemon',21.90,3,1),                 --17
('Mushroom Risotto','Rice, mushrooms, parmesan',17.50,3,1),     --18

-- Desserts (4)
('Chocolate Cake','Homemade cake slice',7.50,4,1),              --19
('Cheesecake','Classic cheesecake',8.20,4,1),                   --20
('Tiramisu','Coffee dessert',8.90,4,1),                         --21
('Ice Cream','Vanilla ice cream',6.50,4,1),                     --22

-- Drinks (5)
('Mineral Water 500ml','Still water',2.80,5,1),                 --23
('Fresh Lemonade','Homemade lemonade',5.20,5,1),                --24
('Espresso','Strong coffee',3.30,5,1);                          --25
GO

-- Ingredients (40) -> IngredientId 1..40
INSERT INTO Ingredient (Name, Unit, IsAllergen) VALUES
('Tomato','g',0),                 -- 1
('Cucumber','g',0),               -- 2
('Sirene Cheese','g',1),          -- 3
('Feta Cheese','g',1),            -- 4
('Olives','g',0),                 -- 5
('Romaine Lettuce','g',0),        -- 6
('Mixed Greens','g',0),           -- 7
('Chicken Meat','g',0),           -- 8
('Parmesan','g',1),               -- 9
('Croutons (gluten)','g',1),      --10
('Tuna','g',0),                   --11
('Corn','g',0),                   --12
('Egg','pcs',1),                  --13
('Avocado','g',0),                --14
('Quinoa','g',0),                 --15
('Cherry Tomato','g',0),          --16
('Yogurt','ml',1),                --17
('Garlic','g',0),                 --18
('Dill','g',0),                   --19
('Carrot','g',0),                 --20
('Celery','g',0),                 --21
('Potatoes','g',0),               --22
('Oil','ml',0),                   --23
('Bread (gluten)','g',1),         --24
('Butter','g',1),                 --25
('Basil','g',0),                  --26
('Pork Meat','g',0),              --27
('Onion','g',0),                  --28
('Beef Mince','g',0),             --29
('Pasta (gluten)','g',1),         --30
('Cream','ml',1),                 --31
('Bacon','g',0),                  --32
('Rice','g',0),                   --33
('Mushrooms','g',0),              --34
('Water','ml',0),                 --35
('Sugar','g',0),                  --36
('Lemon','pcs',0),                --37
('Coffee Beans','g',0),           --38
('Milk','ml',1),                  --39
('BBQ Sauce','ml',0);             --40
GO

/* =========================
   DishIngredient (RECIPES)
   ========================= */

-- Salads
INSERT INTO DishIngredient (DishId, IngredientId, Quantity) VALUES
(1,1,200),(1,2,150),(1,3,80),(1,23,10),
(2,6,120),(2,8,160),(2,9,25),(2,10,35),
(3,1,180),(3,2,140),(3,4,90),(3,5,50),(3,23,10),
(4,7,120),(4,11,120),(4,12,60),(4,13,1),(4,23,10),
(5,14,80),(5,15,120),(5,16,80),(5,2,80),(5,23,8);
GO

-- Starters
INSERT INTO DishIngredient (DishId, IngredientId, Quantity) VALUES
(6,17,250),(6,2,140),(6,18,4),(6,19,3),(6,23,8),
(7,8,120),(7,20,60),(7,21,30),(7,28,30),
(8,22,250),(8,23,25),
(9,24,140),(9,25,25),(9,18,3),
(10,24,120),(10,1,150),(10,26,2),(10,23,10);
GO

-- Main dishes
INSERT INTO DishIngredient (DishId, IngredientId, Quantity) VALUES
(11,8,220),(11,23,10),(11,7,80),
(12,27,220),(12,28,80),(12,34,120),(12,23,10),
(13,29,220),(13,28,40),(13,23,10),(13,22,200),
(14,30,220),(14,31,120),(14,32,70),(14,9,25),
(15,30,220),(15,34,100),(15,28,40),(15,23,10),
(16,27,350),(16,40,60),
(17,1,30),(17,37,1),(17,23,8),
(18,33,180),(18,34,160),(18,31,80),(18,9,20);
GO

-- Desserts
INSERT INTO DishIngredient (DishId, IngredientId, Quantity) VALUES
(19,36,20),(19,31,30),
(20,36,15),(20,31,40),
(21,38,18),(21,36,15),(21,31,30),
(22,31,20),(22,36,10);
GO

-- Drinks
INSERT INTO DishIngredient (DishId, IngredientId, Quantity) VALUES
(23,35,500),
(24,37,1),(24,36,20),(24,35,250),
(25,38,18);
GO

-- Menu sections
INSERT INTO MenuSection (Name, IsActive) VALUES
('Salads',1),
('Starters',1),
('Main Dishes',1),
('Desserts',1),
('Drinks',1);
GO

-- Menu items
INSERT INTO MenuItem (MenuSectionId, DishId, IsVisible, Note) VALUES
(1,1,1,NULL),(1,2,1,NULL),(1,3,1,NULL),(1,4,1,'Popular'),(1,5,1,'Healthy'),
(2,6,1,'Cold soup'),(2,7,1,NULL),(2,8,1,NULL),(2,9,1,NULL),(2,10,1,NULL),
(3,11,1,'Chef choice'),(3,12,1,NULL),(3,13,1,NULL),(3,14,1,NULL),
(3,15,1,'Vegetarian'),(3,16,1,'Spicy'),(3,17,1,'Fish'),(3,18,1,NULL),
(4,19,1,NULL),(4,20,1,NULL),(4,21,1,'Coffee dessert'),(4,22,1,NULL),
(5,23,1,NULL),(5,24,1,'Homemade'),(5,25,1,NULL);
GO