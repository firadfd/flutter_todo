import 'package:flutter/material.dart';

class UiHelper {
  static Widget listItem(
      String title,
      bool isCompleted, {
        required VoidCallback onCompleted,
        required VoidCallback onDelete,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isCompleted ? Colors.green.shade100 : Colors.red.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: isCompleted
                        ? Colors.green.shade800
                        : Colors.grey.shade600,
                  ),
                  onPressed: onCompleted,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: isCompleted
                        ? Colors.green.shade800
                        : Colors.grey.shade600,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
