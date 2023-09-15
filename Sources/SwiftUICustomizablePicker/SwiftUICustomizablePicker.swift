// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI

@available(iOS 15.0, *)
public struct SwiftUICustomizablePicker<Data, Content> : View where Data: Hashable, Content: View {
    
    public var customIndicator: AnyView? = nil
    public var indicatorPadding: EdgeInsets
    
    public let sources: [Data]
    @Binding public var selection: Data
    public let itemBuilder: (Data) -> Content
    
    public let height: CGFloat
    public let cornerRadius: CGFloat
    public let backgroundColor: Color
    public let innerPadding: EdgeInsets
    
    public init(_ sources: [Data], selection: Binding<Data>, height: CGFloat = 32, cornerRadius: CGFloat = 7.0, backgroundColor: Color = Color(UIColor.label).opacity(0.05), indicatorPadding: EdgeInsets = EdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5), innerPadding: EdgeInsets = EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7), indicatorBuilder: (() -> AnyView)? = nil, @ViewBuilder itemBuilder: @escaping (Data) -> Content) {
        self.sources = sources
        self._selection = selection
        if let indicatorBuilder = indicatorBuilder {
            self.customIndicator = indicatorBuilder()
        }
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.indicatorPadding = indicatorPadding
        self.innerPadding = innerPadding
        self.itemBuilder = itemBuilder
    }
    
    
    public var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                
                if let selectedIndex = sources.firstIndex(of: selection) {
                    if let customIndicator = customIndicator {
                        customIndicator
                    } else {
                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .foregroundColor(Color.accentColor)
                            .padding(self.indicatorPadding)
                            .frame(width: geometry.size.width / CGFloat(sources.count))
                            .animation(.spring().speed(1.5), value: selection)
                            .offset(x: geometry.size.width / CGFloat(sources.count) * CGFloat(selectedIndex), y: 0)
                    }
                }
                
                VStack {
                    HStack(spacing: 0) {
                        ForEach(sources, id: \.self) { item in
                            ZStack {
                                itemBuilder(item)
                            }
                            .frame(width: geometry.size.width / CGFloat(sources.count), height: 32)
                            .contentShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                            .onTapGesture {
                                selection = item
                            }
                        }
                    }
                }
                
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 32)
            
        }
        .padding(self.innerPadding)
        .background {
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .foregroundColor(self.backgroundColor)
        }
    }
}
