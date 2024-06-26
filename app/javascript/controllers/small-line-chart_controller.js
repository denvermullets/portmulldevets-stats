import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ["smallLineChart"];
  chart = null;

  connect() {
    this.renderChart();
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy();
    }
  }

  renderChart() {
    const eventsData = this.smallLineChartTarget.dataset.smallLineChartEvents;

    if (!eventsData) {
      console.error("No events data found.");
      return;
    }

    let visitsByDay;

    if (!eventsData || Object.keys(JSON.parse(eventsData)).length === 0) {
      // no events data found render a straight line
      visitsByDay = { "Day 1": 0, "Day 2": 0 };
    } else {
      visitsByDay = JSON.parse(eventsData);
    }

    new Chart(this.canvasContext(), {
      type: "line",
      data: {
        labels: Object.keys(visitsByDay),
        datasets: [
          {
            label: "Number of Unique Users",
            data: Object.values(visitsByDay),
            backgroundColor: "#d5e1f7",
            borderColor: "#084CCF",
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
            border: {
              display: false,
            },
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
            border: {
              display: false,
            },
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
    return this.smallLineChartTarget.getContext("2d");
  }
}
