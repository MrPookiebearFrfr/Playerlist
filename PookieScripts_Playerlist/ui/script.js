window.addEventListener("message", (event) => {
  const data = event.data;

  if (data.type === "show") {
    document.getElementById("playerList").style.display = "block";
  }

  if (data.type === "hide") {
    document.getElementById("playerList").style.display = "none";
  }

  if (data.type === "updatePlayerList") {
    const body = document.getElementById("playerListBody");
    body.innerHTML = "";

    data.players.forEach(player => {
      const row = document.createElement("tr");

      // Use the discord property from the server
      row.innerHTML = `
        <td>${player.name}</td>
        <td>${player.id}</td>
        <td>${player.discord}</td>
      `;

      body.appendChild(row);
    });

    document.getElementById("playerCount").textContent = `Players: ${data.players.length} / 64`;

    // Update Police/EMS/DOT counts and dots
    if (typeof data.policeCount !== "undefined") {
      document.getElementById("policeCount").textContent = data.policeCount;
      document.getElementById("policeDot").style.backgroundColor = data.policeCount > 0 ? "#3fcf3f" : "#cf3f3f";
    }
    if (typeof data.emsCount !== "undefined") {
      document.getElementById("emsCount").textContent = data.emsCount;
      document.getElementById("emsDot").style.backgroundColor = data.emsCount > 0 ? "#3fcf3f" : "#cf3f3f";
    }
    if (typeof data.dotCount !== "undefined") {
      document.getElementById("dotCount").textContent = data.dotCount;
      document.getElementById("dotDot").style.backgroundColor = data.dotCount > 0 ? "#3fcf3f" : "#cf3f3f";
    }
  }
});

// Set the player list title from config or default
document.addEventListener("DOMContentLoaded", () => {
  const title = window.PLAYERLIST_TITLE || "PLAYER LIST";
  const titleElem = document.getElementById("listTitle");
  if (titleElem) titleElem.textContent = title;
});

// Add F10 toggle functionality
document.addEventListener("keydown", (event) => {
  if (event.key === "F10") {
    const playerList = document.getElementById("playerList");
    if (playerList.style.display === "none" || playerList.style.display === "") {
      playerList.style.display = "block";
    } else {
      playerList.style.display = "none";
    }
  }
});
