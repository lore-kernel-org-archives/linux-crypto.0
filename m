From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] crypto: SHA1 multibuffer crypto hash infrastructure
Date: Wed, 14 May 2014 08:10:20 +0800
Message-ID: <20140514001020.GA28593@gondor.apana.org.au>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
 <1400023185.2970.239.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53475 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaENAKg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 20:10:36 -0400
Content-Disposition: inline
In-Reply-To: <1400023185.2970.239.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 13, 2014 at 04:19:45PM -0700, Tim Chen wrote:
>
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 929058a..6f40424 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -229,6 +229,42 @@ int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
>  }
>  EXPORT_SYMBOL_GPL(shash_ahash_update);
>  
> +int shash_ahash_mcryptd_update(struct ahash_request *req,
> +			       struct shash_desc *desc)
> +{
> +	struct crypto_shash *tfm = desc->tfm;
> +	struct shash_alg *shash = crypto_shash_alg(tfm);
> +
> +	/* alignment is to be done by multi-buffer crypto algorithm if needed */
> +
> +	return shash->update(desc, NULL, 0);
> +}
> +EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_update);

Why are these functions in shash.c instead of mcryptd.c?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
