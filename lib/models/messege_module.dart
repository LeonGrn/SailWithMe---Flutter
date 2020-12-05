import 'models.dart';

class Message {
  final UserData sender;
  final String time;
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

// // EXAMPLE CHATS ON HOME SCREEN
// List<Message> chats = [
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '5:30 PM',
//     text: 'Hey dude! Even dead I\'m the hero. Love you 3000 guys.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '4:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '3:30 PM',
//     text: 'WOW! this soul world is amazing, but miss you guys.',
//     unread: false,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '2:30 PM',
//     text: 'I\'m exposed now. Please help me to hide my identity.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '1:30 PM',
//     text: 'HULK SMASH!!',
//     unread: false,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '12:30 PM',
//     text:
//         'I\'m hitting gym bro. I\'m immune to mortal deseases. Are you coming?',
//     unread: false,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '11:30 AM',
//     text: 'My twins are giving me headache. Give me some time please.',
//     unread: false,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '12:45 AM',
//     text: 'You\'re always special to me nick! But you know my struggle.',
//     unread: false,
//   ),
// ];
// List<Message> messages = [
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '5:30 PM',
//     text: 'Hey dude! Event dead I\'m the hero. Love you 3000 guys.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '4:30 PM',
//     text: 'We could surely handle this mess much easily if you were here.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '3:45 PM',
//     text: 'Take care of peter. Give him all the protection & his aunt.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '3:15 PM',
//     text: 'I\'m always proud of her and blessed to have both of them.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '2:30 PM',
//     text:
//         'But that spider kid is having some difficulties due his identity reveal by a blog called daily bugle.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '2:30 PM',
//     text:
//         'Pepper & Morgan is fine. They\'re strong as you. Morgan is a very brave girl, one day she\'ll make you proud.',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '2:30 PM',
//     text: 'Yes Tony!',
//     unread: true,
//   ),
//   Message(
//     sender: new User("Leon", "G", "g.com", 0544, "123",
//         "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
//     time: '2:00 PM',
//     text: 'I hope my family is doing well.',
//     unread: true,
//   ),
// ];
