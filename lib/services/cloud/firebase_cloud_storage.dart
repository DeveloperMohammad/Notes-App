import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/cloud_storage_constants.dart';
import 'package:notes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // first we create a private constructor
  FirebaseCloudStorage._sharedInstance();


  /// static final constructor guy
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  // then we create a factory constructor that's the default constructor for our class
  // and that's gonna talk with static final field that in turn calls a private initializer.
  factory FirebaseCloudStorage() => _shared;

  // talk with firestore
  final notes = FirebaseFirestore.instance.collection('notes');

  // C in CRUD
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final documentReference = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    // fetched document snapshot out of document reference
    final fetchedNote = await documentReference.get();
    // return a cloud note using document reference.
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // R in CRUD
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName == ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotCreateNoteException();
    }
  }

  // get all notes for a specific user
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
            (event) => event.docs
                .map(
                  (doc) => CloudNote.fromSnapshot(doc),
                )
                .where(
                  (note) => note.ownerUserId == ownerUserId,
                ),
          );

  // U in CRUD
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  // D in CRUD
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}
