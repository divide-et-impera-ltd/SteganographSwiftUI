//
//  DocumentPicker.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 28.11.2020.
//

import SwiftUI
import Foundation
import MobileCoreServices
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {

    var callback: (URL) -> ()
    private let onDismiss: () -> Void

    init(callback: @escaping (URL) -> (), onDismiss: @escaping () -> Void) {
        self.callback = callback
        self.onDismiss = onDismiss
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image,
                                                                                 UTType.rawImage,
                                                                                 UTType.heic,
                                                                                 UTType.jpeg,
                                                                                 UTType.pdf,
                                                                                 UTType.item])
        controller.allowsMultipleSelection = false
        controller.delegate = context.coordinator
        return controller
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        init(_ pickerController: DocumentPicker) {
            self.parent = pickerController
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.callback(urls[0])
            parent.onDismiss()
        }
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onDismiss()
        }
    }
}
