import 'package:flutter/material.dart';
import 'dart:io';
import '../../../core/constants/colors.dart';
import '../../../core/data/app_data.dart';

class PublishQuestPage extends StatefulWidget {
  final String associationName;
  final Map<String, dynamic>? urgentRequest;

  const PublishQuestPage({
    Key? key,
    required this.associationName,
    this.urgentRequest,
  }) : super(key: key);

  @override
  State<PublishQuestPage> createState() => _PublishQuestPageState();
}

class _PublishQuestPageState extends State<PublishQuestPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _currentAmountController = TextEditingController(text: "0");
  final TextEditingController _beneficiaryNameController = TextEditingController();
  final TextEditingController _beneficiaryPhoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _daaraNameController = TextEditingController();

  File? _selectedImage;
  String _selectedType = "Santé / Malade";

  // Liste des types sans la maintenance
  final List<String> _questTypes = [
    "Santé / Malade",
    "Construction de Puits",
    "Soutien aux Daaras",
    "Autre"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.urgentRequest != null) {
      _titleController.text = "Urgence : ${widget.urgentRequest!['memberName']}";
      _beneficiaryNameController.text = widget.urgentRequest!['memberName'];
      _beneficiaryPhoneController.text = widget.urgentRequest!['phone'];
      _descriptionController.text = widget.urgentRequest!['message'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _beneficiaryNameController.dispose();
    _beneficiaryPhoneController.dispose();
    _locationController.dispose();
    _daaraNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isHealth = _selectedType == "Santé / Malade";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Détails de la quête", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Quelle est la nature de cette quête ?", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTypeSelector(),
              const Divider(height: 40),

              // Zone Photo pour Santé (Facultative)
              if (isHealth) ...[
                const Text("Justificatif médical (Facultatif)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                _buildPhotoPicker(),
                const SizedBox(height: 20),
              ],

              _buildLabelField("Titre de la quête", _titleController, "Ex: Aide pour opération"),
              const SizedBox(height: 15),

              // Champs conditionnels selon le type
              if (isHealth) ...[
                _buildLabelField("Nom du Patient", _beneficiaryNameController, "Prénom et Nom"),
              ] else if (_selectedType == "Construction de Puits") ...[
                _buildLabelField("Localité / Village", _locationController, "Ex: Village de Ndoulo"),
                const SizedBox(height: 15),
                _buildLabelField("Contact du responsable", _beneficiaryNameController, "Nom du responsable local"),
              ] else if (_selectedType == "Soutien aux Daaras") ...[
                _buildLabelField("Nom du Daara", _daaraNameController, "Ex: Daara Serigne Saliou"),
                const SizedBox(height: 15),
                _buildLabelField("Nom du Borom Daara", _beneficiaryNameController, "Prénom et Nom"),
              ],

              const SizedBox(height: 15),
              _buildLabelField("Téléphone de contact / Réception", _beneficiaryPhoneController, "77 XXX XX XX", isNumber: true),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildLabelField("Objectif (FCFA)", _targetAmountController, "Cible", isNumber: true)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildLabelField("Déjà reçu (FCFA)", _currentAmountController, "Initial", isNumber: true)),
                ],
              ),

              const SizedBox(height: 20),
              _buildLabelField("Description", _descriptionController, "Détails supplémentaires pour les membres...", maxLines: 3),
              const SizedBox(height: 30),

              _buildPublishButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedType,
          isExpanded: true,
          items: _questTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) => setState(() => _selectedType = val!),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary.withOpacity(0.5), size: 40),
          const SizedBox(height: 4),
          const Text("Ajouter une photo (ordonnance, etc.)", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLabelField(String label, TextEditingController controller, String hint, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
          validator: (value) => value!.isEmpty ? "Champ requis" : null,
        ),
      ],
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            publishQuest(
              associationName: widget.associationName,
              title: _titleController.text,
              description: _descriptionController.text,
              targetAmount: _targetAmountController.text,
              currentAmount: _currentAmountController.text,
              isClosed: false, // Toujours actif à la création
              beneficiaryName: _beneficiaryNameController.text,
              beneficiaryPhone: _beneficiaryPhoneController.text,
            );
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text("PUBLIER LA QUÊTE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}