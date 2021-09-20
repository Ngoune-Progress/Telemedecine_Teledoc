import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference doctorsCollections =
    FirebaseFirestore.instance.collection('Health specialist');
CollectionReference patientsCollections =
    FirebaseFirestore.instance.collection('Patients');

CollectionReference availabilityColllection =
    FirebaseFirestore.instance.collection('Availability');

CollectionReference appointmentCollection =
    FirebaseFirestore.instance.collection('Appointment');

CollectionReference hospitalCollection =
    FirebaseFirestore.instance.collection('Hospital');
CollectionReference vaccineCollection =
    FirebaseFirestore.instance.collection('Hospital');
CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
CollectionReference rateCollection =
    FirebaseFirestore.instance.collection('Rates');

CollectionReference favoriteCollection =
    FirebaseFirestore.instance.collection('Favourite');

CollectionReference adminCollection =
    FirebaseFirestore.instance.collection('Admin');
