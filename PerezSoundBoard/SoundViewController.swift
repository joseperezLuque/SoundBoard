//
//  SoundViewController.swift
//  PerezSoundBoard
//
//  Created by Jose Adriano Perez Luque on 18/05/24.
//

import UIKit
import AVFoundation
import CoreData

class SoundViewController: UIViewController {
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        agregarButton.isEnabled = false

    }
    
    func configurarGrabacion() {
            do {
                // Creando sesión de audio
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [])
                try session.overrideOutputAudioPort(.speaker)
                try session.setActive(true)
                
                // Creando dirección para el archivo de audio
                let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let pathComponents = [basePath, "audio.m4a"]
                audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
                
                // Impresión de ruta donde se guardan los archivos
                print("*******")
                print(audioURL!)
                print("*******")
                
                // Crear opciones para el grabador de audio
                var settings: [String: AnyObject] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
                settings[AVSampleRateKey] = 44100.0 as AnyObject
                settings[AVNumberOfChannelsKey] = 2 as AnyObject
                
                // Crear el objeto de grabación de audio
                grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
                grabarAudio!.prepareToRecord()
            } catch let error as NSError {
                print(error)
            }
        }

    
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
                        // Detener la grabación
                        grabarAudio?.stop()
                        // Cambiar texto del botón grabar
                        grabarButton.setTitle("GRABAR", for: .normal)
                        reproducirButton.isEnabled = true
                        agregarButton.isEnabled = true
                    } else {
                        // Empezar a grabar
                        grabarAudio?.record()
                        // Cambiar el texto del botón grabar a detener
                        grabarButton.setTitle("DETENER", for: .normal)
                        reproducirButton.isEnabled = false
                    }

    }
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
                    try reproducirAudio = AVAudioPlayer(contentsOf:audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        } catch{}
    }
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as!
                       AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext(); navigationController!.popViewController(animated: true)
    }
    
    
    
}
