import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ["eventsChart"];

  canvasContext() {
    return this.eventsChartTarget.getContext("2d");
  }

  connect() {
    fetch("/events.json")
      .then((response) => response.json())
      .then((data) => {
        console.log("events data: ", data);

        const visitsByDay = this.processData(data);

        new Chart(this.canvasContext(), {
          type: "line",
          data: {
            labels: Object.keys(visitsByDay),
            datasets: [
              {
                label: "Number of Events",
                data: Object.values(visitsByDay),
                backgroundColor: "rgba(54, 162, 235, 0.2)",
                borderColor: "rgba(54, 162, 235, 1)",
                borderWidth: 1,
              },
            ],
          },
          options: {
            scales: {
              y: {
                beginAtZero: true,
              },
            },
          },
        });
      });
  }

  processData(data) {
    const visitsByDay = {};

    // Initialize visits count for each of the last 30 days
    for (let i = 0; i < 30; i++) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      const dateString = date.toISOString().split("T")[0];
      visitsByDay[dateString] = 0;
    }

    // Process visit data
    data.forEach((visit) => {
      const visitDate = new Date(visit.created_at).toISOString().split("T")[0];
      if (visitsByDay[visitDate] !== undefined) {
        visitsByDay[visitDate] += 1;
      }
    });

    // Sort visitsByDay by date
    const sortedVisitsByDay = Object.keys(visitsByDay)
      .sort()
      .reduce((acc, date) => {
        acc[date] = visitsByDay[date];
        return acc;
      }, {});

    return sortedVisitsByDay;
  }
}
