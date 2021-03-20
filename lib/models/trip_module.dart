
import 'dart:typed_data';

class Trip {
String imageRef;
 double lat ;
 double lng ;
 String name;


 Trip({this.lat,this.lng,this.name,this.imageRef});
 
 Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'name':name,
        'imageRef':imageRef
      };

}
