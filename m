Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BCFC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA8460F90
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhJZJVl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:21:41 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:30720 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbhJZJVk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 05:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635239955;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=rvQ+F+5xOwdTXO4AxHW8+3kJmt8W1va1H6CgvBPSPeE=;
    b=NE+EzvHzwAkI1/aDeB0cDtQ689fQLtluFtUaLR5RQljVfpceIRbKw5gzyEBSz2tME+
    ltMukJOVzap5H3QYwFx57VgrEPp9r3/t+gQCe3xIRHFQXy2o3zEmI6r1J0z6G4JpKRcN
    HhDzofWDh10CcmPBc7CVDJJQWMT/hC7LzFvvOi2ef6cWn+pm0bfXImJEBUwgeP1STSkN
    hEvUB7ILcBGzjMpNK0l5lnwIYODp2uRcNvCqiLOI8AO3YLwli2ENxaATR/t9VfLg9Lt4
    znCdDLxtw8Uw82d8uNgO4PaUleSylETaboYIk7HfTrWiA7OWgpQ0mHjl5MDIktq7JCvj
    5kWg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9Q9JE2I9
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 26 Oct 2021 11:19:14 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 4/6] crypto: DRBG - make reseeding from get_random_bytes() synchronous
Date:   Tue, 26 Oct 2021 11:19:14 +0200
Message-ID: <7177269.TAkDSPn55A@positron.chronox.de>
In-Reply-To: <20211025092525.12805-5-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <20211025092525.12805-5-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 25. Oktober 2021, 11:25:23 CEST schrieb Nicolai Stange:

Hi Nicolai,

> get_random_bytes() usually hasn't full entropy available by the time DRBG
> instances are first getting seeded from it during boot. Thus, the DRBG
> implementation registers random_ready_callbacks which would in turn
> schedule some work for reseeding the DRBGs once get_random_bytes() has
> sufficient entropy available.
> 
> For reference, the relevant history around handling DRBG (re)seeding in
> the context of a not yet fully seeded get_random_bytes() is:
> 
>   commit 16b369a91d0d ("random: Blocking API for accessing
>                         nonblocking_pool")
>   commit 4c7879907edd ("crypto: drbg - add async seeding operation")
> 
>   commit 205a525c3342 ("random: Add callback API for random pool
>                         readiness")
>   commit 57225e679788 ("crypto: drbg - Use callback API for random
>                         readiness")
>   commit c2719503f5e1 ("random: Remove kernel blocking API")
> 
> However, some time later, the initialization state of get_random_bytes()
> has been made queryable via rng_is_initialized() introduced with commit
> 9a47249d444d ("random: Make crng state queryable"). This primitive now
> allows for streamlining the DRBG reseeding from get_random_bytes() by
> replacing that aforementioned asynchronous work scheduling from
> random_ready_callbacks with some simpler, synchronous code in
> drbg_generate() next to the related logic already present therein. Apart
> from improving overall code readability, this change will also enable DRBG
> users to rely on wait_for_random_bytes() for ensuring that the initial
> seeding has completed, if desired.
> 
> The previous patches already laid the grounds by making drbg_seed() to
> record at each DRBG instance whether it was being seeded at a time when
> rng_is_initialized() still had been false as indicated by
> ->seeded == DRBG_SEED_STATE_PARTIAL.
> 
> All that remains to be done now is to make drbg_generate() check for this
> condition, determine whether rng_is_initialized() has flipped to true in
> the meanwhile and invoke a reseed from get_random_bytes() if so.
> 
> Make this move:
> - rename the former drbg_async_seed() work handler, i.e. the one in charge
>   of reseeding a DRBG instance from get_random_bytes(), to
>   "drbg_seed_from_random()",
> - change its signature as appropriate, i.e. make it take a struct
>   drbg_state rather than a work_struct and change its return type from
>   "void" to "int" in order to allow for passing error information from
>   e.g. its __drbg_seed() invocation onwards to callers,
> - make drbg_generate() invoke this drbg_seed_from_random() once it
>   encounters a DRBG instance with ->seeded == DRBG_SEED_STATE_PARTIAL by
>   the time rng_is_initialized() has flipped to true and
> - prune everything related to the former, random_ready_callback based
>   mechanism.
> 
> As drbg_seed_from_random() is now getting invoked from drbg_generate() with
> the ->drbg_mutex being held, it must not attempt to recursively grab it
> once again. Remove the corresponding mutex operations from what is now
> drbg_seed_from_random(). Furthermore, as drbg_seed_from_random() can now
> report errors directly to its caller, there's no need for it to temporarily
> switch the DRBG's ->seeded state to DRBG_SEED_STATE_UNSEEDED so that a
> failure of the subsequently invoked __drbg_seed() will get signaled to
> drbg_generate(). Don't do it then.

The code change in general looks good. But the code change seems to now imply 
that the DRBG only gets fully seeded when its internal reseed operation is 
invoked again - during boot time this is after the elapse of 50 generate 
operations (or in your later patch after the elapse of 5 minutes). I.e. it is 
not immediately reseeded when random.c turns to fully seeded and 
rng_is_initialized() would turn true. So, the DRBG seems to run still 
partially seeded even though it could already be fully seeded, no?
> 
> Signed-off-by: Nicolai Stange <nstange@suse.de>
> ---
>  crypto/drbg.c         | 64 +++++++++----------------------------------
>  include/crypto/drbg.h |  2 --
>  2 files changed, 13 insertions(+), 53 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 6aad210f101a..d9f7dddfd683 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1087,12 +1087,10 @@ static inline int drbg_get_random_bytes(struct
> drbg_state *drbg, return 0;
>  }
> 
> -static void drbg_async_seed(struct work_struct *work)
> +static int drbg_seed_from_random(struct drbg_state *drbg)
>  {
>  	struct drbg_string data;
>  	LIST_HEAD(seedlist);
> -	struct drbg_state *drbg = container_of(work, struct drbg_state,
> -					       seed_work);
>  	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
>  	unsigned char entropy[32];
>  	int ret;
> @@ -1103,23 +1101,17 @@ static void drbg_async_seed(struct work_struct
> *work) drbg_string_fill(&data, entropy, entropylen);
>  	list_add_tail(&data.list, &seedlist);
> 
> -	mutex_lock(&drbg->drbg_mutex);
> -
>  	ret = drbg_get_random_bytes(drbg, entropy, entropylen);
>  	if (ret)
> -		goto unlock;
> -
> -	/* Reset ->seeded so that if __drbg_seed fails the next
> -	 * generate call will trigger a reseed.
> -	 */
> -	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
> -
> -	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
> +		goto out;
> 
> -unlock:
> -	mutex_unlock(&drbg->drbg_mutex);
> +	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
> +	if (ret)
> +		goto out;

Is this last check for ret truly needed considering the goto target is the 
next line?
> 
> +out:
>  	memzero_explicit(entropy, entropylen);
> +	return ret;
>  }
> 
>  /*
> @@ -1422,6 +1414,11 @@ static int drbg_generate(struct drbg_state *drbg,
>  			goto err;
>  		/* 9.3.1 step 7.4 */
>  		addtl = NULL;
> +	} else if (rng_is_initialized() &&
> +		   drbg->seeded == DRBG_SEED_STATE_PARTIAL) {
> +		len = drbg_seed_from_random(drbg);
> +		if (len)
> +			goto err;
>  	}
> 
>  	if (addtl && 0 < addtl->len)
> @@ -1514,45 +1511,15 @@ static int drbg_generate_long(struct drbg_state
> *drbg, return 0;
>  }
> 
> -static void drbg_schedule_async_seed(struct random_ready_callback *rdy)
> -{
> -	struct drbg_state *drbg = container_of(rdy, struct drbg_state,
> -					       random_ready);
> -
> -	schedule_work(&drbg->seed_work);
> -}
> -
>  static int drbg_prepare_hrng(struct drbg_state *drbg)
>  {
> -	int err;
> -
>  	/* We do not need an HRNG in test mode. */
>  	if (list_empty(&drbg->test_data.list))
>  		return 0;
> 
>  	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
> 
> -	INIT_WORK(&drbg->seed_work, drbg_async_seed);
> -
> -	drbg->random_ready.owner = THIS_MODULE;
> -	drbg->random_ready.func = drbg_schedule_async_seed;
> -
> -	err = add_random_ready_callback(&drbg->random_ready);
> -
> -	switch (err) {
> -	case 0:
> -		break;
> -
> -	case -EALREADY:
> -		err = 0;
> -		fallthrough;
> -
> -	default:
> -		drbg->random_ready.func = NULL;
> -		return err;
> -	}
> -
> -	return err;
> +	return 0;
>  }
> 
>  /*
> @@ -1646,11 +1613,6 @@ static int drbg_instantiate(struct drbg_state *drbg,
> struct drbg_string *pers, */
>  static int drbg_uninstantiate(struct drbg_state *drbg)
>  {
> -	if (drbg->random_ready.func) {
> -		del_random_ready_callback(&drbg->random_ready);
> -		cancel_work_sync(&drbg->seed_work);
> -	}
> -
>  	if (!IS_ERR_OR_NULL(drbg->jent))
>  		crypto_free_rng(drbg->jent);
>  	drbg->jent = NULL;
> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> index 3ebdb1effe74..a6c3b8e7deb6 100644
> --- a/include/crypto/drbg.h
> +++ b/include/crypto/drbg.h
> @@ -137,12 +137,10 @@ struct drbg_state {
>  	bool pr;		/* Prediction resistance enabled? */
>  	bool fips_primed;	/* Continuous test primed? */
>  	unsigned char *prev;	/* FIPS 140-2 continuous test value */
> -	struct work_struct seed_work;	/* asynchronous seeding support */
>  	struct crypto_rng *jent;
>  	const struct drbg_state_ops *d_ops;
>  	const struct drbg_core *core;
>  	struct drbg_string test_data;
> -	struct random_ready_callback random_ready;
>  };
> 
>  static inline __u8 drbg_statelen(struct drbg_state *drbg)


Ciao
Stephan


