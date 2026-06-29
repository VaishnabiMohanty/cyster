class ConceptionTip {
  final String title;
  final String body;
  final String icon; // material icon name key, resolved in UI layer

  const ConceptionTip({required this.title, required this.body, required this.icon});
}

class ConceptionTipCategory {
  final String title;
  final List<ConceptionTip> tips;
  const ConceptionTipCategory({required this.title, required this.tips});
}

/// Curated, general-education conception tips. Not medical advice — framed
/// throughout as things to discuss with a healthcare provider, especially
/// given PCOS-specific considerations (insulin resistance, irregular
/// ovulation, weight-sensitive fertility treatments, etc).
final List<ConceptionTipCategory> conceptionTipCategories = [
  ConceptionTipCategory(
    title: 'Timing & Tracking',
    tips: [
      ConceptionTip(
        title: 'Track your fertile window',
        body: 'Use the Fertility Calculator alongside ovulation predictor kits (LH strips) since PCOS can shift '
            'ovulation earlier or later than a "typical" cycle day.',
        icon: 'calendar',
      ),
      ConceptionTip(
        title: 'Watch your cervical mucus',
        body: 'Egg-white, stretchy, clear mucus usually signals you are approaching ovulation. Cloudy or absent '
            'mucus is more typical of non-fertile days.',
        icon: 'water_drop',
      ),
      ConceptionTip(
        title: 'Consider basal body temperature (BBT)',
        body: 'A sustained rise of about 0.3–0.5°C after ovulation can confirm — after the fact — that ovulation '
            'happened that cycle, which helps you understand your pattern over a few months.',
        icon: 'thermostat',
      ),
      ConceptionTip(
        title: 'Have intercourse every 1–2 days during the fertile window',
        body: 'This keeps sperm consistently available without the pressure of pinpointing the "exact" day, '
            'which is harder to predict with PCOS-related cycle variability.',
        icon: 'favorite',
      ),
    ],
  ),
  ConceptionTipCategory(
    title: 'Body & Lifestyle',
    tips: [
      ConceptionTip(
        title: 'A modest weight change can restart ovulation',
        body: 'For some people with PCOS, losing even 5–10% of body weight (if currently above a healthy range) '
            'can help regulate cycles and ovulation — but this isn\'t the case for everyone, and being underweight '
            'can hurt fertility too, so aim for what your doctor considers a healthy range for you.',
        icon: 'monitor_weight',
      ),
      ConceptionTip(
        title: 'Prioritize insulin-friendly eating',
        body: 'Since insulin resistance is common in PCOS and is linked to ovulation problems, steady-release '
            'meals (protein + fiber + smart carbs) may support more regular cycles. See the Nutrition tab for ideas.',
        icon: 'restaurant',
      ),
      ConceptionTip(
        title: 'Move regularly, not punishingly',
        body: 'Moderate, consistent activity (brisk walking, strength training, yoga) supports insulin sensitivity '
            'better than extreme exercise, which can sometimes suppress ovulation further.',
        icon: 'directions_walk',
      ),
      ConceptionTip(
        title: 'Protect your sleep',
        body: 'Poor sleep can worsen insulin resistance and hormonal balance. Aim for a consistent sleep schedule.',
        icon: 'bedtime',
      ),
      ConceptionTip(
        title: 'Reduce alcohol, quit smoking',
        body: 'Both are independently linked to reduced fertility for anyone trying to conceive, regardless of PCOS.',
        icon: 'no_drinks',
      ),
    ],
  ),
  ConceptionTipCategory(
    title: 'Medical Support',
    tips: [
      ConceptionTip(
        title: 'Ask about ovulation induction',
        body: 'Medications like letrozole or clomiphene are commonly used to help trigger ovulation in PCOS and '
            'are usually a first-line conversation with a fertility doctor.',
        icon: 'medication',
      ),
      ConceptionTip(
        title: 'Get baseline bloodwork done',
        body: 'Thyroid function, prolactin, and insulin/glucose levels are often checked early since they can all '
            'affect ovulation and are usually manageable once identified.',
        icon: 'science',
      ),
      ConceptionTip(
        title: 'Start prenatal vitamins early',
        body: 'Folic acid supplementation is recommended before conception, not just after a positive test, to '
            'support early neural development.',
        icon: 'medical_services',
      ),
      ConceptionTip(
        title: "Don't wait too long to ask for help",
        body: 'If you are under 35 and have been trying for a year, or over 35 and trying for 6 months, it is a '
            'reasonable time to see a fertility specialist — earlier if your cycles are very irregular or absent.',
        icon: 'support_agent',
      ),
    ],
  ),
  ConceptionTipCategory(
    title: 'Mind & Partner',
    tips: [
      ConceptionTip(
        title: 'Conception stress is real — name it',
        body: 'The "just relax" advice is unhelpful, but chronic stress can affect hormonal regulation. Gentle '
            'practices like journaling (see the Journal tab) or therapy can help you process the journey.',
        icon: 'self_improvement',
      ),
      ConceptionTip(
        title: "Loop in your partner's health too",
        body: 'Conception is a two-person equation. Semen analysis is quick, often covered by insurance, and '
            'rules out or identifies a contributing factor early.',
        icon: 'diversity_3',
      ),
    ],
  ),
];
