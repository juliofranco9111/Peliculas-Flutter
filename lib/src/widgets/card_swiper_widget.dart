// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  final List<dynamic>? peliculas;

  const CardSwiper({Key? key, required this.peliculas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
      height: _screenSize.height * 0.5,
      width: _screenSize.width * 0.95,
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.8,
        //itemHeight: 200.0,
        itemBuilder: (BuildContext context, int index) {
          peliculas?[index].uniqueId = '${peliculas?[index].id}-tarjeta';

          return Hero(
            tag: peliculas?[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: GestureDetector(
                onTap: () {
                  final pelicula = peliculas?[index];
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
                child: FadeInImage(
                  image: NetworkImage(peliculas![index].getPosterImg()),
                  placeholder: const AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas!.length,
      ),
    );
  }
}
