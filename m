Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81545C636D7
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 05:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjBPFpX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 00:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjBPFpQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 00:45:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D6546D5C
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 21:45:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A72A61E80
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2008C433D2;
        Thu, 16 Feb 2023 05:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526314;
        bh=EwtjJeDJxWFtVB/8ZY3zbDUffGozxteZSy0BERbvScM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IqI0e9SaD5OHBi5/4On3BHitVb7nIi2GGPSB7QNOwI/14LL1NnM4C8KRFTyji2+nl
         BBrGEyf0y6UYLFZrG3pwjLOeSQExe8rLRDiMyqSLl+NLQMWmrj2ET33TjwlSK97WnP
         0vbVr/LRtRgP46l0PlS7f+zm71AZ5vfcz/JFvN1seqDmK59HbopRoJvb5W8z0vvZTj
         3820VfHbp/8eHIjMYABQmqBp7gcnk7v0AaFrDGOwl+04ivzAYZLQlU3j5u5r4mDBna
         yJX6Mn7B9Tt8I0cR6d1ett2BzFzi7HRY0CtXaF9ajEyumb5d17KTC5gyhb7Glvs9Wf
         4RV/+oTqQEHXQ==
Date:   Wed, 15 Feb 2023 21:45:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/10] crypto: aead - Count error stats differently
Message-ID: <Y+3C6f/W4fHtVgnM@sol.localdomain>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A couple more comments:

On Wed, Feb 15, 2023 at 05:25:09PM +0800, Herbert Xu wrote:
> +static int crypto_aead_report_stat(struct sk_buff *skb, struct crypto_alg *alg)
> +	__maybe_unused;
> +static int crypto_aead_report_stat(struct sk_buff *skb, struct crypto_alg *alg)

This could be just:

static int __maybe_unused
crypto_aead_report_stat(struct sk_buff *skb, struct crypto_alg *alg)

> +{
> +	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
> +	struct crypto_istat_aead *istat = aead_get_stat(aead);
> +	struct crypto_stat_aead raead;
> +
> +	memset(&raead, 0, sizeof(raead));
> +
> +	strscpy(raead.type, "aead", sizeof(raead.type));
> +
> +	raead.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
> +	raead.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
> +	raead.stat_decrypt_cnt = atomic64_read(&istat->decrypt_cnt);
> +	raead.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
> +	raead.stat_err_cnt = atomic64_read(&istat->err_cnt);
> +
> +	return nla_put(skb, CRYPTOCFGA_STAT_AEAD, sizeof(raead), &raead);
> +}

But actually it might be better to keep #ifdef-ing this whole function out when
!CONFIG_CRYPTO_STATS, since in that case it contains an unconditional null
pointer dereference.  Yes, it's not executed, but it might be confusing.

>  static int aead_prepare_alg(struct aead_alg *alg)
>  {
> +	struct crypto_istat_aead *istat = aead_get_stat(alg);
>  	struct crypto_alg *base = &alg->base;
>  
>  	if (max3(alg->maxauthsize, alg->ivsize, alg->chunksize) >
> @@ -232,6 +292,9 @@ static int aead_prepare_alg(struct aead_alg *alg)
>  	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
>  	base->cra_flags |= CRYPTO_ALG_TYPE_AEAD;
>  
> +	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> +		memset(istat, 0, sizeof(*istat));
> +

Above is another place that can just do 'if (istat)'.

- Eric
