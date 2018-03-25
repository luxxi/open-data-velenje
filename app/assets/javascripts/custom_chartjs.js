$(function () {
    "use strict";

	// New chart
	new Chart(document.getElementById("pie-chart"), {
		type: 'pie',
		data: {
		  labels: ["Africa", "Asia", "Europe", "Latin America"],
		  datasets: [{
			label: "Population (millions)",
			backgroundColor: ["#36a2eb", "#ff6384","#4bc0c0","#ffcd56","#07b107"],
			data: [2478,5267,3734,2784]
		  }]
		},
		options: {
		  title: {
			display: true,
			text: 'Predicted world population (millions) in 2050'
		  }
		}
	});
});
