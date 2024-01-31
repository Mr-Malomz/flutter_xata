import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_xata/utils.dart';

class XataService {
  final _dio = Dio();
  static String _apiKey = dotenv.get("XATA_API_KEY");
  static String _baseURL = dotenv.get("XATA_DATABASE_URL");

  final _headers = {
    "content-type": "application/json",
    "AUTHORIZATION": "Bearer $_apiKey",
  };

  Future<List<Project>> getProjects() async {
    var response = await _dio.post(
      "$_baseURL:main/tables/Project/query",
      options: Options(headers: _headers),
    );

    if (response.statusCode == 200) {
      var respList = response.data['records'] as List;
      var projectList = respList.map((json) => Project.fromJson(json)).toList();
      return projectList;
    } else {
      throw Exception('Error getting projects');
    }
  }

  Future<Project> getSingleProject(String id) async {
    var response = await _dio.get(
      "$_baseURL:main/tables/Project/data/$id",
      options: Options(headers: _headers),
    );

    if (response.statusCode == 200) {
      var resp = response.data;
      var project = Project.fromJson(resp);
      return project;
    } else {
      throw Exception('Error getting project');
    }
  }

  Future createProject(Project newProject) async {
    var response = await _dio.post(
      "$_baseURL:main/tables/Project/data",
      options: Options(headers: _headers),
      data: newProject.toJson(),
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Error creating project');
    }
  }

  Future updateProject(String id, Project updatedProject) async {
    var response = await _dio.put(
      "$_baseURL:main/tables/Project/data/$id",
      options: Options(headers: _headers),
      data: updatedProject.toJson(),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error updating project');
    }
  }

  Future deleteProject(String id) async {
    var response = await _dio.delete(
      "$_baseURL:main/tables/Project/data/$id",
      options: Options(headers: _headers),
    );

    if (response.statusCode == 204) {
      return response.data;
    } else {
      throw Exception('Error deleting project');
    }
  }
}
