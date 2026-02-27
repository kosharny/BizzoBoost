import SwiftUI

struct AssetMapBB {
    
    static func moodImage(for index: Int) -> AnyView {
        let assetNames = [
            "mood_rough",
            "mood_meh",
            "mood_okay",
            "mood_good",
            "mood_great"
        ]
        
        if index >= 0 && index < assetNames.count {
            return AnyView(
                Image(assetNames[index])
                    .resizable()
                    .scaledToFit()
            )
        }
        
        let moodEmojis = ["😞", "😕", "😐", "🙂", "😁"]
        return AnyView(Text(moodEmojis[safe: index] ?? "😐").font(.largeTitle))
    }
    
    static func habitIcon(for iconName: String) -> AnyView {
        let mapping: [String: String] = [
            "star.fill": "habit_star",
            "heart.fill": "habit_heart",
            "bolt.fill": "habit_bolt",
            "book.fill": "habit_book",
            "drop.fill": "habit_drop",
            "figure.walk": "habit_walk",
            "moon.fill": "habit_moon",
            "sun.max.fill": "habit_sun",
            "leaf.fill": "habit_leaf",
            "music.note": "habit_music",
            "dumbbell.fill": "habit_gym",
            "brain": "habit_brain",
            "fork.knife": "habit_eat",
            "bed.double.fill": "habit_sleep",
            "pencil": "habit_edit"
        ]
        
        if let assetName = mapping[iconName] {
            return AnyView(
                Image(assetName)
                    .resizable()
                    .scaledToFit()
            )
        }
        
        return AnyView(Image(systemName: iconName))
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
