// Used for web apps that only includes the masthead and footer.
// Will only style elements inside the #malmo-masthead and #malmo-footer
@import 'malmo_<%= audience %>';

@import 'bootstrap_custom';
@import 'jquery-ui.helpers.min';
@import 'autocomplete';
@import 'sitesearch';

@import '<%= audience %>/masthead';
#malmo-masthead {
  font-size: 16px;
}

@import 'footer';
@import 'fonts';

body {
  padding: 0;
  margin: 3.5em 0 0;
}

a,
a:hover {
  text-decoration: none;
}
