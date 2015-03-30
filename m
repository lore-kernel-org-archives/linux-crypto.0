From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 02/20] crypto: testmgr to use CRYPTO_ALG_INTERNAL
Date: Tue, 31 Mar 2015 00:10:34 +1100
Message-ID: <20150330131034.GA6251@gondor.apana.org.au>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
 <1657882.6iCTT84gKK@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59472 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbbC3NKj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 09:10:39 -0400
Content-Disposition: inline
In-Reply-To: <1657882.6iCTT84gKK@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 27, 2015 at 11:50:42PM +0100, Stephan Mueller wrote:
> If a cipher allocation fails with -ENOENT, the testmgr now retries
> to allocate the cipher with CRYPTO_ALG_INTERNAL flag.
> 
> As all ciphers, including the internal ciphers will be processed by
> the testmgr, it needs to be able to allocate those ciphers.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/testmgr.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 1f879ad..609bafa 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1506,6 +1506,9 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
>  	int err = 0;
>  
>  	tfm = crypto_alloc_aead(driver, type, mask);
> +	if (PTR_ERR(tfm) == -ENOENT)
> +		tfm = crypto_alloc_aead(driver, type | CRYPTO_ALG_INTERNAL,
> +					mask | CRYPTO_ALG_INTERNAL);

We need to be able to say give me an algorithm regardless of the
INTERNAL bit.  How about treating (type & CRYPTO_ALG_INTERNAL) &&
!(mask & CRYPTO_ALG_INTERNAL) as that special case?

So in patch 1 you would do

	if (!((type | mask) & CRYPTO_ALG_INTERNAL))
		mask |= CRYPTO_ALG_INTERNAL;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
