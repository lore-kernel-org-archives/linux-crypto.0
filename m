Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C953DC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C286218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGCN4h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:56:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50868 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCN4h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 09:56:37 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hifkR-0008Bz-RW; Wed, 03 Jul 2019 21:56:35 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hifkO-0003w3-IT; Wed, 03 Jul 2019 21:56:32 +0800
Date:   Wed, 3 Jul 2019 21:56:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        horia.geanta@nxp.com
Subject: Re: [PATCH v3 27/30] crypto: des - split off DES library from
 generic DES cipher driver
Message-ID: <20190703135632.cizz77mr7ur3tii7@gondor.apana.org.au>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
 <20190628093529.12281-28-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628093529.12281-28-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 11:35:26AM +0200, Ard Biesheuvel wrote:
>
>  static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
>  		      unsigned int keylen)
>  {
>  	struct des_ctx *dctx = crypto_tfm_ctx(tfm);
> -	u32 *flags = &tfm->crt_flags;
> -	u32 tmp[DES_EXPKEY_WORDS];
> -	int ret;
> -
> -	/* Expand to tmp */
> -	ret = des_ekey(tmp, key);
> +	int err;
>  
> -	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
> -		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
> -		return -EINVAL;
> +	err = des_expand_key(dctx, key, keylen);
> +	if (err == -ENOKEY) {
> +		if (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)
> +			err = -EINVAL;
> +		else
> +			err = 0;
>  	}
>  
> -	/* Copy to output */
> -	memcpy(dctx->expkey, tmp, sizeof(dctx->expkey));
> -
> -	return 0;
> +	if (err) {
> +		memzero_explicit(dctx, sizeof(*dctx));

This should use memset as it's not a stack location.  Ditto with
the 3DES version below.  It may not look like a big deal but we
sometimes get bogus patches that convert such memsets to memzeros
and being consistent with our own usage might discourage them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
