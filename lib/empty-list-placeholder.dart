import 'package:flutter/material.dart';

class EmptyListPlaceholder extends StatelessWidget {

  final String message;

  EmptyListPlaceholder(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
