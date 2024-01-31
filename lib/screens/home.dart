import 'package:flutter/material.dart';
import 'package:flutter_xata/screens/create.dart';
import 'package:flutter_xata/screens/detail.dart';
import 'package:flutter_xata/utils.dart'; 
import 'package:flutter_xata/xata_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Project> projects;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    getProjects();
    super.initState();
  }

  getProjects() {
    setState(() {
      _isLoading = true;
    });

    XataService().getProjects().then((value) {
      setState(() {
        projects = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
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
                  'Error getting projects',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Projects',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.black,
                ),
                body: ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Detail(id: projects[index].id as String),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    projects[index].name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Icon(projects[index].status == "Started"
                                          ? Icons.start
                                          : Icons.stop_circle_outlined),
                                      const SizedBox(width: 5.0),
                                      Text(projects[index].status)
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(projects[index].description)
                                ],
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 10.0),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Create(),
                      ),
                    );
                  },
                  backgroundColor: Colors.black,
                  tooltip: 'Create project',
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              );
  }
}
