import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/app/data/events-response.dart';
import 'package:myapp/app/modules/dashboard/views/index_view.dart';
import 'package:myapp/app/modules/dashboard/views/profile_view.dart';
import 'package:myapp/app/modules/dashboard/views/your_event_view.dart';
import 'package:myapp/app/utils/api.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  final _getConnect = GetConnect();

  final token = GetStorage().read('token');

  // Controller buat nama event, ini kayak kotak yang nyimpen teks
  TextEditingController nameController = TextEditingController();
  // Controller buat deskripsi event, tinggal ketik deskripsinya di sini
  TextEditingController descriptionController = TextEditingController();
  // Controller buat tanggal event, biar gampang atur tanggal
  TextEditingController eventDateController = TextEditingController();
  // Controller buat lokasi event, masukin alamat atau tempatnya
  TextEditingController locationController = TextEditingController();



  Future<EventResponse> getEvent() async {
    
    final response = await _getConnect.get(
      BaseUrl.events,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return EventResponse.fromJson(response.body);
  }
  
  var yourEvents = <Events>[].obs;

  Future<void> getYourEvent() async {
    
    final response = await _getConnect.get(
      BaseUrl.yourEvent,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    final eventResponse = EventResponse.fromJson(response.body);
    yourEvents.value = eventResponse.events ?? [];
  }

  // Fungsi buat tambah event, sekali klik langsung gas upload data
  void addEvent() async {
  // Kirim data ke server pake _getConnect.post, lengkap banget parameternya
  final response = await _getConnect.post(
    BaseUrl.events, // URL buat API tambah event
    {
      'name': nameController.text, // Ambil teks dari input nama
      'description': descriptionController.text, // Deskripsi event
      'event_date': eventDateController.text, // Tanggal event
      'location': locationController.text, // Lokasi event
    },
    headers: {'Authorization': "Bearer $token"}, // Header buat autentikasi, token wajib nih
    contentType: "application/json", // Formatnya JSON biar rapi
  );

  // Cek respon server, kalo sukses kode 201
  if (response.statusCode == 201) {
    // Kalau sukses, kasih notifikasi pake Get.snackbar
    Get.snackbar(
      'Success', // Judul notifikasi
      'Event Added', // Pesan sukses
      snackPosition: SnackPosition.BOTTOM, // Posisi notifikasi di bawah
      backgroundColor: Colors.green, // Warna hijau, vibes happy
      colorText: Colors.white, // Teks putih biar kontras
    );
    // Bersihin semua input, biar fresh lagi
    nameController.clear();
    descriptionController.clear();
    eventDateController.clear();
    locationController.clear();
    update(); // Update UI biar langsung kelihatan perubahan
    getEvent(); // Refresh daftar event
    getYourEvent(); // Refresh daftar event user
    Get.close(1); // Tutup halaman atau modal
  } else {
    // Kalau gagal, kasih notifikasi gagal
    Get.snackbar(
      'Failed', // Judul notifikasi
      'Event Failed to Add', // Pesan gagal
      snackPosition: SnackPosition.BOTTOM, // Posisi notifikasi di bawah
      backgroundColor: Colors.red, // Warna merah, vibes alert
      colorText: Colors.white, // Teks putih biar jelas
    );
  }
}



  

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    YourEventView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    getEvent();
    getYourEvent();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
