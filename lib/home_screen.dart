import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:goggle_map/constant/app_url.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textController2 = TextEditingController();
  var uuid = Uuid();
  String _sessionToken ='12344';
  List<dynamic> _placesList =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController2.addListener(() {
      onChange();
    });
  }
  void onChange(){
    if(_sessionToken==null){
        _sessionToken=uuid.v4();
    }
    getSuggestion(textController2.text);
  }
  void getSuggestion(String input) async{
    String aPI_Key ="AIzaSyC4PTPtMR2qopAVKdLUMkXS4oLRvVUQwIg";
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$aPI_Key&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    print(response.body.toString());

    if(response.statusCode == 200){
         setState(() {
           _placesList= jsonDecode(response.body.toString())['prediction'];
         });
     }
     else{
       throw Exception("failed to load datA");
     }
  }

  TextEditingController  textController = TextEditingController();
 Completer<GoogleMapController>  _controller = Completer();
  static const CameraPosition cameraPosition = CameraPosition(
      target:LatLng(28.6061, 77.3619) ,
    zoom:  16,
    tilt: 50
  );
  List<Marker> list = const[
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(28.6061, 77.3619)
    ),
    Marker(
        markerId: MarkerId("2"),
        position: LatLng(28.6460, 77.3695)
    ),
  ];
  MapType mapType = MapType.normal;

 void hybridCall(){
    if(mapType!=MapType.hybrid){
      mapType =MapType.hybrid;
    }
  }
  void normalCall(){
   if(mapType!=MapType.normal){
     mapType = MapType.normal;
   }
  }
  @override

  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.blue ,
       leading: Icon(Icons.arrow_forward),
       title: SizedBox(
         child: TextFormField(
           controller: textController,
           decoration: InputDecoration(
               isDense: true,
               contentPadding: EdgeInsets.zero,
               hintText: "Enter location",
               border: OutlineInputBorder(
               )
           ),
         ),
       ),
       actions: [
         IconButton(onPressed:()async{
           List<Location> locations = await locationFromAddress(textController.text.toString());
           GoogleMapController controller = await _controller.future;
           controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(locations.last.latitude,locations.last.longitude),zoom: 15
           )
           ));
           setState(() {

           });
         }, icon: Icon(Icons.search))
       ],
     ),
     body:  Column(
       children: [
         TextFormField(
           controller: textController2,
           decoration: InputDecoration(
             hintText: "Search pages with name"

           ),
         ),
         Expanded(
           child: Stack(
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: GoogleMap(
                   initialCameraPosition:cameraPosition ,
                   onMapCreated: (GoogleMapController controller){
                       _controller.complete(controller);
                   },
                   mapType:mapType,
                   compassEnabled: true,
                   myLocationButtonEnabled:true,
                   markers:Set<Marker>.of(list)
                 ),
               ),
              Positioned(
                bottom: 200,
                right: 20,
                child: Column(
                  children: [
                    buttoncall("Normal",normalCall),
                    SizedBox(height: 10,),
                    buttoncall("Hybrid",hybridCall)
                  ],
                ),
              )
             ],
           ),
         ),
       ],
     ),
    );
  }
  Widget buttoncall( String text, VoidCallback callback){
    return InkWell(
       onTap: (){
         callback();
         setState(() {

         });
       },
      child: Container(
        width:  80,
        height: 80,
        child: Center(child: Text(text,style: TextStyle(fontSize: 18),)),
        color: Colors.grey,
      ),
    );
  }
}