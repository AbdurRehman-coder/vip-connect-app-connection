// class GroupChatService {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   final _publicGroupsStream = FirebaseFirestore.instance
//       .collection('groups')
//       .where('isPrivate', isEqualTo: false)
//       .orderBy('timestamp', descending: true)
//       .snapshots();
//   late final Stream<List<GroupChatModel>> publicGroups;
//
//   final _privateGroupsStream = FirebaseAuth.instance.currentUser != null
//       ? FirebaseFirestore.instance
//           .collection('groups')
//           .where('isPrivate', isEqualTo: true)
//           .where('members',
//               arrayContains: FirebaseAuth.instance.currentUser?.uid)
//           .orderBy('timestamp', descending: true)
//           .snapshots()
//       : const Stream.empty();
//   late final Stream<List<GroupChatModel>> privateGroups;
//
//   final StreamGroup<List<GroupChatModel>> _streamGroup;
//
//   GroupChatService() {
//     publicGroups = _publicGroupsStream
//         .map((querySnapshot) => querySnapshot.docs.map((doc) {
//               final data = doc.data();
//               final groupId = doc.id;
//               final name = data['name'] ?? '';
//               final description = data['description'] ?? '';
//               final timestamp = data['timestamp'] as Timestamp;
//               return GroupChat(
//                 groupId: groupId,
//                 name: name,
//                 description: description,
//                 isPrivate: false,
//                 timestamp: timestamp.toDate(),
//               );
//             }).toList());
//
//     privateGroups = _privateGroupsStream
//         .map((querySnapshot) => querySnapshot.docs.map((doc) {
//               final data = doc.data();
//               final groupId = doc.id;
//               final name = data['name'] ?? '';
//               final description = data['description'] ?? '';
//               final timestamp = data['timestamp'] as Timestamp;
//               return GroupChat(
//                 groupId: groupId,
//                 name: name,
//                 description: description,
//                 isPrivate: true,
//                 timestamp: timestamp.toDate(),
//               );
//             }).toList());
//
//     _streamGroup =
//         StreamGroup.merge<List<GroupChat>>([publicGroups, privateGroups]);
//   }
//
//   Stream<List<GroupChat>> getGroupChats() => _streamGroup.stream;
// }

/// TODO:
// Stream<List<GroupChatModel>> getGroupChats() {
//   final publicGroupStream = FirebaseFirestore.instance
//       .collection('groupChat')
//       .where('isPrivate', isEqualTo: false)
//       .orderBy('timestamp', descending: true)
//       .snapshots()
//       .map((snapshot) =>
//           snapshot.docs.map((doc) => GroupChatModel.fromJson(doc)).toList());
//
//   final privateGroupStream = FirebaseAuth.instance.currentUser != null
//       ? FirebaseFirestore.instance
//           .collection('groupChat')
//           .where('isPrivate', isEqualTo: true)
//           .snapshots()
//           .map((snapshot) =>
//               snapshot.docs.map((doc) => GroupChatModel.fromJson(doc)).toList())
//           .asyncMap((privateGroupChats) async {
//           final userDoc = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(FirebaseAuth.instance.currentUser!.uid)
//               .get();
//           final user = UserModel.fromJson(userDoc as Map<String, dynamic>);
//           final privateGroups = privateGroupChats
//               .where((group) => group.members!.contains(user.email))
//               .toList();
//           return privateGroups;
//         })
//       : Stream.value([]);
//
//   return Rx.combineLatest2<List<GroupChatModel>, List<GroupChatModel>,
//       List<GroupChatModel>>(
//     publicGroupStream,
//     privateGroupStream,
//     (publicGroups, privateGroups) => [...publicGroups, ...privateGroups],
//   );
// }
