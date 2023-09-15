
import SwiftUI

enum Gender: String, CaseIterable, Codable {
    case Male, Female
}

@available(iOS 15.0.0, *)
struct PickerExample: View {
    
    @State private var selectedItem: Gender = .Male
    
    var body: some View {
        VStack {
            Text("Default Custom picker")
                .fontWeight(.bold)
            SwiftUICustomizablePicker(Gender.allCases, selection: $selectedItem) { item in
                Text(item.rawValue.capitalized)
                    .foregroundColor(selectedItem == item ? .white : .black)
                    .font(.system(size: 15))
                    .fontWeight(selectedItem == item ? .semibold : .medium)
            }
            
            // MARK: - Native Picker
            
            VStack(spacing: 10) {
                Text("Native picker")
                    .fontWeight(.bold)
                
                Picker("", selection: $selectedItem) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }
            .padding()
            
            
        }
    }
}

@available(iOS 15.0.0, *)
struct Preview: PreviewProvider {
    static var previews: some View {
        PickerExample()
    }
}
