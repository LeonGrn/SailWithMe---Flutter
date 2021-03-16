
class Trip {

 double lat ;
 double lng ;
 String name;


 Trip({this.lat,this.lng,this.name});
 
 Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'name':name
      };

}
