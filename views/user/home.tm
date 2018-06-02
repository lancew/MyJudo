% my (%h) = @_;
% my %data = %h<user_data>;
% my %waza = %h<waza>;

<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- HTML Meta Tags -->
    <title>MyJudo.net - Judo Training Tracker</title>
    <meta name="description" content="This is a tool to assist in your tracking of your Judo training.">

    <!-- Google / Search Engine Tags -->
    <meta itemprop="name" content="MyJudo.net - Judo Training Tracker">
    <meta itemprop="description" content="This is a tool to assist in your tracking of your Judo training.">
    <meta itemprop="image" content="https://pbs.twimg.com/profile_banners/73963/1517656187/1500x500">

    <!-- Facebook Meta Tags -->
    <meta property="og:url" content="http://myjudo.net">
    <meta property="og:type" content="website">
    <meta property="og:title" content="MyJudo.net - Judo Training Tracker">
    <meta property="og:description" content="This is a tool to assist in your tracking of your Judo training.">
    <meta property="og:image" content="https://pbs.twimg.com/profile_banners/73963/1517656187/1500x500">

    <!-- Twitter Meta Tags -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="MyJudo.net - Judo Training Tracker">
    <meta name="twitter:description" content="This is a tool to assist in your tracking of your Judo training.">
    <meta name="twitter:image" content="https://pbs.twimg.com/profile_banners/73963/1517656187/1500x500">

    <!-- Meta Tags Generated via http://heymeta.com -->


    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css">

    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
    <link rel="icon" href="/favicon.ico" type="image/x-icon">

    <script defer src="/js/fontawesome-all.min.js"></script>
     <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  </head>
  <body>
      <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
      <a class="navbar-brand" href="/">MyJudo</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarsExampleDefault">
        <ul class="navbar-nav mr-auto">

        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false"><i class="fas fa-cogs" aria-hidden="true"></i> Settings</a>
          <div class="dropdown-menu">
                <a class="dropdown-item" href="/password-change">
                  <i class="fas fa-key" aria-hidden="true"></i>
                  Change Password
                </a>
                <a class="dropdown-item" href="/logout">
                  <i class="fas fa-sign-out-alt" aria-hidden="true"></i>
                  Logout
                </a>
          </div>
         </li>

        </ul>
      </div>
    </nav>


    <div class="container">

      <div class="starter-template">
        <h1>My-Judo</h1>
	<div>
	  <p />




<h1>Home Page for <%= %data<user_name> %></h1>

<h2>Statistics</h2>
<table class="table">
    <tr>
      <td>
       <p><a href="/user/<%= %data<user_name> %>/training-sessions"><i class="fas fa-list" aria-hidden="true"></i> Sessions </a></td>
      <td>
        This month: <%= %data<sessions_this_month> %><br />
        Last month: <%= %data<sessions_last_month> %><br />
        This year: <%= %data<sessions_this_year> %><br />
        Total: <%= %data<sessions> %><br />
      </td>
    </tr>
    <tr>
      <td>Session Types</td>
      <td>
        Kata: <%= %data<session_types><kata> || 0 %><br />
        Nage Komi: <%= %data<session_types><nage-komi> || 0 %><br />
        Ne Waza Randori: <%= %data<session_types><randori-ne-waza> || 0 %><br />
        Tachi Waza Randori: <%= %data<session_types><randori-tachi-waza> || 0 %><br />
        Uchi Komi: <%= %data<session_types><uchi-komi> || 0 %><br />
      </td>
    </tr>
    <tr>
      <td>
       <p>
       <a href="/user/<%= %data<user_name> %>/training-session/add"><i class="fas fa-plus" aria-hidden="true"></i> ADD A SESSION</a>
       </p>
       </td>
       <td></td>
    </tr>
</table>

<h2>Techniques (<%= %waza<kanji> %>)</h2>
<a href="#" onclick="myFunction()"><i class="fas fa-chart-pie"></i> Show/Hide charts</a>

<div id="charts" class="container-fluid" style="display:none;">
  <div class="row">
    <div id="piechart_session_types" style="width: 450px; height: 250px;"></div>
  </div>
  <div class="row">
    <div id="piechart_month" style="width: 450px; height: 250px;"></div>
    <div id="piechart_last_month" style="width: 450px; height: 250px;"></div>
  </div>
  <div class="row">
    <div id="piechart_this_year" style="width: 450px; height: 250px;"></div>
    <div id="piechart_total" style="width: 450px; height: 250px;"></div>
  </div>
</div>


<table class="table table-striped">
  <thead>
    <tr>
      <th></th>
      <th>Total (This Month)</th>
      <th>Total (Last Month)</th>
      <th>Total (This Year)</th>
      <th>Total (All time)</th>
    </tr>
  </thead>
  <tbody>
  % for %data<techniques>.sort(*.value).reverse>>.kv.flat -> $name, $number {
  % next unless $name;
  % my $kanji = %waza<nage-waza><te-waza>{lc $name}<kanji> || %waza<nage-waza><koshi-waza>{lc $name}<kanji> || %waza<nage-waza><ashi-waza>{lc $name}<kanji> || %waza<nage-waza><ma-sutemi-waza>{lc $name}<kanji> || %waza<nage-waza><yoko-sutemi-waza>{lc $name}<kanji> || %waza<katame-waza><osaekomi-waza>{lc $name}<kanji> || %waza<katame-waza><shime-waza>{lc $name}<kanji> || %waza<katame-waza><kansetsu-waza>{lc $name}<kanji>;
    <tr>
      <td>
        <%= $name.tc || '' %> (<%= $kanji || '' %>) <a href="https://www.youtube.com/results?search_query=<%= $kanji %>"><i class="fab fa-youtube"></i></a>
      </td>
      <td>
        <%= %data<techniques_this_month>{lc $name} || '' %>
      </td>
      <td>
        <%= %data<techniques_last_month>{lc $name} || '' %>
      </td>
      <td>
        <%= %data<techniques_this_year>{lc $name} || '' %>
      </td>
      <td>
        <%= $number %>
      </td>
    </tr>
  % }
  </tbody>
</table>

    <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Session Types', 'Total'],
  % for %data<session_types>.sort(*.value).reverse>>.kv.flat -> $name, $number {
  % next unless $name;
  ['<%= $name.tc %>', <%= $number  %>],
  % }
        ]);

        var options = {
          title: 'Training Session Types',
          is3D: true,
          pieSliceText: 'none',
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_session_types'));
        chart.draw(data, options);
      }
    </script>

    <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Techniques', 'Times done'],
  % for %data<techniques>.sort(*.value).reverse>>.kv.flat -> $name, $number {
  % next unless $name;
  % next unless %data<techniques_this_month>{lc $name};
  ['<%= $name.tc %>', <%= %data<techniques_this_month>{lc $name}  %>],
  % }
        ]);

        var options = {
          title: 'Techniques this month',
          is3D: true,
          pieSliceText: 'none',
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_month'));
        chart.draw(data, options);
      }
    </script>

    <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Techniques', 'Times done'],
  % for %data<techniques>.sort(*.value).reverse>>.kv.flat -> $name, $number {
  % next unless $name;
  % next unless %data<techniques_last_month>{lc $name};
  ['<%= $name.tc %>', <%= %data<techniques_last_month>{lc $name}  %>],
  % }
        ]);

        var options = {
          title: 'Techniques last month',
          is3D: true,
          pieSliceText: 'none',
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_last_month'));
        chart.draw(data, options);
      }
    </script>

    <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Techniques', 'Times done'],
  %  for %data<techniques>.sort(*.value).reverse>>.kv.flat -> $name, $number {
  % next unless $name;
  % next unless %data<techniques_this_year>{lc $name};
  ['<%= $name.tc || '' %>', <%= %data<techniques_this_year>{lc $name} || '' %>],
  % }
        ]);

        var options = {
          title: 'Techniques this year',
          is3D: true,
          pieSliceText: 'none',
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_this_year'));
        chart.draw(data, options);
      }
    </script>

    <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Techniques', 'Times done'],
  % for %data<techniques>.sort(*.value).reverse>>.kv.flat -> $name, $number {
  % next unless $name;
  ['<%= $name.tc %>', <%= $number %>],
  % }
        ]);

        var options = {
          title: 'Total Techniques',
          is3D: true,
          pieSliceText: 'none',
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_total'));
        chart.draw(data, options);
      }
    </script>
    <script>
function myFunction() {
    var x = document.getElementById("charts");
    if (x.style.display === "none") {
        x.style.display = "block";
    } else {
        x.style.display = "none";
    }
}
</script>
</p>


        </div>
      </div>

    </div><!-- /.container -->
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>
  </body>
</html>
