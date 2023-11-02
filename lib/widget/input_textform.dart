import 'package:adverts247Pass/themes.dart';
import 'package:flutter/material.dart';

class OutlineInput extends StatefulWidget {
  OutlineInput(
      {Key? key,
      this.controller,
      this.maxLines,
      this.labelText,
      this.validator,
      this.icon,
      this.onChanged,
      this.textCenter,
      this.keyboardType,
      this.onTap,
      this.readOnly,
      this.obscureText,
      this.suffixWidget,
      this.preffixWidget})
      : super(key: key);
  final int? maxLines;
  String? icon;
  String? labelText;
  Widget? preffixWidget;
  TextInputType? keyboardType;
  dynamic onTap;
  bool? obscureText;
  bool? readOnly;
  dynamic onChanged;

  Widget? suffixWidget;
  bool? textCenter;
  // late TextAlign textAlign = TextAlign.left;

  TextEditingController? controller;
  final String? Function(String value)? validator;

  @override
  State<OutlineInput> createState() => _OutlineInputState();
}

class _OutlineInputState extends State<OutlineInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText.toString(),
          style: TextStyles()
              .whiteTextStyle()
              .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: widget.controller,
          textAlign:
              widget.textCenter == true ? TextAlign.center : TextAlign.left,
          style: TextStyles()
              .whiteTextStyle()
              .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly ?? false,

          obscureText: widget.obscureText ?? false,
          maxLines: widget.maxLines ?? 1,
          validator: widget.validator != null
              ? (String? value) => widget.validator!(value!)
              : null,
          decoration: InputDecoration(
            // labelText: widget.labelText,
            // labelStyle: TextStyles().whiteTextStyle().copyWith(
            //       fontSize: 13,
            //     ),
            prefixIcon: widget.preffixWidget,
            suffixIcon: widget.suffixWidget ??
                SizedBox(
                  child: widget.icon == null
                      ? Container(
                          width: 20,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Image.asset(widget.icon.toString()),
                        ),
                ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: Color(0xffE8E9EA),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: Color(0xffE8E9EA),
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: Color(0xffE8E9EA),
              ),
            ),
            //   prefix: widget.preffixWidget,
            filled: true,

            fillColor: Colors.black,
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: Color(0xffE8E9EA),
              ),
            ),
          ),
          //  style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ],
    );
  }
}

class BlackOutlineInput extends StatefulWidget {
  BlackOutlineInput(
      {Key? key, this.controller, this.maxLines, this.validator, this.onTap})
      : super(key: key);
  final int? maxLines;
  VoidCallback? onTap;
  TextEditingController? controller;
  final String? Function(String value)? validator;

  @override
  State<BlackOutlineInput> createState() => _BlackOutlineInputState();
}

class _BlackOutlineInputState extends State<BlackOutlineInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: true,
      onTap: widget.onTap,
      obscureText: false,
      maxLines: widget.maxLines,
      validator: widget.validator != null
          ? (String? value) => widget.validator!(value!)
          : null,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Color(0xffB5B5B5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Color(0xffB5B5B5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Color(0xffB5B5B5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Color(0xffB5B5B5),
          ),
        ),
      ),
      //  style: FlutterFlowTheme.of(context).bodyText1,
    );
  }
}
