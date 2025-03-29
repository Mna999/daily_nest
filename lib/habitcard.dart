import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_nest/habit/collection.dart';
import 'package:daily_nest/habit/edit.dart';
import 'package:daily_nest/homepage.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatefulWidget {
  final String habitId;

  const HabitCard({
    super.key,
    required this.habitId,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  late bool _isFav=false;
  late int _streak=0;
  late String _name = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habitId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _isFav = snapshot.data!['isFav'];
          _streak = snapshot.data!['streak'];
          _name = snapshot.data!['name'];
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isFav ? Icons.favorite : Icons.favorite_border,
                        color: _isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Streak: $_streak days',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: _handleMenuAction,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("Edit Habit"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text(
                            "Delete Habit",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isFav = !_isFav;
    });

    try {
      await FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habitId)
          .update({'isFav': _isFav});

      await Collections.updateHabitStreak(widget.habitId, 0);
    } catch (e) {
      setState(() {
        _isFav = !_isFav;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite: $e')),
      );
    }
  }

  Future<void> _handleMenuAction(String value) async {
    switch (value) {
      case "delete":
        final confirmed = await _showDeleteConfirmation();
        if (confirmed) {
          await _deleteHabit();
        }
        break;
      case "edit":
        await _editHabit();
        break;
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Habit'),
            content: const Text('Are you sure you want to delete this habit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteHabit() async {
    try {
      await Collections.deleteHabit(widget.habitId);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete habit: $e')),
        );
      }
    }
  }

  Future<void> _editHabit() async {
    final doc = await FirebaseFirestore.instance
        .collection('habits')
        .doc(widget.habitId)
        .get();

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditHabit(
            docId: widget.habitId,
            oldName: doc['name'],
          ),
        ),
      );
    }
  }
}
