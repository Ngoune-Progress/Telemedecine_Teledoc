import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teledoc/home/healthSpecialistDetail.dart';
import 'package:teledoc/variable.dart';
import 'package:uuid/uuid.dart';

class SearchMap extends StatefulWidget {
  final List<dynamic> tempStore;
  const SearchMap({Key? key, required this.tempStore}) : super(key: key);

  @override
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  Uint8List? markerIcon;
  bool isView = true;
  TextEditingController specialityController = TextEditingController();
  final bitmapIcon = BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)), 'assets/images/marker.png');
  Completer<GoogleMapController> _controller = Completer();
  var queryResultSet = [];
  var tempSearchStore = [];
  List<Marker> list = [];
  final Set<Marker> markers = new Set();
  // searchByName(String searchField) {
  //   return doctorsCollections
  //       .where('searchKey',
  //           isEqualTo: searchField.substring(0, 1).toLowerCase())
  //       .get();
  // }

  // initiateSearch(value) {
  //   if (value.length == 0) {
  //     setState(() {
  //       queryResultSet = [];
  //       tempSearchStore = [];
  //     });
  //   }
  //   var capitalizedValue =
  //       value.substring(0, 1).toLowerCase() + value.substring(1);

  //   if (queryResultSet.length == 0 && value.length == 1) {
  //     searchByName(value).then((QuerySnapshot d) {
  //       for (int i = 0; i < d.docs.length; ++i) {
  //         queryResultSet.add(d.docs[i].data());
  //         print(d.docChanges);
  //       }
  //     });
  //   } else {
  //     tempSearchStore = [];
  //     list = [];
  //     queryResultSet.forEach((element) {
  //       if (element['speciality'].startsWith(capitalizedValue)) {
  //         print("its me");
  //         setState(() {
  //           tempSearchStore.add(element);
  //         });
  //       }
  //     });
  //   }
  // }

  // @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _googleMap(context),
        ],
      ),
    );
  }

  _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(3.844119, 11.501346), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: getmarkers(),
      ),
    );
  }

  Widget buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 20, left: 20),
        height: 130,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: tempSearchStore.map((element) {
              return demoTopRatedDoctor(
                  element['uid'],
                  element['Address'],
                  element['image_url'],
                  element['name'],
                  element['speciality'],
                  "5.0",
                  context,
                  '200');
            }).toList()),
      ),
    );
  }

  Widget demoTopRatedDoctor(
      String uid,
      String address,
      String image,
      String name,
      String speciality,
      String rating,
      BuildContext context,
      String amount) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HealthSpecialistDetailPage(
                        uid: uid,
                        address: address,
                        image_url: image,
                        name: name,
                        speciality: speciality,
                      )));
        },
        child: Container(
          height: 200,
          width: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 2,
                    offset: Offset.zero)
              ]),
          margin: EdgeInsets.only(top: 10, bottom: 7, left: 10),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 90,
                        width: 90,
                        child: ClipOval(
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        )),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Dr $name",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          // Container(
                          //   width: 10,
                          //   margin: EdgeInsets.only(top: 10, left: 10),
                          //   child: Text(
                          //     "Bill Amount: $address FCFA",
                          //     style: TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w300),
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    speciality,
                                    style: TextStyle(
                                        color: Color(0xffababab),
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            child: Row(
                              children: [
                                Container(
                                  child: Text(
                                    "Rating:",
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'Roboto'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    rating,
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'Roboto'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ));
  }

  Marker marker = Marker(
      markerId: MarkerId("Marker"),
      position: LatLng(3.813420656019075, 11.558190522734236),
      infoWindow: InfoWindow(title: "Peet"),
      icon: BitmapDescriptor.defaultMarker);

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      widget.tempStore.map((element) async {
        final Uint8List markerIcon =
            await getBytesFromAsset('assets/images/mak.png', 80);

        setState(() {
          markers.add(Marker(
              markerId: MarkerId(Uuid().v1()),
              position: LatLng(
                  double.parse(element['lat']), double.parse(element['lon'])),
              infoWindow: InfoWindow(title: "Dr " + element['name']),
              icon: BitmapDescriptor.fromBytes(markerIcon)));
        });
      }).toList();

      //add more markers here
    });
    return markers;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
