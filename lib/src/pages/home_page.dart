// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final peliculasProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Peliculas en cines'),
          backgroundColor: Colors.indigoAccent,
          centerTitle: false,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: DataSearch(), query: '');
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              _swiperTarjetas(),
              const SizedBox(height: 10.0),
              _footer(context),
            ])));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
        future: peliculasProvider.getEnCines(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(peliculas: snapshot.data);
          } else {
            return const SizedBox(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _footer(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle2)),
          const SizedBox(
            height: 10.0,
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return const SizedBox(
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          )
        ],
      ),
    );
  }
}
