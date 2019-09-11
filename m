Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AFFC49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF512085B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfIKPmD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:42:03 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:48725 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbfIKPmD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:42:03 -0400
X-Originating-IP: 148.69.85.38
Received: from localhost (unknown [148.69.85.38])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 2D79524000A;
        Wed, 11 Sep 2019 15:42:01 +0000 (UTC)
Date:   Wed, 11 Sep 2019 16:41:59 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 2/3] crypto: inside-secure - Added support for HMAC-SM3
 ahash
Message-ID: <20190911154159.GD5492@kwain>
References: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568187671-8540-3-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1568187671-8540-3-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 11, 2019 at 09:41:10AM +0200, Pascal van Leeuwen wrote:
> Added support for the hmac(sm3) ahash authentication algorithm
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel.c      |  1 +
>  drivers/crypto/inside-secure/safexcel.h      |  1 +
>  drivers/crypto/inside-secure/safexcel_hash.c | 70 ++++++++++++++++++++++++++++
>  3 files changed, 72 insertions(+)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 826d1fb..7d907d5 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1177,6 +1177,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
>  	&safexcel_alg_chachapoly,
>  	&safexcel_alg_chachapoly_esp,
>  	&safexcel_alg_sm3,
> +	&safexcel_alg_hmac_sm3,
>  };
>  
>  static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index fc2aba2..7ee09fe 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -871,5 +871,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
>  extern struct safexcel_alg_template safexcel_alg_chachapoly;
>  extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
>  extern struct safexcel_alg_template safexcel_alg_sm3;
> +extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
>  
>  #endif
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index a4107bb..fdf4bcc 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -2280,3 +2280,73 @@ struct safexcel_alg_template safexcel_alg_sm3 = {
>  		},
>  	},
>  };
> +
> +static int safexcel_hmac_sm3_setkey(struct crypto_ahash *tfm, const u8 *key,
> +				    unsigned int keylen)
> +{
> +	return safexcel_hmac_alg_setkey(tfm, key, keylen, "safexcel-sm3",
> +					SM3_DIGEST_SIZE);
> +}
> +
> +static int safexcel_hmac_sm3_init(struct ahash_request *areq)
> +{
> +	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
> +	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
> +
> +	memset(req, 0, sizeof(*req));
> +
> +	/* Start from ipad precompute */
> +	memcpy(req->state, ctx->ipad, SM3_DIGEST_SIZE);
> +	/* Already processed the key^ipad part now! */
> +	req->len	= SM3_BLOCK_SIZE;
> +	req->processed	= SM3_BLOCK_SIZE;
> +
> +	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SM3;
> +	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
> +	req->state_sz = SM3_DIGEST_SIZE;
> +	req->block_sz = SM3_BLOCK_SIZE;
> +	req->hmac = true;
> +
> +	return 0;
> +}
> +
> +static int safexcel_hmac_sm3_digest(struct ahash_request *areq)
> +{
> +	int ret = safexcel_hmac_sm3_init(areq);
> +
> +	if (ret)
> +		return ret;
> +
> +	return safexcel_ahash_finup(areq);
> +}
> +
> +struct safexcel_alg_template safexcel_alg_hmac_sm3 = {
> +	.type = SAFEXCEL_ALG_TYPE_AHASH,
> +	.algo_mask = SAFEXCEL_ALG_SM3,
> +	.alg.ahash = {
> +		.init = safexcel_hmac_sm3_init,
> +		.update = safexcel_ahash_update,
> +		.final = safexcel_ahash_final,
> +		.finup = safexcel_ahash_finup,
> +		.digest = safexcel_hmac_sm3_digest,
> +		.setkey = safexcel_hmac_sm3_setkey,
> +		.export = safexcel_ahash_export,
> +		.import = safexcel_ahash_import,
> +		.halg = {
> +			.digestsize = SM3_DIGEST_SIZE,
> +			.statesize = sizeof(struct safexcel_ahash_export_state),
> +			.base = {
> +				.cra_name = "hmac(sm3)",
> +				.cra_driver_name = "safexcel-hmac-sm3",
> +				.cra_priority = SAFEXCEL_CRA_PRIORITY,
> +				.cra_flags = CRYPTO_ALG_ASYNC |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_blocksize = SM3_BLOCK_SIZE,
> +				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
> +				.cra_init = safexcel_ahash_cra_init,
> +				.cra_exit = safexcel_ahash_cra_exit,
> +				.cra_module = THIS_MODULE,
> +			},
> +		},
> +	},
> +};
> -- 
> 1.8.3.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
