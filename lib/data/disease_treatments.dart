/// Disease data with treatments
class DiseaseInfo {
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> treatments;
  final List<String> preventions;
  final String severity; // Low, Medium, High, Critical

  const DiseaseInfo({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatments,
    required this.preventions,
    required this.severity,
  });
}

class DiseaseTreatments {
  static const Map<String, DiseaseInfo> diseases = {
    'Healthy': DiseaseInfo(
      name: 'Malusog na Pinya',
      description: 'Ang iyong halaman ng pinya ay mukhang malusog at walang nakikitang palatandaan ng sakit.',
      symptoms: [
        'Matingkad na berdeng dahon',
        'Matibay na gitnang tangkay',
        'Walang pagbabago ng kulay',
        'Normal na paglaki',
      ],
      causes: [],
      treatments: [
        'Ipagpatuloy ang regular na pag-aalaga',
        'Panatilihin ang tamang iskedyul ng pagdidilig',
        'Tiyakin ang sapat na sikat ng araw',
        'Maglagay ng balanseng pataba bawat buwan',
      ],
      preventions: [
        'Regular na pagsusuri ng mga dahon',
        'Tamang daluyan ng tubig sa lupa',
        'Iwasan ang sobrang pagdidilig',
        'Panatilihing malinis ang paligid mula sa mga kalat',
      ],
      severity: 'Wala',
    ),
    // Variations of Phytophthora Heart Rot
    'Phytophthora Heart Rot': DiseaseInfo(
      name: 'Phytophthora Heart Rot (Bulok sa Puso)',
      description: 'Isang malubhang sakit na dulot ng fungus na Phytophthora species na umaatake sa puso ng halaman ng pinya, na nagdudulot ng pagkabulok mula sa gitna.',
      symptoms: [
        'Paninilaw ng mga gitnang dahon',
        'Malambot at parang basa ang hitsura sa ibaba',
        'Mabahong amoy mula sa nabubulok na bahagi',
        'Madaling matanggal ang mga gitnang dahon',
        'Kayumanggi hanggang itim na pagbabago ng kulay sa loob',
      ],
      causes: [
        'Phytophthora cinnamomi o P. nicotianae fungi',
        'Labis na kahalumigmigan ng lupa',
        'Mahinang daluyan ng tubig',
        'Kontaminadong materyal na itatanim',
        'Mainit at mahalumigmig na panahon',
      ],
      treatments: [
        'Alisin at sirain agad ang mga apektadong halaman',
        'Maglagay ng fungicide (Metalaxyl o Fosetyl-Al)',
        'Pagbutihin ang daluyan ng tubig sa lupa',
        'Bawasan ang pagdidilig',
        'Maglagay ng copper-based fungicides bilang pag-iwas',
        'Gamutin din ang mga katabing halaman bilang pag-iingat',
      ],
      preventions: [
        'Gumamit ng materyal na walang sakit',
        'Tiyakin ang tamang daluyan ng tubig sa lupa',
        'Iwasan ang pagdidilig mula sa itaas',
        'Magtanim sa nakataas na lugar kung mahina ang daluyan ng tubig',
        'Regular na pagpapalit ng mga pananim',
        'Linisin ang mga kagamitan sa pagitan ng mga halaman',
      ],
      severity: 'Kritikal',
    ),
    'Phytophthora Heart Rot (Top Rot)': DiseaseInfo(
      name: 'Phytophthora Heart Rot (Bulok sa Puso)',
      description: 'Isang malubhang sakit na dulot ng fungus na Phytophthora species na umaatake sa puso ng halaman ng pinya, na nagdudulot ng pagkabulok mula sa gitna.',
      symptoms: [
        'Paninilaw ng mga gitnang dahon',
        'Malambot at parang basa ang hitsura sa ibaba',
        'Mabahong amoy mula sa nabubulok na bahagi',
        'Madaling matanggal ang mga gitnang dahon',
        'Kayumanggi hanggang itim na pagbabago ng kulay sa loob',
      ],
      causes: [
        'Phytophthora cinnamomi o P. nicotianae fungi',
        'Labis na kahalumigmigan ng lupa',
        'Mahinang daluyan ng tubig',
        'Kontaminadong materyal na itatanim',
        'Mainit at mahalumigmig na panahon',
      ],
      treatments: [
        'Alisin at sirain agad ang mga apektadong halaman',
        'Maglagay ng fungicide (Metalaxyl o Fosetyl-Al)',
        'Pagbutihin ang daluyan ng tubig sa lupa',
        'Bawasan ang pagdidilig',
        'Maglagay ng copper-based fungicides bilang pag-iwas',
        'Gamutin din ang mga katabing halaman bilang pag-iingat',
      ],
      preventions: [
        'Gumamit ng materyal na walang sakit',
        'Tiyakin ang tamang daluyan ng tubig sa lupa',
        'Iwasan ang pagdidilig mula sa itaas',
        'Magtanim sa nakataas na lugar kung mahina ang daluyan ng tubig',
        'Regular na pagpapalit ng mga pananim',
        'Linisin ang mga kagamitan sa pagitan ng mga halaman',
      ],
      severity: 'Kritikal',
    ),
    'Top Rot': DiseaseInfo(
      name: 'Phytophthora Heart Rot (Bulok sa Puso)',
      description: 'Isang malubhang sakit na dulot ng fungus na Phytophthora species na umaatake sa puso ng halaman ng pinya, na nagdudulot ng pagkabulok mula sa gitna.',
      symptoms: [
        'Paninilaw ng mga gitnang dahon',
        'Malambot at parang basa ang hitsura sa ibaba',
        'Mabahong amoy mula sa nabubulok na bahagi',
        'Madaling matanggal ang mga gitnang dahon',
        'Kayumanggi hanggang itim na pagbabago ng kulay sa loob',
      ],
      causes: [
        'Phytophthora cinnamomi o P. nicotianae fungi',
        'Labis na kahalumigmigan ng lupa',
        'Mahinang daluyan ng tubig',
        'Kontaminadong materyal na itatanim',
        'Mainit at mahalumigmig na panahon',
      ],
      treatments: [
        'Alisin at sirain agad ang mga apektadong halaman',
        'Maglagay ng fungicide (Metalaxyl o Fosetyl-Al)',
        'Pagbutihin ang daluyan ng tubig sa lupa',
        'Bawasan ang pagdidilig',
        'Maglagay ng copper-based fungicides bilang pag-iwas',
        'Gamutin din ang mga katabing halaman bilang pag-iingat',
      ],
      preventions: [
        'Gumamit ng materyal na walang sakit',
        'Tiyakin ang tamang daluyan ng tubig sa lupa',
        'Iwasan ang pagdidilig mula sa itaas',
        'Magtanim sa nakataas na lugar kung mahina ang daluyan ng tubig',
        'Regular na pagpapalit ng mga pananim',
        'Linisin ang mga kagamitan sa pagitan ng mga halaman',
      ],
      severity: 'Kritikal',
    ),
    'Bacterial Heart Rot': DiseaseInfo(
      name: 'Bacterial Heart Rot (Bulok na Dulot ng Bakterya)',
      description: 'Isang sakit na dulot ng bakteryang Erwinia chrysanthemi na nagdudulot ng malambot na pagkabulok sa puso ng pinya at mabilis na kumakalat sa mainit na kondisyon.',
      symptoms: [
        'Parang basa na mga marka sa dahon',
        'Malambot at maburak na bahagi ng puso',
        'Malakas na mabahong amoy',
        'Olive-green hanggang kayumangging pagbabago ng kulay',
        'Mabilis na panlalanta ng mga gitnang dahon',
      ],
      causes: [
        'Erwinia chrysanthemi bakterya',
        'Mga sugat mula sa mga insekto o mekanikal na pinsala',
        'Mataas na halumigmig at temperatura',
        'Kontaminadong tubig o mga kagamitan',
        'Mahinang kalinisan sa bukid',
      ],
      treatments: [
        'Alisin agad ang mga apektadong halaman',
        'HUWAG itapon sa compost - sunugin o ilibing nang malalim',
        'Maglagay ng copper-based bactericides',
        'Bawasan ang pagdidilig para mapigilan ang pagkalat',
        'Gamutin ang mga hiwa gamit ang bactericide',
        'Ihiwalay ang mga malusog na halaman mula sa apektadong lugar',
      ],
      preventions: [
        'Gumamit ng certified disease-free na mga suhi',
        'Iwasan ang pagkasugat ng mga halaman habang inaalagaan',
        'Kontrolin ang mga peste na insekto',
        'Panatilihin ang magandang daluyan ng tubig sa bukid',
        'Linisin ang mga kagamitang pangputol gamit ang bleach solution',
        'Iwasan ang pagtrabaho sa basang kondisyon',
      ],
      severity: 'Kritikal',
    ),
    'Mealybug Wilt': DiseaseInfo(
      name: 'Mealybug Wilt (Lanta Dulot ng Mealybug)',
      description: 'Isang sakit na dulot ng virus na naipapadala ng mealybugs na nagdudulot ng progresibong panlalanta at kalaunan ay pagkamatay ng mga halaman ng pinya.',
      symptoms: [
        'Pamumula ng mga dahon',
        'Pagbaluktot pababa ng mga dulo ng dahon',
        'Progresibong panlalanta mula sa mga panlabas na dahon',
        'Hindi normal ang paglaki ng halaman',
        'Pagkasira ng sistema ng ugat',
        'Pagkakaroon ng mealybugs sa halaman',
      ],
      causes: [
        'Pineapple mealybug wilt-associated virus (PMWaV)',
        'Naipapadala ng pink at gray na mealybugs',
        'Pag-aalaga ng mga langgam sa mealybugs',
        'Apektadong materyal na itatanim',
      ],
      treatments: [
        'Kontrolin ang populasyon ng mealybug gamit ang mga insecticides',
        'Puksain ang mga kolonya ng langgam na nag-aalaga ng mealybugs',
        'Alisin ang mga malubhang apektadong halaman',
        'Maglagay ng systemic insecticides (Imidacloprid)',
        'Gumamit ng insecticidal soap para sa magaang impestasyon',
        'Magdagdag ng natural predators (ladybugs, lacewings)',
      ],
      preventions: [
        'Gumamit ng materyal na walang virus',
        'Regular na pagsusuri para sa mealybugs',
        'Kontrolin ang populasyon ng langgam sa bukid',
        'Panatilihin ang kalusugan ng halaman sa tamang nutrisyon',
        'Alisin ang mga damo na pinagtataguan ng mealybugs',
        'I-quarantine ang mga bagong halaman bago isama',
      ],
      severity: 'Mataas',
    ),
    'Fusarium Wilt': DiseaseInfo(
      name: 'Fusarium Wilt (Bulok sa Ugat)',
      description: 'Isang sakit na dulot ng fungus sa lupa na Fusarium species na umaatake sa base at mga ugat ng mga halaman ng pinya.',
      symptoms: [
        'Paninilaw ng mga mababang dahon',
        'Panlalanta kahit sapat ang tubig',
        'Kayumangging pagbabago ng kulay sa base ng tangkay',
        'Tuyo na pagkabulok ng mga ugat',
        'Pagkatumba ng halaman',
        'Kayumangging vascular kapag pinutol ang tangkay',
      ],
      causes: [
        'Fusarium oxysporum o F. subglutinans fungi',
        'Kontaminadong lupa',
        'Apektadong materyal na itatanim',
        'Mekanikal na mga sugat sa base ng halaman',
        'Pinsala ng nematode na nagpapadali ng pagpasok',
      ],
      treatments: [
        'Alisin at sirain ang mga apektadong halaman',
        'Maglagay ng fungicides (Carbendazim, Thiophanate-methyl)',
        'I-solarize ang lupa bago magtanim muli',
        'Pagbutihin ang daluyan ng tubig sa lupa',
        'Maglagay ng Trichoderma bio-fungicide',
        'Iwasan ang pagtatanim sa parehong lugar ng 2-3 taon',
      ],
      preventions: [
        'Gumamit ng materyal na walang sakit',
        'Ilubog ang materyal na itatanim sa fungicide',
        'Kontrolin ang mga nematode sa lupa',
        'Panatilihin ang tamang pH ng lupa (4.5-5.5)',
        'Iwasan ang pagkasugat sa base ng halaman',
        'Magsagawa ng pagpapalit ng mga pananim',
      ],
      severity: 'Mataas',
    ),
    'Fusarium Wilt (Base Rot)': DiseaseInfo(
      name: 'Fusarium Wilt (Bulok sa Ugat)',
      description: 'Isang sakit na dulot ng fungus sa lupa na Fusarium species na umaatake sa base at mga ugat ng mga halaman ng pinya.',
      symptoms: [
        'Paninilaw ng mga mababang dahon',
        'Panlalanta kahit sapat ang tubig',
        'Kayumangging pagbabago ng kulay sa base ng tangkay',
        'Tuyo na pagkabulok ng mga ugat',
        'Pagkatumba ng halaman',
        'Kayumangging vascular kapag pinutol ang tangkay',
      ],
      causes: [
        'Fusarium oxysporum o F. subglutinans fungi',
        'Kontaminadong lupa',
        'Apektadong materyal na itatanim',
        'Mekanikal na mga sugat sa base ng halaman',
        'Pinsala ng nematode na nagpapadali ng pagpasok',
      ],
      treatments: [
        'Alisin at sirain ang mga apektadong halaman',
        'Maglagay ng fungicides (Carbendazim, Thiophanate-methyl)',
        'I-solarize ang lupa bago magtanim muli',
        'Pagbutihin ang daluyan ng tubig sa lupa',
        'Maglagay ng Trichoderma bio-fungicide',
        'Iwasan ang pagtatanim sa parehong lugar ng 2-3 taon',
      ],
      preventions: [
        'Gumamit ng materyal na walang sakit',
        'Ilubog ang materyal na itatanim sa fungicide',
        'Kontrolin ang mga nematode sa lupa',
        'Panatilihin ang tamang pH ng lupa (4.5-5.5)',
        'Iwasan ang pagkasugat sa base ng halaman',
        'Magsagawa ng pagpapalit ng mga pananim',
      ],
      severity: 'Mataas',
    ),
    'Base Rot': DiseaseInfo(
      name: 'Fusarium Wilt (Bulok sa Ugat)',
      description: 'Isang sakit na dulot ng fungus sa lupa na Fusarium species na umaatake sa base at mga ugat ng mga halaman ng pinya.',
      symptoms: [
        'Paninilaw ng mga mababang dahon',
        'Panlalanta kahit sapat ang tubig',
        'Kayumangging pagbabago ng kulay sa base ng tangkay',
        'Tuyo na pagkabulok ng mga ugat',
        'Pagkatumba ng halaman',
        'Kayumangging vascular kapag pinutol ang tangkay',
      ],
      causes: [
        'Fusarium oxysporum o F. subglutinans fungi',
        'Kontaminadong lupa',
        'Apektadong materyal na itatanim',
        'Mekanikal na mga sugat sa base ng halaman',
        'Pinsala ng nematode na nagpapadali ng pagpasok',
      ],
      treatments: [
        'Alisin at sirain ang mga apektadong halaman',
        'Maglagay ng fungicides (Carbendazim, Thiophanate-methyl)',
        'I-solarize ang lupa bago magtanim muli',
        'Pagbutihin ang daluyan ng tubig sa lupa',
        'Maglagay ng Trichoderma bio-fungicide',
        'Iwasan ang pagtatanim sa parehong lugar ng 2-3 taon',
      ],
      preventions: [
        'Gumamit ng materyal na walang sakit',
        'Ilubog ang materyal na itatanim sa fungicide',
        'Kontrolin ang mga nematode sa lupa',
        'Panatilihin ang tamang pH ng lupa (4.5-5.5)',
        'Iwasan ang pagkasugat sa base ng halaman',
        'Magsagawa ng pagpapalit ng mga pananim',
      ],
      severity: 'Mataas',
    ),
    'Hindi Na-load ang Modelo': DiseaseInfo(
      name: 'Hindi Na-load ang Modelo',
      description: 'Hindi pa na-load ang ML model. Mangyaring idagdag ang iyong trained model files sa assets/models/ folder.',
      symptoms: [],
      causes: [
        'Hindi nahanap ang disease_model.tflite',
        'Wala sa tamang lokasyon ang model files',
      ],
      treatments: [
        'Idagdag ang disease_model.tflite sa assets/models/',
        'Idagdag ang labels.txt na may mga pangalan ng sakit',
        'I-run ang flutter pub get',
        'I-restart ang application',
      ],
      preventions: [],
      severity: 'Wala',
    ),
    'Tap camera to scan': DiseaseInfo(
      name: 'Handa Nang Mag-scan',
      description: 'Pindutin ang camera view para kunan ng larawan ang iyong halaman ng pinya para suriin.',
      symptoms: [],
      causes: [],
      treatments: [
        'Iposisyon ang camera para malinaw na makuha ang pinya',
        'Tiyakin ang magandang ilaw',
        'Pindutin ang camera view para kumuha ng larawan',
        'Hintayin ang mga resulta ng pagsusuri',
      ],
      preventions: [],
      severity: 'Wala',
    ),
    'Pindutin ang camera para mag-scan': DiseaseInfo(
      name: 'Handa Nang Mag-scan',
      description: 'Pindutin ang camera view para kunan ng larawan ang iyong halaman ng pinya para suriin.',
      symptoms: [],
      causes: [],
      treatments: [
        'Iposisyon ang camera para malinaw na makuha ang pinya',
        'Tiyakin ang magandang ilaw',
        'Pindutin ang camera view para kumuha ng larawan',
        'Hintayin ang mga resulta ng pagsusuri',
      ],
      preventions: [],
      severity: 'Wala',
    ),
    'Analysis Error': DiseaseInfo(
      name: 'Error sa Pagsusuri',
      description: 'May naganap na error habang sinusuri ang larawan. Mangyaring subukan muli.',
      symptoms: [],
      causes: [
        'Nabigo ang pagproseso ng larawan',
        'Error sa model inference',
        'Hindi sapat ang memory',
      ],
      treatments: [
        'Subukang kumuha muli ng larawan',
        'Tiyakin na malinaw at may magandang ilaw ang larawan',
        'I-restart ang app kung magpapatuloy ang problema',
      ],
      preventions: [],
      severity: 'Wala',
    ),
  };

  /// Get disease info by name, returns default if not found
  static DiseaseInfo getDisease(String name) {
    // Try exact match first
    if (diseases.containsKey(name)) {
      return diseases[name]!;
    }
    
    // Try partial match
    for (final entry in diseases.entries) {
      if (name.toLowerCase().contains(entry.key.toLowerCase()) ||
          entry.key.toLowerCase().contains(name.toLowerCase())) {
        return entry.value;
      }
    }
    
    // Return default unknown disease
    return DiseaseInfo(
      name: name,
      description: 'Hindi pa available sa aming database ang impormasyon para sa kondisyong ito.',
      symptoms: ['Walang available na datos'],
      causes: ['Hindi alam'],
      treatments: ['Kumonsulta sa lokal na eksperto sa agrikultura para sa payo'],
      preventions: ['Inirerekomenda ang regular na pagsusuri ng halaman'],
      severity: 'Hindi Alam',
    );
  }
}
