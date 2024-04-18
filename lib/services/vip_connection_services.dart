// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ConnectionService {
//   final String currentUserID;
//
//   /// constructor
//   ConnectionService(this.currentUserID);
//
//   /// User collection reference
//   final CollectionReference _userCollection =
//       FirebaseFirestore.instance.collection('user');
//
//   Future<void> sendConnectionRequest(String recipientID) async {
//     // Check if the recipient has already sent a connection request
//     final recipientConnectionsSnap = await _userCollection
//         .doc(recipientID)
//         .collection('connections')
//         .where('recipient_id', isEqualTo: currentUserID)
//         .get();
//     if (recipientConnectionsSnap.docs.isNotEmpty) {
//       throw Exception(
//           'You have already sent a connection request to this user.');
//     }
//
//     // Check if the current user has already sent a connection request to the recipient
//     final senderConnectionsSnap = await _userCollection
//         .doc(currentUserID)
//         .collection('connections')
//         .where('recipient_id', isEqualTo: recipientID)
//         .get();
//     if (senderConnectionsSnap.docs.isNotEmpty) {
//       throw Exception(
//           'You have already sent a connection request to this user.');
//     }
//
//     /// Create a new connection request document in the recipient's connections subcollection
//     await _userCollection.doc(recipientID).collection('connections').add({
//       'sender_id': currentUserID,
//       'recipient_id': recipientID,
//       'status': 'pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     /// Create a new notification document in the recipient's notifications subcollection
//     await _userCollection.doc(recipientID).collection('notifications').add({
//       'type': 'connection_request',
//       'message':
//           'You have received a new connection request from ${currentUserID}.',
//       'is_read': false,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//
//   Future<void> acceptConnectionRequest(
//       String connectionID, String senderID) async {
//     // Update the status of the connection document in both the sender and recipient's connections subcollections
//     await _userCollection
//         .doc(senderID)
//         .collection('connections')
//         .doc(connectionID)
//         .update({
//       'status': 'accepted',
//     });
//     await _userCollection
//         .doc(currentUserID)
//         .collection('connections')
//         .doc(connectionID)
//         .update({
//       'status': 'accepted',
//     });
//
//     // Create a new notification document in the sender's notifications subcollection
//     await _userCollection.doc(senderID).collection('notifications').add({
//       'type': 'connection_accepted',
//       'message': '${currentUserID} has accepted your connection request.',
//       'is_read': false,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//
//   Future<void> rejectConnectionRequest(
//       String connectionID, String senderID) async {
//     // Update the status of the connection document in both the sender and recipient's connections subcollections
//     await _userCollection
//         .doc(senderID)
//         .collection('connections')
//         .doc(connectionID)
//         .update({
//       'status': 'rejected',
//     });
//     await _userCollection
//         .doc(currentUserID)
//         .collection('connections')
//         .doc(connectionID)
//         .update({
//       'status': 'rejected',
//     });
//
//     // Create a new notification document in the sender's notifications subcollection
//     await _userCollection.doc(senderID).collection('notifications').add({
//       'type': 'connection_rejected',
//       'message': '${currentUserID} has declined your connection request.',
//       'is_read': false,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//
//   Future<void> cancelConnectionRequest(
//       String connectionID, String recipientID) async {
//     // Delete the connection document from both the sender and recipient's connections subcollections
//     await _userCollection
//         .doc(currentUserID)
//         .collection('connections')
//         .doc(connectionID)
//         .delete();
//     await _userCollection
//         .doc(recipientID)
//         .collection('connections')
//         .doc(connectionID)
//         .delete();
//   }
//
//   Stream<QuerySnapshot> getPendingConnectionRequests() {
//     // Return a stream of the current user's pending connection requests
//     return _userCollection
//         .doc(currentUserID)
//         .collection('connections')
//         .where('status', isEqualTo: 'pending')
//         .snapshots();
//   }
//
//   Stream<QuerySnapshot> getNotifications() {
//     // Return a stream of the current user's notifications
//     return _userCollection
//         .doc(currentUserID)
//         .collection('notifications')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }
//
//   Future<void> markNotificationAsRead(String notificationID) async {
//     // Update the is_read field of the notification document
//     await _userCollection
//         .doc(currentUserID)
//         .collection('notifications')
//         .doc(notificationID)
//         .update({'is_read': true});
//   }
// }

/// todo:
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class ConnectionService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<String?> sendConnectionRequest(String receiverId) async {
//     try {
//       final String? senderId = _auth.currentUser?.uid;
//       if (senderId == null) {
//         return 'User not authenticated';
//       }
//       if (senderId == receiverId) {
//         return 'You cannot send connection request to yourself';
//       }
//       final DocumentReference receiverRef =
//       _firestore.collection('users').doc(receiverId);
//       final DocumentSnapshot receiverSnapshot = await receiverRef.get();
//       if (!receiverSnapshot.exists) {
//         return 'User does not exist';
//       }
//       final Map<String, dynamic> request = <String, dynamic>{
//         'sender': senderId,
//         'receiver': receiverId,
//         'status': 'pending',
//         'created_at': FieldValue.serverTimestamp(),
//       };
//       final CollectionReference requestCollection =
//       _firestore.collection('users/$receiverId/connections');
//       final DocumentReference requestDoc = requestCollection.doc();
//       await requestDoc.set(request);
//       final CollectionReference outgoingCollection =
//       _firestore.collection('users/$senderId/outgoingConnections');
//       final DocumentReference outgoingDoc =
//       outgoingCollection.doc(requestDoc.id);
//       await outgoingDoc.set(request);
//       await _sendNotification(
//         receiverId,
//         'New connection request received from ${_auth.currentUser?.displayName}',
//       );
//       return null;
//     } on FirebaseException catch (e) {
//       return e.message;
//     }
//   }
//
//   Future<void> acceptConnectionRequest(String requestId) async {
//     final String? userId = _auth.currentUser?.uid;
//     if (userId == null) {
//       return;
//     }
//     final CollectionReference requestCollection =
//     _firestore.collection('users/$userId/connections');
//     final DocumentReference requestDoc = requestCollection.doc(requestId);
//     final DocumentSnapshot requestSnapshot = await requestDoc.get();
//     if (!requestSnapshot.exists) {
//       return;
//     }
//     final Map<String, dynamic> request = requestSnapshot.data()
//     as Map<String, dynamic>; // may need typecast depending on your schema
//     if (request['status'] != 'pending') {
//       return;
//     }
//     final String senderId = request['sender'] as String;
//     final DocumentReference senderRef =
//     _firestore.collection('users').doc(senderId);
//     final DocumentSnapshot senderSnapshot = await senderRef.get();
//     if (!senderSnapshot.exists) {
//       return;
//     }
//     final Map<String, dynamic> connection = <String, dynamic>{
//       'user_id': senderId,
//       'created_at': FieldValue.serverTimestamp(),
//     };
//     final CollectionReference connectionCollection =
//     _firestore.collection('users/$userId/connections');
//     await connectionCollection.doc(senderId).set(connection);
//     final CollectionReference senderOutgoingCollection =
//     _firestore.collection('users/$senderId/outgoingConnections');
//     await senderOutgoingCollection.doc(requestId).update(<String, dynamic>{
//       'status': 'accepted',
//       'updated_at': FieldValue.serverTimestamp(),
//     });
//     final CollectionReference senderConnectionCollection =
//     _firestore.collection('users/$senderId/connections');
//     await senderConnectionCollection.doc(userId).set(connection);
//     final CollectionReference receiverOutgoingCollection =
//     _firestore.collection('users/$userId/outgoingConnections');
//     await receiverOutgoingCollection.doc(requestId).update(<String, dynamic>{
//         'status': 'accepted',
//         'updated

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vip_connect/model/user_model.dart';

class ConnectionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> sendConnectionRequest(
      String currentUserId, String targetUserId) async {
    final currentUserRef = _db.collection('user').doc(currentUserId);
    final targetUserRef = _db.collection('user').doc(targetUserId);

    final batch = _db.batch();

    /// Add connection request to target user's incoming connections subcollection
    final connectionRequestRef =
        targetUserRef.collection('incomingConnections').doc(currentUserId);
    batch.set(
      connectionRequestRef,
      {
        'senderId': currentUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      },
    );

    // Add connection request to current user's outgoing connections subcollection
    final outgoingConnectionRef =
        currentUserRef.collection('outgoingConnections').doc(targetUserId);
    batch.set(
      outgoingConnectionRef,
      {
        'receiverId': targetUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  Future<void> acceptConnectionRequest(
      String userId, String requesterId) async {
    final currentUserRef = _db.collection('users').doc(userId);
    final requesterUserRef = _db.collection('users').doc(requesterId);

    final batch = _db.batch();

    /// Update incoming connection request status to accepted
    final incomingConnectionRef =
        currentUserRef.collection('incomingConnections').doc(requesterId);
    batch.update(incomingConnectionRef, {'status': 'accepted'});

    // Update outgoing connection request status to accepted
    final outgoingConnectionRef =
        requesterUserRef.collection('outgoingConnections').doc(userId);
    batch.update(outgoingConnectionRef, {'status': 'accepted'});

    // Add connection to current user's connections subcollection
    final connectionRef =
        currentUserRef.collection('connections').doc(requesterId);
    batch.set(
      connectionRef,
      {'status': 'accepted', 'timestamp': FieldValue.serverTimestamp()},
    );

    // Add connection to requester's connections subcollection
    final requesterConnectionRef =
        requesterUserRef.collection('connections').doc(userId);
    batch.set(
      requesterConnectionRef,
      {'status': 'accepted', 'timestamp': FieldValue.serverTimestamp()},
    );

    await batch.commit();

    /// Send FCM notification to requester user
    final requesterUserDoc = await requesterUserRef.get();
    final requesterUserToken = requesterUserDoc.data()?['fcmToken'];
    if (requesterUserToken != null) {
      // ChatServices().sendNotification([requesterUserToken], 'connection', 'connect2', 'connection');
      // await _fcm.send(
      //   messaging.Message(
      //     notification: messaging.Notification(
      //       title: 'Connection Request Accepted',
      //       body: 'Your connection request has been accepted.',
      //     ),
      //     token: requesterUserToken,
      //   ),
      // );
    }
  }

  /// On Connection accept
  void acceptFriendRequest(String senderId) async {
    final user = FirebaseAuth.instance.currentUser;
    final batch = FirebaseFirestore.instance.batch();
    final currentUserRef =
        FirebaseFirestore.instance.collection('user').doc(user?.uid);
    final senderRef =
        FirebaseFirestore.instance.collection('user').doc(senderId);

    // Update the current user's incommingConnections subcollection
    final incommingConnectionRef =
        currentUserRef.collection('incomingConnections').doc(senderId);
    batch.update(incommingConnectionRef,
        {'status': 'accepted', 'timestamp': FieldValue.serverTimestamp()});

    // Update the sender's outgoingConnections subcollection
    final outgoingConnectionRef =
        senderRef.collection('outgoingConnections').doc(user?.uid);
    batch.update(outgoingConnectionRef,
        {'status': 'accepted', 'timestamp': FieldValue.serverTimestamp()});

    /// Add the accepted user's UID to the array of accepted connections in the current user's document
    final currentUserDocRef =
        FirebaseFirestore.instance.collection('user').doc(user?.uid);

    /// Create accepted connections / friend list uid in current user collection on acceptance
    await currentUserDocRef.update({
      // store sender id
      'acceptedConnections': FieldValue.arrayUnion([senderId])
    });

    /// Create accepted connections / friend list uid in sender user collection on acceptance
    await senderRef.update({
      // store current user in sender
      'acceptedConnections': FieldValue.arrayUnion([user?.uid])
    });

    // Commit the batch
    await batch.commit();
  }

  void declineFriendRequest(String senderId) async {
    final user = FirebaseAuth.instance.currentUser;
    final batch = FirebaseFirestore.instance.batch();
    final currentUserRef =
        FirebaseFirestore.instance.collection('user').doc(user?.uid);
    final senderRef =
        FirebaseFirestore.instance.collection('user').doc(senderId);

    // Update the current user's incommingConnections subcollection
    final incommingConnectionRef =
        currentUserRef.collection('incomingConnections').doc(senderId);
    batch.update(incommingConnectionRef,
        {'status': 'decline', 'timestamp': FieldValue.serverTimestamp()});

    // Update the sender's outgoingConnections subcollection
    final outgoingConnectionRef =
        senderRef.collection('outgoingConnections').doc(user?.uid);
    batch.update(outgoingConnectionRef,
        {'status': 'decline', 'timestamp': FieldValue.serverTimestamp()});

    /// Add the accepted user's UID to the array of accepted connections in the current user's document
    final currentUserDocRef =
        FirebaseFirestore.instance.collection('user').doc(user?.uid);

    // /// Create accepted connections / friend list uid in current user collection on acceptance
    // await currentUserDocRef.update({
    //   // store sender id
    //   'acceptedConnections': FieldValue.arrayUnion([senderId])
    // });
    // /// Create accepted connections / friend list uid in sender user collection on acceptance
    // await senderRef.update({
    //   // store current user in sender
    //   'acceptedConnections': FieldValue.arrayUnion([user?.uid])
    // });

    // Commit the batch
    await batch.commit();
  }

  /// Get connection status For VIP Module Main Screen
  Stream<String> getConnectionStatusStream(UserModel user) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserRef = _db.collection('user').doc(currentUser!.uid);

    String status = 'none';

    final outgoingStream = currentUserRef
        .collection('outgoingConnections')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = doc.data();
        final status = data!['status'] as String;
        return status;
      } else {
        return 'notConnected';
      }
    });

    final incomingStream = currentUserRef
        .collection('incomingConnections')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = doc.data();
        final status = data!['status'] as String;
        return status;
      } else {
        return 'notConnected';
      }
    });

    return StreamZip([outgoingStream, incomingStream]).map((statuses) {
      if (statuses[0] != 'notConnected') {
        return statuses[0];
      } else if (statuses[1] != 'notConnected') {
        return statuses[1];
      } else {
        return 'notConnected';
      }
    });

    // Stream<String> outgoingStream = currentUserRef
    //     .collection('outgoingConnections')
    //     .doc(user.uid)
    //     .snapshots()
    //     .map((doc) {
    //   if (doc.exists) {
    //     final data = doc.data();
    //     final status = data!['status'] as String;
    //     print('outgoing connections status: $status');
    //     return status;
    //   } else {
    //     return 'notConnected';
    //   }
    // });
    //
    // Stream<String> incomingStream = currentUserRef
    //     .collection('incomingConnections')
    //     .doc(user.uid)
    //     .snapshots()
    //     .map((doc) {
    //   if (doc.exists) {
    //     final data = doc.data();
    //     final status = data!['status'] as String;
    //     print('incoming connections status: $status');
    //     return status;
    //   } else {
    //     return 'notConnected';
    //   }
    // });
    // print('merge stream status: ${StreamGroup.merge<String>([
    //       outgoingStream,
    //       incomingStream
    //     ])}');
    //
    // /// Merge the two streams into one
    // return StreamGroup.merge<String>([
    //   incomingStream,
    //   outgoingStream,
    // ]);

    ///TODO: first implementation only for incoming
    // return currentUserRef
    //     .collection('outgoingConnections')
    //     .doc(user.uid)
    //     .snapshots()
    //     .map((doc) {
    //   if (doc.exists) {
    //     final data = doc.data();
    //     final status = data!['status'] as String;
    //     return status;
    //   } else {
    //     return 'notConnected';
    //   }
    // });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserModel>> getIncomingConnectionRequests() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return _firestore
        .collection('user')
        .doc(currentUser?.uid)
        .collection('incomingConnections')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<UserModel> users = [];
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String senderId = data['senderId'];
        DocumentSnapshot userDoc =
            await _firestore.collection('user').doc(data['senderId']).get();

        UserModel user =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        // User user = User.fromSnapshot(userDoc);
        users.add(user);
      }
      return users;
    });
  }
}
