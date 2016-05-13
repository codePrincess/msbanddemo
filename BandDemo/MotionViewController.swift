
import UIKit

class MotionViewController: UIViewController, MSBClientManagerDelegate {

    @IBOutlet weak var currentMotionLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    
    var connectedClient : MSBClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectedClient = BandConnectionManager.defaultManager.registerForEvents(self)
        
        if let _ = self.connectedClient {
            startDistanceSensor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startSensorUpdates () {
        startDistanceSensor()
    }
    
    func startDistanceSensor () {
        do {
            try self.connectedClient?.sensorManager.startDistanceUpdatesToQueue(nil, withHandler: { (data, error) in
                switch data.motionType {
                    case .Idle: self.currentMotionLabel.text = "Idling around"
                    case .Walking: self.currentMotionLabel.text = "Nice walking"
                    case .Jogging : self.currentMotionLabel.text = "Nice jogging"
                    case .Running : self.currentMotionLabel.text = "Go on running!"
                    case .Unknown : self.currentMotionLabel.text = "..."
                }
                
                self.paceLabel.text = String(format: "%.2f min/km", data.pace*1000/60000)
                self.speedLabel.text = String(format: "%.2f km/h", data.speed/100000*3600)
                self.totalDistanceLabel.text = String(format: "%d km", data.totalDistance/1000)
            })
        } catch {
            
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

