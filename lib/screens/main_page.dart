import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/card_tile.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, UserProvider _, child) => Column(
              children: [
                15.h,
                Row(
                  children: [
                    Text(
                      "Hoşgeldiniz ,${_.userModel!.nameSurname} ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Huzurlu bir gün geçirmeniz dileği ile ..  ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
                15.h,
                CardTile(
                  leading: FontAwesomeIcons.wandMagicSparkles,
                  title: "Bir uzman'dan tabir yorumu al",
                  desp:
                      "Rüyanızı uzman rüya tabircilerimize yorumlatmak için tıklayınız..",
                  trailing: Icons.chevron_right_outlined,
                ),
                10.h,
                Divider(
                  thickness: 0.1,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        child: Image.asset(
                          "assets/horoscope/${_.transformString(_.userModel!.horoscope!) + ".png"}",
                          color: Colors.white,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      title: Text(
                        "${_.userModel!.horoscope!}" + " Burcu Genel Yorumu",
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "Burcunuzun günlük , haftalık , aylık ve yıllık yorumu",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                10.h,
                Expanded(
                    child: FutureBuilder<List<Map<String, String>>>(
                  future: _.fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: getLoading());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Hata: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Veri bulunamadı.'));
                    } else {
                      List<Map<String, String>> data = snapshot.data!;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return CardTile(
                            bottomPadding: true,
                            backgroundColor: Color.fromRGBO(30, 33, 37, 1),
                            title: data[index]['title']!,
                            desp: data[index]['description']!,
                          ).paddingOnly(bottom: 10);
                        },
                      );
                    }
                  },
                ))
              ],
            ).paddingSymmetric(horizontal: 10));
  }
}
