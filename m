From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 03/10] crypto: aead: Add aead_request_cast() api
Date: Mon, 6 Jul 2015 15:41:45 +0800
Message-ID: <20150706074145.GC20192@gondor.apana.org.au>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-4-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49135 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbGFHlv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 03:41:51 -0400
Content-Disposition: inline
In-Reply-To: <1435814320-30347-4-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2015 at 10:48:33AM +0530, Lokesh Vutla wrote:
> Add aead_request_cast() api to get pointer to aead_request
> from cryto_async_request.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  include/linux/crypto.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 10df5d2..20fac3d 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -1460,6 +1460,12 @@ static inline void aead_request_set_tfm(struct aead_request *req,
>  	req->base.tfm = crypto_aead_tfm(crypto_aead_crt(tfm)->base);
>  }
>  
> +static inline struct aead_request *aead_request_cast(
> +					struct crypto_async_request *req)
> +{
> +	return container_of(req, struct aead_request, base);
> +}
> +

This should go into include/crypto/internal/aead.h.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
