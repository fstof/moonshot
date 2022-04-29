import 'package:flutter/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GameButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: VxCard(
        text.text.xl2.make().p8(),
      ).orange500.make(),
      onTap: onPressed,
    );
  }
}
