import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class VaccinationMap extends StatefulWidget {
  final List<dynamic> tempStore;
  const VaccinationMap({Key? key, required this.tempStore}) : super(key: key);

  @override
  _VaccinationMapState createState() => _VaccinationMapState();
}

class _VaccinationMapState extends State<VaccinationMap> {
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
              infoWindow: InfoWindow(title: element['name']),
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
