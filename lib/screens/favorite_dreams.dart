import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/card_tile.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class FavoriteDreams extends StatefulWidget {
  const FavoriteDreams({super.key});

  @override
  State<FavoriteDreams> createState() => _FavoriteDreamsState();
}

class _FavoriteDreamsState extends State<FavoriteDreams> {
  late Future<List<Map<String, dynamic>>> _favoriteDreamsFuture;

  @override
  void initState() {
    _favoriteDreamsFuture = context.read<UserProvider>().getFavoriteDreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget.getAppBar("Favori Tabirlerim"),
        body: Column(
          children: [
            10.h,
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _favoriteDreamsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: getLoading());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Favori rüya bulunamadı.'));
                  } else {
                    var favoriteDreams = snapshot.data!;
                    return ListView.builder(
                      itemCount: favoriteDreams.length,
                      itemBuilder: (context, index) {
                        var dream = favoriteDreams[index];
                        return CardTile(
                          leading: Icons.star,
                          backgroundColor: Color.fromRGBO(30, 33, 37, 1),
                          title: dream['text'] ?? '',
                        ).paddingOnly(bottom: 10);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }
}
