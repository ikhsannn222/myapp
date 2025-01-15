import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/app/data/detail_events_response.dart';
import 'package:myapp/app/modules/dashboard/controllers/dashboard_controller.dart';

// Halaman buat edit event, tinggal kasih ID event sama judulnya
class EditView extends GetView {
  const EditView({super.key, required this.id, required this.title});
  final int id; // ID event yang mau diedit
  final String title; // Judul event yang muncul di AppBar

  @override
  Widget build(BuildContext context) {
    // Controller buat ngatur data di dashboard
    DashboardController controller = Get.put(DashboardController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $title Event'),
        centerTitle: true,
        backgroundColor: HexColor('#feeee8'),
      ),
      backgroundColor: HexColor('#feeee8'),
      body: FutureBuilder<DetailEventResponse>(
        future: controller.getDetailEvent(id: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.network(
                'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                repeat: true,
                width: MediaQuery.of(context).size.width,
              ),
            );
          }
          if (snapshot.hasData) {
            controller.nameController.text = snapshot.data!.name ?? '';
            controller.descriptionController.text =
                snapshot.data!.description ?? '';
            controller.eventDateController.text =
                snapshot.data!.eventDate ?? '';
            controller.locationController.text = snapshot.data!.location ?? '';
          }
          return SingleChildScrollView(
            // Mengatasi overflow dengan scroll
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Lottie.network(
                      'https://gist.githubusercontent.com/olipiskandar/2095343e6b34255dcfb042166c4a3283/raw/d76e1121a2124640481edcf6e7712130304d6236/praujikom_kucing.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                  TextField(
                    autofocus: true,
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event Name',
                      hintText: 'Masukan Nama Event',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      hintText: 'Masukan Deskripsi',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.eventDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event Date',
                      hintText: 'Masukan Tanggal Event',
                    ),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        controller.eventDateController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.locationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Location',
                      hintText: 'Masukan Lokasi Event',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.editEvent(id: id);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
