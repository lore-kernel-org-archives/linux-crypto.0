Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06738C5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC8B62084D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfIKP3w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:29:52 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44309 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfIKP3w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:29:52 -0400
X-Originating-IP: 148.69.85.38
Received: from localhost (unknown [148.69.85.38])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id EBD82C000C;
        Wed, 11 Sep 2019 15:29:48 +0000 (UTC)
Date:   Wed, 11 Sep 2019 16:29:47 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 2/2] crypto: inside-secure - Add support for the
 Chacha20-Poly1305 AEAD
Message-ID: <20190911152947.GB5492@kwain>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-3-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1568126293-4039-3-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Pascal,

On Tue, Sep 10, 2019 at 04:38:13PM +0200, Pascal van Leeuwen wrote:
> @@ -43,8 +44,8 @@ struct safexcel_cipher_ctx {
>  
>  	u32 mode;
>  	enum safexcel_cipher_alg alg;
> -	bool aead;
> -	int  xcm; /* 0=authenc, 1=GCM, 2 reserved for CCM */
> +	char aead; /* !=0=AEAD, 2=IPSec ESP AEAD */
> +	char xcm;  /* 0=authenc, 1=GCM, 2 reserved for CCM */

You could use an u8 instead. It also seems the aead comment has an
issue, I'll let you check that.

> -		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
> +		dev_err(priv->dev, "aead: unsupported hash algorithmn");

You remove the '\' here.

> @@ -440,6 +459,17 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
>  				CONTEXT_CONTROL_DIGEST_XCM |
>  				ctx->hash_alg |
>  				CONTEXT_CONTROL_SIZE(ctrl_size);
> +		} else if (ctx->alg == SAFEXCEL_CHACHA20) {
> +			/* Chacha20-Poly1305 */
> +			cdesc->control_data.control0 =
> +				CONTEXT_CONTROL_KEY_EN |
> +				CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20 |
> +				(sreq->direction == SAFEXCEL_ENCRYPT ?
> +					CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT :
> +					CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN) |
> +				ctx->hash_alg |
> +				CONTEXT_CONTROL_SIZE(ctrl_size);

I think you could use an if + |= for readability here.

> +static int safexcel_aead_chachapoly_crypt(struct aead_request *req,
> +					  enum safexcel_cipher_direction dir)
> +{
> +	struct safexcel_cipher_req *creq = aead_request_ctx(req);
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> +	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct aead_request *subreq = aead_request_ctx(req);
> +	u32 key[CHACHA_KEY_SIZE / sizeof(u32) + 1];

Shouldn't you explicitly memzero the key at the end of the function?

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
