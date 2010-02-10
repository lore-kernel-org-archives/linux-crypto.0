From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/3] SCRIPTS: s/should/must/ for all ERRORs
Date: Wed, 10 Feb 2010 08:49:08 -0800
Message-ID: <20100210084908.ad315b9b.rdunlap@xenotime.net>
References: <1265762465-21114-1-git-send-email-richih.mailinglist@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@fifo99.com>,
	linux-kernel@vger.kernel.org
To: Richard Hartmann <richih.mailinglist@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:57591 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754943Ab0BJQtK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Feb 2010 11:49:10 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2010 08:49:08 -0800
In-Reply-To: <1265762465-21114-1-git-send-email-richih.mailinglist@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 10 Feb 2010 01:41:03 +0100 Richard Hartmann wrote:

> 
> Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
> ---

Well, I will gladly disagree.  checkpatch is an advisory tool.
It has no such final authority to enforce /must/.

/must/ would OK on syntax errors that must be fixed before they will compile.


>  scripts/checkpatch.pl |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d5405aa..96ca9f0 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1355,7 +1355,7 @@ sub process {
>  			my $ptr = substr($blank, 0, length($utf8_prefix)) . "^";
>  			my $hereptr = "$hereline$ptr\n";
>  
> -			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
> +			ERROR("Invalid UTF-8, patch and commit message must be encoded in UTF-8\n" . $hereptr);
>  		}
>  
>  # ignore non-hunk lines and lines being removed
> @@ -1408,7 +1408,7 @@ sub process {
>  		if ($rawline =~ /^\+\s* \t\s*\S/ ||
>  		    $rawline =~ /^\+\s*        \s*/) {
>  			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
> -			ERROR("code indent should use tabs where possible\n" . $herevet);
> +			ERROR("code indent must use tabs where possible\n" . $herevet);
>  		}
>  
>  # check we are in a valid C source file if not then ignore this hunk
> @@ -1515,7 +1515,7 @@ sub process {
>  				}
>  			}
>  			if ($err ne '') {
> -				ERROR("switch and case should be at the same indent\n$hereline$err");
> +				ERROR("switch and case must be at the same indent\n$hereline$err");
>  			}
>  		}
>  
> @@ -1543,7 +1543,7 @@ sub process {
>  			#print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
>  
>  			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
> -				ERROR("that open brace { should be on the previous line\n" .
> +				ERROR("that open brace { must be on the previous line\n" .
>  					"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
>  			}
>  			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
> @@ -1682,7 +1682,7 @@ sub process {
>  # check for initialisation to aggregates open brace on the next line
>  		if ($line =~ /^.\s*{/ &&
>  		    $prevline =~ /(?:^|[^=])=\s*$/) {
> -			ERROR("that open brace { should be on the previous line\n" . $hereprev);
> +			ERROR("that open brace { must be on the previous line\n" . $hereprev);
>  		}
>  
>  #
> @@ -1777,7 +1777,7 @@ sub process {
>  
>  			#print "from<$from> to<$to>\n";
>  			if ($from ne $to) {
> -				ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
> +				ERROR("\"(foo$from)\" must be \"(foo$to)\"\n" .  $herecurr);
>  			}
>  		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
>  			my ($from, $to, $ident) = ($1, $1, $2);
> @@ -1794,7 +1794,7 @@ sub process {
>  
>  			#print "from<$from> to<$to> ident<$ident>\n";
>  			if ($from ne $to && $ident !~ /^$Modifier$/) {
> -				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
> +				ERROR("\"foo${from}bar\" must be \"foo${to}bar\"\n" .  $herecurr);
>  			}
>  		}
>  
> @@ -2188,7 +2188,7 @@ sub process {
>  					$stat_real = "[...]\n$stat_real";
>  				}
>  
> -				ERROR("trailing statements should be on next line\n" . $herecurr . $stat_real);
> +				ERROR("trailing statements must be on next line\n" . $herecurr . $stat_real);
>  			}
>  		}
>  
> @@ -2212,12 +2212,12 @@ sub process {
>  			my $s = $1;
>  			$s =~ s/$;//g; 	# Remove any comments
>  			if ($s !~ /^\s*(?:\sif|(?:{|)\s*\\?\s*$)/) {
> -				ERROR("trailing statements should be on next line\n" . $herecurr);
> +				ERROR("trailing statements must be on next line\n" . $herecurr);
>  			}
>  		}
>  # if should not continue a brace
>  		if ($line =~ /}\s*if\b/) {
> -			ERROR("trailing statements should be on next line\n" .
> +			ERROR("trailing statements must be on next line\n" .
>  				$herecurr);
>  		}
>  # case and default should not have general statements after them
> @@ -2227,14 +2227,14 @@ sub process {
>  			\s*return\s+
>  		    )/xg)
>  		{
> -			ERROR("trailing statements should be on next line\n" . $herecurr);
> +			ERROR("trailing statements must be on next line\n" . $herecurr);
>  		}
>  
>  		# Check for }<nl>else {, these must be at the same
>  		# indent level to be relevant to each other.
>  		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
>  						$previndent == $indent) {
> -			ERROR("else should follow close brace '}'\n" . $hereprev);
> +			ERROR("else must follow close brace '}'\n" . $hereprev);
>  		}
>  
>  		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ and
> @@ -2247,7 +2247,7 @@ sub process {
>  			$s =~ s/\n.*//g;
>  
>  			if ($s =~ /^\s*;/) {
> -				ERROR("while should follow close brace '}'\n" . $hereprev);
> +				ERROR("while must follow close brace '}'\n" . $hereprev);
>  			}
>  		}
>  
> @@ -2356,7 +2356,7 @@ sub process {
>  				if ($rest !~ /while\s*\(/ &&
>  				    $dstat !~ /$exceptions/)
>  				{
> -					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
> +					ERROR("Macros with multiple statements must be enclosed in a do - while loop\n" . "$here\n$ctx\n");
>  				}
>  
>  			} elsif ($ctx !~ /;/) {
> @@ -2366,7 +2366,7 @@ sub process {
>  				    $dstat !~ /^\.$Ident\s*=/ &&
>  				    $dstat =~ /$Operators/)
>  				{
> -					ERROR("Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
> +					ERROR("Macros with complex values must be enclosed in parenthesis\n" . "$here\n$ctx\n");
>  				}
>  			}
>  		}
> @@ -2564,7 +2564,7 @@ sub process {
>  # storage class and type.
>  		if ($line =~ /\b$Type\s+$Inline\b/ ||
>  		    $line =~ /\b$Inline\s+$Storage\b/) {
> -			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
> +			ERROR("inline keyword must sit between storage class and type\n" . $herecurr);
>  		}
>  
>  # Check for __inline__ and __inline, prefer inline
> -- 

---
~Randy
