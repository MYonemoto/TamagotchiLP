use warnings;
use strict;

use Wx;
use wxPerl::Constructors;
use Wx qw( wxWidth wxHeight);
use threads('yield', 'stack_size'=>64*4096, 'exit'=> 'threads_only', 'stringify');
use threads::shared;
use Audio::Beep;

package MyApp;
  
use base 'Wx::App';

my $btnSleep :shared;
$btnSleep = 'DORMIR';

my $lastState :shared;

my $happy :shared;
$happy = 100;

my $hunger :shared;
$hunger = 100;

my $health :shared;
$health = 100;

my $dirty :shared;
$dirty = 0;

my $tired :shared;
$tired = 0;

my $luz :shared;
$luz = 'ACESA';

my $state :shared; 
$state = 'normal';

my $normal :shared;
$normal = "
     (o)--(o)
    /.____.\\
    \\_____/
   ./          \\.
( .              . )
  \\ \\_\\\\//_/ /
 ~~  ~~  ~~  
 ";

my $sleep :shared;
$sleep = "
     (-)--(-)
    /.____.\\
    \\_____/
   ./          \\.
( .              . )
  \\ \\_\\\\//_/ /
 ~~  ~~  ~~ 
 ";

my $dead :shared; 
$dead = "
     (x)--(x)
    /.____.\\
    \\_____/
   ./          \\.
( .              . )
  \\ \\_\\\\//_/ /
 ~~  ~~  ~~  
 ";

my $food :shared;
$food = "
         \\/ .--,   
         //_..       
   .----/---.          
  /        __ \\      
 \\       \\ __                                           
   \\__.__ /            
";

my $sujo :shared;
$sujo = "
     (     )
  (   )   (
    )  _   )
      (    \\_
  _(_\\     \\)__
 (____\\___))
";

my $emoji : shared;
$emoji = $normal;

my $emoji_aux : shared;

my $emoji2 : shared;
$emoji2 = "";

sub Restart {
   $state = 'normal';
   $happy = 100;
   $hunger = 100;
   $health = 100;
   $tired = 0;
   $dirty = 0;
   $luz = 'ACESA';
   $btnSleep = 'DORMIR';
}

sub UpdateTime {
   if ($state eq 'normal') {
	$happy = $happy - 2;
	$hunger = $hunger - 2;
	$health = $health - 1;
	$tired++;
	$dirty++;
	
   }
   if ($state eq 'dirty') {
	$happy = $happy - 1;
	$hunger = $hunger - 1;
	$health = $health - 1;
	$tired++;
	$dirty++;
	
   }
   if ($state eq 'sad') {
	$happy = $happy - 3;
	$hunger = $hunger - 1;
	$health = $health - 2;
	$tired++;
	$dirty++;
   }
   if ($state eq 'sick') {
	$happy = $happy - 1;
	$hunger = $hunger - 2;
	$health = $health - 3;
	$tired++;
	$dirty++;
   }
   if ($state eq 'hungry') {
	$happy = $happy - 2;
	$hunger = $hunger - 3;
	$health = $health - 2;
	$tired++;
	$dirty++;
   }
   if ($state eq 'tired') {
	$happy = $happy - 3;
	$hunger = $hunger - 1;
	$health = $health - 2;
	$tired++;
	$dirty++;
   }
   if($state eq 'sleeping'){
	$happy = $happy - 1;
	$hunger = $hunger - 1;
	$health = $health - 1;
	$tired = $tired - 5;
	$dirty++;
	if($tired <= 0){
           $state = $lastState;
           $luz = 'ACESA';
           $btnSleep = 'DORMIR';
        }
   }
   if ($state eq 'playing') {
   	if($happy < 100){
		$happy = $happy + 1;
	}
	$hunger = $hunger - 20;
	$health = $health - 1;
	$tired++;
	$dirty++;
	
   }
   Update();
}

sub Update {
      if($state ne 'dead' and $state ne 'sleeping'){
		if($hunger <= 0 or $happy <= 0 or $health <= 0){
			$state = 'dead';
			$emoji = $dead;
		}
		elsif($state eq 'normal'){
			if($dirty >= 10 and $state ne 'dirty'){
				$state = 'dirty';
				$emoji2 = $sujo;
			}
			elsif($tired >= 50 and $state ne 'tired'){
				$state = 'tired';
			}
			elsif($happy < 40 and $state ne 'sad'){ 
				$state = 'sad';	
			}
			elsif($health < 40 and $state ne 'sick'){ 
				$state = 'sick';
			}
			elsif($hunger < 80 and $state ne 'hungry'){
				$state = 'hungry';
				$emoji2 = $food;
			}
			$emoji = $normal;
		}
		elsif($state eq 'dirty' and $dirty <10){
			if(($happy >= 40 and $health >= 40 and $hunger >= 40) and ($state ne 'normal')){
				$state = 'normal';
			}
			elsif($tired >= 50 and $state ne 'tired'){
				$state = 'tired';
			}
			elsif($happy < 40 and $state ne 'sad'){ 
				$state = 'sad';
			}
			elsif($health < 40 and $state ne 'sick'){ 
				$state = 'sick';
			}
			elsif($hunger < 40 and $state ne 'hungry'){
				$state = 'hungry';
				$emoji2 = $food;
			}
		}
		elsif($state eq 'tired' and $tired < 50){
			if($dirty >= 10 and $state ne 'dirty'){
				$state = 'dirty';
				$emoji2 = $sujo;
			}
			elsif(($happy >= 40 and $health >= 40 and $hunger >= 40) and ($state ne 'normal')){
				$state = 'normal';
			}
			elsif($happy < 40 and $state ne 'sad'){ 
				$state = 'sad';
			}
			elsif($health < 40 and $state ne 'sick'){ 
				$state = 'sick';
			}
			elsif($hunger < 40 and $state ne 'hungry'){
				$state = 'hungry';
			}
		}
		elsif($state eq 'sad' and $happy > 40){
			if($dirty >= 10 and $state ne 'dirty'){
				$state = 'dirty';
				$emoji2 = $sujo;
			}
			elsif(($happy >= 90 and $health >= 40 and $hunger >= 40) and ($state ne 'normal')){
				$state = 'normal';
			}
			elsif($tired >= 50 and $state ne 'tired'){
				$state = 'tired';
			}
			elsif($health < 40 and $state ne 'sick'){ 
				$state = 'sick';
			}
			elsif($hunger < 40 and $state ne 'hungry'){
				$state = 'hungry';
				$emoji2 = $food;
			}
		}
		elsif($state eq 'sick' and $health > 40){
			if($dirty >= 10 and $state ne 'dirty'){
				$state = 'dirty';
				$emoji2 = $sujo;
			}
			elsif(($happy >= 40 and $health >= 40 and $hunger >= 40) and ($state ne 'normal')){
				$state = 'normal';
			}
			elsif($happy < 40 and $state ne 'sad'){ 
				$state = 'sad';
			}
			elsif($tired >= 50 and $state ne 'tired'){
				$state = 'tired';
			}
			elsif($hunger < 40 and $state ne 'hungry'){
				$state = 'hungry';
				$emoji2 = $food;
			}
		}
		elsif($state eq 'hungry' and $hunger > 80){
			if($dirty >= 10 and $state ne 'dirty'){
				$state = 'dirty';
				$emoji2 = $sujo;
			}
			elsif(($happy >= 40 and $health >= 40 and $hunger >= 40) and ($state ne 'normal')){
				$state = 'normal';
				$emoji2 = "";
			}
			elsif($happy < 40 and $state ne 'sad'){ 
				$state = 'sad';
			}
			elsif($tired >= 50 and $state ne 'tired'){
				$state = 'tired';
			}
			elsif($health < 40 and $state ne 'sick'){ 
				$state = 'sick';
				$emoji2 = $food;
			}
		}
	}
	elsif($state ne 'dead' and $luz eq 'ACESA'){
            $state = $lastState;
            $emoji = $emoji_aux;
	}
	elsif($state eq 'dead'){
		$health = 0;
		$hunger = 0;
		$happy = 0;
	}
}

sub OnInit {
        my $self = shift;
        my $frame = wxPerl::Frame->new(undef, 'TAMAGOTCHI');
        $frame->SetMinSize([120,40]);
        my $sizer = Wx::BoxSizer->new(&Wx::wxVERTICAL);
        
        my $self1 = shift;
	my $frame1 = wxPerl::Frame->new($frame, 'QUIZ GAME');
	$frame1->SetMinSize([120,40]);
	my $sizer1 = Wx::BoxSizer->new(&Wx::wxVERTICAL);
        
        my $text_tama2 = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "$emoji2",    # The literal text to display
           [250, 150],           # [x, y] coordinates of the control
        );
        
        my $text_tama = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "$normal",    # The literal text to display
           [150, 150],           # [x, y] coordinates of the control
        );
        
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
        
        my $text_luz = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "LUZ: ",    # The literal text to display
           [10, 90],           # [x, y] coordinates of the control
        );
        
        my $text_luz_value = Wx::StaticText->new(
           $frame,             # parent window
           -1,                 # Let the system assign a window ID
           "$luz",    # The literal text to display
           [40, 90],           # [x, y] coordinates of the control
        );
        
        my $comer = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'COMER',      # label
                                  [100, 300],       # position
                                  [-1, -1],       # default size
                                  );
           
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
                                  "$btnSleep",      # label
                                  [190, 330],       # position
                                  [-1, -1],       # default size
                                  );
       
       my $reset = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'RESTART',      # label
                                  [190, 360],       # position
                                  [-1, -1],       # default size
                                  );
                                  
       my $exit = Wx::Button->new( $frame,        # parent window
                                  -1,             # ID
                                  'SAIR',      # label
                                  [140, 390],       # position
                                  [-1, -1],       # default size
                                  );
       
       
       Wx::Event::EVT_BUTTON($jogar, -1, sub {
                
		$frame1->Show;
		$lastState = $state;
		$state = 'playing';
		
		
		my $exitt = Wx::Button->new( $frame1,        # parent window
                                  -1,             # ID
                                  "SAIR",      # label
                                  [150, 300],       # position
                                  [-1, -1],       # default size
                                  );
		
		my $op1 = Wx::Button->new( $frame1,        # parent window
                                  -1,             # ID
                                  "Chapecoense",      # label
                                  [100, 200],       # position
                                  [-1, -1],       # default size
                                  );
                                  
                my $op2 = Wx::Button->new( $frame1,        # parent window
                                  -1,             # ID
                                  "Milan",      # label
                                  [100, 250],       # position
                                  [-1, -1],       # default size
                                  );
                                  
                my $op3 = Wx::Button->new( $frame1,        # parent window
                                  -1,             # ID
                                  "PSG",      # label
                                  [200, 200],       # position
                                  [-1, -1],       # default size
                                  );
                                  
                my $op4 = Wx::Button->new( $frame1,        # parent window
                                  -1,             # ID
                                  "Boca Jrs",      # label
                                  [200, 250],       # position
                                  [-1, -1],       # default size
                                  );
                                  
             my $text_q = Wx::StaticText->new(
             $frame1,             # parent window
             -1,                 # Let the system assign a window ID
             "QUAL TIME PERTENCE A FRANCA?",    # The literal text to display
             [100, 100],           # [x, y] coordinates of the control
             );
             
             Wx::Event::EVT_BUTTON($op3, -1, sub {
             	if($state ne 'dead'){
			$text_q->SetLabel("QUAL SELECÃO NUNCA GANHOU UM MUNDIAL?");
			$op1->SetLabel("Brasil");
			$op2->SetLabel("Holanda");
			$op3->SetLabel("Uruguai");
			$op4->SetLabel("Itália");
			Wx::Event::EVT_BUTTON($op1, -1, sub {
					 $frame1->Destroy();
			});
				    
			Wx::Event::EVT_BUTTON($op3, -1, sub {
					$frame1->Destroy();
			});
				    
			Wx::Event::EVT_BUTTON($op4, -1, sub {
					$frame1->Destroy();
			});
		}
		else{
			$frame1->Destroy();
		}
                Wx::Event::EVT_BUTTON($op2, -1, sub {
		  if($state ne 'dead'){
			  $text_q->SetLabel("QUAL DOS TIMES ABAIXO NAO É TRICOLOR?");
			  $op1->SetLabel("Criciuma");
			  $op2->SetLabel("Bahia");
			  $op3->SetLabel("Joinville");
			  $op4->SetLabel("Grêmio");
			  Wx::Event::EVT_BUTTON($op2, -1, sub {
				 $frame1->Destroy();
			  });
			    
			  Wx::Event::EVT_BUTTON($op3, -1, sub {
				$frame1->Destroy();
			  });
			    
			  Wx::Event::EVT_BUTTON($op4, -1, sub {
				$frame1->Destroy();
			  });
		  }
		  else{
			$frame1->Destroy();
		  }  
			  Wx::Event::EVT_BUTTON($op1, -1, sub {
			    if($state ne 'dead'){
				  $text_q->SetLabel("QUANTOS MUNDIAIS TEM O CORINTHIANS?");
				  $op1->SetLabel("3");
				  $op2->SetLabel("2");
				  $op3->SetLabel("Nenhum");
				  $op4->SetLabel("1");
				  Wx::Event::EVT_BUTTON($op1, -1, sub {
					 $frame1->Destroy();
				  });
				    
				  Wx::Event::EVT_BUTTON($op2, -1, sub {
					$frame1->Destroy();
				  });
				    
				  Wx::Event::EVT_BUTTON($op3, -1, sub {
					$frame1->Destroy();
				  });
				  }
			  else{
				$frame1->Destroy();
			  } 
				  Wx::Event::EVT_BUTTON($op4, -1, sub {
						$op1->Hide;
						$op2->Hide;
						$op3->Hide;
						$op4->Hide;
						$text_q->Hide;
						
						$happy = $happy + 50;
						
						my $text_win = Wx::StaticText->new(
						$frame1,
						-1,
						"YOU WIN!!",
						[150,150],
						);
						
						my $exit_game = Wx::Button->new( $frame1,        # parent window
								  -1,             # ID
								  'VOLTAR',      # label
								  [200, 250],       # position
								  [-1, -1],       # default size
								  );
						Wx::Event::EVT_BUTTON($exit_game, -1, sub {
							$state = $lastState;
							$frame1->Destroy();
						}); 
					
				});
			});
		});
	    
            });
            Wx::Event::EVT_BUTTON($op2, -1, sub {
                 $frame1->Destroy();
	    });
	    
	    Wx::Event::EVT_BUTTON($op1, -1, sub {
                $frame1->Destroy();
	    });
	    
	    Wx::Event::EVT_BUTTON($op4, -1, sub {
	    	$frame1->Destroy();
	    });
	    
	    Wx::Event::EVT_BUTTON($exitt, -1, sub {
                $state = $lastState;
                $frame1->Destroy();
	    });
      });
                
      Wx::Event::EVT_BUTTON($curar, -1, sub {
                if($health < 100 and $state ne 'dead'){
			lock$health;
			$health = $health + 2;
		}
		Update();
                $text_health_value->SetLabel("| $health |");
       });
                
       Wx::Event::EVT_BUTTON($comer, -1, sub {
		if($hunger < 100 and $state ne 'dead'){
			lock$hunger;
			$hunger = $hunger + 2;
		}
		elsif($hunger > 100 and $state ne  'dead'){
			$health = 39;
		}
		Update();
                $text_hunger_value->SetLabel("| $hunger |");
       });
                
       Wx::Event::EVT_BUTTON($limpar, -1, sub {
                if($state ne 'dead' and $state eq 'dirty'){
			lock$dirty;
			$dirty = 0;
			$health = $health + 5;
			$emoji2 = "";
			$text_tama2->SetLabel("$emoji2");
			Update();
			$text_state_value->SetLabel("| $state |"); 
                }
       });
                
       Wx::Event::EVT_BUTTON($reset, -1, sub {
               Restart(); 
               $text_luz_value->SetLabel("$luz");
               $dormir->SetLabel("$btnSleep");
               $text_happy_value->SetLabel("| $happy |");
               $text_hunger_value->SetLabel("| $hunger |");
               $text_health_value->SetLabel("| $health |");
               $text_state_value->SetLabel("| $state |");
               
       });
                
       Wx::Event::EVT_BUTTON($dormir, -1, sub {
                if($state ne 'dead'){
			if($luz eq 'ACESA'){
				$luz = 'APAGADA';
				$btnSleep = 'ACORDAR';
				$lastState = $state;
				$state = 'sleeping';
				$emoji_aux = $emoji;
				$emoji = $sleep;
			}
			else{
				$luz = 'ACESA';
				$btnSleep = 'DORMIR';
				
			}
			Update();
			$text_tama->SetLabel("$emoji");
			$text_luz_value->SetLabel("$luz");
			$dormir->SetLabel("$btnSleep");
			$text_state_value->SetLabel("| $state |"); 
                }
       });
       
       Wx::Event::EVT_BUTTON($exit, -1, sub {
                $frame->Destroy();
                
       });
                    
       my $tr_listener = threads->create(sub{
            while(1){
               sleep 2;
               UpdateTime();
               print "dirty: $dirty\n tired: $tired\n";
               $text_tama2->SetLabel("$emoji2");
               $text_luz_value->SetLabel("$luz");
               $dormir->SetLabel("$btnSleep");
               $text_happy_value->SetLabel("| $happy |");
               $text_hunger_value->SetLabel("| $hunger |");
               $text_health_value->SetLabel("| $health |");
               $text_state_value->SetLabel("| $state |");
               
               
            }
       });
       
       my $tr_audio = threads->create(sub{
	   while(1){
	       my $beeper = Audio::Beep->new();
	       my $music = "g' f bes' c8 f d4 c8 f d4 bes c g f2 g' f bes' c8 f d4 c8 f d4 bes c g f2 g' f bes' c8 f d4 c8 f d4 bes c g f2";
	       $beeper->play( $music );
	   }
       	
       	
       	});
       	
       	my $tr_gif = threads->create(sub{
		while(1){
			if($state ne 'dead' and $state ne 'sleeping'){
				$emoji = $normal;
				$text_tama->SetLabel("$emoji");
				sleep 1;
				$emoji = $sleep;
				$text_tama->SetLabel("$emoji");
				
			}
			elsif($state eq 'dead'){
				$text_tama->SetLabel("$emoji");
				#$frame1->Destroy();
			}
			sleep 1;
		}
       	
       		
       	});
             
       $frame->SetSizer($sizer);
       $frame->Show;
       
}
 
MyApp->new->MainLoop;