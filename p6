using System;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Enter task names and estimates for best, worst, and average case scenarios:");
        string[] tasks = new string[3];
        int[,] estimates = new int[3, 3];
        for (int i = 0; i < 3; i++)
        {
            Console.Write($"Task {i + 1} name: ");
            tasks[i] = Console.ReadLine();
            Console.Write($"Task {i + 1} best case estimate: ");
            estimates[i, 0] = int.Parse(Console.ReadLine());
            Console.Write($"Task {i + 1} worst case estimate: ");
            estimates[i, 1] = int.Parse(Console.ReadLine());
            Console.Write($"Task {i + 1} average case estimate: ");
            estimates[i, 2] = int.Parse(Console.ReadLine());
        }

        Console.Write("Enter number of iterations for Monte Carlo simulation: ");
        int iterations = int.Parse(Console.ReadLine());

        int[,] taskEstimates = new int[3, iterations];
        Random random = new Random();
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < iterations; j++)
            {
                int best = estimates[i, 0];
                int worst = estimates[i, 1];
                int average = estimates[i, 2];
                double rand = random.NextDouble();
                if (rand < 0.2) // 20% probability for best case
                {
                    taskEstimates[i, j] = best;
                }
                else if (rand < 0.8) // 60% probability for average case
                {
                    taskEstimates[i, j] = average;
                }
                else // 20% probability for worst case
                {
                    taskEstimates[i, j] = worst;
                }
            }
        }

        int[] totalEstimates = new int[iterations];
        for (int i = 0; i < iterations; i++)
        {
            totalEstimates[i] = taskEstimates[0, i] + taskEstimates[1, i] + taskEstimates[2, i];
        }

        int maxTime = totalEstimates.Max();
        int[] buckets = new int[maxTime + 1];
        for (int i = 0; i < iterations; i++)
        {
            buckets[totalEstimates[i]]++;
        }

        double[] probabilities = new double[maxTime + 1];
        double accumulatedProbability = 0;
        for (int i = 0; i <= maxTime; i++)
        {
            probabilities[i] = (double)buckets[i] / iterations;
            accumulatedProbability += probabilities[i];
            Console.WriteLine($"Probability of finishing in {i} days: {probabilities[i]:0.00%} (accumulated: {accumulatedProbability:0.00%})");
        }

        double averageTime = totalEstimates.Average();
        Console.WriteLine($"Average time to finish the plan: {averageTime:0.00} days");
    }
}
