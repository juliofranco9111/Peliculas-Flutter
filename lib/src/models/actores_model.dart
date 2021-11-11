// ignore_for_file: unnecessary_null_comparison

class Cast {
  List<Actor> actores = [];
  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    }
  }
}

class Actor {
  late int castId;
  late String character;
  late String creditId;
  late int gender;
  late int id;
  late String name;
  late int order;
  late String profilePath;

  Actor(
      {required this.castId,
      required this.character,
      required this.creditId,
      required this.gender,
      required this.id,
      required this.name,
      required this.order,
      required this.profilePath});

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }

  getFoto() {
    if (profilePath == null) {
      return 'https://i.pinimg.com/originals/fc/04/73/fc047347b17f7df7ff288d78c8c281cf.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}

class ActorDetalle {
  late String biography;
  late String birthday;
  late String deathday = '';
  late int gender;
  late int id;
  late String name;
  late String placeOfBirth;
  late String profilePath;

  ActorDetalle(
      {required this.biography,
      required this.birthday,
      required this.deathday,
      required this.gender,
      required this.id,
      required this.name,
      required this.placeOfBirth,
      required this.profilePath});

  ActorDetalle.fromJsonMap(Map<String, dynamic> json) {
    biography = json['biography'];
    birthday = json['birthday'];
    deathday = json['deathday'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    placeOfBirth = json['place_of_birth'];
    profilePath = json['profile_path'];
  }

  getFoto() {
    if (profilePath == null) {
      return 'https://i.pinimg.com/originals/fc/04/73/fc047347b17f7df7ff288d78c8c281cf.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
