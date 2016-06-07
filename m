From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/9] crypto: add driver-side scomp interface
Date: Tue, 7 Jun 2016 18:22:09 +0800
Message-ID: <20160607102209.GA32725@gondor.apana.org.au>
References: <1464870543-5988-1-git-send-email-giovanni.cabiddu@intel.com>
 <1464870543-5988-4-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49302 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbcFGKWa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 06:22:30 -0400
Content-Disposition: inline
In-Reply-To: <1464870543-5988-4-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 01:28:57PM +0100, Giovanni Cabiddu wrote:
>
> @@ -96,6 +116,31 @@ struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
>  }
>  EXPORT_SYMBOL_GPL(crypto_alloc_acomp);
>  
> +struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp, gfp_t gfp)
> +{
> +	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
> +	struct acomp_req *req;
> +
> +	req = __acomp_request_alloc(acomp, gfp);
> +	if (req && (tfm->__crt_alg->cra_type != &crypto_acomp_type))
> +		return crypto_acomp_scomp_alloc_ctx(req);

The gfp argument is pointless since scomp requires GFP_KERNEL.

So please just make it a requirement that acomp_request_alloc
always uses GFP_KERNEL.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
