using System;
using NUnit.Framework;
using RestaurantMenuPRJ.Data.Models;

namespace RestaurantMenuPRJ.Tests.Models
{
    [TestFixture]
    public class ModelsCoverageTests
    {
        // ---------- Category ----------

        [Test]
        public void Category_Ctor_ShouldInitializeDishes()
        {
            var category = new Category();

            Assert.That(category.Dishes, Is.Not.Null);
            Assert.That(category.Dishes, Is.Empty);
        }

        [Test]
        public void Category_Properties_ShouldSetCorrectly()
        {
            var category = new Category
            {
                Id = 1,
                Name = "Desserts",
                Description = "Sweet dishes"
            };

            Assert.That(category.Id, Is.EqualTo(1));
            Assert.That(category.Name, Is.EqualTo("Desserts"));
            Assert.That(category.Description, Is.EqualTo("Sweet dishes"));
        }

        // ---------- Dish ----------

        [Test]
        public void Dish_Ctor_ShouldInitializeCollections()
        {
            var dish = new Dish();

            Assert.That(dish.DishIngredients, Is.Not.Null);
            Assert.That(dish.MenuItems, Is.Not.Null);
        }

        [Test]
        public void Dish_Properties_ShouldSetCorrectly()
        {
            var dish = new Dish
            {
                Id = 10,
                Name = "Pizza",
                Description = "Classic pizza",
                Price = 12.50m,
                CategoryId = 2,
                IsActive = true
            };

            Assert.Multiple(() =>
            {
                Assert.That(dish.Id, Is.EqualTo(10));
                Assert.That(dish.Name, Is.EqualTo("Pizza"));
                Assert.That(dish.Description, Is.EqualTo("Classic pizza"));
                Assert.That(dish.Price, Is.EqualTo(12.50m));
                Assert.That(dish.CategoryId, Is.EqualTo(2));
                Assert.That(dish.IsActive, Is.True);
            });
        }

        // ---------- Ingredient ----------

        [Test]
        public void Ingredient_Ctor_ShouldInitializeDishIngredients()
        {
            var ingredient = new Ingredient();

            Assert.That(ingredient.DishIngredients, Is.Not.Null);
            Assert.That(ingredient.DishIngredients, Is.Empty);
        }

        [Test]
        public void Ingredient_Properties_ShouldSetCorrectly()
        {
            var ingredient = new Ingredient
            {
                Id = 3,
                Name = "Milk",
                Unit = "ml",
                IsAllergen = true
            };

            Assert.That(ingredient.Name, Is.EqualTo("Milk"));
            Assert.That(ingredient.Unit, Is.EqualTo("ml"));
            Assert.That(ingredient.IsAllergen, Is.True);
        }

        // ---------- DishIngredient ----------

        [Test]
        public void DishIngredient_ShouldLinkDishAndIngredient()
        {
            var dish = new Dish { Id = 1, Name = "Soup", CategoryId = 1, Price = 5m };
            var ingredient = new Ingredient { Id = 2, Name = "Salt", Unit = "g" };

            var di = new DishIngredient
            {
                DishId = dish.Id,
                IngredientId = ingredient.Id,
                Quantity = 3.5m,
                Dish = dish,
                Ingredient = ingredient
            };

            Assert.That(di.Quantity, Is.EqualTo(3.5m));
            Assert.That(di.Dish, Is.SameAs(dish));
            Assert.That(di.Ingredient, Is.SameAs(ingredient));
        }

        // ---------- MenuSection ----------

        [Test]
        public void MenuSection_Ctor_ShouldInitializeMenuItems()
        {
            var section = new MenuSection();

            Assert.That(section.MenuItems, Is.Not.Null);
            Assert.That(section.MenuItems, Is.Empty);
        }

        [Test]
        public void MenuSection_Properties_ShouldSetCorrectly()
        {
            var section = new MenuSection
            {
                Id = 5,
                Name = "Drinks",
                IsActive = true
            };

            Assert.That(section.Name, Is.EqualTo("Drinks"));
            Assert.That(section.IsActive, Is.True);
        }

        // ---------- MenuItem ----------

        [Test]
        public void MenuItem_ShouldLinkDishAndSection()
        {
            var dish = new Dish { Id = 7, Name = "Cola", CategoryId = 3, Price = 2.5m };
            var section = new MenuSection { Id = 2, Name = "Beverages", IsActive = true };

            var menuItem = new MenuItem
            {
                DishId = dish.Id,
                MenuSectionId = section.Id,
                IsVisible = true,
                Note = "Cold",
                Dish = dish,
                MenuSection = section
            };

            Assert.That(menuItem.IsVisible, Is.True);
            Assert.That(menuItem.Note, Is.EqualTo("Cold"));
            Assert.That(menuItem.Dish, Is.SameAs(dish));
            Assert.That(menuItem.MenuSection, Is.SameAs(section));
        }

        // ---------- Userr ----------

        [Test]
        public void Userr_CreatedAt_ShouldBeInitialized()
        {
            var before = DateTime.UtcNow;
            var user = new Userr();
            var after = DateTime.UtcNow;

            Assert.That(user.CreatedAt, Is.InRange(before, after));
        }

        [Test]
        public void Userr_CustomProperties_ShouldSetCorrectly()
        {
            var user = new Userr
            {
                FirstName = "Ivan",
                LastName = "Petrov",
                Email = "ivan@test.com"
            };

            Assert.That(user.FirstName, Is.EqualTo("Ivan"));
            Assert.That(user.LastName, Is.EqualTo("Petrov"));
            Assert.That(user.Email, Is.EqualTo("ivan@test.com"));
        }

        // ---------- Full Graph Coverage ----------

        [Test]
        public void FullObjectGraph_ShouldWorkCorrectly()
        {
            var category = new Category { Name = "Main" };
            var dish = new Dish { Name = "Pasta", Category = category, Price = 10m };
            category.Dishes.Add(dish);

            var ingredient = new Ingredient { Name = "Cheese", Unit = "g" };
            var di = new DishIngredient { Dish = dish, Ingredient = ingredient, Quantity = 50m };
            dish.DishIngredients.Add(di);
            ingredient.DishIngredients.Add(di);

            var section = new MenuSection { Name = "Lunch", IsActive = true };
            var item = new MenuItem { Dish = dish, MenuSection = section, IsVisible = true };
            section.MenuItems.Add(item);
            dish.MenuItems.Add(item);

            Assert.That(category.Dishes.Count, Is.EqualTo(1));
            Assert.That(dish.DishIngredients.Count, Is.EqualTo(1));
            Assert.That(section.MenuItems.Count, Is.EqualTo(1));
        }
    }
}
