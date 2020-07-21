

// https://leetcode.com/problems/valid-sudoku/

let input = [
  ["5","3",".",".","7",".",".",".","."],
  ["6",".",".","1","9","5",".",".","."],
  [".","9","8",".",".",".",".","6","."],
  ["8",".",".",".","6",".",".",".","3"],
  ["4",".",".","8",".","3",".",".","1"],
  ["7",".",".",".","2",".",".",".","6"],
  [".","6",".",".",".",".","2","8","."],
  [".",".",".","4","1","9",".",".","5"],
  [".",".",".",".","8",".",".","7","9"]
]

class Cell {
	let initial: Int?
	var guesses = Set<Int>()
	var isFound: Bool { guesses.count == 1 }
	var value: Int? {
		if let initial = initial {
			return initial
		} else if isFound {
			return guesses.first!
		} else {
			return nil
		}
	}

	init(initial: Int?) {
		self.initial = initial
	}

	func updatedGuesses(_ newGuesses: Set<Int>) -> Bool {
		guard initial == nil, !isFound else { return false }
		if guesses.count == 0 {
			guesses = newGuesses
		} else {
			guesses = guesses.intersection(newGuesses)
		}
		return isFound
	}
}

extension Array where Element == [Cell] {
	var rows: [[Cell]] {
		return self
	}

	var columns: [[Cell]] {
		// make a copy of self
		var retVal = self
		// transpose
		for i in 0..<self.count {
			for j in 0..<self.count {
				retVal[i][j] = self[j][i]
			}
		}
		return retVal
	}

	var cells: [[Cell]] {
		var retVal = self
		var cellID = 0
		var targetI = 0
		var targetJ = 0
		while cellID < self.count {
			let startI = (cellID % 3) * 3
			let startJ = (cellID / 3) * 3
			for i in startI..<startI+3 {
				for j in startJ..<startJ+3 {
					retVal[targetI][targetJ] = self[i][j]
					targetJ += 1
				}
			}
			targetJ = 0
			targetI += 1
			cellID += 1
		}
		return retVal
	}

	func debug(_ message: String) {
		print(message)
		var result = ""
		for row in self {
			for cell in row {
				if let initial = cell.initial {
					result += "\(initial), "
				} else if cell.isFound {
					result += "\(cell.guesses.first!)!, "
				} else {
					result += "\(cell.guesses.map { $0 }), "
				}
			}
			result += "\n"
		}
		print(result)
	}
}

var table: [[Cell]] = input.map { $0.map {
	return Cell(initial: Int($0))
}}

table.debug("Initial:")

// preform "hidden singles" reduction until no more
var found = true
var count = 1
while found {
	found = false
	for boxType in [table.rows, table.columns, table.cells] {
		for box in boxType {
			let options = Set(1...9).subtracting(box.compactMap { $0.value })
			box.forEach {
				found = found || $0.updatedGuesses(options)
			}
		}
	}
	table.debug("Step \(count)")
	count += 1
}
