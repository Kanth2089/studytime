const ExcelJS = require('exceljs');

async function generateReport(testResults, platform) {
    const workbook = new ExcelJS.Workbook();
    const sheet = workbook.addWorksheet(`${platform} Test Analysis`);

    // Define Columns
    sheet.columns = [
        { header: 'Test Case ID', key: 'id', width: 15 },
        { header: 'Description', key: 'desc', width: 40 },
        { header: 'Category', key: 'category', width: 20 },
        { header: 'Status', key: 'status', width: 15 },
        { header: 'Pass Rate', key: 'rate', width: 15 },
        { header: 'Execution Time (ms)', key: 'time', width: 20 }
    ];

    // Add Mock Data/Results
    testResults.forEach(result => {
        const row = sheet.addRow(result);
        
        // Color coding for status
        const statusCell = row.getCell('status');
        if (result.status === 'Pass') {
            statusCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFC8E6C9' } }; // Green
        } else {
            statusCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFCDD2' } }; // Red
        }
    });

    const filePath = `./reports/${platform}_E2E_Analysis_Report.xlsx`;
    await workbook.xlsx.writeFile(filePath);
    console.log(`✅ Excel Report generated: ${filePath}`);
}

// Updated usage with 20 Comprehensive Test Scenarios
const mockResults = [
    { id: 'TC-WEB-001', desc: 'Web Login: Valid Credentials', category: 'Auth', status: 'Pass', rate: '100%', time: 1542 },
    { id: 'TC-WEB-002', desc: 'Web: Donor Registration Flow', category: 'Functional', status: 'Pass', rate: '100%', time: 3210 },
    { id: 'TC-WEB-003', desc: 'Web: Blood Search Analytics', category: 'Functional', status: 'Pass', rate: '100%', time: 1890 },
    { id: 'TC-WEB-004', desc: 'Web: Emergency Request submission', category: 'Functional', status: 'Pass', rate: '100%', time: 2450 },
    { id: 'TC-WEB-005', desc: 'Web: Hospital Dashboard Approval', category: 'Functional', status: 'Pass', rate: '100%', time: 2100 },
    { id: 'TC-WEB-006', desc: 'Web: Security Sanitization Test', category: 'Security', status: 'Pass', rate: '100%', time: 1200 },
    { id: 'TC-WEB-007', desc: 'Web: Responsive Design Check', category: 'UI/UX', status: 'Pass', rate: '100%', time: 3100 },
    { id: 'TC-WEB-008', desc: 'Web: Dashboard performance metrics', category: 'Performance', status: 'Pass', rate: '100%', time: 1400 },
    { id: 'TC-WEB-009', desc: 'Web: Admin User Management', category: 'Admin', status: 'Pass', rate: '100%', time: 2300 },
    { id: 'TC-WEB-010', desc: 'Web: Email Notification Service', category: 'Service', status: 'Pass', rate: '100%', time: 4500 },
    { id: 'TC-MOB-001', desc: 'Mobile Login: Profile Verification', category: 'Auth', status: 'Pass', rate: '100%', time: 2100 },
    { id: 'TC-MOB-002', desc: 'Mobile: Emergency Request flow', category: 'Functional', status: 'Pass', rate: '100%', time: 3400 },
    { id: 'TC-MOB-003', desc: 'Mobile: GPS Proximity Search', category: 'Functional', status: 'Pass', rate: '100%', time: 1200 },
    { id: 'TC-MOB-004', desc: 'Mobile: Push notification service', category: 'Service', status: 'Pass', rate: '100%', time: 900 },
    { id: 'TC-MOB-005', desc: 'Mobile: Offline Certificate Access', category: 'UX', status: 'Pass', rate: '100%', time: 500 },
    { id: 'TC-MOB-006', desc: 'Mobile: Firestore Profile Sync', category: 'Integrity', status: 'Pass', rate: '100%', time: 1900 },
    { id: 'TC-MOB-007', desc: 'Mobile: App transition benchmarks', category: 'Performance', status: 'Pass', rate: '100%', time: 1100 },
    { id: 'TC-MOB-008', desc: 'Mobile: Pull-to-refresh validation', category: 'UI', status: 'Pass', rate: '100%', time: 600 },
    { id: 'TC-MOB-009', desc: 'Mobile: Biometric Auth Mock', category: 'Security', status: 'Pass', rate: '100%', time: 1500 },
    { id: 'TC-MOB-010', desc: 'Mobile: Network Timeout recovery', category: 'Reliability', status: 'Pass', rate: '100%', time: 2200 }
];

generateReport(mockResults, 'Smart_Blood_Comprehensive_Analysis');
