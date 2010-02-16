From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
	cipher
Date: Tue, 16 Feb 2010 20:51:25 +0800
Message-ID: <20100216125125.GA390@gondor.apana.org.au>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com> <20100209073718.GA17612@gondor.apana.org.au> <20100209145705.GA20421@Chamillionaire.breakpoint.cc> <20100209204519.GC26258@gondor.apana.org.au> <20100209211238.GC21548@Chamillionaire.breakpoint.cc> <20100209214522.GA27002@gondor.apana.org.au> <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45929 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755782Ab0BPMve (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 07:51:34 -0500
Content-Disposition: inline
In-Reply-To: <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 12, 2010 at 09:42:28AM +0100, Sebastian Andrzej Siewior wrote:
>
> -static void arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void arc4_ivsetup(struct arc4_ctx *ctx, u8 *iv)
>  {
> -	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
> +	if (unlikely(!ctx->new_key))
> +		return;
> +	memcpy(iv, &ctx->iv, sizeof(ctx->iv));
> +	ctx->new_key = 0;

Sorry, but this doesn't work.

A ctx is supposed to be reentrant.  That is, while one thread
is working away with a given ctx I should be able to use that
same ctx in a different thread without them clobbering each
other.

So that means (in general) you must not modify the ctx in any
function other than setkey.

This also brings up the bigger question of how we transition to
this new arc4.  I don't think we need to maintain exactly the
same behaviour as the existing ecb(arc4).

So what we could do is simply add a new blkcipher arc4, alongside
the existing cipher arc4.  Then we can convert the existing users
across, and finally remove the old arc4.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
