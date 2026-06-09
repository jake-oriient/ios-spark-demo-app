//
//  BarcodeScannerDelegate.swift
//  Spark Holiday Demo
//
//  Created by Jake Dunahee on 6/9/26.
//


import UIKit
import AVFoundation

// MARK: - Protocols

protocol BarcodeScannerDelegate: AnyObject {
    func didFindBarcode(code: String, type: AVMetadataObject.ObjectType)
    func didFailWithError(message: String)
}

class ScannerViewController: UIViewController {
    
    // MARK: - Properties
    
    /* Delegate */
    weak var delegate: BarcodeScannerDelegate?
    
    /* Private */
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        previewLayer?.frame = view.layer.bounds
    }

}

//MARK: - Private Functions

private extension ScannerViewController {
    
    func setupCaptureSession() {
        let session = AVCaptureSession()
        self.captureSession = session
        
        // 1. Configure the hardware camera input
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            delegate?.didFailWithError(message: "Camera not available on this device.")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            delegate?.didFailWithError(message: "Unable to access the camera input.")
            return
        }
        
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            delegate?.didFailWithError(message: "Failed to add camera input to session.")
            return
        }
        
        // 2. Configure the metadata output
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            
            // Set delegate and dispatch queue for handling callbacks
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Define which barcode types you want to scan
            metadataOutput.metadataObjectTypes = [
                .ean13,        // Standard supermarket 1D barcodes
                .ean8,
                .code128,      // Standard shipping/logistics 1D barcodes
                .qr,           // 2D QR Codes
                .pdf417        // 2D Passports/ID barcodes
            ]
        } else {
            delegate?.didFailWithError(message: "Failed to add metadata output.")
            return
        }
        
        // 3. Set up the video preview layer on screen
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = view.layer.bounds
        preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preview)
        self.previewLayer = preview
        
        // 4. Start the capture session in the background
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }
    
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        // Stop session immediately to prevent multi-scanning the same item
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Haptic feedback confirmation
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            captureSession?.stopRunning()
            delegate?.didFindBarcode(code: stringValue, type: readableObject.type)
        }
    }
    
}
