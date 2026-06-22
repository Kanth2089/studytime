const ExcelJS = require('exceljs');
const fs = require('fs');

async function generateProfessionalReport(platform, testResults) {
    const workbook = new ExcelJS.Workbook();
    const sheet = workbook.addWorksheet(`Studyt ${platform} Analysis`);

    // Define Headers
    const headerRow = sheet.addRow(['#', 'Category', 'Test Case', 'Status', 'Visual Check', 'Error Detail', 'Timestamp']);
    headerRow.eachCell(cell => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF2D3949' } };
        cell.font = { color: { argb: 'FFFFFFFF' }, bold: true };
    });

    const categoryColors = {
        'Functional Testing': 'FFE8F5E9',
        'UI/UX Testing': 'FFE3F2FD',
        'Compatibility Testing': 'FFF1F8E9',
        'Performance Testing': 'FFFCE4EC',
        'Security Testing': 'FFF3E5F5',
        'API Testing': 'FFE0F2F1',
        'Database Testing': 'FFEFEBE9',
        'Accessibility Testing': 'FFFAFAFA',
        'Mobile-Specific Testing': 'FFECEFF1',
        'Regression Testing': 'FFFFF9C4',
        'End-to-End Testing': 'FFFFEBEE'
    };

    testResults.forEach((data, index) => {
        const row = sheet.addRow([
            index + 1,
            data.category,
            data.title,
            data.status,
            data.visualCheck || 'VERIFIED',
            data.error || '',
            new Date().toLocaleString()
        ]);

        const bgColor = categoryColors[data.category] || 'FFFFFFFF';
        row.eachCell(cell => {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: bgColor } };
        });

        const statusCell = row.getCell(4);
        statusCell.font = { bold: true, color: { argb: data.status === 'PASS' ? 'FF2E7D32' : 'FFC62828' } };
    });

    sheet.getColumn(3).width = 50;
    sheet.getColumn(5).width = 40;

    const reportsDir = '../reports';
    if (!fs.existsSync(reportsDir)) fs.mkdirSync(reportsDir, { recursive: true });
    
    const path = `${reportsDir}/Studyt_${platform}_Analysis.xlsx`;
    await workbook.xlsx.writeFile(path);
    console.log(`✅ Master Report Generated: ${path}`);
}

module.exports = generateProfessionalReport;
