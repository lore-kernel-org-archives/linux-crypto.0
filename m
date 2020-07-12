Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A737C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 18:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0693206F0
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 18:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgGLSGR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 14:06:17 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:58530 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbgGLSGR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 14:06:17 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id DC26972CCF6;
        Sun, 12 Jul 2020 21:06:13 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id C5BF44A4AEE;
        Sun, 12 Jul 2020 21:06:13 +0300 (MSK)
Date:   Sun, 12 Jul 2020 21:06:13 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 5/5] crypto: ECDH SP800-56A rev 3 local public key
 validation
Message-ID: <20200712180613.dkzaklumuxndpgfw@altlinux.org>
Mail-Followup-To: Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <3168469.44csPzL39Z@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3168469.44csPzL39Z@positron.chronox.de>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stephan,

On Sun, Jul 12, 2020 at 06:42:14PM +0200, Stephan Müller wrote:
> After the generation of a local public key, SP800-56A rev 3 section
> 5.6.2.1.3 mandates a validation of that key with a full validation
> compliant to section 5.6.2.3.3.
> 
> Only if the full validation passes, the key is allowed to be used.
> 
> The patch adds the full key validation compliant to 5.6.2.3.3 and
> performs the required check on the generated public key.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/ecc.c | 31 ++++++++++++++++++++++++++++++-
>  crypto/ecc.h | 14 ++++++++++++++
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 52e2d49262f2..7308487e7c55 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1404,7 +1404,9 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
>  	}
>  
>  	ecc_point_mult(pk, &curve->g, priv, NULL, curve, ndigits);
> -	if (ecc_point_is_zero(pk)) {
> +
> +	/* SP800-56A rev 3 5.6.2.1.3 key check */
> +	if (ecc_is_pubkey_valid_full(curve, pk)) {
>  		ret = -EAGAIN;
>  		goto err_free_point;
>  	}
> @@ -1452,6 +1454,33 @@ int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
>  }
>  EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
>  
> +/* SP800-56A section 5.6.2.3.3 full verification */

Btw, 5.6.2.3.3 is partial validation, 5.6.2.3.2 is full validation
routine.

Thanks,

> +int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
> +			     struct ecc_point *pk)
> +{
> +	struct ecc_point *nQ;
> +
> +	/* Checks 1 through 3 */
> +	int ret = ecc_is_pubkey_valid_partial(curve, pk);
> +
> +	if (ret)
> +		return ret;
> +
> +	/* Check 4: Verify that nQ is the zero point. */
> +	nQ = ecc_alloc_point(pk->ndigits);
> +	if (!nQ)
> +		return -ENOMEM;
> +
> +	ecc_point_mult(nQ, pk, curve->n, NULL, curve, pk->ndigits);
> +	if (!ecc_point_is_zero(nQ))
> +		ret = -EINVAL;
> +
> +	ecc_free_point(nQ);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ecc_is_pubkey_valid_full);
> +
>  int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
>  			      const u64 *private_key, const u64 *public_key,
>  			      u64 *secret)
> diff --git a/crypto/ecc.h b/crypto/ecc.h
> index ab0eb70b9c09..d4e546b9ad79 100644
> --- a/crypto/ecc.h
> +++ b/crypto/ecc.h
> @@ -147,6 +147,20 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
>  int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
>  				struct ecc_point *pk);
>  
> +/**
> + * ecc_is_pubkey_valid_full() - Full public key validation
> + *
> + * @curve:		elliptic curve domain parameters
> + * @pk:			public key as a point
> + *
> + * Valdiate public key according to SP800-56A section 5.6.2.3.3 ECC Full
> + * Public-Key Validation Routine.
> + *
> + * Return: 0 if validation is successful, -EINVAL if validation is failed.
> + */
> +int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
> +			     struct ecc_point *pk);
> +
>  /**
>   * vli_is_zero() - Determine is vli is zero
>   *
> -- 
> 2.26.2
> 
> 
> 
