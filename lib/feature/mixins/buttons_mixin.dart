import 'package:flutter/material.dart';

mixin ButtonsMixin {
  Widget buildSelectPointsButton({
    required VoidCallback onPressed,
  }) {
    return Positioned(
      bottom: 150,
      left: 10,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text('Başlangıç ve Bitiş Noktalarını Seç'),
      ),
    );
  }

  Widget buildMapTypeButton({
    required Offset fabPosition,
    required VoidCallback onMapTypeButtonPressed,
  }) {
    return Positioned(
      left: fabPosition.dx,
      top: fabPosition.dy,
      child: Draggable(
        feedback: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.map),
          backgroundColor: Colors.orange,
        ),
        childWhenDragging: Container(),
        onDraggableCanceled: (velocity, offset) {
          // FAB pozisyonunu güncelle
        },
        child: FloatingActionButton(
          onPressed: onMapTypeButtonPressed,
          child: Icon(Icons.map),
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }
}
