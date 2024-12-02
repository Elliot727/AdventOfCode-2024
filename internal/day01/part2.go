package day01

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func Part2() int {
	var left, right []int
	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {
		parts := strings.Fields(scanner.Text())
		if len(parts) != 2 {
			fmt.Println("Error: Invalid input format")
			return -1
		}
		leftID, err1 := strconv.Atoi(parts[0])
		rightID, err2 := strconv.Atoi(parts[1])
		if err1 != nil || err2 != nil {
			fmt.Println("Error: Invalid integer input")
			return -1
		}
		left = append(left, leftID)
		right = append(right, rightID)
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading input:", err)
		return -1
	}

	rightCounts := make(map[int]int)
	for _, num := range right {
		rightCounts[num]++
	}

	similarityScore := 0
	for _, num := range left {
		similarityScore += num * rightCounts[num]
	}

	return similarityScore
}
