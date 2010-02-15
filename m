From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
	cipher
Date: Mon, 15 Feb 2010 08:10:08 +0800
Message-ID: <20100215001008.GA15437@gondor.apana.org.au>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com> <20100209073718.GA17612@gondor.apana.org.au> <20100209145705.GA20421@Chamillionaire.breakpoint.cc> <20100209204519.GC26258@gondor.apana.org.au> <20100209211238.GC21548@Chamillionaire.breakpoint.cc> <20100209214522.GA27002@gondor.apana.org.au> <20100212084228.GA1535@Chamillionaire.breakpoint.cc> <20100214204253.GA19275@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39341 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752256Ab0BOAKP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Feb 2010 19:10:15 -0500
Content-Disposition: inline
In-Reply-To: <20100214204253.GA19275@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 14, 2010 at 09:42:54PM +0100, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2010-02-12 09:42:28 [+0100]:
> 
> >+static void arc4_ivsetup(struct arc4_ctx *ctx, u8 *iv)
> > {
> >-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
> >+	if (unlikely(!ctx->new_key))
> 
> That should be likely(). Do you want me resend the whole thing? Haven't
> noticed anything else :)

How about we just remove it? It's not on a hot path anyway.

I can do this when integrating the patch so you don't have to
resend.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
