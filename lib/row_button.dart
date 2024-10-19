import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date and time formatting

class RowButton extends StatefulWidget {
  const RowButton({super.key});

  @override
  _RowButtonState createState() => _RowButtonState();
}
class _RowButtonState extends State<RowButton>{

   void _pickDateTime() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: "預計抵達日期及時間"
    );

    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          isImmediate = false; // "選擇日期與時間" is now selected
          DateTime fullDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
        });
      }
    }
  }
  
  bool isImmediate = true; // Whether "立即出發" is selected
  Color leftButtonColor = Colors.purple; // Default color for the left button ("立即出發")
  Color rightButtonColor = Colors.blue; // Default color for the right button
  String selectedDateTime = ''; // For displaying selected date and time
  @override
  Widget build(BuildContext context){
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left button - "立即出發"
                    FilledButton(
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor: Colors.white,
                      //   foregroundColor: leftButtonColor, // Text color
                      // ),
                      onPressed: () {
                        setState(() {
                          leftButtonColor = Colors.purple;
                          rightButtonColor = Colors.blue;
                          isImmediate = true; // "立即出發" is selected
                          selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            isImmediate
                                ? '立即出發'
                                : '抵達時間'
                          ),
                          const SizedBox(width: 5),
                          // const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    // Right button - Date & Time Picker
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: rightButtonColor, // Text color
                      ),
                      onPressed: () {
                        setState(() {
                          leftButtonColor = Colors.blue;
                          rightButtonColor = Colors.purple;
                        });
                        _pickDateTime();
                      },
                      child: Row(
                        children: [
                          Text(
                            isImmediate
                                ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()) // Show current time if "立即出發"
                                : (selectedDateTime.isEmpty ? '選擇日期與時間' : selectedDateTime),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                );
  }
}