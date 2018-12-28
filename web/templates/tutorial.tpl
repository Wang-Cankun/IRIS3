{{extends file="base.tpl"}}

{{block name="extra_style"}}
  form div.fieldWrapper label { min-width: 5%; }
{{/block}}

{{block name="extra_js"}}


<!-- Piwik -->

<!-- End Piwik Code -->
{{/block}}
<script>
$(document).ready(function () {
    $("#showcase").awShowcase({
        content_width: 900,
        content_height: 1000,
        auto: true,
        interval: 3000,
        continuous: false,
        arrows: true,
        buttons: true,
        btn_numbers: true,
        keybord_keys: true,
        mousetrace: false,
        /* Trace x and y coordinates for the mouse */
        pauseonover: true,
        stoponclick: false,
        transition: 'fade',
        /* hslide/vslide/fade */
        transition_delay: 0,
        transition_speed: 500,
        show_caption: 'onload'
		/* onload/onhover/show */
    });
});
</script>

</head>
{{block name="main"}}
<link href="assets/css/help.css" rel="stylesheet" type="text/css">
<script src="assets/js/help.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $("#the-basics-content").click(function() {
        alert("click menu1");
    });
});
</script>
    <main role="main">

      <!-- Main jumbotron for a primary marketing message or call to action -->

      <div class="container">
		<div>
		  <div class="row">
		  <div class="col-md-3">
		  	<div id="menu">
			<ul>
				<li>
					<a href="#1basics" class="highlight">
						<span class="section">The Basics of IRIS3</span>
						<span class="description">Learn the concept and background of IRIS3</span>
					</a>
					<div class="submenu" id="submenu-1basics"></div>
				</li>
				<li>
					<a href="#2submission">
						<span class="section">How to submit a job</span>
						<span class="description">Job submission and advance options</span>
					</a>
					<div class="submenu" id="submenu-2submission"></div>
				</li>
				<li>
					<a href="#3example" class="last">
						<span class="section">Example result illustration</span>
						<span class="description">A guide to interpret the result of IRIS3</span>
					</a>
					<div class="submenu" id="submenu-3example"></div>
					</li>
				<li>
					<a href="#4FAQ">
						<span class="section">FAQ</span>
					</a>
					<div class="submenu" id="submenu-4FAQ"></div>
				</li>
				<li>
					<a href="#5citation">
						<span class="section">Citations</span>
					</a>
					<div class="submenu" id="submenu-5citation"></div>
				</li>
				<li>
					<a href="#6contact" class="highlight">
						<span class="section">Contact</span>
					</a>
					<div class="submenu" id="submenu-6contact"></div>
				</li>				
			</ul>
			
			
		</div>
		</div>
<div class="col-md-9">
		<div class="clear"></div>
		<div id="content">
		
        <hr>
</div>
</div>
      </div> <!--<img src="http://circos.ca/guide/tables/img/guide-table.png"> /container -->
<div class="push"></div>
    </main>



{{/block}}


