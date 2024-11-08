import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
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
      padding: widget.style?.padding ?? const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              right: 20,
              left: 20,
            ),
            height: kToolbarHeight + 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 150,
                  decoration: BoxDecoration(
                    color: widget.dividerColor ?? Colors.grey,
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     if (title != null)
                //       Text(
                //         title,
                //         style: TextStyles.t1,
                //         maxLines: 1,
                //       )
                //     else
                //       const SizedBox(),
                //     if (showCancelButton)
                //       Bounce(
                //         onTap: () => Navigator.pop(context),
                //         child: const Icon(
                //           PhosphorIcons.x_bold,
                //         ),
                //       )
                //   ],
                // ),
              ],
            ),
          ),
          Padding(
            padding: widget.style?.searchFieldPadding ?? const EdgeInsets.all(0),
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
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (ctx, index) => Column(
                children: <Widget>[
                  ListTile(
                    leading: Image.asset(
                      'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                      package: 'intl_phone_field',
                      width: 25,
                    ),
                    contentPadding: widget.style?.listTilePadding,
                    title: Text(
                      _filteredCountries[index].localizedName(widget.languageCode) +
                          " " +
                          '(+${_filteredCountries[index].dialCode})',
                      style: widget.style?.countryNameStyle ?? const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      _selectedCountry = _filteredCountries[index];
                      widget.onCountryChanged(_selectedCountry);
                      Navigator.of(context).pop();
                    },
                  ),
                  // widget.style?.listTileDivider ?? const Divider(thickness: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
