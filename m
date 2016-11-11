From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/16] crypto: skcipher - Add skcipher walk interface
Date: Fri, 11 Nov 2016 19:19:59 +0800
Message-ID: <20161111111959.GA26599@gondor.apana.org.au>
References: <20161101231648.GA15967@gondor.apana.org.au>
 <E1c1iKc-0004Av-CW@gondolin.me.apana.org.au>
 <20161102205420.GA17645@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34643 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755487AbcKKLUG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 06:20:06 -0500
Content-Disposition: inline
In-Reply-To: <20161102205420.GA17645@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 02, 2016 at 01:54:20PM -0700, Eric Biggers wrote:
>
> I think the case where skcipher_copy_iv() fails may be handled incorrectly.
> Wouldn't it need to set walk.nbytes to 0 so as to not confuse callers which
> expect that behavior?  Or maybe it should be calling skcipher_walk_done().

Good catch.  I'll fix and repost.

> Setting walk->in.sg and walk->out.sg is redundant with the scatterwalk_start()
> calls.

Will remove.

> This gets called with uninitialized 'walk.flags'.  This was somewhat of a
> theoretical problem with the old blkcipher_walk code but it looks like now it
> will interact badly with the new SKCIPHER_WALK_SLEEP flag.  As far as I can see,
> whether the flag will end up set or not can depend on the uninitialized value.
> It would be nice if this problem could be avoided entirely be setting flags=0.

Right.  I'll fix this as well.

> I'm also wondering about the choice to not look at 'atomic' until after the call
> to skcipher_walk_skcipher().  Wouldn't this mean that the choice of 'atomic'
> would not be respected in e.g. the kmalloc() in skcipher_copy_iv()?

The atomic flag is meant to be used in cases such as aesni where
you need to do kernel_fpu_begin after the call to start the walk.
IOW sleeping is fine at the start but not on subsequent walk calls.

> I don't see any users of the "async" walking being introduced; are some planned?

skcipher_walk is meant to unite blkcipher_walk and ablkcipher_walk.
The latter will use the async case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
