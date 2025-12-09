import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/items.dart';

class CraftingScreen extends StatelessWidget {
  const CraftingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crafting Table'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final canCraft = gameState.canCraft(recipe);
          final resultDef = itemDefinitions[recipe.result]!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: resultDef.color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
                child: resultDef.icon != null
                    ? Icon(resultDef.icon, color: Colors.white)
                    : null,
              ),
              title: Text(resultDef.name),
              subtitle: Text(
                recipe.ingredients.entries.map((e) {
                  final ingName = itemDefinitions[e.key]!.name;
                  return '$ingName x${e.value}';
                }).join(', '),
              ),
              trailing: ElevatedButton(
                onPressed: canCraft
                    ? () {
                        context.read<GameState>().craft(recipe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Crafted ${resultDef.name}!'),
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                      }
                    : null,
                child: const Text('Craft'),
              ),
            ),
          );
        },
      ),
    );
  }
}
