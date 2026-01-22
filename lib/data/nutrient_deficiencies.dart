/// Nutrient deficiency data with treatments
class NutrientDeficiencyInfo {
  final String name;
  final String nutrient;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> treatments;
  final List<String> preventions;
  final String severity; // Banayad, Katamtaman, Malubha

  const NutrientDeficiencyInfo({
    required this.name,
    required this.nutrient,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatments,
    required this.preventions,
    required this.severity,
  });
}

class NutrientDeficiencies {
  static const List<NutrientDeficiencyInfo> deficiencies = [
    // Nitrogen Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Nitrogen (N)',
      nutrient: 'Nitrogen',
      description: 'Ang nitrogen ay mahalaga para sa paglaki ng dahon at produksyon ng chlorophyll. Ang kakulangan nito ay nagdudulot ng mahinang paglaki at paninilaw ng mga dahon.',
      symptoms: [
        'Paninilaw ng mga lumang dahon (mula sa ibaba)',
        'Mahinang paglaki ng halaman',
        'Maliliit na dahon',
        'Maputlang berdeng kulay ng buong halaman',
        'Maagang pagkahinog ng bunga',
        'Maliit na bunga',
      ],
      causes: [
        'Kakulangan ng nitrogen sa lupa',
        'Labis na pagdidilig na naghuhugas ng nutrients',
        'Mahinang uri ng lupa',
        'Mataas na pH ng lupa (alkaline)',
        'Kakulangan ng organic matter sa lupa',
      ],
      treatments: [
        'Maglagay ng urea (46-0-0) sa rate na 10-15 grams bawat halaman',
        'Gumamit ng ammonium sulfate (21-0-0)',
        'Maglagay ng foliar spray na may nitrogen',
        'Hatiin ang paglalagay ng pataba (3-4 na beses sa isang taon)',
        'Magdagdag ng composted manure sa lupa',
      ],
      preventions: [
        'Regular na soil testing',
        'Tamang iskedyul ng pagpapataba',
        'Paggamit ng organic fertilizers',
        'Tamang pagdidilig para maiwasan ang leaching',
        'Pagdagdag ng mulch para mapigilan ang pagkawala ng nutrients',
      ],
      severity: 'Katamtaman',
    ),

    // Phosphorus Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Phosphorus (P)',
      nutrient: 'Phosphorus',
      description: 'Ang phosphorus ay mahalaga para sa pagbuo ng ugat, pamumulaklak, at pagbubunga. Ang kakulangan nito ay nakakaapekto sa produksyon ng bunga.',
      symptoms: [
        'Maitim na berde hanggang purple na kulay ng mga dahon',
        'Mahinang pagbuo ng ugat',
        'Mabagal na paglaki',
        'Mahinang pamumulaklak',
        'Maliit at maasim na bunga',
        'Mga lumang dahon ay nagiging kayumanggi',
      ],
      causes: [
        'Mababang phosphorus sa lupa',
        'Mataas o mababang pH ng lupa (hindi available ang P)',
        'Malamig na temperatura ng lupa',
        'Sobrang kahalumigmigan ng lupa',
        'Mataas na iron o aluminum sa lupa',
      ],
      treatments: [
        'Maglagay ng complete fertilizer (14-14-14)',
        'Gumamit ng superphosphate o triple superphosphate',
        'Maglagay ng rock phosphate para sa long-term supply',
        'I-adjust ang pH ng lupa sa 4.5-5.5',
        'Magdagdag ng bone meal sa lupa',
      ],
      preventions: [
        'Regular na pagsusuri ng lupa',
        'Paggamit ng balanseng pataba',
        'Panatilihin ang tamang pH ng lupa',
        'Iwasan ang sobrang pagdidilig',
        'Magdagdag ng organic matter',
      ],
      severity: 'Katamtaman',
    ),

    // Potassium Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Potassium (K)',
      nutrient: 'Potassium',
      description: 'Ang potassium ay kritikal para sa kalidad ng bunga, tamis, at resistensya sa sakit. Ito ang pinakamahalagang nutrient para sa pinya.',
      symptoms: [
        'Paninilaw at pagkatuyo ng mga gilid ng dahon',
        'Mga dahon ay nagiging kayumanggi sa dulo',
        'Mahinang kalidad ng bunga',
        'Matabang at maasim na bunga',
        'Madaling tamaan ng sakit ang halaman',
        'Mahinang paglaki ng korona',
      ],
      causes: [
        'Mababang potassium sa lupa',
        'Sandy o light soils',
        'Labis na pagdidilig o ulan',
        'Mataas na calcium o magnesium na nagha-hamper sa K uptake',
        'Kakulangan ng organic matter',
      ],
      treatments: [
        'Maglagay ng muriate of potash (0-0-60)',
        'Gumamit ng potassium sulfate (0-0-50)',
        'Mag-foliar spray ng potassium nitrate',
        'Magdagdag ng wood ash sa lupa',
        'Gumamit ng complete fertilizer na may mataas na K',
      ],
      preventions: [
        'Regular na soil testing para sa K levels',
        'Balanseng fertilization program',
        'Tamang ratio ng N-P-K (1:0.5:2 para sa pinya)',
        'Iwasan ang sobrang pagdidilig',
        'Magdagdag ng compost at organic materials',
      ],
      severity: 'Malubha',
    ),

    // Iron Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Iron (Fe)',
      nutrient: 'Iron',
      description: 'Ang iron ay mahalaga para sa produksyon ng chlorophyll. Ang kakulangan nito ay nagdudulot ng chlorosis o paninilaw ng mga bagong dahon.',
      symptoms: [
        'Paninilaw ng mga bagong dahon (interveinal chlorosis)',
        'Berdeng mga ugat ngunit dilaw ang pagitan',
        'Maputla hanggang puting mga bagong dahon sa malubhang kaso',
        'Mahinang paglaki',
        'Maliit na mga dahon',
      ],
      causes: [
        'Mataas na pH ng lupa (alkaline)',
        'Sobrang pagdidilig',
        'Mahinang daluyan ng tubig sa lupa',
        'Mataas na phosphorus, zinc, o manganese',
        'Malamig na lupa',
      ],
      treatments: [
        'Mag-foliar spray ng iron sulfate o iron chelate',
        'Maglagay ng chelated iron sa lupa',
        'Babaan ang pH ng lupa gamit ang sulfur',
        'Pagbutihin ang daluyan ng tubig',
        'Bawasan ang sobrang pagdidilig',
      ],
      preventions: [
        'Panatilihin ang pH ng lupa sa 4.5-5.5',
        'Iwasan ang sobrang paglalagay ng phosphorus',
        'Tiyakin ang magandang daluyan ng lupa',
        'Regular na foliar application ng micronutrients',
        'Gumamit ng acidifying fertilizers',
      ],
      severity: 'Katamtaman',
    ),

    // Zinc Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Zinc (Zn)',
      nutrient: 'Zinc',
      description: 'Ang zinc ay mahalaga para sa paglaki at pagbuo ng mga enzyme. Ang kakulangan nito ay karaniwang problema sa mga alkaline soils.',
      symptoms: [
        'Maliliit at makikitid na mga dahon',
        'Interveinal chlorosis sa mga bagong dahon',
        'Rosetting o bunching ng mga dahon',
        'Mahinang paglaki ng halaman',
        'Nabawasan ang produksyon ng bunga',
        'Mga dahon ay may bronze o purple na kulay',
      ],
      causes: [
        'Mataas na pH ng lupa',
        'Mataas na phosphorus sa lupa',
        'Sandy soils na may mababang organic matter',
        'Malamig at basang kondisyon ng lupa',
        'Sobrang paglalagay ng lime',
      ],
      treatments: [
        'Mag-foliar spray ng zinc sulfate (0.5%)',
        'Maglagay ng zinc sulfate sa lupa (5-10 kg/ha)',
        'Gumamit ng zinc chelate para sa mabilis na resulta',
        'Babaan ang pH ng lupa kung kinakailangan',
        'Bawasan ang phosphorus application',
      ],
      preventions: [
        'Regular na soil at tissue testing',
        'Balanseng micronutrient program',
        'Panatilihin ang tamang pH ng lupa',
        'Iwasan ang sobrang phosphorus',
        'Magdagdag ng organic matter sa lupa',
      ],
      severity: 'Katamtaman',
    ),

    // Magnesium Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Magnesium (Mg)',
      nutrient: 'Magnesium',
      description: 'Ang magnesium ay bahagi ng chlorophyll at mahalaga para sa photosynthesis. Ang kakulangan nito ay nagdudulot ng chlorosis sa mga lumang dahon.',
      symptoms: [
        'Interveinal chlorosis sa mga lumang dahon',
        'Berdeng ugat ngunit dilaw ang pagitan ng mga dahon',
        'Pagkahulog ng mga lumang dahon',
        'Reddish-purple na kulay sa mga gilid ng dahon',
        'Mahinang paglaki at maliit na bunga',
      ],
      causes: [
        'Mababang magnesium sa lupa',
        'Sandy o acidic soils',
        'Sobrang potassium o calcium na nagha-hamper sa Mg uptake',
        'Heavy rainfall na naghuhugas ng Mg',
        'Mahinang soil structure',
      ],
      treatments: [
        'Mag-foliar spray ng magnesium sulfate (Epsom salt) - 2%',
        'Maglagay ng dolomite lime',
        'Magdagdag ng magnesium sulfate sa lupa',
        'Bawasan ang sobrang potassium application',
        'Ayusin ang pH ng lupa kung kinakailangan',
      ],
      preventions: [
        'Regular na soil testing para sa Mg levels',
        'Balanseng fertilizer program',
        'Gumamit ng dolomitic limestone kung nag-li-lime',
        'Iwasan ang sobrang K fertilization',
        'Pagdagdag ng organic matter',
      ],
      severity: 'Katamtaman',
    ),

    // Calcium Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Calcium (Ca)',
      nutrient: 'Calcium',
      description: 'Ang calcium ay mahalaga para sa pagbuo ng cell wall at paglaki ng mga bagong bahagi ng halaman. Ang kakulangan nito ay nakakaapekto sa kalidad ng bunga.',
      symptoms: [
        'Pagkasira ng mga bagong dahon at growing points',
        'Mga dulo ng dahon ay nagiging kayumanggi at tuyo',
        'Mahinang pagbuo ng ugat',
        'Pagkabali ng mga dahon',
        'Internal browning ng bunga',
        'Cracking ng bunga',
      ],
      causes: [
        'Mababang calcium sa lupa',
        'Acidic soils',
        'Sobrang potassium, magnesium, o ammonium',
        'Mahinang paggalaw ng tubig sa halaman',
        'High humidity at mababang transpiration',
      ],
      treatments: [
        'Maglagay ng agricultural lime o gypsum',
        'Mag-foliar spray ng calcium chloride o calcium nitrate',
        'Pagbutihin ang irrigation management',
        'Bawasan ang sobrang N, K, o Mg fertilization',
        'Tiyakin ang regular na pagdidilig',
      ],
      preventions: [
        'Regular na soil testing at liming kung kinakailangan',
        'Balanseng fertilizer program',
        'Tamang irrigation para sa magandang Ca uptake',
        'Iwasan ang sobrang ammonium-based fertilizers',
        'Magdagdag ng gypsum sa heavy soils',
      ],
      severity: 'Katamtaman',
    ),

    // Boron Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Boron (B)',
      nutrient: 'Boron',
      description: 'Ang boron ay mahalaga para sa pagbuo ng cell wall, pamumulaklak, at pagbubunga. Ang kakulangan nito ay kritikal sa kalidad ng bunga ng pinya.',
      symptoms: [
        'Cracking at corking ng bunga',
        'Deformed na bunga',
        'Hollow heart sa bunga',
        'Pagkasira ng mga bagong dahon',
        'Mahinang pamumulaklak',
        'Makapal at malutong na mga dahon',
      ],
      causes: [
        'Mababang boron sa lupa',
        'Sandy soils na may mababang organic matter',
        'Mataas na pH ng lupa',
        'Tagtuyot o sobrang pagdidilig',
        'Mataas na calcium na nagha-hamper sa B uptake',
      ],
      treatments: [
        'Mag-foliar spray ng Borax (0.1-0.2%)',
        'Maglagay ng Borax sa lupa (1-2 kg/ha)',
        'Gumamit ng Solubor para sa foliar application',
        'I-adjust ang pH ng lupa kung kinakailangan',
        'Tamang irrigation management',
      ],
      preventions: [
        'Regular na soil at tissue testing',
        'Annual boron application kung kinakailangan',
        'Panatilihin ang organic matter sa lupa',
        'Tamang pH management',
        'Balanseng micronutrient program',
      ],
      severity: 'Malubha',
    ),

    // Manganese Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Manganese (Mn)',
      nutrient: 'Manganese',
      description: 'Ang manganese ay mahalaga para sa photosynthesis at enzyme activation. Ang kakulangan nito ay nagdudulot ng chlorosis sa mga bagong dahon.',
      symptoms: [
        'Interveinal chlorosis sa mga bagong dahon',
        'Grayish-green na kulay ng mga dahon',
        'Necrotic spots sa mga dahon',
        'Mahinang paglaki',
        'Nabawasan ang produksyon ng bunga',
      ],
      causes: [
        'Mataas na pH ng lupa (>6.5)',
        'Sandy soils na may mababang organic matter',
        'Sobrang lime application',
        'Mahinang daluyan ng lupa',
        'Mataas na iron o zinc',
      ],
      treatments: [
        'Mag-foliar spray ng manganese sulfate (0.5%)',
        'Maglagay ng manganese sulfate sa lupa',
        'Babaan ang pH ng lupa gamit ang sulfur',
        'Gumamit ng acidifying fertilizers',
        'Pagbutihin ang daluyan ng lupa',
      ],
      preventions: [
        'Panatilihin ang pH ng lupa sa 4.5-5.5',
        'Regular na tissue testing',
        'Balanseng micronutrient program',
        'Iwasan ang sobrang liming',
        'Pagdagdag ng organic matter',
      ],
      severity: 'Banayad',
    ),

    // Copper Deficiency
    NutrientDeficiencyInfo(
      name: 'Kakulangan sa Copper (Cu)',
      nutrient: 'Copper',
      description: 'Ang copper ay mahalaga para sa enzyme function at lignin formation. Ang kakulangan nito ay bihira ngunit puwedeng mangyari sa organic soils.',
      symptoms: [
        'Pagkasira ng mga bagong dahon',
        'Wilting ng mga bagong dahon',
        'Maputlang berdeng kulay',
        'Mahinang pagbuo ng bunga',
        'Dieback ng mga shoots',
        'Mga dahon ay nananatiling nakasara',
      ],
      causes: [
        'Organic soils (peat soils)',
        'Sandy soils na may mababang organic matter',
        'Mataas na pH ng lupa',
        'Sobrang nitrogen, phosphorus, o zinc',
        'Heavy leaching',
      ],
      treatments: [
        'Mag-foliar spray ng copper sulfate (0.1%)',
        'Maglagay ng copper sulfate sa lupa (2-5 kg/ha)',
        'Gumamit ng copper chelate',
        'I-adjust ang pH kung kinakailangan',
        'Bawasan ang sobrang N o P application',
      ],
      preventions: [
        'Regular na soil testing',
        'Balanseng fertilizer program',
        'Panatilihin ang tamang pH',
        'Iwasan ang sobrang nitrogen',
        'Periodic copper application sa organic soils',
      ],
      severity: 'Banayad',
    ),
  ];

  /// Get deficiency info by name
  static NutrientDeficiencyInfo? getDeficiency(String name) {
    for (final deficiency in deficiencies) {
      if (deficiency.name.toLowerCase().contains(name.toLowerCase()) ||
          deficiency.nutrient.toLowerCase().contains(name.toLowerCase())) {
        return deficiency;
      }
    }
    return null;
  }

  /// Get all deficiency names
  static List<String> getDeficiencyNames() {
    return deficiencies.map((d) => d.name).toList();
  }
}
