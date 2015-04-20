From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: drbg - Do not seed RNG in drbg_kcapi_init
Date: Mon, 20 Apr 2015 14:17:36 +0200
Message-ID: <129959989.H0oAQT423E@myon.chronox.de>
References: <20150420032648.GA17746@gondor.apana.org.au> <20150420032914.GB17746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34224 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915AbbDTNQA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 09:16:00 -0400
In-Reply-To: <20150420032914.GB17746@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. April 2015, 11:29:15 schrieb Herbert Xu:

Hi Herbert,

> Initialising the RNG in drbg_kcapi_init is a waste of precious
> entropy because all users will immediately seed the RNG after
> the allocation.
> 
> In fact, all users should seed the RNG before using it.  So there
> is no point in doing the seeding in drbg_kcapi_init.
> 
> This patch removes the initial seeding and the user must seed
> the RNG explicitly (as they all currently do).
> 
> This patch also changes drbg_kcapi_reset to allow reseeding.
> That is, if you call it after a successful initial seeding, then
> it will not reset the internal state of the DRBG before mixing
> the new input and entropy.
> 
> If you still wish to reset the internal state, you can always
> free the DRBG and allocate a new one.
> 
> Finally this patch removes locking from drbg_uninstantiate because
> it's now only called from the destruction path which must not be
> executed in parallel with normal operations.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Stephan Mueller <smueller@chronox.de>

> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 57fd479..5bce159 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1136,6 +1136,8 @@ static inline void drbg_dealloc_state(struct
> drbg_state *drbg) kzfree(drbg->scratchpad);
>  	drbg->scratchpad = NULL;
>  	drbg->reseed_ctr = 0;
> +	drbg->d_ops = NULL;
> +	drbg->core = NULL;
>  #ifdef CONFIG_CRYPTO_FIPS
>  	kzfree(drbg->prev);
>  	drbg->prev = NULL;
> @@ -1152,6 +1154,27 @@ static inline int drbg_alloc_state(struct drbg_state
> *drbg) int ret = -ENOMEM;
>  	unsigned int sb_size = 0;
> 
> +	switch (drbg->core->flags & DRBG_TYPE_MASK) {
> +#ifdef CONFIG_CRYPTO_DRBG_HMAC
> +	case DRBG_HMAC:
> +		drbg->d_ops = &drbg_hmac_ops;
> +		break;
> +#endif /* CONFIG_CRYPTO_DRBG_HMAC */
> +#ifdef CONFIG_CRYPTO_DRBG_HASH
> +	case DRBG_HASH:
> +		drbg->d_ops = &drbg_hash_ops;
> +		break;
> +#endif /* CONFIG_CRYPTO_DRBG_HASH */
> +#ifdef CONFIG_CRYPTO_DRBG_CTR
> +	case DRBG_CTR:
> +		drbg->d_ops = &drbg_ctr_ops;
> +		break;
> +#endif /* CONFIG_CRYPTO_DRBG_CTR */
> +	default:
> +		ret = -EOPNOTSUPP;
> +		goto err;
> +	}
> +
>  	drbg->V = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
>  	if (!drbg->V)
>  		goto err;
> @@ -1215,6 +1238,10 @@ static int drbg_generate(struct drbg_state *drbg,
>  	int len = 0;
>  	LIST_HEAD(addtllist);
> 
> +	if (!drbg->core) {
> +		pr_devel("DRBG: not yet seeded\n");
> +		return -EINVAL;
> +	}
>  	if (0 == buflen || !buf) {
>  		pr_devel("DRBG: no output buffer provided\n");
>  		return -EINVAL;
> @@ -1372,33 +1399,12 @@ static int drbg_generate_long(struct drbg_state
> *drbg, static int drbg_instantiate(struct drbg_state *drbg, struct
> drbg_string *pers, int coreref, bool pr)
>  {
> -	int ret = -EOPNOTSUPP;
> +	int ret;
> +	bool reseed = true;
> 
>  	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
>  		 "%s\n", coreref, pr ? "enabled" : "disabled");
>  	mutex_lock(&drbg->drbg_mutex);
> -	drbg->core = &drbg_cores[coreref];
> -	drbg->pr = pr;
> -	drbg->seeded = false;
> -	switch (drbg->core->flags & DRBG_TYPE_MASK) {
> -#ifdef CONFIG_CRYPTO_DRBG_HMAC
> -	case DRBG_HMAC:
> -		drbg->d_ops = &drbg_hmac_ops;
> -		break;
> -#endif /* CONFIG_CRYPTO_DRBG_HMAC */
> -#ifdef CONFIG_CRYPTO_DRBG_HASH
> -	case DRBG_HASH:
> -		drbg->d_ops = &drbg_hash_ops;
> -		break;
> -#endif /* CONFIG_CRYPTO_DRBG_HASH */
> -#ifdef CONFIG_CRYPTO_DRBG_CTR
> -	case DRBG_CTR:
> -		drbg->d_ops = &drbg_ctr_ops;
> -		break;
> -#endif /* CONFIG_CRYPTO_DRBG_CTR */
> -	default:
> -		goto unlock;
> -	}
> 
>  	/* 9.1 step 1 is implicit with the selected DRBG type */
> 
> @@ -1410,21 +1416,31 @@ static int drbg_instantiate(struct drbg_state *drbg,
> struct drbg_string *pers,
> 
>  	/* 9.1 step 4 is implicit in  drbg_sec_strength */
> 
> -	ret = drbg_alloc_state(drbg);
> -	if (ret)
> -		goto unlock;
> +	if (!drbg->core) {
> +		drbg->core = &drbg_cores[coreref];
> +		drbg->pr = pr;
> +		drbg->seeded = false;
> 
> -	ret = -EFAULT;
> -	if (drbg->d_ops->crypto_init(drbg))
> -		goto err;
> -	ret = drbg_seed(drbg, pers, false);
> -	if (ret) {
> +		ret = drbg_alloc_state(drbg);
> +		if (ret)
> +			goto unlock;
> +
> +		ret = -EFAULT;
> +		if (drbg->d_ops->crypto_init(drbg))
> +			goto err;
> +
> +		reseed = false;
> +	}
> +
> +	ret = drbg_seed(drbg, pers, reseed);
> +
> +	if (ret && !reseed) {
>  		drbg->d_ops->crypto_fini(drbg);
>  		goto err;
>  	}
> 
>  	mutex_unlock(&drbg->drbg_mutex);
> -	return 0;
> +	return ret;
> 
>  err:
>  	drbg_dealloc_state(drbg);
> @@ -1444,11 +1460,10 @@ unlock:
>   */
>  static int drbg_uninstantiate(struct drbg_state *drbg)
>  {
> -	mutex_lock(&drbg->drbg_mutex);
> -	drbg->d_ops->crypto_fini(drbg);
> +	if (drbg->d_ops)
> +		drbg->d_ops->crypto_fini(drbg);
>  	drbg_dealloc_state(drbg);
>  	/* no scrubbing of test_data -- this shall survive an uninstantiate */
> -	mutex_unlock(&drbg->drbg_mutex);
>  	return 0;
>  }
> 
> @@ -1615,16 +1630,10 @@ static inline void drbg_convert_tfm_core(const char
> *cra_driver_name, static int drbg_kcapi_init(struct crypto_tfm *tfm)
>  {
>  	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
> -	bool pr = false;
> -	int coreref = 0;
> 
>  	mutex_init(&drbg->drbg_mutex);
> -	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm), &coreref, &pr);
> -	/*
> -	 * when personalization string is needed, the caller must call reset
> -	 * and provide the personalization string as seed information
> -	 */
> -	return drbg_instantiate(drbg, NULL, coreref, pr);
> +
> +	return 0;
>  }
> 
>  static void drbg_kcapi_cleanup(struct crypto_tfm *tfm)
> @@ -1665,10 +1674,9 @@ static int drbg_kcapi_random(struct crypto_rng *tfm,
> u8 *rdata, }
> 
>  /*
> - * Reset the DRBG invoked by the kernel crypto API
> - * The reset implies a full re-initialization of the DRBG. Similar to the
> - * generate function of drbg_kcapi_random, this function extends the
> - * kernel crypto API interface with struct drbg_gen
> + * Seed the DRBG invoked by the kernel crypto API
> + * Similar to the generate function of drbg_kcapi_random, this
> + * function extends the kernel crypto API interface with struct drbg_gen
>   */
>  static int drbg_kcapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int
> slen) {
> @@ -1678,7 +1686,6 @@ static int drbg_kcapi_reset(struct crypto_rng *tfm, u8
> *seed, unsigned int slen) struct drbg_string seed_string;
>  	int coreref = 0;
> 
> -	drbg_uninstantiate(drbg);
>  	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm_base), &coreref,
>  			      &pr);
>  	if (0 < slen) {


-- 
Ciao
Stephan
