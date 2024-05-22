import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zodiac_star/utils/int_extension.dart';

class GemWidget extends StatefulWidget {
  final data;
  const GemWidget({super.key, this.data});

  @override
  State<GemWidget> createState() => _GemWidgetState();
}

class _GemWidgetState extends State<GemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(49, 54, 63, 0.9).withOpacity(0.8),
            Color.fromRGBO(49, 54, 63, 0.8).withOpacity(0.7),
            Color.fromRGBO(49, 54, 63, 0.7).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.centerRight,
      height: 40,
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          15.w,
          Expanded(
            child: Text(
              "${widget.data}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          10.w,
          Icon(
            FontAwesomeIcons.gem,
            size: 20,
            color: Colors.blue[400],
          ),
          10.w,
        ],
      ),
    );
  }
}
