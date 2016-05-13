
import Foundation

class MeViewController : UIViewController, MSBClientManagerDelegate {
    
    @IBOutlet weak var bandContactLabel: UILabel!
    @IBOutlet weak var flightsClimbedLabel: UILabel!
    @IBOutlet weak var totalStepsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var upstepcountlabel: UILabel!
    @IBOutlet weak var skinTempLabel: UILabel!
    @IBOutlet weak var skinResistanceLabel: UILabel!
    
    var connectedClient : MSBClient?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectedClient = BandConnectionManager.defaultManager.registerForEvents(self)
    }
    
    func startSensorUpdates() {
        startBandContactSensor()
        startAltimeterSensor()
        startCalorieSensor()
        startGSRSensor()
        startSkinTemperatureSensor()
        startPedometerSensor()
    }
    
    func startBandContactSensor() {
        do {
            try connectedClient?.sensorManager.startBandContactUpdatesToQueue(nil, withHandler: { (data, error) in
                switch data.wornState {
                case .Worn :
                    self.bandContactLabel.text = "Wonderful, you are wearing your band!"
                case .NotWorn :
                    self.bandContactLabel.text = "Oh, did you forget to get your band on today?"
                case .Unknown :
                    self.bandContactLabel.text = "Sorry, but I can't find your band :("
                }
            })
        } catch {
            print("sensor error - band contact state can't be retrieved")
        }
    }
    
    func startAltimeterSensor() {
        do {
            try connectedClient?.sensorManager.startAltimeterUpdatesToQueue(nil, withHandler: { (data, error) in
                self.flightsClimbedLabel.text = "\(data.flightsAscended)"
                self.upstepcountlabel.text = "\(data.steppingGain)"
            })
            
        } catch {
            print("sensor error - altimeter sensor data can't be retrieved")
        }
    }
    
    func startCalorieSensor() {
        do {
            try connectedClient?.sensorManager.startCaloriesUpdatesToQueue(nil, withHandler: { (data, error) in
                self.caloriesLabel.text = "\(data.caloriesToday)"
            })
        } catch {
            print("sensor error - calories sensor data can't be retrieved")
        }
    }
    
    func startGSRSensor() {
        do {
            try connectedClient?.sensorManager.startGSRUpdatesToQueue(nil, withHandler: { (data, error) in
                self.skinResistanceLabel.text = "\(data.resistance)"
            })
        } catch {
            print("sensor error - GSR sensor data can't be retrieved")
        }
    }
    
    func startSkinTemperatureSensor() {
        do {
            try connectedClient?.sensorManager.startSkinTempUpdatesToQueue(nil, withHandler: { (data, error) in
                self.skinTempLabel.text = "\(data.temperature)"
            })
        } catch {
            print("sensor error - skin temperature sensor data can't be retrieved")
        }
    }
    
    func startPedometerSensor() {
        do {
            try connectedClient?.sensorManager.startPedometerUpdatesToQueue(nil, withHandler: { (data, error) in
                self.totalStepsLabel.text = "\(data.stepsToday)"
            })
        } catch {
            print("sensor error - altimeter sensor data can't be retrieved")
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