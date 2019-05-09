Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538B1C04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 09:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FC9D206A3
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 09:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfEIJQT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 05:16:19 -0400
Received: from ou.quest-ce.net ([195.154.187.82]:36811 "EHLO ou.quest-ce.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfEIJQT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 05:16:19 -0400
Received: from [2a01:e35:39f2:1220:2452:dd6c:fe2f:be2c] (helo=opteyam2)
        by ou.quest-ce.net with esmtpsa (TLS1.1:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <ydroneaud@opteya.com>)
        id 1hOf9w-0001nU-Na; Thu, 09 May 2019 11:16:13 +0200
Message-ID: <3c251e75b3bfda1bf0722210bd2b4e84f74ff2da.camel@opteya.com>
From:   Yann Droneaud <ydroneaud@opteya.com>
To:     Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Date:   Thu, 09 May 2019 11:16:12 +0200
In-Reply-To: <1778495.GGYfhorZbc@tauon.chronox.de>
References: <1852500.fyBc0DU23F@positron.chronox.de>
         <1654549.mqJkfNR9fV@positron.chronox.de>
         <74c517ac2c654a7372af731a67e24743c843e157.camel@opteya.com>
         <1778495.GGYfhorZbc@tauon.chronox.de>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a01:e35:39f2:1220:2452:dd6c:fe2f:be2c
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH v6] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le mercredi 08 mai 2019 à 16:19 +0200, Stephan Mueller a écrit :
> FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
> source. Up to kernel 4.8 drivers/char/random.c provided this continuous
> self test. Afterwards it was moved to a location that is inconsistent
> with the FIPS 140-2 requirements. The relevant patch was
> e192be9d9a30555aae2ca1dc3aad37cba484cd4a .
> 
> Thus, the FIPS 140-2 CTRNG is added to the DRBG when it obtains the
> seed. This patch resurrects the function drbg_fips_continous_test that
> existed some time ago and applies it to the noise sources. The patch
> that removed the drbg_fips_continous_test was
> b3614763059b82c26bdd02ffcb1c016c1132aad0 .
> 
> The Jitter RNG implements its own FIPS 140-2 self test and thus does not
> need to be subjected to the test in the DRBG.
> 
> The patch contains a tiny fix to ensure proper zeroization in case of an
> error during the Jitter RNG data gathering.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c         | 94 +++++++++++++++++++++++++++++++++++++++++--
>  include/crypto/drbg.h |  2 +
>  2 files changed, 93 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 2a5b16bb000c..b6929eb5f565 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -219,6 +219,57 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
>  	}
>  }
>  
> +/*
> + * FIPS 140-2 continuous self test for the noise source
> + * The test is performed on the noise source input data. Thus, the function
> + * implicitly knows the size of the buffer to be equal to the security
> + * strength.
> + *
> + * Note, this function disregards the nonce trailing the entropy data during
> + * initial seeding.
> + *
> + * drbg->drbg_mutex must have been taken.
> + *
> + * @drbg DRBG handle
> + * @entropy buffer of seed data to be checked
> + *
> + * return:
> + *	0 on success
> + *	-EAGAIN on when the CTRNG is not yet primed
> + *	< 0 on error
> + */
> +static int drbg_fips_continuous_test(struct drbg_state *drbg,
> +				     const unsigned char *entropy)
> +{
> +	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
> +	int ret = 0;
> +
> +	if (!IS_ENABLED(CONFIG_CRYPTO_FIPS))
> +		return 0;
> +
> +	/* skip test if we test the overall system */
> +	if (list_empty(&drbg->test_data.list))
> +		return 0;
> +	/* only perform test in FIPS mode */
> +	if (!fips_enabled)
> +		return 0;
> +
> +	if (!drbg->fips_primed) {
> +		/* Priming of FIPS test */
> +		memcpy(drbg->prev, entropy, entropylen);
> +		drbg->fips_primed = true;
> +		/* priming: another round is needed */
> +		return -EAGAIN;
> +	}
> +	ret = memcmp(drbg->prev, entropy, entropylen);
> +	if (!ret)
> +		panic("DRBG continuous self test failed\n");
> +	memcpy(drbg->prev, entropy, entropylen);
> +
> +	/* the test shall pass when the two values are not equal */
> +	return 0;
> +}
> +
>  /*
>   * Convert an integer into a byte representation of this integer.
>   * The byte representation is big-endian
> @@ -998,6 +1049,22 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
>  	return ret;
>  }
>  
> +static inline int drbg_get_random_bytes(struct drbg_state *drbg,
> +					unsigned char *entropy,
> +					unsigned int entropylen)
> +{
> +	int ret;
> +
> +	do {
> +		get_random_bytes(entropy, entropylen);
> +		ret = drbg_fips_continuous_test(drbg, entropy);
> +		if (ret && ret != -EAGAIN)
> +			return ret;
> +	} while (ret);
> +
> +	return 0;
> +}
> +
>  static void drbg_async_seed(struct work_struct *work)
>  {
>  	struct drbg_string data;
> @@ -1006,16 +1073,20 @@ static void drbg_async_seed(struct work_struct *work)
>  					       seed_work);
>  	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
>  	unsigned char entropy[32];
> +	int ret;
>  
>  	BUG_ON(!entropylen);
>  	BUG_ON(entropylen > sizeof(entropy));
> -	get_random_bytes(entropy, entropylen);
>  
>  	drbg_string_fill(&data, entropy, entropylen);
>  	list_add_tail(&data.list, &seedlist);
>  
>  	mutex_lock(&drbg->drbg_mutex);
>  
> +	ret = drbg_get_random_bytes(drbg, entropy, entropylen);
> +	if (ret)
> +		goto unlock;
> +
>  	/* If nonblocking pool is initialized, deactivate Jitter RNG */
>  	crypto_free_rng(drbg->jent);
>  	drbg->jent = NULL;
> @@ -1030,6 +1101,7 @@ static void drbg_async_seed(struct work_struct *work)
>  	if (drbg->seeded)
>  		drbg->reseed_threshold = drbg_max_requests(drbg);
>  
> +unlock:
>  	mutex_unlock(&drbg->drbg_mutex);
>  
>  	memzero_explicit(entropy, entropylen);
> @@ -1081,7 +1153,9 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
>  		BUG_ON((entropylen * 2) > sizeof(entropy));
>  
>  		/* Get seed from in-kernel /dev/urandom */
> -		get_random_bytes(entropy, entropylen);
> +		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
> +		if (ret)
> +			goto out;
>  
>  		if (!drbg->jent) {
>  			drbg_string_fill(&data1, entropy, entropylen);
> @@ -1094,7 +1168,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
>  						   entropylen);
>  			if (ret) {
>  				pr_devel("DRBG: jent failed with %d\n", ret);
> -				return ret;
> +				goto out;
>  			}
>  
>  			drbg_string_fill(&data1, entropy, entropylen * 2);
> @@ -1121,6 +1195,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
>  
>  	ret = __drbg_seed(drbg, &seedlist, reseed);
>  
> +out:
>  	memzero_explicit(entropy, entropylen * 2);
>  
>  	return ret;
> @@ -1142,6 +1217,11 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
>  	drbg->reseed_ctr = 0;
>  	drbg->d_ops = NULL;
>  	drbg->core = NULL;
> +	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
> +		kzfree(drbg->prev);
> +		drbg->prev = NULL;
> +		drbg->fips_primed = false;
> +	}
>  }
>  
>  /*
> @@ -1211,6 +1291,14 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
>  		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, ret + 1);
>  	}
>  
> +	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
> +		drbg->prev = kzalloc(drbg_sec_strength(drbg->core->flags),
> +				     GFP_KERNEL);
> +		if (!drbg->prev)
> +			goto fini;
> +		drbg->fips_primed = false;
> +	}
> +
>  	return 0;
>  
>  fini:
> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> index 3fb581bf3b87..8c9af21efce1 100644
> --- a/include/crypto/drbg.h
> +++ b/include/crypto/drbg.h
> @@ -129,6 +129,8 @@ struct drbg_state {
>  
>  	bool seeded;		/* DRBG fully seeded? */
>  	bool pr;		/* Prediction resistance enabled? */
> +	bool fips_primed;	/* Continuous test primed? */
> +	unsigned char *prev;	/* FIPS 140-2 continuous test value */
>  	struct work_struct seed_work;	/* asynchronous seeding support */
>  	struct crypto_rng *jent;
>  	const struct drbg_state_ops *d_ops;

Thanks.

Reviewed-by: Yann Droneaud <ydroneaud@opteya.com>

-- 
Yann Droneaud
OPTEYA




