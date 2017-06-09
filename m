From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 4.12
Date: Fri, 9 Jun 2017 10:52:33 +0800
Message-ID: <20170609025233.GA8630@gondor.apana.org.au>
References: <20170304074119.GA3041@gondor.apana.org.au>
 <20170523034211.GA12748@gondor.apana.org.au>
 <20170608092320.GA6478@gondor.apana.org.au>
 <20170608.100502.1861332545609152555.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170608.100502.1861332545609152555.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 08, 2017 at 10:05:02AM -0400, David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Thu, 8 Jun 2017 17:23:21 +0800
> 
> > This push fixes a couple of places in the crypto code that were
> > doing interruptible sleeps dangerously.  They have been converted
> > to use non-interruptible sleeps.  This push also fixes a bug in
> > asymmetric_keys where it would trigger a use-after-free if a
> > request returned EBUSY due to a full device queue.
> 
> Where is the gcc shash miscompile workaround?

I'll push it to Linus in a couple of days.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
