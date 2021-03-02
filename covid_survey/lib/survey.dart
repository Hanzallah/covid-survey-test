import 'package:connectivity/connectivity.dart';
import 'package:covid_survey/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Survey extends StatefulWidget {
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RegExp nameRegex = new RegExp(r"^[A-Za-zİĞÜŞÖÇğüşöç ,.'-]+$");
  List<String> citiesList;
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _effectsController = TextEditingController();
  FocusNode _focusFname = new FocusNode();
  FocusNode _focusLname = new FocusNode();
  FocusNode _focusDate = new FocusNode();
  FocusNode _focusEffects = new FocusNode();
  DateTime selectedDate = DateTime.now();
  String _chosenGender;
  String _chosenCity;
  String _chosenVaccine;
  var subscription;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isOnline = true;
        });
      } else {
        setState(() {
          isOnline = false;
        });
      }
    });
    citiesList = jsonCities.map<String>((e) => e['name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Appium App Testing",
          style: TextStyle(
            color: Color(0xFFF2AA4C),
          ),
        ),
        backgroundColor: Color(0xFF101820),
        elevation: 0,
      ),
      body: isOnline
          ? GestureDetector(
              onTap: () {
                if (_focusFname.hasFocus) _focusFname.unfocus();
                if (_focusLname.hasFocus) _focusLname.unfocus();
                if (_focusDate.hasFocus) _focusDate.unfocus();
                if (_focusEffects.hasFocus) _focusEffects.unfocus();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // title
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: RichText(
                            text: TextSpan(
                              text: "Covid-19 Survey\n",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF101820),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        // First name
                        TextFormField(
                          key: Key("fname"),
                          controller: _fNameController,
                          keyboardType: TextInputType.name,
                          focusNode: _focusFname,
                          maxLength: 20,
                          maxLines: 1,
                          onChanged: (val) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: "First Name",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            prefixIcon: Icon(Icons.person),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter your first name';
                            if (!nameRegex.hasMatch(value))
                              return 'Enter a valid first name';
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        // Surname
                        TextFormField(
                          key: Key("lname"),
                          controller: _lNameController,
                          keyboardType: TextInputType.name,
                          focusNode: _focusLname,
                          maxLength: 20,
                          maxLines: 1,
                          onChanged: (val) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: "Surname",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            prefixIcon: Icon(Icons.person),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter your surname';
                            if (!nameRegex.hasMatch(value))
                              return 'Enter a valid surname';
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        // Birth date
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                            if (_focusFname.hasFocus) _focusFname.unfocus();
                            if (_focusLname.hasFocus) _focusLname.unfocus();
                            if (_focusEffects.hasFocus) _focusEffects.unfocus();
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              key: Key("dateField"),
                              controller: _dateController,
                              keyboardType: TextInputType.datetime,
                              focusNode: _focusDate,
                              onChanged: (val) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: "Birth Date",
                                prefixIcon: Icon(Icons.calendar_today),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Please enter your birth date";
                                if (selectedDate.year < 1950 ||
                                    selectedDate.year > DateTime.now().year)
                                  return "Year should be between 1950 and ${DateTime.now().year}";
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        // city
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            key: Key("cityDropdown"),
                            decoration: InputDecoration(
                              labelText: "City",
                              prefixIcon: Icon(Icons.location_city),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            focusColor: Color(0xFFF2AA4C),
                            value: _chosenCity,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: citiesList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onTap: () {
                              if (_focusFname.hasFocus) _focusFname.unfocus();
                              if (_focusLname.hasFocus) _focusLname.unfocus();
                              if (_focusEffects.hasFocus)
                                _focusEffects.unfocus();
                            },
                            onChanged: (String value) {
                              setState(() {
                                _chosenCity = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        // gender
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            key: Key("genderDropdown"),
                            decoration: InputDecoration(
                              labelText: "Gender",
                              prefixIcon: Icon(Icons.wc),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            focusColor: Color(0xFFF2AA4C),
                            value: _chosenGender,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: genders
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onTap: () {
                              if (_focusFname.hasFocus) _focusFname.unfocus();
                              if (_focusLname.hasFocus) _focusLname.unfocus();
                              if (_focusEffects.hasFocus)
                                _focusEffects.unfocus();
                            },
                            onChanged: (String value) {
                              setState(() {
                                _chosenGender = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        // vaccine type
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            key: Key("vaccineDropdown"),
                            decoration: InputDecoration(
                              labelText: "Vaccine Type",
                              prefixIcon: Icon(Icons.medical_services),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            focusColor: Color(0xFFF2AA4C),
                            value: _chosenVaccine,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: vaccines
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onTap: () {
                              if (_focusFname.hasFocus) _focusFname.unfocus();
                              if (_focusLname.hasFocus) _focusLname.unfocus();
                              if (_focusEffects.hasFocus)
                                _focusEffects.unfocus();
                            },
                            onChanged: (String value) {
                              setState(() {
                                _chosenVaccine = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        // side effects
                        TextFormField(
                          key: Key("sideEffects"),
                          controller: _effectsController,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          onChanged: (val) {
                            setState(() {});
                          },
                          focusNode: _focusEffects,
                          decoration: InputDecoration(
                            labelText: "Side Effects",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            prefixIcon: Icon(Icons.sick),
                          ),
                          validator: (value) {
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        // submit
                        if (_chosenGender != null &&
                            _chosenCity != null &&
                            _chosenVaccine != null &&
                            _formKey.currentState != null &&
                            _formKey.currentState.validate())
                          ElevatedButton(
                            key: Key("submit"),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF101820), // background
                              onPrimary: Color(0xFFF2AA4C), // foreground
                            ),
                            onPressed: () {
                              Toast.show("Submitted", context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM);
                              // dispose the connection subscriber
                              dispose();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Survey(),
                                ),
                              );
                            },
                            child: Text('Submit'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              child: Center(
                child: RichText(
                  key: Key("networkError"),
                  text: TextSpan(
                    text: "Please check your network connection\n",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF101820),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF101820),
              onPrimary: Color(0xFFF2AA4C),
              surface: Color(0xFF101820),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
    _fNameController.dispose();
    _lNameController.dispose();
    _dateController.dispose();
    _effectsController.dispose();
    _focusFname.dispose();
    _focusLname.dispose();
    _focusDate.dispose();
    _focusEffects.dispose();
  }
}
