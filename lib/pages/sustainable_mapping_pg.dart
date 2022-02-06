import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxon_app/directions_repository.dart';
import 'package:oxon_app/models/toilets.dart';
import 'package:oxon_app/repositories/loc_data_repository.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

import '../directions_model.dart';

class SusMapping extends StatefulWidget {
  SusMapping({Key? key, required this.title}) : super(key: key);
  static const routeName = '/mapping-page';

  final String title;

  @override
  _SusMappingState createState() => _SusMappingState();
}

class _SusMappingState extends State<SusMapping> with TickerProviderStateMixin {
  final LocDataRepository repository = LocDataRepository();
  Set<Marker> dustbinMarkers ={};
  Set<Marker> toiletMarkers ={};
  Completer<GoogleMapController> _controller = Completer();
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle solidRoundButtonStyle = SolidRoundButtonStyle();

    return SafeArea(
      child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Color.fromARGB(255, 34, 90, 0), // add this to remove the line green between appbar and body
          appBar: CustomAppBar(context, widget.title),
          body: Column(
            children: [
              Container(
                child: TabBar(
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 1,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                      insets: EdgeInsets.symmetric(horizontal: 50.0)),
                  controller: _tabController,
                  tabs: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () => _tabController.animateTo(0),
                            // allMarkers = {};},
                            icon: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/dustbin.png"))),
                            )),
                        Text(
                          "Dustbins",
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () => _tabController.animateTo(1),
                            // allMarkers = {};},
                            icon: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/toilet.png"))),
                            )),
                        Text(
                          "Toilets",
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () => _tabController.animateTo(2),
                            // allMarkers = {};},
                            icon: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/suggest_loc.png"))),
                            )),
                        Text(
                          "Suggest\nLocation",
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                // height: 100,
                height: (MediaQuery.of(context).size.height) * 0.4,
                // width: (MediaQuery.of(context).size.width),
                // height: 230,
                child: TabBarView( // TODO: add map here
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: repository.dustbinsGetStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator();

                            for (int i=0; i < snapshot.data!.docs.length; i++) {
                              dustbinMarkers.add(
                                  Marker(markerId: MarkerId("$i"),
                                    infoWindow: InfoWindow(title: "Public Dustbins",
                                    ),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                                    position: LatLng(snapshot.data!.docs[i]["location"].latitude, snapshot.data!.docs[i]
                                    ["location"].longitude),
                                  )
                              );
                            }

                            // print("This is snapshot");
                            // print(snapshot);
                            // final List<DocumentSnapshot> blank = [];
                            // initializeMarkers(snapshot.data?.docs);
                            return GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: CameraPosition(target: LatLng(26.4723125, 76.7268125), zoom: 16),
                              markers: dustbinMarkers,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            );
                          }
                      ),
                    ),
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: repository.toiletsGetStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return LinearProgressIndicator();

                          for (int i=0; i < snapshot.data!.docs.length; i++) {
                                toiletMarkers.add(
                                          Marker(markerId: MarkerId("$i"),
                                            infoWindow: InfoWindow(title: "Public Toilet",
                                            ),
                                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                                            position: LatLng(snapshot.data!.docs[i]["location"].latitude, snapshot.data!.docs[i]
                                                ["location"].longitude),
                                          )
                                );
                          }

                          // print("This is snapshot");
                          // print(snapshot);
                          // final List<DocumentSnapshot> blank = [];
                          // initializeMarkers(snapshot.data?.docs);
                          return GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: CameraPosition(target: LatLng(26.4723125, 76.7268125), zoom: 16),
                            markers: toiletMarkers,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          );
                        }
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/suggest_loc.png"))),
                            )),
                        Text(
                          "Suggest\nLocation",
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(80, 18, 80, 18),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Guide The Way",
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Color.fromARGB(255, 34, 90, 0)),
                    ),
                    style: solidRoundButtonStyle),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(80, 0, 80, 18),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Open In Maps",
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Color.fromARGB(255, 34, 90, 0)),
                    ),
                    style: solidRoundButtonStyle),
              ),
            ],
          )),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // origin is not set or bot are set
      setState(() {
        _origin = Marker(markerId: MarkerId("origin"),
        infoWindow: InfoWindow(title: "Origin",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
        );
        // reset destination marker
        _destination = null;

        _info = null;
      });
    } else {
      // origin is already set
      // set destination

      setState(() {
        _destination = Marker(markerId: MarkerId("destination"),
          infoWindow: InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository().getDirections(origin: _origin!.position, destination: _destination!.position);
      setState(() {
        _info = directions;
      });



    }
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final toilet = Toilet.fromSnapshot(snapshot);

    return Text("${toilet.location.latitude} ${toilet.location.longitude} ");  }

  // void initializeMarkers(List<DocumentSnapshot>? snapshots) {
  //   var counter = 0;
  //   for (counter=0; counter < snapshots!.length; counter += 1) {
  //     // final toilet = Toilet.fromSnapshot(snapshots[counter]);
  //     allMarkers.add(
  //               Marker(markerId: MarkerId("$counter"),
  //                 infoWindow: InfoWindow(title: "Public Toilet",
  //                 ),
  //                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //                 position: LatLng(snapshots[counter].location.latitude, toilet.location.longitude),
  //               )
  //     );
  //   }
  //
  //
  //   setState(() {
  //
  //   });
  //   // snapshots!.forEach((element) {
  //   //   final toilet = Toilet.fromSnapshot(element);
  //   //   print(toilet.location);
  //   //   allMarkers.add(
  //   //       Marker(markerId: MarkerId("$counter"),
  //   //         infoWindow: InfoWindow(title: "Public Toilet",
  //   //         ),
  //   //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   //         position: LatLng(toilet.location.latitude, toilet.location.longitude),
  //   //       )      );
  //   //
  //   //   counter += 1;
  //   // });
  //   // snapshots!.asMap().forEach((index, element) {
  //   //   final toilet = Toilet.fromSnapshot(element);
  //   //   print(toilet.location);
  //   //   allMarkers.add(
  //   //       Marker(markerId: MarkerId("$index"),
  //   //         infoWindow: InfoWindow(title: "Public Toilet",
  //   //         ),
  //   //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   //         position: LatLng(toilet.location.latitude, toilet.location.longitude),
  //   //       )      );
  //   // });
  //
  //   // setState(() {
  //   //
  //   // });
  // }
}

// todo convert into geopoints at firestore
// fetch as geopoint