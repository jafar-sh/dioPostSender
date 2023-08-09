

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Dio _dio = Dio();
  String _responseMessage = "";
  bool _isUploading=false;
  int k=1;



  Future<void> myUploadImage() async{
  
    
    try {
     if (k==1) {
       setState(() {
        _isUploading=true;
        _responseMessage="";
      });
       
     }
      
        List<String> imagePaths = [
      'assets/img/flower2.jpg',
      'assets/img/flower3.jpg',
      'assets/img/flower4.jpg',
      'assets/img/pic800.jpg',
      ];
      for (String path in imagePaths) {
        if (_isUploading) {
        
        ByteData byteData=await rootBundle.load(path);
      // ByteData byteData=await rootBundle.load('assets/img/flower2.jpg');
      List<int> bytes=byteData.buffer.asUint8List();
      FormData formData=FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes,filename: path.split('/').last),

      });
      
      Response response=await _dio.post('http://digipac.ir/shapp/flt_post_tt/test.php',data: formData);

      setState(() {
        _responseMessage='$k=>'+response.data.toString();
      });
      k++;
          
        } else {
          setState(() {
            _responseMessage='Upload canceled...';
          });
          
        }
     
      }
      _responseMessage='آپلود موفق تمام تصاویر';
    } catch (e) {
      setState(() {
        _responseMessage='Error:$e';
      });
      
    }
  }

  void cancelUpload(){
    setState(() {
      _isUploading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // await uploadImages();
                await myUploadImage();
              },
              child: const Text('Upload Images'),
            ),
            const SizedBox(height: 10),
              ElevatedButton(
              onPressed:()=>cancelUpload(),
              child: const Text('cancel Upload'),
            ),
            const SizedBox(height: 20),

            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}