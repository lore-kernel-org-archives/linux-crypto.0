From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Sun, 20 Jul 2014 13:41:04 -0400
Message-ID: <20140720174104.GH5017@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <87tx6cvt2p.fsf@igel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Andreas Schwab <schwab@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46186 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaGTRlW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Jul 2014 13:41:22 -0400
Content-Disposition: inline
In-Reply-To: <87tx6cvt2p.fsf@igel.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 20, 2014 at 07:27:42PM +0200, Andreas Schwab wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > ERRORS
> > 	EINVAL		The buflen value was invalid.
> 
> Also on unknown flags?  Without that it would be impossible to probe for
> implemented flags.

We removed the cap on the buflen size (although if someone gives
something insanely large, it can get capped), so EINVAL will only
happen for unknown flags.  I'll fix the suggested man page.

	       	   	   	   	    - Ted

P.S. The reason why OpenBSD had a very strong opinion about returning
EIO for buflen greater than 256 bytes was they really wanted to pound
it into application writers than if they were trying to fetch more
than 256 bytes, they were probably Doing Something Wrong, and they
decided EIO was less subtle that EINVAL....
