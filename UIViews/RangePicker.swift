//
//  MultiNumberPicker.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-22.
//

import SwiftUI

// MARK: - Picker

struct MultiNumberPicker: View {
    
    /// The range of numbers to include.
    var range: Range<Int>
    
    /// Binding to the current lowest number.
    @Binding var lowestNumber: Int
    
    /// Binding to the current highest number.
    @Binding var highestNumber: Int
    
    var body: some View {
        ZStack {
            MultiNumberPickerRepresentable(range: range, lowestNumber: $lowestNumber, highestNumber: $highestNumber)
            
            Text("to")
                .font(.body.weight(.medium))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Picker Representable

/// A multi-integer-component picker view.
struct MultiNumberPickerRepresentable: UIViewRepresentable {
    
    /// The range of numbers to include.
    var range: Range<Int>
    
    /// Binding to the current lowest number.
    @Binding var lowestNumber: Int
    
    /// Binding to the current highest number.
    @Binding var highestNumber: Int
    
    /// Computed components.
    var components: [Component] {[
        Component(value: $lowestNumber, choices: [Int](range.lowerBound...highestNumber)),
        Component(value: $highestNumber, choices: [Int](lowestNumber..<range.upperBound)),
    ]}
    
    func makeUIView(context: Context) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.dataSource = context.coordinator
        pickerView.delegate = context.coordinator
        
        selectComponentRows(in: pickerView)
        
        return pickerView
    }
    
    func updateUIView(_ pickerView: UIPickerView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        .init(for: self)
    }
    
    func selectComponentRows(in pickerView: UIPickerView, animated: Bool = false) {
        for (index, component) in components.enumerated() {
            if let valueIndex = component.index {
                pickerView.selectRow(valueIndex, inComponent: index, animated: animated)
            }
        }
    }
}

// MARK: - Component

extension MultiNumberPickerRepresentable {
    
    /// A number picker component structure.
    struct Component {
        
        /// The current value chosen by the picker for this component.
        @Binding var value: Int
        
        /// The choices to display in the picker for this component.
        var choices: [Int]
        
        /// The current value's index in choices.
        var index: Int? {
            choices.firstIndex(of: value)
        }
    }
}

// MARK: - Coordinator

extension MultiNumberPickerRepresentable {
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        
        var parent: MultiNumberPickerRepresentable
        
        init(for parent: MultiNumberPickerRepresentable) {
            self.parent = parent
        }
        
        // MARK: Picker Data Source
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            parent.components.count
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            parent.components[component].choices.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            String(parent.components[component].choices[row])
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.components[component].value = parent.components[component].choices[row]
            
            parent.selectComponentRows(in: pickerView, animated: false)
            pickerView.reloadAllComponents()
        }
    }
}
