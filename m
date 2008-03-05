From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment v2
Date: Wed, 05 Mar 2008 23:48:01 +0100
Message-ID: <47CF2321.6020100@the2masters.de>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc> <20080305115203.GA28021@gondor.apana.org.au> <20080305120153.GA18425@Chamillionaire.breakpoint.cc> <47CEA7F5.2080700@the2masters.de> <20080305163753.GA20787@Chamillionaire.breakpoint.cc> <20080305221746.GA32072@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:55469 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbYCEWsy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 17:48:54 -0500
In-Reply-To: <20080305221746.GA32072@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> The XTS blockmode uses a copy of the IV which is saved on the stack
> and may or may not be properly aligned. If it is not, it will break
> hardware cipher like the geode or padlock.
> This patch encrypts the IV in place so we don't have to worry about
> alignment.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
> Herbert, I tried the small patch thing :)
> It passed tcrypt on my geode, dunno about dm-crypt & friends.
> Stefan if you could test it with dm-crypt than we have a small fix :)

Yes, this passwd my tests, too! Nice :)

Tested-by: Stefan Hellermann <stefan@the2masters.de


PS: The segfaults I got with 2.6.25-rc[1-3] are gone ... LRW is stable here.

>  crypto/xts.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/crypto/xts.c b/crypto/xts.c
> index 8eb08bf..d87b0f3 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -77,16 +77,16 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
>  }
>  
>  struct sinfo {
> -	be128 t;
> +	be128 *t;
>  	struct crypto_tfm *tfm;
>  	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
>  };
>  
>  static inline void xts_round(struct sinfo *s, void *dst, const void *src)
>  {
> -	be128_xor(dst, &s->t, src);		/* PP <- T xor P */
> +	be128_xor(dst, s->t, src);		/* PP <- T xor P */
>  	s->fn(s->tfm, dst, dst);		/* CC <- E(Key1,PP) */
> -	be128_xor(dst, dst, &s->t);		/* C <- T xor CC */
> +	be128_xor(dst, dst, s->t);		/* C <- T xor CC */
>  }
>  
>  static int crypt(struct blkcipher_desc *d,
> @@ -101,7 +101,6 @@ static int crypt(struct blkcipher_desc *d,
>  		.tfm = crypto_cipher_tfm(ctx->child),
>  		.fn = fn
>  	};
> -	be128 *iv;
>  	u8 *wsrc;
>  	u8 *wdst;
>  
> @@ -109,20 +108,20 @@ static int crypt(struct blkcipher_desc *d,
>  	if (!w->nbytes)
>  		return err;
>  
> +	s.t = (be128 *)w->iv;
>  	avail = w->nbytes;
>  
>  	wsrc = w->src.virt.addr;
>  	wdst = w->dst.virt.addr;
>  
>  	/* calculate first value of T */
> -	iv = (be128 *)w->iv;
> -	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s.t, w->iv);
> +	tw(crypto_cipher_tfm(ctx->tweak), w->iv, w->iv);
>  
>  	goto first;
>  
>  	for (;;) {
>  		do {
> -			gf128mul_x_ble(&s.t, &s.t);
> +			gf128mul_x_ble(s.t, s.t);
>  
>  first:
>  			xts_round(&s, wdst, wsrc);
