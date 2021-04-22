import 'dart:convert';

import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_patient/component/Menudetail.dart';
import 'package:flutter_patient/screen/Doctordeatil.dart';
import 'package:flutter_patient/utils/Configs.dart';
import 'package:flutter_patient/utils/api_endpoints.dart';
import 'package:flutter_patient/utils/base_main_repo.dart';
import 'package:flutter_patient/utils/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_patient/models/doctor.dart';

class Doctorlistpage extends StatefulWidget {
  Doctorlistpage();

  @override
  DoctorlistpageState createState() => DoctorlistpageState();
}

class DoctorlistpageState extends State<Doctorlistpage> {
  BaseMainRepository _baseMainRepository;

  TextEditingController searchcontroller = TextEditingController();
  bool search_flag = false;

  List<doctor> search_list = List();
  List<Widget> widgetlist = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _baseMainRepository = BaseMainRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: !Configs.menu_flag
          ? Column(
              children: [
                Container(
                  width: Configs.calcwidth(580),
                  height: Configs.calcheight(160),
                  padding: EdgeInsets.only(left: 5, right: 5, top: Configs.calcheight(6)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: Configs.calcheight(65),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/ic_gradientbg.png',
                                ),
                                fit: BoxFit.fill)),
                        padding: EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'أطباء من جميع التخصصات مستعدون لتقديم الاستشارة الطبية',
                            style: TextStyle(
                              fontSize: Configs.calcheight(25),
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        )
                      ),
                      SizedBox(
                        height: Configs.calcheight(5),
                      ),
                      Container(
                        width: double.infinity,
                        height: Configs.calcheight(80),
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          border: new Border.all(
                            color: Color(0xffEEEEEE),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                  child: TextField(
                                    controller: searchcontroller,
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        hintText: 'ابحث عن طبيب',
                                        hintStyle: TextStyle(
                                            fontSize: Configs.calcheight(25),
                                        ),
                                        contentPadding:
                                        EdgeInsets.all(0),),
                                    onChanged: (text) {
                                      if(text.length == 0){
                                        setState(() {
                                          search_flag = false;
                                        });
                                      } else{
                                        calculatesearch(text);
                                        setState(() {
                                          search_flag = true;
                                        });
                                      }
                                    },
                                    style: TextStyle(
                                        fontSize: Configs.calcheight(30)),
                                  ),
                                  width: double.infinity,
                                )
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/images/ic_search.png',
                              width: Configs
                                  .calcheight(
                                  40),
                              height: Configs
                                  .calcheight(
                                  40),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ),
                !search_flag? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Configs.umodel.menus.length,
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (context, index) {
                      return Container(
                        width: Configs.calcwidth(561),
                        height: Configs.calcheight(385),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Configs.calcheight(8))),
                            color: Gray02,
                            border: Border.all(
                                color: Colors.white,
                                width: Configs.calcheight(7))),
                        margin: EdgeInsets.all(Configs.calcheight(10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: Configs.calcwidth(166),
                                  height: Configs.calcheight(66),
                                  color: Gray04,
                                  margin: EdgeInsets.only(
                                      top: Configs.calcheight(10),
                                      left: Configs.calcwidth(12)),
                                  child: OutlineButton(
                                      color:Gray04,
                                      textColor: Black0,
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Configs.calcheight(7)),
                                      ),
                                      onPressed: () async {
                                        String response =
                                        await _baseMainRepository
                                            .patient_menulist(Configs
                                            .umodel.menus[index].id);
                                        var result = jsonDecode(response);
                                        if (result['status'] == 'success') {
                                          Map<String, dynamic> decodedJSON = {};
                                          decodedJSON = jsonDecode(response)
                                          as Map<String, dynamic>;
                                          Configs.menu_dotors = decodedJSON[
                                          'doctor'] !=
                                              null
                                              ? List.from(decodedJSON['doctor'])
                                              .map(
                                                  (e) => doctor.fromJSON(e))
                                              .toList()
                                              : [];
                                        }
                                        Configs.menu_title =
                                            Configs.umodel.menus[index].text;
                                        Configs.menu_flag = true;
                                        setState(() {});
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          Configs.umodel.menus[index].text,
                                          style: TextStyle(
                                              fontSize: Configs.calcheight(27),
                                              color: Black0),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                                Container(
                                  child: Text(
                                    'ﺍﺳﺄﻝ ﻭﺍﺳﺘﺸﺮ ﺍﻟﻄﺒﻴﺐ ﺍﻟﻤﺨﺘﺺ ﻓﻲ',
                                    style: TextStyle(
                                        fontSize: Configs.calcheight(24),
                                        color: Black0),
                                  ),
                                  padding: EdgeInsets.all(5),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            Expanded(
                                child: Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Configs.umodel.doctors.length,
                                    itemBuilder: (context, indexs) {
                                      return Container(
                                        width: Configs.umodel.menus[index].id !=
                                            Configs.umodel.doctors[indexs]
                                                .menulist_id
                                            ? 0
                                            : Configs.calcwidth(190),
                                        height: Configs.calcheight(300),
                                        padding: EdgeInsets.only(
                                            right: Configs.calcwidth(12),
                                            left: Configs.calcwidth(12)),
                                        child: Container(
                                            height: Configs.calcheight(300),
                                            width: Configs.calcwidth(166),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    top: Configs.calcheight(60),
                                                    child: Material(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Configs.con_doctor1 = Configs.umodel.doctors[indexs];
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Doctordetail(
                                                                          )));
                                                        },
                                                        child: Container(
                                                          width: Configs.calcwidth(
                                                              166),
                                                          height:
                                                          Configs.calcheight(
                                                              215),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .all(Radius.circular(
                                                                Configs
                                                                    .calcheight(
                                                                    7))),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xff000000)
                                                                    .withOpacity(
                                                                    0.1),
                                                                offset: Offset(
                                                                    0,
                                                                    Configs
                                                                        .calcheight(
                                                                        3)),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child: Flag(
                                                                    getcountryid(Configs
                                                                        .umodel
                                                                        .doctors[
                                                                    indexs]
                                                                        .country_id),
                                                                    height: Configs
                                                                        .calcheight(
                                                                        30),
                                                                    width: Configs
                                                                        .calcheight(
                                                                        45),
                                                                    fit: BoxFit
                                                                        .fill),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Container(
                                                                    margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                      top: Configs
                                                                          .calcheight(
                                                                          60),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text(
                                                                          Configs
                                                                              .umodel
                                                                              .doctors[
                                                                          indexs]
                                                                              .fname +
                                                                              ' ' +
                                                                              Configs
                                                                                  .umodel
                                                                                  .doctors[indexs]
                                                                                  .lname +
                                                                              ' ',
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Configs.calcheight(18),
                                                                            color:
                                                                            Black02,
                                                                          ),
                                                                          maxLines:
                                                                          1,
                                                                        ),
                                                                        Text(
                                                                          ' .د ',
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Configs.calcheight(18),
                                                                            color:
                                                                            Black02,
                                                                          ),
                                                                        ),
                                                                        Image.asset(
                                                                          'assets/images/ic_bright.png',
                                                                          width: Configs
                                                                              .calcheight(
                                                                              20),
                                                                          height: Configs
                                                                              .calcheight(
                                                                              20),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: Configs
                                                                            .calcheight(
                                                                            5)),
                                                                    child: Text(
                                                                      Configs
                                                                          .umodel
                                                                          .doctors[
                                                                      indexs]
                                                                          .text,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          Configs.calcheight(
                                                                              14),
                                                                          color:
                                                                          Black02),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: Configs
                                                                            .calcheight(
                                                                            5)),
                                                                    child: Text(
                                                                      Configs
                                                                          .umodel
                                                                          .doctors[
                                                                      indexs]
                                                                          .degree,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          Configs.calcheight(
                                                                              14),
                                                                          color:
                                                                          Black02),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: Configs
                                                                        .calcwidth(
                                                                        152),
                                                                    height: Configs
                                                                        .calcheight(
                                                                        41),
                                                                    margin: EdgeInsets.only(
                                                                        top: Configs
                                                                            .calcheight(
                                                                            15)),
                                                                    child:
                                                                    FlatButton(
                                                                      color: Blue03,
                                                                      textColor:
                                                                      textColor,
                                                                      padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                          0),
                                                                      shape:
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            Configs.calcheight(11)),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Configs.con_doctor1 = Configs.umodel.doctors[indexs];
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                    Doctordetail()));
                                                                      },
                                                                      child: Text(
                                                                        'ﻃﻠﺐ ﺍﺳﺘﺸﺎﺭﺓ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            Configs.calcheight(
                                                                                14),
                                                                            color: Colors
                                                                                .white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      elevation: 10,
                                                    )),
                                                Container(
                                                    width: double.infinity,
                                                    alignment: Alignment.topCenter,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          child: Material(
                                                            child: Container(
                                                              width: Configs
                                                                  .calcheight(102),
                                                              height: Configs
                                                                  .calcheight(102),
                                                              decoration: new BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: new DecorationImage(
                                                                      fit: BoxFit.cover,
                                                                      image: new NetworkImage(
                                                                        APIEndPoints
                                                                            .mediaurl +
                                                                            Configs
                                                                                .umodel
                                                                                .doctors[indexs]
                                                                                .photo,
                                                                      ))),
                                                            ),
                                                            elevation: 10,
                                                            shape: CircleBorder(),
                                                          ),
                                                          padding: EdgeInsets.only(
                                                              top: Configs
                                                                  .calcheight(8)),
                                                        ),
                                                        Positioned(
                                                          top:
                                                          Configs.calcheight(8),
                                                          child: Container(
                                                            decoration:
                                                            new BoxDecoration(
                                                              color: Colors.white,
                                                              shape:
                                                              BoxShape.circle,
                                                            ),
                                                            width:
                                                            Configs.calcheight(
                                                                20),
                                                            height:
                                                            Configs.calcheight(
                                                                20),
                                                            child: Icon(
                                                              Icons.brightness_1,
                                                              color: Configs
                                                                  .umodel
                                                                  .doctors[
                                                              indexs]
                                                                  .active_state ==
                                                                  1
                                                                  ? Green01
                                                                  : Gray04,
                                                              size: Configs
                                                                  .calcheight(20),
                                                            ),
                                                          ),
                                                          left:
                                                          Configs.calcwidth(4),
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      bottom: Configs.calcheight(5)),
                                ))
                          ],
                        ),
                      );
                    },
                  ),
                ):
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Configs.calcheight(8))),
                            color: Gray02,
                            border: Border.all(
                                color: Colors.white,
                                width: Configs.calcheight(7))),
                        child: ListView(
                          children: widgetlist.map((element) {
                            return element;
                          }).toList(),
                        ),
                      ),
                    )
              ],
            )
          : Menudetail(),
    );
  }

  String getcountryid(int countryid) {
    String country_id = '';
    for (int i = 0; i < Configs.umodel.countries.length; i++) {
      if (countryid == Configs.umodel.countries[i].id) {
        switch (Configs.umodel.countries[i].text) {
          case 'السويد':
            country_id = 'SE';
            break;
          case 'العراق':
            country_id = 'IQ';
            break;
          case 'المانيا':
            country_id = 'DE';
            break;
          case 'ايرلندا':
            country_id = 'IE';
            break;
          case 'بريطانيا':
            country_id = 'GB';
            break;
          case 'هولندا':
            country_id = 'NL';
            break;
        }
      }
    }
    return country_id;
  }

  void calculatesearch(String text) {
    search_list = List();
    widgetlist = List();
    for(int i = 0; i < Configs.umodel.doctors.length; i++){
      String t_name =  Configs.umodel.doctors[i].fname + ' ' + Configs.umodel.doctors[i].lname;
      print('he');
      print(text);
      print(Configs.umodel.doctors[i].fname);
      print(t_name.toLowerCase().contains(text.toLowerCase()) || Configs.umodel.doctors[i].fname.toLowerCase().contains(text.toLowerCase()) || Configs.umodel.doctors[i].lname.toLowerCase().contains(text.toLowerCase()) || t_name == text || Configs.umodel.doctors[i].lname == text || Configs.umodel.doctors[i].fname == text);
      if(t_name.toLowerCase().contains(text.toLowerCase()) || Configs.umodel.doctors[i].fname.toLowerCase().contains(text.toLowerCase()) || Configs.umodel.doctors[i].lname.toLowerCase().contains(text.toLowerCase()) || t_name == text || Configs.umodel.doctors[i].lname == text || Configs.umodel.doctors[i].fname == text){
        search_list.add(Configs.umodel.doctors[i]);
        setState(() {

        });
      }
    }
    for(int i = 0; i < (search_list.length / 3).round() + 1; i+= 3 ){
      widgetlist.add(Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getdoctoritem(i*3),
            getdoctoritem(i*3 + 1),
            getdoctoritem(i*3 + 2)
          ],
        )
      ));
    }
    setState(() {

    });
  }
  Widget getdoctoritem(int d_index){
    if(d_index >= search_list.length){
      return Container(
        width: Configs.calcwidth(190),
        height: Configs.calcheight(300),
      );
    }
    return Container(
      width: Configs.calcwidth(190),
      height: Configs.calcheight(300),
      padding: EdgeInsets.only(
          right: Configs.calcwidth(12),
          left: Configs.calcwidth(12)),
      child: Container(
          height: Configs.calcheight(300),
          width: Configs.calcwidth(166),
          child: Stack(
            children: [
              Positioned(
                  top: Configs.calcheight(60),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Configs.con_doctor1 = search_list[d_index];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Doctordetail(
                                    )));
                      },
                      child: Container(
                        width: Configs.calcwidth(
                            166),
                        height:
                        Configs.calcheight(
                            215),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius
                              .all(Radius.circular(
                              Configs
                                  .calcheight(
                                  7))),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(
                                  0xff000000)
                                  .withOpacity(
                                  0.1),
                              offset: Offset(
                                  0,
                                  Configs
                                      .calcheight(
                                      3)),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Flag(
                                  getcountryid(search_list[d_index]
                                      .country_id),
                                  height: Configs
                                      .calcheight(
                                      30),
                                  width: Configs
                                      .calcheight(
                                      45),
                                  fit: BoxFit
                                      .fill),
                            ),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Container(
                                  margin:
                                  EdgeInsets
                                      .only(
                                    top: Configs
                                        .calcheight(
                                        60),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Container(
                                        child:  Text(
                                          search_list[d_index]
                                              .fname +
                                              ' ' +
                                              search_list[d_index].lname +
                                              ' ',
                                          style:
                                          TextStyle(
                                            fontSize:
                                            Configs.calcheight(18),
                                            color:
                                            Black02,
                                          ),
                                          maxLines:
                                          1,
                                        ),
                                      ),
                                      Text(
                                        ' .د ',
                                        style:
                                        TextStyle(
                                          fontSize:
                                          Configs.calcheight(18),
                                          color:
                                          Black02,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/ic_bright.png',
                                        width: Configs
                                            .calcheight(
                                            20),
                                        height: Configs
                                            .calcheight(
                                            20),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Configs
                                          .calcheight(
                                          5)),
                                  child: Text(
                                    search_list[d_index]
                                        .text,
                                    style: TextStyle(
                                        fontSize:
                                        Configs.calcheight(
                                            14),
                                        color:
                                        Black02),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Configs
                                          .calcheight(
                                          5)),
                                  child: Text(
                                    search_list[d_index]
                                        .degree,
                                    style: TextStyle(
                                        fontSize:
                                        Configs.calcheight(
                                            14),
                                        color:
                                        Black02),
                                  ),
                                ),
                                Container(
                                  width: Configs
                                      .calcwidth(
                                      152),
                                  height: Configs
                                      .calcheight(
                                      41),
                                  margin: EdgeInsets.only(
                                      top: Configs
                                          .calcheight(
                                          15)),
                                  child:
                                  FlatButton(
                                    color: Blue03,
                                    textColor:
                                    textColor,
                                    padding:
                                    EdgeInsets
                                        .all(
                                        0),
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Configs.calcheight(11)),
                                    ),
                                    onPressed:
                                        () {
                                      Configs.con_doctor1 = search_list[d_index];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Doctordetail()));
                                    },
                                    child: Text(
                                      'ﻃﻠﺐ ﺍﺳﺘﺸﺎﺭﺓ',
                                      style: TextStyle(
                                          fontSize:
                                          Configs.calcheight(
                                              14),
                                          color: Colors
                                              .white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    elevation: 10,
                  )),
              Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Container(
                        child: Material(
                          child: Container(
                            width: Configs
                                .calcheight(102),
                            height: Configs
                                .calcheight(102),
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(
                                      APIEndPoints
                                          .mediaurl +
                                          search_list[d_index]
                                              .photo,
                                    ))),
                          ),
                          elevation: 10,
                          shape: CircleBorder(),
                        ),
                        padding: EdgeInsets.only(
                            top: Configs
                                .calcheight(8)),
                      ),
                      Positioned(
                        top:
                        Configs.calcheight(8),
                        child: Container(
                          decoration:
                          new BoxDecoration(
                            color: Colors.white,
                            shape:
                            BoxShape.circle,
                          ),
                          width:
                          Configs.calcheight(
                              20),
                          height:
                          Configs.calcheight(
                              20),
                          child: Icon(
                            Icons.brightness_1,
                            color: search_list[d_index]
                                .active_state ==
                                1
                                ? Green01
                                : Gray04,
                            size: Configs
                                .calcheight(20),
                          ),
                        ),
                        left:
                        Configs.calcwidth(4),
                      )
                    ],
                  )),
            ],
          )),
    );
  }
}
