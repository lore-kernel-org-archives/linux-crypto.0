From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
	cipher
Date: Tue, 23 Feb 2010 08:15:20 +0800
Message-ID: <20100223001520.GB9118@gondor.apana.org.au>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com> <20100209073718.GA17612@gondor.apana.org.au> <20100209145705.GA20421@Chamillionaire.breakpoint.cc> <20100209204519.GC26258@gondor.apana.org.au> <20100209211238.GC21548@Chamillionaire.breakpoint.cc> <20100209214522.GA27002@gondor.apana.org.au> <20100212084228.GA1535@Chamillionaire.breakpoint.cc> <20100216125125.GA390@gondor.apana.org.au> <Pine.LNX.4.64.1002221400090.31819@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	mbroz@redhat.com, dm-devel@redhat.com, agk@redhat.com,
	linux-crypto@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54115 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750766Ab0BWAP2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2010 19:15:28 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002221400090.31819@hs20-bc2-1.build.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 22, 2010 at 02:40:49PM -0500, Mikulas Patocka wrote:
>
> > So what we could do is simply add a new blkcipher arc4, alongside
> > the existing cipher arc4.  Then we can convert the existing users
> > across, and finally remove the old arc4.
> 
> arc4 can't be used as a block cipher --- see this paper 
> http://www.wisdom.weizmann.ac.il/~itsik/RC4/Papers/Rc4_ksa.ps , it says 
> that initialization vectors on RC4 are unreliable, if you use (unknown key 
> concatenated with known IV) or (known IV concatenated with unknown key) as 
> a RC4 key, the RC4 state can be exposed and the cipher is broken.

What we call a blkcipher is not really a block cipher.  In fact,
what we call "cipher" is really a block cipher.  So we're actually
changing arc4 so that it doesn't get used as a block cipher, i.e.,
you will no longer be able to say "cbc(arc4)" or some such.

I know it's confusing and perhaps one day we will rename blkcipher
to skcipher and cipher to blkcipher.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
