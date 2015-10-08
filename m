From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH  v5 2/2] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 8 Oct 2015 21:02:49 +0800
Message-ID: <20151008130249.GB24128@gondor.apana.org.au>
References: <20151002051032.27263.21150.stgit@tstruk-mobl1>
 <20151002051043.27263.10920.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41963 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbbJHNCw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 09:02:52 -0400
Content-Disposition: inline
In-Reply-To: <20151002051043.27263.10920.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 10:10:43PM -0700, Tadeusz Struk wrote:
>
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 69d163e..c55526c 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -13,26 +13,27 @@
>  #ifndef _CRYPTO_AKCIPHER_H
>  #define _CRYPTO_AKCIPHER_H
>  #include <linux/crypto.h>
> +#include <linux/scatterlist.h>

Is this actually needed?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
