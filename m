From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Wed, 5 Mar 2008 19:16:02 +0800
Message-ID: <20080305111602.GB27552@gondor.apana.org.au>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Stefan Hellermann <stefan@the2masters.de>
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44740 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751358AbYCELQF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 06:16:05 -0500
Content-Disposition: inline
In-Reply-To: <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 02, 2008 at 11:09:10AM +0000, Sebastian Siewior wrote:
> The XTS blockmode uses a copy of the IV which is saved on the stack
> and may or may not be properly aligned. If it is not, it will break
> hardware cipher like the geode or padlock.
> This patch moves the copy of IV to the private structre which has the
> same aligment as the underlying cipher.
> 
> Tested-by: Stefan Hellermann <stefan@the2masters.de>
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Sorry but this patch isn't right.

> +struct sinfo {
> +	be128 t;
> +	struct crypto_tfm *tfm;
> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
> +};
> +
>  struct priv {
> +	/* s.t being the first member in this struct enforces proper alignment
> +	 * required by the underlying cipher without explicit knowing the it.
> +	 */
> +	struct sinfo s;

tfm objects should be reentrant so you can't store any per-op
info in the context structure.

> -	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s.t, w->iv);
> +	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s->t, w->iv);

However, the real question is why do we need this at all? The
tw argument should be using the proper entry points that do
copying for you if necessary.

OK, I see that the issue is that we're using cia_encrypt instead
of cit_encrypt_one.  So if we just change that then it should work
correctly.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
