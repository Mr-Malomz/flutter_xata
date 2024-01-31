import 'package:flutter/material.dart';
import 'package:flutter_xata/screens/home.dart';
import 'package:flutter_xata/utils.dart';
import 'package:flutter_xata/xata_service.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final _formKey = GlobalKey<FormState>();
  var _selected = '';
  var _dropdownItems = ["Started", "Not_Started"];
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _isError = false;

  @override
  void initState() {
    getSingleProject();
    super.initState();
  }

  getSingleProject() {
    setState(() {
      _isLoading = true;
    });

    XataService().getSingleProject(widget.id).then((value) {
      setState(() {
        _isLoading = false;
      });
      _name.text = value.name;
      _description.text = value.description;
      _selected = value.status;
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  updateProject() {
    setState(() {
      _isSubmitting = true;
    });

    Project updatedProject = Project(
      name: _name.text,
      description: _description.text,
      status: _selected,
    );

    XataService().updateProject(widget.id, updatedProject).then((value) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project updated successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }).catchError((onError) {
      setState(() {
        _isSubmitting = false;
        _isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating project!')),
      );
    });
  }

  deleteProject() {
    setState(() {
      _isSubmitting = true;
    });

    XataService().deleteProject(widget.id).then((value) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project deleted successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }).catchError((onError) {
      setState(() {
        _isSubmitting = false;
        _isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting project!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isError
            ? const Center(
                child: Text(
                  'Error getting project',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text("Details",
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Name',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input name",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                ),
                                const SizedBox(height: 30.0),
                                const Text(
                                  'Status',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                DropdownButtonFormField(
                                  value: _selected,
                                  items: _dropdownItems.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => _selected = value!);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "select status",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _description,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input ydescription';
                                    }
                                    return null;
                                  },
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input description",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      updateProject();
                                    }
                                  },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            child: const Text(
                              'Update project',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          deleteProject();
                        },
                  backgroundColor: Colors.red,
                  tooltip: 'Delete',
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              );
  }
}
