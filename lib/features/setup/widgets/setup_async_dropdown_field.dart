import 'package:flutter/material.dart';

import 'setup_dropdown_field.dart';

/// Presents a dropdown together with its loading, error and empty states.
class SetupAsyncDropdownField<T> extends StatelessWidget {
  const SetupAsyncDropdownField({
    super.key,
    required this.future,
    required this.label,
    required this.icon,
    required this.hint,
    required this.loadingLabel,
    required this.errorMessage,
    required this.emptyMessage,
    required this.value,
    required this.itemLabel,
    required this.onChanged,
    required this.onRetry,
  });

  final Future<List<T>>? future;
  final String label;
  final IconData icon;
  final String hint;
  final String loadingLabel;
  final String errorMessage;
  final String emptyMessage;
  final T? value;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (future == null) return _field(const [], enabled: false);

    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(semanticsLabel: loadingLabel),
          );
        }
        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(liveRegion: true, child: Text(errorMessage)),
              TextButton(
                onPressed: onRetry,
                child: const Text('Tentar novamente'),
              ),
            ],
          );
        }
        final items = snapshot.data ?? <T>[];
        if (items.isEmpty) {
          return Semantics(liveRegion: true, child: Text(emptyMessage));
        }
        return _field(items, enabled: true);
      },
    );
  }

  SetupDropdownField<T> _field(List<T> items, {required bool enabled}) =>
      SetupDropdownField<T>(
        label: label,
        icon: icon,
        hint: hint,
        items: items,
        value: value,
        itemLabel: itemLabel,
        onChanged: enabled ? onChanged : null,
      );
}
