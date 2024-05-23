import 'package:flutter/material.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';

class RequestDetail extends StatefulWidget {
  final String? question;
  final String? answer;
  const RequestDetail({super.key, this.question, this.answer});

  @override
  State<RequestDetail> createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  @override
  void initState() {
    print(widget.answer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget.getAppBar(" Rüya Detayı"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sorulan Soru:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.h,
              Text(
                widget.question ?? 'Sorulan soru bulunamadı.',
                style: TextStyle(fontSize: 16),
              ),
              20.h,
              Text(
                'Uzmanın Yanıtı:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.h,
              Text(
                widget.answer != "" && widget.answer != null
                    ? widget.answer!
                    : 'Yanıt Bekleniyor..',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
