#!/usr/bin/perl

# Kyle Sutherland
# CMSC 416
# 3/12/2017
# Assignment 3
# POS Tagging
#
# The purpose of this program is to perform part of speech tagging on a document.  
# The program is to implement the most likely tag algorithm where the objective is
# to maximize P(tag|word).  The program reads in a training dataset of tags and 
# then uses those tags to label a test dataset.  In additon, five extra rules must
# be implemented to aid in the tagging operation and increase the accuracy of the
# tagger.  My rules are as follows:
	# #1.  Acronyms are proper nouns
	# #2.  nouns with capital leters are proper nouns
	# #3.  Words with hyphens tend to be adjectives
	# #4.  Nouns that end in 's' are plural
	# #5.  All numbers are numbers
# Also, another program has been written titled 'scorer.pl' which is intended to 
# test the tagging algorithm on the remainder of the training dataset by comparing
# the output against a key and retriveing an overall accuracy of the tagger.  This
# accuracy is outputted and a confusion matrix is constructed to display which
# tags were commonly misidentified and as what.



use Data::Dumper;

#grab command line arguments for files
$file0 = @ARGV[0];
$file1 = @ARGV[1];

#open training file
open(my $train, '<:encoding(UTF-8)', $file0)
 or die "coult not open file '$file0' $!";

#initialize array for text and hash for tag counts
my @text;
my %tags;

#read training file
while (my $row = <$train>) {
	chomp $row;
	@line = split/ +/, $row; # splits on white
	push @corpus, @line;	#add to text
}

#iterate through training file and save counts of word->tag
for my $i (0 .. $#corpus+1){
	$word = @corpus[$i];
	@wordtag = split/\//, $word;	#split word and tag
	$tizzag = @wordtag[$#wordtag];
	$tizzag =~s/(.*)\|.*/$1/;	#ignore second part of ambiguous tags
	$wizzord = join('', @wordtag[0..$#wordtag-1]);
	
	$tags{$wizzord}{$tizzag}++;
}

#open test file
open(my $test, '<:encoding(UTF-8)', $file1)
 or die "coult not open file '$file1' $!";
 
#read test file
while (my $row = <$test>) {
	chomp $row;
	@line = split/ +/, $row; # splits on white
	push @text, @line;
}

#tag each word one at a time, print word along with tag to STDOUT
for my $j (0 .. $#text+1){
	$tempval = 0;
	my $temptag = "NN";	#all unknown words are nouns by default
	$word = @text[$j];
	
	while (my ($key, $value) = each %{ $tags{$word}}){	#checks hash for entry of current word
		if ($value > $tempval){	#chooses the tag with the highest nuumber of incidents per word
			$tempval = $value;
			$temptag = $key;
		}
	}
	
	if ($temptag eq "NN"){	#special rules for tagging nouns
		if ($word=~m/^[A-Z][A-Za-z]+$/){	#2.  nouns with capital leters are proper nouns
			$temptag = "NNP";	
		}
		if ($word=~m/^[a-z]+s$/i){	#4.  Nouns that end in S are plural
			$temptag = "NNS";
		}
	}
	if ($word=~m/([A-Z]\.)+/){	#1.  Acronyms are proper nouns
		$temptag = "NNP"
	}
	
	if ($word=~m/^[0-9]+.*/){	#5.  All numbers are numbers
		$temptag = "CD";
	}
	if ($word=~m/[0-9a-z]+-[0-9a-z]+/i){	#3.  Words with hyphens tend to be adjectives
		$temptag = "JJ";
	}
		
	
	#print out words and tags
	if ($word=~m/\[|\]/){ #don't tag brackets
		$temptag = "";
		print "$word ";
	}
	else{
		print "$word/$temptag ";	#print word and tag
	}
	
}
