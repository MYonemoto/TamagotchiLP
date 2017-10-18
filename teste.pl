use warnings;
use strict;

use Wx;
use wxPerl::Constructors;
use Wx qw( wxWidth wxHeight);
use threads('yield', 'stack_size'=>64*4096, 'exit'=> 'threads_only', 'stringify');
use threads::shared;
#use Wx::Image;
#use Wx::Perl::Imagick;
#use GD::Image;
use IO::File;
use GD::Image;



package MyApp;
  
use base 'Wx::App';

my $happy :shared;
$happy = 100;
my $hunger = 100;
my $health = 100;
my $state = 'normal';


sub OnInit {
        my $self = shift;
        my $frame = wxPerl::Frame->new(undef, 'A wxPerl Application');
        $frame->SetMinSize([120,40]);
        my $sizer = Wx::BoxSizer->new(&Wx::wxVERTICAL);
        
        my $text_happy = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "HAPPY",    # The literal text to display
           [50, 25],           # [x, y] coordinates of the control
        );
        
        my $text_happy_value = Wx::StaticText->new(
           $frame,             # parent window
           1,                 # Let the system assign a window ID
           "| $happy |",    # The literal text to display
           [50, 45],           # [x, y] coordinates of the control
        );
        
        my $text_hunger = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "HUNGER",    # The literal text to display
           [120, 25],           # [x, y] coordinates of the control
        );
        
        my $text_hunger_value = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "| $hunger |",    # The literal text to display
           [120, 45],           # [x, y] coordinates of the control
        );
        
        my $text_health = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "HEALTH",    # The literal text to display
           [190, 25],           # [x, y] coordinates of the control
        );
        
        my $text_health_value = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "| $health |",    # The literal text to display
           [190, 45],           # [x, y] coordinates of the control
        );
        
        my $text_state = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "STATE",    # The literal text to display
           [260, 25],           # [x, y] coordinates of the control
        );
        
        my $text_state_value = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "| $state |",    # The literal text to display
           [260, 45],           # [x, y] coordinates of the control
        );
        
        my $comer = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'COMER',      # label
                                  [100, 300],       # position
                                  [-1, -1],       # default size
                                  );
  
       #my $button = wxPerl::Button->new($frame, 'Click Me'); 
       #$sizer->Add($button, 0.5, 5, &Wx::wxEXPAND);
       #my $button2 = wxPerl::Button->new($frame, 'DO NOT CLICK');
       #$sizer->Add($button2, 0.5, 5, &Wx::wxEXPAND);
       
       
       
       my $limpar = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'LIMPAR',      # label
                                  [100, 330],       # position
                                  [-1, -1],       # default size
                                  );
                                  
       my $jogar = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'JOGAR',      # label
                                  [100, 360],       # position
                                  [-1, -1],       # default size
                                  );
       
       
       
       my $curar = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'CURAR',      # label
                                  [190, 300],       # position
                                  [-1, -1],       # default size
                                  );
       
       my $dormir = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'DORMIR',      # label
                                  [190, 330],       # position
                                  [-1, -1],       # default size
                                  );
       
       my $reset = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'RESTART',      # label
                                  [190, 360],       # position
                                  [-1, -1],       # default size
                                  );
       
       Wx::Event::EVT_BUTTON($jogar, -1, sub {
                #my ($b, $evt) = @_;
                lock$happy;
                $happy = $happy + 2;
                $text_happy_value->SetLabel("| $happy |");
                #$b->SetLabel($r);
                #$b->Disable;
                });
       #Wx::Event::EVT_BUTTON($button2, -1, sub {
       #&Wx::wxTheApp->ExitMainLoop;
       #});
       my $aux = 0;
       my $tr_happy = threads->create(sub{
            while(1){
               sleep 2;
               $happy = $happy - 2;
               $text_happy_value->SetLabel("| $happy |");
               
            }
       });
       
       my $tr_health = threads->create(sub{
            while($health >= 0){
               sleep 2;
               $health = $health - 2;
               $text_health_value->SetLabel("| $health |");
               Wx::Event::EVT_BUTTON($curar, -1, sub {
                #my ($b, $evt) = @_;
                $health = $health + 2;
                $text_health_value->SetLabel("| $health |");
                #$b->SetLabel($r);
                #$b->Disable;
                });
            }
       });
       
       my $tr_hunger = threads->create(sub{
            while($hunger >= 0){
               sleep 2;
               $hunger = $hunger - 2;
               $text_hunger_value->SetLabel("| $hunger |");
               Wx::Event::EVT_BUTTON($comer, -1, sub {
                #my ($b, $evt) = @_;
                $hunger = $hunger + 2;
                $text_hunger_value->SetLabel("| $hunger |");
                #$b->SetLabel($r);
                #$b->Disable;
                });
            }
       });
       
       
       $frame->SetSizer($sizer);
       $frame->Show;
       #$frame->Freeze();
       #$frame->DestroyChildren();
       
}
 
MyApp->new->MainLoop;