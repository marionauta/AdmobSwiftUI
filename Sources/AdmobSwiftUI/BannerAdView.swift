#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif
import SwiftUI

public struct BannerAdView: View {
    public enum Constants {
        public static let defaultAdsHiddenKey = "AdmobSwiftUI.BannerAdView.areAdsHidden"
        public static let defaultHeight: CGFloat = 60
    }

    enum Stage {
        case loading, loaded, error
    }

    private let adUnitId: String
    private let areAdsHidden: AppStorage<Bool>
    @State private var stage: Stage = .loading
    @State private var height: CGFloat = Constants.defaultHeight

    public init(adUnitId: String, adsHiddenKey: String = Constants.defaultAdsHiddenKey) {
        self.adUnitId = adUnitId
        self.areAdsHidden = AppStorage(wrappedValue: false, adsHiddenKey)
    }

    public var body: some View {
        #if !canImport(GoogleMobileAds)
        EmptyView()
        #elseif DEBUG
        Text(verbatim: "DEBUG AD")
            .foregroundStyle(.orange)
            .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            .background(.orange.opacity(0.25))
        #else
        if stage == .error || areAdsHidden.wrappedValue {
            EmptyView()
        } else {
            ZStack {
                if stage == .loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                GeometryReader { proxy in
                    BannerView(stage: $stage, height: $height, width: proxy.size.width, adUnitID: adUnitId)
                }
                .frame(height: height)
            }
        }
        #endif
    }
}

#if canImport(GoogleMobileAds)
private struct BannerView: UIViewControllerRepresentable {
    @Binding var stage: BannerAdView.Stage
    @Binding var height: CGFloat
    var width: CGFloat
    let adUnitID: String

    private let bannerView = GADBannerView()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = UIViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerView.delegate = context.coordinator
        bannerViewController.view.addSubview(bannerView)
        return bannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard stage != .error else { return }
        bannerView.adSize = GADInlineAdaptiveBannerAdSizeWithWidthAndMaxHeight(width, BannerAdView.Constants.defaultHeight)
        bannerView.load(GADRequest())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, GADBannerViewDelegate {
        let parent: BannerView

        init(_ parent: BannerView) {
            self.parent = parent
        }

        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            parent.stage = .loaded
            parent.height = bannerView.frame.height
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print(#function, error.localizedDescription)
            parent.stage = .error
        }
    }
}
#endif
