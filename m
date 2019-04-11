Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE6BC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 09:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF1D20850
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 09:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ZwPdiGXZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfDKJ2B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:28:01 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:18484 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfDKJ2A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 05:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1554974875;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=kmndxOeXQUvS9+uIy/B/SNrWvaFypAxwZKTCnGJj7gs=;
        b=ZwPdiGXZgPmhSWDnfluXlv8OpKNmPuqUs8Qx64eZq1VmPBvamCd8Yr6eT1zCXjBTbl
        ARxc6iCntRl9cqXyLSC/l4wXePvJ+xr2iWyQ28yhqpIT6nhAzYOKibhy3cJyUkVA5ixv
        238ZLgg5MxCbSr8ISarkIoeCb7XkJmwRdwTAqsGc3o3LYO3zm9k+jfdvKxRMSbjoE3s/
        Mirl3hEikgsmwEWq6vlJZ/XFo7rSW3XD4D7hos2qEeCYraFU+BVWG3YPBc9wEsSQ/mzU
        VirUFB1rlWxNdNBNsmlkruOPeETvv6JS6c1w7b0qQAk2tz1io9A7Ub0inOu9lRT+QXet
        nfbg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmcHKf2haCKHXPG347ZF"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv3B9RsCDv
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 11 Apr 2019 11:27:54 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 10/24] crypto: ccree - Forbid 2-key 3DES in FIPS mode
Date:   Thu, 11 Apr 2019 11:27:54 +0200
Message-ID: <2919231.mFyek56I8j@tauon.chronox.de>
In-Reply-To: <E1hEVQI-0006mq-Kd@gondobar>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au> <E1hEVQI-0006mq-Kd@gondobar>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 11. April 2019, 10:51:06 CEST schrieb Herbert Xu:

Hi Herbert,

> This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/crypto/ccree/cc_aead.c |   37 +++++++++++++++++++++++++++++++++++--
> 1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
> index a3527c00b29a..c5cde327cf1f 100644
> --- a/drivers/crypto/ccree/cc_aead.c
> +++ b/drivers/crypto/ccree/cc_aead.c
> @@ -650,6 +650,39 @@ static int cc_aead_setkey(struct crypto_aead *tfm,
> const u8 *key, return rc;
>  }
> 
> +static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
> +			       unsigned int keylen)

This function looks very similar to des3_aead_setkey in the different caam 
code changes.

Thus, wouldn't it be better to have common service function?
> +{
> +	struct crypto_authenc_keys keys;
> +	u32 flags;
> +	int err;
> +
> +	err = crypto_authenc_extractkeys(&keys, key, keylen);
> +	if (unlikely(err))
> +		goto badkey;
> +
> +	err = -EINVAL;
> +	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
> +		goto badkey;
> +
> +	flags = crypto_aead_get_flags(aead);
> +	err = __des3_verify_key(&flags, keys.enckey);
> +	if (unlikely(err)) {
> +		crypto_aead_set_flags(aead, flags);
> +		goto out;
> +	}
> +
> +	err = cc_aead_setkey(aead, key, keylen);
> +
> +out:
> +	memzero_explicit(&keys, sizeof(keys));
> +	return err;
> +
> +badkey:
> +	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +	goto out;
> +}
> +
>  static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
>  				 unsigned int keylen)
>  {
> @@ -2372,7 +2405,7 @@ static struct cc_alg_template aead_algs[] = {
>  		.driver_name = "authenc-hmac-sha1-cbc-des3-ccree",
>  		.blocksize = DES3_EDE_BLOCK_SIZE,
>  		.template_aead = {
> -			.setkey = cc_aead_setkey,
> +			.setkey = cc_des3_aead_setkey,
>  			.setauthsize = cc_aead_setauthsize,
>  			.encrypt = cc_aead_encrypt,
>  			.decrypt = cc_aead_decrypt,
> @@ -2412,7 +2445,7 @@ static struct cc_alg_template aead_algs[] = {
>  		.driver_name = "authenc-hmac-sha256-cbc-des3-ccree",
>  		.blocksize = DES3_EDE_BLOCK_SIZE,
>  		.template_aead = {
> -			.setkey = cc_aead_setkey,
> +			.setkey = cc_des3_aead_setkey,
>  			.setauthsize = cc_aead_setauthsize,
>  			.encrypt = cc_aead_encrypt,
>  			.decrypt = cc_aead_decrypt,



Ciao
Stephan


