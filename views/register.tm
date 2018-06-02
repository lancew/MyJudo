% my ($h) = @_;
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


         <li class="nav-item">
            <a class="nav-link" href="/register">
              <i class="fas fa-user-plus" aria-hidden="true"></i>
              Register
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link" href="/login">
              <i class="fas fa-sign-in-alt" aria-hidden="true"></i>
              Login
            </a>
          </li>

        </ul>
      </div>
    </nav>


    <div class="container">

      <div class="starter-template">
        <h1>My-Judo</h1>
	<div>
	  <p />


    <h1>Register</h1>
    % if ($h<registered>) {
      <p>You are registered</p>
    % } else {
    <div>
      <form method="post">
				<p>
					<label for="usernamesignup" class="uname" data-icon="u">Your username</label>
					<input id="usernamesignup" name="usernamesignup" required="required" type="text" placeholder="mysuperusername690" />
				</p>
				<p>
					<label for="emailsignup" class="youmail" data-icon="e" > Your email</label>
					<input id="emailsignup" name="emailsignup" required="required" type="email" placeholder="mysupermail@mail.com"/>
				</p>
				<p>
					<label for="passwordsignup" class="youpasswd" data-icon="p">Your password </label>
					<input id="passwordsignup" name="passwordsignup" required="required" type="password" placeholder="eg. X8df!90EO"/>
				</p>
				<p>
					<label for="passwordsignup_confirm" class="youpasswd" data-icon="p">Please confirm your password </label>
					<input id="passwordsignup_confirm" name="passwordsignup_confirm" required="required" type="password" placeholder="eg. X8df!90EO"/>
				</p>
				<p class="signin button">
          <input type="submit" value="Register" class="btn btn-primary">
				</p>
				<p class="change_link">
					Already a member ?
					<a href="/login" class="to_register"> log in </a>
				</p>



      </form>
    </div>
    % }


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
