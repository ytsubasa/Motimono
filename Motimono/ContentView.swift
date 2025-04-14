//


import SwiftUI

struct ContentView: View {
    var body: some View {
        BeerCafeSplashView()
    }
}

#Preview {
    ContentView()
}
//


import SwiftUI

struct appStartView: View {
    var body: some View {
        ZStack {
            // 背景色
            Color.white
                .ignoresSafeArea()

            // 背景の円形デザイン
            GeometryReader { geometry in
                // 左下の半円
                Circle()
                    .fill(Color.yellow)
                    .frame(width: geometry.size.width * 0.8)
                    .offset(x: -geometry.size.width * 0.3,
                            y: geometry.size.height * 0.7)

                // 右上の半円
                Circle()
                    .fill(Color.yellow)
                    .frame(width: geometry.size.width * 0.9)
                    .offset(x: geometry.size.width * 0.6,
                            y: -geometry.size.height * 0.2)
            }

            // 中央のコンテンツ
            VStack(spacing: 12) {
                // ビールアイコン
                Image("LogoImage") // ←Assets.xcassetsに追加しておく
                    .resizable()
                    .frame(width: 100, height: 100)

                // 「deeps」テキスト（"ee"を黄色にする例）
                HStack(spacing: 0) {
                    Text("Motimono")
                    
                }
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)

            }
        }
    }
}
