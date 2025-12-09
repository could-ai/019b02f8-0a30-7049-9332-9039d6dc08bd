import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/items.dart';
import 'crafting_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mine & Craft'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<GameState>().resetWorld(),
            tooltip: 'Reset World',
          ),
          IconButton(
            icon: const Icon(Icons.build),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CraftingScreen()),
              );
            },
            tooltip: 'Crafting',
          ),
        ],
      ),
      body: Column(
        children: [
          // The World Grid
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.lightBlue[100], // Sky background
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameState.cols,
                  childAspectRatio: 1.0,
                ),
                itemCount: gameState.world.length,
                itemBuilder: (context, index) {
                  final blockType = gameState.world[index];
                  final blockDef = itemDefinitions[blockType]!;

                  return GestureDetector(
                    onTap: () {
                      if (blockType != ItemType.empty) {
                        context.read<GameState>().mineBlock(index);
                      } else {
                        context.read<GameState>().placeBlock(index);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: blockType == ItemType.empty
                            ? Colors.transparent
                            : blockDef.color,
                        borderRadius: BorderRadius.circular(4),
                        border: blockType != ItemType.empty
                            ? Border.all(color: Colors.black12)
                            : null,
                      ),
                      child: blockDef.icon != null
                          ? Icon(blockDef.icon, color: Colors.white70, size: 20)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Inventory / Hotbar
          Container(
            height: 120,
            color: Colors.grey[900],
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inventory (Tap to Select)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: gameState.inventory.isEmpty
                      ? const Center(
                          child: Text('Inventory Empty', style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: gameState.inventory.length,
                          itemBuilder: (context, index) {
                            final itemType = gameState.inventory.keys.elementAt(index);
                            final count = gameState.inventory[itemType];
                            final itemDef = itemDefinitions[itemType]!;
                            final isSelected = gameState.selectedItem == itemType;

                            return GestureDetector(
                              onTap: () => context.read<GameState>().selectItem(itemType),
                              child: Container(
                                width: 70,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white24 : Colors.black26,
                                  border: Border.all(
                                    color: isSelected ? Colors.yellow : Colors.grey,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      itemDef.icon ?? Icons.square,
                                      color: itemDef.color,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$count',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      itemDef.name,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
