import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final Color textColor = const Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFFFFFDE7), // المركز فاتح
            Color(0xFFFFC828), // الوسط أصفر
            Color(0xFFF57F17), // الأطراف عسلي
          ],
          stops: [0.1, 0.6, 1.0],
          center: Alignment.center,
          radius: 1.0,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      child: Directionality(
        textDirection:
            TextDirection.rtl, // لضمان ترتيب العناصر من اليمين لليسار
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // زر الرجوع (يسار)
                Align(
                  alignment: Alignment.centerLeft,
                  child: NeobrutalistBackButton(
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 10),

                // محتوى الإعدادات داخل قائمة
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // --- 1. كرت الملف الشخصي ---
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: textColor, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF1E1E1E),
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2D4FB),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: textColor,
                                  width: 2.5,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 35,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Salem Alaidaroos",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "salem_aid@gmail.com",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // --- 2. تفضيلات التطبيق ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "تفضيلات التطبيق",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SettingsOptionRow(
                        title: "الوضع الليلي (قريباً)",
                        icon: Icons.nightlight_round,
                        hasSwitch: true,
                      ),

                      const SizedBox(height: 30),

                      // --- 3. الدعم والمعلومات ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "الدعم والمعلومات",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: textColor, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF1E1E1E),
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SettingsOptionRow(
                              title: "تواصل معنا",
                              icon: Icons.headset_mic_rounded,
                              iconBgColor: const Color(0xFFD0F0C0),
                              onTap: () {},
                            ),
                            Container(height: 2.5, color: textColor),
                            SettingsOptionRow(
                              title: "عن التطبيق",
                              icon: Icons.info_outline_rounded,
                              iconBgColor: const Color(0xFFBBDEFB),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // --- 4. زر تسجيل الخروج ---
                      LogoutButton(onTap: () {}),

                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "إصدار التطبيق 1.0.0",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: textColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================================
// الودجتس المساعدة (Rows, Buttons)
// ========================================================

class SettingsOptionRow extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool hasSwitch;
  final Color? iconBgColor;
  final VoidCallback? onTap;
  const SettingsOptionRow({
    super.key,
    required this.title,
    required this.icon,
    this.hasSwitch = false,
    this.iconBgColor,
    this.onTap,
  });

  @override
  State<SettingsOptionRow> createState() => _SettingsOptionRowState();
}

class _SettingsOptionRowState extends State<SettingsOptionRow> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: !widget.hasSwitch
            ? BoxDecoration(
                color: isPressed ? const Color(0xFFF1F3F4) : Colors.transparent,
              )
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
                ],
              ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.iconBgColor ?? const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
              ),
              child: Icon(
                widget.icon,
                size: 22,
                color: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            if (widget.hasSwitch)
              Container(
                width: 50,
                height: 28,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF1E1E1E),
                    width: 2.5,
                  ),
                ),
                alignment: Alignment.centerRight,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9E9E9E),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1E1E1E),
                      width: 2,
                    ),
                  ),
                ),
              )
            else
              const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class NeobrutalistBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const NeobrutalistBackButton({super.key, required this.onTap});
  @override
  State<NeobrutalistBackButton> createState() => _NeobrutalistBackButtonState();
}

class _NeobrutalistBackButtonState extends State<NeobrutalistBackButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          isPressed ? 3 : 0,
          isPressed ? 3 : 0,
          0,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
          boxShadow: isPressed
              ? []
              : const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(3, 3)),
                ],
        ),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(Icons.arrow_back_rounded, size: 24),
        ),
      ),
    );
  }
}

class LogoutButton extends StatefulWidget {
  final VoidCallback onTap;
  const LogoutButton({super.key, required this.onTap});
  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          isPressed ? 4 : 0,
          isPressed ? 4 : 0,
          0,
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4D4D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
          boxShadow: isPressed
              ? []
              : const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
                ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "تسجيل الخروج  ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Icon(Icons.logout_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
