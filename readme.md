#Critique-It!

###Overview
Critique-It! is a microblog that allows users to post photographs and have them critiqued by other photographers. It was designed to provide photographer/artists who have left art school an online class critique experience. Currently it only has the capability to CRUD photographs in your own account. This was completed during a five-day sprint. I plan to finish adding feautures until I get the finished product I envisioned.
</br>
</br>

<img src="http://i60.tinypic.com/19s21v.png" />
<img src="http://i61.tinypic.com/23rsvfo.png" />
<img src="http://i62.tinypic.com/wat7yo.png" />

###Technology 
<ul>
	<li> Ruby 2.1.2
	<li> Redis 3.1.0
	<li> Sinatra
	<li> HTTParty
	<li> Awesome_Print 1.2.0
	<li> JSON
	<li> Authentication through GooglePlus
</ul>
###Instructions
To use the GooglePlus authorization, you will need to register as a developer and obtain Google authrization keys.

####Visit the site
<a href="http://powerful-reef-4488.herokuapp.com/">Critique-It!</a>

####User Stories
<ol>
	<li>NEW & POST: A user can create a new micro_post via a form... (/micro_posts/new -> POST /micro_posts)</li>
	<li>SHOW: A user can show (ie, see) a given micro_post... (/micro_posts/micro-post-id)</li>
	<li>INDEX: A user can see all of the micro_posts as a feed, up to a maximum of ten... (/micro_posts)</li>
	<li>EDIT & DELETE: A user can delete a micro_post... (/micro_posts/micro-post-id/edit -> DELETE /micro_posts/micro-post-id)</li>
	<li>UPDATE: A user can update a micro_post... (/micro_posts/micro-post-id/edit -> PUT /micro_posts/micro-post-id)</li>

<br>
#####Created by 
freejacque
