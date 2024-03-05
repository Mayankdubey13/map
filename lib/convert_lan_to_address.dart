import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';


class ConvertLanToAdress extends StatefulWidget {  @override
  State<ConvertLanToAdress> createState() => _ConvertLanToAdressState();
}

class _ConvertLanToAdressState extends State<ConvertLanToAdress> {
  String stAdress ='Hello World!';
  String stLocat ='Hello World!';

  getLocation() async
  {
    List<Placemark> placemarks = await placemarkFromCoordinates(28.641485, 77.371384);
    List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");
    stAdress= await placemarks.reversed.last.country.toString() +" "+ placemarks.reversed.last.locality.toString()+" "+placemarks.reversed.last.subAdministrativeArea.toString();
    stLocat= await locations.last.longitude.toString() +" "+ locations.last.longitude.toString();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Text(stAdress),
           Text(stLocat),
           InkWell(
             onTap: (){
              getLocation();
             },
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 height: 80,
                 width: double.infinity,
                 color: Colors.red,
                 child: const Center(child: Text("Convert",style: TextStyle(fontSize: 25),))
               ),
             ),
           ),
         ],
       ),
     );

  }}
