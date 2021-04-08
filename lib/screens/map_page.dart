import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:SailWithMe/Keys/configMaps.dart';
import '../config/ApiCalls.dart';
import '../models/models.dart';
import 'package:geolocator/geolocator.dart' as geocoding;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/trip_module.dart';
import 'dart:math' show cos, sqrt, asin;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int checkBuildContainer = 1;
  Dio dio = new Dio();
  Response response;
  GoogleMapController mapController;
  double zoomVal = 5.0;
// For storing the current position
  geocoding.Position _currentPosition;
  String _currentAddress;
  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;
  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();
  final destinationAddressController = TextEditingController();
  Set<Marker> markers = {};
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  final startAddressController = TextEditingController();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff84FFFF),
        body: Stack(children: <Widget>[
          _buildGoogleMap(context),
          _safeAreaWithtInputTextFilled(),
          _safeAreawiget(),
          checkBuildContainer % 2 == 0
              ? _buildContainer()
              : _safeAreaForGetLocationButton(),
        ]));
  }

  Widget _safeAreawiget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.blue[100], // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.add),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ClipOval(
              child: Material(
                color: Colors.blue[100], // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.remove),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            savePlaces(),
            SizedBox(height: 20),
            _ricomanderRiver(),
          ],
        ),
      ),
    );
  }

  Widget savePlaces() {
    return ClipOval(
      child: Material(
        color: Colors.yellow[500], // button color
        child: InkWell(
          splashColor: Colors.blue, // inkwell color
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.star,
              color: Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              checkBuildContainer++;
            });
          },
        ),
      ),
    );
  }

  Widget _safeAreaForGetLocationButton() {
    return (
        // Show current location button
        SafeArea(
            child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                    child: ClipOval(
                        child: Material(
                            color: Colors.orange[100], // button color
                            child: InkWell(
                                splashColor: Colors.orange, // inkwell color
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(Icons.my_location),
                                ),
                                onTap: () {
                                  mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                          _currentPosition.latitude,
                                          _currentPosition.longitude,
                                        ),
                                        zoom: 18.0,
                                      ),
                                    ),
                                  );
                                })))))));
  }

  Widget _ricomanderRiver() {
    return ClipOval(
      child: Material(
        child: InkWell(
          splashColor: Colors.blue, // inkwell color
          child: SizedBox(
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              "assets/river.svg",
              height: 50.0,
              width: 50.0,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          onTap: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      title: Text(
                        "Informations",
                        style: GoogleFonts.lato(
                          fontSize: 25,
                          textStyle: TextStyle(
                              color: Colors.grey,
                              letterSpacing: .5,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      content: setupAlertDialoadContainer(),
                    );
                  });
            });
          },
        ),
      ),
    );
  }

  Widget setupAlertDialoadContainer() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: FutureBuilder(
            future: ApiCalls.getRecomandRiver(), // async work
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView(shrinkWrap: true, children: <Widget>[
                  ListTile(
                    title: Text('Name: ${snapshot.data}'),
                  )
                ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        markers: markers != null ? Set<Marker>.from(markers) : null,
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: FutureBuilder(
            future: ApiCalls.getListOfTrips(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(child: Text("wait..."));
              } else {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: SizedBox(
                              // width: 180,
                              //     height: 200,
                              child: _boxes(
                                  snapshot.data[index].imageRef,
                                  snapshot.data[index].lat,
                                  snapshot.data[index].lng,
                                  snapshot.data[index].name)));
                    });
              }
            }),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String placeName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=$_image&key=$mapKey"),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(placeName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  Widget myDetailsContainer1(String placeName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            placeName.length > 20 ? placeName.substring(0, 19) : placeName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              "4.1",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              "(946)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Closed \u00B7 Opens 17:00 Thu",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  Widget _safeAreaWithtInputTextFilled() {
    return (SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            width: 400 * 0.9,
            child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Places',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 10),
                    _textField(
                        label: 'Start',
                        hint: 'Choose starting point',
                        prefixIcon: Icon(Icons.looks_one),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: () {
                            startAddressController.text = _currentAddress;
                            _startAddress = _currentAddress;
                          },
                        ),
                        controller: startAddressController,
                        focusNode: startAddressFocusNode,
                        width: 400,
                        locationCallback: (String value) {
                          setState(() {
                            _startAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    _textField(
                        label: 'Destination',
                        hint: 'Choose destination',
                        prefixIcon: Icon(Icons.looks_two),
                        controller: destinationAddressController,
                        focusNode: desrinationAddressFocusNode,
                        width: 400,
                        locationCallback: (String value) {
                          setState(() {
                            _destinationAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    Visibility(
                      visible: _placeDistance == null ? false : true,
                      child: Text(
                        'DISTANCE: $_placeDistance km',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    RaisedButton(
                      onPressed: (_startAddress != '' &&
                              _destinationAddress != '')
                          ? () async {
                              startAddressFocusNode.unfocus();
                              desrinationAddressFocusNode.unfocus();
                              setState(() {
                                if (markers.isNotEmpty) markers.clear();
                                if (polylines.isNotEmpty) polylines.clear();
                                if (polylineCoordinates.isNotEmpty)
                                  polylineCoordinates.clear();
                                _placeDistance = null;
                              });

                              _calculateDistance().then((isCalculated) {
                                if (isCalculated) {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Distance Calculated Sucessfully'),
                                    ),
                                  );
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Error Calculating Distance'),
                                    ),
                                  );
                                }
                              });
                            }
                          : null,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Show Route'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    ));
  }

  getAllSavePlaces() async {
    List<Trip> trips = ApiCalls.getListOfTrips() as List<Trip>;
    List<Marker> markers = [];
    String count = "a";

    for (Trip trip in trips) {
      markers.add(new Marker(
        markerId: MarkerId(count),
        position: LatLng(trip.lat, trip.lng),
        infoWindow: InfoWindow(title: trip.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ));
      return markers;
    }
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await geocoding.Geolocator.getCurrentPosition(
            desiredAccuracy: geocoding.LocationAccuracy.high)
        .then((geocoding.Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        // Structuring the address
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

        // Update the text of the TextField
        startAddressController.text = _currentAddress;

        // Setting the user's present location as the starting address
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
      geocoding.Position start, geocoding.Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  // Formula for calculating distance between two coordinates
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

// Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    // Retrieving placemarks from addresses
    List<Location> startPlacemark = await locationFromAddress(_startAddress);
    List<Location> destinationPlacemark =
        await locationFromAddress(_destinationAddress);

    if (startPlacemark != null && destinationPlacemark != null) {
      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      geocoding.Position startCoordinates = _startAddress == _currentAddress
          ? geocoding.Position(
              latitude: _currentPosition.latitude,
              longitude: _currentPosition.longitude)
          : geocoding.Position(
              latitude: startPlacemark[0].latitude,
              longitude: startPlacemark[0].longitude);
      geocoding.Position destinationCoordinates = geocoding.Position(
          latitude: destinationPlacemark[0].latitude,
          longitude: destinationPlacemark[0].longitude);

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId('$startCoordinates'),
        position: LatLng(
          startCoordinates.latitude,
          startCoordinates.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Start',
          snippet: _startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId('$destinationCoordinates'),
        position: LatLng(
          destinationCoordinates.latitude,
          destinationCoordinates.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print('START COORDINATES: $startCoordinates');
      print('DESTINATION COORDINATES: $destinationCoordinates');

      geocoding.Position _northeastCoordinates;
      geocoding.Position _southwestCoordinates;

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny =
          (startCoordinates.latitude <= destinationCoordinates.latitude)
              ? startCoordinates.latitude
              : destinationCoordinates.latitude;
      double minx =
          (startCoordinates.longitude <= destinationCoordinates.longitude)
              ? startCoordinates.longitude
              : destinationCoordinates.longitude;
      double maxy =
          (startCoordinates.latitude <= destinationCoordinates.latitude)
              ? destinationCoordinates.latitude
              : startCoordinates.latitude;
      double maxx =
          (startCoordinates.longitude <= destinationCoordinates.longitude)
              ? destinationCoordinates.longitude
              : startCoordinates.longitude;

      _southwestCoordinates =
          geocoding.Position(latitude: miny, longitude: minx);
      _northeastCoordinates =
          geocoding.Position(latitude: maxy, longitude: maxx);

      // Accommodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(
              _northeastCoordinates.latitude,
              _northeastCoordinates.longitude,
            ),
            southwest: LatLng(
              _southwestCoordinates.latitude,
              _southwestCoordinates.longitude,
            ),
          ),
          100.0,
        ),
      );
      await _createPolylines(startCoordinates, destinationCoordinates);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    }
  }
}
