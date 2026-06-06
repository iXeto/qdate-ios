import SwiftUI
import UIKit

enum AppTab: String, CaseIterable {
    case home = "Home"
    case compass = "Compass"
    case profile = "Profile"

    var symbol: String {
        switch self {
        case .home: "sparkles"
        case .compass: "location.north.line"
        case .profile: "person.crop.circle"
        }
    }
}

enum SearchStage: String {
    case activeSearch
    case matchFound
    case timeCoordinationOpen
    case userVotedWaiting
    case sharedTimeFound
    case dateBeingPlanned
    case datePlanReady

}

enum VibeDimension: String, CaseIterable, Identifiable {
    case decisionStyle
    case outlook
    case socialEnergy
    case planningStyle
    case orderStyle

    var id: String { rawValue }

    var title: String {
        switch self {
        case .decisionStyle: "Heart or Head"
        case .outlook: "Pessimist or Optimist"
        case .socialEnergy: "Introvert or Extrovert"
        case .planningStyle: "Planner or Spontaneous"
        case .orderStyle: "Chaotic or Tidy"
        }
    }

    var options: [String] {
        switch self {
        case .decisionStyle: ["Heart", "Head"]
        case .outlook: ["Pessimist", "Optimist"]
        case .socialEnergy: ["Introvert", "Extrovert"]
        case .planningStyle: ["Planner", "Spontaneous"]
        case .orderStyle: ["Chaotic", "Tidy"]
        }
    }

    var displayLabel: String {
        switch self {
        case .decisionStyle: "Decisions"
        case .outlook: "Outlook"
        case .socialEnergy: "Social energy"
        case .planningStyle: "Planning"
        case .orderStyle: "Environment"
        }
    }
}

struct ProfileVibe: Equatable {
    var decisionStyle = "Heart"
    var outlook = "Optimist"
    var socialEnergy = "Introvert"
    var planningStyle = "Spontaneous"
    var orderStyle = "Tidy"

    var selectedValues: [String] {
        VibeDimension.allCases.map { selection(for: $0) }
    }

    func selection(for dimension: VibeDimension) -> String {
        switch dimension {
        case .decisionStyle: decisionStyle
        case .outlook: outlook
        case .socialEnergy: socialEnergy
        case .planningStyle: planningStyle
        case .orderStyle: orderStyle
        }
    }

    mutating func setSelection(_ value: String, for dimension: VibeDimension) {
        switch dimension {
        case .decisionStyle: decisionStyle = value
        case .outlook: outlook = value
        case .socialEnergy: socialEnergy = value
        case .planningStyle: planningStyle = value
        case .orderStyle: orderStyle = value
        }
    }
}

struct DemoUser {
    var name: String
    var age: Int
    var city: String
    var vibe: String
    var bio: String
    var interests: [String]
    var favoriteArtist: String
    var favoriteSong: String
    var favoriteMovie: String
    var favoriteFood: String
    var favoriteDestination: String
    var favoriteBook: String
    var bucketList: [String]
    var prompts: [String]
}

struct DateExperience: Identifiable, Equatable {
    let id: String
    let title: String
    let category: String
    let activity: String
    let location: String
    let budget: String
    let description: String
    let symbol: String
    let colors: [Color]
    let backgroundImageName: String?

    init(
        id: String,
        title: String,
        category: String,
        location: String,
        budget: String,
        description: String,
        symbol: String,
        colors: [Color],
        activity: String? = nil,
        backgroundImageName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.activity = activity ?? category
        self.location = location
        self.budget = budget
        self.description = description
        self.symbol = symbol
        self.colors = colors
        self.backgroundImageName = backgroundImageName
    }
}

struct ActiveMatch {
    var name: String
    var age: Int
    var city: String
    var compatibility: [String]
    var sharedVibes: [String]
}

struct TimeSlot: Identifiable {
    let id = UUID()
    let day: String
    let time: String
    let note: String
    var partnerStatus: PartnerSlotStatus
}

struct ProfilePromptDefinition: Identifiable, Hashable {
    let id: String
    let question: String
    let answers: [String]
}

struct ProfileQuestionSlot: Identifiable {
    let id = UUID()
    var questionID: String?
    var selectedAnswers: Set<String> = []
}

struct ProfileEditContext: Identifiable {
    let id: String
    let title: String
}

struct QuestionEditContext: Identifiable {
    let id: UUID
}

enum PartnerSlotStatus: String {
    case pending = "Pending"
    case accepted = "Accepted"
    case unavailable = "Busy"

    var color: Color {
        switch self {
        case .pending: .gray
        case .accepted: QTheme.success
        case .unavailable: QTheme.warning
        }
    }
}

enum ReadinessImprovementTip: String, CaseIterable, Identifiable {
    case swipeMore
    case addAvailability
    case answerProfileQuestions

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .swipeMore: "heart.text.square"
        case .addAvailability: "calendar.badge.clock"
        case .answerProfileQuestions: "text.bubble"
        }
    }

    var title: String {
        switch self {
        case .swipeMore: "Swipe more date ideas"
        case .addAvailability: "Add availability"
        case .answerProfileQuestions: "Answer profile questions"
        }
    }

    var detail: String {
        switch self {
        case .swipeMore: "Helps QDate understand your ideal setting."
        case .addAvailability: "Needed before a match can become a plan."
        case .answerProfileQuestions: "Sharper answers lead to better matches."
        }
    }

    var actionTitle: String {
        switch self {
        case .swipeMore: "Swipe"
        case .addAvailability: "Add"
        case .answerProfileQuestions: "Answer"
        }
    }
}

enum Weekday: String, CaseIterable, Identifiable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var id: String { rawValue }

    var title: String {
        switch self {
        case .monday: "Monday"
        case .tuesday: "Tuesday"
        case .wednesday: "Wednesday"
        case .thursday: "Thursday"
        case .friday: "Friday"
        case .saturday: "Saturday"
        case .sunday: "Sunday"
        }
    }

    var shortTitle: String {
        switch self {
        case .monday: "Mon"
        case .tuesday: "Tue"
        case .wednesday: "Wed"
        case .thursday: "Thu"
        case .friday: "Fri"
        case .saturday: "Sat"
        case .sunday: "Sun"
        }
    }
}

struct AvailabilityTimeSlot: Identifiable, Equatable {
    let id: UUID
    var weekday: Weekday
    var startTime: Date
    var endTime: Date

    init(
        id: UUID = UUID(),
        weekday: Weekday,
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int
    ) {
        self.id = id
        self.weekday = weekday
        let calendar = Calendar.current
        self.startTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: .now) ?? .now
        self.endTime = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: .now) ?? .now
    }

    var formattedRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: startTime)) – \(formatter.string(from: endTime))"
    }
}

enum DateFilterCatalog {
    static let tiers = ["Light", "Medium", "Premium"]

    static let categoriesByTier: [String: [String]] = [
        "Light": [
            "Café meetup",
            "Nature experience",
            "Museums",
            "Sightseeing",
            "Viewpoints",
            "Food & drinks",
            "Other"
        ],
        "Medium": [
            "Museums",
            "Cinema",
            "Action",
            "Sightseeing",
            "Other"
        ],
        "Premium": [
            "Museums",
            "Theatre",
            "Opera",
            "Action",
            "Sightseeing",
            "Other"
        ]
    ]

    static var allCategories: [String] {
        var seen = Set<String>()
        var result: [String] = []
        for tier in tiers {
            for category in categoriesByTier[tier] ?? [] where seen.insert(category).inserted {
                result.append(category)
            }
        }
        return result
    }
}

@MainActor
final class DemoStore: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var stage: SearchStage = .activeSearch
    @Published var readinessScore: Double = 42
    @Published var selectedExperienceIndex = 0
    @Published var pendingButtonSwipe: ButtonSwipeRequest?
    @Published var likedExperienceIDs: Set<String> = []
    @Published var dislikedExperienceIDs: Set<String> = []
    @Published private(set) var totalSwipeCount = 0
    @Published var selectedTimeSlotIDs: Set<UUID> = []
    @Published var appliedBudgetTiers: Set<String> = Set(DateFilterCatalog.tiers)
    @Published var appliedFilterCategories: Set<String> = Set(DateFilterCatalog.allCategories)
    @Published var selectedBudget = "Premium"
    @Published var selectedGender = "Women"
    @Published var minAge = 25.0
    @Published var maxAge = 34.0
    @Published var notificationsEnabled = true
    @Published var showFilters = false
    @Published var showExperienceDetails: DateExperience?
    @Published var showTimeCoordination = false
    @Published var showAvailabilityEditor = false
    @Published var showPhotoEditor = false
    @Published var editingProfileSection: ProfileEditContext?
    @Published var editingQuestionSlot: QuestionEditContext?
    @Published var profileVibe = ProfileVibe()
    @Published var aboutText = "Looking for intentional dates that feel easy, thoughtful, and a little cinematic."
    @Published var favoriteArtist = "Daft Punk"
    @Published var favoriteSong = "Get Lucky"
    @Published var favoriteMovie = "Interstellar"
    @Published var favoriteFood = "Sushi"
    @Published var favoriteDestination = "Tokyo"
    @Published var favoriteBook = "The Hobbit"
    @Published var interests = ["🎨 Art galleries", "🗣️ Deep talks", "🚶 Long walks", "🎶 Concerts", "🧠 Personal growth"]
    @Published var biggestWish = "Build a life that feels spacious, brave, and shared with the right person."
    @Published var bucketExperiences = [
        "Take a spontaneous train trip with no fixed plan",
        "Watch sunrise after a great night out",
        "Host a long dinner for friends and future friends"
    ]
    @Published var childhoodDream = "Architect"
    @Published var currentPath = "Founder building relationship technology"
    @Published var profileQuestionSlots = Array(repeating: ProfileQuestionSlot(), count: 5)
    @Published var weeklyAvailability: [AvailabilityTimeSlot] = [
        AvailabilityTimeSlot(weekday: .friday, startHour: 19, startMinute: 30, endHour: 22, endMinute: 0),
        AvailabilityTimeSlot(weekday: .sunday, startHour: 19, startMinute: 0, endHour: 21, endMinute: 0),
        AvailabilityTimeSlot(weekday: .tuesday, startHour: 20, startMinute: 0, endHour: 22, endMinute: 0)
    ]

    let user = DemoUser(
        name: "Chris",
        age: 22,
        city: "Hamburg",
        vibe: "Heart · Optimist · Introvert · Spontaneous · Tidy",
        bio: "Looking for intentional dates that feel easy, thoughtful, and a little cinematic.",
        interests: [],
        favoriteArtist: "Daft Punk",
        favoriteSong: "Get Lucky",
        favoriteMovie: "Interstellar",
        favoriteFood: "Sushi",
        favoriteDestination: "Tokyo",
        favoriteBook: "The Hobbit",
        bucketList: [],
        prompts: []
    )

    let profilePromptDefinitions: [ProfilePromptDefinition] = [
        ProfilePromptDefinition(
            id: "communication",
            question: "How would you describe your communication style?",
            answers: ["Direct and honest", "Calm and thoughtful", "Casual and humorous", "Deep and reflective", "Curious and questioning", "Depends on the situation"]
        ),
        ProfilePromptDefinition(
            id: "opinions",
            question: "How do you deal with differing opinions?",
            answers: ["I enjoy discussing things", "I listen first", "I try to find common ground", "I tend to avoid conflict", "It depends on the topic"]
        ),
        ProfilePromptDefinition(
            id: "newpeople",
            question: "When you meet new people, are you more likely to be...?",
            answers: ["Immediately open", "Reserved at first", "Quiet, but interested", "Quickly talkative when the vibe is right", "Very situation-dependent"]
        ),
        ProfilePromptDefinition(
            id: "important",
            question: "What is most important to you in other people?",
            answers: ["Honesty", "Empathy", "Humor", "Reliability", "Openness", "Self-reflection", "Calmness", "Loyalty"]
        ),
        ProfilePromptDefinition(
            id: "openup",
            question: "How easy is it for you to open up to new people?",
            answers: ["Very easy", "Quickly, if the vibe is right", "Rather slowly", "I need several meetings", "It depends on the person"]
        ),
        ProfilePromptDefinition(
            id: "difficult",
            question: "What do you sometimes find difficult with new connections?",
            answers: ["Making the first move", "Small talk", "Opening up right away", "Honestly saying what I think", "Keeping in touch", "None of these, actually"]
        ),
        ProfilePromptDefinition(
            id: "changed",
            question: "How much have you changed in recent years?",
            answers: ["Hardly at all", "A little", "Quite a lot", "A lot", "I am currently in the middle of changing"]
        ),
        ProfilePromptDefinition(
            id: "groups",
            question: "What role do you usually take on in groups?",
            answers: ["I start conversations", "I listen a lot", "I bring in humor", "I keep the group together", "I observe at first", "I adapt flexibly"]
        ),
        ProfilePromptDefinition(
            id: "connection",
            question: "What makes a good connection for you?",
            answers: ["Honest communication", "Mutual trust", "Shared humor", "Similar values", "Deep conversations", "Ease / lightness", "Reliability"]
        ),
        ProfilePromptDefinition(
            id: "selfimage",
            question: "How would you describe your self-image?",
            answers: ["I am rather self-confident", "I am rather self-critical", "I am a mix of both", "It strongly depends on the situation"]
        ),
        ProfilePromptDefinition(
            id: "people",
            question: "I get along well with people who...",
            answers: ["communicate honestly", "have a lot of humor", "are calm and relaxed", "think deeply", "are open and curious", "don't take themselves too seriously"]
        )
    ]

    init() {
        profileQuestionSlots = (0..<5).map { _ in ProfileQuestionSlot() }
    }

    let match = ActiveMatch(
        name: "Leila",
        age: 21,
        city: "Hamburg",
        compatibility: [
            "Both prefer intentional first dates over endless texting.",
            "Shared Sunday evening availability.",
            "High overlap on calm venues, food, and city walks."
        ],
        sharedVibes: ["low-pressure", "romantic", "curated", "offline-first"]
    )

    let experiences: [DateExperience] = [
        DateExperience(
            id: "cafe-matcha",
            title: "Matcha date at Café Love Story",
            category: "Café meetup",
            location: "Café Love Story",
            budget: "Light",
            description: "You meet at the cozy Café Love Story and start your RealMeet with matcha, coffee, or something sweet. Perfect to arrive relaxed, get to know each other, and enjoy the café vibe.",
            symbol: "cup.and.saucer.fill",
            colors: [Color(red: 0.78, green: 0.42, blue: 0.30), Color(red: 0.52, green: 0.18, blue: 0.42)],
            backgroundImageName: "CardBackgrounds/Matcha Date"
        ),
        DateExperience(
            id: "go-karting",
            title: "Race each other on the track",
            category: "Action",
            location: "Kart track in Hamburg",
            budget: "Premium",
            description: "You meet for go karting and race a few rounds against each other. Speed, curves, and a bit of friendly competition make the meetup feel more exciting than a normal indoor activity.",
            symbol: "flag.checkered",
            colors: [Color(red: 0.10, green: 0.10, blue: 0.12), Color(red: 0.92, green: 0.14, blue: 0.20)],
            activity: "Go karting",
            backgroundImageName: "CardBackgrounds/Karting_HH"
        ),
        DateExperience(
            id: "miniatur-wunderland",
            title: "Tiny worlds in Speicherstadt",
            category: "Museums",
            location: "Miniatur Wunderland",
            budget: "Premium",
            description: "You explore Miniatur Wunderland together and move through detailed miniature landscapes from Hamburg to places around the world. There is so much to spot that the meetup naturally stays light, curious, and full of small discoveries.",
            symbol: "globe.europe.africa.fill",
            colors: [Color(red: 0.52, green: 0.22, blue: 0.16), Color(red: 0.10, green: 0.30, blue: 0.58)],
            activity: "Visit to Miniatur Wunderland",
            backgroundImageName: "CardBackgrounds/Miniatur_Wonderland"
        ),
        DateExperience(
            id: "ferry-62",
            title: "Mini cruise on ferry 62",
            category: "Sightseeing",
            location: "Landungsbrücken",
            budget: "Medium",
            description: "You ride ferry 62 together across the Elbe and experience Hamburg from the water. The route passes the harbor, cranes, and Elbe views, turning a simple meetup into a small Hamburg experience.",
            symbol: "ferry.fill",
            colors: [Color(red: 0.12, green: 0.38, blue: 0.62), Color(red: 0.22, green: 0.52, blue: 0.78)],
            activity: "Ferry ride on the Elbe",
            backgroundImageName: "CardBackgrounds/Ferry_62"
        ),
        DateExperience(
            id: "board-game-cafe",
            title: "Board game café date",
            category: "Other",
            location: "Würfel & Zucker",
            budget: "Medium",
            description: "You meet at Würfel & Zucker and choose a board game to play together. The café setting, little challenges, and playful moments make it easy to spend time together without a stiff date feeling.",
            symbol: "dice.fill",
            colors: [Color(red: 0.42, green: 0.28, blue: 0.18), Color(red: 0.62, green: 0.38, blue: 0.22)],
            activity: "Board game café",
            backgroundImageName: "CardBackgrounds/Brettspiel_Cafe"
        )
    ]

    @Published var timeSlots: [TimeSlot] = [
        TimeSlot(day: "Friday", time: "19:30", note: "Drinks first, flexible dinner after", partnerStatus: .pending),
        TimeSlot(day: "Saturday", time: "18:00", note: "Early dinner and walk", partnerStatus: .unavailable),
        TimeSlot(day: "Sunday", time: "19:00", note: "Best fit for both calendars", partnerStatus: .accepted)
    ]

    var filteredExperiences: [DateExperience] {
        experiences.filter { experience in
            appliedBudgetTiers.contains(experience.budget) &&
            appliedFilterCategories.contains(experience.category)
        }
    }

    var currentExperience: DateExperience? {
        guard selectedExperienceIndex < filteredExperiences.count else { return nil }
        return filteredExperiences[selectedExperienceIndex]
    }

    var hasNoMatchingExperiences: Bool {
        filteredExperiences.isEmpty
    }

    var filledProfileQuestionCount: Int {
        profileQuestionSlots.filter { slot in
            slot.questionID != nil && !slot.selectedAnswers.isEmpty
        }.count
    }

    var readinessImprovementTips: [ReadinessImprovementTip] {
        ReadinessImprovementTip.allCases.filter { tip in
            switch tip {
            case .swipeMore:
                totalSwipeCount < 3 && currentExperience != nil
            case .addAvailability:
                weeklyAvailability.count < 4
            case .answerProfileQuestions:
                filledProfileQuestionCount < 3
            }
        }
        .prefix(3)
        .map { $0 }
    }

    func performReadinessAction(for tip: ReadinessImprovementTip, scrollToSwipeDeck: (() -> Void)? = nil) {
        switch tip {
        case .swipeMore:
            scrollToSwipeDeck?()
        case .addAvailability:
            showAvailabilityEditor = true
        case .answerProfileQuestions:
            selectedTab = .profile
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self else { return }
                if let slot = profileQuestionSlots.first(where: { $0.questionID == nil || $0.selectedAnswers.isEmpty }) {
                    editingQuestionSlot = QuestionEditContext(id: slot.id)
                }
            }
        }
    }

    func applyFilters(budgetTiers: Set<String>, categories: Set<String>) {
        appliedBudgetTiers = budgetTiers
        appliedFilterCategories = categories
        selectedExperienceIndex = 0
    }

    var isInMatchFlow: Bool {
        stage != .activeSearch
    }

    private func resetToActiveSearch() {
        showTimeCoordination = false
        withAnimation(.easeInOut(duration: 0.6)) {
            likedExperienceIDs.removeAll()
            dislikedExperienceIDs.removeAll()
            totalSwipeCount = 0
            selectedExperienceIndex = 0
            readinessScore = 42
            stage = .activeSearch
            selectedTimeSlotIDs.removeAll()
        }
    }

    func resetSwipes() {
        resetToActiveSearch()
        Haptics.success()
    }

    func cancelMatch() {
        resetToActiveSearch()
        Haptics.light()
    }

    func availabilitySlot(for weekday: Weekday) -> AvailabilityTimeSlot? {
        weeklyAvailability.first { $0.weekday == weekday }
    }

    func addAvailabilitySlot(for weekday: Weekday) {
        guard availabilitySlot(for: weekday) == nil else { return }
        weeklyAvailability.append(
            AvailabilityTimeSlot(weekday: weekday, startHour: 18, startMinute: 0, endHour: 20, endMinute: 0)
        )
    }

    func removeAvailabilitySlot(for weekday: Weekday) {
        weeklyAvailability.removeAll { $0.weekday == weekday }
    }

    var isCompassLocked: Bool {
        stage != .activeSearch && stage != .matchFound
    }

    func swipeCurrent(liked: Bool) {
        guard stage == .activeSearch else { return }
        guard let experience = currentExperience else { return }

        if liked {
            likedExperienceIDs.insert(experience.id)
            Haptics.success()
        } else {
            dislikedExperienceIDs.insert(experience.id)
            Haptics.light()
        }

        totalSwipeCount += 1
        let shouldBeginMatchFlow = totalSwipeCount >= 4

        withAnimation(.easeInOut(duration: 0.6)) {
            readinessScore = min(100, readinessScore + (liked ? 13 : 8))
            if !filteredExperiences.isEmpty {
                selectedExperienceIndex = min(
                    selectedExperienceIndex + 1,
                    filteredExperiences.count - 1
                )
            }
        }

        if shouldBeginMatchFlow {
            beginMatchFlow()
        }
    }

    func revealMatch() {
        withAnimation(.easeInOut(duration: 0.6)) {
            readinessScore = max(readinessScore, 86)
            stage = .matchFound
        }
        Haptics.success()
    }

    func beginMatchFlow() {
        guard stage == .activeSearch else { return }
        revealMatch()
    }

    func openTimeCoordination() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .timeCoordinationOpen
            showTimeCoordination = true
        }
    }

    func submitTimes() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .userVotedWaiting
            showTimeCoordination = false
        }
        Haptics.success()
    }

    func simulateSharedTime() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .sharedTimeFound
        }
    }

    func startPlanning() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .dateBeingPlanned
        }
    }

    func finishPlan() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
            stage = .datePlanReady
        }
        Haptics.success()
    }
}

enum QTheme {
    static let plum = Color(red: 0.09, green: 0.04, blue: 0.16)
    static let midnight = Color(red: 0.03, green: 0.02, blue: 0.08)
    static let violet = Color(red: 0.58, green: 0.25, blue: 1.0)
    static let electric = Color(red: 0.76, green: 0.39, blue: 1.0)
    static let rose = Color(red: 1.0, green: 0.28, blue: 0.52)
    static let text = Color.white
    static let muted = Color.white.opacity(0.68)
    static let success = Color(red: 0.34, green: 0.95, blue: 0.66)
    static let warning = Color(red: 1.0, green: 0.60, blue: 0.28)

    /// Signature gradient used for brand marks and prominent accents.
    static let brandGradient = LinearGradient(
        colors: [electric, violet, rose],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [violet, rose],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Soft tint poured into Liquid Glass surfaces to keep the dark, foggy mood.
    static let glassTint = Color(red: 0.10, green: 0.06, blue: 0.20)
}

enum Haptics {
    @MainActor
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    @MainActor
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

struct ContentView: View {
    @StateObject private var store = DemoStore()

    var body: some View {
        MainShell()
            .environmentObject(store)
            .preferredColorScheme(.dark)
    }
}

struct MainShell: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                GlassHeader()

                Group {
                    switch store.selectedTab {
                    case .home:
                        HomeScreen()
                    case .compass:
                        CompassScreen()
                    case .profile:
                        ProfileScreen()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack {
                Spacer()
                GlassTabBar()
                    .padding(.horizontal, 18)
                    .padding(.bottom, 6)
            }
        }
        .sheet(isPresented: $store.showFilters) {
            FilterSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $store.showExperienceDetails) { experience in
            ExperienceDetailSheet(experience: experience)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $store.showTimeCoordination) {
            TimeCoordinationSheet()
        }
        .fullScreenCover(isPresented: $store.showAvailabilityEditor) {
            WeeklyAvailabilityEditScreen()
        }
        .sheet(item: $store.editingProfileSection) { context in
            ProfileEditSheet(context: context)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $store.editingQuestionSlot) { context in
            QuestionSlotEditSheet(slotID: context.id)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $store.showPhotoEditor) {
            PhotoEditSheet()
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [QTheme.midnight, QTheme.plum, Color(red: 0.05, green: 0.02, blue: 0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(QTheme.violet.opacity(0.28))
                .frame(width: 360, height: 360)
                .blur(radius: 90)
                .offset(x: -160, y: -260)

            Circle()
                .fill(QTheme.rose.opacity(0.20))
                .frame(width: 320, height: 320)
                .blur(radius: 100)
                .offset(x: 180, y: 220)
        }
    }
}

struct GlassCard<Content: View>: View {
    let cornerRadius: CGFloat
    let glow: Bool
    @ViewBuilder var content: Content

    init(cornerRadius: CGFloat = 28, glow: Bool = false, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.glow = glow
        self.content = content()
    }

    var body: some View {
        content
            .glassEffect(
                glow ? .regular.tint(QTheme.violet.opacity(0.22)) : .regular.tint(QTheme.glassTint.opacity(0.35)),
                in: .rect(cornerRadius: cornerRadius)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.40), Color.white.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
                    .allowsHitTesting(false)
            }
            .shadow(
                color: glow ? QTheme.violet.opacity(0.40) : Color.black.opacity(0.30),
                radius: glow ? 32 : 18,
                x: 0,
                y: 16
            )
    }
}

struct GlassButton: View {
    let title: String
    let symbol: String?
    var prominent = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 15, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(.plain)
        .glassEffect(
            prominent
                ? .regular.tint(QTheme.violet.opacity(0.55)).interactive()
                : .regular.interactive(),
            in: .capsule
        )
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(Color.white.opacity(prominent ? 0.28 : 0.16), lineWidth: 0.8)
                .allowsHitTesting(false)
        }
        .shadow(color: prominent ? QTheme.violet.opacity(0.42) : .clear, radius: 20, y: 10)
    }
}

struct GlassIconButton: View {
    let symbol: String
    var tint: Color = .white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: 50, height: 50)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .overlay {
            Circle()
                .strokeBorder(Color.white.opacity(0.16), lineWidth: 0.8)
                .allowsHitTesting(false)
        }
    }
}

struct GlassHeader: View {
    @State private var showHelp = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("QDate")
                        .font(.system(size: 26, weight: .semibold, design: .serif))
                        .tracking(0.5)
                        .foregroundStyle(QTheme.electric)

                    HStack(spacing: 5) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(QTheme.electric)
                        Text("Hamburg")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(QTheme.muted)
                    }
                }

                Spacer()

                Button {
                    showHelp = true
                    Haptics.light()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(QTheme.electric)
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("QDate help")
            }
            .padding(.horizontal, 22)
            .padding(.top, 2)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        colors: [Color.white.opacity(0.10), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea(edges: .top)
        }
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [Color.white.opacity(0.18), Color.white.opacity(0.02)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
        }
        .sheet(isPresented: $showHelp) {
            QDateHelpSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct QDateHelpSheet: View {
    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 18) {
                Text("How QDate works")
                    .font(.system(size: 30, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)

                HelpRow(symbol: "sparkles", title: "Search stays active", detail: "QDate learns from date ideas and readiness signals.")
                HelpRow(symbol: "heart.circle", title: "No endless chat", detail: "The concierge moves promising matches toward a real plan.")
                HelpRow(symbol: "calendar.badge.clock", title: "Hamburg demo", detail: "This prototype is seeded around local date planning.")

                Spacer()
            }
            .padding(22)
        }
    }
}

struct HelpRow: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(QTheme.electric)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(QTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct GlassTabBar: View {
    @EnvironmentObject private var store: DemoStore
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 6) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let selected = store.selectedTab == tab
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                        store.selectedTab = tab
                    }
                    Haptics.light()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: tab.symbol)
                            .font(.system(size: 16, weight: .semibold))
                            .symbolVariant(selected ? .fill : .none)
                        if selected {
                            Text(tab.rawValue)
                                .font(.system(size: 13, weight: .bold))
                                .fixedSize()
                                .transition(.opacity.combined(with: .scale(scale: 0.7)))
                        }
                    }
                    .foregroundStyle(selected ? .white : Color.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background {
                        if selected {
                            Capsule(style: .continuous)
                                .fill(QTheme.violet)
                                .shadow(color: QTheme.violet.opacity(0.45), radius: 10, y: 4)
                                .matchedGeometryEffect(id: "activeTab", in: namespace)
                        }
                    }
                    .contentShape(Capsule(style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .glassEffect(.regular.tint(QTheme.glassTint.opacity(0.4)), in: .capsule)
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
                .allowsHitTesting(false)
        }
        .shadow(color: Color.black.opacity(0.38), radius: 26, y: 16)
    }
}

struct CancelMatchButton: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        Button {
            store.cancelMatch()
        } label: {
            Text("Cancel match")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(QTheme.muted.opacity(0.72))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Cancel match and start over")
    }
}

struct HomeScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    switch store.stage {
                    case .activeSearch:
                        ActiveSearchView(
                            scrollToImproveReadiness: {
                                withAnimation(.easeInOut(duration: 0.45)) {
                                    proxy.scrollTo("improveMatchReadiness", anchor: .top)
                                }
                            },
                            scrollToSwipeDeck: {
                                withAnimation(.easeInOut(duration: 0.45)) {
                                    proxy.scrollTo("experienceSwipeDeck", anchor: .center)
                                }
                            }
                        )
                case .matchFound, .timeCoordinationOpen:
                    MatchCockpit()
                case .userVotedWaiting:
                    WaitingForMatchView()
                case .sharedTimeFound:
                    SharedTimeFoundView()
                case .dateBeingPlanned:
                    DateBeingPlannedView()
                case .datePlanReady:
                    DatePlanReadyView()
                }

                    if store.isInMatchFlow {
                        CancelMatchButton()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 12)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 96)
            }
        }
    }
}

struct ActiveSearchView: View {
    @EnvironmentObject private var store: DemoStore
    let scrollToImproveReadiness: () -> Void
    let scrollToSwipeDeck: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            ReadinessCard(onTap: scrollToImproveReadiness)
                .padding(.bottom, 20)

            ExperienceSwipeDeck()
                .id("experienceSwipeDeck")

            GuidanceTasks(scrollToSwipeDeck: scrollToSwipeDeck)
                .id("improveMatchReadiness")
        }
    }
}

struct ReadinessCard: View {
    @EnvironmentObject private var store: DemoStore
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Button(action: onTap) {
                    HStack(spacing: 10) {
                        Text("Match readiness")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)

                        Spacer()

                        Text("\(Int(store.readinessScore))%")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundStyle(QTheme.electric)
                            .monospacedDigit()
                            .contentTransition(.numericText(value: store.readinessScore))
                            .animation(.easeInOut(duration: 0.6), value: store.readinessScore)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Match readiness, scroll to improvement tips")

                Button {
                    store.showFilters = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(QTheme.muted)
                        .frame(width: 34, height: 34)
                        .background(Color.white.opacity(0.08), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Date filters")
            }

            Button(action: onTap) {
                ReadinessProgressBar(progress: store.readinessScore)
                    .frame(height: 10)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Match readiness progress, scroll to improvement tips")
        }
    }
}

private struct ReadinessProgressBar: View {
    var progress: Double

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.10))
                ReadinessProgressFill(progress: progress)
                    .fill(QTheme.violet)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .shadow(color: QTheme.violet.opacity(0.45), radius: 10)
            }
        }
    }
}

private struct ReadinessProgressFill: Shape {
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let fillWidth = rect.width * max(0.04, progress / 100)
        return Capsule().path(in: CGRect(x: 0, y: 0, width: fillWidth, height: rect.height))
    }
}

struct ExperienceSwipeDeck: View {
    @EnvironmentObject private var store: DemoStore

    private let cardHeight: CGFloat = 520

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                ForEach(Array(store.filteredExperiences.enumerated().reversed()), id: \.element.id) { index, experience in
                    if index >= store.selectedExperienceIndex && index < store.selectedExperienceIndex + 3 {
                        ExperienceCard(
                            experience: experience,
                            isTop: index == store.selectedExperienceIndex,
                            cardHeight: cardHeight
                        )
                        .scaleEffect(index == store.selectedExperienceIndex ? 1 : 0.94 - CGFloat(index - store.selectedExperienceIndex) * 0.03)
                        .offset(y: CGFloat(index - store.selectedExperienceIndex) * 14)
                        .zIndex(Double(store.filteredExperiences.count - index))
                    }
                }

                if store.currentExperience == nil {
                    GlassCard(cornerRadius: 28) {
                        VStack(spacing: 14) {
                            Image(systemName: store.hasNoMatchingExperiences ? "line.3.horizontal.decrease.circle" : "sparkles.rectangle.stack")
                                .font(.system(size: 42))
                                .foregroundStyle(QTheme.electric)
                            Text(store.hasNoMatchingExperiences ? "No matches for these filters" : "Enough signal collected")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.white)
                            Text(store.hasNoMatchingExperiences
                                 ? "Try another budget tier or category to see more date ideas."
                                 : "QDate has what it needs to move from search into a curated match.")
                                .font(.system(size: 14))
                                .foregroundStyle(QTheme.muted)
                                .multilineTextAlignment(.center)
                        }
                        .padding(28)
                        .frame(maxWidth: .infinity, minHeight: cardHeight)
                    }
                }
            }
            .frame(height: cardHeight)

            if store.currentExperience != nil {
                HStack(spacing: 48) {
                    SwipeActionButton(symbol: "xmark", tint: QTheme.warning, size: 64) {
                        if let current = store.currentExperience {
                            store.pendingButtonSwipe = ButtonSwipeRequest(experienceID: current.id, liked: false)
                        }
                    }

                    SwipeActionButton(symbol: "heart.fill", tint: QTheme.rose, size: 64) {
                        if let current = store.currentExperience {
                            store.pendingButtonSwipe = ButtonSwipeRequest(experienceID: current.id, liked: true)
                        }
                    }
                }
            }
        }
    }
}

struct ButtonSwipeRequest: Equatable {
    let experienceID: String
    let liked: Bool
    let token = UUID()
}

/// Hit-test shape for the swipe gesture. Insets the active region so the
/// edges/corners of the card fall through to the background scroll view
/// instead of being captured as a swipe.
struct SwipeHitShape: Shape {
    var horizontalInset: CGFloat
    var topInset: CGFloat
    var bottomInset: CGFloat
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let inset = CGRect(
            x: rect.minX + horizontalInset,
            y: rect.minY + topInset,
            width: max(0, rect.width - horizontalInset * 2),
            height: max(0, rect.height - topInset - bottomInset)
        )
        return RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).path(in: inset)
    }
}

struct ExperienceCard: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let experience: DateExperience
    let isTop: Bool
    let cardHeight: CGFloat
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(LinearGradient(colors: experience.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay {
                    if let imageName = experience.backgroundImageName {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: experience.symbol)
                            .font(.system(size: 150, weight: .thin))
                            .foregroundStyle(.white.opacity(0.18))
                            .offset(x: 72, y: -150)
                    }
                }
                .overlay {
                    LinearGradient(colors: [.clear, .black.opacity(0.78)], startPoint: .top, endPoint: .bottom)
                }

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(experience.activity, systemImage: "sparkle")
                    Spacer()
                    Text(experience.budget)
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white.opacity(0.84))

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text(experience.location)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(QTheme.electric)
                    Text(experience.title)
                        .font(.system(size: 30, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text(experience.description)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.82))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    Button {
                        store.showExperienceDetails = experience
                    } label: {
                        Text("See more")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(QTheme.electric)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(22)

            SwipeIndicator(title: "LIKE", systemImage: "heart.fill", color: QTheme.rose, opacity: max(0, dragOffset.width / 110))
                .rotationEffect(.degrees(-10))
                .padding(.leading, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .offset(y: -(cardHeight * 0.12))

            SwipeIndicator(title: "PASS", systemImage: "xmark", color: QTheme.warning, opacity: max(0, -dragOffset.width / 110))
                .rotationEffect(.degrees(10))
                .padding(.trailing, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .offset(y: -(cardHeight * 0.12))
        }
        .frame(height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 34, style: .continuous).stroke(Color.white.opacity(0.20), lineWidth: 1))
        .shadow(color: QTheme.violet.opacity(0.28), radius: 26, y: 18)
        .offset(dragOffset)
        .rotationEffect(.degrees(reduceMotion ? 0 : Double(dragOffset.width / 22)))
        .contentShape(SwipeHitShape(horizontalInset: 26, topInset: 10, bottomInset: 22, cornerRadius: 28))
        .gesture(
            DragGesture(minimumDistance: 12)
                .onChanged { value in
                    guard isTop else { return }
                    dragOffset = CGSize(
                        width: value.translation.width,
                        height: Self.dampenedVertical(value.translation.height)
                    )
                }
                .onEnded { value in
                    guard isTop else { return }
                    let translation = value.translation.width
                    let predicted = value.predictedEndTranslation.width

                    if translation > Self.commitThreshold || predicted > Self.flickThreshold {
                        flyOff(liked: true)
                    } else if translation < -Self.commitThreshold || predicted < -Self.flickThreshold {
                        flyOff(liked: false)
                    } else {
                        withAnimation(.spring(response: 0.36, dampingFraction: 0.78)) {
                            dragOffset = .zero
                        }
                    }
                },
            including: isTop ? .gesture : .subviews
        )
        .onChange(of: store.pendingButtonSwipe) { request in
            guard isTop, let request, request.experienceID == experience.id else { return }
            store.pendingButtonSwipe = nil
            flyOff(liked: request.liked)
        }
    }

    private func flyOff(liked: Bool) {
        let direction: CGFloat = liked ? 1 : -1
        let targetX = direction * (UIScreen.main.bounds.width + 220)
        let exitHeight = max(-14, min(14, dragOffset.height * 0.3))
        withAnimation(.easeOut(duration: 0.32)) {
            dragOffset = CGSize(width: targetX, height: exitHeight)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
            store.swipeCurrent(liked: liked)
        }
    }

    private static let commitThreshold: CGFloat = 105
    private static let flickThreshold: CGFloat = 320
    private static let verticalLimit: CGFloat = 36

    private static func dampenedVertical(_ raw: CGFloat) -> CGFloat {
        let limit = verticalLimit
        let magnitude = abs(raw)
        let resisted = limit * (1 - exp(-magnitude / limit))
        return raw < 0 ? -resisted : resisted
    }
}

struct SwipeActionButton: View {
    let symbol: String
    var tint: Color = .white
    var size: CGFloat = 64
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: size * 0.36, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: size, height: size)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .overlay {
            Circle()
                .strokeBorder(Color.white.opacity(0.16), lineWidth: 0.8)
                .allowsHitTesting(false)
        }
        .shadow(color: tint.opacity(0.22), radius: 14, y: 6)
    }
}

struct SwipeIndicator: View {
    let title: String
    let systemImage: String
    let color: Color
    let opacity: Double

    private var clamped: Double { min(1, max(0, opacity)) }

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .heavy))
            Text(title)
                .font(.system(size: 19, weight: .black, design: .rounded))
                .tracking(1.6)
        }
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.28), radius: 2, y: 1)
        .padding(.horizontal, 17)
        .padding(.vertical, 10)
        .background {
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    Capsule(style: .continuous)
                        .fill(color.opacity(0.62))
                }
                .clipShape(Capsule(style: .continuous))
        }
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.85), .white.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.4
                )
                .allowsHitTesting(false)
        }
        .shadow(color: .black.opacity(0.22), radius: 9, y: 5)
        .opacity(clamped)
        .scaleEffect(0.78 + clamped * 0.22)
    }
}

struct ProfileQuestionStack: View {
    var body: some View {
        GlassCard(cornerRadius: 24, glow: true) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Profile clarity unlocked")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(.white)
                PromptRow(question: "What makes a first date feel safe?", answer: "Clear plan, warm tone, easy exit.")
                PromptRow(question: "What should QDate avoid?", answer: "Crowded bars and endless texting.")
            }
            .padding(18)
        }
    }
}

struct PromptRow: View {
    let question: String
    let answer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(QTheme.muted)
            Text(answer)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct GuidanceTasks: View {
    @EnvironmentObject private var store: DemoStore
    let scrollToSwipeDeck: () -> Void

    var body: some View {
        let tips = store.readinessImprovementTips
        if !tips.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Improve match readiness")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.leading, 2)

                ForEach(tips) { tip in
                    GuidanceTipCard(tip: tip, scrollToSwipeDeck: scrollToSwipeDeck)
                }
            }
        }
    }
}

struct GuidanceTipCard: View {
    @EnvironmentObject private var store: DemoStore
    let tip: ReadinessImprovementTip
    let scrollToSwipeDeck: () -> Void

    var body: some View {
        GlassCard(cornerRadius: 18) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: tip.symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(QTheme.electric)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(tip.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                    Text(tip.detail)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(QTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                Button {
                    store.performReadinessAction(for: tip, scrollToSwipeDeck: scrollToSwipeDeck)
                } label: {
                    Text(tip.actionTitle)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .contentShape(Capsule(style: .continuous))
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.tint(QTheme.violet.opacity(0.42)).interactive(), in: .capsule)
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 0.8)
                        .allowsHitTesting(false)
                }
                .accessibilityLabel("\(tip.actionTitle), \(tip.title)")
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }
}

struct MatchCockpit: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            GlassCard(cornerRadius: 30, glow: true) {
                VStack(spacing: 18) {
                    HStack(spacing: 16) {
                        AvatarOrb(name: store.user.name, symbol: "person.fill", color: QTheme.violet)
                        Image(systemName: "heart.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(QTheme.rose)
                        AvatarOrb(name: store.match.name, symbol: "person.fill", color: QTheme.rose)
                    }

                    VStack(spacing: 6) {
                        Text("You and \(store.match.name), \(store.match.age)")
                            .font(.system(size: 26, weight: .semibold, design: .serif))
                            .foregroundStyle(.white)
                        Text("QDate found a high-intent match in \(store.match.city).")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(QTheme.muted)
                    }

                    VStack(spacing: 10) {
                        ForEach(store.match.compatibility, id: \.self) { reason in
                            CompatibilityReason(text: reason)
                        }
                    }
                }
                .padding(20)
            }

            TimelineCard()

            GlassButton(
                title: store.stage == .timeCoordinationOpen ? "Edit Time Choices" : "Coordinate Availability",
                symbol: "calendar.badge.clock",
                prominent: true
            ) {
                store.openTimeCoordination()
            }
        }
    }
}

struct AvatarOrb: View {
    let name: String
    let symbol: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 86, height: 86)
                    .glassEffect(.regular.tint(color.opacity(0.45)), in: .circle)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.28), lineWidth: 0.8)
                            .allowsHitTesting(false)
                    }
                    .shadow(color: color.opacity(0.40), radius: 20, y: 8)
            }
            .frame(width: 86, height: 86)
            Text(name)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

struct CompatibilityReason: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(QTheme.success)
            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.82))
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct TimelineCard: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Date journey")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                TimelineRow(done: true, title: "Preferences learned", detail: "Date ideas and readiness signal collected.")
                TimelineRow(done: true, title: "Match confirmed", detail: "\(store.match.name) fits your intent and vibe.")
                TimelineRow(done: false, title: "Coordinate time", detail: "Choose shared availability.")
                TimelineRow(done: false, title: "QDate plans", detail: "Venue, route, meeting point, and plan.")
            }
            .padding(18)
        }
    }
}

struct TimelineRow: View {
    let done: Bool
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(done ? QTheme.success : QTheme.muted)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(QTheme.muted)
            }
            Spacer()
        }
    }
}

struct WaitingForMatchView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            GlassCard(cornerRadius: 28) {
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.checkmark")
                        .font(.system(size: 46, weight: .semibold))
                        .foregroundStyle(QTheme.electric)
                    Text("Your times are saved")
                        .font(.system(size: 25, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                    Text("QDate is waiting for \(store.match.name) to confirm a shared window. You can still edit your choices.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(QTheme.muted)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 12) {
                        GlassButton(title: "Edit Times", symbol: "pencil") {
                            store.openTimeCoordination()
                        }
                        GlassButton(title: "Simulate Reply", symbol: "bolt.fill", prominent: true) {
                            store.simulateSharedTime()
                        }
                    }
                }
                .padding(24)
            }
        }
    }
}

struct SharedTimeFoundView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            PlanningTicket(title: "Shared time found", status: "Sunday 19:00", detail: "\(store.match.name) accepted your strongest slot. QDate can now plan the actual date.")
            GlassButton(title: "Let QDate Plan It", symbol: "wand.and.stars", prominent: true) {
                store.startPlanning()
            }
        }
    }
}

struct DateBeingPlannedView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            PlanningTicket(title: "Planning in progress", status: "Reservation route venue", detail: "QDate is choosing a venue, meeting point, route, and the right first-date pacing.")
            GlassCard(cornerRadius: 22) {
                VStack(alignment: .leading, spacing: 12) {
                    PlanProgressRow(done: true, title: "Shared time locked")
                    PlanProgressRow(done: true, title: "Experience preference selected")
                    PlanProgressRow(done: false, title: "Venue confirmation")
                    PlanProgressRow(done: false, title: "Meeting point")
                }
                .padding(18)
            }
            GlassButton(title: "Show Final Plan", symbol: "checkmark.seal.fill", prominent: true) {
                store.finishPlan()
            }
        }
    }
}

struct PlanningTicket: View {
    let title: String
    let status: String
    let detail: String

    var body: some View {
        GlassCard(cornerRadius: 28, glow: true) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(title)
                        .font(.system(size: 24, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "ticket.fill")
                        .foregroundStyle(QTheme.electric)
                }
                Text(status)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(QTheme.success)
                Text(detail)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(QTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(22)
        }
    }
}

struct PlanProgressRow: View {
    let done: Bool
    let title: String

    var body: some View {
        HStack {
            Image(systemName: done ? "checkmark.circle.fill" : "circle.dotted")
                .foregroundStyle(done ? QTheme.success : QTheme.electric)
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 15, weight: .bold))
            Spacer()
        }
    }
}

struct DatePlanReadyView: View {
    @EnvironmentObject private var store: DemoStore
    @State private var expanded = false

    var body: some View {
        VStack(spacing: 18) {
            GlassCard(cornerRadius: 34, glow: true) {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("QDate Pass")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(QTheme.electric)
                            Text("Sunday Date With \(store.match.name)")
                                .font(.system(size: 30, weight: .semibold, design: .serif))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(QTheme.rose)
                    }

                    VStack(spacing: 12) {
                        PlanField(symbol: "calendar", label: "Date", value: "Sunday, June 7")
                        PlanField(symbol: "clock", label: "Time", value: "19:00")
                        PlanField(symbol: "mappin.and.ellipse", label: "Meeting point", value: "HafenCity coffee kiosk")
                        PlanField(symbol: "sparkles", label: "Plan", value: "Harbor glow walk plus reserved natural wine table")
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Countdown")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(QTheme.muted)
                            Text("1 day 6 hours")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        GlassIconButton(symbol: "square.and.arrow.up") {}
                    }
                }
                .padding(22)
            }

            GlassCard(cornerRadius: 22) {
                VStack(alignment: .leading, spacing: 12) {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            expanded.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Why this match works")
                                .font(.system(size: 17, weight: .bold))
                            Spacer()
                            Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        }
                        .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    if expanded {
                        ForEach(store.match.compatibility, id: \.self) { reason in
                            CompatibilityReason(text: reason)
                        }
                    }
                }
                .padding(18)
            }
        }
    }
}

struct PlanField: View {
    let symbol: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(QTheme.electric)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                Text(value)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct CompassScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                if store.isCompassLocked {
                    LockedBanner()
                }

                PreferenceSection(title: "Date budget", locked: store.isCompassLocked) {
                    ChipPicker(options: ["Light", "Medium", "Premium"], selection: $store.selectedBudget, locked: store.isCompassLocked)
                }

                PreferenceSection(title: "Desired match", locked: store.isCompassLocked) {
                    ChipPicker(options: ["Women", "Men", "Non-binary", "Open"], selection: $store.selectedGender, locked: store.isCompassLocked)
                }

                PreferenceSection(title: "Age range", locked: store.isCompassLocked) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(Int(store.minAge))")
                            Spacer()
                            Text("\(Int(store.maxAge))")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        Slider(value: $store.minAge, in: 21...40)
                            .disabled(store.isCompassLocked)
                        Slider(value: $store.maxAge, in: 24...46)
                            .disabled(store.isCompassLocked)
                    }
                }

                PreferenceSection(title: "Weekly availability", locked: store.isCompassLocked) {
                    WeeklyAvailabilityEditor(locked: store.isCompassLocked)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 96)
        }
    }
}

struct LockedBanner: View {
    var body: some View {
        GlassCard(cornerRadius: 22, glow: true) {
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(QTheme.electric)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Compass locked")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Preferences are frozen while QDate coordinates this match.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(QTheme.muted)
                }
                Spacer()
            }
            .padding(16)
        }
    }
}

struct PreferenceSection<Content: View>: View {
    let title: String
    let locked: Bool
    @ViewBuilder var content: Content

    var body: some View {
        GlassCard(cornerRadius: 24) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    if locked {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(QTheme.muted)
                    }
                }
                content
                    .opacity(locked ? 0.58 : 1)
            }
            .padding(18)
        }
    }
}

struct ChipMultiPicker: View {
    let options: [String]
    @Binding var selection: Set<String>
    let locked: Bool
    var minimumSelection = 1

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 98), spacing: 10)], spacing: 10) {
            ForEach(options, id: \.self) { option in
                let isSelected = selection.contains(option)
                Button {
                    guard !locked else { return }
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                        if isSelected {
                            guard selection.count > minimumSelection else { return }
                            selection.remove(option)
                        } else {
                            selection.insert(option)
                        }
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(isSelected ? QTheme.violet.opacity(0.55) : Color.white.opacity(0.08), in: Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(isSelected ? 0.34 : 0.10), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .disabled(locked)
            }
        }
    }
}

struct FilterCategoryChip: View {
    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selected ? QTheme.violet.opacity(0.48) : Color.white.opacity(0.08), in: Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(selected ? 0.34 : 0.10), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct ChipPicker: View {
    let options: [String]
    @Binding var selection: String
    let locked: Bool

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 98), spacing: 10)], spacing: 10) {
            ForEach(options, id: \.self) { option in
                Button {
                    guard !locked else { return }
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                        selection = option
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(selection == option ? QTheme.violet.opacity(0.55) : Color.white.opacity(0.08), in: Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(selection == option ? 0.34 : 0.10), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .disabled(locked)
            }
        }
    }
}

struct WeeklyAvailabilityEditor: View {
    @EnvironmentObject private var store: DemoStore
    let locked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(spacing: 0) {
                ForEach(Array(Weekday.allCases.enumerated()), id: \.element.id) { index, weekday in
                    AvailabilitySummaryRow(weekday: weekday)

                    if index < Weekday.allCases.count - 1 {
                        Divider()
                            .overlay(Color.white.opacity(0.08))
                    }
                }
            }
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            if !locked {
                Button {
                    store.showAvailabilityEditor = true
                } label: {
                    Label("Edit availability", systemImage: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(QTheme.electric)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct AvailabilitySummaryRow: View {
    @EnvironmentObject private var store: DemoStore
    let weekday: Weekday

    var body: some View {
        HStack(spacing: 12) {
            Text(weekday.title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 96, alignment: .leading)

            if let slot = store.availabilitySlot(for: weekday) {
                Text(slot.formattedRange)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer(minLength: 8)
                Circle()
                    .fill(QTheme.success)
                    .frame(width: 8, height: 8)
            } else {
                Text("Unavailable")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(QTheme.muted)
                Spacer(minLength: 8)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

struct WeeklyAvailabilityEditScreen: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedWeekday: Weekday = .monday

    private var selectedSlotIndex: Int? {
        store.weeklyAvailability.firstIndex { $0.weekday == selectedWeekday }
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Edit availability")
                            .font(.system(size: 30, weight: .semibold, design: .serif))
                            .foregroundStyle(.white)
                        Text("Choose a day, then add or update one time slot.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    GlassIconButton(symbol: "xmark") {
                        close()
                    }
                }

                Text("Select day")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(QTheme.muted)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Weekday.allCases) { weekday in
                            let isSelected = selectedWeekday == weekday
                            let hasSlot = store.availabilitySlot(for: weekday) != nil

                            Button {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                    selectedWeekday = weekday
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Text(weekday.shortTitle)
                                        .font(.system(size: 14, weight: .bold))
                                    Circle()
                                        .fill(hasSlot ? QTheme.success : Color.white.opacity(0.18))
                                        .frame(width: 6, height: 6)
                                }
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(isSelected ? QTheme.violet.opacity(0.55) : Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.white.opacity(isSelected ? 0.34 : 0.10), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                GlassCard(cornerRadius: 22) {
                    VStack(alignment: .leading, spacing: 16) {
                            Text(selectedWeekday.title)
                                .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)

                        if let index = selectedSlotIndex {
                            AvailabilitySlotEditor(
                                startTime: $store.weeklyAvailability[index].startTime,
                                endTime: $store.weeklyAvailability[index].endTime
                            )

                            Button {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                    store.removeAvailabilitySlot(for: selectedWeekday)
                                }
                            } label: {
                                Label("Remove slot", systemImage: "trash")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(QTheme.warning)
                            }
                            .buttonStyle(.plain)
                        } else {
                            Text("No availability set for this day.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(QTheme.muted)

                            GlassButton(title: "Add time slot", symbol: "plus.circle.fill", prominent: true) {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                    store.addAvailabilitySlot(for: selectedWeekday)
                                }
                            }
                        }
                    }
                    .padding(18)
                }

                Spacer()

                GlassButton(title: "Done", symbol: "checkmark", prominent: true) {
                    close()
                }
            }
            .padding(20)
        }
    }

    private func close() {
        store.showAvailabilityEditor = false
        dismiss()
    }
}

struct AvailabilitySlotEditor: View {
    @Binding var startTime: Date
    @Binding var endTime: Date

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("Start")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                    .frame(width: 42, alignment: .leading)
                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(QTheme.electric)
                    .onChange(of: startTime) { _, newStart in
                        if endTime <= newStart {
                            endTime = Calendar.current.date(byAdding: .hour, value: 2, to: newStart) ?? newStart
                        }
                    }
                Spacer()
            }

            HStack(spacing: 12) {
                Text("End")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                    .frame(width: 42, alignment: .leading)
                DatePicker("", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(QTheme.electric)
                Spacer()
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct ProfileScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    ProfileHeader()
                    EditableProfileSection(title: "Vibe", editID: "vibe") {
                        VibeCardContent(vibe: store.profileVibe)
                    }
                    EditableProfileSection(title: "Favorites", editID: "favorites") {
                        FavoritesCardContent()
                    }
                    EditableProfileSection(title: "Interests", editID: "interests") {
                        TagWrap(tags: store.interests)
                    }
                    EditableProfileSection(title: "Bucket List", editID: "bucket") {
                        BucketListCardContent()
                    }
                    EditableProfileSection(title: "Career / Life Path", editID: "career") {
                        CareerLifePathContent()
                    }
                    EditableProfileSection(title: "About You", editID: "about") {
                        Text(store.aboutText)
                            .profileText()
                    }
                    ProfileQuestionCards()
                    SettingsLinks()
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 96)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ProfileHeader: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 30, glow: true) {
            VStack(spacing: 16) {
                Button {
                    store.showPhotoEditor = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(QTheme.violet)
                            .frame(width: 118, height: 118)
                            .shadow(color: QTheme.violet.opacity(0.35), radius: 26, y: 12)
                        Image(systemName: "person.fill")
                            .font(.system(size: 46, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)

                VStack(spacing: 5) {
                    Text("\(store.user.name), \(store.user.age)")
                        .font(.system(size: 28, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                    Text(store.user.city)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(QTheme.muted)
                }

                GlassButton(title: "Edit Photo", symbol: "camera.fill", prominent: true) {
                    store.showPhotoEditor = true
                }
            }
            .padding(22)
        }
    }
}

struct EditableProfileSection<Content: View>: View {
    @EnvironmentObject private var store: DemoStore
    let title: String
    let editID: String
    @ViewBuilder var content: Content

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        store.editingProfileSection = ProfileEditContext(id: editID, title: title)
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(Color.white.opacity(0.10), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Edit \(title)")
                }
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
        }
    }
}

struct VibeCardContent: View {
    let vibe: ProfileVibe

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(VibeDimension.allCases) { dimension in
                FavoriteRow(label: dimension.displayLabel, value: vibe.selection(for: dimension))
            }
        }
    }
}

struct VibeEditor: View {
    @Binding var vibe: ProfileVibe

    var body: some View {
        VStack(spacing: 14) {
            ForEach(VibeDimension.allCases) { dimension in
                GlassCard(cornerRadius: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(dimension.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(QTheme.muted)
                        ChipPicker(
                            options: dimension.options,
                            selection: binding(for: dimension),
                            locked: false
                        )
                    }
                    .padding(16)
                }
            }
        }
    }

    private func binding(for dimension: VibeDimension) -> Binding<String> {
        Binding(
            get: { vibe.selection(for: dimension) },
            set: { vibe.setSelection($0, for: dimension) }
        )
    }
}

struct FavoritesCardContent: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            FavoriteRow(label: "Artist", value: store.favoriteArtist)
            FavoriteRow(label: "Song", value: store.favoriteSong)
            FavoriteRow(label: "Movie", value: store.favoriteMovie)
            FavoriteRow(label: "Food", value: store.favoriteFood)
            FavoriteRow(label: "Travel Destination", value: store.favoriteDestination)
            FavoriteRow(label: "Book", value: store.favoriteBook)
        }
    }
}

struct FavoriteRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(QTheme.muted)
            Spacer()
            Text(value.isEmpty ? "Not specified" : value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct BucketListCardContent: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProfileQuestionValue(question: "Biggest wish for the future", value: store.biggestWish)

            VStack(alignment: .leading, spacing: 8) {
                Text("Three things I would like to experience")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(QTheme.muted)

                ForEach(Array(store.bucketExperiences.enumerated()), id: \.offset) { index, value in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(QTheme.electric)
                            .frame(width: 18)
                        Text(value)
                            .profileText()
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
    }
}

struct CareerLifePathContent: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProfileQuestionValue(question: "As a child, I wanted to become", value: store.childhoodDream)
            ProfileQuestionValue(question: "What I do today", value: store.currentPath)
        }
    }
}

struct ProfileQuestionValue: View {
    let question: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(question)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(QTheme.muted)
            Text(value.isEmpty ? "Add an answer" : value)
                .profileText()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ProfileQuestionCards: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("QDate Questions")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Choose up to five personality cards. Each card can have multiple answers.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(QTheme.muted)
                }

                VStack(spacing: 10) {
                    ForEach(store.profileQuestionSlots.indices, id: \.self) { index in
                        QuestionSlotCard(slot: store.profileQuestionSlots[index], index: index)
                    }
                }
            }
            .padding(18)
        }
    }
}

struct QuestionSlotCard: View {
    @EnvironmentObject private var store: DemoStore
    let slot: ProfileQuestionSlot
    let index: Int

    var body: some View {
        Button {
            store.editingQuestionSlot = QuestionEditContext(id: slot.id)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(slot.questionID == nil ? Color.white.opacity(0.09) : QTheme.violet.opacity(0.32))
                        .frame(width: 34, height: 34)
                    Text("\(index + 1)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(definition?.question ?? "Choose a question")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                    if slot.selectedAnswers.isEmpty {
                        Text("Tap to select a prompt and answers")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    } else {
                        TagWrap(tags: Array(slot.selectedAnswers).sorted())
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                    .padding(.top, 5)
            }
            .padding(14)
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var definition: ProfilePromptDefinition? {
        store.profilePromptDefinitions.first { $0.id == slot.questionID }
    }
}

extension Text {
    func profileText() -> some View {
        self.font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Color.white.opacity(0.82))
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct TagWrap: View {
    let tags: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 94), spacing: 8)], spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.09), in: Capsule())
            }
        }
    }
}

struct SettingsLinks: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(spacing: 4) {
                NavigationLink {
                    AccountSettingsScreen()
                } label: {
                    SettingsRow(symbol: "person.badge.key", title: "Account settings")
                }
                NavigationLink {
                    AppSettingsScreen()
                } label: {
                    SettingsRow(symbol: "switch.2", title: "App settings")
                }
                NavigationLink {
                    SupportFAQScreen()
                } label: {
                    SettingsRow(symbol: "questionmark.circle", title: "Support and FAQ")
                }
                Toggle("Notifications", isOn: $store.notificationsEnabled)
                    .tint(QTheme.violet)
                    .foregroundStyle(.white)
                    .padding(12)
            }
            .padding(6)
        }
    }
}

struct SettingsRow: View {
    let symbol: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(QTheme.electric)
                .frame(width: 28)
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(QTheme.muted)
        }
        .padding(12)
        .contentShape(Rectangle())
    }
}

struct AccountSettingsScreen: View {
    var body: some View {
        SettingsDetailScreen(title: "Account") {
            DetailLine(title: "Demo user", value: "Chris")
            DetailLine(title: "Email", value: "demo@qdate.app")
            DetailLine(title: "Privacy", value: "Local mock state")
        }
    }
}

struct AppSettingsScreen: View {
    var body: some View {
        SettingsDetailScreen(title: "App") {
            DetailLine(title: "Theme", value: "Liquid Glass dark")
            DetailLine(title: "Haptics", value: "Enabled")
            DetailLine(title: "Autosave", value: "On")
        }
    }
}

struct SupportFAQScreen: View {
    var body: some View {
        SettingsDetailScreen(title: "Support") {
            DetailLine(title: "What does QDate plan?", value: "Time, place, route, and date flow.")
            DetailLine(title: "Is this production?", value: "No, hackathon demo state only.")
            DetailLine(title: "Can I cancel?", value: "A future version would support this.")
        }
    }
}

struct SettingsDetailScreen<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(title)
                        .font(.system(size: 32, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                    GlassCard(cornerRadius: 22) {
                        VStack(spacing: 10) {
                            content
                        }
                        .padding(18)
                    }
                }
                .padding(20)
            }
        }
    }
}

struct DetailLine: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(QTheme.muted)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 8)
    }
}

struct FilterSheet: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss
    @State private var draftBudgetTiers: Set<String> = []
    @State private var draftCategories: Set<String> = []

    private var isValid: Bool {
        !draftBudgetTiers.isEmpty && !draftCategories.isEmpty
    }

    private var sortedSelectedTiers: [String] {
        DateFilterCatalog.tiers.filter { draftBudgetTiers.contains($0) }
    }

    private var swipeCount: Int {
        store.totalSwipeCount
    }

    private var hasSwipeProgress: Bool {
        swipeCount > 0
    }

    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date filters")
                        .font(.system(size: 30, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)

                    Text("\(store.totalSwipeCount) swiped · \(store.likedExperienceIDs.count) liked · \(store.dislikedExperienceIDs.count) skipped")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(QTheme.muted)
                }

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        PreferenceSection(title: "Budget tier", locked: false) {
                            ChipMultiPicker(
                                options: DateFilterCatalog.tiers,
                                selection: $draftBudgetTiers,
                                locked: false,
                                minimumSelection: 1
                            )
                        }

                        if sortedSelectedTiers.isEmpty {
                            Text("Select at least one budget tier to see categories.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(QTheme.muted)
                        } else {
                            ForEach(sortedSelectedTiers, id: \.self) { tier in
                                PreferenceSection(title: "\(tier) categories", locked: false) {
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 116), spacing: 8)], spacing: 8) {
                                        ForEach(DateFilterCatalog.categoriesByTier[tier] ?? [], id: \.self) { category in
                                            FilterCategoryChip(
                                                title: category,
                                                selected: draftCategories.contains(category)
                                            ) {
                                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                                    if draftCategories.contains(category) {
                                                        draftCategories.remove(category)
                                                    } else {
                                                        draftCategories.insert(category)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if !isValid {
                    Text("Pick at least one budget tier and one category.")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(QTheme.warning)
                }

                GlassButton(title: "Apply Filters", symbol: "checkmark", prominent: true) {
                    store.applyFilters(budgetTiers: draftBudgetTiers, categories: draftCategories)
                    store.showFilters = false
                    dismiss()
                }
                .opacity(isValid ? 1 : 0.45)
                .disabled(!isValid)

                Button {
                    store.resetSwipes()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reset swipes")
                                .font(.system(size: 15, weight: .bold))
                            Text(hasSwipeProgress
                                 ? "Clears your \(swipeCount) swiped ideas and starts fresh."
                                 : "Clears swiped date ideas and starts fresh.")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(QTheme.muted)
                        }
                        Spacer()
                    }
                    .foregroundStyle(hasSwipeProgress ? .white : Color.white.opacity(0.55))
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.14), lineWidth: 0.8)
                        .allowsHitTesting(false)
                }
                .disabled(!hasSwipeProgress)
            }
            .padding(20)
        }
        .onAppear {
            draftBudgetTiers = store.appliedBudgetTiers
            draftCategories = store.appliedFilterCategories
        }
    }
}

struct ExperienceDetailSheet: View {
    let experience: DateExperience

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(LinearGradient(colors: experience.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 220)
                        .overlay {
                            if let imageName = experience.backgroundImageName {
                                GeometryReader { geo in
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                                        .offset(y: -geo.size.height * 0.12)
                                        .frame(width: geo.size.width, height: geo.size.height)
                                        .clipped()
                                }
                            } else {
                                Image(systemName: experience.symbol)
                                    .font(.system(size: 96, weight: .thin))
                                    .foregroundStyle(.white.opacity(0.30))
                            }
                        }
                        .overlay {
                            LinearGradient(colors: [.clear, .black.opacity(0.78)], startPoint: .top, endPoint: .bottom)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .overlay(alignment: .topTrailing) {
                            Text(experience.budget)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 14)
                                .glassEffect(.regular.tint(QTheme.glassTint.opacity(0.4)), in: .capsule)
                                .padding(14)
                        }

                    VStack(alignment: .leading, spacing: 14) {
                        Label(experience.activity, systemImage: "sparkle")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white.opacity(0.85))

                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 14, weight: .bold))
                                Text(experience.location)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundStyle(QTheme.electric)

                            Text(experience.title)
                                .font(.system(size: 32, weight: .semibold, design: .serif))
                                .foregroundStyle(.white)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Text(experience.description)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(QTheme.muted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(20)
            }
        }
    }
}

struct TimeCoordinationSheet: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Coordinate time")
                            .font(.system(size: 32, weight: .semibold, design: .serif))
                            .foregroundStyle(.white)
                        Text("Select every slot that works. \(store.match.name)'s status updates as QDate coordinates.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    GlassIconButton(symbol: "xmark") {
                        store.showTimeCoordination = false
                        dismiss()
                    }
                }

                VStack(spacing: 12) {
                    ForEach(store.timeSlots) { slot in
                        TimeSlotRow(slot: slot, selected: store.selectedTimeSlotIDs.contains(slot.id)) {
                            if store.selectedTimeSlotIDs.contains(slot.id) {
                                store.selectedTimeSlotIDs.remove(slot.id)
                            } else {
                                store.selectedTimeSlotIDs.insert(slot.id)
                            }
                        }
                    }
                }

                Spacer()

                HStack(spacing: 12) {
                    GlassButton(title: "Decline All", symbol: "xmark") {
                        store.selectedTimeSlotIDs.removeAll()
                    }
                    GlassButton(title: "Submit Times", symbol: "paperplane.fill", prominent: true) {
                        if store.selectedTimeSlotIDs.isEmpty, let accepted = store.timeSlots.first(where: { $0.partnerStatus == .accepted }) {
                            store.selectedTimeSlotIDs.insert(accepted.id)
                        }
                        store.submitTimes()
                    }
                }

                CancelMatchButton()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }
            .padding(20)
        }
    }
}

struct TimeSlotRow: View {
    let slot: TimeSlot
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            GlassCard(cornerRadius: 22, glow: selected) {
                HStack(spacing: 14) {
                    Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(selected ? QTheme.success : QTheme.muted)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(slot.day) \(slot.time)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text(slot.note)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    Text(slot.partnerStatus.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(slot.partnerStatus.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(slot.partnerStatus.color.opacity(0.14), in: Capsule())
                }
                .padding(16)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ProfileEditSheet: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss
    let context: ProfileEditContext

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Edit \(context.title)")
                            .font(.system(size: 30, weight: .semibold, design: .serif))
                            .foregroundStyle(.white)
                        Spacer()
                        GlassIconButton(symbol: "xmark") {
                            store.editingProfileSection = nil
                            dismiss()
                        }
                    }

                    editorContent

                    GlassButton(title: "Done", symbol: "checkmark", prominent: true) {
                        store.editingProfileSection = nil
                        dismiss()
                    }
                }
                .padding(20)
            }
        }
    }

    @ViewBuilder
    private var editorContent: some View {
        switch context.id {
        case "vibe":
            VibeEditor(vibe: $store.profileVibe)
        case "about":
            GlassTextEditor(title: "About You", text: $store.aboutText, axis: .vertical)
        case "favorites":
            FavoritesEditor(
                artist: $store.favoriteArtist,
                song: $store.favoriteSong,
                movie: $store.favoriteMovie,
                food: $store.favoriteFood,
                destination: $store.favoriteDestination,
                book: $store.favoriteBook
            )
        case "interests":
            CategorizedInterestPicker(selectedInterests: $store.interests)
        case "bucket":
            GlassTextEditor(title: "Biggest wish for the future", text: $store.biggestWish, axis: .vertical)
            ForEach(0..<3, id: \.self) { index in
                GlassTextEditor(title: "\(index + 1)", text: bindingForBucketExperience(index), axis: .vertical)
            }
        case "career":
            GlassTextEditor(title: "As a child, I wanted to become", text: $store.childhoodDream, axis: .vertical)
            GlassTextEditor(title: "What I do today", text: $store.currentPath, axis: .vertical)
        default:
            Text("Nothing to edit")
                .profileText()
        }
    }

    private func bindingForBucketExperience(_ index: Int) -> Binding<String> {
        Binding(
            get: {
                guard store.bucketExperiences.indices.contains(index) else { return "" }
                return store.bucketExperiences[index]
            },
            set: { newValue in
                guard store.bucketExperiences.indices.contains(index) else { return }
                store.bucketExperiences[index] = newValue
            }
        )
    }
}

struct GlassTextEditor: View {
    let title: String
    @Binding var text: String
    var axis: Axis = .vertical

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                TextField(title, text: $text, axis: axis)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(axis == .vertical ? 2...5 : 1...1)
                    .padding(12)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(16)
        }
    }
}

struct FavoritesEditor: View {
    @Binding var artist: String
    @Binding var song: String
    @Binding var movie: String
    @Binding var food: String
    @Binding var destination: String
    @Binding var book: String

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 14) {
                FavoriteEditField(title: "Artist", text: $artist)
                FavoriteEditField(title: "Song", text: $song)
                FavoriteEditField(title: "Movie", text: $movie)
                FavoriteEditField(title: "Food", text: $food)
                FavoriteEditField(title: "Travel Destination", text: $destination)
                FavoriteEditField(title: "Book", text: $book)
            }
            .padding(16)
        }
    }
}

struct FavoriteEditField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(QTheme.muted)
            TextField("Enter favorite \(title.lowercased())", text: $text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .textFieldStyle(.plain)
        }
    }
}

struct EditableTagList: View {
    let title: String
    @Binding var tags: [String]
    let suggestions: [String]

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 14) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(QTheme.muted)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 116), spacing: 8)], spacing: 8) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button {
                            if tags.contains(suggestion) {
                                tags.removeAll { $0 == suggestion }
                            } else {
                                tags.append(suggestion)
                            }
                        } label: {
                            Text(suggestion)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(tags.contains(suggestion) ? QTheme.violet.opacity(0.48) : Color.white.opacity(0.08), in: Capsule())
                                .overlay(Capsule().stroke(Color.white.opacity(tags.contains(suggestion) ? 0.34 : 0.10), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
        }
    }
}

struct InterestCategory: Identifiable {
    let id = UUID()
    let title: String
    let interests: [String]
}

struct CategorizedInterestPicker: View {
    @Binding var selectedInterests: [String]
    private let maxSelection = 20
    private let categories: [InterestCategory] = [
        InterestCategory(title: "Sports & Movement", interests: ["🏃 Running", "🏋️ Gym", "🧘 Yoga", "🚴 Cycling", "🥾 Hiking", "🧗 Climbing", "🏊 Swimming", "⚽ Football", "🎾 Tennis", "🏀 Basketball", "🏐 Volleyball", "🛹 Skateboarding", "🥊 Boxing", "💃 Dancing", "🚶 Long walks"]),
        InterestCategory(title: "Outdoors & Nature", interests: ["🌲 Nature walks", "🏕️ Camping", "🌊 Beach days", "🌅 Sunsets", "🪴 Houseplants", "🐶 Dogs", "🐱 Cats", "🐾 Animal lover", "🌿 Gardening", "🧺 Picnics", "🚣 Kayaking", "🏔️ Mountains"]),
        InterestCategory(title: "Food & Drinks", interests: ["☕ Coffee", "🍵 Tea", "🍷 Wine tasting", "🍹 Cocktails", "🍸 Mocktails", "🍕 Pizza", "🍣 Sushi", "🍝 Italian food", "🌮 Street food", "🧁 Baking", "👨‍🍳 Cooking", "🥐 Brunch", "🌱 Vegetarian food", "🌶️ Spicy food"]),
        InterestCategory(title: "Culture & Going Out", interests: ["🎬 Movies", "📺 Series", "🎭 Theatre", "🎤 Stand up comedy", "🎶 Concerts", "🎧 Festivals", "🖼️ Museums", "📚 Bookstores", "🎨 Art galleries", "🕺 Nightlife", "🎲 Board games", "🧩 Quiz nights", "🎳 Bowling"]),
        InterestCategory(title: "Music", interests: ["🎧 Playlists", "🎸 Indie music", "🎤 Pop music", "🎹 Jazz", "🎧 Electronic music", "🎸 Rock", "🤘 Metal", "🎼 Classical music", "🎵 New music", "🎙️ Podcasts"]),
        InterestCategory(title: "Creative & Personal", interests: ["📸 Photography", "🎨 Painting", "✍️ Writing", "🧶 DIY projects", "🪡 Fashion", "🧵 Thrifting", "🎥 Filmmaking", "🎮 Gaming", "🧠 Learning new things", "🗣️ Deep talks", "😂 Memes"]),
        InterestCategory(title: "Travel & Adventure", interests: ["✈️ Travel", "🧳 City trips", "🏝️ Weekend getaways", "🚗 Road trips", "🗺️ Hidden gems", "🏛️ Historic places", "🌍 Different cultures", "🏨 Boutique hotels", "🚆 Train trips", "🧭 Spontaneous plans"]),
        InterestCategory(title: "Lifestyle & Values", interests: ["🧘 Self care", "🛁 Spa days", "🕯️ Slow mornings", "🧼 Clean living", "🌱 Sustainability", "🤝 Volunteering", "🧑‍🤝‍🧑 Community events", "🧘 Meditation", "🧠 Personal growth", "🏡 Cozy nights in"])
    ]

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Interests")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Select up to \(maxSelection). Categories are only here to make scanning faster.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    Text("\(selectedInterests.count)/\(maxSelection)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(selectedInterests.count >= maxSelection ? QTheme.warning : QTheme.electric)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.09), in: Capsule())
                }

                VStack(alignment: .leading, spacing: 18) {
                    ForEach(categories) { category in
                        VStack(alignment: .leading, spacing: 10) {
                                Text(category.title)
                                    .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.white)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 136), spacing: 8)], spacing: 8) {
                                ForEach(category.interests, id: \.self) { interest in
                                    InterestChip(
                                        title: interest,
                                        selected: selectedInterests.contains(interest),
                                        disabled: selectedInterests.count >= maxSelection && !selectedInterests.contains(interest)
                                    ) {
                                        toggle(interest)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
    }

    private func toggle(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.removeAll { $0 == interest }
        } else if selectedInterests.count < maxSelection {
            selectedInterests.append(interest)
        } else {
            Haptics.light()
        }
    }
}

struct InterestChip: View {
    let title: String
    let selected: Bool
    let disabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(disabled ? Color.white.opacity(0.38) : .white)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(.horizontal, 10)
                .background(selected ? QTheme.violet.opacity(0.50) : Color.white.opacity(disabled ? 0.04 : 0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(selected ? QTheme.electric.opacity(0.60) : Color.white.opacity(0.10), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

struct QuestionSlotEditSheet: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss
    let slotID: UUID

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Edit question")
                                .font(.system(size: 30, weight: .semibold, design: .serif))
                                .foregroundStyle(.white)
                            Text("Pick one question, then select all answers that fit.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(QTheme.muted)
                        }
                        Spacer()
                        GlassIconButton(symbol: "xmark") {
                            store.editingQuestionSlot = nil
                            dismiss()
                        }
                    }

                    GlassCard(cornerRadius: 22) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Question")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.white)
                            ForEach(store.profilePromptDefinitions) { definition in
                                QuestionChoiceRow(definition: definition, selected: currentSlot?.questionID == definition.id) {
                                    updateSlot { slot in
                                        slot.questionID = definition.id
                                        slot.selectedAnswers = []
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }

                    if let definition = selectedDefinition {
                        GlassCard(cornerRadius: 22, glow: true) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Answers")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.white)
                                ForEach(definition.answers, id: \.self) { answer in
                                    MultiSelectAnswerRow(answer: answer, selected: currentSlot?.selectedAnswers.contains(answer) ?? false) {
                                        updateSlot { slot in
                                            if slot.selectedAnswers.contains(answer) {
                                                slot.selectedAnswers.remove(answer)
                                            } else {
                                                slot.selectedAnswers.insert(answer)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(16)
                        }
                    }

                    GlassButton(title: "Done", symbol: "checkmark", prominent: true) {
                        store.editingQuestionSlot = nil
                        dismiss()
                    }
                }
                .padding(20)
            }
        }
    }

    private var currentSlot: ProfileQuestionSlot? {
        store.profileQuestionSlots.first { $0.id == slotID }
    }

    private var selectedDefinition: ProfilePromptDefinition? {
        guard let questionID = currentSlot?.questionID else { return nil }
        return store.profilePromptDefinitions.first { $0.id == questionID }
    }

    private func updateSlot(_ update: (inout ProfileQuestionSlot) -> Void) {
        guard let index = store.profileQuestionSlots.firstIndex(where: { $0.id == slotID }) else { return }
        update(&store.profileQuestionSlots[index])
    }
}

struct QuestionChoiceRow: View {
    let definition: ProfilePromptDefinition
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selected ? QTheme.success : QTheme.muted)
                Text(definition.question)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(12)
            .background(selected ? QTheme.violet.opacity(0.22) : Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct MultiSelectAnswerRow: View {
    let answer: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: selected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(selected ? QTheme.success : QTheme.muted)
                Text(answer)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(12)
            .background(selected ? QTheme.violet.opacity(0.25) : Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct PhotoEditSheet: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 18) {
                Text("Photo editor")
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)
                Text("Demo-safe mock. No camera or library access required.")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(QTheme.muted)
                    .multilineTextAlignment(.center)
                GlassButton(title: "Use Current Photo", symbol: "person.crop.circle", prominent: true) {
                    store.showPhotoEditor = false
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    ContentView()
}
