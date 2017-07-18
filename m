From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V6 5/7] crypto: AES CBC multi-buffer glue code
Date: Tue, 18 Jul 2017 13:41:42 +0800
Message-ID: <20170718054142.GA4764@gondor.apana.org.au>
References: <1498609575-6217-1-git-send-email-megha.dey@linux.intel.com>
 <1498609575-6217-6-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        megha.dey@intel.com
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:49936 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdGRFmU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 01:42:20 -0400
Content-Disposition: inline
In-Reply-To: <1498609575-6217-6-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 27, 2017 at 05:26:13PM -0700, Megha Dey wrote:
>
> +static void completion_callback(struct mcryptd_skcipher_request_ctx *rctx,
> +			    struct mcryptd_alg_cstate *cstate,
> +			    int err)
> +{
> +	struct skcipher_request *req = cast_mcryptd_ctx_to_req(rctx);
> +
> +       /* remove from work list and invoke completion callback */
> +	spin_lock(&cstate->work_lock);
> +	list_del(&rctx->waiter);
> +	spin_unlock(&cstate->work_lock);
> +
> +	if (irqs_disabled())
> +		rctx->complete(&req->base, err);
> +	else {
> +		local_bh_disable();
> +		rctx->complete(&req->base, err);
> +		local_bh_enable();
> +	}
> +}

The fact that you need to do this check means that this design is
wrong.  You should always know what context you are in.

> +/*
> + * CRYPTO_ALG_ASYNC flag is passed to indicate we have an ablk
> + * scatter-gather walk.
> + */
> +static struct skcipher_alg aes_cbc_mb_alg = {
> +	.base = {
> +		.cra_name		= "cbc(aes)",
> +		.cra_driver_name	= "cbc-aes-aesni-mb",
> +		.cra_priority		= 500,
> +		.cra_flags		= CRYPTO_ALG_INTERNAL,
> +		.cra_blocksize		= AES_BLOCK_SIZE,
> +		.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
> +		.cra_module		= THIS_MODULE,
> +	},
> +	.min_keysize	= AES_MIN_KEY_SIZE,
> +	.max_keysize	= AES_MAX_KEY_SIZE,
> +	.ivsize		= AES_BLOCK_SIZE,
> +	.setkey		= aes_set_key,
> +	.encrypt	= mb_aes_cbc_encrypt,
> +	.decrypt	= mb_aes_cbc_decrypt
> +};

So this claims to be a sync algorithm.  Is this really the case?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
