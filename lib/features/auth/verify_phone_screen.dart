import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../home/member_dashboard.dart'; // Change si association
import '../../../core/services/api_service.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phone; // Numéro affiché (masqué pour sécurité)

  const VerifyPhoneScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  bool _canResend = true;
  int _resendCountdown = 60;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final api = ApiService();

    try {
      final response = await api.verifyPhone(
        phone: widget.phone,
        code: _codeController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Numéro vérifié avec succès ! ✅'),
          backgroundColor: Colors.green,
        ),
      );

      // Redirection vers le dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MemberDashboard()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;

    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });

    final api = ApiService();

    try {
      final response = await api.resendCode(phone: widget.phone);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Nouveau code envoyé !'),
          backgroundColor: Colors.blue,
        ),
      );

      // Compte à rebours
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _resendCountdown--);
          if (_resendCountdown > 0) {
            Future.delayed(const Duration(seconds: 1), () => _resendCodeCountdown());
          } else {
            setState(() => _canResend = true);
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
      );
      setState(() => _canResend = true);
    }
  }

  void _resendCodeCountdown() {
    if (_resendCountdown > 0 && mounted) {
      setState(() => _resendCountdown--);
      Future.delayed(const Duration(seconds: 1), _resendCodeCountdown);
    } else if (mounted) {
      setState(() => _canResend = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Vérification"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.sms_outlined, size: 80, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text(
                "Vérifiez votre numéro",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Nous avons envoyé un code à 4 chiffres au numéro\n${widget.phone.replaceRange(5, widget.phone.length - 3, '***')}",
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Champ code
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 4,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "_ _ _ _",
                  hintStyle: const TextStyle(fontSize: 30, letterSpacing: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(fontSize: 30, letterSpacing: 20),
                validator: (value) {
                  if (value == null || value.length != 4) {
                    return "Code à 4 chiffres requis";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Bouton vérifier
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _verifyCode,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "VÉRIFIER",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Renvoyer le code
              TextButton(
                onPressed: _canResend ? _resendCode : null,
                child: Text(
                  _canResend
                      ? "Renvoyer le code"
                      : "Renvoyer dans $_resendCountdown s",
                  style: TextStyle(color: _canResend ? AppColors.primary : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}