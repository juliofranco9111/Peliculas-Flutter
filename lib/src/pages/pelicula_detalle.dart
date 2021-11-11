import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  const PeliculaDetalle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula =
        ModalRoute.of(context)!.settings.arguments as Pelicula;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _crearAppBar(pelicula),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(height: 10.0),
          _posterTitulo(context, pelicula),
          _descripcion(pelicula),
          const Text('Actores',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
              )),
          const SizedBox(height: 10.0),
          _crearCasting(pelicula),
        ])),
      ],
    ));
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      pinned: true,
      centerTitle: true,
      floating: true,
      snap: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImage()),
          placeholder: const AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 150),
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.caption,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(),
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                )
              ],
            ))
          ],
        ));
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = PeliculasProvider();

    return FutureBuilder(
        future: peliProvider.getCast(pelicula.id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return _crearActoresPageView(context, snapshot.data as List<Actor>);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearActoresPageView(BuildContext context, List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.30, initialPage: 1),
        children: [
          ...actores.map((actor) {
            return _actorTarjeta(context, actor);
          }).toList(),
        ],
      ),
    );
  }

  Widget _actorTarjeta(BuildContext context, Actor actor) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'actor', arguments: actor);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: const AssetImage('assets/img/no-avatar.png'),
              height: 80.0,
              width: 80.0,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          actor.name,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        )
      ],
    );
  }
}
