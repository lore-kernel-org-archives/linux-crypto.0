From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/6] crypto: SHA1 multibuffer crypto hash
 infrastructure
Date: Sat, 21 Jun 2014 01:57:51 +0800
Message-ID: <20140620175751.GA2802@gondor.apana.org.au>
References: <cover.1402491749.git.tim.c.chen@linux.intel.com>
 <1402520625.2970.537.camel@schen9-DESK>
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
Received: from helcar.apana.org.au ([209.40.204.226]:44009 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676AbaFTR6Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 13:58:25 -0400
Content-Disposition: inline
In-Reply-To: <1402520625.2970.537.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 11, 2014 at 02:03:45PM -0700, Tim Chen wrote:
>
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 929058a..234ece0 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -271,6 +271,18 @@ static int shash_async_finup(struct ahash_request *req)
>  	return shash_ahash_finup(req, desc);
>  }
>  
> +int shash_ahash_mcryptd_digest(struct ahash_request *req,
> +			       struct shash_desc *desc)
> +{
> +	int err;
> +
> +	err = crypto_shash_init(desc) ?:
> +	      shash_ahash_mcryptd_finup(req, desc);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_digest);
> +

This bit causes your patch to not build for me.

Please fix and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
