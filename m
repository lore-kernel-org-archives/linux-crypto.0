Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E47C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5172208E3
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561652173;
	bh=VUlxJZUszv89mJikE+fSKgQvFjP6iFyqQWfMETD6NIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JnA25fQORuFCwuA70PSZNPj5NuFkEgDiXFJDPfwSmYfKeLOLrTeMfmKSA2/TobZ5P
	 5CY9Y02/iUHTJeo0D1Nczk/xr31A1LcdKSRzmN6eAWYvo4+MhaDOWxS7/SMU3Dzr5T
	 qsOxRPOlSoc+WIIzhSdMG8eY+3iDBGqFEMq5mIbY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfF0QQM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 12:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfF0QQM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 12:16:12 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7538620659;
        Thu, 27 Jun 2019 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561652171;
        bh=VUlxJZUszv89mJikE+fSKgQvFjP6iFyqQWfMETD6NIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qlTZST2RziIoPliKzVUlsNnQDRS/HV9zARO4sXQgGa6RArqO4Nz9S84nAsmNLHtpO
         3EmDsx0BouC/mK0vrFxzM1wmR5mTS2o8E3YuHoTXX8hAAf4GSST4QpaA1kgXwANhgk
         w8MXRoCrly+RQ9qD+56uS3sPxSKdjxnTFoQ0vHR8=
Date:   Thu, 27 Jun 2019 09:16:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com
Subject: Re: [PATCH v2 22/30] crypto: sun4i/des - switch to new verification
 routines
Message-ID: <20190627161609.GA686@sol.localdomain>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
 <20190627120314.7197-23-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627120314.7197-23-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 27, 2019 at 02:03:06PM +0200, Ard Biesheuvel wrote:
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 22 ++++----------------
>  drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
>  2 files changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> index b060a0810934..93b383654af0 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -533,25 +533,11 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  			unsigned int keylen)
>  {
>  	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
> -	struct sun4i_ss_ctx *ss = op->ss;
> -	u32 flags;
> -	u32 tmp[DES_EXPKEY_WORDS];
>  	int ret;
>  
> -	if (unlikely(keylen != DES_KEY_SIZE)) {
> -		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
> -		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> -		return -EINVAL;
> -	}
> -
> -	flags = crypto_skcipher_get_flags(tfm);
> -
> -	ret = des_ekey(tmp, key);
> -	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
> -		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
> -		dev_dbg(ss->dev, "Weak key %u\n", keylen);
> -		return -EINVAL;
> -	}
> +	err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key);
> +	if (unlikely(err))
> +		return err;
>  
>  	op->keylen = keylen;
>  	memcpy(op->key, key, keylen);
> @@ -569,7 +555,7 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
>  	int err;
>  
> -	err = des3_verify_key(tfm, key);
> +	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key);
>  	if (unlikely(err))
>  		return err;
>  

There is a build error here:

drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_des_setkey':
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:538:2: error: 'err' undeclared (first use in this function)
  err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key);
  ^~~
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:538:2: note: each undeclared identifier is reported only once for each function it appears in
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:536:6: warning: unused variable 'ret' [-Wunused-variable]
  int ret;
      ^~~
