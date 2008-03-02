From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Sun, 02 Mar 2008 13:04:37 +0100
Message-ID: <47CA97D5.8090804@the2masters.de>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <47C15AEC.5040705@the2masters.de> <20080224125117.GA17076@Chamillionaire.breakpoint.cc> <47C1CE67.70804@the2masters.de> <20080302112004.GA16659@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:34032 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYCBMEx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2008 07:04:53 -0500
In-Reply-To: <20080302112004.GA16659@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> The XTS blockmode uses a copy of the IV which is saved on the stack
> and may or may not be properly aligned. If it is not, it will break
> hardware cipher like the geode or padlock.
> This patch moves the copy of IV to the private structre which has the
> same aligment as the underlying cipher.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

It works now! Thanks!
But I get much lower speed than with aes-cbc-essiv:sha256.
With xts I get 57MB/s while reading the cryptodev with dd, and >90% sys in top, 0% wait
With cbc-essiv I get about 75MB/s while reading it with dd, 60% sys int top, 30% wait
without cryptodev I get 75MB/s while reading the raw lvm-volume with dd, 40% sys, 50% wait
I do a blockdev --flushbufs beetween each read.


Tested-by: Stefan Hellermann <stefan@the2masters.de>

> ---
> Stefan, please try the following patch, it should fix your xts problem.
> 
>  crypto/xts.c |   32 +++++++++++++++++---------------
>  1 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/crypto/xts.c b/crypto/xts.c
> index 8eb08bf..4457022 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -24,7 +24,17 @@
>  #include <crypto/b128ops.h>
>  #include <crypto/gf128mul.h>
>  
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
>  	struct crypto_cipher *child;
>  	struct crypto_cipher *tweak;
>  };
> @@ -76,12 +86,6 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
>  	return 0;
>  }
>  
> -struct sinfo {
> -	be128 t;
> -	struct crypto_tfm *tfm;
> -	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
> -};
> -
>  static inline void xts_round(struct sinfo *s, void *dst, const void *src)
>  {
>  	be128_xor(dst, &s->t, src);		/* PP <- T xor P */
> @@ -97,13 +101,12 @@ static int crypt(struct blkcipher_desc *d,
>  	int err;
>  	unsigned int avail;
>  	const int bs = crypto_cipher_blocksize(ctx->child);
> -	struct sinfo s = {
> -		.tfm = crypto_cipher_tfm(ctx->child),
> -		.fn = fn
> -	};
> -	be128 *iv;
>  	u8 *wsrc;
>  	u8 *wdst;
> +	struct sinfo *s = &ctx->s;
> +
> +	s->tfm = crypto_cipher_tfm(ctx->child);
> +	s->fn = fn;
>  
>  	err = blkcipher_walk_virt(d, w);
>  	if (!w->nbytes)
> @@ -115,17 +118,16 @@ static int crypt(struct blkcipher_desc *d,
>  	wdst = w->dst.virt.addr;
>  
>  	/* calculate first value of T */
> -	iv = (be128 *)w->iv;
> -	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s.t, w->iv);
> +	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s->t, w->iv);
>  
>  	goto first;
>  
>  	for (;;) {
>  		do {
> -			gf128mul_x_ble(&s.t, &s.t);
> +			gf128mul_x_ble(&s->t, &s->t);
>  
>  first:
> -			xts_round(&s, wdst, wsrc);
> +			xts_round(s, wdst, wsrc);
>  
>  			wsrc += bs;
>  			wdst += bs;
