Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C66333727;
	Mon, 20 Apr 2026 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701167; cv=none; b=MIiNe0X9cZ3+a0IeSVSJRkdlCWZrb9+nIEdlALh7fhwpjHjqEiLwzAXtqvmhUMCA4td+QfHUu7lQ14ZbiLXzV+PDVmaLNS7hlHRearPIaVgFRwchZspXubhOdLvl4xgXDrkdA3yngeO8OLVpc5NsJ93Xe55ZjRLjnAs7YN/4jt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701167; c=relaxed/simple;
	bh=Z3nMyQHxT2EyCzagfzd74vM9WoLfip6g2UhfTChBwS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDQbYh7eX1xCw69KZJ9+5rZjBeTm8zaJFg+6RtjxmU3hFvONxHGcG6lAy3goheIh8+dxinu9eIt5STzpmLFO1kvwZ/6Jin/eU19UBSHQ5nnZaNYWBdK8KSeYZBgjjPDVZNYwrGmDb5zbgQjAa9AvpK3C33UFTpWBJD3Vw9YOwlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=0YAa9S1B; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="0YAa9S1B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1776701164; bh=Z3nMyQHxT2EyCzagfzd74vM9WoLfip6g2UhfTChBwS4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=0YAa9S1BLIqZob3ejdDdXJUFPN1XkzX3esWWUfhdFUvUMqU5hBbmYLZsahWu9FO08
	 FVfHUwwtzgwK89RKXFWLOOSytSav62WyZYVk5pAL3lUJeAh3Ey+zdksarkVr2LYVKH
	 JgkAv8CN4bk5wlCm/WWWBhQvtz8stH4eUER65PWCz0O1L+l3adbGusN5zrimJE3rnW
	 mk9grS3kz9BxHoywLUIAmukBaY1QUyCXn3fVQraUN98scuGAEZXkTqP4kkIAkQMxNE
	 Y2E03Eu1LXo97RX+/XTrj5+4yJ5PW7XivuAGno4K1d2F8qPnCXJWWBSWy18XaP2d9g
	 ruSnNwbmzfaGg==
Message-ID: <f3e2f1d7-e541-45ef-961c-1d32e5dea655@jvdsn.com>
Date: Mon, 20 Apr 2026 11:06:04 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 20/38] crypto: drbg - Move fixed values into constants
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20260420063422.324906-1-ebiggers@kernel.org>
 <20260420063422.324906-21-ebiggers@kernel.org>
From: Joachim Vandersmissen <joachim@jvdsn.com>
Content-Language: en-US
In-Reply-To: <20260420063422.324906-21-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

If possible, I suggest using "DRBG_MAX_ADDTL_BYTES" for consistency with 
DRBG_MAX_REQUEST_BYTES and avoiding any possible confusion in the future.

Kind regards,
Joachim

On 4/20/26 1:34 AM, Eric Biggers wrote:
> Since only one drbg_core remains, the state length, block length, and
> security strength are now fixed values.  Moreover, the maximum request
> length, maximum additional data length, and maximum number of requests
> were all already fixed values.
>
> Simplify the code by just using #defines for all these fixed values.
>
> In drbg_seed_from_random(), take advantage of the constant to define the
> array size.  Remove assertions that are no longer useful.
>
> In the case of drbg_blocklen() and drbg_statelen(), replace these with a
> single value DRBG_STATE_LEN, as for HMAC_DRBG they are the same thing.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   crypto/drbg.c | 183 +++++++++++++++++---------------------------------
>   1 file changed, 61 insertions(+), 122 deletions(-)
>
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 04c798d7a8b6..34a7cbdda1f1 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -89,25 +89,22 @@
>    */
>   
>   #include <crypto/internal/drbg.h>
>   #include <crypto/internal/rng.h>
>   #include <crypto/hash.h>
> +#include <crypto/sha2.h>
>   #include <linux/fips.h>
>   #include <linux/kernel.h>
>   #include <linux/jiffies.h>
>   #include <linux/module.h>
>   #include <linux/mutex.h>
>   #include <linux/string_choices.h>
>   #include <linux/unaligned.h>
>   
>   struct drbg_state;
> -typedef uint32_t drbg_flag_t;
>   
>   struct drbg_core {
> -	drbg_flag_t flags;	/* flags for the cipher */
> -	__u8 statelen;		/* maximum state length */
> -	__u8 blocklen_bytes;	/* block size of output in bytes */
>   	char cra_name[CRYPTO_MAX_ALG_NAME]; /* mapping to kernel crypto API */
>   	 /* kernel crypto API backend cipher name */
>   	char backend_cra_name[CRYPTO_MAX_ALG_NAME];
>   };
>   
> @@ -115,10 +112,36 @@ enum drbg_seed_state {
>   	DRBG_SEED_STATE_UNSEEDED,
>   	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
>   	DRBG_SEED_STATE_FULL,
>   };
>   
> +/* State length in bytes */
> +#define DRBG_STATE_LEN		SHA512_DIGEST_SIZE
> +
> +/* Security strength in bytes */
> +#define DRBG_SEC_STRENGTH	(SHA512_DIGEST_SIZE / 2)
> +
> +/*
> + * Maximum number of requests before reseeding is forced.
> + * SP800-90A allows this to be up to 2**48.  We use a lower value.
> + */
> +#define DRBG_MAX_REQUESTS	(1 << 20)
> +
> +/*
> + * Maximum number of random bytes that can be requested at once.
> + * SP800-90A allows up to 2**19 bits, which is 2**16 bytes.
> + */
> +#define DRBG_MAX_REQUEST_BYTES	(1 << 16)
> +
> +/*
> + * Maximum length of additional info and personalization strings, in bytes.
> + * SP800-90A allows up to 2**35 bits, i.e. 2**32 bytes.  We use 2**32 - 2 bytes
> + * so that the value never quite completely fills the range of a size_t,
> + * allowing the health check to verify that larger values are rejected.
> + */
> +#define DRBG_MAX_ADDTL		(U32_MAX - 1)
> +
>   struct drbg_state {
>   	struct mutex drbg_mutex;	/* lock around DRBG */
>   	unsigned char *V;	/* internal state -- 10.1.2.1 1a */
>   	unsigned char *Vbuf;
>   	unsigned char *C;	/* current key -- 10.1.2.1 1b */
> @@ -134,57 +157,10 @@ struct drbg_state {
>   	struct crypto_rng *jent;
>   	const struct drbg_core *core;
>   	struct drbg_string test_data;
>   };
>   
> -static inline __u8 drbg_statelen(struct drbg_state *drbg)
> -{
> -	if (drbg && drbg->core)
> -		return drbg->core->statelen;
> -	return 0;
> -}
> -
> -static inline __u8 drbg_blocklen(struct drbg_state *drbg)
> -{
> -	if (drbg && drbg->core)
> -		return drbg->core->blocklen_bytes;
> -	return 0;
> -}
> -
> -static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
> -{
> -	/* SP800-90A requires the limit 2**19 bits, but we return bytes */
> -	return (1 << 16);
> -}
> -
> -/*
> - * SP800-90A allows implementations to support additional info / personalization
> - * strings of up to 2**35 bits.  Implementations can have a smaller maximum.  We
> - * use 2**35 - 16 bits == U32_MAX - 1 bytes so that the max + 1 always fits in a
> - * size_t, allowing drbg_healthcheck_sanity() to verify its enforcement.
> - */
> -static inline size_t drbg_max_addtl(struct drbg_state *drbg)
> -{
> -	return U32_MAX - 1;
> -}
> -
> -static inline size_t drbg_max_requests(struct drbg_state *drbg)
> -{
> -	/* SP800-90A requires 2**48 maximum requests before reseeding */
> -	return (1<<20);
> -}
> -
> -/* DRBG type flags */
> -#define DRBG_HMAC	((drbg_flag_t)1<<1)
> -#define DRBG_TYPE_MASK	DRBG_HMAC
> -/* DRBG strength flags */
> -#define DRBG_STRENGTH128	((drbg_flag_t)1<<3)
> -#define DRBG_STRENGTH192	((drbg_flag_t)1<<4)
> -#define DRBG_STRENGTH256	((drbg_flag_t)1<<5)
> -#define DRBG_STRENGTH_MASK	(DRBG_STRENGTH128 | DRBG_STRENGTH192 | \
> -				 DRBG_STRENGTH256)
> -
>   enum drbg_prefixes {
>   	DRBG_PREFIX0 = 0x00,
>   	DRBG_PREFIX1,
>   };
>   
> @@ -199,46 +175,17 @@ enum drbg_prefixes {
>    *
>    * Thus, the favored DRBGs are the latest entries in this array.
>    */
>   static const struct drbg_core drbg_cores[] = {
>   	{
> -		.flags = DRBG_HMAC | DRBG_STRENGTH256,
> -		.statelen = 64, /* block length of cipher */
> -		.blocklen_bytes = 64,
>   		.cra_name = "hmac_sha512",
>   		.backend_cra_name = "hmac(sha512)",
>   	},
>   };
>   
>   static int drbg_uninstantiate(struct drbg_state *drbg);
>   
> -/******************************************************************
> - * Generic helper functions
> - ******************************************************************/
> -
> -/*
> - * Return strength of DRBG according to SP800-90A section 8.4
> - *
> - * @flags DRBG flags reference
> - *
> - * Return: normalized strength in *bytes* value or 32 as default
> - *	   to counter programming errors
> - */
> -static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
> -{
> -	switch (flags & DRBG_STRENGTH_MASK) {
> -	case DRBG_STRENGTH128:
> -		return 16;
> -	case DRBG_STRENGTH192:
> -		return 24;
> -	case DRBG_STRENGTH256:
> -		return 32;
> -	default:
> -		return 32;
> -	}
> -}
> -
>   /******************************************************************
>    * HMAC DRBG functions
>    ******************************************************************/
>   
>   static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
> @@ -261,24 +208,24 @@ static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
>   	LIST_HEAD(seedlist);
>   	LIST_HEAD(vdatalist);
>   
>   	if (!reseed) {
>   		/* 10.1.2.3 step 2 -- memset(0) of C is implicit with kzalloc */
> -		memset(drbg->V, 1, drbg_statelen(drbg));
> +		memset(drbg->V, 1, DRBG_STATE_LEN);
>   		drbg_kcapi_hmacsetkey(drbg, drbg->C);
>   	}
>   
> -	drbg_string_fill(&seed1, drbg->V, drbg_statelen(drbg));
> +	drbg_string_fill(&seed1, drbg->V, DRBG_STATE_LEN);
>   	list_add_tail(&seed1.list, &seedlist);
>   	/* buffer of seed2 will be filled in for loop below with one byte */
>   	drbg_string_fill(&seed2, NULL, 1);
>   	list_add_tail(&seed2.list, &seedlist);
>   	/* input data of seed is allowed to be NULL at this point */
>   	if (seed)
>   		list_splice_tail(seed, &seedlist);
>   
> -	drbg_string_fill(&vdata, drbg->V, drbg_statelen(drbg));
> +	drbg_string_fill(&vdata, drbg->V, DRBG_STATE_LEN);
>   	list_add_tail(&vdata.list, &vdatalist);
>   	for (i = 2; 0 < i; i--) {
>   		/* first round uses 0x0, second 0x1 */
>   		unsigned char prefix = DRBG_PREFIX0;
>   		if (1 == i)
> @@ -319,20 +266,20 @@ static int drbg_hmac_generate(struct drbg_state *drbg,
>   		ret = drbg_hmac_update(drbg, addtl, 1);
>   		if (ret)
>   			return ret;
>   	}
>   
> -	drbg_string_fill(&data, drbg->V, drbg_statelen(drbg));
> +	drbg_string_fill(&data, drbg->V, DRBG_STATE_LEN);
>   	list_add_tail(&data.list, &datalist);
>   	while (len < buflen) {
>   		unsigned int outlen = 0;
>   		/* 10.1.2.5 step 4.1 */
>   		ret = drbg_kcapi_hash(drbg, drbg->V, &datalist);
>   		if (ret)
>   			return ret;
> -		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
> -			  drbg_blocklen(drbg) : (buflen - len);
> +		outlen = (DRBG_STATE_LEN < (buflen - len)) ?
> +			  DRBG_STATE_LEN : (buflen - len);
>   
>   		/* 10.1.2.5 step 4.2 */
>   		memcpy(buf + len, drbg->V, outlen);
>   		len += outlen;
>   	}
> @@ -375,11 +322,11 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
>   	case DRBG_SEED_STATE_FULL:
>   		/*
>   		 * Seed source has become fully initialized, frequent
>   		 * reseeds no longer required.
>   		 */
> -		drbg->reseed_threshold = drbg_max_requests(drbg);
> +		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
>   		break;
>   	}
>   
>   	return ret;
>   }
> @@ -387,25 +334,21 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
>   static int drbg_seed_from_random(struct drbg_state *drbg)
>   	__must_hold(&drbg->drbg_mutex)
>   {
>   	struct drbg_string data;
>   	LIST_HEAD(seedlist);
> -	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
> -	unsigned char entropy[32];
> +	unsigned char entropy[DRBG_SEC_STRENGTH];
>   	int ret;
>   
> -	BUG_ON(!entropylen);
> -	BUG_ON(entropylen > sizeof(entropy));
> -
> -	drbg_string_fill(&data, entropy, entropylen);
> +	drbg_string_fill(&data, entropy, DRBG_SEC_STRENGTH);
>   	list_add_tail(&data.list, &seedlist);
>   
> -	get_random_bytes(entropy, entropylen);
> +	get_random_bytes(entropy, DRBG_SEC_STRENGTH);
>   
>   	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
>   
> -	memzero_explicit(entropy, entropylen);
> +	memzero_explicit(entropy, DRBG_SEC_STRENGTH);
>   	return ret;
>   }
>   
>   static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
>   {
> @@ -442,17 +385,17 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
>   		     bool reseed)
>   	__must_hold(&drbg->drbg_mutex)
>   {
>   	int ret;
>   	unsigned char entropy[((32 + 16) * 2)];
> -	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
> +	unsigned int entropylen;
>   	struct drbg_string data1;
>   	LIST_HEAD(seedlist);
>   	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
>   
>   	/* 9.1 / 9.2 / 9.3.1 step 3 */
> -	if (pers && pers->len > (drbg_max_addtl(drbg))) {
> +	if (pers && pers->len > DRBG_MAX_ADDTL) {
>   		pr_devel("DRBG: personalization string too long %zu\n",
>   			 pers->len);
>   		return -EINVAL;
>   	}
>   
> @@ -467,13 +410,14 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
>   		 * to the entropy. A nonce must be at least 1/2 of the security
>   		 * strength of the DRBG in size. Thus, entropy + nonce is 3/2
>   		 * of the strength. The consideration of a nonce is only
>   		 * applicable during initial seeding.
>   		 */
> -		BUG_ON(!entropylen);
>   		if (!reseed)
> -			entropylen = ((entropylen + 1) / 2) * 3;
> +			entropylen = ((DRBG_SEC_STRENGTH + 1) / 2) * 3;
> +		else
> +			entropylen = DRBG_SEC_STRENGTH;
>   		BUG_ON((entropylen * 2) > sizeof(entropy));
>   
>   		/* Get seed from in-kernel /dev/urandom */
>   		if (!rng_is_initialized())
>   			new_seed_state = DRBG_SEED_STATE_PARTIAL;
> @@ -529,18 +473,18 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
>   		list_add_tail(&pers->list, &seedlist);
>   		pr_devel("DRBG: using personalization string\n");
>   	}
>   
>   	if (!reseed) {
> -		memset(drbg->V, 0, drbg_statelen(drbg));
> -		memset(drbg->C, 0, drbg_statelen(drbg));
> +		memset(drbg->V, 0, DRBG_STATE_LEN);
> +		memset(drbg->C, 0, DRBG_STATE_LEN);
>   	}
>   
>   	ret = __drbg_seed(drbg, &seedlist, reseed, new_seed_state);
>   
>   out:
> -	memzero_explicit(entropy, entropylen * 2);
> +	memzero_explicit(entropy, sizeof(entropy));
>   
>   	return ret;
>   }
>   
>   /* Free all substructures in a DRBG state without the DRBG state structure */
> @@ -568,17 +512,17 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
>   
>   	ret = drbg_init_hash_kernel(drbg);
>   	if (ret < 0)
>   		goto err;
>   
> -	drbg->Vbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
> +	drbg->Vbuf = kmalloc(DRBG_STATE_LEN + ret, GFP_KERNEL);
>   	if (!drbg->Vbuf) {
>   		ret = -ENOMEM;
>   		goto fini;
>   	}
>   	drbg->V = PTR_ALIGN(drbg->Vbuf, ret + 1);
> -	drbg->Cbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
> +	drbg->Cbuf = kmalloc(DRBG_STATE_LEN + ret, GFP_KERNEL);
>   	if (!drbg->Cbuf) {
>   		ret = -ENOMEM;
>   		goto fini;
>   	}
>   	drbg->C = PTR_ALIGN(drbg->Cbuf, ret + 1);
> @@ -628,24 +572,23 @@ static int drbg_generate(struct drbg_state *drbg,
>   		pr_devel("DRBG: wrong format of additional information\n");
>   		return -EINVAL;
>   	}
>   
>   	/* 9.3.1 step 2 */
> -	len = -EINVAL;
> -	if (buflen > (drbg_max_request_bytes(drbg))) {
> +	if (buflen > DRBG_MAX_REQUEST_BYTES) {
>   		pr_devel("DRBG: requested random numbers too large %u\n",
>   			 buflen);
> -		goto err;
> +		return -EINVAL;
>   	}
>   
>   	/* 9.3.1 step 3 is implicit with the chosen DRBG */
>   
>   	/* 9.3.1 step 4 */
> -	if (addtl && addtl->len > (drbg_max_addtl(drbg))) {
> +	if (addtl && addtl->len > DRBG_MAX_ADDTL) {
>   		pr_devel("DRBG: additional information string too long %zu\n",
>   			 addtl->len);
> -		goto err;
> +		return -EINVAL;
>   	}
>   	/* 9.3.1 step 5 is implicit with the chosen DRBG */
>   
>   	/*
>   	 * 9.3.1 step 6 and 9 supplemented by 9.3.2 step c is implemented
> @@ -721,12 +664,12 @@ static int drbg_generate_long(struct drbg_state *drbg,
>   	unsigned int len = 0;
>   	unsigned int slice = 0;
>   	do {
>   		int err = 0;
>   		unsigned int chunk = 0;
> -		slice = ((buflen - len) / drbg_max_request_bytes(drbg));
> -		chunk = slice ? drbg_max_request_bytes(drbg) : (buflen - len);
> +		slice = (buflen - len) / DRBG_MAX_REQUEST_BYTES;
> +		chunk = slice ? DRBG_MAX_REQUEST_BYTES : (buflen - len);
>   		mutex_lock(&drbg->drbg_mutex);
>   		err = drbg_generate(drbg, buf + len, chunk, addtl);
>   		mutex_unlock(&drbg->drbg_mutex);
>   		if (0 > err)
>   			return err;
> @@ -783,22 +726,21 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
>   
>   	/* 9.1 step 1 is implicit with the selected DRBG type */
>   
>   	/*
>   	 * 9.1 step 2 is implicit as caller can select prediction resistance
> -	 * and the flag is copied into drbg->flags --
>   	 * all DRBG types support prediction resistance
>   	 */
>   
> -	/* 9.1 step 4 is implicit in  drbg_sec_strength */
> +	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
>   
>   	if (!drbg->core) {
>   		drbg->core = &drbg_cores[coreref];
>   		drbg->pr = pr;
>   		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
>   		drbg->last_seed_time = 0;
> -		drbg->reseed_threshold = drbg_max_requests(drbg);
> +		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
>   
>   		ret = drbg_alloc_state(drbg);
>   		if (ret)
>   			goto unlock;
>   
> @@ -882,11 +824,11 @@ static int drbg_init_hash_kernel(struct drbg_state *drbg)
>   	if (IS_ERR(tfm)) {
>   		pr_info("DRBG: could not allocate digest TFM handle: %s\n",
>   				drbg->core->backend_cra_name);
>   		return PTR_ERR(tfm);
>   	}
> -	BUG_ON(drbg_blocklen(drbg) != crypto_shash_digestsize(tfm));
> +	BUG_ON(DRBG_STATE_LEN != crypto_shash_digestsize(tfm));
>   	sdesc = kzalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
>   			GFP_KERNEL);
>   	if (!sdesc) {
>   		crypto_free_shash(tfm);
>   		return -ENOMEM;
> @@ -912,11 +854,11 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg)
>   static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
>   				  const unsigned char *key)
>   {
>   	struct sdesc *sdesc = drbg->priv_data;
>   
> -	crypto_shash_setkey(sdesc->shash.tfm, key, drbg_statelen(drbg));
> +	crypto_shash_setkey(sdesc->shash.tfm, key, DRBG_STATE_LEN);
>   }
>   
>   static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
>   			   const struct list_head *in)
>   {
> @@ -1058,11 +1000,10 @@ static inline int __init drbg_healthcheck_sanity(void)
>   	int ret;
>   	int rc = -EFAULT;
>   	bool pr = false;
>   	int coreref = 0;
>   	struct drbg_string addtl;
> -	size_t max_addtllen, max_request_bytes;
>   
>   	/* only perform test in FIPS mode */
>   	if (!fips_enabled)
>   		return 0;
>   
> @@ -1072,28 +1013,26 @@ static inline int __init drbg_healthcheck_sanity(void)
>   	if (!drbg)
>   		return -ENOMEM;
>   
>   	guard(mutex_init)(&drbg->drbg_mutex);
>   	drbg->core = &drbg_cores[coreref];
> -	drbg->reseed_threshold = drbg_max_requests(drbg);
> +	drbg->reseed_threshold = DRBG_MAX_REQUESTS;
>   
>   	/*
>   	 * if the following tests fail, it is likely that there is a buffer
>   	 * overflow as buf is much smaller than the requested or provided
>   	 * string lengths -- in case the error handling does not succeed
>   	 * we may get an OOPS. And we want to get an OOPS as this is a
>   	 * grave bug.
>   	 */
>   
> -	max_addtllen = drbg_max_addtl(drbg);
> -	max_request_bytes = drbg_max_request_bytes(drbg);
> -	drbg_string_fill(&addtl, buf, max_addtllen + 1);
> +	drbg_string_fill(&addtl, buf, DRBG_MAX_ADDTL + 1);
>   	/* overflow addtllen with additional info string */
>   	ret = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
>   	BUG_ON(ret == 0);
>   	/* overflow max_bits */
> -	ret = drbg_generate(drbg, buf, max_request_bytes + 1, NULL);
> +	ret = drbg_generate(drbg, buf, DRBG_MAX_REQUEST_BYTES + 1, NULL);
>   	BUG_ON(ret == 0);
>   
>   	/* overflow max addtllen with personalization string */
>   	ret = drbg_seed(drbg, &addtl, false);
>   	BUG_ON(0 == ret);
