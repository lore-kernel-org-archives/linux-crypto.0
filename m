From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 10/17] crypto: Add userspace report for ablkcipher
	type algorithms
Date: Sat, 24 Sep 2011 13:21:25 +1000
Message-ID: <20110924032125.GA26475@gondor.apana.org.au>
References: <20110921085855.GE1808@secunet.com> <20110921090716.GO1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34289 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1IXDV3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Sep 2011 23:21:29 -0400
Content-Disposition: inline
In-Reply-To: <20110921090716.GO1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 21, 2011 at 11:07:16AM +0200, Steffen Klassert wrote:
>
> diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
> index 62ae124..0c359e5 100644
> --- a/include/linux/cryptouser.h
> +++ b/include/linux/cryptouser.h
> @@ -40,6 +40,7 @@ enum crypto_attr_type_t {
>  	CRYPTOCFGA_REPORT_SHASH,	/* struct crypto_report_hash */
>  	CRYPTOCFGA_REPORT_AHASH,	/* struct crypto_report_hash */
>  	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
> +	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_blkcipher */

I don't think you should distinguish between BLKCIPHER and ABLKCIPHER.
A good rule of thumb would be if the report data structure is the
same, then the type value should be the same.

You can still have the string type to show something different to
the user.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
