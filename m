From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : async implementation for sha1-mb
Date: Mon, 20 Jun 2016 19:21:57 +0800
Message-ID: <20160620112157.GC10601@gondor.apana.org.au>
References: <1466191710-2261-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42686 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbcFTLWG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 07:22:06 -0400
Content-Disposition: inline
In-Reply-To: <1466191710-2261-1-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 17, 2016 at 12:28:30PM -0700, Megha Dey wrote:
>
> -static void sha1_mb_async_exit_tfm(struct crypto_tfm *tfm)
> -{
> -	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
> +	ahash_request_set_tfm(areq, child);
> +	ahash_request_set_callback(areq, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);

You need to fix them all, not just the one that I picked out.

> @@ -874,11 +893,13 @@ static struct ahash_alg sha1_mb_async_alg = {
>  			.cra_name               = "sha1",
>  			.cra_driver_name        = "sha1_mb",
>  			.cra_priority           = 200,
> -			.cra_flags              = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
> +			.cra_flags              = CRYPTO_ALG_TYPE_AHASH |
> +							CRYPTO_ALG_ASYNC,

Please don't include unrelated changes such as white-space fixes
like this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
