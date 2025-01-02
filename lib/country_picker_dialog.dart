import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final double? countryFlagSize;

  final Widget? listTileDivider;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  final Color? radioColor;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryFlagSize,
    this.countryNameStyle,
    this.listTileDivider,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
    this.radioColor,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;
  final Color? dividerColor;
  final ScrollController scrollController;
  final bool showRadio;

  const CountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
    this.dividerColor,
    required this.scrollController,
    this.showRadio = true,
  }) : super(key: key);

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries.toList()
      ..sort(
        (a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 6,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Padding(
            padding: widget.style?.searchFieldPadding ?? const EdgeInsets.all(10),
            child: TextField(
              cursorColor: widget.style?.searchFieldCursorColor,
              decoration: widget.style?.searchFieldInputDecoration ??
                  InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    labelText: widget.searchText,
                  ),
              onChanged: (value) {
                _filteredCountries = widget.countryList.stringSearch(value)
                  ..sort(
                    (a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)),
                  );
                if (mounted) setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _filteredCountries.length,
              itemBuilder: (ctx, index) => GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 1),
                  child: Row(children: [
                    Image.asset(
                      'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                      package: 'intl_phone_field',
                      width: widget.style?.countryFlagSize ?? 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _filteredCountries[index].localizedName(widget.languageCode),
                      style: widget.style?.countryNameStyle ?? const TextStyle(fontSize: 14),
                    ),
                    Spacer(),
                    Text(
                      '[+${_filteredCountries[index].dialCode}]',
                    ),
                    if (widget.showRadio)
                      Radio<Country>(
                        value: _filteredCountries[index],
                        groupValue: _selectedCountry,
                        onChanged: (Country? value) {
                          if (value != null) {
                            setState(() {
                              _selectedCountry = value;
                            });
                            widget.onCountryChanged(_selectedCountry);
                            Navigator.of(context).pop();
                          }
                        },
                        activeColor: widget.style?.radioColor ?? Colors.purple,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return widget.style?.radioColor ?? Colors.purple;
                          }
                          return Colors.black26;
                        }),
                        visualDensity: VisualDensity.standard,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                  ]),
                ),
                onTap: () {
                  _selectedCountry = _filteredCountries[index];
                  widget.onCountryChanged(_selectedCountry);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
