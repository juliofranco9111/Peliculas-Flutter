import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<dynamic>? peliculas;
  final Function siguientePagina;

  MovieHorizontal(
      {Key? key, required this.peliculas, required this.siguientePagina})
      : super(key: key);

  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.32,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return SizedBox(
        height: _screenSize.height * 0.3,
        child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: peliculas?.length ?? 0,
          itemBuilder: (BuildContext context, int index) =>
              _tarjeta(context, peliculas?[index]),
          //children: _tarjetas(context),
        ));
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-poster';

    final tarjeta = Container(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(children: [
          Hero(
            tag: pelicula.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.fitHeight,
                height: 140.0,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ]));

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: tarjeta,
    );
  }
}
