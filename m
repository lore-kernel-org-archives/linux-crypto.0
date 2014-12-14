From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 13/25] crypto: Add appropriate consts to RNG API
Date: Sun, 14 Dec 2014 12:39:47 +0100
Message-ID: <10282004.9BfpQk0Rcv@tachyon.chronox.de>
References: <cover.1417951990.git.linux@horizon.com> <622c0b1320fe555f0ce97f4c342a0877f14d63b6.1417951990.git.linux@horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55032 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaLNLj5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2014 06:39:57 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC345> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 14 Dec 2014 12:39:47 +0100
In-Reply-To: <622c0b1320fe555f0ce97f4c342a0877f14d63b6.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 7. Dezember 2014, 07:26:21 schrieb George Spelvin:

Hi George,

> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>  crypto/ansi_cprng.c    | 11 ++++++-----
>  crypto/krng.c          |  2 +-
>  crypto/rng.c           |  3 ++-
>  include/crypto/rng.h   |  2 +-
>  include/linux/crypto.h |  6 ++++--
>  5 files changed, 14 insertions(+), 10 deletions(-)

Please update the drbg too.
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index 249b944f..c1c81266 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -299,11 +299,11 @@ static int cprng_get_random(struct crypto_rng *tfm, u8
> *rdata, *  V and KEY are required during reset, and DT is optional,
> detected *  as being present by testing the length of the seed
>   */
> -static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
> +static int cprng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned
> int slen) {
>  	struct prng_context *prng = crypto_rng_ctx(tfm);
> -	u8 *key = seed + DEFAULT_BLK_SZ;
> -	u8 *dt = NULL;
> +	const u8 *key = seed + DEFAULT_BLK_SZ;
> +	const u8 *dt = NULL;
> 
>  	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
>  		return -EINVAL;
> @@ -327,9 +327,10 @@ static int fips_cprng_get_random(struct crypto_rng
> *tfm, u8 *rdata, return get_prng_bytes(rdata, dlen, prng, true);
>  }
> 
> -static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int
> slen) +static int fips_cprng_reset(struct crypto_rng *tfm, const u8 *seed,
> +			    unsigned int slen)
>  {
> -	u8 *key = seed + DEFAULT_BLK_SZ;
> +	const u8 *key = seed + DEFAULT_BLK_SZ;
>  	int rc;
> 
>  	struct prng_context *prng = crypto_rng_ctx(tfm);
> diff --git a/crypto/krng.c b/crypto/krng.c
> index a2d2b72f..007ea7e3 100644
> --- a/crypto/krng.c
> +++ b/crypto/krng.c
> @@ -22,7 +22,7 @@ static int krng_get_random(struct crypto_rng *tfm, u8
> *rdata, unsigned int dlen) return 0;
>  }
> 
> -static int krng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
> +static int krng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int
> slen) {
>  	return 0;
>  }
> diff --git a/crypto/rng.c b/crypto/rng.c
> index e0a25c24..9e3a6efd 100644
> --- a/crypto/rng.c
> +++ b/crypto/rng.c
> @@ -29,7 +29,8 @@ struct crypto_rng *crypto_default_rng;
>  EXPORT_SYMBOL_GPL(crypto_default_rng);
>  static int crypto_default_rng_refcnt;
> 
> -static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int
> slen) +static int rngapi_reset(struct crypto_rng *tfm, const u8 *seed,
> +			unsigned int slen)
>  {
>  	u8 *buf = NULL;
>  	int err;
> diff --git a/include/crypto/rng.h b/include/crypto/rng.h
> index c93f9b91..9659300a 100644
> --- a/include/crypto/rng.h
> +++ b/include/crypto/rng.h
> @@ -62,7 +62,7 @@ static inline int crypto_rng_get_bytes(struct crypto_rng
> *tfm, }
> 
>  static inline int crypto_rng_reset(struct crypto_rng *tfm,
> -				   u8 *seed, unsigned int slen)
> +				   const u8 *seed, unsigned int slen)
>  {
>  	return crypto_rng_crt(tfm)->rng_reset(tfm, seed, slen);
>  }
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index d45e9496..8aa6350b 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -264,7 +264,8 @@ struct compress_alg {
>  struct rng_alg {
>  	int (*rng_make_random)(struct crypto_rng *tfm, u8 *rdata,
>  			       unsigned int dlen);
> -	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
> +	int (*rng_reset)(struct crypto_rng *tfm, const u8 *seed,
> +			       unsigned int slen);
> 
>  	unsigned int seedsize;
>  };
> @@ -399,7 +400,8 @@ struct compress_tfm {
>  struct rng_tfm {
>  	int (*rng_gen_random)(struct crypto_rng *tfm, u8 *rdata,
>  			      unsigned int dlen);
> -	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
> +	int (*rng_reset)(struct crypto_rng *tfm, const u8 *seed,
> +			 unsigned int slen);
>  };
> 
>  #define crt_ablkcipher	crt_u.ablkcipher


-- 
Ciao
Stephan
