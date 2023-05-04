import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'Help Desk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to the Goa Police eBeat Help Desk',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'If you have any concerns, questions or complaints related to the Goa Police eBeat app or its services, please feel free to reach out to us using the following methods:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '- You can email us at jovidsilva6@gmail.com with subject line "Ebeat-Goa Help". We will respond to your email as soon as possible.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '- You can also call our helpline at +91 8459839467 for any emergency assistance or to report a crime.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Thank you for using the Goa Police eBeat app. We are committed to providing you with the best possible service.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: 'jovidsilva6@gmail.com',
                        query:
                            'subject=Ebeat-Goa Help&body=Hi, I am a police officer who wants to report the following:',
                      );
                      launch(params.toString());
                    },
                    icon: Icon(Icons.email, color: Colors.white),
                    label: Text(
                      'jovidsilva6@gmail.com',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'If you need immediate assistance or want to report a crime, please call our helpline:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      String phoneNumber = '+918459839467';
                      launch("tel:" + phoneNumber);
                    },
                    icon: Icon(Icons.phone, color: Colors.white),
                    label: Text(
                      '+91 8459839467',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
