import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MaterialApp(
    home: RegistrationPage(),
  ));
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _userTypeController =
      TextEditingController(text: 'Customer');
  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _houseNumberController = TextEditingController();
  TextEditingController _nearByController = TextEditingController();
  TextEditingController _areaCodeController = TextEditingController();
  TextEditingController _phone2Controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  PickedFile? _imageFile;
  File? _attachedFile;

  List<String> _countryCodes = [
    '+251', // Ethiopia (using the country code)
    '+1', // United States
    '+44', // United Kingdom
    '+91', // India
    '+86', // China
    '+81', // Japan
  ];

  List<String> _ethiopianCities = [
    'Addis Ababa',
    'Dire Dawa',
    'Mekelle',
    'Gondar',
    'Bahir Dar',
    'Jimma',
    'Awasa',
    'Dessie',
    'Harar',
    'Hawassa',
  ];

  String _selectedMobileCountryCode = '+251'; // Set Ethiopia as the default
  String _selectedPhone2CountryCode = '+251'; // Set Ethiopia as the default

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _birthDateController.dispose();
    _userTypeController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _nearByController.dispose();
    _areaCodeController.dispose();
    _phone2Controller.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      setState(() {
        _attachedFile = file;
      });
    }
  }

  void _navigateToSuccessPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(),
      ),
    );
  }

  void _showCitySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select City'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _ethiopianCities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_ethiopianCities[index]),
                  onTap: () {
                    setState(() {
                      _cityController.text = _ethiopianCities[index];
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _registerUser() {
    String fullName = _fullNameController.text;
    String mobile = '$_selectedMobileCountryCode${_mobileController.text}';
    String birthDate = _birthDateController.text;
    String userType = _userTypeController.text;
    String city = _cityController.text;
    String street = _streetController.text;
    String houseNumber = _houseNumberController.text;
    String nearBy = _nearByController.text;
    String areaCode = _areaCodeController.text;
    String phone2 = '$_selectedPhone2CountryCode${_phone2Controller.text}';
    String email = _emailController.text;
    String username = _usernameController.text;

    String imagePath = _imageFile?.path ?? '';
    String attachedFilePath = _attachedFile?.path ?? '';

    // Check if any of the required fields are empty
    if (fullName.isEmpty ||
        mobile.isEmpty ||
        birthDate.isEmpty ||
        userType.isEmpty ||
        city.isEmpty ||
        street.isEmpty ||
        houseNumber.isEmpty ||
        nearBy.isEmpty ||
        areaCode.isEmpty ||
        phone2.isEmpty ||
        email.isEmpty ||
        username.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the information.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // All fields are filled, navigate to the success page
      _navigateToSuccessPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedMobileCountryCode,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedMobileCountryCode = newValue!;
                          });
                        },
                        items: _countryCodes.map((countryCode) {
                          return DropdownMenuItem<String>(
                            value: countryCode,
                            child: Text(countryCode),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Country Code',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    hintText: 'YYYY-MM-DD',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _userTypeController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'User Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _cityController,
                  onTap: () {
                    _showCitySelectionDialog();
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(
                    labelText: 'Street',
                    prefixIcon: Icon(Icons.streetview),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _houseNumberController,
                  decoration: InputDecoration(
                    labelText: 'House Number',
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _nearByController,
                  decoration: InputDecoration(
                    labelText: 'Near By',
                    prefixIcon: Icon(Icons.place),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _areaCodeController,
                  decoration: InputDecoration(
                    labelText: 'Area Code',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedPhone2CountryCode,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPhone2CountryCode = newValue!;
                          });
                        },
                        items: _countryCodes.map((countryCode) {
                          return DropdownMenuItem<String>(
                            value: countryCode,
                            child: Text(countryCode),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Country Code',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _phone2Controller,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone 2',
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.account_circle),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          SizedBox(width: 4.0),
                          Text('Select Photo'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: Row(
                        children: [
                          Icon(Icons.attach_file),
                          SizedBox(width: 4.0),
                          Text('Attach File'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                _imageFile != null
                    ? Column(
                        children: [
                          SizedBox(height: 8.0),
                          Image.file(
                            File(_imageFile!.path),
                            height: 150,
                            width: 150,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                _attachedFile != null
                    ? Column(
                        children: [
                          SizedBox(height: 8.0),
                          Text('File Attached: ${_attachedFile!.path}'),
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64.0,
              color: Colors.green,
            ),
            SizedBox(height: 16.0),
            Text(
              'You have successfully registered!',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
