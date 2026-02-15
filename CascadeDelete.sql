USE RestaurantMenu;
GO

-- ШАГ 1: Премахваме старите foreign key constraints
PRINT 'Dropping old constraints...';

-- Намираме името на constraint-а за Dish -> Category
DECLARE @ConstraintName NVARCHAR(200);

SELECT @ConstraintName = name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('Dish') 
  AND referenced_object_id = OBJECT_ID('Category');

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Dish DROP CONSTRAINT ' + @ConstraintName);
    PRINT 'Dropped constraint: ' + @ConstraintName;
END

-- Намираме името на constraint-а за MenuItem -> Dish
SELECT @ConstraintName = name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('MenuItem') 
  AND referenced_object_id = OBJECT_ID('Dish');

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE MenuItem DROP CONSTRAINT ' + @ConstraintName);
    PRINT 'Dropped constraint: ' + @ConstraintName;
END

-- Намираме името на constraint-а за DishIngredient -> Dish
SELECT @ConstraintName = name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('DishIngredient') 
  AND referenced_object_id = OBJECT_ID('Dish');

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE DishIngredient DROP CONSTRAINT ' + @ConstraintName);
    PRINT 'Dropped constraint: ' + @ConstraintName;
END

GO

-- ШАГ 2: Създаваме НОВИ constraints с правилната конфигурация
PRINT 'Creating new constraints with CASCADE...';

-- Dish -> Category (NO CASCADE - защита)
ALTER TABLE Dish
ADD CONSTRAINT FK_Dish_Category
FOREIGN KEY (CategoryId) REFERENCES Category(ID);
PRINT 'Created FK_Dish_Category';

-- DishIngredient -> Dish (CASCADE)
ALTER TABLE DishIngredient
ADD CONSTRAINT FK_DishIngredient_Dish
FOREIGN KEY (DishId) REFERENCES Dish(ID)
ON DELETE CASCADE;
PRINT 'Created FK_DishIngredient_Dish with CASCADE';

-- MenuItem -> Dish (CASCADE)
ALTER TABLE MenuItem
ADD CONSTRAINT FK_MenuItem_Dish
FOREIGN KEY (DishId) REFERENCES Dish(ID)
ON DELETE CASCADE;
PRINT 'Created FK_MenuItem_Dish with CASCADE';

GO

PRINT 'All constraints updated successfully!';