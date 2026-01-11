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
      name: 'Healthy Pineapple',
      description: 'Your pineapple plant appears to be in good health with no visible signs of disease.',
      symptoms: [
        'Vibrant green leaves',
        'Strong central stem',
        'No discoloration',
        'Normal growth pattern',
      ],
      causes: [],
      treatments: [
        'Continue regular care routine',
        'Maintain proper watering schedule',
        'Ensure adequate sunlight',
        'Apply balanced fertilizer monthly',
      ],
      preventions: [
        'Regular inspection of leaves',
        'Proper drainage in soil',
        'Avoid overwatering',
        'Keep area clean from debris',
      ],
      severity: 'None',
    ),
    // Variations of Phytophthora Heart Rot
    'Phytophthora Heart Rot': DiseaseInfo(
      name: 'Phytophthora Heart Rot (Top Rot)',
      description: 'A serious fungal disease caused by Phytophthora species that affects the heart of the pineapple plant, causing rotting from the center.',
      symptoms: [
        'Yellowing of central leaves',
        'Soft, water-soaked appearance at base',
        'Foul odor from rotting tissue',
        'Easy detachment of central leaves',
        'Brown to black discoloration inside',
      ],
      causes: [
        'Phytophthora cinnamomi or P. nicotianae fungi',
        'Excessive soil moisture',
        'Poor drainage conditions',
        'Contaminated planting material',
        'Warm, humid weather',
      ],
      treatments: [
        'Remove and destroy infected plants immediately',
        'Apply fungicide (Metalaxyl or Fosetyl-Al)',
        'Improve soil drainage',
        'Reduce irrigation frequency',
        'Apply copper-based fungicides preventively',
        'Treat surrounding plants as precaution',
      ],
      preventions: [
        'Use disease-free planting material',
        'Ensure proper soil drainage',
        'Avoid overhead irrigation',
        'Plant in raised beds if drainage is poor',
        'Rotate crops regularly',
        'Sanitize tools between plants',
      ],
      severity: 'Critical',
    ),
    'Phytophthora Heart Rot (Top Rot)': DiseaseInfo(
      name: 'Phytophthora Heart Rot (Top Rot)',
      description: 'A serious fungal disease caused by Phytophthora species that affects the heart of the pineapple plant, causing rotting from the center.',
      symptoms: [
        'Yellowing of central leaves',
        'Soft, water-soaked appearance at base',
        'Foul odor from rotting tissue',
        'Easy detachment of central leaves',
        'Brown to black discoloration inside',
      ],
      causes: [
        'Phytophthora cinnamomi or P. nicotianae fungi',
        'Excessive soil moisture',
        'Poor drainage conditions',
        'Contaminated planting material',
        'Warm, humid weather',
      ],
      treatments: [
        'Remove and destroy infected plants immediately',
        'Apply fungicide (Metalaxyl or Fosetyl-Al)',
        'Improve soil drainage',
        'Reduce irrigation frequency',
        'Apply copper-based fungicides preventively',
        'Treat surrounding plants as precaution',
      ],
      preventions: [
        'Use disease-free planting material',
        'Ensure proper soil drainage',
        'Avoid overhead irrigation',
        'Plant in raised beds if drainage is poor',
        'Rotate crops regularly',
        'Sanitize tools between plants',
      ],
      severity: 'Critical',
    ),
    'Top Rot': DiseaseInfo(
      name: 'Phytophthora Heart Rot (Top Rot)',
      description: 'A serious fungal disease caused by Phytophthora species that affects the heart of the pineapple plant, causing rotting from the center.',
      symptoms: [
        'Yellowing of central leaves',
        'Soft, water-soaked appearance at base',
        'Foul odor from rotting tissue',
        'Easy detachment of central leaves',
        'Brown to black discoloration inside',
      ],
      causes: [
        'Phytophthora cinnamomi or P. nicotianae fungi',
        'Excessive soil moisture',
        'Poor drainage conditions',
        'Contaminated planting material',
        'Warm, humid weather',
      ],
      treatments: [
        'Remove and destroy infected plants immediately',
        'Apply fungicide (Metalaxyl or Fosetyl-Al)',
        'Improve soil drainage',
        'Reduce irrigation frequency',
        'Apply copper-based fungicides preventively',
        'Treat surrounding plants as precaution',
      ],
      preventions: [
        'Use disease-free planting material',
        'Ensure proper soil drainage',
        'Avoid overhead irrigation',
        'Plant in raised beds if drainage is poor',
        'Rotate crops regularly',
        'Sanitize tools between plants',
      ],
      severity: 'Critical',
    ),
    'Bacterial Heart Rot': DiseaseInfo(
      name: 'Bacterial Heart Rot',
      description: 'A bacterial disease caused by Erwinia chrysanthemi that leads to soft rot of the pineapple heart and can spread rapidly in warm conditions.',
      symptoms: [
        'Water-soaked lesions on leaves',
        'Soft, mushy heart tissue',
        'Strong foul smell',
        'Olive-green to brown discoloration',
        'Rapid wilting of central leaves',
      ],
      causes: [
        'Erwinia chrysanthemi bacteria',
        'Wounds from insects or mechanical damage',
        'High humidity and temperature',
        'Contaminated water or tools',
        'Poor field sanitation',
      ],
      treatments: [
        'Remove infected plants immediately',
        'Do NOT compost - burn or bury deeply',
        'Apply copper-based bactericides',
        'Reduce watering to limit spread',
        'Treat cuts with bactericide',
        'Isolate healthy plants from infected area',
      ],
      preventions: [
        'Use certified disease-free suckers',
        'Avoid wounding plants during cultivation',
        'Control insect pests',
        'Maintain good field drainage',
        'Sanitize cutting tools with bleach solution',
        'Avoid working in wet conditions',
      ],
      severity: 'Critical',
    ),
    'Mealybug Wilt': DiseaseInfo(
      name: 'Mealybug Wilt',
      description: 'A viral disease transmitted by mealybugs that causes progressive wilting and eventual death of pineapple plants.',
      symptoms: [
        'Reddening of leaves',
        'Leaf tips curling downward',
        'Progressive wilting from outer leaves',
        'Stunted plant growth',
        'Root system deterioration',
        'Presence of mealybugs on plant',
      ],
      causes: [
        'Pineapple mealybug wilt-associated virus (PMWaV)',
        'Transmitted by pink and gray mealybugs',
        'Ant farming of mealybugs',
        'Infected planting material',
      ],
      treatments: [
        'Control mealybug populations with insecticides',
        'Eliminate ant colonies that farm mealybugs',
        'Remove severely infected plants',
        'Apply systemic insecticides (Imidacloprid)',
        'Use insecticidal soap for light infestations',
        'Introduce natural predators (ladybugs, lacewings)',
      ],
      preventions: [
        'Use virus-free planting material',
        'Regular inspection for mealybugs',
        'Control ant populations in field',
        'Maintain plant health with proper nutrition',
        'Remove weeds that harbor mealybugs',
        'Quarantine new plants before introduction',
      ],
      severity: 'High',
    ),
    'Fusarium Wilt': DiseaseInfo(
      name: 'Fusarium Wilt (Base Rot)',
      description: 'A soil-borne fungal disease caused by Fusarium species that attacks the base and roots of pineapple plants.',
      symptoms: [
        'Yellowing of lower leaves',
        'Wilting despite adequate water',
        'Brown discoloration at stem base',
        'Dry rot of roots',
        'Plant toppling over',
        'Vascular browning when stem is cut',
      ],
      causes: [
        'Fusarium oxysporum or F. subglutinans fungi',
        'Contaminated soil',
        'Infected planting material',
        'Mechanical wounds at plant base',
        'Nematode damage facilitating entry',
      ],
      treatments: [
        'Remove and destroy infected plants',
        'Apply fungicides (Carbendazim, Thiophanate-methyl)',
        'Solarize soil before replanting',
        'Improve soil drainage',
        'Apply Trichoderma bio-fungicide',
        'Avoid planting in same area for 2-3 years',
      ],
      preventions: [
        'Use disease-free planting material',
        'Treat planting material with fungicide dip',
        'Control nematodes in soil',
        'Maintain proper soil pH (4.5-5.5)',
        'Avoid injury to plant base',
        'Practice crop rotation',
      ],
      severity: 'High',
    ),
    'Fusarium Wilt (Base Rot)': DiseaseInfo(
      name: 'Fusarium Wilt (Base Rot)',
      description: 'A soil-borne fungal disease caused by Fusarium species that attacks the base and roots of pineapple plants.',
      symptoms: [
        'Yellowing of lower leaves',
        'Wilting despite adequate water',
        'Brown discoloration at stem base',
        'Dry rot of roots',
        'Plant toppling over',
        'Vascular browning when stem is cut',
      ],
      causes: [
        'Fusarium oxysporum or F. subglutinans fungi',
        'Contaminated soil',
        'Infected planting material',
        'Mechanical wounds at plant base',
        'Nematode damage facilitating entry',
      ],
      treatments: [
        'Remove and destroy infected plants',
        'Apply fungicides (Carbendazim, Thiophanate-methyl)',
        'Solarize soil before replanting',
        'Improve soil drainage',
        'Apply Trichoderma bio-fungicide',
        'Avoid planting in same area for 2-3 years',
      ],
      preventions: [
        'Use disease-free planting material',
        'Treat planting material with fungicide dip',
        'Control nematodes in soil',
        'Maintain proper soil pH (4.5-5.5)',
        'Avoid injury to plant base',
        'Practice crop rotation',
      ],
      severity: 'High',
    ),
    'Base Rot': DiseaseInfo(
      name: 'Fusarium Wilt (Base Rot)',
      description: 'A soil-borne fungal disease caused by Fusarium species that attacks the base and roots of pineapple plants.',
      symptoms: [
        'Yellowing of lower leaves',
        'Wilting despite adequate water',
        'Brown discoloration at stem base',
        'Dry rot of roots',
        'Plant toppling over',
        'Vascular browning when stem is cut',
      ],
      causes: [
        'Fusarium oxysporum or F. subglutinans fungi',
        'Contaminated soil',
        'Infected planting material',
        'Mechanical wounds at plant base',
        'Nematode damage facilitating entry',
      ],
      treatments: [
        'Remove and destroy infected plants',
        'Apply fungicides (Carbendazim, Thiophanate-methyl)',
        'Solarize soil before replanting',
        'Improve soil drainage',
        'Apply Trichoderma bio-fungicide',
        'Avoid planting in same area for 2-3 years',
      ],
      preventions: [
        'Use disease-free planting material',
        'Treat planting material with fungicide dip',
        'Control nematodes in soil',
        'Maintain proper soil pH (4.5-5.5)',
        'Avoid injury to plant base',
        'Practice crop rotation',
      ],
      severity: 'High',
    ),
    'Model not loaded': DiseaseInfo(
      name: 'Model Not Loaded',
      description: 'The ML model is not yet loaded. Please add your trained model files to the assets/models/ folder.',
      symptoms: [],
      causes: [
        'disease_model.tflite not found',
        'Model files not in correct location',
      ],
      treatments: [
        'Add disease_model.tflite to assets/models/',
        'Add labels.txt with disease names',
        'Run flutter pub get',
        'Restart the application',
      ],
      preventions: [],
      severity: 'None',
    ),
    'Tap camera to scan': DiseaseInfo(
      name: 'Ready to Scan',
      description: 'Tap the camera view to capture an image of your pineapple plant for analysis.',
      symptoms: [],
      causes: [],
      treatments: [
        'Position the camera to capture the pineapple clearly',
        'Ensure good lighting',
        'Tap the camera view to capture',
        'Wait for analysis results',
      ],
      preventions: [],
      severity: 'None',
    ),
    'Analysis Error': DiseaseInfo(
      name: 'Analysis Error',
      description: 'An error occurred while analyzing the image. Please try again.',
      symptoms: [],
      causes: [
        'Image processing failed',
        'Model inference error',
        'Insufficient memory',
      ],
      treatments: [
        'Try capturing the image again',
        'Ensure the image is clear and well-lit',
        'Restart the app if problem persists',
      ],
      preventions: [],
      severity: 'None',
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
      description: 'Information for this condition is not yet available in our database.',
      symptoms: ['No data available'],
      causes: ['Unknown'],
      treatments: ['Consult a local agricultural expert for advice'],
      preventions: ['Regular plant inspection recommended'],
      severity: 'Unknown',
    );
  }
}
