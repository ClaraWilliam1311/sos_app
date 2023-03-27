import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/Data/Models/patient.dart';
import 'package:sos_app/Presentation/Widgets/loading_widget.dart';

import 'NotificationModel.dart';

class Doctor extends Patient {
  var field;
  var experience;
  var price;
  var addressLat;
  var addressLong;
  var bio;
  var id;
  var idImage;
  var rate;
  var verified;

  Doctor(
      {username,
      this.id,
      email,
      phoneNumber,
      password,
      age,
      gender,
      image,
      token,
      this.verified,
      this.rate,
      this.idImage,
      this.field,
      this.experience,
      this.price,
      this.addressLat,
      this.addressLong,
      this.bio})
      : super(
            username: username,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            age: age,
            gender: gender,
            image: image,
            token: token) {}

  Update_Doctor(Doctor doctor, formdata, context) async {
    if (formdata!.validate()) {
      formdata.save();
      await FirebaseFirestore.instance
          .collection("Doctors")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "FullName": doctor.username,
        "Email": doctor.email,
        'Password': doctor.password,
        "PhoneNumber": doctor.phoneNumber,
        "Age": doctor.age,
        "Field": doctor.field,
        "TicketPrice": doctor.price,
        "YearsOfExperience": doctor.experience,
        "Bio": doctor.bio,
        "Image": doctor.image,
      });
      await updateDoctorsPrefs(
          doctor.id,
          doctor.username,
          doctor.email,
          doctor.password,
          doctor.age,
          doctor.gender,
          doctor.phoneNumber,
          doctor.image,
          doctor.field,
          doctor.price,
          doctor.experience,
          doctor.bio,
          doctor.addressLat,
          doctor.addressLong,
          doctor.rate.toString(),
          doctor.verified,
          doctor.token,
          doctor.idImage);

      Navigator.pop(context, "refresh");
    } else {
      print("not valid");
    }
  }
}

updateDoctorsPrefs(id, name, email, password, age, gender, phone, image, field,
    price, experience, bio, lan, lon, rate, verified, token, idImage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.setString("Id", id);
  prefs.setString("FullName", name);
  prefs.setString("Email", email);
  prefs.setString("Password", password);
  prefs.setString("PhoneNumber", phone);
  prefs.setString("Age", age);
  prefs.setString("Gender", gender);
  prefs.setString("Image", image);
  prefs.setString("Field", field);
  prefs.setString("TicketPrice", price);
  prefs.setString("YearsOfExperience", experience);
  prefs.setString("Bio", bio);
  prefs.setString("AddressLatitude", lan);
  prefs.setString("AddressLongitude", lon);
  prefs.setString("Role", "Doctor");
  prefs.setString("Rate", rate);
  prefs.setString("Token", token);
  prefs.setInt("Verified", verified);
  prefs.setString("IdImage", idImage);
}

UpdateAddress({doctor, lat, long, context}) async {
  await FirebaseFirestore.instance.collection("Doctors").doc(doctor.id).update(
      {"AddressLatitude": lat, "AddressLongitude": long}).then((value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("AddressLatitude", lat);
    prefs.setString("AddressLongitude", long);
  });

  Navigator.pop(context, "refresh");
}

getDoctors() async {
  List<Doctor> doctors = [];
  await FirebaseFirestore.instance.collection('Doctors').get().then((value) {
    for (var i = 0; i < value.docs.length; i++) {
      Doctor dr = Doctor(
          id: value.docs[i].id,
          username: value.docs[i].data()['FullName'],
          email: value.docs[i].data()['Email'],
          phoneNumber: value.docs[i].data()['PhoneNumber'],
          password: value.docs[i].data()['Password'],
          age: value.docs[i].data()['Age'],
          gender: value.docs[i].data()['Gender'],
          image: value.docs[i].data()['Image'],
          field: value.docs[i].data()['Field'],
          addressLat: value.docs[i].data()['AddressLatitude'],
          addressLong: value.docs[i].data()['AddressLongitude'],
          bio: value.docs[i].data()['Bio'],
          experience: value.docs[i].data()['YearsOfExperience'],
          price: value.docs[i].data()['TicketPrice'],
          verified: value.docs[i].data()["Verified"],
          rate: value.docs[i].data()["Rate"],
          token: value.docs[i].data()["Token"],
          idImage: value.docs[i].data()["IdImage"]);

      doctors.insert(i, dr);
    }
  });
  return doctors;
}

UpdateDoctorToken(doctorId, token) async {
  await FirebaseFirestore.instance
      .collection("Doctors")
      .doc(doctorId)
      .update({"Token": token}).then((value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Token", token);
  });
  return "updated";
}

getDoctorsForAdmin() async {
  List<Doctor> doctors = [];
  await FirebaseFirestore.instance
      .collection('Doctors')
      .where("Verified", isEqualTo: 0)
      .get()
      .then((value) {
    for (var i = 0; i < value.docs.length; i++) {
      Doctor dr = Doctor(
        id: value.docs[i].id,
        username: value.docs[i].data()['FullName'],
        email: value.docs[i].data()['Email'],
        phoneNumber: value.docs[i].data()['PhoneNumber'],
        password: value.docs[i].data()['Password'],
        age: value.docs[i].data()['Age'],
        gender: value.docs[i].data()['Gender'],
        image: value.docs[i].data()['Image'],
        field: value.docs[i].data()['Field'],
        addressLat: value.docs[i].data()['AddressLatitude'],
        addressLong: value.docs[i].data()['AddressLongitude'],
        bio: value.docs[i].data()['Bio'],
        experience: value.docs[i].data()['YearsOfExperience'],
        price: value.docs[i].data()['TicketPrice'],
        verified: value.docs[i].data()["Verified"],
        rate: value.docs[i].data()["Rate"],
        token: value.docs[i].data()["Token"],
        idImage: value.docs[i].data()["IdImage"],
      );

      doctors.insert(i, dr);
    }
  });
  return doctors;
}

UpdateVerifiedToVerify(doctorId, token) async {
  await FirebaseFirestore.instance
      .collection("Doctors")
      .doc(doctorId)
      .update({"Verified": 1}).then((value) async {
    await SendNotifyToUser("Your account is verified", token, doctorId);
  });
  return "updated";
}

UpdateVerifiedToBlock(doctorId, token) async {
  await FirebaseFirestore.instance
      .collection("Doctors")
      .doc(doctorId)
      .update({"Verified": 2}).then((value) async {
    await SendNotifyToUser(
        "Your account is blocked, please update your ID card", token, doctorId);
  });
  return "updated";
}

UpdateDoctorIdCard(doctorId, idImage, context) async {
  await FirebaseFirestore.instance
      .collection("Doctors")
      .doc(doctorId)
      .update({"Verified": 0, "IdImage": idImage}).then((value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("Verified", 0);
  });
  Navigator.pop(context);
  return "updated";
}
