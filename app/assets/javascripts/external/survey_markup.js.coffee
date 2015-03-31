msettings.surveyMarkup = '<section id="survey" class="box">
  <h1 class="box-title">Vi behöver din åsikt!</h1>
  <form id="survey-form" action="/" method="get">
    <section class="page-1 box-content">
      <p>För att vi ska kunna göra malmo.se bättre behöver vi din åsikt. Det enda du behöver göra är att svara på två frågor. Det tar mindre än 15 sekunder.</p>
      <div class="actions">
        <button type="button" class="btn btn-default" id="survey-action-ok">Ja gärna!</button>
        <button type="button" class="btn btn-default" id="survey-action-no">Nej, inte idag</button>
      </div>
    </section>

    <section class="page-2 box-content">
      <p>Välj ett alternativ för varje fråga.</p>

      <div class="form-group">
        <label for="roll" class="control-label">I vilken roll besöker du malmo.se idag? </label>
        <div class="controls">
          <select id="roll" name="roll" class="form-control">
            <option></option>
            <option value="enkat-bo-malmo">Bor i Malmö</option>
            <option value="enkat-bo-skane">Bor i annan skånsk kommun</option>
            <option value="enkat-flytta">Funderar på att flytta till Malmö</option>
            <option value="enkat-arbetar-malmo">Arbetar i Malmö</option>
            <option value="enkat-anstalld">Anställd av Malmö stad</option>
            <option value="enkat-offentlig">Arbetar i offentlig förvaltning</option>
            <option value="enkat-journalist">Journalist</option>
            <option value="enkat-turist">Turist/besökare</option>
            <option value="enkat-studerar">Studerar</option>
            <option value="enkat-företagare">Företagare/näringsidkare</option>
            <option value="enkat-jobbsokande">Jobbsökande</option>
            <option value="enkat-annan-roll">Annat</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="syfte" class="control-label">Vad vill du göra på malmo.se just detta besök?</label>
        <div class="controls">
          <select id="syfte" name="syfte" class="form-control">
            <option></option>
            <option value="enkat-tjanst">Använda en tjänst, t.ex. hämta blankett, boka loppis, låna bok</option>
            <option value="enkat-kontakt">Hitta kontaktuppgifter</option>
            <option value="enkat-jobb">Hitta lediga jobb</option>
            <option value="enkat-verksamhet">Läsa information om viss verksamhet</option>
            <option value="enkat-nyheter">Läsa om nyheter och aktuella händelser</option>
            <option value="enkat-annat-syfte">Annat</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="nojdhet" class="control-label">Hur nöjd är du med ditt besök på malmo.se idag?</label>
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
      <p>Dina svar kommer att användas för att göra malmo.se bättre!</p>
      <div class="actions">
        <button type="button" class="btn btn-default" id="survey-action-done">Stäng</button>
      </div>
    </section>
  </form>
</section>'
