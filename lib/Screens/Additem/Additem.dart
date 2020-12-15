import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
import 'package:bhumi_app/Common/Loading/cirecularloading.dart';
import 'package:bhumi_app/Common/Widget/Appbar.dart';
import 'package:bhumi_app/Service/AdditemService.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  File _image;

  List<String> _colorList = List();

  String _productname;
  String _produid;
  int _rent;
  bool loading  = false ;
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
        body: loading ? CircularLoading(): SingleChildScrollView(
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
                                    child: _image == null ? Text('Choose Image'):Image.file(
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
                      TextFormField(

                        maxLength: 30,
                        decoration: inputdecoration.copyWith(labelText: 'Product Title '),
                        validator: (val) =>
                        val.isEmpty ? 'Enter The Product Title' : null,
                        onChanged: (val) => _productname = val,
                      ),

                      SizedBox(height: sizeboxheight,),
                      TextFormField(

                        maxLength: 10,
                        decoration: inputdecoration.copyWith(labelText: 'Product Id '),
                        validator: (val) =>
                        val.isEmpty ? 'Enter The Product Id' : null,
                        onChanged: (val) => _produid = val,
                      ),SizedBox(height: sizeboxheight,),
                      TextFormField(

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



                            if (_image == null) {
                              setState(() {
                                error = 'Choose Image';
                              });
                            }
                            else {
                                final results =  await AdditemService().additem(_productname, _produid, _rent, _image);
                              setState(() {
                                loading = true;
                              });
                             if(results ==  'exist'){
                               print('ss');
                               setState(() {
                                 error= 'Exist ProductId';
                                 loading = false;
                               });

                             }
                             else{
                              return  Navigator.pop(context);



                             }
                            }
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

