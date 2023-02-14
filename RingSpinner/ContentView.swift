//
//  ContentView.swift
//  RingSpinner
//
//  Created by Rokon Uddin on 2/14/23.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        RingSpinner()
    }
}

struct RingSpinner : View {
    @State var progress: Double = 0.0
    
    var animation: Animation {
        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
    
    var body: some View {
        
        Color.black
            .ignoresSafeArea(.all)
            .overlay {
                GeometryReader { geometry in
                    ZStack {
                        Path { path in
                            
                            path.addArc(center: CGPoint(x: geometry.size.width/2, y: geometry.size.width/2),
                                        radius: geometry.size.width/2,
                                        startAngle: Angle(degrees: 0),
                                        endAngle: Angle(degrees: 360),
                                        clockwise: true)
                        }
                        .stroke(Color.green, lineWidth: 4)
                        
                        InnerRing(progress: self.progress).stroke(Color.white, lineWidth: 20)
                            .blur(radius: 6)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(64)
                .onAppear() {
                    withAnimation(self.animation) {
                        self.progress = 1.0
                    }
                }
            }
    }
    
}

struct InnerRing : Shape {
    var lagAmount = 0.35
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        
        let end = progress * 360
        var start: Double
        
        if progress > (1 - lagAmount) {
            start = 360 * (2 * progress - 1.0)
        } else if progress > lagAmount {
            start = 360 * (progress - lagAmount)
        } else {
            start = 0
        }
        
        var p = Path()
        
        p.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                 radius: rect.size.width/2,
                 startAngle: Angle(degrees: start),
                 endAngle: Angle(degrees: end),
                 clockwise: false)
        
        return p
    }
    
    var animatableData: Double {
        get { return progress }
        set { progress = newValue }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
