#!/usr/bin/env perl
use warnings;
use strict;

use Cwd qw(realpath);

print "OS: $^O\n";

sub hpath($) {
    # Transform tilde into absolutely home directory path.

    $_ = shift;
    return s/~/$ENV{HOME}/r;
}

# Sanity check.
my $tb = hpath("~/toolbag");
die "Not found: $tb" unless (-d $tb);

sub tbpath($) {
    # Transform a toolbag relative path into an absolute path.

    return $tb . "/" . $_[0];
}

sub expect_symlink($$) {
    # Warm if [home path] does not exist, or does not resolve to
    # [toolbag path].

    my $p = shift or die;
    $p = hpath($p);
    my $tbp = shift or die;
    $tbp = tbpath($tbp);
    if (! -f $p) {
	warn "Expected symlink $p but path does not exist\n";
	return;
    }
    my $rp = realpath($p);
    return if ($rp eq $tbp);
    warn "Expected symlink $p -> $tbp\n";
    if ($rp eq $p) { warn "  Found $p\n"; }
    else { warn "  Found $p -> $rp\n"; }
}

sub check_exe_on_path() {
    # Check any of the exectuable names specified is present in the
    # PATH and warn if multiple instances are present.

    my @path = split(":", $ENV{PATH});
    for my $exe (@_) {
	my @possible = map { $_ . "/" . $exe } @path;
	my @actual = grep { -f $_ } @possible;
	my $count = scalar(@actual);
	if ($count > 1) {
	    warn "Multiple instances in path:\n";
	    warn "  $_\n" for (@actual);
	}
	elsif ($count == 0) {
	    warn "$exe not in path\n";
	}
    }
}


sub check_dir_in_path($) {

    my $p = hpath($_[0]);
    unless (grep{ $p eq $_} split(':', $ENV{PATH})) {
	warn "$_[0] not in path\n";
    }
}


&check_dir_in_path("~/bin");


if ($ENV{SHELL} =~ /zsh$/) {
    &expect_symlink("~/.zshrc", "zsh/zshrc");
    &expect_symlink("~/.zshenv", "zsh/zshenv");
}


if (-d &hpath("~/.emacs.d")) {
    warn "Found ~.emacs.d and ~/.emacs\n" if (-f &hpath("~/.emacs"));
    &expect_symlink("~/.emacs.d/init.el", "emacs/myinit.el");
    &check_exe_on_path("emacsclient");
}

&check_exe_on_path("racket", "raco");
