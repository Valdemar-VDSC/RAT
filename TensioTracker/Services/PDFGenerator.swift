import UIKit

class PDFGenerator {

    // MARK: - Colors (matching the image)
    private let blueBorder = UIColor(red: 0.2, green: 0.4, blue: 0.75, alpha: 1.0)
    private let greenTitle = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0)
    private let greenDark = UIColor(red: 0.0, green: 0.45, blue: 0.15, alpha: 1.0)
    private let purpleText = UIColor(red: 0.35, green: 0.0, blue: 0.55, alpha: 1.0)
    private let lightBlue = UIColor(red: 0.85, green: 0.9, blue: 1.0, alpha: 1.0)
    private let lightGreen = UIColor(red: 0.85, green: 1.0, blue: 0.85, alpha: 1.0)
    private let darkBlue = UIColor(red: 0.15, green: 0.25, blue: 0.55, alpha: 1.0)

    // MARK: - Page Setup
    private let pageWidth: CGFloat = 595.0   // A4
    private let pageHeight: CGFloat = 842.0
    private let margin: CGFloat = 28.0

    private var contentWidth: CGFloat { pageWidth - 2 * margin }

    // MARK: - Generate

    func generatePDF(session: MeasurementSession, profile: PatientProfile, viewModel: MeasurementViewModel) -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        let dateFmt = DateFormatter()
        dateFmt.dateStyle = .short
        dateFmt.locale = Locale(identifier: "fr_FR")

        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            var y: CGFloat = margin

            y = drawPatientInfoBox(y: y, profile: profile, session: session, dateFmt: dateFmt)
            y += 6
            y = drawImportantNotice(y: y)
            y += 6
            y = drawMainTitle(y: y)
            y += 6
            y = drawProtocolBullets(y: y)
            y += 4
            y = drawInscriptionLine(y: y)
            y += 8

            for dayIdx in 0..<3 {
                y = drawDayTable(y: y, dayIdx: dayIdx, session: session, dateFmt: dateFmt)
                y += 6
            }

            y = drawAveragesAndDevice(y: y, viewModel: viewModel)
            y += 6
            y = drawFooterNote(y: y)
        }
        return data
    }

    // MARK: - 1. Patient Info Box

    private func drawPatientInfoBox(y: CGFloat, profile: PatientProfile, session: MeasurementSession, dateFmt: DateFormatter) -> CGFloat {
        let boxHeight: CGFloat = 60
        let leftWidth = contentWidth * 0.62
        let rightWidth = contentWidth * 0.38

        // Left box
        let leftRect = CGRect(x: margin, y: y, width: leftWidth, height: boxHeight)
        blueBorder.setStroke()
        let leftPath = UIBezierPath(rect: leftRect)
        leftPath.lineWidth = 1.5
        leftPath.stroke()

        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.darkGray
        ]
        let valueAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 9),
            .foregroundColor: UIColor.black
        ]

        let nameValue = "\(profile.lastName) \(profile.firstName)".trimmingCharacters(in: .whitespaces)
        let px: CGFloat = margin + 8
        var py = y + 8

        // Nom / Prénom
        let nameLine = NSMutableAttributedString()
        nameLine.append(NSAttributedString(string: "Nom : ", attributes: labelAttrs))
        nameLine.append(NSAttributedString(string: profile.lastName.isEmpty ? "……………………………" : profile.lastName, attributes: profile.lastName.isEmpty ? labelAttrs : valueAttrs))
        nameLine.append(NSAttributedString(string: "  Prénom : ", attributes: labelAttrs))
        nameLine.append(NSAttributedString(string: profile.firstName.isEmpty ? "……………………" : profile.firstName, attributes: profile.firstName.isEmpty ? labelAttrs : valueAttrs))
        nameLine.draw(at: CGPoint(x: px, y: py))

        py += 16

        // Période du relevé
        let firstDate = session.days.first?.date
        let lastDate = session.days.last?.date
        let periodLine = NSMutableAttributedString()
        periodLine.append(NSAttributedString(string: "Période du relevé : du ", attributes: labelAttrs))
        periodLine.append(NSAttributedString(string: firstDate != nil ? dateFmt.string(from: firstDate!) : "……………", attributes: firstDate != nil ? valueAttrs : labelAttrs))
        periodLine.append(NSAttributedString(string: " au ", attributes: labelAttrs))
        periodLine.append(NSAttributedString(string: lastDate != nil ? dateFmt.string(from: lastDate!) : "……………", attributes: lastDate != nil ? valueAttrs : labelAttrs))
        periodLine.draw(at: CGPoint(x: px, y: py))

        py += 16

        // Traitement
        let medText = profile.medications.replacingOccurrences(of: "\n", with: ", ")
        let treatLine = NSMutableAttributedString()
        treatLine.append(NSAttributedString(string: "Traitement : ", attributes: labelAttrs))
        treatLine.append(NSAttributedString(string: medText.isEmpty ? "…………………………………………………………………" : medText, attributes: medText.isEmpty ? labelAttrs : valueAttrs))
        treatLine.draw(in: CGRect(x: px, y: py, width: leftWidth - 16, height: 14))

        // Right box - "Cachet de l'officine"
        let rightRect = CGRect(x: margin + leftWidth, y: y, width: rightWidth, height: boxHeight)
        blueBorder.setStroke()
        UIBezierPath(rect: rightRect).stroke()

        let cachetAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor.gray
        ]
        drawCenteredText("Cachet de l'officine", in: CGRect(x: rightRect.minX, y: y + 6, width: rightWidth, height: 14), attributes: cachetAttrs)

        return y + boxHeight
    }

    // MARK: - 2. Important Notice

    private func drawImportantNotice(y: CGFloat) -> CGFloat {
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 9),
            .foregroundColor: darkBlue
        ]
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: darkBlue
        ]
        let underlineAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: darkBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        var py = y
        let px = margin + 12

        let line1 = NSMutableAttributedString()
        line1.append(NSAttributedString(string: "Important : Montrer ce document", attributes: boldAttrs))
        line1.draw(at: CGPoint(x: px, y: py))
        py += 14

        let line2 = NSMutableAttributedString()
        line2.append(NSAttributedString(string: "     - au pharmacien lors de votre venue à l'officine", attributes: normalAttrs))
        line2.draw(at: CGPoint(x: px, y: py))
        py += 14

        let line3 = NSMutableAttributedString()
        line3.append(NSAttributedString(string: "     - ", attributes: normalAttrs))
        line3.append(NSAttributedString(string: "au médecin à la prochaine consultation", attributes: underlineAttrs))
        line3.draw(at: CGPoint(x: px, y: py))
        py += 14

        return py + 2
    }

    // MARK: - 3. Main Title

    private func drawMainTitle(y: CGFloat) -> CGFloat {
        let barHeight: CGFloat = 32
        let barRect = CGRect(x: margin, y: y, width: contentWidth, height: barHeight)

        greenTitle.setFill()
        UIBezierPath(roundedRect: barRect, cornerRadius: 4).fill()

        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica-BoldOblique", size: 17) ?? UIFont.boldSystemFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]
        drawCenteredText("RELEVÉ D'AUTOMESURE TENSIONNELLE", in: barRect, attributes: titleAttrs)

        return y + barHeight
    }

    // MARK: - 4. Protocol Bullets

    private func drawProtocolBullets(y: CGFloat) -> CGFloat {
        let bulletAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8.5),
            .foregroundColor: UIColor.black
        ]

        let bullets = [
            "3 mesures consécutives (à quelques minutes d'intervalle) le matin avant de prendre ses médicaments",
            "3 mesures consécutives (à quelques minutes d'intervalle) le soir entre le dîner et le coucher",
            "3 jours de suite"
        ]

        var py = y + 4
        let px = margin + 12
        let bulletW = contentWidth - 24

        for bullet in bullets {
            let text = "•  \(bullet)"
            let textRect = CGRect(x: px, y: py, width: bulletW, height: 24)
            text.draw(in: textRect, withAttributes: bulletAttrs)
            let height = (text as NSString).boundingRect(with: CGSize(width: bulletW, height: .greatestFiniteMagnitude),
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: bulletAttrs,
                                                         context: nil).height
            py += max(height + 2, 13)
        }

        return py
    }

    // MARK: - 5. Inscription Line

    private func drawInscriptionLine(y: CGFloat) -> CGFloat {
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8.5),
            .foregroundColor: purpleText
        ]
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 8.5),
            .foregroundColor: purpleText
        ]

        let line = NSMutableAttributedString()
        line.append(NSAttributedString(string: "Inscrire ", attributes: normalAttrs))
        line.append(NSAttributedString(string: "tous les chiffres", attributes: boldAttrs))
        line.append(NSAttributedString(string: " qui apparaissent sur l'écran du tensiomètre", attributes: normalAttrs))

        let size = line.size()
        line.draw(at: CGPoint(x: margin + (contentWidth - size.width) / 2, y: y))

        return y + 14
    }

    // MARK: - 6. Day Table

    private func drawDayTable(y: CGFloat, dayIdx: Int, session: MeasurementSession, dateFmt: DateFormatter) -> CGFloat {
        let tableX = margin
        let labelColW: CGFloat = 70
        let dataColW = (contentWidth - labelColW) / 6.0  // 6 data columns
        let rowH: CGFloat = 20
        let headerH: CGFloat = 22
        let subHeaderH: CGFloat = 16

        var cy = y

        // === Jour N header ===
        let jourRect = CGRect(x: tableX, y: cy, width: contentWidth, height: headerH)
        blueBorder.setFill()
        UIBezierPath(rect: jourRect).fill()

        let jourAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.white
        ]

        let jourLabel = "Jour \(dayIdx + 1)"
        jourLabel.draw(at: CGPoint(x: tableX + 10, y: cy + 4), withAttributes: jourAttrs)

        // Matin / Soir headers
        let matinAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10),
            .foregroundColor: UIColor.white
        ]
        let matinX = tableX + labelColW
        let soirX = tableX + labelColW + 3 * dataColW
        drawCenteredText("Matin", in: CGRect(x: matinX, y: cy, width: 3 * dataColW, height: headerH), attributes: matinAttrs)
        drawCenteredText("Soir", in: CGRect(x: soirX, y: cy, width: 3 * dataColW, height: headerH), attributes: matinAttrs)

        // Vertical separator between matin and soir in header
        UIColor.white.withAlphaComponent(0.5).setStroke()
        let sepPath = UIBezierPath()
        sepPath.move(to: CGPoint(x: soirX, y: cy + 2))
        sepPath.addLine(to: CGPoint(x: soirX, y: cy + headerH - 2))
        sepPath.lineWidth = 1
        sepPath.stroke()

        cy += headerH

        // === Sub-header (systolique, diastolique, pouls × 2) ===
        let subRect = CGRect(x: tableX, y: cy, width: contentWidth, height: subHeaderH)
        lightBlue.setFill()
        UIRectFill(subRect)
        blueBorder.setStroke()
        UIBezierPath(rect: subRect).stroke()

        let subAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 7.5),
            .foregroundColor: UIColor.darkGray
        ]

        let colHeaders = ["systolique", "diastolique", "pouls"]
        for i in 0..<3 {
            let x = tableX + labelColW + CGFloat(i) * dataColW
            drawCenteredText(colHeaders[i], in: CGRect(x: x, y: cy, width: dataColW, height: subHeaderH), attributes: subAttrs)

            let x2 = tableX + labelColW + 3 * dataColW + CGFloat(i) * dataColW
            drawCenteredText(colHeaders[i], in: CGRect(x: x2, y: cy, width: dataColW, height: subHeaderH), attributes: subAttrs)
        }

        // Label column header empty
        let labelRect = CGRect(x: tableX, y: cy, width: labelColW, height: subHeaderH)
        blueBorder.setStroke()
        UIBezierPath(rect: labelRect).stroke()

        // Vertical lines in subheader
        for i in 0..<7 {
            let x = tableX + labelColW + CGFloat(i) * dataColW
            let vp = UIBezierPath()
            vp.move(to: CGPoint(x: x, y: cy))
            vp.addLine(to: CGPoint(x: x, y: cy + subHeaderH))
            vp.lineWidth = 0.5
            blueBorder.setStroke()
            vp.stroke()
        }

        cy += subHeaderH

        // === 3 Measurement Rows ===
        let day = session.days[dayIdx]

        for rowIdx in 0..<3 {
            let rowRect = CGRect(x: tableX, y: cy, width: contentWidth, height: rowH)
            let bgColor = rowIdx % 2 == 0 ? UIColor.white : UIColor(white: 0.97, alpha: 1.0)
            bgColor.setFill()
            UIRectFill(rowRect)
            blueBorder.setStroke()
            UIBezierPath(rect: rowRect).stroke()

            // Mesure label
            let mesureAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 8.5),
                .foregroundColor: darkBlue
            ]
            drawCenteredText("Mesure \(rowIdx + 1)", in: CGRect(x: tableX, y: cy, width: labelColW, height: rowH), attributes: mesureAttrs)

            let valueAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedDigitSystemFont(ofSize: 10, weight: .medium),
                .foregroundColor: UIColor.black
            ]
            let dashAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.lightGray
            ]

            // Morning values
            let mReading = day.morningReadings[rowIdx]
            let mValues: [Int?] = [mReading.systolic, mReading.diastolic, mReading.pulse]
            for (i, val) in mValues.enumerated() {
                let x = tableX + labelColW + CGFloat(i) * dataColW
                let text = val != nil ? "\(val!)" : "– – –"
                let attrs = val != nil ? valueAttrs : dashAttrs
                drawCenteredText(text, in: CGRect(x: x, y: cy, width: dataColW, height: rowH), attributes: attrs)
            }

            // Evening values
            let eReading = day.eveningReadings[rowIdx]
            let eValues: [Int?] = [eReading.systolic, eReading.diastolic, eReading.pulse]
            for (i, val) in eValues.enumerated() {
                let x = tableX + labelColW + 3 * dataColW + CGFloat(i) * dataColW
                let text = val != nil ? "\(val!)" : "– – –"
                let attrs = val != nil ? valueAttrs : dashAttrs
                drawCenteredText(text, in: CGRect(x: x, y: cy, width: dataColW, height: rowH), attributes: attrs)
            }

            // Vertical lines
            for i in 0..<7 {
                let x = tableX + labelColW + CGFloat(i) * dataColW
                let vp = UIBezierPath()
                vp.move(to: CGPoint(x: x, y: cy))
                vp.addLine(to: CGPoint(x: x, y: cy + rowH))
                vp.lineWidth = 0.5
                blueBorder.setStroke()
                vp.stroke()
            }

            // Thicker separator between matin and soir
            let midX = tableX + labelColW + 3 * dataColW
            let midPath = UIBezierPath()
            midPath.move(to: CGPoint(x: midX, y: cy))
            midPath.addLine(to: CGPoint(x: midX, y: cy + rowH))
            midPath.lineWidth = 1.5
            blueBorder.setStroke()
            midPath.stroke()

            cy += rowH
        }

        return cy
    }

    // MARK: - 7. Averages & Device

    private func drawAveragesAndDevice(y: CGFloat, viewModel: MeasurementViewModel) -> CGFloat {
        let tableX = margin
        let halfW = contentWidth / 2.0
        let boxH: CGFloat = 52

        // === Left: Averages ===
        let avgRect = CGRect(x: tableX, y: y, width: halfW, height: boxH)
        lightGreen.setFill()
        UIBezierPath(rect: avgRect).fill()
        greenDark.setStroke()
        let avgBorder = UIBezierPath(rect: avgRect)
        avgBorder.lineWidth = 1.5
        avgBorder.stroke()

        let avgTitleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 8),
            .foregroundColor: UIColor.black
        ]
        let avgValueAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .bold),
            .foregroundColor: greenDark
        ]

        let colW = halfW / 2.0

        // Moyenne Systolique
        let sysTitle = "MOYENNE\nSYSTOLIQUE *"
        let sysRect = CGRect(x: tableX + 6, y: y + 4, width: colW - 12, height: 24)
        sysTitle.draw(in: sysRect, withAttributes: avgTitleAttrs)

        let sysVal = viewModel.formatAverage(viewModel.generalAverageSys)
        drawCenteredText(sysVal, in: CGRect(x: tableX, y: y + 30, width: colW, height: 18), attributes: avgValueAttrs)

        // Vertical separator
        greenDark.setStroke()
        let sepPath = UIBezierPath()
        sepPath.move(to: CGPoint(x: tableX + colW, y: y + 4))
        sepPath.addLine(to: CGPoint(x: tableX + colW, y: y + boxH - 4))
        sepPath.lineWidth = 0.5
        sepPath.stroke()

        // Moyenne Diastolique
        let diaTitle = "MOYENNE\nDIASTOLIQUE *"
        let diaRect = CGRect(x: tableX + colW + 6, y: y + 4, width: colW - 12, height: 24)
        diaTitle.draw(in: diaRect, withAttributes: avgTitleAttrs)

        let diaVal = viewModel.formatAverage(viewModel.generalAverageDia)
        drawCenteredText(diaVal, in: CGRect(x: tableX + colW, y: y + 30, width: colW, height: 18), attributes: avgValueAttrs)

        // === Right: Autotensiomètre ===
        let devRect = CGRect(x: tableX + halfW, y: y, width: halfW, height: boxH)
        UIColor.white.setFill()
        UIRectFill(devRect)
        blueBorder.setStroke()
        let devBorder = UIBezierPath(rect: devRect)
        devBorder.lineWidth = 1.5
        devBorder.stroke()

        let devTitleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 9),
            .foregroundColor: purpleText
        ]
        let devLabelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor.darkGray
        ]

        let dx = tableX + halfW + 10
        drawCenteredText("Autotensiomètre", in: CGRect(x: tableX + halfW, y: y + 4, width: halfW, height: 14), attributes: devTitleAttrs)

        let marqueText = "Marque : ………………     Modèle : ………………"
        marqueText.draw(at: CGPoint(x: dx, y: y + 20), withAttributes: devLabelAttrs)

        let checkAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: purpleText
        ]
        "☐ poignet              ☐ bras".draw(at: CGPoint(x: dx + 20, y: y + 36), withAttributes: checkAttrs)

        return y + boxH
    }

    // MARK: - 8. Footer Note

    private func drawFooterNote(y: CGFloat) -> CGFloat {
        let noteAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 7),
            .foregroundColor: UIColor.darkGray
        ]
        let note = "* additionner toutes les mesures, systoliques ou diastoliques, et diviser par 18"
        note.draw(at: CGPoint(x: margin, y: y + 4), withAttributes: noteAttrs)
        return y + 16
    }

    // MARK: - Helpers

    private func drawCenteredText(_ text: String, in rect: CGRect, attributes: [NSAttributedString.Key: Any]) {
        let size = text.size(withAttributes: attributes)
        let x = rect.midX - size.width / 2
        let y = rect.midY - size.height / 2
        text.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
    }

    // MARK: - File Name

    func fileName(profile: PatientProfile, session: MeasurementSession) -> String {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFmt.string(from: session.createdAt)

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
