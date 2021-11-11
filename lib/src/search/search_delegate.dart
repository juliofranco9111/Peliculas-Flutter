import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = PeliculasProvider();

  /* final List<String> peliculas = [
    "Spiderman",
    "Aquaman",
    "Batman",
    "Shazam",
    "Ironman",
    "Ironman 2",
    "Ironman 3",
    "Capitan America",
    "Superman",
  ];

  final List<String> peliculasRecientes = [
    "Spiderman",
    "Capitan America",
  ]; */

  @override
  List<Widget>? buildActions(BuildContext context) {
    //Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  /* @override
  Widget buildSuggestions(BuildContext context) {
    //crea las sugerencias que aparecen cuando la persona escribe

    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: const Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  } */

  @override
  Widget buildSuggestions(BuildContext context) {
    //crea las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
            children: peliculas!.map((pelicula) {
              return ListTile(
                leading: Hero(
                  tag: pelicula.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: FadeInImage(
                      image: NetworkImage(pelicula.getPosterImg()),
                      placeholder: const AssetImage('assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados que vamos a mostrar
    return const Center(
        /* child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ), */
        );
  }
}
