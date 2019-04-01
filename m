Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5DDC10F05
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 15:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 089322133D
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554134196;
	bh=KCYyJlq+hx4cxGOXRidy9n4RK/dkl9GwQ1AvfuOaKKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rPm6VBXcG/FB+XbdzM7RuEK1jTCdggZEyG16kj6swkYb4qJtdF0b8GAxhYuLXpt2p
	 8uBlj5QLiEYpeZSFFGURf4Bb5ORs/10wkCxjSt9JZ8wSm387O2txqRVt6XL43CPIuF
	 Iy1UtW2Xrnhx0WN2WY0UPFHOLT1eDkEabfEwm4Ag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfDAP4f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 11:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfDAP4f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 11:56:35 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 604AE20857;
        Mon,  1 Apr 2019 15:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554134193;
        bh=KCYyJlq+hx4cxGOXRidy9n4RK/dkl9GwQ1AvfuOaKKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVBot7pDs6fBiilhwpfPqfPYsUNdztte6LF+pWhLEyOSU2AgvmuuZPGxtwlHowPOk
         3oFDWtnpBpED1YA9CUmJAJgldGCiLjDuqWBFaBK3M4WYTWojKsFkVNWrh9B1xt9cdj
         t7gnhShJddXEsI3wKVS9UTGo1U6UAvv80eW/w/wc=
Date:   Mon, 1 Apr 2019 08:56:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 07/18] crypto: gcm - fix incompatibility between
 "gcm" and "gcm_base"
Message-ID: <20190401155630.GA131675@gmail.com>
References: <20190331200428.26597-1-ebiggers@kernel.org>
 <20190331200428.26597-8-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331200428.26597-8-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 31, 2019 at 01:04:17PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> GCM instances can be created by either the "gcm" template, which only
> allows choosing the block cipher, e.g. "gcm(aes)"; or by "gcm_base",
> which allows choosing the ctr and ghash implementations, e.g.
> "gcm_base(ctr(aes-generic),ghash-generic)".
> 
> However, a "gcm_base" instance prevents a "gcm" instance from being
> registered using the same implementations.  Nor will the instance be
> found by lookups of "gcm".  This can be used as a denial of service.
> Moreover, "gcm_base" instances are never tested by the crypto
> self-tests, even if there are compatible "gcm" tests.
> 
> The root cause of these problems is that instances of the two templates
> use different cra_names.  Therefore, fix these problems by making
> "gcm_base" instances set the same cra_name as "gcm" instances, e.g.
> "gcm(aes)" instead of "gcm_base(ctr(aes-generic),ghash-generic)".
> 
> This requires extracting the block cipher name from the name of the ctr
> algorithm, which means starting to require that the stream cipher really
> be ctr and not something else.  But it would be pretty bizarre if anyone
> was actually relying on being able to use a non-ctr stream cipher here.
> 
> Fixes: d00aa19b507b ("[CRYPTO] gcm: Allow block cipher parameter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/gcm.c | 30 ++++++++----------------------
>  1 file changed, 8 insertions(+), 22 deletions(-)
> 
> diff --git a/crypto/gcm.c b/crypto/gcm.c
> index e1a11f529d257..12ff5ed569272 100644
> --- a/crypto/gcm.c
> +++ b/crypto/gcm.c
> @@ -597,7 +597,6 @@ static void crypto_gcm_free(struct aead_instance *inst)
>  
>  static int crypto_gcm_create_common(struct crypto_template *tmpl,
>  				    struct rtattr **tb,
> -				    const char *full_name,
>  				    const char *ctr_name,
>  				    const char *ghash_name)
>  {
> @@ -650,24 +649,23 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
>  
>  	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
>  
> -	/* We only support 16-byte blocks. */
> +	/* Must be CTR mode with 16-byte blocks. */
>  	err = -EINVAL;
> -	if (crypto_skcipher_alg_ivsize(ctr) != 16)
> +	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
> +	    crypto_skcipher_alg_ivsize(ctr) != 16)
>  		goto out_put_ctr;
>  
> -	/* Not a stream cipher? */
> -	if (ctr->base.cra_blocksize != 1)
> +	err = -ENAMETOOLONG;
> +	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
> +		     "gcm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
>  		goto out_put_ctr;
>  
> -	err = -ENAMETOOLONG;
>  	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
>  		     "gcm_base(%s,%s)", ctr->base.cra_driver_name,
>  		     ghash_alg->cra_driver_name) >=
>  	    CRYPTO_MAX_ALG_NAME)
>  		goto out_put_ctr;
>  
> -	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
> -
>  	inst->alg.base.cra_flags = (ghash->base.cra_flags |
>  				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
>  	inst->alg.base.cra_priority = (ghash->base.cra_priority +
> @@ -709,7 +707,6 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
>  {
>  	const char *cipher_name;
>  	char ctr_name[CRYPTO_MAX_ALG_NAME];
> -	char full_name[CRYPTO_MAX_ALG_NAME];
>  
>  	cipher_name = crypto_attr_alg_name(tb[1]);
>  	if (IS_ERR(cipher_name))
> @@ -719,12 +716,7 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	    CRYPTO_MAX_ALG_NAME)
>  		return -ENAMETOOLONG;
>  
> -	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm(%s)", cipher_name) >=
> -	    CRYPTO_MAX_ALG_NAME)
> -		return -ENAMETOOLONG;
> -
> -	return crypto_gcm_create_common(tmpl, tb, full_name,
> -					ctr_name, "ghash");
> +	return crypto_gcm_create_common(tmpl, tb, ctr_name, "ghash");
>  }
>  
>  static int crypto_gcm_base_create(struct crypto_template *tmpl,
> @@ -732,7 +724,6 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
>  {
>  	const char *ctr_name;
>  	const char *ghash_name;
> -	char full_name[CRYPTO_MAX_ALG_NAME];
>  
>  	ctr_name = crypto_attr_alg_name(tb[1]);
>  	if (IS_ERR(ctr_name))
> @@ -742,12 +733,7 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
>  	if (IS_ERR(ghash_name))
>  		return PTR_ERR(ghash_name);
>  
> -	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
> -		     ctr_name, ghash_name) >= CRYPTO_MAX_ALG_NAME)
> -		return -ENAMETOOLONG;
> -
> -	return crypto_gcm_create_common(tmpl, tb, full_name,
> -					ctr_name, ghash_name);
> +	return crypto_gcm_create_common(tmpl, tb, ctr_name, ghash_name);
>  }
>  
>  static int crypto_rfc4106_setkey(struct crypto_aead *parent, const u8 *key,
> -- 
> 2.21.0
> 

Oops, I think there's a bug here: we also need to check that the hash algorithm
passed to gcm_base is really "ghash".  Similarly, in the next patch, ccm_base
requires "cbcmac".

- Eric
