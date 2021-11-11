import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class ActorDetalle extends StatelessWidget {
  const ActorDetalle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context)!.settings.arguments as Actor;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(actor),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 10.0),
            //_posterTitulo(context, actor),
            //_descripcion(actor),

            const SizedBox(height: 10.0),
            _description(actor)
          ])),
        ],
      ),
    );
  }

  _crearAppbar(Actor actor) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 400.0,
      pinned: true,
      centerTitle: true,
      floating: true,
      snap: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(actor.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        background: FadeInImage(
          image: NetworkImage(actor.getFoto()),
          placeholder: const AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 150),
        ),
      ),
    );
  }

  _posterTitulo(BuildContext context, Actor actor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(actor.name,
                    style: Theme.of(context).textTheme.headline6,
                    overflow: TextOverflow.ellipsis),
                Text(actor.character,
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis),
                //_descripcion(actor),
              ],
            ),
          )
        ],
      ),
    );
  }

  _description(actor) {
    return FutureBuilder(
      future: PeliculasProvider().getActorInfo(actor.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final actorDetalle = snapshot.data;
          return _crearDescripcion(actorDetalle);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Widget _crearDescripcion(dynamic actorDetalle) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
    child: Text(
      actorDetalle.biography,
      textAlign: TextAlign.justify,
    ),
  );
}
