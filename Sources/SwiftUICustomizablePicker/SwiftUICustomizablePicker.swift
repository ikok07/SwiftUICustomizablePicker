// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI

@available(iOS 15.0, *)
public struct SwiftUICustomizablePicker<Data, Content> : View where Data: Hashable, Content: View {
    
    public var customIndicator: AnyView? = nil
    
    private var indicatorPadding: EdgeInsets = EdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)
    private var indicatorBackgroundColor: Color = .accentColor
    
    @Binding public var selection: Data
    public let sources: [Data]
    public let itemBuilder: (Data) -> Content
    
    private var height: CGFloat = 32
    private var cornerRadius: CGFloat = 7
    private var backgroundColor: Color = Color(UIColor.label).opacity(0.05)
    private var innerPadding: EdgeInsets = EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
    
    public init(_ sources: [Data], selection: Binding<Data>, indicatorBuilder: (() -> AnyView)? = nil, @ViewBuilder itemBuilder: @escaping (Data) -> Content) {
        self.sources = sources
        self._selection = selection
        if let indicatorBuilder = indicatorBuilder {
            self.customIndicator = indicatorBuilder()
        }
        self.itemBuilder = itemBuilder
    }
    
    func height(_ height: CGFloat) -> SwiftUICustomizablePicker {
        var view = self
        view.height = height
        return view
    }
    
    func cornerRadius(_ cornerRadius: CGFloat) -> SwiftUICustomizablePicker {
        var view = self
        view.cornerRadius = cornerRadius
        return view
    }
    
    func backgroundColor(_ backgroundColor: Color) -> SwiftUICustomizablePicker {
        var view = self
        view.backgroundColor = backgroundColor
        return view
    }
    
    func indicatorPadding(_ indicatorPadding: EdgeInsets) -> SwiftUICustomizablePicker {
        var view = self
        view.indicatorPadding = indicatorPadding
        return view
    }
    
    func innerPadding(_ innerPadding: EdgeInsets) -> SwiftUICustomizablePicker {
        var view = self
        view.innerPadding = innerPadding
        return view
    }
    
    func indicatorBackgroundColor(_ color: Color) -> SwiftUICustomizablePicker {
        var view = self
        view.indicatorBackgroundColor = color
        return view
    }
    
    
    public var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                
                if let selectedIndex = sources.firstIndex(of: selection) {
                    if let customIndicator = customIndicator {
                        customIndicator
                    } else {
                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .foregroundColor(self.indicatorBackgroundColor)
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
