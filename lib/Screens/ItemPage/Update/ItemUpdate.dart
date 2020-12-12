import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Service/AdditemService.dart';
import 'package:bhumi_app/Service/ItemService.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
class ItemUpdate extends StatefulWidget {
  int rent;
  String itemid;
  String oldimageurl;
  String productname;

  ItemUpdate({this.rent,this.oldimageurl,this.itemid,this.productname,});
  @override
  _ItemUpdateState createState() => _ItemUpdateState();
}

class _ItemUpdateState extends State<ItemUpdate> {
  File _image;


  int _rent;
  String error = '';
  final _formkey = GlobalKey<FormState>();
  double sizeboxheight = 15.0;
  double sizeboxwidth = 10.0;

  Color containerColor = Colors.white;

  getImage(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
      source: source,
    );


    setState(() {
      _image = File(image.path);


    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: BasicAppbar(),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SingleChildScrollView(
                              child: Card(
                                child: Container(

                                  height: 250,
                                  decoration: BoxDecoration(
                                      color: containerColor,
                                      border: Border(
                                        top: BorderSide(color: Colors.black,width: 0.1),
                                        bottom: BorderSide(color: Colors.black,width: 0.1),
                                        right: BorderSide(color: Colors.black,width: 0.1),
                                        left: BorderSide(color: Colors.black,width: 0.1),
                                      )
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      return showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(

                                              content:_image == null?Text('Select The Image'): Image.file(
                                                _image,
                                                width:100,
                                              ),
                                              actions: [
                                                IconButton(
                                                  icon:Icon(Icons.forward),
                                                  onPressed: (){

                                                    setState(() {


                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                )
                                              ],
                                            );


                                          }
                                      );
                                    },
                                    child: _image == null ? Image.network(widget.oldimageurl,fit: BoxFit.cover,):Image.file(
                                      _image,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  RaisedButton(
                                    shape: StadiumBorder(),
                                    color: commonAssets.appbuttonColor,
                                    onPressed: () => getImage(ImageSource.camera),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                  RaisedButton(
                                    shape: StadiumBorder(),
                                    color: commonAssets.appbuttonColor,
                                    onPressed: () => getImage(ImageSource.gallery),
                                    child: Icon(
                                      Icons.photo_size_select_actual,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      SizedBox(height: sizeboxheight,),
                      Text(error,style: TextStyle(
                        color: Colors.red,

                      ),),
                      SizedBox(height: sizeboxheight,),
                      SizedBox(height: sizeboxheight,),
                      TextFormField(
                  initialValue: widget.rent.toString(),
                        keyboardType: TextInputType.number,
                        decoration: inputdecoration.copyWith(labelText: 'Rent '),
                        validator: numbervalidtion,
                        onChanged: (val) => _rent = int.parse(val),
                      ),




                      SizedBox(height: sizeboxheight,),

                      RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal:width *0.09,vertical: height*0.02),
                        shape: StadiumBorder(),
                        child: Text(
                          'Upload',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),

                        color: commonAssets.appbuttonColor,
                        onPressed: ()async{
                          if(_formkey.currentState.validate()) {




                              ItemService(itemname: widget.itemid).updateitem(widget.oldimageurl, _rent ??widget.rent , widget.productname, _image);
                             Navigator.pop(context);

                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter The Number Only';
    } else {
      return null;
    }
  }
}

