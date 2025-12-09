import 'dart:math';
import 'package:flutter/material.dart';
import 'items.dart';

class GameState extends ChangeNotifier {
  // World dimensions
  static const int rows = 20;
  static const int cols = 10;
  
  // The world grid
  List<ItemType> _world = [];
  List<ItemType> get world => _world;

  // Player inventory
  final Map<ItemType, int> _inventory = {};
  Map<ItemType, int> get inventory => _inventory;

  // Selected item for placing
  ItemType _selectedItem = ItemType.empty;
  ItemType get selectedItem => _selectedItem;

  GameState() {
    _generateWorld();
  }

  void _generateWorld() {
    _world = List.generate(rows * cols, (index) {
      // Simple terrain generation
      int row = index ~/ cols;
      
      if (row < 2) return ItemType.empty; // Sky
      if (row == 2) return ItemType.grass; // Surface
      if (row < 5) return ItemType.dirt; // Underground dirt
      
      // Deep underground - random ores
      final rand = Random();
      if (rand.nextDouble() < 0.05) return ItemType.diamondOre;
      if (rand.nextDouble() < 0.1) return ItemType.ironOre;
      if (rand.nextDouble() < 0.1) return ItemType.wood; // Buried wood? Why not.
      
      return ItemType.stone;
    });
    
    // Give starter items
    _inventory[ItemType.pickaxe] = 1;
    notifyListeners();
  }

  void mineBlock(int index) {
    if (index < 0 || index >= _world.length) return;
    
    final block = _world[index];
    if (block == ItemType.empty) return;

    // Add to inventory
    _inventory[block] = (_inventory[block] ?? 0) + 1;
    
    // Remove from world
    _world[index] = ItemType.empty;
    
    notifyListeners();
  }

  void placeBlock(int index) {
    if (index < 0 || index >= _world.length) return;
    if (_selectedItem == ItemType.empty) return;
    if (_world[index] != ItemType.empty) return; // Can't place on existing block
    if ((_inventory[_selectedItem] ?? 0) <= 0) return; // No items left

    // Remove from inventory
    _inventory[_selectedItem] = (_inventory[_selectedItem]!) - 1;
    if (_inventory[_selectedItem] == 0) {
      _inventory.remove(_selectedItem);
      _selectedItem = ItemType.empty;
    }

    // Place in world
    _world[index] = _selectedItem;
    
    notifyListeners();
  }

  void selectItem(ItemType item) {
    _selectedItem = item;
    notifyListeners();
  }

  bool canCraft(CraftingRecipe recipe) {
    for (var entry in recipe.ingredients.entries) {
      if ((_inventory[entry.key] ?? 0) < entry.value) {
        return false;
      }
    }
    return true;
  }

  void craft(CraftingRecipe recipe) {
    if (!canCraft(recipe)) return;

    // Consume ingredients
    for (var entry in recipe.ingredients.entries) {
      _inventory[entry.key] = (_inventory[entry.key]!) - entry.value;
      if (_inventory[entry.key] == 0) {
        _inventory.remove(entry.key);
      }
    }

    // Add result
    _inventory[recipe.result] = (_inventory[recipe.result] ?? 0) + recipe.resultCount;
    notifyListeners();
  }
  
  void resetWorld() {
    _inventory.clear();
    _generateWorld();
  }
}
