import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/models/jobPost_module.dart';
import 'package:SailWithMe/screens/sub-screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_image/firebase_image.dart';

class JobOfferListScreen extends StatefulWidget {
  @override
  _JobOfferListScreenState createState() => _JobOfferListScreenState();
}

class _JobOfferListScreenState extends State<JobOfferListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: new IconButton(
            color: Colors.black,
            icon: new Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)}),
        title: Text(
          "JOB OFFERS",
          style: TextStyle(
              color: Palette.sailWithMe,
              fontFamily: 'IndieFlower',
              fontSize: 25.0),
        ),
      ),
      body: FutureBuilder(
        future: ApiCalls.getListOfJobsByUserId(), // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('No Connection');
            case ConnectionState.waiting:
              return new CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return new Text('No Job exist');
              else
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      JobPost jobOffer = snapshot.data[index];
                      return JobCard(jobOffer: jobOffer);
                    });
          }
        },
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final JobPost jobOffer;

  const JobCard({
    Key key,
    @required this.jobOffer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: jobOffer.createdBy.imageUrl != ""
                          ? FirebaseImage(
                              'gs://sailwithme.appspot.com/${jobOffer.createdBy.imageUrl}',
                              shouldCache:
                                  false, // The image should be cached (default: True)
                              // maxSizeBytes:
                              //     3000 * 1000, // 3MB max file size (default: 2.5MB)
                              // cacheRefreshStrategy: CacheRefreshStrategy
                              //     .NEVER // Switch off update checking
                            ) //??
                          : AssetImage('assets/user.png'),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(new MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return ProfileScreen(
                                            id: "${jobOffer.createdBy.id}");
                                      },
                                      fullscreenDialog: true));
                            },
                            child: Text(
                              "${jobOffer.createdBy.getName()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${jobOffer.timeAgo} • ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.0,
                                ),
                              ),
                              Icon(
                                Icons.public,
                                color: Colors.grey[600],
                                size: 12.0,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: 100,
                  height: 190,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[500],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Column contents vertically,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, //Center Column contents horizontally,
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon: Icon(
                          Icons.work,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      Text(
                        "Looking for ${jobOffer.position}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Row contents vertically,
                        children: [
                          Container(
                            width: 120,
                            height: 30,
                            child: Center(
                              child: Text(
                                "${jobOffer.employmentType}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 120,
                            height: 30,
                            child: Center(
                              child: Text(
                                "${jobOffer.location}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Row contents vertically,
                        children: [
                          Container(
                            width: 120,
                            height: 30,
                            child: Center(
                              child: Text(
                                "${jobOffer.salary}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 120,
                            height: 30,
                            child: Center(
                              child: Text(
                                "${jobOffer.vessel}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                Text("${jobOffer.description}"),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Palette.sailWithMe,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.thumb_up,
                        size: 10.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        '{job.likes}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Text(
                      '{job.comments} Comments',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    _PostButton(
                      icon: Icon(
                        MdiIcons.thumbUpOutline,
                        color: Colors.grey[600],
                        size: 20.0,
                      ),
                      label: 'Like',
                      onTap: () => print('Like'),
                    ),
                    _PostButton(
                      icon: Icon(
                        MdiIcons.commentOutline,
                        color: Colors.grey[600],
                        size: 20.0,
                      ),
                      label: 'Comment',
                      onTap: () => print('Comment'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function onTap;

  const _PostButton({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
