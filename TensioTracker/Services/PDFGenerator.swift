import UIKit
import PDFKit

class PDFGenerator {

    // MARK: - Colors
    private let themeBlue = UIColor(red: 0.102, green: 0.322, blue: 0.463, alpha: 1.0)
    private let lightBlue = UIColor(red: 0.102, green: 0.322, blue: 0.463, alpha: 0.08)
    private let headerBg = UIColor(red: 0.102, green: 0.322, blue: 0.463, alpha: 1.0)
    private let tableBorder = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
    private let tableHeaderBg = UIColor(red: 0.93, green: 0.95, blue: 0.97, alpha: 1.0)

    // MARK: - Page Setup
    private let pageWidth: CGFloat = 595.0   // A4 portrait
    private let pageHeight: CGFloat = 842.0
    private let margin: CGFloat = 30.0

    // MARK: - Generate PDF

    func generatePDF(session: MeasurementSession, profile: PatientProfile, viewModel: MeasurementViewModel) -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "fr_FR")

        let data = pdfRenderer.pdfData { context in
            context.beginPage()

            var y: CGFloat = margin

            // 1. Title bar
            y = drawTitleBar(y: y)

            // 2. Protocol instructions
            y = drawProtocolSection(y: y)

            // 3. Patient info
            y = drawPatientInfo(y: y, profile: profile, dateFormatter: dateFormatter)

            // 4. Measurement table
            y = drawMeasurementTable(y: y, session: session, dateFormatter: dateFormatter)

            // 5. Averages section (right side is integrated in table, but we draw below)
            y = drawAverages(y: y, viewModel: viewModel)

            // 6. Target info
            y = drawTargetInfo(y: y)
        }

        return data
    }

    // MARK: - Title Bar

    private func drawTitleBar(y: CGFloat) -> CGFloat {
        let barHeight: CGFloat = 44
        let barRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: barHeight)

        // Blue background
        headerBg.setFill()
        UIBezierPath(roundedRect: barRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 6, height: 6)).fill()

        // Title text
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]
        let title = "Relevé d'automesure tensionnelle"
        let titleSize = title.size(withAttributes: titleAttrs)
        title.draw(
            at: CGPoint(x: barRect.midX - titleSize.width / 2, y: barRect.midY - titleSize.height / 2),
            withAttributes: titleAttrs
        )

        return y + barHeight + 8
    }

    // MARK: - Protocol Section

    private func drawProtocolSection(y: CGFloat) -> CGFloat {
        let boxRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: 58)

        // Light background
        UIColor(red: 0.95, green: 0.97, blue: 0.99, alpha: 1.0).setFill()
        UIBezierPath(roundedRect: boxRect, cornerRadius: 4).fill()

        // Border
        tableBorder.setStroke()
        UIBezierPath(roundedRect: boxRect, cornerRadius: 4).stroke()

        let textAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor.darkGray
        ]
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 8),
            .foregroundColor: UIColor.darkGray
        ]

        let line1 = NSMutableAttributedString()
        line1.append(NSAttributedString(string: "Pendant 3 jours consécutifs, ", attributes: textAttrs))
        line1.append(NSAttributedString(string: "prendre sa tension 3 fois le matin", attributes: boldAttrs))
        line1.append(NSAttributedString(string: " (avant le petit déjeuner", attributes: textAttrs))

        let line2 = "et toute prise de médicaments) et 3 fois le soir (avant le coucher) sur le même bras."
        let line3 = "Attendre 1 minute entre chaque mesure. Noter les résultats ci-dessous :"

        let textX = margin + 8
        let textW = boxRect.width - 16

        line1.draw(in: CGRect(x: textX, y: y + 8, width: textW, height: 14))
        line2.draw(in: CGRect(x: textX, y: y + 22, width: textW, height: 14), withAttributes: textAttrs)
        (line3 as NSString).draw(in: CGRect(x: textX, y: y + 36, width: textW, height: 14), withAttributes: boldAttrs)

        return y + 58 + 8
    }

    // MARK: - Patient Info

    private func drawPatientInfo(y: CGFloat, profile: PatientProfile, dateFormatter: DateFormatter) -> CGFloat {
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.darkGray
        ]
        let valueAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 9),
            .foregroundColor: UIColor.black
        ]

        let contentWidth = pageWidth - 2 * margin

        // Name line
        let nameLabel = "Nom / Prénom : "
        let nameValue = "\(profile.lastName) \(profile.firstName)".trimmingCharacters(in: .whitespaces)
        nameLabel.draw(at: CGPoint(x: margin, y: y), withAttributes: labelAttrs)
        let nameLabelWidth = nameLabel.size(withAttributes: labelAttrs).width
        nameValue.draw(at: CGPoint(x: margin + nameLabelWidth, y: y), withAttributes: valueAttrs)

        // Birth date
        let birthLabel = "Date de naissance : "
        let birthValue = profile.birthDate != nil ? dateFormatter.string(from: profile.birthDate!) : ""
        let birthX = margin + contentWidth * 0.55
        birthLabel.draw(at: CGPoint(x: birthX, y: y), withAttributes: labelAttrs)
        let birthLabelWidth = birthLabel.size(withAttributes: labelAttrs).width
        birthValue.draw(at: CGPoint(x: birthX + birthLabelWidth, y: y), withAttributes: valueAttrs)

        // Dotted lines
        drawDottedLine(from: CGPoint(x: margin + nameLabelWidth + nameValue.size(withAttributes: valueAttrs).width + 4, y: y + 12),
                       to: CGPoint(x: birthX - 10, y: y + 12))
        drawDottedLine(from: CGPoint(x: birthX + birthLabelWidth + birthValue.size(withAttributes: valueAttrs).width + 4, y: y + 12),
                       to: CGPoint(x: margin + contentWidth, y: y + 12))

        let y2 = y + 18

        // Medications
        let medLabel = "Médicament(s) antihypertenseur(s) : "
        medLabel.draw(at: CGPoint(x: margin, y: y2), withAttributes: labelAttrs)
        let medLabelWidth = medLabel.size(withAttributes: labelAttrs).width
        let medValue = profile.medications.replacingOccurrences(of: "\n", with: ", ")
        medValue.draw(at: CGPoint(x: margin + medLabelWidth, y: y2), withAttributes: valueAttrs)

        drawDottedLine(from: CGPoint(x: margin + medLabelWidth + medValue.size(withAttributes: valueAttrs).width + 4, y: y2 + 12),
                       to: CGPoint(x: margin + contentWidth, y: y2 + 12))

        return y2 + 22
    }

    // MARK: - Measurement Table

    private func drawMeasurementTable(y: CGFloat, session: MeasurementSession, dateFormatter: DateFormatter) -> CGFloat {
        let contentWidth = pageWidth - 2 * margin
        let tableX = margin
        let labelColWidth: CGFloat = 50.0
        let periodColWidth: CGFloat = 28.0
        let avgColWidth: CGFloat = 80.0
        let dataWidth = contentWidth - labelColWidth - periodColWidth - avgColWidth
        let dayWidth = dataWidth / 3.0
        let cellWidth = dayWidth / 3.0
        let rowHeight: CGFloat = 18.0
        let headerHeight: CGFloat = 20.0

        var currentY = y

        let headerAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 8),
            .foregroundColor: themeBlue
        ]
        let cellAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor.darkGray
        ]
        let cellValueAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedDigitSystemFont(ofSize: 9, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        let avgHeaderAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 7.5),
            .foregroundColor: themeBlue
        ]

        // === JOUR header row ===
        let jourHeaderRect = CGRect(x: tableX, y: currentY, width: contentWidth, height: headerHeight)
        tableHeaderBg.setFill()
        UIRectFill(jourHeaderRect)
        tableBorder.setStroke()
        UIRectFrame(jourHeaderRect)

        let dataStartX = tableX + periodColWidth + labelColWidth
        for i in 0..<3 {
            let x = dataStartX + CGFloat(i) * dayWidth
            let jourText = "JOUR \(i + 1)"
            drawCenteredText(jourText, in: CGRect(x: x, y: currentY, width: dayWidth, height: headerHeight), attributes: headerAttrs)

            // Vertical separator between days
            if i > 0 {
                tableBorder.setStroke()
                let path = UIBezierPath()
                path.move(to: CGPoint(x: x, y: currentY))
                path.addLine(to: CGPoint(x: x, y: currentY + headerHeight))
                path.lineWidth = 0.5
                path.stroke()
            }
        }

        // "Moyenne générale" label in avg column
        let avgX = dataStartX + dataWidth
        drawCenteredText("Moyenne générale", in: CGRect(x: avgX, y: currentY, width: avgColWidth, height: headerHeight), attributes: avgHeaderAttrs)

        currentY += headerHeight

        // === Date row ===
        let dateRowRect = CGRect(x: tableX, y: currentY, width: contentWidth, height: rowHeight)
        UIColor.white.setFill()
        UIRectFill(dateRowRect)
        tableBorder.setStroke()
        UIRectFrame(dateRowRect)

        drawCenteredText("Date", in: CGRect(x: tableX, y: currentY, width: periodColWidth + labelColWidth, height: rowHeight), attributes: cellAttrs)

        for i in 0..<3 {
            let x = dataStartX + CGFloat(i) * dayWidth
            let dateStr = session.days[i].date != nil ? dateFormatter.string(from: session.days[i].date!) : ""
            drawCenteredText(dateStr, in: CGRect(x: x, y: currentY, width: dayWidth, height: rowHeight), attributes: cellValueAttrs)

            // Vertical lines
            tableBorder.setStroke()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: currentY))
            path.addLine(to: CGPoint(x: x, y: currentY + rowHeight))
            path.lineWidth = 0.5
            path.stroke()
        }

        // Vertical line before avg column
        let avgLine = UIBezierPath()
        avgLine.move(to: CGPoint(x: avgX, y: currentY))
        avgLine.addLine(to: CGPoint(x: avgX, y: currentY + rowHeight))
        avgLine.lineWidth = 0.5
        tableBorder.setStroke()
        avgLine.stroke()

        currentY += rowHeight

        // === Mesures header row ===
        let mesureRowRect = CGRect(x: tableX, y: currentY, width: contentWidth, height: rowHeight)
        tableHeaderBg.setFill()
        UIRectFill(mesureRowRect)
        tableBorder.setStroke()
        UIRectFrame(mesureRowRect)

        drawCenteredText("Mesures", in: CGRect(x: tableX, y: currentY, width: periodColWidth + labelColWidth, height: rowHeight), attributes: cellAttrs)

        for i in 0..<3 {
            for j in 0..<3 {
                let x = dataStartX + CGFloat(i) * dayWidth + CGFloat(j) * cellWidth
                drawCenteredText("\(j + 1)", in: CGRect(x: x, y: currentY, width: cellWidth, height: rowHeight), attributes: headerAttrs)

                // Vertical line
                tableBorder.setStroke()
                let path = UIBezierPath()
                path.move(to: CGPoint(x: x, y: currentY))
                path.addLine(to: CGPoint(x: x, y: currentY + rowHeight))
                path.lineWidth = 0.3
                path.stroke()
            }
        }

        // Avg column header
        let avgVertLine = UIBezierPath()
        avgVertLine.move(to: CGPoint(x: avgX, y: currentY))
        avgVertLine.addLine(to: CGPoint(x: avgX, y: currentY + rowHeight))
        avgVertLine.lineWidth = 0.5
        tableBorder.setStroke()
        avgVertLine.stroke()

        currentY += rowHeight

        // === Data rows (MATIN + SOIR) ===
        let periods: [(String, KeyPath<DayMeasurement, [BloodPressureReading]>)] = [
            ("MATIN", \.morningReadings),
            ("SOIR", \.eveningReadings)
        ]
        let metrics = ["SYS", "DIA", "PULSE"]

        for (periodIdx, (periodName, readingsKeyPath)) in periods.enumerated() {
            for (metricIdx, metric) in metrics.enumerated() {
                let rowRect = CGRect(x: tableX, y: currentY, width: contentWidth, height: rowHeight)
                let isEvenRow = (periodIdx * 3 + metricIdx) % 2 == 0
                (isEvenRow ? UIColor.white : UIColor(white: 0.98, alpha: 1.0)).setFill()
                UIRectFill(rowRect)
                tableBorder.setStroke()
                UIRectFrame(rowRect)

                // Period label (only on first metric row of each period)
                if metricIdx == 0 {
                    // Draw period label vertically centered across 3 rows
                    let periodRect = CGRect(x: tableX, y: currentY, width: periodColWidth, height: rowHeight * 3)
                    drawVerticalText(periodName, in: periodRect, attributes: headerAttrs)
                }

                // Period column vertical line
                let periodLine = UIBezierPath()
                periodLine.move(to: CGPoint(x: tableX + periodColWidth, y: currentY))
                periodLine.addLine(to: CGPoint(x: tableX + periodColWidth, y: currentY + rowHeight))
                periodLine.lineWidth = 0.5
                tableBorder.setStroke()
                periodLine.stroke()

                // Metric label
                drawCenteredText(metric, in: CGRect(x: tableX + periodColWidth, y: currentY, width: labelColWidth - periodColWidth, height: rowHeight), attributes: cellAttrs)

                // Vertical line after label
                let labelLine = UIBezierPath()
                labelLine.move(to: CGPoint(x: dataStartX, y: currentY))
                labelLine.addLine(to: CGPoint(x: dataStartX, y: currentY + rowHeight))
                labelLine.lineWidth = 0.5
                tableBorder.setStroke()
                labelLine.stroke()

                // Data cells
                for dayIdx in 0..<3 {
                    let readings = session.days[dayIdx][keyPath: readingsKeyPath]
                    for readingIdx in 0..<3 {
                        let x = dataStartX + CGFloat(dayIdx) * dayWidth + CGFloat(readingIdx) * cellWidth
                        let reading = readings[readingIdx]

                        let value: Int?
                        switch metric {
                        case "SYS": value = reading.systolic
                        case "DIA": value = reading.diastolic
                        case "PULSE": value = reading.pulse
                        default: value = nil
                        }

                        if let v = value {
                            drawCenteredText("\(v)", in: CGRect(x: x, y: currentY, width: cellWidth, height: rowHeight), attributes: cellValueAttrs)
                        }

                        // Vertical line
                        tableBorder.setStroke()
                        let path = UIBezierPath()
                        path.move(to: CGPoint(x: x, y: currentY))
                        path.addLine(to: CGPoint(x: x, y: currentY + rowHeight))
                        path.lineWidth = 0.3
                        path.stroke()
                    }
                }

                // Avg column vertical line
                let avgVLine = UIBezierPath()
                avgVLine.move(to: CGPoint(x: avgX, y: currentY))
                avgVLine.addLine(to: CGPoint(x: avgX, y: currentY + rowHeight))
                avgVLine.lineWidth = 0.5
                tableBorder.setStroke()
                avgVLine.stroke()

                currentY += rowHeight
            }

            // Draw horizontal separator between MATIN and SOIR
            if periodIdx == 0 {
                themeBlue.setStroke()
                let sepPath = UIBezierPath()
                sepPath.move(to: CGPoint(x: tableX, y: currentY))
                sepPath.addLine(to: CGPoint(x: tableX + contentWidth, y: currentY))
                sepPath.lineWidth = 1.0
                sepPath.stroke()
            }
        }

        return currentY + 4
    }

    // MARK: - Averages

    private func drawAverages(y: CGFloat, viewModel: MeasurementViewModel) -> CGFloat {
        let contentWidth = pageWidth - 2 * margin
        var currentY = y

        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10),
            .foregroundColor: themeBlue
        ]
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 9),
            .foregroundColor: UIColor.darkGray
        ]
        let valueAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .bold),
            .foregroundColor: themeBlue
        ]
        let unitAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 7),
            .foregroundColor: UIColor.gray
        ]

        let averages: [(String, String, String)] = [
            ("Moyenne générale",
             viewModel.formatAverage(viewModel.generalAverageSys),
             viewModel.formatAverage(viewModel.generalAverageDia)),
            ("Moyenne du matin",
             viewModel.formatAverage(viewModel.morningAverageSys),
             viewModel.formatAverage(viewModel.morningAverageDia)),
            ("Moyenne du soir",
             viewModel.formatAverage(viewModel.eveningAverageSys),
             viewModel.formatAverage(viewModel.eveningAverageDia))
        ]

        let boxWidth = (contentWidth - 16) / 3.0

        for (idx, (title, sys, dia)) in averages.enumerated() {
            let boxX = margin + CGFloat(idx) * (boxWidth + 8)
            let boxRect = CGRect(x: boxX, y: currentY, width: boxWidth, height: 58)

            // Background
            UIColor(red: 0.95, green: 0.97, blue: 0.99, alpha: 1.0).setFill()
            UIBezierPath(roundedRect: boxRect, cornerRadius: 6).fill()

            // Border
            themeBlue.withAlphaComponent(0.2).setStroke()
            let borderPath = UIBezierPath(roundedRect: boxRect, cornerRadius: 6)
            borderPath.lineWidth = 0.5
            borderPath.stroke()

            // Title
            drawCenteredText(title, in: CGRect(x: boxX, y: currentY + 4, width: boxWidth, height: 14), attributes: titleAttrs)

            // SYS value
            let sysLabel = "SYS"
            sysLabel.draw(at: CGPoint(x: boxX + 10, y: currentY + 22), withAttributes: labelAttrs)
            sys.draw(at: CGPoint(x: boxX + 38, y: currentY + 20), withAttributes: valueAttrs)
            "mmHg".draw(at: CGPoint(x: boxX + 38 + sys.size(withAttributes: valueAttrs).width + 2, y: currentY + 26), withAttributes: unitAttrs)

            // DIA value
            let diaLabel = "DIA"
            diaLabel.draw(at: CGPoint(x: boxX + 10, y: currentY + 40), withAttributes: labelAttrs)
            dia.draw(at: CGPoint(x: boxX + 38, y: currentY + 38), withAttributes: valueAttrs)
            "mmHg".draw(at: CGPoint(x: boxX + 38 + dia.size(withAttributes: valueAttrs).width + 2, y: currentY + 44), withAttributes: unitAttrs)
        }

        return currentY + 70
    }

    // MARK: - Target Info

    private func drawTargetInfo(y: CGFloat) -> CGFloat {
        let contentWidth = pageWidth - 2 * margin
        let boxRect = CGRect(x: margin, y: y, width: contentWidth, height: 34)

        UIColor(red: 0.95, green: 0.97, blue: 0.99, alpha: 1.0).setFill()
        UIBezierPath(roundedRect: boxRect, cornerRadius: 4).fill()

        let textAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 7.5),
            .foregroundColor: UIColor.darkGray
        ]
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 7.5),
            .foregroundColor: UIColor.darkGray
        ]

        let line1 = "Dans la majorité des cas, l'objectif tensionnel devrait être inférieur à 135 mmHg (SYS) et 85 mmHg (DIA)."
        let line2 = "Selon votre âge et votre état de santé, cet objectif peut être modulé. Parlez-en à votre médecin."

        line1.draw(in: CGRect(x: margin + 8, y: y + 5, width: contentWidth - 16, height: 12), withAttributes: textAttrs)
        line2.draw(in: CGRect(x: margin + 8, y: y + 18, width: contentWidth - 16, height: 12), withAttributes: boldAttrs)

        return y + 40
    }

    // MARK: - Helpers

    private func drawCenteredText(_ text: String, in rect: CGRect, attributes: [NSAttributedString.Key: Any]) {
        let size = text.size(withAttributes: attributes)
        let x = rect.midX - size.width / 2
        let y = rect.midY - size.height / 2
        text.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
    }

    private func drawVerticalText(_ text: String, in rect: CGRect, attributes: [NSAttributedString.Key: Any]) {
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()

        let size = text.size(withAttributes: attributes)
        context.translateBy(x: rect.midX - size.height / 2, y: rect.midY + size.width / 2)
        context.rotate(by: -.pi / 2)
        text.draw(at: .zero, withAttributes: attributes)

        context.restoreGState()
    }

    private func drawDottedLine(from start: CGPoint, to end: CGPoint) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = 0.5
        let dashes: [CGFloat] = [2, 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        UIColor.lightGray.setStroke()
        path.stroke()
    }

    // MARK: - PDF File Name

    func fileName(profile: PatientProfile, session: MeasurementSession) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: session.createdAt)

        var name = "Releve_tensionnel"
        let patientName = "\(profile.lastName)_\(profile.firstName)"
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "_")
        if !patientName.isEmpty && patientName != "_" {
            name += "_\(patientName)"
        }
        name += "_\(dateStr)"
        return name + ".pdf"
    }
}
