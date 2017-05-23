#!/usr/bin/perl

#This is the scorer for the POS tagger

use Data::Dumper;

#get command line arguments
$file0 = @ARGV[0];
$file1 = @ARGV[1];

#open test with tags and key
open(my $test, '<:encoding(UTF-8)', $file0)
 or die "coult not open file '$file0' $!";

open(my $key, '<:encoding(UTF-8)', $file1)
 or die "coult not open file '$file0' $!";
 
 
 #initialize arrays for each file and the confusion matrix hashmy @testtags;
my @keytags;
my %confusion;
#load each array
while (my $row = <$test>) {
	chomp $row;
	@line = split/ +/, $row; # splits on white
	push @testtags, @line;
}while (my $row = <$key>) {
	chomp $row;
	@line = split/ +/, $row; # splits on white
	push @keytags, @line;
}

#keep track of numbers of correct tagging, as well as a list of each tag
$correct = 0;
$total = 0;
%listOfTags;for $i (0..$#keytags){
	$word = $keytags[$i];
	unless ($word=~m/\[|\]/){	#ignore brackts
		$total++;	#increment total number of words
		@key = split/\//, $keytags[$i];	#split key word into word and tag
		@tag = split/\//, $testtags[$i];	#split test word into word and tag
		$tizzag = @key[$#key];	#grab key tag
		$tizzag =~s/(.*)\|.*/$1/;	#only use first tag in ambiguous tags
		if (@tag[$#tag] eq $tizzag){
			$correct++;	#increment amount correct if necessary
		}
		$confusion{$tizzag}{@tag[$#tag]}++;	#save tag assignments into confusion matrix
		$listOfTags{$tizzag}++;	#save names of each tag
	}
}


$score = $correct/$total*100;	#turn score into percentage and print
printf "The accuracy of the tagging program is %.2f percent.\n", $score;
print "\nThe confusion matrix is as follows:\n\n";#print confusion matrix
my @alltags;
while (my $key = each(%listOfTags)){
	if ($key=~m/.+/){
		push(@alltags, $key);
		print "$key|"; #print each tag as top row
	}
}
print "\n";
 
 
# #print each entry of confusion matrix at the intersection of the tags in the table
for $i (0 .. $#alltags){
    for $j (0 .. $#alltags){
        if (exists $confusion{$alltags[$i]}{$alltags[$j]}){
            print  $confusion{$alltags[$i]}{$alltags[$j]}; #gets numbers of each assigned tag and key tag
        }
        else{
            print "0";	#fills in zeroes for when there isn't an intersection of tags on the matrix
        }
        print " | ";	#spacing lines for easy reading
    }
    print "\n";
}