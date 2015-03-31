surveyMarkup = '<section id="survey" class="box">
  <h1 class="box-title">Vi behöver din åsikt!</h1>
  <form id="survey-form" action="/" method="get">
    <section class="page-1 box-content">
      <p>För att vi ska kunna göra Komin bättre behöver vi din åsikt. Det enda du behöver göra är att svara på två frågor. Det tar mindre än 15 sekunder.</p>
      <div class="actions">
        <button type="button" class="btn btn-default" id="survey-action-ok">Ja gärna!</button>
        <button type="button" class="btn btn-default" id="survey-action-no">Nej, inte idag</button>
      </div>
    </section>

    <section class="page-2 box-content">
      <p>Välj ett alternativ för varje fråga.</p>

      <div class="form-group">
        <label for="roll" class="control-label">Vad vill du göra på Komin just detta besök?</label>
        <div class="controls">
          <select id="syfte" name="syfte" class="form-control">
            <option></option>
            <option value="nyheter">Läsa om aktuella händelser och nyheter</option>
            <option value="forvaltning">Läsa basinfo om min förvaltning </option>
            <option value="arbetsfalt">Läsa basinfo om mitt arbetsfält </option>
            <option value="bokning">Göra en bokning, t.ex. lokal, bil, cykel</option>
            <option value="lediga_jobb">Hitta lediga jobb</option>
            <option value="kontakt">Hitta kontaktuppgifter eller adresser</option>
            <option value="verktyg">Använda en länk till ett verktyg, t.ex. HRutan, Raindance, verksamhetssystem</option>
            <option value="samarbete">Läsa och delta i samarbeten via forum och blogg</option>
            <option value="annat">Annat</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="syfte" class="control-label">Hur nöjd är du med ditt besök på Komin idag?</label>
        <div class="controls">
          <select id="nojdhet" name="nojdhet" class="form-control">
            <option></option>
            <option value="5">5 – Mycket nöjd</option>
            <option value="4">4</option>
            <option value="3">3 – Varken nöjd eller missnöjd</option>
            <option value="2">2</option>
            <option value="1">1 – Mycket missnöjd</option>
          </select>
        </div>
      </div>

      <div class="actions">
        <button type="button" class="btn btn-primary" id="survey-action-send">Skicka in</button>
      </div>
    </section>

    <section class="page-3 box-content">
      <h1>Tack för dina svar!</h1>
      <p>Dina svar kommer att användas för att göra Komin bättre!</p>
      <div class="actions">
        <button type="button" class="btn btn-default" id="survey-action-done">Stäng</button>
      </div>
    </section>
  </form>
</section>'
