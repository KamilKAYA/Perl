use POSIX;
print "\n Textual / Verilog Generator
 Binary Tree of Adders
 Written by Kamil KAYA
 Ozyegin University - EEE \n\n";

$InputIsOkay=0;
while($InputIsOkay==0){
	print " Please enter command, item and bit length (Ex:bta 4 6) >>";
	$comInput=<STDIN>;
	chomp $comInput;
	($command, $input, $bitSize)=split / +/, $comInput;
	$FileName=$command."_".$input."_".$bitSize;
	$export=$FileName.".v";
	if(($command eq "bta") and $bitSize>0 and	$input>0){
		$InputIsOkay=1;
		print " \n";
	}else
	{
		print " Please try again. \n"
	}	
}

# Program adder item calculation start.
my @adders;
my $number=0;
my $bit=1;
my $carry=2;
if($input>0){
	$adders[0][$number]=$input;
	$arrayCounter=0;
	while($adders[$arrayCounter][$number]!=0){
			$adders[$arrayCounter][$carry]=$adders[$arrayCounter][$number]%2;
			$adders[$arrayCounter][$number]=floor($adders[$arrayCounter][$number]/2);
			
			$adders[$arrayCounter][$bit]=$bitSize+$arrayCounter;									

			
			if($adders[$arrayCounter][$carry]==1 and $carryFlag==0){
				$carryFlag=1;
			}elsif($adders[$arrayCounter][$carry]==1 and $adders[$arrayCounter-1][$carry]==1 and $carryFlag==1){
				$adders[$arrayCounter][$number]++;
				$carryFlag=0;
			}elsif($adders[$arrayCounter][$carry]==1 and $adders[$arrayCounter-1][$carry]==0 and $carryFlag==1){
				$adders[$arrayCounter][$number]++;
				$carryFlag=0;
			}
			
			$arrayCounter++;	
			$adders[$arrayCounter][$number]=$adders[$arrayCounter-1][$number];
	}
}

$carryFlag=0;
print " For this design you need: \n";
for($i=0; $i<$arrayCounter-1; $i++){
	print "\t".$adders[$i][0]."x".$adders[$i][1]." bit FA \n";
}
print " adders \n";
# Program adder item calculation end.


# File writing sub program begin.
open(File, ">$export") or die " Could not open the file.";
print File "module Top_".$FileName."(";
for($i=0; $i<$input; $i++){
	print File "input [".($bitSize-1).":0] in".$i;
	print File ", ";
}
print File "output reg [".($adders[$arrayCounter-1][$bit]-1).":0] out, output reg carry);\n";


print File "endmodule";


for($i=0; $i<$arrayCounter-1; $i++){
print File "
module FullAdder_".$adders[$i][$bit]."bit(input [".($adders[$i][$bit]-1).":0] in0, input [".($adders[$i][$bit]-1).":0] in1, input carryIn, output wire [".($adders[$i][$bit]).":0] out, output wire carryOut);
    wire [".($adders[$i][$bit]+1).":0] acc;
    assign acc=in0+in1+carryIn;
    assign out=acc[".($adders[$i][$bit]).":0];
    assign carryOut=acc[".($adders[$i][$bit]+1)."]; 
endmodule
";
}

# File writing sub program end.
