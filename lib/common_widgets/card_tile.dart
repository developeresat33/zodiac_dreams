import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardTile extends StatelessWidget {
  final Color? backgroundColor;
  final String? desp;
  final String title;
  final IconData? leading;
  final IconData? trailing;
  final bool isCircle;
  final Function()? onTap;
  const CardTile(
      {super.key,
      this.desp,
      this.onTap,
      required this.title,
      this.leading,
      this.trailing,
      this.backgroundColor,
      this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? null,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor ?? Colors.blue[800]!.withOpacity(0.8),
        ),
        child: ListTile(
          leading: leading != null
              ? isCircle
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Icon(leading, color: Colors.blue)),
                    )
                  : Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: Icon(
                        leading,
                        color: Colors.white70,
                        size: 25,
                      ))
              : null,
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: desp != null
              ? Text(
                  desp!,
                )
              : null,
          trailing: trailing != null
              ? Icon(
                  trailing,
                  color: Colors.white70,
                )
              : null,
        ).paddingOnly(top: 5, bottom: 5),
      ),
    );
  }
}
