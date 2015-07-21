From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Don't attempt to register algorithm
 multiple times
Date: Tue, 21 Jul 2015 20:17:57 +0800
Message-ID: <20150721121757.GA24985@gondor.apana.org.au>
References: <20150721014538.25720.17568.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38402 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbbGUMSa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2015 08:18:30 -0400
Content-Disposition: inline
In-Reply-To: <20150721014538.25720.17568.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 20, 2015 at 06:45:38PM -0700, Tadeusz Struk wrote:
> When multiple devices are present in the system the driver attempts
> to register the same algorithm many times.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> index 557a740..3e3c5c8 100644
> --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> @@ -58,6 +58,8 @@
>  #include "adf_common_drv.h"
>  #include "qat_crypto.h"
>  
> +static atomic_t active_devs;
> +
>  struct qat_rsa_input_params {
>  	union {
>  		struct {
> @@ -629,11 +631,16 @@ static struct akcipher_alg rsa = {
>  
>  int qat_asym_algs_register(void)
>  {
> -	rsa.base.cra_flags = 0;
> -	return crypto_register_akcipher(&rsa);
> +	if (atomic_add_return(1, &active_devs) == 1) {
> +		rsa.base.cra_flags = 0;
> +		return crypto_register_akcipher(&rsa);
> +	}
> +
> +	return 0;
>  }

This looks buggy.  Either this can be called in parallel in which
case the atomic is not enough because you're not synchronising
between the register and the unregister.  Or it cannot be called
in parallel in which case the atomic is redundant.

The same issue exists on the sym side as well.

Please clarify how this is supposed to be called and use the
correct synchronisation mechanism.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
