import 'package:flutter/material.dart';

class GramInputSheet extends StatefulWidget {
  final String foodName;
  final double caloriesPer100g;
  final Future<void> Function(double grams) onConfirm;

  const GramInputSheet({
    super.key,
    required this.foodName,
    required this.caloriesPer100g,
    required this.onConfirm,
  });

  @override
  State<GramInputSheet> createState() => _GramInputSheetState();
}

class _GramInputSheetState extends State<GramInputSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  static const _green = Color(0xFF4CAF50);
  static const _orange = Color(0xFFFF7043);
  static const _textPrimary = Color(0xFF212121);
  static const _textSecondary = Color(0xFF757575);

  double get _estimatedCalories {
    final grams = double.tryParse(_controller.text) ?? 0;
    return (widget.caloriesPer100g / 100) * grams;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Food name
              Text(
                widget.foodName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.caloriesPer100g.toStringAsFixed(1)} kcal per 100g',
                style: const TextStyle(fontSize: 13, color: _textSecondary),
              ),

              const SizedBox(height: 20),

              // Label
              const Text(
                'Jumlah yang dimakan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),

              // Gram input
              TextFormField(
                controller: _controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(fontSize: 15, color: _textPrimary),
                decoration: InputDecoration(
                  hintText: 'Masukkan gram',
                  hintStyle: const TextStyle(
                    color: _textSecondary,
                    fontSize: 15,
                  ),
                  suffixText: 'g',
                  suffixStyle: const TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _green, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _orange),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _orange, width: 1.5),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan jumlah gram';
                  }
                  final grams = double.tryParse(value);
                  if (grams == null || grams <= 0) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Calorie preview
              AnimatedOpacity(
                opacity: _controller.text.isNotEmpty ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _orange.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: _orange,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Estimasi: ${_estimatedCalories.toStringAsFixed(1)} kcal',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _isLoading = true);
                          final grams = double.parse(_controller.text);
                          await widget.onConfirm(grams);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _green.withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Tambah ke Log',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
