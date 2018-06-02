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
% my %data = %h<user_data>;
% my %waza = %h<waza>;
% my %session = %h<session> || {};

    <h1>Add a session for <%= %data<user_name> %></h1>
    <div>
      <form method="post">
        <div class="form-group">
            <label for="session-date">Session Date:</label>
            <input
                   type = "date"
                   class="form-control"
                   name = "session-date"
                   id="session-date"
                   value ="<%= Date.new( %session<date> || DateTime.now) %>"
                   >
        </div>

        <div class="form-group">
            <label for="session-dojo">Dojo:</label>
            <input
              class="form-control"
              type="text"
              name="session-dojo"
              id="session-dojo"
              value="<%= %session<dojo> || %data<dojo> || '' %>"
              >
        </div>


        <h2>Training type(s)</h2>
        <div class="form-check">
          <label class="form-check-label">
            <input class="form-check-box" type="checkbox" name="randori-tachi-waza" id="randori-tachi-waza" <%= ( %session.defined && %session<types>.defined ?? %session<types>.Str !! '' ).contains('randori-tachi-waza') ?? 'checked' !! '' %> >
            Tachi-Waza Randori
          </label>
          <label class="form-check-label">
            <input class="form-check-box"
                   type="checkbox"
                   name="randori-ne-waza"
                   id="randori-ne-waza"
                   <%= (%session.defined && %session<types>.defined ?? %session<types>.Str !! '').contains('randori-ne-waza') ?? 'checked' !! '' %>>
            Ne-Waza Randori
          </label>
          <label class="form-check-label">
            <input class="form-check-box"
                   type="checkbox"
                   name="uchi-komi"
                   id="uchi-komi"
                   <%= (%session.defined && %session<types>.defined ?? %session<types>.Str !! '').contains('uchi-komi') ?? 'checked' !! '' %>>
            Uchi-Komi
          </label>
          <label class="form-check-label">
            <input class="form-check-box"
                   type="checkbox"
                   name="nage-komi"
                   id="nage-komi"
                   <%= (%session.defined && %session<types>.defined ?? %session<types>.Str !! ''  ).contains('nage-komi') ?? 'checked' !! '' %>>
            Nage-Komi
          </label>
          <label class="form-check-label">
            <input class="form-check-box"
                   type="checkbox"
                   name="kata"
                   id="kata" <%= (%session.defined && %session<types>.defined ?? %session<types>.Str !! '').contains('kata') ?? 'checked' !! '' %>>
            Kata
          </label>
        </div>

        <h2>Nage-Waza (<%= %waza<nage-waza><kanji> %>)</h2>
          <table class="table">
          <tr>
        % my @groups = 'te-waza', 'koshi-waza', 'ashi-waza', 'ma-sutemi-waza', 'yoko-sutemi-waza';
        % for @groups -> $group {
          <td>
          <h3><%= $group.tc %></h3>
            <ul class="list-group">
              % for @(%waza<nage-waza>{$group}.values) -> %t {
                  <li class="list-group-item">
                  <div class="form-check">
                    <label class="form-check-label">
                      <input class="form-check-input"
                             type="checkbox"
                             name="<%= %t<name> || '' %>"
                             id="<%= %t<name> || '' %>"
                             <%= ( %session.defined && %session<techniques>.defined ?? ~%session<techniques> !! '').contains(%t<name>.lc || '') ?? 'checked' !! '' %>>
                      <%= %t<name> %> (<%= %t<kanji> %>)
                    </label>
                  </div>
              % }
            </ul>
          </td>
        % }


          <table class="table">
          <tr>
           <td>
            <h2>Katame-Waza (<%= %waza<katame-waza><kanji> %>)</h2>
           </td>
          </tr>
          <tr>
        % @groups = 'osaekomi-waza', 'shime-waza', 'kansetsu-waza';
        % for @groups -> $group {
          <td>
          <h3><%= $group.tc %></h3>
            <ul class="list-group">
              % for @(%waza<katame-waza>{$group}.values) -> %t {
                  <li class="list-group-item">
                  <div class="form-check">
                    <label class="form-check-label">
                      <input class="form-check-input"
                             type="checkbox"
                             name="<%= %t<name> || '' %>"
                             id="<%= %t<name> || '' %>"
                             <%= ( %session.defined && %session<techniques>.defined ?? %session<techniques> !! '').contains(%t<name>.lc || '') ?? 'checked' !! '' %>>
                      <%= %t<name> %> (<%= %t<kanji> %>)
                    </label>
                  </div>
              % }
            </ul>
          </td>
        % }


          </tr>
          </table>
        <input type="submit" value="Add" class="btn btn-primary">
      </form>
    </div>



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

