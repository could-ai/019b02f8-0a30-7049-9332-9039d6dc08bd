import 'package:flutter/material.dart';

enum ItemType {
  empty,
  grass,
  dirt,
  stone,
  wood,
  ironOre,
  diamondOre,
  planks,
  stick,
  pickaxe,
  sword,
  chest,
}

class ItemDefinition {
  final String name;
  final Color color;
  final IconData? icon;
  final bool isSolid;

  const ItemDefinition({
    required this.name,
    required this.color,
    this.icon,
    this.isSolid = true,
  });
}

final Map<ItemType, ItemDefinition> itemDefinitions = {
  ItemType.empty: const ItemDefinition(name: 'Air', color: Colors.transparent, isSolid: false),
  ItemType.grass: const ItemDefinition(name: 'Grass', color: Colors.green),
  ItemType.dirt: const ItemDefinition(name: 'Dirt', color: Colors.brown),
  ItemType.stone: const ItemDefinition(name: 'Stone', color: Colors.grey),
  ItemType.wood: const ItemDefinition(name: 'Wood', color: Colors.brown, icon: Icons.forest),
  ItemType.ironOre: const ItemDefinition(name: 'Iron Ore', color: Colors.blueGrey, icon: Icons.circle),
  ItemType.diamondOre: const ItemDefinition(name: 'Diamond Ore', color: Colors.cyanAccent, icon: Icons.diamond),
  ItemType.planks: const ItemDefinition(name: 'Planks', color: Colors.orangeAccent, icon: Icons.table_rows),
  ItemType.stick: const ItemDefinition(name: 'Stick', color: Colors.brown, icon: Icons.horizontal_rule),
  ItemType.pickaxe: const ItemDefinition(name: 'Pickaxe', color: Colors.grey, icon: Icons.build),
  ItemType.sword: const ItemDefinition(name: 'Sword', color: Colors.grey, icon: Icons.colorize), // Using colorize as a sword-like icon
  ItemType.chest: const ItemDefinition(name: 'Chest', color: Colors.amber, icon: Icons.inventory_2),
};

class CraftingRecipe {
  final ItemType result;
  final int resultCount;
  final Map<ItemType, int> ingredients;

  CraftingRecipe({
    required this.result,
    this.resultCount = 1,
    required this.ingredients,
  });
}

final List<CraftingRecipe> recipes = [
  CraftingRecipe(
    result: ItemType.planks,
    resultCount: 4,
    ingredients: {ItemType.wood: 1},
  ),
  CraftingRecipe(
    result: ItemType.stick,
    resultCount: 4,
    ingredients: {ItemType.planks: 2},
  ),
  CraftingRecipe(
    result: ItemType.pickaxe,
    ingredients: {ItemType.stick: 2, ItemType.planks: 3},
  ),
  CraftingRecipe(
    result: ItemType.sword,
    ingredients: {ItemType.stick: 1, ItemType.planks: 2},
  ),
  CraftingRecipe(
    result: ItemType.chest,
    ingredients: {ItemType.planks: 8},
  ),
];
