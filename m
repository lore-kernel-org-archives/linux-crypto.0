From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 5/6] staging: lustre: Use ahash
Date: Wed, 3 Feb 2016 14:48:57 -0800
Message-ID: <20160203224857.GA20244@kroah.com>
References: <20160201133405.GA10754@gondor.apana.org.au>
 <E1aQEez-0002pe-RL@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	devel@driverdev.osuosl.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbcBCWs5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 17:48:57 -0500
Content-Disposition: inline
In-Reply-To: <E1aQEez-0002pe-RL@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 01, 2016 at 09:36:53PM +0800, Herbert Xu wrote:
> This patch replaces uses of the long obsolete hash interface with
> ahash.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c |   92 +++++++-------
>  1 file changed, 52 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
> index 079d50e..94c01aa 100644
> --- a/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
> +++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
> @@ -27,7 +27,7 @@
>   * Copyright (c) 2012, Intel Corporation.
>   */
>  
> -#include <linux/crypto.h>
> +#include <crypto/hash.h>
>  #include <linux/scatterlist.h>
>  #include "../../../include/linux/libcfs/libcfs.h"
>  #include "linux-crypto.h"
> @@ -38,9 +38,11 @@ static int cfs_crypto_hash_speeds[CFS_HASH_ALG_MAX];
>  
>  static int cfs_crypto_hash_alloc(unsigned char alg_id,
>  				 const struct cfs_crypto_hash_type **type,
> -				 struct hash_desc *desc, unsigned char *key,
> +				 struct ahash_request **req,
> +				 unsigned char *key,
>  				 unsigned int key_len)
>  {
> +	struct crypto_ahash *tfm;
>  	int     err = 0;
>  
>  	*type = cfs_crypto_hash_type(alg_id);
> @@ -50,18 +52,23 @@ static int cfs_crypto_hash_alloc(unsigned char alg_id,
>  		      alg_id, CFS_HASH_ALG_MAX);
>  		return -EINVAL;
>  	}
> -	desc->tfm = crypto_alloc_hash((*type)->cht_name, 0, 0);
> +	tfm = crypto_alloc_ahash((*type)->cht_name, 0, CRYPTO_ALG_ASYNC);
>  
> -	if (desc->tfm == NULL)
> -		return -EINVAL;
> -
> -	if (IS_ERR(desc->tfm)) {
> +	if (IS_ERR(tfm)) {
>  		CDEBUG(D_INFO, "Failed to alloc crypto hash %s\n",
>  		       (*type)->cht_name);
> -		return PTR_ERR(desc->tfm);
> +		return PTR_ERR(tfm);
>  	}
>  
> -	desc->flags = 0;
> +	*req = ahash_request_alloc(tfm, GFP_KERNEL);
> +	if (!*req) {
> +		CDEBUG(D_INFO, "Failed to alloc ahash_request for %s\n",
> +		       (*type)->cht_name);
> +		crypto_free_ahash(tfm);
> +		return -ENOMEM;
> +	}
> +
> +	ahash_request_set_callback(*req, 0, NULL, NULL);
>  
>  	/** Shash have different logic for initialization then digest
>  	 * shash: crypto_hash_setkey, crypto_hash_init
> @@ -70,23 +77,27 @@ static int cfs_crypto_hash_alloc(unsigned char alg_id,
>  	 * cfs_crypto_hash_alloc.
>  	 */
>  	if (key != NULL)
> -		err = crypto_hash_setkey(desc->tfm, key, key_len);
> +		err = crypto_ahash_setkey(tfm, key, key_len);
>  	else if ((*type)->cht_key != 0)
> -		err = crypto_hash_setkey(desc->tfm,
> +		err = crypto_ahash_setkey(tfm,
>  					 (unsigned char *)&((*type)->cht_key),
>  					 (*type)->cht_size);
>  
>  	if (err != 0) {
> -		crypto_free_hash(desc->tfm);
> +		crypto_free_ahash(tfm);
>  		return err;
>  	}
>  
>  	CDEBUG(D_INFO, "Using crypto hash: %s (%s) speed %d MB/s\n",
> -	       (crypto_hash_tfm(desc->tfm))->__crt_alg->cra_name,
> -	       (crypto_hash_tfm(desc->tfm))->__crt_alg->cra_driver_name,
> +	       crypto_ahash_alg_name(tfm), crypto_ahash_driver_name(tfm),

This change breaks the build for me so I can't take this through my
tree.  I'm hoping you have a patch earlier in the series that adds these
functions, if so, feel free to take this through your tree:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
