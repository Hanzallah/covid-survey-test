import 'package:flutter/material.dart';

class Survey extends StatefulWidget {
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RegExp nameRegex = new RegExp(r"^[a-z ,.'-]+$");
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _effectsController = TextEditingController();
  FocusNode _focusFname = new FocusNode();
  FocusNode _focusLname = new FocusNode();
  FocusNode _focusDate = new FocusNode();
  FocusNode _focusEffects = new FocusNode();
  DateTime selectedDate = DateTime.now();

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
      body: GestureDetector(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.person),
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter your first name';
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.person),
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter your surname';
                      if (!nameRegex.hasMatch(value))
                        return 'Enter a valid surname';
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  // Birth date
                  GestureDetector(
                    onTap: () => _selectDate(context),
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
                            return "Please enter a date for your task";
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
                  // gender
                  // vaccine type
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                  if (_formKey.currentState != null &&
                      _formKey.currentState.validate())
                    ElevatedButton(
                      key: Key("submit"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF101820), // background
                        onPrimary: Color(0xFFF2AA4C), // foreground
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Submitted'),
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
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
  }
}
