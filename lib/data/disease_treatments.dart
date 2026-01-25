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
    // ==================== FROM LABELS.TXT ====================
    
    'Base (Butt) Rot': DiseaseInfo(
      name: 'Base (Butt) Rot - Bulok sa Puno',
      description: 'Isang sakit na dulot ng fungus na Thielaviopsis paradoxa o Chalara paradoxa na umaatake sa base ng halaman ng pinya, na nagdudulot ng pagkabulok mula sa ibaba.',
      symptoms: [
        'Itim hanggang kayumangging pagbabago sa base ng tangkay',
        'Malambot na pagkabulok sa ibaba ng halaman',
        'Paninilaw ng mga mababang dahon',
        'Mabahong amoy ng nabubulok',
        'Madaling matumba ang halaman',
      ],
      causes: [
        'Thielaviopsis paradoxa fungus',
        'Kontaminadong lupa o materyal na itatanim',
        'Mga sugat sa base ng halaman',
        'Mahinang daluyan ng tubig',
        'Sobrang kahalumigmigan',
      ],
      treatments: [
        'Alisin at sirain ang mga apektadong halaman',
        'Maglagay ng fungicide sa lupa (Thiabendazole)',
        'Pagbutihin ang daluyan ng tubig',
        'I-disinfect ang mga kagamitan',
        'Gumamit ng hot water treatment sa suhi bago itanim',
      ],
      preventions: [
        'Gumamit ng malinis na materyal na itatanim',
        'Iwasan ang sugat sa base ng halaman',
        'Tiyakin ang tamang daluyan ng tubig',
        'I-disinfect ang mga kagamitan',
        'Iwasan ang sobrang pagdidilig',
      ],
      severity: 'Mataas',
    ),
    
    'Fruit Rot by Yeast and Candida Species': DiseaseInfo(
      name: 'Fruit Rot by Yeast - Bulok ng Bunga',
      description: 'Isang sakit na dulot ng mga yeast at Candida species na umaatake sa bunga ng pinya, lalo na pagkatapos ng pag-aani.',
      symptoms: [
        'Malambot na bahagi sa balat ng bunga',
        'Puting hanggang cream na kulay na paglaki ng fungus',
        'Mabahong amoy ng pag-ferment',
        'Pagkakaroon ng likido sa loob ng bunga',
        'Mabilis na pagkasira ng bunga',
      ],
      causes: [
        'Yeast at Candida species',
        'Mga sugat sa bunga habang nag-aani',
        'Mainit at mahalumigmig na imbakan',
        'Kontaminadong mga kagamitan',
        'Hindi tamang post-harvest handling',
      ],
      treatments: [
        'Alisin agad ang mga apektadong bunga',
        'Ilubog sa fungicide solution ang mga bunga bago i-store',
        'Palamig kaagad ang mga na-harvest na bunga',
        'Panatilihin ang malamig na temperatura sa storage',
      ],
      preventions: [
        'Mag-ingat sa pag-aani para maiwasan ang sugat',
        'Gumamit ng malinis na mga kagamitan',
        'Palamig kaagad ang mga na-harvest',
        'Tiyakin ang proper ventilation sa storage',
        'Gumamit ng post-harvest fungicide treatment',
      ],
      severity: 'Katamtaman',
    ),
    
    'Fruitlet Core Rot (Green Eye)': DiseaseInfo(
      name: 'Fruitlet Core Rot - Green Eye',
      description: 'Isang sakit na nagdudulot ng pagkabulok sa gitna ng mga fruitlets ng pinya, na kilala rin bilang "green eye" dahil sa berdeng kulay ng apektadong bahagi.',
      symptoms: [
        'Berdeng kulay sa gitna ng fruitlet (green eye)',
        'Malambot na bahagi sa loob ng bunga',
        'Kayumangging pagbabago ng kulay sa gitna',
        'Mabahong amoy kapag binuksan',
        'Hindi pantay ang hinog ng bunga',
      ],
      causes: [
        'Penicillium funiculosum at iba pang fungi',
        'Impeksyon sa panahon ng pamumulaklak',
        'Mahalumigmig na kondisyon',
        'Pinsala ng insekto sa mga bulaklak',
      ],
      treatments: [
        'Alisin ang mga apektadong bunga',
        'Mag-spray ng fungicide sa panahon ng pamumulaklak',
        'Kontrolin ang mga insekto',
        'Pagbutihin ang air circulation',
      ],
      preventions: [
        'Mag-spray ng protektanteng fungicide sa pamumulaklak',
        'Kontrolin ang populasyon ng insekto',
        'Iwasan ang overhead irrigation sa pamumulaklak',
        'Panatilihin ang tamang spacing ng mga halaman',
      ],
      severity: 'Katamtaman',
    ),
    
    'Fusariosis': DiseaseInfo(
      name: 'Fusariosis',
      description: 'Isang sakit na dulot ng Fusarium guttiforme na umaatake sa iba\'t ibang bahagi ng pinya at nagdudulot ng fruitlet core rot at iba pang sintomas.',
      symptoms: [
        'Kayumangging pagbabago ng kulay sa fruitlets',
        'Pagkabulok ng gitna ng bunga',
        'Gummy exudation mula sa apektadong bahagi',
        'Paninilaw at panlalanta ng mga dahon',
        'Hindi normal na hugis ng bunga',
      ],
      causes: [
        'Fusarium guttiforme fungus',
        'Impeksyon sa mga bulaklak at fruitlets',
        'Kontaminadong materyal na itatanim',
        'Pinsala ng insekto',
      ],
      treatments: [
        'Alisin ang mga apektadong halaman at bunga',
        'Maglagay ng fungicides (Carbendazim)',
        'Kontrolin ang mga insekto',
        'Ilubog ang suhi sa fungicide bago itanim',
      ],
      preventions: [
        'Gumamit ng disease-free na materyal',
        'Kontrolin ang mga insekto sa bukid',
        'Mag-spray ng protektanteng fungicide',
        'Panatilihin ang kalinisan sa bukid',
      ],
      severity: 'Mataas',
    ),
    
    'Green Fruit Rot': DiseaseInfo(
      name: 'Green Fruit Rot - Bulok ng Berdeng Bunga',
      description: 'Isang sakit na umaatake sa mga berdeng bunga ng pinya na nagdudulot ng pagkabulok bago pa man hinog.',
      symptoms: [
        'Malambot na bahagi sa berdeng bunga',
        'Kayumangging hanggang itim na mantsa',
        'Pagkakaroon ng malamig at basa na hitsura',
        'Mabilis na pagkalat ng bulok',
        'Mabahong amoy',
      ],
      causes: [
        'Iba\'t ibang fungal pathogens',
        'Mga sugat sa bunga',
        'Sobrang halumigmig',
        'Mahinang air circulation',
      ],
      treatments: [
        'Alisin ang mga apektadong bunga',
        'Mag-spray ng fungicide',
        'Pagbutihin ang air circulation',
        'Bawasan ang irrigation',
      ],
      preventions: [
        'Iwasan ang pinsala sa bunga',
        'Regular na mag-spray ng protektanteng fungicide',
        'Panatilihin ang tamang spacing',
        'Kontrolin ang halumigmig',
      ],
      severity: 'Katamtaman',
    ),
    
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
    
    'Interfruit Corking': DiseaseInfo(
      name: 'Interfruit Corking',
      description: 'Isang kondisyon kung saan may cork-like na tissue na nabubuo sa pagitan ng mga fruitlets ng pinya.',
      symptoms: [
        'Kayumangging cork-like na tissue sa pagitan ng fruitlets',
        'Magaspang na texture sa ibabaw ng bunga',
        'Hindi pantay ang paglaki ng fruitlets',
        'Matigas na bahagi sa loob ng bunga',
      ],
      causes: [
        'Stress sa halaman dahil sa temperatura',
        'Hindi pantay na moisture',
        'Kakulangan sa nutrisyon',
        'Pinsala ng insekto',
      ],
      treatments: [
        'Wala nang magagawa kapag nagkaroon na ng corking',
        'Ang mga bunga ay pwede pa ring kainin pero may apektadong texture',
        'Pagbutihin ang kondisyon ng halaman para sa susunod na ani',
      ],
      preventions: [
        'Panatilihin ang consistent na irrigation',
        'Magbigay ng sapat na nutrisyon',
        'Kontrolin ang mga insekto',
        'Protektahan mula sa extreme temperatures',
      ],
      severity: 'Mababa',
    ),
    
    'Leathery Pocket': DiseaseInfo(
      name: 'Leathery Pocket',
      description: 'Isang kondisyon kung saan may bahagi ng bunga na hindi naghihinog at nananatiling matigas at makunat.',
      symptoms: [
        'Matigas at makunat na bahagi ng bunga',
        'Hindi naghihinog ang ilang fruitlets',
        'Kulay na mas mapusyaw kaysa normal',
        'Parang katad ang texture',
      ],
      causes: [
        'Hindi kompleto ang polinasyon',
        'Stress sa halaman',
        'Environmental factors',
        'Genetic predisposition',
      ],
      treatments: [
        'Wala nang magagawa kapag nagkaroon na',
        'Alisin ang apektadong bahagi bago kainin',
        'Ang malusog na bahagi ay safe pa ring kainin',
      ],
      preventions: [
        'Tiyakin ang tamang polinasyon',
        'Iwasan ang stress sa halaman',
        'Panatilihin ang optimal na kondisyon ng paglaki',
      ],
      severity: 'Mababa',
    ),
    
    'Marbling': DiseaseInfo(
      name: 'Marbling',
      description: 'Isang kondisyon kung saan may marble-like na pattern ang flesh ng pinya dahil sa internal browning.',
      symptoms: [
        'Marble-like na kayumanggi at puting pattern sa flesh',
        'Hindi pantay ang kulay ng laman ng bunga',
        'Matigas ang ilang bahagi',
        'Nabawasan ang tamis',
      ],
      causes: [
        'Chilling injury - nalamigan',
        'Storage sa masyadong malamig na temperatura',
        'Post-harvest stress',
        'Genetic factors',
      ],
      treatments: [
        'Alisin ang apektadong bahagi',
        'I-adjust ang storage temperature',
        'Ang malusog na bahagi ay safe pa ring kainin',
      ],
      preventions: [
        'Iwasan ang storage na mas mababa sa 7°C',
        'Proper post-harvest handling',
        'Iwasan ang sudden temperature changes',
      ],
      severity: 'Mababa',
    ),
    
    'Mealybug Wilt Disease': DiseaseInfo(
      name: 'Mealybug Wilt Disease - Lanta Dulot ng Mealybug',
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
    
    'Phytophthora Heart (Top) Rot': DiseaseInfo(
      name: 'Phytophthora Heart (Top) Rot - Bulok sa Puso',
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
    
    'Phytophthora Root Rot': DiseaseInfo(
      name: 'Phytophthora Root Rot - Bulok sa Ugat',
      description: 'Isang sakit na dulot ng Phytophthora species na umaatake sa mga ugat ng pinya, na nagdudulot ng pagkabulok at panlalanta.',
      symptoms: [
        'Paninilaw at panlalanta ng mga dahon',
        'Kayumangging at bulok na mga ugat',
        'Hindi normal ang paglaki',
        'Pagkatumba ng halaman',
        'Mabahong amoy sa ugat',
      ],
      causes: [
        'Phytophthora cinnamomi o P. nicotianae',
        'Basa at mahinang daluyan ng tubig sa lupa',
        'Kontaminadong lupa',
        'Sobrang pagdidilig',
      ],
      treatments: [
        'Alisin ang mga apektadong halaman',
        'Maglagay ng fungicide sa lupa (Metalaxyl)',
        'Pagbutihin ang daluyan ng tubig',
        'Bawasan ang irrigation',
      ],
      preventions: [
        'Tiyakin ang tamang daluyan ng tubig',
        'Iwasan ang waterlogging',
        'Gumamit ng disease-free na materyal',
        'Magtanim sa raised beds kung kinakailangan',
      ],
      severity: 'Kritikal',
    ),
    
    'Pink Disease': DiseaseInfo(
      name: 'Pink Disease',
      description: 'Isang sakit na dulot ng Pantoea citrea na nagdudulot ng pink na pagbabago ng kulay sa flesh ng pinya.',
      symptoms: [
        'Pink hanggang light brown na kulay ng flesh',
        'Malambot na texture ng apektadong bahagi',
        'Hindi normal na amoy',
        'Pagbabago ng lasa',
      ],
      causes: [
        'Pantoea citrea (dating Erwinia herbicola)',
        'Impeksyon sa pamamagitan ng mga sugat',
        'Kontaminadong kagamitan sa pag-aani',
        'Mahinang post-harvest handling',
      ],
      treatments: [
        'Alisin ang mga apektadong bunga',
        'I-sanitize ang mga kagamitan',
        'Proper post-harvest handling',
      ],
      preventions: [
        'Mag-ingat sa pag-aani para maiwasan ang sugat',
        'Linisin ang mga kagamitan',
        'Quick cooling pagkatapos ng pag-aani',
        'Proper storage conditions',
      ],
      severity: 'Katamtaman',
    ),
    
    'Water Blister': DiseaseInfo(
      name: 'Water Blister',
      description: 'Isang kondisyon kung saan may water-soaked na mga bahagi sa flesh ng pinya.',
      symptoms: [
        'Water-soaked na hitsura ng flesh',
        'Translucent na bahagi sa loob ng bunga',
        'Malambot na texture',
        'Pagtagas ng likido kapag pinutol',
      ],
      causes: [
        'Sobrang tubig sa lupa',
        'Mabilis na pag-absorb ng tubig bago ang pag-aani',
        'Mabigat na ulan bago mag-harvest',
        'Genetic predisposition',
      ],
      treatments: [
        'Alisin ang apektadong bahagi',
        'Ang malusog na bahagi ay safe kainin',
        'I-adjust ang irrigation schedule',
      ],
      preventions: [
        'Bawasan ang tubig 1-2 linggo bago mag-harvest',
        'Iwasan ang pag-aani pagkatapos ng mabigat na ulan',
        'Proper drainage sa bukid',
      ],
      severity: 'Mababa',
    ),
    
    'White Leaf Spot': DiseaseInfo(
      name: 'White Leaf Spot - Puting Mantsa sa Dahon',
      description: 'Isang sakit na dulot ng fungus na nagdudulot ng mga puting mantsa sa mga dahon ng pinya.',
      symptoms: [
        'Mga maliliit na puting mantsa sa dahon',
        'Pagkalat ng mga mantsa habang tumatagal',
        'Pagkatuyo ng apektadong bahagi',
        'Panghihina ng dahon',
      ],
      causes: [
        'Fungal infection (Chalara species)',
        'Mahalumigmig na kondisyon',
        'Mahinang air circulation',
        'Overcrowding ng mga halaman',
      ],
      treatments: [
        'Mag-spray ng fungicide (Mancozeb, Copper-based)',
        'Alisin ang malubhang apektadong dahon',
        'Pagbutihin ang air circulation',
      ],
      preventions: [
        'Tamang spacing ng mga halaman',
        'Regular na pagsusuri ng mga dahon',
        'Protektanteng fungicide spray',
        'Iwasan ang overhead irrigation',
      ],
      severity: 'Katamtaman',
    ),
    
    'Yellow Spot': DiseaseInfo(
      name: 'Yellow Spot - Dilaw na Mantsa',
      description: 'Isang sakit na dulot ng virus na nagdudulot ng mga dilaw na mantsa at pagbabago ng kulay sa mga dahon ng pinya.',
      symptoms: [
        'Mga dilaw na mantsa sa dahon',
        'Chlorotic streaking',
        'Hindi normal na paglaki',
        'Pagliit ng bunga',
      ],
      causes: [
        'Pineapple mealybug wilt-associated virus',
        'Naipapadala ng mealybugs',
        'Kontaminadong materyal na itatanim',
      ],
      treatments: [
        'Kontrolin ang mealybug population',
        'Alisin ang malubhang apektadong halaman',
        'Gamutin ng insecticides',
      ],
      preventions: [
        'Gumamit ng virus-free na materyal',
        'Kontrolin ang mealybugs at ants',
        'Regular na pagsusuri ng halaman',
        'I-quarantine ang mga bagong halaman',
      ],
      severity: 'Mataas',
    ),

    // ==================== EXISTING VARIATIONS ====================
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
