import 'package:bhumi_app/Common/Common.dart';
import 'package:bhumi_app/Common/Inputdecoration.dart';
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
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  String _productname;
  String _produid;
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
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

                                              content: Image.file(
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
                      TextFormField(

                        maxLength: 50,
                        decoration: inputdecoration.copyWith(labelText: 'Product Title '),
                        validator: (val) =>
                        val.isEmpty ? 'Enter The Product Title' : null,
                        onChanged: (val) => _productname = val,
                      ),

                      SizedBox(height: sizeboxheight,),
                      TextFormField(


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
                      Text(error),
                      SizedBox(height: 5,),
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
                        onPressed: (){
                          if(_formkey.currentState.validate()) {
                            if (_image == null) {
                              setState(() {
                                error = 'Choose Image';
                              });
                            }
                            else {
                              AdditemService().additem(_productname, _produid,
                                  _rent, _image);
                              Navigator.pop(context);
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

/*
* Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Text('Colour',style: TextStyle(fontWeight: FontWeight.bold),),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: (){
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        actions: [
                                                          RaisedButton(

                                                            onPressed: ()async{
                                                              setState(() =>  currentColor = pickerColor);
                                                              return Navigator.pop(context);
                                                            },
                                                            color: commonAssets.appbuttonColor,
                                                            shape: StadiumBorder(),
                                                            child: Text('Got It'),
                                                          )
                                                        ],
                                                        titlePadding: const EdgeInsets.all(0.0),
                                                        contentPadding: const EdgeInsets.all(0.0),
                                                        content: SingleChildScrollView(
                                                          child:  ColorPicker(

                                                            pickerColor: currentColor,
                                                            onColorChanged: changeColor,
                                                            colorPickerWidth: 300.0,
                                                            pickerAreaHeightPercent: 0.7,
                                                            enableAlpha: true,
                                                            displayThumbColor: true,
                                                            showLabel: true,
                                                            paletteType: PaletteType.hsv,
                                                            pickerAreaBorderRadius: const BorderRadius.only(
                                                              topLeft: const Radius.circular(2.0),
                                                              topRight: const Radius.circular(2.0),
                                                            ),
                                                          ),
                                                        ),
                                                      );

                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: width*0.5,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: currentColor,
                                                      borderRadius: BorderRadius.circular(20.0)
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Choose Color',
                                                      style: TextStyle(
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                bool colorexist = _colorList.contains(currentColor.value.toString());
                                                print(colorexist);
                                                if(colorexist == false){
                                                  _colorList.add(currentColor.value.toString());
                                                  print(_colorList);
                                                }


                                              },
                                            ),

                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/