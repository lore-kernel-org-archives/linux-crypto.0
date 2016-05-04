From: tytso@mit.edu
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 17:49:01 +0000
Message-ID: <20160504174901.GC3901@thunk.org>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Jeffrey Walton <noloader@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46442 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbcEDRtR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 13:49:17 -0400
Content-Disposition: inline
In-Reply-To: <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 10:40:20AM -0400, Jeffrey Walton wrote:
> > +static inline u32 rotl32(u32 v, u8 n)
> > +{
> > +       return (v << n) | (v >> (sizeof(v) * 8 - n));
> > +}
> 
> That's undefined behavior when n=0.

Sure, but it's never called with n = 0; I've double checked and the
compiler seems to do the right thing with the above pattern as well.

Hmm, it looks like there is a "standard" version rotate left and right
defined in include/linux/bitops.h.  So I suspect it would make sense
to use rol32 as defined in bitops.h --- and this is probably something
that we should do for the rest of crypto/*.c, where people seem to be
defininig their own version of something like rotl32 (I copied the
contents of crypto/chacha20_generic.c to lib/chacha20, so this pattern
of defining one's own version of rol32 isn't new).

> I think the portable way to do a rotate that avoids UB is the
> following. GCC, Clang and ICC recognize the pattern, and emit a rotate
> instruction.
> 
>     static const unsigned int MASK=31;
>     return (v<<n)|(v>>(-n&MASK));
> 
> You should also avoid the following because its not constant time due
> to the branch:
> 
>     return n == 0 ? v : (v << n) | (v >> (sizeof(v) * 8 - n));
> 

Where is this coming from?  I don't see this construct in the patch.

      	      	     	      	    - Ted
