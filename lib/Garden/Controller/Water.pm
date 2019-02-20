package Garden::Controller::Water;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(to_json);
use Weather::NOAA::GFS;
use Weather::Underground;

sub connected{

#my $jsonstuff = $self->req->params->to_hash

}

sub water{
    
    my $self = shift;
    
    my $rs = $self->pg->db->query('select data from tax');
    
   
    }
sub status{
    
    
    my $self = shift;
    my $jsonstuff = $self ->pg->db->query('select info from ord order BY genesis desc;')->expand->hash;
    warn $self->dumper($jsonstuff);
    #$jsonstuff = Mojo::JSON->from_json($jsonstuff);
    #my $jsonstuff = $self ->pg->db->query('select info from ord order BY genesis desc limit 10;')->hash;
    #my $jsonstuff = $self ->pg->db->query('select ?::json as info', {json => {temperature => 'temp'}});
    #$self->stash( json => $jsonstuff);
    
    #$self->stash(json => $jsonstuff);

    
    #my $->stash(json => $jsonstuff);
    
    #$jsonstuff->stash(json => {info => 'temerature'});
    
    #my $json = $jsonstuff->stash;
    return $self->render(json_data => $jsonstuff);
    
     }
    
sub weather_data{
    
    my $self = shift; 
    
    # define parameters 
    my %params = (
                'minlon'   => -5,# mandatory
                'maxlon'   => 45,# mandatory
                'minlat'   => 30,# mandatory
                'maxlat'   => 50,# mandatory
                'mail_anonymous'    => 'my@mail.org',# mandatory to log NOAA ftp server
                'gradsc_path' => 'gradsc',# mandatory, needed to create maps
                'wgrib_path' => 'wgrib',# mandatory, needed to process NOAA GRIB files
                'timeout'=> '30',#mandatory timeout in minute
                'debug'    => 1, # 0 no output - 1 output
                'logfile'    => 'weather-noaa-gfs.log',# optional
                'cbarn_path' => 'cbarn.gs', #optional, needed to print image legend
                'r_path' => 'R',# optional, needed to downscale
                'server_list' => 'nomad3.ncep.noaa.gov,nomad5.ncep.noaa.gov',#optional, server list to choose from   
                );
     my $weather_gfs = Weather::NOAA::GFS->new(%params);
     
     #download Grib files for your area
 
  if($weather_gfs->downloadGribFiles()){
        print "downloadGribFiles done!!!";
  } else {
        print "Error: downloadGribFiles had problems!!!";
        die;
  }
   
  #transform Grib files to Ascii files (needs GrADS's wgrib)
   
  if($weather_gfs->grib2ascii()){
        print "grib2ascii succeded!!!";
  } else {
        print "Error: grib2ascii had problems!!!";
        die;
  }
 
  #transform Ascii files to IDRISI files
   
  if($weather_gfs->ascii2idrisi()){
        print "ascii2idrisi succeded!!!";
  } else {
        print "Error: ascii2idrisi had problems!!!";
        die;
  }
 
  #Downscale to 0.1 degrees the IDRISI files (needs R)
  #Execution time has a sensible increase (x3 ca.)
  if($weather_gfs->idrisiDownscale()){
        print "idrisiDownscale succeded!!!";
  } else {
        print "idrisiDownscale had problems!!!";
        die;
  }
   
  #itransform Idrisi files to Png images (needs GrADS's gradsc)
  if($weather_gfs->idrisi2png()){
        print "idrisi2png succeded!!!";
  } else {
        print "Error: idrisi2png had problems!!!";
        die;
  }
 
  #Delete files you don't need
  my @typesToDelete = (
        "grib",
        "temp",
        #"png",
        "idrisi",
        );
$weather_gfs->cleanUp(@typesToDelete);

return $self;
     
     
     
    }
    
    
    
  sub chart_data{
      


 // javascript
var dataset = [20, 100, 56, 120, 180, 30, 40, 120, 160];

var svgWidth = 500, svgHeight = 300, barPadding = 5;
var barWidth = (svgWidth / dataset.length);


var svg = d3.select('svg')
    .attr("width", svgWidth)
    .attr("height", svgHeight);
    
var barChart = svg.selectAll("rect")
    .data(dataset)
    .enter()
    .append("rect")
    .attr("y", function(d) {
         return svgHeight - d 
    })
    .attr("height", function(d) { 
        return d; 
    })
    .attr("width", barWidth - barPadding)
    .attr("transform", function (d, i) {
var translate = [barWidth * i, 0]; 
        return "translate("+ translate +")";
    });



}
1;
