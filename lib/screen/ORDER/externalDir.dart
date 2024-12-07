import 'dart:convert';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExternalDir {
  String? tempFp;
  List<FileSystemEntity> _folders = [];
//   fileRead() async {
//     String path;
//     Directory? extDir = await getExternalStorageDirectory();
//     String dirPath = '${extDir!.path}/VgFp/';
//     print("dirPath----$dirPath");
//     dirPath =
//         dirPath.replaceAll("Android/data/com.example.sqlorderapp/files/", "");
//     await Directory(dirPath).create(recursive: true);
//     final File file = File('${dirPath}/fpCode.txt');
//     print("file...$file");
//     String filpath = '$dirPath/fpCode.txt';
//     if (await File(filpath).exists()) 
//     {
//       print("existgfgf");
//       tempFp = await file.readAsString();
//       print("file exist----$tempFp");
//     } 
//     else 
//     {
//       print("file not exist----$tempFp");
//       tempFp = "";
//     }
//     print("file exist----$tempFp");
//     return tempFp;
//   }

// ///////////////////////////////////////////////////////////////////////////////////
//   fileWrite(String fp) async {
//     String path;
//     print("fpppp====$fp");
//     Directory? extDir = await getExternalStorageDirectory();
//     String dirPath = '${extDir!.path}/VgFp';
//     dirPath =
//         dirPath.replaceAll("Android/data/com.example.sqlorderapp/files/", "");
//     await Directory(dirPath).create(recursive: true);
//     // Directory? baseDir = Directory('storage/emulated/0/Android/data');
//     final File file = File('${dirPath}/fpCode.txt');
//     print("file...$file");
//     String filpath = '$dirPath/fpCode.txt';

//     if (await File(filpath).exists()) {
//       print("file exists");
//     } else {
//       await file.writeAsString(fp);
//     }
//   }

  // Read map from file
  // Future<Map<String, dynamic>?> fileRead() async {
  //   Directory? extDir = await getExternalStorageDirectory();
  //   String dirPath = '${extDir!.path}/VgFp';
  //    print("dirPath----$dirPath");
  //   dirPath = dirPath.replaceAll("Android/data/com.example.sqlorder24/files/", "");
  //   await Directory(dirPath).create(recursive: true);
  //   final File file = File('${dirPath}/dbDetails.txt');
  //    print("file...$file");
  //   if (await file.exists()) 
  //   {
  //     print("File exists, reading...");
  //     String fileContent = await file.readAsString();
  //     print("File content: $fileContent");
  //     return jsonDecode(fileContent) as Map<String, dynamic>;
  //   } 
  //   else 
  //   {
  //     print("File does not exist");
  //     return null;
  //   }
  // }
Future<Map<String, dynamic>> fileRead() async {
  Directory? extDir = await getExternalStorageDirectory();
  String dirPath = '${extDir!.path}/VgFp';
  dirPath = dirPath.replaceAll("Android/data/com.example.sqlorder24/files/", "");
  print("reading from----$dirPath");
  final File file = File('${dirPath}/dbDetails.txt');
   print("reading file----$file");
  // Check if the file exists
  if (await file.exists()) 
  {
    String jsonString = await file.readAsString(); // Read the file as a string
    Map<String, dynamic> data = jsonDecode(jsonString); // Convert JSON string back to Map
    print("File read with data: $data");
    return data;
  } 
  else
  {
    print("File does not exist");
    return {}; // Return empty map if file doesn't exist
  }
}

Future<void> deleteFile() async {
  Directory? extDir = await getExternalStorageDirectory();
  String dirPath = '${extDir!.path}/VgFp';
  dirPath = dirPath.replaceAll("Android/data/com.example.sqlorder24/files/", "");
  print("deleting from----$dirPath");
  final File file = File('${dirPath}/dbDetails.txt');
   print("deleting file----$file");
  // Check if the file exists
  if (await file.exists()) 
  {
    await file.delete(); // Delete the file
    print("File deleted successfully.");
  } 
  else 
  {
    print("File does not exist.");
  }
}

  // Write map to file
  // Future<void> fileWrite(Map<String, dynamic> data) async {
  //   Directory? extDir = await getExternalStorageDirectory();
  //   String dirPath = '${extDir!.path}/VgFp';
  //   dirPath = dirPath.replaceAll("Android/data/com.example.sqlorder24/files/", "");
  //   await Directory(dirPath).create(recursive: true);

  //   final File file = File('${dirPath}/dbDetails.txt');
  //   String jsonString = jsonEncode(data); // Convert map to JSON string
  //   await file.writeAsString(jsonString); // Write JSON string to file
  //   print("File written with data: $jsonString");
  // }
// Future<void> fileWrite(Map<String, dynamic> data) async {
//   Directory? extDir = await getExternalStorageDirectory();
//   String dirPath = '${extDir!.path}/VgFp';
//   dirPath = dirPath.replaceAll("Android/data/com.example.sqlorder24/files/", "");
//   await Directory(dirPath).create(recursive: true);

//   final File file = File('${dirPath}/dbDetails.txt');

//   // Convert the map to JSON string
//   String jsonString = jsonEncode(data);

//   // Check if file exists
//   if (await file.exists()) {
//     // File exists, overwrite its content
//     await file.writeAsString(jsonString, mode: FileMode.write);
//     print("File overwritten with data: $jsonString");
//   } else {
//     // File does not exist, create and write data
//     await file.writeAsString(jsonString);
//     print("New file created with data: $jsonString");
//   }
// }
Future<void> fileWrite(Map<String, dynamic> data) async 
{
  Directory? extDir = await getExternalStorageDirectory();
  String dirPath = '${extDir!.path}/VgFp';
  dirPath = dirPath.replaceAll("Android/data/com.example.sqlorder24/files/", "");
  await Directory(dirPath).create(recursive: true);
  print("writing to----$dirPath");
  final File file = File('${dirPath}/dbDetails.txt'); //dbDet.txt
  print("writing to file----$file");
  // Convert the map to JSON string
  String jsonString = jsonEncode(data);
  // Check if file exists and overwrite or create new
  if (await file.exists()) 
  {
    // Overwrite existing file
    await file.writeAsString(jsonString, mode: FileMode.write, flush: true);
    print("File overwritten with data: $jsonString");
  }
  else 
  {
    // Create and write new file
    await file.writeAsString(jsonString, flush: true);
    print("New file created with data: $jsonString");
  }
}


  // Update content in file
  Future<void> updateFile(String key, dynamic newValue) async {
    Map<String, dynamic>? fileData = await fileRead();
    if (fileData != null) {
      fileData[key] = newValue; // Update the map
      await fileWrite(fileData); // Write updated map back to file
      print("File updated with new value: $key -> $newValue");
    } else {
      print("File is empty or does not exist.");
    }
  }
}
