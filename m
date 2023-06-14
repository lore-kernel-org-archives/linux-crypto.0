Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2530EB64DA
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 09:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243504AbjFNJvK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 05:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241748AbjFNJvI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 05:51:08 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3314B19F;
        Wed, 14 Jun 2023 02:51:02 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q9N9Q-002ond-3C; Wed, 14 Jun 2023 17:50:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 Jun 2023 17:50:52 +0800
Date:   Wed, 14 Jun 2023 17:50:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mahmoud Adam <mngyadam@amazon.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: rsa - allow only odd e and restrict value in
 FIPS mode
Message-ID: <ZImNfECCS+22oF/D@gondor.apana.org.au>
References: <20230613161731.74081-1-mngyadam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613161731.74081-1-mngyadam@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 13, 2023 at 04:17:31PM +0000, Mahmoud Adam wrote:
> check if rsa public exponent is odd and check its value is between
> 2^16 < e < 2^256.
> 
> FIPS 186-5 DSS (page 35)[1] specify that:
> 1. The public exponent e shall be selected with the following constraints:
>   (a) The public verification exponent e shall be selected prior to
>   generating the primes, p and q, and the private signature exponent
>   d.
>   (b) The exponent e shall be an odd positive integer such that:
>    2^16 < e < 2^256.
> 
> [1] https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-5.pdf
> 
> Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
> ---
>  crypto/rsa.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/crypto/rsa.c b/crypto/rsa.c
> index c50f2d2a4d06..c79613cdce6e 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -205,6 +205,32 @@ static int rsa_check_key_length(unsigned int len)
>  	return -EINVAL;
>  }
>  
> +static int rsa_check_exponent_fips(MPI e)
> +{
> +	MPI e_max = NULL;
> +
> +	/* check if odd */
> +	if (!mpi_test_bit(e, 0)) {
> +		return -EINVAL;
> +	}
> +
> +	/* check if 2^16 < e < 2^256. */
> +	if (mpi_cmp_ui(e, 65536) <= 0) {
> +		return -EINVAL;
> +	}
> +
> +	e_max = mpi_alloc(0);
> +	mpi_set_bit(e_max, 256);
> +
> +	if (mpi_cmp(e, e_max) >= 0) {
> +		mpi_free(e_max);
> +		return -EINVAL;
> +	}
> +
> +	mpi_free(e_max);
> +	return 0;
> +}
> +
>  static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  			   unsigned int keylen)
>  {
> @@ -232,6 +258,11 @@ static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  		return -EINVAL;
>  	}
>  
> +	if (fips_enabled && rsa_check_exponent_fips(mpi_key->e)) {
> +		rsa_free_mpi_key(mpi_key);
> +		return -EINVAL;
> +	}
> +
>  	return 0;
>  
>  err:
> @@ -290,6 +321,11 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  		return -EINVAL;
>  	}
>  
> +	if (fips_enabled && rsa_check_exponent_fips(mpi_key->e)) {
> +		rsa_free_mpi_key(mpi_key);
> +		return -EINVAL;
> +	}
> +
>  	return 0;
>  
>  err:
> -- 
> 2.40.1

Cc Stephan Mueller
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
