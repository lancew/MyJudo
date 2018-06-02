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
                  <i class="fas fa-sign-out" aria-hidden="true"></i>
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

% my (%h) = @_;
% my $sessions = %h<sessions>;
% my $data = %h<user_data>;

<h2>Sessions: <%= $sessions.elems %></h2>

<table class="table table-striped">
  <tr>
    <th>Date</th>
    <th>Training Type(s)</th>
    <th>Techniques</th>
    <th></th>
  </tr>
% for $sessions.reverse.flat -> $session {
  <tr>
    <td><a href="/user/<%= $data<user_name> %>/training-session/edit/<%= $session<id> %>"><%= $session<date> %></a></td>
    <td><%= $session<types> %></td>
    <td><%= $session<techniques> %></td>
    <td></td>
  </tr>
% }
</table>

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
