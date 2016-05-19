
import Foundation

class EnvironmentViewController : UIViewController, MSBClientManagerDelegate {
    
    @IBOutlet weak var airPressureLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    
    var connectedClient : MSBClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectedClient = BandConnectionManager.defaultManager.registerForEvents(self)
        
        if let _ = self.connectedClient {
            startSensorUpdates()
        }
    }
    
    func startSensorUpdates() {
        startUVIndexSensor()
        startBarometerSensor()
    }
    
    func startUVIndexSensor() {
        do {
            try connectedClient?.sensorManager.startUVUpdatesToQueue(nil, withHandler: { (data, error) in
                switch data.uvIndexLevel {
                    case .Low: self.uvIndexLabel.text = "Low"
                    case .Medium: self.uvIndexLabel.text = "Medium"
                    case .High: self.uvIndexLabel.text = "High"
                    case .VeryHigh: self.uvIndexLabel.text = "Very high"
                    case .None: self.uvIndexLabel.text = "No sun :/"
                }
            })
        } catch {
            print("sensor error - band uv sensor can't be retrieved")
        }
    }
    
    func startBarometerSensor() {
        do {
            try connectedClient?.sensorManager.startBarometerUpdatesToQueue(nil, withHandler: { (data, error) in
                self.temperatureLabel.text = String(format: "%.2f °C", data.temperature)
                self.airPressureLabel.text = String(format: "%.2f hPa", data.airPressure)
            })
        } catch {
            print ("sensor error - barometer sensor can't be retrieved")
        }
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        print("band connected")
        connectedClient = client
        startSensorUpdates()
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        print("band disconnected")
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        print("band failed to connect - whooooot")
    }
    
}