class PregnancySign {
  final String title;
  final String description;
  final String icon;
  final bool isEarlySign;

  const PregnancySign({
    required this.title,
    required this.description,
    required this.icon,
    this.isEarlySign = true,
  });
}

/// General-education list of commonly reported early pregnancy signs.
/// Several overlap heavily with PCOS and PMS symptoms, which is called out
/// explicitly in the UI so this doesn't read as a diagnostic checklist.
final List<PregnancySign> earlyPregnancySigns = [
  PregnancySign(
    title: 'Missed or unusually light period',
    description: 'The most commonly recognized early sign — though irregular or absent cycles are also common '
        'with PCOS, which can make this confusing on its own.',
    icon: 'event_busy',
  ),
  PregnancySign(
    title: 'Nausea, with or without vomiting',
    description: 'Often called "morning sickness," though it can happen at any time of day, typically starting '
        'around week 4–6.',
    icon: 'sick',
  ),
  PregnancySign(
    title: 'Breast tenderness or swelling',
    description: 'Hormonal shifts can make breasts feel sore, heavy, or sensitive — similar to premenstrual '
        'tenderness, but often more pronounced or longer-lasting.',
    icon: 'favorite_border',
  ),
  PregnancySign(
    title: 'Fatigue',
    description: 'Rising progesterone can cause noticeable tiredness even in early pregnancy, before other signs '
        'appear.',
    icon: 'bedtime',
  ),
  PregnancySign(
    title: 'Frequent urination',
    description: 'Increased blood flow to the kidneys and, later, pressure from the growing uterus can increase '
        'bathroom trips.',
    icon: 'wc',
  ),
  PregnancySign(
    title: 'Food aversions or cravings',
    description: 'A heightened sense of smell or sudden dislike (or strong liking) for certain foods is commonly '
        'reported early on.',
    icon: 'restaurant',
  ),
  PregnancySign(
    title: 'Mild cramping or spotting',
    description: 'Implantation can cause light spotting and cramping around the time a period would be due — '
        'usually lighter and shorter than a period.',
    icon: 'water_drop_outlined',
  ),
  PregnancySign(
    title: 'Mood swings',
    description: 'Rapid hormonal shifts can affect mood, similar to PMS but sometimes more intense or persistent.',
    icon: 'mood',
  ),
  PregnancySign(
    title: 'Bloating',
    description: 'Hormonal changes can slow digestion, leading to a bloated feeling that overlaps with both PMS '
        'and PCOS bloating.',
    icon: 'circle_outlined',
  ),
  PregnancySign(
    title: 'Heightened sense of smell',
    description: 'Some people notice smells become much more intense or nauseating very early on.',
    icon: 'air',
  ),
  PregnancySign(
    title: 'Basal body temperature stays elevated',
    description: 'If you track BBT, a sustained rise for more than 14–18 days past ovulation (rather than '
        'dropping before a period) can be an early signal worth a test.',
    icon: 'thermostat',
  ),
];

/// Why this matters specifically for PCOS — kept as a distinct constant so
/// the UI can render it as a dedicated callout.
const String pcosPregnancySignsCaveat =
    'Because PCOS symptoms (irregular periods, bloating, fatigue, mood changes) overlap so heavily with early '
    'pregnancy signs, symptoms alone are not a reliable way to tell the two apart. A home urine test (most '
    'accurate from the day of a missed period, or about 12-14 days after ovulation) or a blood test at a clinic '
    'are the only reliable ways to confirm pregnancy.';
