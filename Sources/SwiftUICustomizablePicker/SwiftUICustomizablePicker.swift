// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI

@available(iOS 15.0, *)
public struct SwiftUICustomizablePicker<Data, Content> : View where Data: Hashable, Content: View {
    
    public var customIndicator: AnyView? = nil
    
    private var indicatorPadding: EdgeInsets = EdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)
    private var indicatorBackgroundGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [.accentColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    @Binding public var selection: Data
    public let sources: [Data]
    public let itemBuilder: (Data) -> Content
    
    private var width: CGFloat = UIScreen.main.bounds.width * 0.95
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
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> SwiftUICustomizablePicker {
        var view = self
        if let width = width {
            view.width = width
        }
        if let height = height {
            view.height = height
        }
        return view
    }
    
    public func height(_ height: CGFloat) -> SwiftUICustomizablePicker {
        var view = self
        view.height = height
        return view
    }
    
    public func cornerRadius(_ cornerRadius: CGFloat) -> SwiftUICustomizablePicker {
        var view = self
        view.cornerRadius = cornerRadius
        return view
    }
    
    public func backgroundColor(_ backgroundColor: Color) -> SwiftUICustomizablePicker {
        var view = self
        view.backgroundColor = backgroundColor
        return view
    }
    
    public func indicatorPadding(_ indicatorPadding: EdgeInsets) -> SwiftUICustomizablePicker {
        var view = self
        view.indicatorPadding = indicatorPadding
        return view
    }
    
    public func innerPadding(_ innerPadding: EdgeInsets) -> SwiftUICustomizablePicker {
        var view = self
        view.innerPadding = innerPadding
        return view
    }
    
    public func indicatorBackgroundGradient(_ gradient: LinearGradient) -> SwiftUICustomizablePicker {
        var view = self
        view.indicatorBackgroundGradient = gradient
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
                            .foregroundStyle(self.indicatorBackgroundGradient)
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
                            .frame(maxWidth: geometry.size.width / CGFloat(sources.count), maxHeight: 32)
                            .contentShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                            .onTapGesture {
                                selection = item
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, idealHeight: self.height, maxHeight: self.height)
            
            
        }
        .padding(self.innerPadding)
        .background {
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .foregroundColor(self.backgroundColor)
        }
    }
}
