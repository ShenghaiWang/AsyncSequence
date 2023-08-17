import Foundation
import AsyncAlgorithms

// Conform to AsyncSequence
struct DiceRolling: AsyncSequence {
    typealias Element = Int
    let times: Int

    init(times: Int = 3) {
        self.times = times
    }

    struct AsyncIterator: AsyncIteratorProtocol {
        var times: Int

        mutating func next() async -> Int? {
            guard !Task.isCancelled, times > 0 else { return nil }
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
            } catch {
                return nil
                // Ignore error handling here for simpliciry.
            }
            times -= 1
            return (1...6).randomElement()
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(times: times)
    }
}

for await diceValue in DiceRolling() {
    print(diceValue)
}

// Use AsyncStream
struct DiceRollingStream {
    let queue = DispatchQueue(label: "test.asyncstream.queue")
    let times: Int

    init(times: Int = 3) {
        self.times = times
    }

    var stream: AsyncStream<Int> {
        AsyncStream { continuation in
            (1...times).forEach { _ in
                queue.async {
                    Thread.sleep(forTimeInterval: 2)
                    continuation.yield((1...6).randomElement() ?? 1)
                }
            }
            queue.async {
                continuation.finish()
            }
        }
    }
}

for await diceValue in DiceRollingStream().stream {
    print(diceValue)
}


// Use .async syntax
for await diceValue in [1, 2, 3, 4, 5, 6].shuffled().async.prefix(3) {
    print(diceValue)
}

// Use AsyncChannel
class DiceRollingChannel {
    let channel = AsyncChannel<Int>()

    init(times: Int = 3) {
        Task {
            for _ in 1...times {
                do {
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                } catch {
                    // Ignore error handling here for simpliciry.
                    // Can use AsyncThrowingChannel to handle error if needed
                }
                await channel.send((1...6).randomElement() ?? 1)
            }
            channel.finish()
        }
    }
}

for await diceValue in DiceRollingChannel().channel {
    print(diceValue)
}
