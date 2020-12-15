import 'package:cloud_firestore/cloud_firestore.dart';

class ItemHistoryModel{
  String cus_name;
  String cus_number;
  String cus_address;
  String prodcutid;
  int advanced ;
  int discount;
  int netrent;
  int extracharge;
  int rentold;
  Timestamp bookingdate;
  bool compeleteorder;
  String orderIDtrack;
  List<String> datelist;

  ItemHistoryModel({
  this.cus_name,
  this.cus_number,
  this.cus_address,
  this.prodcutid,
  this.advanced,
  this.discount,
  this.netrent,
  this.datelist,
    this.extracharge,
    this.rentold,
    this.bookingdate,
    this.compeleteorder,
    this.orderIDtrack,

  });

}