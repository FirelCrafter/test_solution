//
//  Toast.swift
//  test_solution
//
//  Created by Михаил Щербаков on 05.08.2024.
//

import SwiftUI

struct RootView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var overlayWindow: UIWindow?
    var body: some View {
        content
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PasstroughWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    let rootController = UIHostingController(rootView: ToastGroup())
                    rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootController.view.backgroundColor = .clear
                    window.rootViewController = rootController
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    
                    overlayWindow = window
                }
            }
    }
}

fileprivate class PasstroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}

@Observable
class Toast {
    static let shared = Toast()
    fileprivate var toasts: [ToastItem] = []
    
    func present(title: String, symbol: String?, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: ToastTime = .meduim) {
        withAnimation(.snappy) {
            toasts.append(.init(title: title, symbol: symbol, tint: tint, isUserInteractionEnabled: isUserInteractionEnabled, timing: timing))
        }
    }
}

struct ToastItem: Identifiable {
    let id: UUID = .init()
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    var timing: ToastTime = .meduim
}

enum ToastTime: CGFloat {
    case short = 1.0
    case meduim = 2.0
    case long = 3.5
}

fileprivate struct ToastGroup: View {
    var model = Toast.shared
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                ForEach(model.toasts) { toast in
                    ToastView(size: size, item: toast)
                        .scaleEffect(scale(toast))
                        .offset(y: offsetY(toast))
                }
            }
            .padding(.top, safeArea.bottom == .zero ? -300 : -250)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    func offsetY(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return (totalCount - index) >= 2 ? -5 : ((totalCount-index) * -2)
    }
    
    func scale(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount-index) * 0.1))
    }
}

fileprivate struct ToastView: View {
    var size: CGSize
    var item: ToastItem
    @State private var animateIn: Bool = false
    @State private var animateOut: Bool = false
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.title3)
                    .padding(.trailing, 10)
            }
            Text(item.title)
                .lineLimit(1)
        }
        .foregroundColor(item.tint)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(
            .background
                .shadow(.drop(color:.primary.opacity(0.06),radius: 5, x: 5, y: 5))
                .shadow(.drop(color:.primary.opacity(0.06),radius: 8, x: -5, y: -5)),
            in: .capsule
        )
        .contentShape(.capsule)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    
                    if (endY+velocityY) < -100 {
                        removeToast()
                    }
                })
        )
        .offset(y: animateIn ? 150 : 0)
        .offset(y: !animateOut ? 150 : 0)
        .task {
            guard !animateIn else { return }
            withAnimation(.snappy) {
                animateIn = true
            }
            try? await Task.sleep(for: .seconds(item.timing.rawValue))
            
            removeToast()
        }
        .frame(maxWidth: size.width * 0.7)
    }
    
    func removeToast() {
        guard !animateOut else { return }
        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
            animateOut = true
        } completion: {
            removeToastItem()
        }
    }
    
    func removeToastItem() {
        Toast.shared.toasts.removeAll(where: { $0.id == item.id })
    }
}

