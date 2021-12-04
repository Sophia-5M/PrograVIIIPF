import 'package:card_swiper/card_swiper.dart';
import 'package:cartelera/models/images_response.dart';
import 'package:cartelera/models/models.dart';
import 'package:cartelera/providers/movies_provider.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(id: args.id),
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(
              title: args.title,
              originalTitle: args.originalTitle,
              voteAverage: args.voteAverage,
              postherPotho: args.posterPath,
            ),
            _Overview(overView: args.overview),
            _CardSwiper(id: args.id)
          ]))
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final int id;
  const _CustomAppBar({Key? key, required this.id}) : super(key: key); //

  //

  @override
  Widget build(BuildContext context) {
    late Future<ImagesResponse> np;
    np = MoviesProvider().getImages(id);
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true, background: _getImages(context, np)),
    );

    //return _getImages(context, np);
  }

  Widget _getImages(BuildContext context, Future<ImagesResponse> np) {
    return Center(
      child: FutureBuilder<ImagesResponse>(
        future: np,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FadeInImage(
              placeholder: AssetImage('assets/no_image.jpeg'),
              image: NetworkImage("https://www.themoviedb.org/t/p/w500" +
                  snapshot.data!.backdrops[0].filePath),
              fit: BoxFit.cover,
            );
          } else if (snapshot.hasError) {
            return FadeInImage(
              placeholder: AssetImage('assets/no_image.jpeg'),
              image: AssetImage('assets/loading.gif'),
              fit: BoxFit.cover,
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String title;
  final String originalTitle;
  final double voteAverage;
  final String postherPotho;

  _PosterAndTitle(
      {required this.title,
      required this.originalTitle,
      required this.voteAverage,
      required this.postherPotho});
  //const _PosterAndTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TEMA
    final TextTheme textTheme = Theme.of(context).textTheme;
    //MEDIA QUERY
    final size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Hero(
              tag: 'movie.horeId!',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no_image.jpeg'),
                  //image: NetworkImage('https://via.placeholder.com/200x300'),

                  image: NetworkImage(
                      "https://www.themoviedb.org/t/p/w600_and_h900_bestv2" +
                          postherPotho),
                  height: 150,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width - 190),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    originalTitle,
                    style: textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_outline,
                        size: 15,
                        color: Colors.cyan,
                      ),
                      SizedBox(width: 5),
                      Text(voteAverage.toStringAsPrecision(2),
                          style: textTheme.caption),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class _Overview extends StatelessWidget {
  final String overView;

  const _Overview({Key? key, required this.overView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        overView,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

class _CardSwiper extends StatelessWidget {
  final int id;
  const _CardSwiper({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Future<CreditsResponse> np;
    np = MoviesProvider().getCastingMovie(id);

    final size = MediaQuery.of(context).size;
    return getCast(context, np);
  }

  Widget getCast(BuildContext context, Future<CreditsResponse> np) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: FutureBuilder<CreditsResponse>(
          future: np,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                  width: double.infinity,
                  height: size.height * 0.5,

                  //color: Colors.red,

                  child: Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.cast.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: 110,
                              height: 100,
                              child: Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: _fImage(snapshot
                                          .data!.cast[index].profilePath)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.data!.cast[index].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          })));
            } else if (snapshot.hasError) {
              return Text('No hay datos');
            }
            return CircularProgressIndicator();
          }),
    );
  }

  FadeInImage _fImage(String image) {
    if (image.isEmpty) {
      return FadeInImage(
        placeholder: AssetImage('assets/no_image.jpeg'),
        image: NetworkImage('https://via.placeholder.com/200x300'),
        height: 140,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      return FadeInImage(
        placeholder: AssetImage('assets/no_image.jpeg'),
        image: NetworkImage(
            "https://www.themoviedb.org/t/p/w600_and_h900_bestv2" + image),
        height: 140,
        width: 100,
        fit: BoxFit.cover,
      );
    }
  }
}
