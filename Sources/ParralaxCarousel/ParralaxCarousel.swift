import SwiftUI

public struct ParralaxCarouselView<ItemView: View, Item: Hashable>: View {

    @Binding public var bindedIndex: Int?
    public let config: ParralaxCarouselConfig
    public let items: [Item]
    public let itemView: (Item) -> ItemView

    public init(
        config: ParralaxCarouselConfig,
        selectedIndex: Binding<Int?>,
        items: [Item],
        itemView: @escaping (Item) -> ItemView
    ) {
        self.config = config
        self._bindedIndex = selectedIndex
        self.items = items
        self.itemView = itemView
    }

    private func minX(carouselProxy: GeometryProxy, itemProxy: GeometryProxy) -> CGFloat {
        switch config.parralaxEffect {
        case .one:
            return min((itemProxy.frame(in: .scrollView).minX - config.horizontalInset) * 1.4, carouselProxy.size.width * 1.4)
        }
    }

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                let size = geometry.size
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: config.horizontalSpacing) {
                        ForEach(Array(items.enumerated()), id: \.element.hashValue) { index, item in
                            itemView(for: item, geometry: geometry)
                                .id(index)
                        }

                    }
                    .padding(.horizontal, config.horizontalInset)
                    .frame(height: size.height, alignment: .top)
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $bindedIndex)
                .overlay(alignment: .bottom) {
                    dotsView()
                }
            }
            .padding(.horizontal, -config.horizontalInset * 0.5)
            .padding(.top, 10)
        }
    }

    private func itemView(for item: Item, geometry: GeometryProxy) -> some View {
        GeometryReader { proxy in
            let itemSize = proxy.size
            let minX = minX(carouselProxy: geometry, itemProxy: proxy)

            itemView(item)
                .offset(x: -minX)
                .frame(width: proxy.size.width * 2.5)
                .frame(width: itemSize.width, height: itemSize.height)
                .clipShape(.rect(cornerRadius: config.cornerRadius))
                .shadow(color: config.shadowColor, radius: 8, x: 5, y: 10)
        }
        .frame(
            width: geometry.size.width - 2 * config.horizontalInset,
            height: geometry.size.height - 50
        )
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view.scaleEffect(phase.isIdentity ? 1 : 0.95)
        }
    }

    private func dotsView() -> some View {
        HStack {
            Spacer()
            ForEach(Array(0 ..< items.count), id: \.self) { index in
                Image(systemName: index == bindedIndex ? "circle.circle" : "circle")
                    .resizable()
                    .frame(width: 4, height: 4)
                    .contentTransition(.symbolEffect)
            }
            Spacer()
        }
    }

    private func dotIndexesCount() -> Int {
        min(config.dotsCount, items.count)
    }

    private func dotIndex(for itemIndex: Int) -> Int {
        guard config.dotsCount < items.count else { return bindedIndex ?? 0 }
        return dotIndexesCount()
    }
}
