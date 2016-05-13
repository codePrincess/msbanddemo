import UIKit

class HeartBeatController : UIViewController, MSBClientManagerDelegate {
    
    @IBOutlet weak var heartBeatLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    

    var heartRateFactor : CGFloat = 0
    var connectedClient : MSBClient?

    
    deinit {
        do {
            let success = try self.connectedClient?.sensorManager.stopHeartRateUpdatesErrorRef()
            print("Heartrate sensor stopped: \(success)")
        } catch {
            print("Heartrate sensor stop failed!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.heartBeatLabel.alpha = 0.5
        
        connectedClient = BandConnectionManager.defaultManager.registerForEvents(self)
        
        if let _ = self.connectedClient {
            getUserPermissions()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        print("band connected")
        connectedClient = client
        getUserPermissions()
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        print("band disconnected")
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        print("band failed to connect - whooooot")
    }
    


    func getUserPermissions() {
        if let consent = self.connectedClient?.sensorManager.heartRateUserConsent() {
            switch (consent) {
            case .Granted :
                startHeartRateUpdates()
            case .Declined :
                print("user declined consent for heartrate")
            case .NotSpecified :
                self.connectedClient?.sensorManager.requestHRUserConsentWithCompletion({ (granted, error) in
                    if (granted) {
                        self.startHeartRateUpdates()
                    }
                    else {
                        print("user declined consent for heartrate")
                    }
                })
            }
        }
    }
    
    func startHeartRateUpdates() {
        do {
            try self.connectedClient?.sensorManager.startHeartRateUpdatesToQueue(nil) { (heartRateData, error) in
                
                self.heartRateFactor = CGFloat(Float(heartRateData.heartRate) / 100) + 1
                
                UIView.animateWithDuration(0.3, animations: {
                    self.heartBeatLabel.alpha = 1
                    self.heartBeatLabel.text = "\(heartRateData.heartRate)"
                },
                completion: {finished in
                    UIView.animateWithDuration(0.3, animations: {
                        self.heartBeatLabel.alpha = 0.5
                    })
                })
            
                self.animateHeart()
                
//                print("heartRate: \(heartRateData.heartRate), quality: \(heartRateData.quality.rawValue), factor: \(self.heartRateFactor)")
            }
        } catch {
            print("sensor error - heartrate can't be retrieved")
        }
    }
    
    func animateHeart() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut,
            animations: {
                self.heartImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5)
            },
            completion: { finished in
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseInOut,
                    animations: {
                        self.heartImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.heartRateFactor, self.heartRateFactor)
                    },
                    completion: { finished in
                        UIView.animateWithDuration(0.3, animations: { 
                            self.heartImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
                        })
                    })
            }
        )
    }


}

