import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxon_app/directions_repository.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

import '../directions_model.dart';

class SusMapping extends StatefulWidget {
  SusMapping({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SusMappingState createState() => _SusMappingState();
}

class _SusMappingState extends State<SusMapping> with TickerProviderStateMixin {
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
                // height: 100,
                height: (MediaQuery.of(context).size.height) * 0.35,
                // width: (MediaQuery.of(context).size.width),
                // height: 230,
                child: TabBarView( // TODO: add map here
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GoogleMap(
                            polylines: {
                              if(_info != null)
                                Polyline(polylineId: PolylineId("overview_polyline"),color:Colors.red,
                                width: 5,
                                points: _info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList())
                            },

                            onLongPress: _addMarker,
                            mapType: MapType.hybrid,
                            initialCameraPosition: _kGooglePlex,
                            markers: {
                              if (_origin != null) _origin!,
                              if (_destination != null) _destination!
                            },
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                          if (_info!= null)
                            Positioned(
                              top: 20.0,
                              child: Container(
                                child: Text(
                                  '${_info!.totalDistance},${_info!.totalDuration}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.oxonOffWhite, //change color
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                  )]
                                ),
                              ),
                            )
                        ],
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
}
