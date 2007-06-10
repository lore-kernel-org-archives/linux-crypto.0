From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Sun, 10 Jun 2007 12:33:45 -0500
Message-ID: <20070610173345.GV11115@waste.org>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <20070609201159.GC11166@waste.org> <466B0C3F.3040300@garzik.org> <466B46D5.1020004@cs.cmu.edu> <20070610135956.GS11115@waste.org> <466C2B17.8000708@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([66.93.16.53]:54972 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbXFJReT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jun 2007 13:34:19 -0400
Content-Disposition: inline
In-Reply-To: <466C2B17.8000708@cs.cmu.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jun 10, 2007 at 12:47:19PM -0400, Benjamin Gilbert wrote:
> Matt Mackall wrote:
> >On Sat, Jun 09, 2007 at 08:33:25PM -0400, Benjamin Gilbert wrote:
> >>It's not just the loop unrolling; it's the register allocation and 
> >>spilling.  For comparison, I built SHATransform() from the 
> >>drivers/char/random.c in 2.6.11, using gcc 3.3.5 with -O2 and 
> >>SHA_CODE_SIZE == 3 (i.e., fully unrolled); I'm guessing this is pretty 
> >>close to what you tested back then.  The resulting code is 49% MOV 
> >>instructions, and 80% of *those* involve memory.  gcc4 is somewhat 
> >>better, but it still spills a whole lot, both for the 2.6.11 unrolled 
> >>code and for the current lib/sha1.c.
> >
> >Wait, your benchmark is comparing against the unrolled code?
> 
> No, it's comparing the current lib/sha1.c to the optimized code in the 
> patch.  I was just pointing out that the unrolled code you were likely 
> testing against, back then, may not have been very good.  (Though I 
> assumed that you were talking about the unrolled code in random.c, not 
> the code in CryptoAPI, so that might change the numbers some.  It 
> appears from the post you linked below that the unrolled CryptoAPI code 
> still beat the rolled version?)

That predates lib/sha1.c by a while.

> >How big is the -code- footprint?
> 
> About 3700 bytes for the 32-bit version of sha_transform().

lib/sha1.c's footprint is... 621 bytes today. Huh. That's up from 466
bytes when it was introduced and no one's touched it:

http://search.luky.org/ML/linux-kernel.2005/msg06648.html

Stupid compilers.

But anyway. Cache footprint matters. The two big users of SHA1 in the
kernel are /dev/random and IPSec, both of which typically operate on
small chunks of data.

-- 
Mathematics is the supreme nostalgia of our time.
