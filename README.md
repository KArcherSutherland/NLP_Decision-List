# NLP_POS-Tagging
Decision List Program for Natural Language Processing

tagger.pl

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
