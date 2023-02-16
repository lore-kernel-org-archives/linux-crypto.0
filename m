Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EE1C636CC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 05:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjBPFfk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 00:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjBPFfj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 00:35:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5228B43450
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 21:35:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E23D36134F
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D643C433D2;
        Thu, 16 Feb 2023 05:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676525723;
        bh=s7NYdflzTd9WYWcKE8S32stBKWVJau7UrZknQip4Nhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYAXCzmlIV1lGNgs7CW+3fSMhcLpSl2wWscAWvxcXRQxciEADzZTUcKJvRnP8r3Yg
         eTNnnSyiHll1dT7/iVZ9+38QXWBsclA/TxM3sLs4jWaFrJby5OcBSIx9fFhpTT3DTS
         cogr+lmwFdO0MYsk87E1KeAcxymfBk+aBHZTSdVLEAmwd5O/YshAJtjo8XZqWz4kFB
         qV/ObJ6+ZYaI0i6HayFNNSf95e8z6WXMhUKFVafvrzjLf+u0fXoYRRXJb0BCN0m+2E
         nI4B5NwHsI1KMF/BheiwHZAQfyar9q1Aa+bz8Rhl+XY0e1ySzw8X/gYVgjHvL7taWh
         nWV7FT6XTCD6g==
Date:   Wed, 15 Feb 2023 21:35:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/10] crypto: aead - Count error stats differently
Message-ID: <Y+3AmZaoNJBO4xU0@sol.localdomain>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 05:25:09PM +0800, Herbert Xu wrote:
>  int crypto_aead_encrypt(struct aead_request *req)
>  {
>  	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -	struct crypto_alg *alg = aead->base.__crt_alg;
> +	struct aead_alg *alg = crypto_aead_alg(aead);
>  	unsigned int cryptlen = req->cryptlen;

The cryptlen local variable is no longer needed.  Just use req->cryptlen below.

> +	struct crypto_istat_aead *istat;
>  	int ret;
>  
> -	crypto_stats_get(alg);
> +	istat = aead_get_stat(alg);
> +
> +	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
> +		atomic64_inc(&istat->encrypt_cnt);
> +		atomic64_add(cryptlen, &istat->encrypt_tlen);
> +	}
> +

This could just check whether istat is NULL:

	istat = aead_get_stat(alg);
	if (istat) {
		atomic64_inc(&istat->encrypt_cnt);
		atomic64_add(req->cryptlen, &istat->encrypt_tlen);
	}

That's simpler, and it makes it clearer that the pointer is not dereferenced
when it is NULL.

Note that aead_get_stat() is an inline function, so the stats code will still be
optimized out when !CONFIG_CRYPTO_STATS.

> +static inline int crypto_aead_errstat(struct crypto_istat_aead *istat, int err)
> +{
> +	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
> +		return err;
> +
> +	if (err && err != -EINPROGRESS && err != -EBUSY)
> +		atomic64_inc(&istat->err_cnt);
> +
> +	return err;
> +}
> +
[...]
>  	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
>  		ret = -ENOKEY;
>  	else
> -		ret = crypto_aead_alg(aead)->encrypt(req);
> -	crypto_stats_aead_encrypt(cryptlen, alg, ret);
> -	return ret;
> +		ret = alg->encrypt(req);
> +
> +	return crypto_aead_errstat(istat, ret);

Similarly, istat != NULL could be used instead of CONFIG_CRYPTO_STATS.

IMO, this would also be easier to read if the stats increment was just coded
directly, like it is above, without the crypto_aead_errstat() function:

	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
		ret = -ENOKEY;
	else
		ret = alg->encrypt(req);

	if (istat && ret && ret != -EINPROGRESS && ret != -EBUSY)
		atomic64_inc(&istat->err_cnt);

	return ret;

Similarly for all the other algorithm types.

- Eric
