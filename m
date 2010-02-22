From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
	cipher
Date: Mon, 22 Feb 2010 08:52:17 +0800
Message-ID: <20100222005217.GA24920@gondor.apana.org.au>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com> <20100209073718.GA17612@gondor.apana.org.au> <20100209145705.GA20421@Chamillionaire.breakpoint.cc> <20100209204519.GC26258@gondor.apana.org.au> <20100209211238.GC21548@Chamillionaire.breakpoint.cc> <20100209214522.GA27002@gondor.apana.org.au> <20100212084228.GA1535@Chamillionaire.breakpoint.cc> <20100216125125.GA390@gondor.apana.org.au> <20100221200140.GC11951@Chamillionaire.breakpoint.cc> <20100222004547.GA24812@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55937 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753596Ab0BVAwW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Feb 2010 19:52:22 -0500
Content-Disposition: inline
In-Reply-To: <20100222004547.GA24812@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 22, 2010 at 08:45:47AM +0800, Herbert Xu wrote:
> 
> How about this? You extend the IV by one more byte, and use that
> byte as a boolean flag to indicate whether the IV is valid.  All
> users that cannot supply their own IVs can then set the IV to zero.
> 
> When you see the zero flag in the IV, you reinitialise the IV per
> the key.

In fact for arc4 we could just drop the key altogether since it
plays no part after setting the initial state.

> > salsa also does not stick to plan here. ctx->input[6-9] is initialized
> > in encrypt() path. So two threads sharing a ctx are going to clobber
> > their state.
> 
> Salsa should also be fixed.

For Salsa on the other hand the key is rather useful since all
we need is a two-byte IV that's just a sequence number.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
