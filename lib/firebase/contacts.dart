import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_revamp/firebase/chats.dart' as chats;

class Contacts {
  static final _db = FirebaseFirestore.instance;

  static Future<QuerySnapshot<Map<String, dynamic>>> getContactFromEmail(
      String email) async {
    return await _db.collection('users').where('email', isEqualTo: email).get();
  }
  static Future<DocumentSnapshot<Map<String, dynamic>>> getContactFromId(
      String id) async {
    return await _db.collection('users').doc(id).get();
  }

  static Future<bool> addContact(String email) async {
    final contact = await Contacts.getContactFromEmail(email); //get contact reference
    if (contact.docs.isEmpty) return false;
    final contactId = contact.docs.first.id; // get contact id
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (uid == contactId) {//i cant add my self as a contact
      return true;
    }
    DocumentReference mydocRef = _db.collection('users').doc(uid);
    DocumentReference contactdocRef = _db.collection('users').doc(contactId);
    DocumentSnapshot requestsSnapshot = await mydocRef
        .collection('requests')
        .doc(contactId)
        .get(); //get the request from my requests
    if (requestsSnapshot.exists) {
      //if account already requested accept request
      acceptRequest(contactId);
      return true;
    }
    DocumentSnapshot contactSnapshot = await mydocRef
        .collection('contacts')
        .doc(contactId)
        .get(); //check if already account is added
    DocumentSnapshot requestedSnapshot = await mydocRef
        .collection('requested')
        .doc(contactId)
        .get(); //check if already requested

    if (contactSnapshot.exists || requestedSnapshot.exists) {
      return false;
    }
    //add contact to requested list and add my self to his requests one
    final contactData = await _db.collection('users').doc(contactId).get();
    final myData = await _db.collection('users').doc(uid).get();

    await mydocRef
        .collection('requested')
        .doc(contactId)
        .set(contactData.data()!);

    await contactdocRef.collection('requests').doc(uid).set(myData.data()!);
    return true;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getContacts() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('contacts').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRequests() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('requests').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRequested() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('requested').snapshots();
  }

  static Future<String> getContactName(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    return doc.data()!['username'];
  }

  static acceptRequest(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid; //get my id

    final chatId = await chats.Chats
        .createChat(); //create chat and insert its is before adding to contacts

    DocumentReference mydocRef =
        _db.collection('users').doc(uid); //refereence to my doc
    DocumentReference contactdocRef = _db
        .collection('users')
        .doc(id); //reference to contact that requested doc
    final contactDocs = await mydocRef
        .collection('requests')
        .doc(id)
        .get(); //get data from my requests
    final contactData = contactDocs.data();
    final myDocs = await contactdocRef
        .collection('requested')
        .doc(uid)
        .get(); //get data from contact requested
    final myData = myDocs.data();
    mydocRef.collection('requests').doc(id).delete(); //delete from my requests
    contactdocRef
        .collection('requested')
        .doc(uid)
        .delete(); //delete from his requested
    myData!['chatId'] = chatId;
    contactData!['chatId'] = chatId;
    mydocRef
        .collection('contacts')
        .doc(id)
        .set(contactData); //add to my contacts
    contactdocRef
        .collection('contacts')
        .doc(uid)
        .set(myData); //add to his contacts
  }


}
