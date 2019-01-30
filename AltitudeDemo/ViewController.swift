import UIKit
import CoreMotion

class ViewController: UIViewController {
    lazy var altimeter: CMAltimeter = {
        CMAltimeter()
    }()

    lazy var floorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    lazy var altitudeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        view.addSubview(floorLabel)
        view.addSubview(altitudeLabel)
        NSLayoutConstraint.activate([
            floorLabel.topAnchor.constraint(equalTo: view.topAnchor),
            floorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            floorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            altitudeLabel.topAnchor.constraint(equalTo: floorLabel.bottomAnchor),
            altitudeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            altitudeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            altitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])

        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                if let error = error {
                    self.floorLabel.text = error.localizedDescription
                } else if let data = data {
                    if data.relativeAltitude.floatValue < 0 {
                        self.floorLabel.text = "Floor 1"
                    } else {
                        self.floorLabel.text = "Floor \(data.relativeAltitude.floatValue / 2)"
                    }
                    self.altitudeLabel.text = "Altitude \(data.relativeAltitude.stringValue)"
                } else {
                    self.floorLabel.text = "No results"
                }
            })
        }
    }
}

