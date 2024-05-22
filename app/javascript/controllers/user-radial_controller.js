import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ["userRadialChart"];

  connect() {
    const eventsData = this.userRadialChartTarget.dataset.userRadialEvents;

    if (!eventsData) {
      console.error("No events data found.");
      return;
    }

    const parsedData = JSON.parse(eventsData);
    const visitsByDay = this.processData(parsedData);

    new Chart(this.canvasContext(), {
      type: "line",
      data: {
        labels: Object.keys(visitsByDay),
        datasets: [
          {
            label: "Number of Unique Users",
            data: Object.values(visitsByDay),
            backgroundColor: "rgba(54, 162, 235, 0.2)",
            borderColor: "rgba(54, 162, 235, 1)",
            borderWidth: 1,
            tension: 0.4, // Smooth lines
            pointRadius: 0, // Hide point dots
            pointHoverRadius: 5, // Show point dots on hover
            fill: true, // Fill area under the line
          },
        ],
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
            grid: {
              display: false, // Hide background lines
              drawBorder: false, // Hide the border on the left
            },
            ticks: {
              precision: 0, // Only show whole numbers
              display: false, // Hide y-axis labels
            },
          },
          x: {
            grid: {
              display: false, // Hide background lines on x-axis
              drawBorder: false, // Hide the border on the bottom
            },
            ticks: {
              display: false, // Hide x-axis labels
            },
          },
        },
        plugins: {
          legend: {
            display: false, // Hide legend
          },
          tooltip: {
            enabled: false, // Disable tooltips
          },
        },
        elements: {
          line: {
            borderWidth: 2, // Adjust the line width if necessary
          },
          point: {
            radius: 0, // Do not show points on the line
            hoverRadius: 0, // Point radius on hover
          },
        },
      },
    });
  }

  canvasContext() {
    return this.userRadialChartTarget.getContext("2d");
  }

  processData(data) {
    const visitsByDay = {};

    // Initialize visits count for each of the last 30 days
    for (let i = 0; i < 30; i++) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      const dateString = date.toISOString().split("T")[0];
      visitsByDay[dateString] = new Set();
    }

    // Process visit data
    data.forEach((visit) => {
      const visitDate = new Date(visit.created_at).toISOString().split("T")[0];
      if (visitsByDay[visitDate] !== undefined) {
        visitsByDay[visitDate].add(visit.user_id);
      }
    });

    // Convert sets to counts
    const visitsByDayCount = {};
    Object.keys(visitsByDay).forEach((date) => {
      visitsByDayCount[date] = visitsByDay[date].size;
    });

    // Sort visitsByDay by date
    const sortedVisitsByDayCount = Object.keys(visitsByDayCount)
      .sort()
      .reduce((acc, date) => {
        acc[date] = visitsByDayCount[date];
        return acc;
      }, {});

    return sortedVisitsByDayCount;
  }
}
