
use Data::Dumper;

#grab command line arguments for files
$file0 = @ARGV[0];
$file1 = @ARGV[1];
$file2 = @ARGV[2];


#open training file
open(my $train, '<:encoding(UTF-8)', $file0)
 or die "coult not open file '$file0' $!";

#open test file
open(my $test, '<:encoding(UTF-8)', $file1)
 or die "coult not open file '$file1' $!";
 
#open decision list
open(my $dlist, '<:encoding(UTF-8)', $file2)
 or die "coult not open file '$file2' $!";
 

while (my $row = <$train>) {
	chomp $row;
	@line = split/ +/, $row; # splits on white
	push @corpus, @line;	#add to text
}


print Dumper (\@corpus);