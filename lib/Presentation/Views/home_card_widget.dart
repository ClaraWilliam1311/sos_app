import 'package:flutter/material.dart';
import 'package:sos_app/Presentation/Styles/fonts.dart';

class HomeCardWidget extends StatelessWidget {
  final text;
  final cardIcon;
  final screen;
  HomeCardWidget(
      {super.key,
      @required this.text,
      @required this.cardIcon,
      @required this.screen});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen,
              ));
        },
        child: Card(
          elevation: 6.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Column(
              children: [
                IconButton(
                    onPressed: null,
                    iconSize: 80,
                    icon: Icon(
                      cardIcon,
                      color: Colors.black,
                    )),
                Text(text,
                    style: const TextStyle(
                      fontSize: formSubtitleFont,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ));
  }
}
