import 'models.dart';

class Group {
  List<UserData> friendsList;
  List<Event> eventList;
  List<Post> posts;
  List get getFriendsList => friendsList;

  set setFriendsList(List friendsList) => this.friendsList = friendsList;

  List get getEventList => eventList;

  set setEventList(List eventList) => this.eventList = eventList;

  List get getPosts => posts;

  set setPosts(List posts) => this.posts = posts;
}
