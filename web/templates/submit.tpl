{{extends file="base.tpl"}} {{block name="extra_style"}} form div.fieldWrapper label { min-width: 5%; } {{/block}} {{block name="extra_js"}} {{/block}} {{block name="main"}}
	<script src="vendor/bootstrap/js/bootstrap-select.min.js"></script>
<script>
function addPreviewTable(response, metadata = true, type) {

    // Define table
    var $table = $('<table>', {
        'class': 'table-striped w-100'
    }).append($('<thead>').append($('<tr>', {
        'class': ' very-small text-center border-grey border-left-0 border-right-0'
    }))).append($('<tbody>'));
    // Add headers
    //label = metadata ? 'Gene' : 'Cell Label'
	
    upload_type = response['type'][0];
    console.log(upload_type);
    if (type == 'exp' && upload_type == 'text') {
        label = 'Gene'
        $table.find('tr').append($('<th>', {
            'class': 'px-2 py-1 text-center'
        }).html(label));
        $.each(response['columns'][0], function(i, col) {
            $table.find('tr').append($('<th>', {
                'class': 'px-2 py-1 text-center'
            }).html(col));
        })
    } else if (type == 'label') {
        label = 'Cell label'
        $table.find('tr').append($('<th>', {
            'class': 'px-2 py-1 text-center'
        }).html(label));
        $.each(response['columns'][0], function(i, col) {
            $table.find('tr').append($('<th>', {
                'class': 'px-2 py-1 text-center'
            }).html(col));
        })
    } else if (type == 'module') {
        label = 'Module';
    }

    // Get row number
    n = metadata ? 6 : response['index'].length;

    switch (upload_type) {
        case 'text':
            try { // Add rows
                for (i = 0; i < n; i++) {
                    var $tr = $('<tr>').append($('<td>', {
                        'class': 'bold text-center px-2 py-1'
                    }).html(response['index'][i]));
                    $.each(response['data'][i], function(i, val) {
                        $tr.append($('<td>', {
                            'class': 'light text-center tiny'
                        }).html(val));
                    })
                    $table.find('tbody').append($tr);
                } // Add
                $('#loader_' + type).addClass('d-none');
                $('#preview_' + type).append($table);
                document.getElementById("is_load_" + type).value = 1;
            } catch (err) {
                $('#preview_' + type).append($('<label>', {
                    'class': 'px-2 py-1'
                }).html('<span class="highlight">ERROR: ' + err.message + ', please check your upload data format.</span></label>'));
            }

            if (response['columns'][0].length != response['data'][0].length && type == 'exp') {
                $('#preview_' + type).append($('<label>', {
                    'class': 'px-2 py-1'
                }).html('<span class="bold highlight">WARNING: The number of cells in your first row(' + response['columns'][0].length + ') does not match the number in the other rows(' + response['data'][0].length + ').</span></label>'));
            }
            percent_gene_num = response['gene_num'][0] > 1000 ? 1000 : response['gene_num'][0];
            percent = (1 - response['count_zero'][0] / (response['columns'][0].length * percent_gene_num)).toFixed(6);

            if (percent > 0.85 && type == 'exp') {
                $('#preview_' + type).append($('<label>', {
                    'class': 'px-2 py-1'
                }).html('<span class="bold highlight">WARNING: There are too many zeros or or unrecognized characters in your dataset (' + percent * 100 + '%), errors are likely to occur when you submit job to IRIS3.</span></label>'));
            }
            if (response['columns'][0].length < 40 && type == 'exp') {
                $('#preview_' + type).append($('<label>', {
                    'class': 'px-2 py-1'
                }).html('<span class="bold highlight">WARNING: Your dataset has (' + response['columns'][0].length + ') cells, errors may occur when you submit to IRIS3. It is recommended to have at least around 100 cells in your scRNA-seq experiment. </span></label>'))
                document.getElementById("k_arg").value = 5;
            }
            var check_cell_name_start_with_number = function(array) {
                for (var i = 0; i < array.length; i += 1) {
                    // Use the index i here
                    console.log();
                    if ('0123456789'.indexOf(array[i].charAt(0)) !== -1) {
                        return true;
                    }
                }
            }
            if (check_cell_name_start_with_number(response['columns'][0]) && type == 'exp') {
                $('#preview_' + type).append($('<label>', {
                    'class': 'px-2 py-1'
                }).html('<span class="bold highlight">NOTE: Some of the cell names in your dataset start with numeric value, IRIS3 will try to rename them in data pre-processing.  </span></label><br/>'));
            }
            break;
        case 'hdf':
            $('#preview_' + type).append($('<label>', {
                'class': 'px-2 py-1'
            }).html('<span class="bold highlight">NOTE: Word on HDF.... ' + response['type'][0] + '</span></label>'));
            break;

    }
    $('#preview_' + type).append($('<label>', {
        'class': 'px-2 py-1'
    }).html('<span class="bold highlight">NOTE: Your upload file type: ' + upload_type + '</span></label><br/>'))



}


var addTable = function(dataset, type) {
    // method from biojupies/upload/table
    $('#expression').val(JSON.stringify(dataset));
    // Toggle Interfaces
    //$('button[form="upload-expression-form"]').prop('disabled', false);
    //$('button[form="upload-expression-form"]').toggleClass('black white bg-white bg-blue');
	if(dataset['type'][0] == 'text') {
		$('#dropzone_' + type).hide();
		$('#formats').hide();
		$('#drop_exp').hide();
		$('#drop_label').hide();
	}
    addPreviewTable(dataset, true, type);
	if(dataset['type'][0] == 'text') {
	    $('#intro_' + type).append($('<label>', {
        'class': 'px-2 py-1'
		}).html('Your uploaded gene expression file contains <span class="highlight">' + dataset['columns'][0].length + ' cells</span> and <span class="highlight">' + dataset['gene_num'][0] + ' genes</span>. Check that the preview is correct, select the species then click submit button or upload additional files in the advanced options.</label>'))
	} else if (dataset['type'][0] == 'hdf') {
		$('#intro_' + type).append($('<label>', {
        'class': 'px-2 py-1'
		}).html('You uploaded <span class="highlight">HDF format </span>gene expression file, select the species then click submit button or upload additional files in the advanced options.</label>'))
	}
	
}
var exp_file_status = 0;
$(document).ready(function() {
    $('.selectpicker').selectpicker();
    $('#tooltip1').tooltip();
    $('[data-toggle="tooltip"]').tooltip({
        placement: 'top'
    });
    $('.dropdown-toggle').dropdown();

    dz_exp = $("#dropzone_exp").dropzone({
        dictDefaultMessage: "Drag or click upload your gene expression matrix, supported format: <br>1. Gene expression matrix (txt, tsv, csv). <br>2. HDF5 feature barcode batrix (hdf5).<br>3. Gene-barcode matrices (3 files in your 10X output directory). <br> Compressed file accepted.",
        acceptedFiles: ".txt,.csv,.tsv,.xls,.xlsx,.gz,.h5,.hdf5",
        url: "upload.php",
        maxFiles: 3,
        maxFilesize: 1000,
        maxfilesexceeded: function(file) {
            this.removeFile(this.files[0]);
            this.addFile(file);
        },
        timeout: 1800000,
        sending: function(file, xhr, formData) {
            formData.append('filetype', 'dropzone_exp');
        },
        success: function(file, response) {
            if ($('select[name=species_arg]').val()) {
                $('#submit_btn').attr("disabled", false);
            }
            exp_file_status = 1;
            response = JSON.parse(response);
            console.log(this.getAcceptedFiles().length);
			if (this.getAcceptedFiles().length <= 1){
            addTable(response, 'exp');
			}
        }
    });

    $("div#dropzone_label").dropzone({
        dictDefaultMessage: "Drag or click to upload your cell label file. <br> Accepted files: .txt,.csv,.tsv",
        acceptedFiles: ".txt,.csv,.tsv,.xls,.xlsx",
        url: "upload.php",
        maxFiles: 1,
        maxFilesize: 50,
        timeout: 1800000,
        maxfilesexceeded: function(file) {
            this.removeAllFiles();
            this.addFile(file);
        },
        sending: function(file, xhr, formData) {
            formData.append('filetype', 'dropzone_label');
        },
        success: function(file, response) {
            $('#enable_labelfile').attr("disabled", false);
            response = JSON.parse(response);
            console.log(response);
            addTable(response, 'label');

        }
    });

    $("div#dropzone_gene_module").dropzone({
        dictDefaultMessage: "Drag or click to upload your gene module file. <br> Accepted files: .txt,.csv,.tsv",
        acceptedFiles: ".txt,.csv,.tsv,.xls,.xlsx",
        url: "upload.php",
        maxFiles: 1,
        maxFilesize: 50,
        timeout: 300000,
        maxfilesexceeded: function(file) {
            this.removeAllFiles();
            this.addFile(file);
        },
        sending: function(file, xhr, formData) {
            formData.append('filetype', 'dropzone_gene_module');
        },
        success: function(file, response) {
            $('#enable_gene_module').attr("disabled", false);
            response = JSON.parse(response);
            console.log(response);
            addTable(response, 'gene_module');
        }
    });

    $('.dz-message').css({
        'font-size': '18px'
    });
    // Load Example expression file
    $('#load_exp').click(function(evt) {
        exp_file_status = 1;
        $('#enable_labelfile').attr("disabled", false);
        $('#submit_btn').attr("disabled", false);
        $('#loader_exp').html($('<div>', {
            'class': 'text-center medium regular py-5 border-grey rounded',
            'style': "background-image: url(assets/img/expression_table_remove.jpg); background-size: 100% 100%;height:150px; background-size: 100% 100%;margin:10px 0 0 0;border:1px solid #c9c9c9;border-radius:.25rem!important"
        }).html($('<div>', {
            'class': 'dz-default dz-message',
            'style': 'margin:2em 0;font-weight:600;color:#00AA90'
        }).html('<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>Example gene expression file loaded')));
        $('#dropzone_exp').hide();
        $('#loader_label').html($('<div>', {
            'class': 'text-center medium regular py-5 border-grey rounded',
            'style': "background-image: url(assets/img/expression_label.jpg); background-size: 100% 100%;height:150px; background-size: 100% 100%;margin:10px 0 0 0;border:1px solid #c9c9c9;border-radius:.25rem!important"
        }).html($('<div>', {
            'class': 'dz-default dz-message',
            'style': 'margin:2em 0;font-weight:600;color:#00AA90'
        }).html('<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>Example cell label file loaded')));
        $('#dropzone_label').hide();
        $("#species_arg option[value='Human']").prop('selected', true);
        $('.selectpicker').selectpicker('refresh')
        // load example data
        $.ajax({
            url: "upload.php",
            type: 'POST',
            data: {
                'filename': 'expression'
            },
            dataType: 'json',
            success: function(response) {},
            error: function(e) {
                console.log(e.message);
            }
        })
    });
    // load example cell label
    $('#load_label').click(function(evt) {
        exp_file_status = 1;
        $('#submit_btn').attr("disabled", false);
        $('#enable_labelfile').attr("disabled", false);
        $('#loader_exp').html($('<div>', {
            'class': 'text-center medium regular py-5 border-grey rounded',
            'style': "background-image: url(assets/img/expression_table.jpg); background-size: 100% 100%;height:150px; background-size: 100% 100%;margin:10px 0 0 0;border:1px solid #c9c9c9;border-radius:.25rem!important"
        }).html($('<div>', {
            'class': 'dz-default dz-message',
            'style': 'margin:2em 0;font-weight:600;color:#00AA90'
        }).html('<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>Example gene expression file loaded')));
        $('#dropzone_exp').hide();
        $('#loader_label').html($('<div>', {
            'class': 'text-center medium regular py-5 border-grey rounded',
            'style': "background-image: url(assets/img/expression_label.jpg); background-size: 100% 100%;height:150px; background-size: 100% 100%;margin:10px 0 0 0;border:1px solid #c9c9c9;border-radius:.25rem!important"
        }).html($('<div>', {
            'class': 'dz-default dz-message',
            'style': 'margin:2em 0;font-weight:600;color:#00AA90'
        }).html('<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>Example cell label file loaded')));
        $('#dropzone_label').hide();
        $("#species_arg option[value='Human']").prop('selected', true);
        $('.selectpicker').selectpicker('refresh')
        // AJAX upload example
        $.ajax({
            url: "upload.php",
            type: 'POST',
            data: {
                'filename': 'label'
            },
            dataType: 'json',
            success: function(response) {},
            error: function(e) {
                console.log(e.message);
            }
        })
    });

    // load example gene module
    /*$('#load_gene_module').click(function(evt) {
	$('#submit_btn').attr("disabled", false);
	$('#enable_labelfile').attr("disabled", false);
	$('#loader_exp').html($('<div>', {'class': 'text-center medium regular py-5 border-grey rounded', 'style':"background-image: url(assets/img/expression_table.jpg); background-size: 100% 100%;height:150px; background-size: 100% 100%;margin:10px 0 0 0;border:1px solid #c9c9c9;border-radius:.25rem!important"}).html($('<div>', {'class': 'dz-default dz-message','style':'margin:2em 0;font-weight:600;font-size:2em;color:#00AA90'}).html('<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>Example gene expression file loaded')));
	$('#dropzone_exp').hide();
	$('#loader_label').html($('<div>', {'class': 'text-center medium regular py-5 border-grey rounded', 'style':"background-image: url(assets/img/expression_label.jpg); background-size: 100% 100%;height:150px; background-size: 100% 100%;margin:10px 0 0 0;border:1px solid #c9c9c9;border-radius:.25rem!important"}).html($('<div>', {'class': 'dz-default dz-message','style':'margin:2em 0;font-weight:600;font-size:1.5em;color:#00AA90'}).html('<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>Example cell label file loaded')));
	$('#dropzone_label').hide();

	$.ajax({
		url: "upload.php",
		type: 'POST',
		data: {'filename': 'gene_module'},
		dataType: 'json',
		success: function(response) {
		},
        error: function(e){
            console.log(e.message);
        }
	})
	});*/
    $("select#species_arg").on("change", function(value) {
        var This = $(this);
        var selectedD = $(this).val();
        console.log(selectedD)
        if (selectedD && exp_file_status) {
            $('#submit_btn').attr("disabled", false);
        } else {
            $('#submit_btn').attr("disabled", true);
        }
    });

});
</script>
<main role="main" class="container" style="min-height: calc(100vh - 182px);">
	<hr>
	<!--<div class="starter-template">-->
	<form method="POST" action="{{$URL}}" encType="multipart/form-data" id="needs-validation">
		<h2 class="text-center">Job Submission</h2>
		<div class="form-group row">
			<div class="form-check col-sm-12 ">
				<label class="form-check-label" for="expfile">Upload gene expression file: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A gene expression file with genes as rows and cells as columns. Users can provide normalized or non-normalized input file for the submission. Accept both txt, csv and tsv format. "> </span>
				</label>
			</div>
			<div class="form-check col-sm-2  ">
				<div class="dropdown"  id="drop_exp">
					<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:1px solid #c9c9c9;border-radius:.25rem!important">Example <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
						<li><a id="load_exp" class="dropdown-item" href="#">Load example file</a>
						</li>
						<li><a class="dropdown-item" href="storage/iris3_example_expression_matrix.csv" >Download example gene expression matrix</a>
						</li>
						<li><a class="dropdown-item" href="storage/iris3_example_hdf5.h5" >Download example HDF5 feature barcode matrix</a>
						</li>
						<li><a class="dropdown-item" href="storage/iris3_example_10x_matrices.zip" >Download example gene-barcode matrices (3 files in 10X output)</a>
						</li>
					</ul>
				</div>
			</div>
			<!--<div class="form-check col-sm-1  ">
				<div class="dropdown">
					<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:1px solid #c9c9c9;border-radius:.25rem!important">Example (10x) <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
						<li><a id="load_exp" class="dropdown-item" href="#">Load example file</a>
						</li>
						<li><a class="dropdown-item" href="storage/iris3_example_expression_matrix.csv" >Download example gene expression file</a>
						</li>
					</ul>
				</div>
			</div>-->
			<div class="col-sm-12">
				<div id="dropzone_exp" class="dropzone border-grey rounded dz-clickable" style="background-image: url(assets/img/expression_table_remove.jpg); background-size: 100% 100%;margin:10px 0 0 0;border:2px dashed #c9c9c9;border-radius:.25rem!important"></div>
			<div id="loader_exp"></div>
			<!--<div id="hint_upload" style="font-weight: 200;">Note: We accept gene symbols as row identifiers, automated identifier conversion currently in development.</div>-->
			<div id="preview_exp"></div>
			<div id="intro_exp" class="mt-2"></div>
			</div>

		</div>
		<div class="form-group row">
		<div class="form-check col-sm-6 ">
		<label class="form-check-label" for="species_select">Species:
		 <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Specify the species belongs to your gene expression matrix."> </span> 
				</label>
		<select class="selectpicker" id="species_arg" name="species_arg[]" multiple data-max-options="2">
  <option value="Human">Human</option>
  <option value="Mouse">Mouse</option>
  <option value="Zebrafish">Zebrafish</option>
  <option value="Fruit_fly">Fruit fly</option>
  <option value="Yeast">Yeast</option>
  <option value="Worm">Worm</option>
</select>
</div>
		<br/>
		
			
		</div>
		
		<hr>
		<div class="bs-example2">
			<div class="panel-group" id="accordion2">
				<div class="panel panel-default">
					<div class="panel-collapse-heading">
						<h4 class="panel-title">
                     <a data-toggle="collapse" data-parent="#accordion2" href="#collapseThree2">Advanced options</a>
                  </h4>
					</div>
					<div id="collapseThree2" class="panel-collapse collapse">
						<div class="panel-body">
						<h4 class="font-italic text-left">Pre-processing</h4>
						<div class="form-group row">
						<div class="form-check col-sm-12 ">
							<input class="form-check-input" type="checkbox" name="is_gene_filter" id="is_gene_filter" value="1" checked>
							<label class="form-check-label" for="is_gene_filter">Enable gene filtering (default: Yes) 
							 <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="The optional filtering step removes genes that are expressed in less than 5% of total cells."> </span> 
							</label>
						</div>
						<div class="form-check col-sm-12 ">
							<input class="form-check-input" type="checkbox" name="is_cell_filter" id="is_cell_filter" value="1" checked>
							<label class="form-check-label" for="is_cell_filter">Enable cell filtering (default: Yes) 
							 <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="The optional filtering step removes cells that are expressed in less than 1% of total genes."> </span>
							<!-- </label> -->
						</div>
					</div>
							<h4 class="font-italic text-left">Biclustering parameters</h4>
							<div class="form-group">
								<div class="row">
									<div class="col-md-2">
										<label for="ex1">Consistancy level: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Parameter in QUBIC that affect the consistancy level of a bicluster. Lower value allows more genes included during the growth of bicluster and 1 means no growth. Default is 1. "> </span> 
										</label>
									</div>
									<div class="col-md-2">
										<select class="selectpicker" name="c_arg" data-width="auto">
											<option>0.6</option>
											<option>0.7</option>
											<option>0.8</option>
											<option>0.9</option>
											<option data-subtext="Default" selected="selected">1.0</option>
										</select>
									</div>
								</div>
								<br>
								<div class="row">
									<div class="col-md-2">
										<label for="ex3">Max biclusters: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Max number of biclusters to output. Note: the output number will affect the prediction of bicluster, not merely a cutoff, and the output biclusters may be less than this number. Default is 100."> </span>
										</label>
									</div>
									<div class="col-md-2">
										<select class="selectpicker" name="o_arg" data-width="auto">
											<option>20</option>
											<option>50</option>
											<option data-subtext="Default" selected="selected">100</option>
											<option>200</option>
										</select>
									</div>
								</div>
								<br>
								<div class="row">
									<div class="col-md-2">
										<label for="ex2">Overlap rate: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Controls the level of overlaps between to-be-identified biclusters. 0 means no overlap and 1 means complete overlap. Default is 0.5."> </span>
										</label>
									</div>
									<div class="col-md-2">
										<select class="selectpicker" name="f_arg" data-width="auto">
											<option>0.1</option>
											<option>0.2</option>
											<option>0.3</option>
											<option>0.4</option>
											<option data-subtext="Default" selected="selected">0.5</option>
											<option>0.6</option>
											<option>0.7</option>
											<option>0.8</option>
											<option>0.9</option>
											<option>1.0</option>
										</select>
									</div>
								</div>
							</div>
							<h4 class="font-italic text-left">SC3 option 
							<span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="By default, cell types are predicted in SC3 by gene distance calculation, PCA dimension reduction, tSNE-k-means clustering, and consensus clustering. You may also manually specify the nubmer of cell types in SC3."> </span> 
							</h4>
							<div class="row">
									<div class="col-md-1">
										<label for="ex4">k: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Number of clusters"> </span>
										</label>
										
									</div>
									<div class="col-md-2">
										<input type="radio" value="estimate" id="enable_sc3_k" name="enable_sc3_k" class="custom-control-input" checked required>
									<label class="custom-control-label" for="enable_sc3_estimate">Estimated by SC3
									</label>
									</div>
									<div class="col-md-5">
									<label class="custom-control-label" for="enable_sc3_estimate"><input type="radio" value="specify" id="enable_sc3_k" name="enable_sc3_k" class="custom-control-input" > Specify:<input name="param_k" type="text" id="param_k" size="5" value="" title="Please enter numeric value > 0" style="position:relative;left:10px; width : 50%;" pattern="^[1-9][0-9]*$" oninvalid="setCustomValidity('Please enter numeric value > 0')"
    onchange="try{setCustomValidity('')}catch(e){}"/></label>
									
									</div>
								</div>
							<h4 class="font-italic text-left">Upload cell label: (Optional) <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A table contains cell infomation. The file should includes a cell names in the first column match with the expression file, and the second column indicating the cell clusters. Cell clusters are used in two ways: (i) assess the cell-type prediction results from SC3, and (ii) assign Cell-type-specific regulons. If no cell label file uploaded, the pipeline will automatically use the predicted clusters from SC3 for the following regulon predictions. Accept both txt and csv format."> </span></h4>
							
							<div id="upload_label">
									<div class="form-group row">
										<div class="col-sm-4">
											<div class="dropdown"  id="drop_label">
												<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:1px solid #c9c9c9;border-radius:.25rem!important">Example <span class="caret"></span>
												</button>
												<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
													<li><a id="load_label" class="dropdown-item" href="#dropzone_label">Load example file</a>
													</li>
													<li><a class="dropdown-item" href="/iris3/storage/iris3_example_expression_label.csv" download>Download example cell label file</a>
													</li>
												</ul>
											</div>
											<div id="dropzone_label" class="dropzone border-grey rounded dz-clickable" style="background-image: url(assets/img/expression_label.jpg); background-size: 100% 100%;margin:0;border:1px solid #c9c9c9;border-radius:.25rem!important"></div>
											<div id="loader_label"></div>
			<div id="preview_label"></div>
										</div>
									</div>
							</div>
							<h4 class="font-italic text-left">CTS-bicluster inference <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Choose the resource of cell types, either predicted from SC3 or the ground truth labels provided in the uploaded cell label file. The CTS-biclusters are determined by performing the hypergeometric test between the cells in each bicluster and in each cell type."> </span></h4>
							<div class="row">
								<div class="form-check col-sm-2 ">
									<input type="radio" value="1" id="enable_sc3" name="bicluster_inference" class="custom-control-input" checked="">
									<label class="custom-control-label" for="enable_sc3">SC3 <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A clustering based cell type prediction tool. Default parameters are used."> </span>
									</label>
									
								</div>
								<div class="col-sm-2">
									<input type="radio" value="2" id="enable_labelfile" name="bicluster_inference" disabled="true" class="custom-control-input">
									<label class="custom-control-label" for="enable_labelfile">Your cell label <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Enable this option by uploading your cell label file."> </span>
									</label>
								</div>
								
							</div>
							<br>
							<h4 class="font-italic text-left">Upload gene module: (Optional) 
							 <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="The developed gene modules that you are interested in or identified by preferred module detection methods can be uploaded to IRIS3 and have them analyzed to identify the “module-specific regulons”. Each column should represents a gene module, check example gene module file for more details."> </span> 
							</h4>
			
							<div id="upload_gene_module">
									<div class="form-group row">
										<div class="col-sm-4">
											<div class="dropdown" id="drop_gene_module">
												<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:1px solid #c9c9c9;border-radius:.25rem!important">Example <span class="caret"></span>
												</button>
												<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
													<!--<li><a id="load_gene_module" class="dropdown-item" href="#dropzone_label">Load example file</a>
													</li>-->
													<li><a class="dropdown-item" href="/iris3/storage/iris3_example_gene_module.csv" download>Download example gene module file</a>
													</li>
												</ul>
											</div>
											<div id="dropzone_gene_module" class="dropzone border-grey rounded dz-clickable" style="background-image: url(assets/img/gene_module_example.jpg); background-size: 100% 100%;margin:0;border:1px solid #c9c9c9;border-radius:.25rem!important"></div>
														<div id="loader_gene_module"></div>
			<div id="preview_gene_module"></div>
										</div>
									</div>
							</div>
							<!--
							<br>
							<h4 class="font-italic text-left">CTS-regulon prediction <span class="glyphicon glyphicon-question-sign" data-html="true" data-toggle="tooltip" data-original-title="Regulon: a group of genes that controlled by the same regulatory gene.<br>
CTS-regulon: A group of genes controlled by ONE motif under the same cell type. Genes can repeated show up in multiple regulons. <br>
 One regulon refers to multiple gene groups found in one bicluster under the same cell type."> </span></h4>
							<div class="row">
								<div class="form-check col-sm-2 ">
									<input type="radio" id="motif_dminda" value="0" name="motif_program" class="custom-control-input" checked="">
									<label class="custom-control-label" for="motif_dminda">DMINDA <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Our in-house motif prediction tool."> </span>
									</label>
								</div>
								<div class="col-sm-2">
									<input type="radio" id="motif_meme" value="1" name="motif_program" class="custom-control-input">
									<label class="custom-control-label" for="motif_meme">MEME <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="We integrated the MEME command line version as an option for motif prediction. Default parameters are used. "> </span>
									</label>
								</div>
								<br>
							</div>
							-->
							<div class="row">
								<div class="col-md-5">
									<label for="ex2">Upstream promoter region:	
									 <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="The upstream length from a gene and its DNA sequence will be used for DNA motif prediction."> </span> 
									</label>
									<select class="selectpicker" name="promoter_arg" data-width="auto">
										<option>500</option>
										<option data-subtext="Default" selected="selected">1000</option>
										<option>2000</option>
									</select>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="form-check col-sm-12 ">
				<input class="form-check-input" type="checkbox" name="allowstorage" id="allowstorage" value="1">
				<label class="form-check-label" for="allowstorage">Allow permanent storage in our database <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="By checking this option, you allow us to store your data in IRIS3 database (both submitted and results) for the future database construction. Be cautious if your data have not been published."> </span>
				</label>
			</div>
		<div id="emailfd" class="section" style="position:relative;top:10px;">&nbsp;&nbsp;Optional: Please leave your email below; you will be notified by email when the job is done.
			<br/>
			<div class="bootstrap-iso" style="margin-top: 5px;">&nbsp; <strong>E-mail</strong>&nbsp;:
				<input name="email" type="text" id="email" size="60" style="position:relative;left:10px; width : 30%;" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
		</div>
		<hr>
		<div class="form-group">
			<button type="submit" id="submit_btn" disabled="true" class="btn btn-submit" name="submit" value="submit">Submit</button>
			<input type="hidden" id="is_load_exp" name="is_load_exp" value="0">
			<input type="hidden" id="is_load_label" name="is_load_label" value="0">
			<input type="hidden" id="is_load_gene_module" name="is_load_gene_module" value="0">
			<input type="hidden" id="k_arg" name="k_arg" value="18">
			<input class="btn btn-submit" type="button" value="Example output" onClick="javascript:location.href = '/iris3/results.php?jobid=2019062485208#';" />

		</div>
		<div class="form-group">
			<p id="words" class="hidden text-danger">Your job is running, don't close the browser tab, waiting time could vary from minutes to hour.</p>
		</div>
	</form>
	<!--</div>-->
	<hr>
	<script src='assets/js/dropzone.js'></script>
	<link href="assets/css/dropzone.css" type="text/css" rel="stylesheet" />
</main>{{/block}}