From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 3/3] SCRIPTS: Replace four whitespaces with tabs for indentation
Date: Wed, 10 Feb 2010 01:41:10 +0100
Message-ID: <1265762471-21145-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@fifo99.com>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 scripts/checkpatch.pl |  172 ++++++++++++++++++++++++------------------------
 1 files changed, 86 insertions(+), 86 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 96ca9f0..31f872f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -398,7 +398,7 @@ sub sanitise_line {
 
 		# A \ in a string means ignore the next character.
 		if (($sanitise_quote eq "'" || $sanitise_quote eq '"') &&
-		    $c eq "\\") {
+			$c eq "\\") {
 			substr($res, $off, 2, 'XX');
 			$off++;
 			next;
@@ -1016,7 +1016,7 @@ sub possible {
 			do
 		)(?:\s|$)|
 		^(?:typedef|struct|enum)\b
-	    )}x;
+		)}x;
 	warn "CHECK<$possible> ($line)\n" if ($dbg_possible > 2);
 	if ($possible !~ $notPermitted) {
 		# Check for modifiers.
@@ -1188,7 +1188,7 @@ sub process {
 				#print "RAW<$rawlines[$ln - 1]>\n";
 				last if (!defined $rawlines[$ln - 1]);
 				if ($rawlines[$ln - 1] =~ m@(/\*|\*/)@ &&
-				    $rawlines[$ln - 1] !~ m@"[^"]*(?:/\*|\*/)[^"]*"@) {
+					$rawlines[$ln - 1] !~ m@"[^"]*(?:/\*|\*/)[^"]*"@) {
 					($edge) = $1;
 					last;
 				}
@@ -1201,7 +1201,7 @@ sub process {
 			# is the start of a diff block and this line starts
 			# ' *' then it is very likely a comment.
 			if (!defined $edge &&
-			    $rawlines[$linenr] =~ m@^.\s*(?:\*\*+| \*)(?:\s|$)@)
+				$rawlines[$linenr] =~ m@^.\s*(?:\*\*+| \*)(?:\s|$)@)
 			{
 				$in_comment = 1;
 			}
@@ -1294,7 +1294,7 @@ sub process {
 
 			$p1_prefix = $1;
 			if (!$file && $tree && $p1_prefix ne '' &&
-			    -e "$root/$p1_prefix") {
+				-e "$root/$p1_prefix") {
 				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
 			}
 
@@ -1338,7 +1338,7 @@ sub process {
 				my $file = $1;
 
 				if ($file =~ m{^(.*?)(?::\d+)+:?$} &&
-				    check_absolute_file($1, $herecurr)) {
+					check_absolute_file($1, $herecurr)) {
 					#
 				} else {
 					check_absolute_file($file, $herecurr);
@@ -1348,7 +1348,7 @@ sub process {
 
 # UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
 		if (($realfile =~ /^$/ || $line =~ /^\+/) &&
-		    $rawline !~ m/^$UTF8*$/) {
+			$rawline !~ m/^$UTF8*$/) {
 			my ($utf8_prefix) = ($rawline =~ /^($UTF8*)/);
 
 			my $blank = copy_spacing($rawline);
@@ -1376,9 +1376,9 @@ sub process {
 
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
-		    $length > 80)
+			$rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
+			$line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
+			$length > 80)
 		{
 			WARN("line over 80 characters\n" . $herecurr);
 		}
@@ -1406,7 +1406,7 @@ sub process {
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
 		if ($rawline =~ /^\+\s* \t\s*\S/ ||
-		    $rawline =~ /^\+\s*        \s*/) {
+			$rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("code indent must use tabs where possible\n" . $herevet);
 		}
@@ -1431,7 +1431,7 @@ sub process {
 
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
-		    $realline_next);
+			$realline_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
@@ -1441,8 +1441,8 @@ sub process {
 			# Find the real next line.
 			$realline_next = $line_nr_next;
 			if (defined $realline_next &&
-			    (!defined $lines[$realline_next - 1] ||
-			     substr($lines[$realline_next - 1], $off_next) =~ /^\s*$/)) {
+				(!defined $lines[$realline_next - 1] ||
+				 substr($lines[$realline_next - 1], $off_next) =~ /^\s*$/)) {
 				$realline_next++;
 			}
 
@@ -1547,8 +1547,8 @@ sub process {
 					"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
 			}
 			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
-			    $ctx =~ /\)\s*\;\s*$/ &&
-			    defined $lines[$ctx_ln - 1])
+				$ctx =~ /\)\s*\;\s*$/ &&
+				defined $lines[$ctx_ln - 1])
 			{
 				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
 				if ($nindent > $indent) {
@@ -1593,7 +1593,7 @@ sub process {
 			# Also ignore a loop construct at the end of a
 			# preprocessor statement.
 			if (($prevline =~ /^.\s*#\s*define\s/ ||
-			    $prevline =~ /\\\s*$/) && $continuation == 0) {
+				$prevline =~ /\\\s*$/) && $continuation == 0) {
 				$check = 0;
 			}
 
@@ -1613,9 +1613,9 @@ sub process {
 				#  2) preprocessor lines, and
 				#  3) labels.
 				if ($continuation ||
-				    $s =~ /^\s*?\n/ ||
-				    $s =~ /^\s*#\s*?/ ||
-				    $s =~ /^\s*$Ident\s*:/) {
+					$s =~ /^\s*?\n/ ||
+					$s =~ /^\s*#\s*?/ ||
+					$s =~ /^\s*$Ident\s*:/) {
 					$continuation = ($s =~ /^.*?\\\n/) ? 1 : 0;
 					if ($s =~ s/^.*?\n//) {
 						$cond_lines++;
@@ -1629,7 +1629,7 @@ sub process {
 			# Check if either of these lines are modified, else
 			# this is not this patch's fault.
 			if (!defined($stat_real) ||
-			    $stat !~ /^\+/ && $stat_real !~ /^\+/) {
+				$stat !~ /^\+/ && $stat_real !~ /^\+/) {
 				$check = 0;
 			}
 			if (defined($stat_real) && $cond_lines > 1) {
@@ -1639,7 +1639,7 @@ sub process {
 			#print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
 
 			if ($check && (($sindent % 8) != 0 ||
-			    ($sindent <= $indent && $s ne ''))) {
+				($sindent <= $indent && $s ne ''))) {
 				WARN("suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
 			}
 		}
@@ -1681,7 +1681,7 @@ sub process {
 
 # check for initialisation to aggregates open brace on the next line
 		if ($line =~ /^.\s*{/ &&
-		    $prevline =~ /(?:^|[^=])=\s*$/) {
+			$prevline =~ /(?:^|[^=])=\s*$/) {
 			ERROR("that open brace { must be on the previous line\n" . $hereprev);
 		}
 
@@ -1710,10 +1710,10 @@ sub process {
 # the whole statement.
 #print "APW <$lines[$realline_next - 1]>\n";
 		if (defined $realline_next &&
-		    exists $lines[$realline_next - 1] &&
-		    !defined $suppress_export{$realline_next} &&
-		    ($lines[$realline_next - 1] =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
-		     $lines[$realline_next - 1] =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+			exists $lines[$realline_next - 1] &&
+			!defined $suppress_export{$realline_next} &&
+			($lines[$realline_next - 1] =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
+			 $lines[$realline_next - 1] =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
 			my $name = $1;
 			if ($stat !~ /(?:
 				\n.}\s*$|
@@ -1722,7 +1722,7 @@ sub process {
 				^.LIST_HEAD\(\Q$name\E\)|
 				^.(?:$Storage\s+)?$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
 				\b\Q$name\E(?:\s+$Attribute)*\s*(?:;|=|\[|\()
-			    )/x) {
+				)/x) {
 #print "FOO A<$lines[$realline_next - 1]> stat<$stat> name<$name>\n";
 				$suppress_export{$realline_next} = 2;
 			} else {
@@ -1730,14 +1730,14 @@ sub process {
 			}
 		}
 		if (!defined $suppress_export{$linenr} &&
-		    $prevline =~ /^.\s*$/ &&
-		    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
-		     $line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+			$prevline =~ /^.\s*$/ &&
+			($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
+			 $line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
 #print "FOO B <$lines[$linenr - 1]>\n";
 			$suppress_export{$linenr} = 2;
 		}
 		if (defined $suppress_export{$linenr} &&
-		    $suppress_export{$linenr} == 2) {
+			$suppress_export{$linenr} == 2) {
 			WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 		}
 
@@ -1755,10 +1755,10 @@ sub process {
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
-		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
-		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
-		    $line !~ /\b$typeTypedefs\b/ &&
-		    $line !~ /\b__bitwise(?:__|)\b/) {
+			$line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
+			$line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
+			$line !~ /\b$typeTypedefs\b/ &&
+			$line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("do not add new typedefs\n" . $herecurr);
 		}
 
@@ -1835,13 +1835,13 @@ sub process {
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
-		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
+			!($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
-		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
+			$prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
 			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
 		}
 
@@ -1852,8 +1852,8 @@ sub process {
 		while ($line =~ /(.*?\s)\[/g) {
 			my ($where, $prefix) = ($-[1], $1);
 			if ($prefix !~ /$Type\s+$/ &&
-			    ($where != 0 || $prefix !~ /^.\s+$/) &&
-			    $prefix !~ /{\s+$/) {
+				($where != 0 || $prefix !~ /^.\s+$/) &&
+				$prefix !~ /{\s+$/) {
 				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
 			}
 		}
@@ -1950,7 +1950,7 @@ sub process {
 
 				# Ignore operators passed as parameters.
 				if ($op_type ne 'V' &&
-				    $ca =~ /\s$/ && $cc =~ /^\s*,/) {
+					$ca =~ /\s$/ && $cc =~ /^\s*,/) {
 
 #				# Ignore comments
 #				} elsif ($op =~ /^$;+$/) {
@@ -1958,7 +1958,7 @@ sub process {
 				# ; should have either the end of line or a space or \ after it
 				} elsif ($op eq ';') {
 					if ($ctx !~ /.x[WEBC]/ &&
-					    $cc !~ /^\\/ && $cc !~ /^;/) {
+						$cc !~ /^\\/ && $cc !~ /^;/) {
 						ERROR("space required after that '$op' $at\n" . $hereptr);
 					}
 
@@ -2005,7 +2005,7 @@ sub process {
 						ERROR("space required one side of that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /Wx[BE]/ ||
-					    ($ctx =~ /Wx./ && $cc =~ /^;/)) {
+						($ctx =~ /Wx./ && $cc =~ /^;/)) {
 						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /ExW/) {
@@ -2038,17 +2038,17 @@ sub process {
 
 					# Ignore email addresses <foo@bar>
 					if (($op eq '<' &&
-					     $cc =~ /^\S+\@\S+>/) ||
-					    ($op eq '>' &&
-					     $ca =~ /<\S+\@\S+$/))
+						 $cc =~ /^\S+\@\S+>/) ||
+						($op eq '>' &&
+						 $ca =~ /<\S+\@\S+$/))
 					{
-					    	$ok = 1;
+							$ok = 1;
 					}
 
 					# Ignore ?:
 					if (($opv eq ':O' && $ca =~ /\?$/) ||
-					    ($op eq '?' && $cc =~ /^:/)) {
-					    	$ok = 1;
+						($op eq '?' && $cc =~ /^:/)) {
+							$ok = 1;
 					}
 
 					if ($ok == 0) {
@@ -2067,7 +2067,7 @@ sub process {
 ## # check for multiple declarations, allowing for a function declaration
 ## # continuation.
 ## 		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
-## 		    $line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
+## 			$line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
 ##
 ## 			# Remove any bracketed sections to ensure we do not
 ## 			# falsly report the parameters of functions.
@@ -2081,7 +2081,7 @@ sub process {
 
 #need space before brace following if, while, etc
 		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
-		    $line =~ /do{/) {
+			$line =~ /do{/) {
 			ERROR("space required before the open brace '{'\n" . $herecurr);
 		}
 
@@ -2101,12 +2101,12 @@ sub process {
 
 # check spacing on parentheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
-		    $line !~ /for\s*\(\s+;/) {
+			$line !~ /for\s*\(\s+;/) {
 			ERROR("space prohibited after that open parenthesis '('\n" . $herecurr);
 		}
 		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
-		    $line !~ /for\s*\(.*;\s+\)/ &&
-		    $line !~ /:\s+\)/) {
+			$line !~ /for\s*\(.*;\s+\)/ &&
+			$line !~ /:\s+\)/) {
 			ERROR("space prohibited before that close parenthesis ')'\n" . $herecurr);
 		}
 
@@ -2124,10 +2124,10 @@ sub process {
 			# Flatten any parentheses
 			$value =~ s/\)\(/\) \(/g;
 			while ($value =~ s/\[[^\{\}]*\]/1/ ||
-			       $value !~ /(?:$Ident|-?$Constant)\s*
-					     $Compare\s*
-					     (?:$Ident|-?$Constant)/x &&
-			       $value =~ s/\([^\(\)]*\)/1/) {
+				   $value !~ /(?:$Ident|-?$Constant)\s*
+						 $Compare\s*
+						 (?:$Ident|-?$Constant)/x &&
+				   $value =~ s/\([^\(\)]*\)/1/) {
 			}
 
 			if ($value =~ /^(?:$Ident|-?$Constant)$/) {
@@ -2164,7 +2164,7 @@ sub process {
 			}
 		}
 		if (!defined $suppress_whiletrailers{$linenr} &&
-		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
+			$line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
@@ -2177,7 +2177,7 @@ sub process {
 			$s =~ s/\n.*//g;
 			$s =~ s/$;//g; 	# Remove any comments
 			if (length($c) && $s !~ /^\s*{?\s*\\*\s*$/ &&
-			    $c !~ /}\s*while\s*/)
+				$c !~ /}\s*while\s*/)
 			{
 				# Find out how long the conditional actually is.
 				my @newlines = ($c =~ /\n/gs);
@@ -2222,10 +2222,10 @@ sub process {
 		}
 # case and default should not have general statements after them
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
-		    $line !~ /\G(?:
+			$line !~ /\G(?:
 			(?:\s*$;*)(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
 			\s*return\s+
-		    )/xg)
+			)/xg)
 		{
 			ERROR("trailing statements must be on next line\n" . $herecurr);
 		}
@@ -2253,9 +2253,9 @@ sub process {
 
 #studly caps, commented out until figure out how to distinguish between use of existing and adding new
 #		if (($line=~/[\w_][a-z\d]+[A-Z]/) and !($line=~/print/)) {
-#		    print "No studly caps, use _\n";
-#		    print "$herecurr";
-#		    $clean = 0;
+#			print "No studly caps, use _\n";
+#			print "$herecurr";
+#			$clean = 0;
 #		}
 
 #no spaces allowed after \ in define
@@ -2268,8 +2268,8 @@ sub process {
 			my $file = "$1.h";
 			my $checkfile = "include/linux/$file";
 			if (-f "$root/$checkfile" &&
-			    $realfile ne $checkfile &&
-			    $1 ne 'irq')
+				$realfile ne $checkfile &&
+				$1 ne 'irq')
 			{
 				if ($realfile =~ m{^arch/}) {
 					CHK("Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
@@ -2283,7 +2283,7 @@ sub process {
 # first statement and ensure its the whole macro if its not enclosed
 # in a known good container
 		if ($realfile !~ m@/vmlinux.lds.h$@ &&
-		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
+			$line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
 			my $ln = $linenr;
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
@@ -2336,8 +2336,8 @@ sub process {
 
 			# Flatten any parentheses and braces
 			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
-			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
-			       $dstat =~ s/\[[^\{\}]*\]/1/)
+				   $dstat =~ s/\{[^\{\}]*\}/1/ ||
+				   $dstat =~ s/\[[^\{\}]*\]/1/)
 			{
 			}
 
@@ -2354,17 +2354,17 @@ sub process {
 			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
-				    $dstat !~ /$exceptions/)
+					$dstat !~ /$exceptions/)
 				{
 					ERROR("Macros with multiple statements must be enclosed in a do - while loop\n" . "$here\n$ctx\n");
 				}
 
 			} elsif ($ctx !~ /;/) {
 				if ($dstat ne '' &&
-				    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&
-				    $dstat !~ /$exceptions/ &&
-				    $dstat !~ /^\.$Ident\s*=/ &&
-				    $dstat =~ /$Operators/)
+					$dstat !~ /^(?:$Ident|-?$Constant)$/ &&
+					$dstat !~ /$exceptions/ &&
+					$dstat !~ /^\.$Ident\s*=/ &&
+					$dstat =~ /$Operators/)
 				{
 					ERROR("Macros with complex values must be enclosed in parenthesis\n" . "$here\n$ctx\n");
 				}
@@ -2543,7 +2543,7 @@ sub process {
 
 # check for spinlock_t definitions without a comment.
 		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/ ||
-		    $line =~ /^.\s*(DEFINE_MUTEX)\s*\(/) {
+			$line =~ /^.\s*(DEFINE_MUTEX)\s*\(/) {
 			my $which = $1;
 			if (!ctx_has_comment($first_line, $linenr)) {
 				CHK("$1 definition without comment\n" . $herecurr);
@@ -2563,7 +2563,7 @@ sub process {
 # check the location of the inline attribute, that it is between
 # storage class and type.
 		if ($line =~ /\b$Type\s+$Inline\b/ ||
-		    $line =~ /\b$Inline\s+$Storage\b/) {
+			$line =~ /\b$Inline\s+$Storage\b/) {
 			ERROR("inline keyword must sit between storage class and type\n" . $herecurr);
 		}
 
@@ -2574,7 +2574,7 @@ sub process {
 
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
-		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
+			$stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
 		{
 			my $function_name = $1;
 			my $paren_space = $2;
@@ -2584,7 +2584,7 @@ sub process {
 				substr($s, 0, length($cond), '');
 			}
 			if ($s =~ /^\s*;/ &&
-			    $function_name ne 'uninitialized_var')
+				$function_name ne 'uninitialized_var')
 			{
 				WARN("externs should be avoided in .c files\n" .  $herecurr);
 			}
@@ -2594,7 +2594,7 @@ sub process {
 			}
 
 		} elsif ($realfile =~ /\.c$/ && defined $stat &&
-		    $stat =~ /^.\s*extern\s+/)
+			$stat =~ /^.\s*extern\s+/)
 		{
 			WARN("externs should be avoided in .c files\n" .  $herecurr);
 		}
@@ -2636,7 +2636,7 @@ sub process {
 		}
 # check for struct file_operations, ensure they are const.
 		if ($line !~ /\bconst\b/ &&
-		    $line =~ /\bstruct\s+(file_operations|seq_operations)\b/) {
+			$line =~ /\bstruct\s+(file_operations|seq_operations)\b/) {
 			WARN("struct $1 should normally be const\n" .
 				$herecurr);
 		}
@@ -2644,11 +2644,11 @@ sub process {
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
 		if ($line =~ /\bNR_CPUS\b/ &&
-		    $line !~ /^.\s*\s*#\s*if\b.*\bNR_CPUS\b/ &&
-		    $line !~ /^.\s*\s*#\s*define\b.*\bNR_CPUS\b/ &&
-		    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/ &&
-		    $line !~ /\[[^\]]*\.\.\.[^\]]*NR_CPUS[^\]]*\]/ &&
-		    $line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/)
+			$line !~ /^.\s*\s*#\s*if\b.*\bNR_CPUS\b/ &&
+			$line !~ /^.\s*\s*#\s*define\b.*\bNR_CPUS\b/ &&
+			$line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/ &&
+			$line !~ /\[[^\]]*\.\.\.[^\]]*NR_CPUS[^\]]*\]/ &&
+			$line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/)
 		{
 			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
-- 
1.6.6.1
