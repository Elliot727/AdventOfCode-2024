package day01

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func Part1() int {
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

	sort.Ints(left)
	sort.Ints(right)

	if len(left) != len(right) {
		fmt.Println("Error: Lists have different lengths")
		return -1
	}

	totalDistance := 0
	for i := 0; i < len(left); i++ {
		distance := left[i] - right[i]
		if distance < 0 {
			distance = -distance
		}
		totalDistance += distance
	}

	return totalDistance
}
