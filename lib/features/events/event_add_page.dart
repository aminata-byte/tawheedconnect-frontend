import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class EventAddPage extends StatefulWidget {
  const EventAddPage({Key? key}) : super(key: key);

  @override
  State<EventAddPage> createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _speakersController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TimeOfDay? _selectedEndTime;
  String? _imagePath;
  bool _notifyMembers = true;
  bool _reminder24h = true;
  bool _reminder1h = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _speakersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedEndTime = picked);
    }
  }

  void _pickImage() {
    // TODO: Implémenter la sélection d'image avec image_picker
    setState(() {
      _imagePath = "image_placeholder.jpg"; // Simulation
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image sélectionnée avec succès")),
    );
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez sélectionner une date")),
        );
        return;
      }
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez sélectionner une heure")),
        );
        return;
      }

      // TODO: Sauvegarder l'événement
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Événement publié avec succès")),
      );
      Navigator.pop(context);
    }
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("📝 Brouillon enregistré")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Créer un Événement"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("📸 MÉDIA"),
              const SizedBox(height: 12),
              _buildImagePicker(),

              const SizedBox(height: 24),
              _buildSectionTitle("📝 INFORMATIONS GÉNÉRALES"),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _titleController,
                label: "Titre de l'événement",
                hint: "Ex: Conférence sur le Tawhid",
                icon: Icons.title,
                validator: (v) => v!.isEmpty ? "Titre requis" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                hint: "Décrivez votre événement...",
                icon: Icons.description,
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Description requise" : null,
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("📅 DATE ET HEURE"),
              const SizedBox(height: 12),

              _buildDateTimeSelector(),

              const SizedBox(height: 24),
              _buildSectionTitle("📍 LIEU"),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _locationController,
                label: "Adresse",
                hint: "Grande Mosquée, Dakar",
                icon: Icons.location_on,
                validator: (v) => v!.isEmpty ? "Lieu requis" : null,
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Ouvrir la carte pour sélectionner le lieu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("📍 Choisir sur la carte")),
                  );
                },
                icon: const Icon(Icons.map),
                label: const Text("Choisir sur la carte"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("👨‍🏫 INTERVENANTS / ANIMATEURS"),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _speakersController,
                label: "Nom des intervenants",
                hint: "Ex: Oustaze Cheikh Omar, Imam Diop",
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? "Au moins un intervenant requis" : null,
              ),
              const SizedBox(height: 8),
              const Text(
                "💡 Séparez les noms par des virgules",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("🔔 NOTIFICATIONS"),
              const SizedBox(height: 12),

              _buildNotificationSettings(),

              const SizedBox(height: 30),

              // Boutons d'action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "✅ PUBLIER L'ÉVÉNEMENT",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _saveDraft,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Enregistrer comme brouillon"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: _imagePath == null ? Colors.grey[200] : Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _imagePath == null ? Colors.grey[400]! : Colors.green,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _imagePath == null ? Icons.add_photo_alternate : Icons.check_circle,
                size: 60,
                color: _imagePath == null ? Colors.grey[600] : Colors.green,
              ),
              const SizedBox(height: 12),
              Text(
                _imagePath == null ? "📷 Ajouter une image" : "✅ Image ajoutée",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _imagePath == null ? Colors.grey[700] : Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _imagePath == null ? "ou une bannière" : "Toucher pour changer",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelector() {
    return Column(
      children: [
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "📆 Sélectionner la date..."
                        : "📅 ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    style: TextStyle(
                      color: _selectedDate == null ? Colors.grey : Colors.black,
                      fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTime == null
                            ? "Début"
                            : "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: _selectedTime == null ? Colors.grey : Colors.black,
                          fontWeight: _selectedTime == null ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: _selectEndTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_filled, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        _selectedEndTime == null
                            ? "Fin"
                            : "${_selectedEndTime!.hour}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: _selectedEndTime == null ? Colors.grey : Colors.black,
                          fontWeight: _selectedEndTime == null ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            value: _notifyMembers,
            onChanged: (val) => setState(() => _notifyMembers = val ?? true),
            title: const Text("Notifier tous les membres"),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
          ),
          CheckboxListTile(
            value: _reminder24h,
            onChanged: (val) => setState(() => _reminder24h = val ?? true),
            title: const Text("Rappel 24h avant"),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
          ),
          CheckboxListTile(
            value: _reminder1h,
            onChanged: (val) => setState(() => _reminder1h = val ?? true),
            title: const Text("Rappel 1h avant"),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}