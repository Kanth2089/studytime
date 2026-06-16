import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../domain/book_model.dart';

class BookPdfViewerScreen extends StatefulWidget {
  final BookModel book;

  const BookPdfViewerScreen({super.key, required this.book});

  @override
  State<BookPdfViewerScreen> createState() => _BookPdfViewerScreenState();
}

class _BookPdfViewerScreenState extends State<BookPdfViewerScreen> {
  int _currentPage = 1;
  final int _totalPages = 5;

  // Bilingual content pages depending on category
  final Map<String, List<Map<String, String>>> _mockBookContent = {
    'Police': [
      {
        'en': 'Chapter 1: Principles of Policing\n\nThe fundamental mission of the police is to prevent crime and disorder. In democratic systems, police officers are civil servants responsible for enforcing laws, protecting life, and safeguarding individual rights. Under the Indian Penal Code (IPC), police duties include registration of First Information Reports (FIR) and prompt crime investigation.',
        'te': 'అధ్యాయం 1: పోలీసింగ్ సూత్రాలు\n\nనేరం మరియు రుగ్మతలను నివారించడం పోలీస్ వ్యవస్థ యొక్క ప్రాథమిక లక్ష్యం. ప్రజాస్వామ్య వ్యవస్థలో, పోలీస్ అధికారులు చట్టాలను అమలు చేయడానికి, ప్రాణాలను రక్షించడానికి మరియు వ్యక్తిగత హక్కులను కాపాడటానికి బాధ్యత వహించే సివిల్ సర్వెంట్లు. ఇండియన్ పీనల్ కోడ్ (IPC) ప్రకారం పోలీస్ విధుల్లో ఎఫ్.ఐ.ఆర్ (FIR) నమోదు మరియు నేర పరిశోధన ముఖ్యమైనవి.'
      },
      {
        'en': 'Chapter 2: Criminal Law Basics\n\nThe Code of Criminal Procedure (CrPC) regulates the process for investigation of crimes, arrest of suspects, collection of evidence, and determination of guilt. Crucial sections include Section 41 (arrest without warrant) and Section 154 (first information reports). Learn these parameters for the exam.',
        'te': 'అధ్యాయం 2: క్రిమినల్ లా ప్రాథమికాంశాలు\n\nనేరాల దర్యాప్తు, నిందితుల అరెస్టు, సాక్ష్యాల సేకరణ మరియు నేర నిర్ధారణ ప్రక్రియలను క్రిమినల్ ప్రొసీజర్ కోడ్ (CrPC) క్రమబద్ధీకరిస్తుంది. ముఖ్యమైన సెక్షన్లలో సెక్షన్ 41 (వారెంట్ లేకుండా అరెస్టు) మరియు సెక్షన్ 154 (ఎఫ్.ఐ.ఆర్) ఉన్నాయి. పరీక్ష కోసం ఈ అంశాలను నేర్చుకోండి.'
      },
      {
        'en': 'Chapter 3: Indian Penal Code Overview\n\nUnderstanding specific penalties is essential. Key subjects: Crimes against body (IPC 299-377), crimes against property (IPC 378-462), and offenses against public tranquility. Ensure you memorize major chapters.',
        'te': 'అధ్యాయం 3: ఇండియన్ పీనల్ కోడ్ అవలోకనం\n\nనిర్దిష్ట శిక్షలను అర్థం చేసుకోవడం చాలా ముఖ్యం. ముఖ్యమైన సబ్జెక్టులు: మానవ శరీరంపై నేరాలు (IPC 299-377), ఆస్తికి వ్యతిరేకంగా నేరాలు (IPC 378-462), మరియు ప్రజా శాంతికి భంగం కలిగించే నేరాలు. ప్రధాన అధ్యాయాలను గుర్తుంచుకోండి.'
      },
      {
        'en': 'Chapter 4: General Science & Forensic Investigation\n\nForensic science plays a vital role in identifying culprits. Fingerprint analysis, DNA profiling, and toxicology studies are integrated within modern crime solving frameworks under the guidance of court standards.',
        'te': 'అధ్యాయం 4: జనరల్ సైన్స్ & ఫోరెన్సిక్ ఇన్వెస్టిగేషన్\n\nనేరస్థులను గుర్తించడంలో ఫోరెన్సిక్ సైన్స్ కీలక పాత్ర పోషిస్తుంది. ఆధునిక నేర పరిశోధనలో వేలిముద్రల విశ్లేషణ, డి.ఎన్.ఎ (DNA) ప్రొఫైలింగ్ మరియు టాక్సికాలజీ అధ్యయనాలు కోర్టు ప్రమాణాల మార్గదర్శకత్వంలో అనుసంధానించబడ్డాయి.'
      },
      {
        'en': 'Chapter 5: Practice Mock Questions\n\n1. Abetment of suicide is defined under which section of IPC? (Ans: Sec 306)\n2. What is the standard rank of a Police Station officer-in-charge? (Ans: Inspector/Sub-Inspector)',
        'te': 'అధ్యాయం 5: సాధన ప్రశ్నలు\n\n1. ఆత్మహత్యకు ప్రేరేపించడం ఐపిసి (IPC) లోని ఏ సెక్షన్ కింద నిర్వచించబడింది? (జవాబు: సెక్షన్ 306)\n2. పోలీస్ స్టేషన్ ఇన్‌చార్జ్ అధికారి సాధారణ ర్యాంక్ ఏమిటి? (జవాబు: ఇన్‌స్పెక్టర్/సబ్-ఇన్‌స్పెక్టర్)'
      },
    ],
    'Banking': [
      {
        'en': 'Chapter 1: Introduction to Reserve Bank of India\n\nEstablished on April 1, 1935, RBI is the central banking institution of India. Key tasks: Regulating monetary policies, managing foreign reserves, issuing currency, and controlling credit structures using metrics like Repo Rate and CRR.',
        'te': 'అధ్యాయం 1: రిజర్వ్ బ్యాంక్ ఆఫ్ ఇండియా పరిచయం\n\n1935 ఏప్రిల్ 1న స్థాపించబడిన ఆర్‌బీఐ (RBI) భారతదేశపు కేంద్ర బ్యాంకింగ్ సంస్థ. ప్రధాన విధులు: ద్రవ్య విధానాలను క్రమబద్ధీకరించడం, విదేశీ నిల్వలను నిర్వహించడం, కరెన్సీ జారీ చేయడం మరియు రెపో రేట్, సి.ఆర్.ఆర్ (CRR) వంటి కొలతలతో క్రెడిట్ నియంత్రించడం.'
      },
      {
        'en': 'Chapter 2: Financial Markets\n\nCapital markets deal with long-term funds and are regulated by SEBI. Money markets handle short-term money transactions and are overseen by RBI. Treasury bills, commercial papers, and certificates of deposit are primary money instruments.',
        'te': 'అధ్యాయం 2: ఆర్థిక మార్కెట్లు\n\nక్యాపిటల్ మార్కెట్లు దీర్ఘకాలిక నిధులతో వ్యవహరిస్తాయి మరియు సెబీ (SEBI) ద్వారా నియంత్రించబడతాయి. మనీ మార్కెట్లు స్వల్పకాలిక లావాదేవీలను నిర్వహిస్తాయి మరియు ఆర్‌బీఐ పర్యవేక్షిస్తుంది. ట్రెజరీ బిల్లులు, కమర్షియల్ పేపర్లు మనీ మార్కెట్ సాధనాలు.'
      },
      {
        'en': 'Chapter 3: Banking Terminology\n\n- Repo Rate: Rate at which RBI lends money to commercial banks.\n- Reverse Repo: Rate at which banks deposit excess cash with RBI.\n- SLR: Statutory Liquidity Ratio required as liquid assets.',
        'te': 'అధ్యాయం 3: బ్యాంకింగ్ పదజాలం\n\n- రెపో రేట్: ఆర్‌బీఐ వాణిజ్య బ్యాంకులకు అప్పు ఇచ్చే వడ్డీ రేటు.\n- రివర్స్ రెపో: బ్యాంకులు తమ అదనపు నగదును ఆర్‌బీఐ వద్ద జమ చేసే వడ్డీ రేటు.\n- SLR: బ్యాంకులు తమ వద్ద ఉంచుకోవాల్సిన ద్రవ్య నిష్పత్తి.'
      },
      {
        'en': 'Chapter 4: Digital Banking & Cyber Security\n\nModern banking heavily relies on NEFT, RTGS, IMPS, and UPI transactions. Enhancing encryption standards, firewalls, and multi-factor authentication are key tasks in protecting customer transaction data.',
        'te': 'అధ్యాయం 4: డిజిటల్ బ్యాంకింగ్ & సైబర్ సెక్యూరిటీ\n\nఆధునిక బ్యాంకింగ్ అధికంగా నెఫ్ట్ (NEFT), ఆర్.టి.జి.ఎస్ (RTGS), ఐ.ఎమ్.పి.ఎస్ (IMPS) మరియు యు.పి.ఐ (UPI) లావాదేవీలపై ఆధారపడి ఉంది. కస్టమర్ల లావాదేవీలను రక్షించడంలో ఎన్‌క్రిప్షన్, ఫైర్‌వాల్స్ మరియు మల్టీ-ఫ్యాక్టర్ ప్రామాణీకరణలు ప్రధానమైనవి.'
      },
      {
        'en': 'Chapter 5: Key Banking Formulas\n\n1. Assets = Liabilities + Capital\n2. Net Interest Margin = (Interest Earned - Interest Expended) / Average Earning Assets',
        'te': 'అధ్యాయం 5: ముఖ్యమైన బ్యాంకింగ్ సూత్రాలు\n\n1. ఆస్తులు = అప్పులు + మూలధనం\n2. నికర వడ్డీ మార్జిన్ = (ఆర్జించిన వడ్డీ - ఖర్చు చేసిన వడ్డీ) / సగటు ఆదాయ ఆస్తులు'
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    // Fallback to Police content if category content not found
    final String categoryKey = _mockBookContent.containsKey(widget.book.category)
        ? widget.book.category
        : 'Police';

    final pages = _mockBookContent[categoryKey]!;
    final currentPageContent = pages[_currentPage - 1][loc.locale] ?? "Page not available";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.book.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: const [
          LanguageSelector(isCompact: true),
          SizedBox(width: 12),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.bgGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Book info
                  Text(
                    "${widget.book.category} Book - Page $_currentPage of $_totalPages",
                    style: const TextStyle(color: AppColors.skyBlue, fontSize: 13, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Reading paper glass page
                  Expanded(
                    child: GlassContainer(
                      padding: const EdgeInsets.all(24),
                      fillOpacity: 0.12,
                      child: SingleChildScrollView(
                        child: Text(
                          currentPageContent,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Navigation panel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: _currentPage > 1
                            ? () {
                                setState(() {
                                  _currentPage--;
                                });
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(loc.translate('previous')),
                      ),
                      Text(
                        "$_currentPage / $_totalPages",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      OutlinedButton(
                        onPressed: _currentPage < _totalPages
                            ? () {
                                setState(() {
                                  _currentPage++;
                                });
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(loc.translate('next')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
