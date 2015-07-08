From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 5/7] crypto: aead: Add aead_request_cast() api
Date: Wed, 8 Jul 2015 11:56:52 +0800
Message-ID: <20150708035652.GC12627@gondor.apana.org.au>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
 <1436283109-13318-6-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49869 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbbGHD4z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 23:56:55 -0400
Content-Disposition: inline
In-Reply-To: <1436283109-13318-6-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2015 at 09:01:47PM +0530, Lokesh Vutla wrote:
> Add aead_request_cast() api to get pointer to aead_request
> from cryto_async_request.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  include/crypto/internal/aead.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
> index 4b25471..0423fa5 100644
> --- a/include/crypto/internal/aead.h
> +++ b/include/crypto/internal/aead.h
> @@ -157,6 +157,12 @@ static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
>  	return crypto_aead_alg_maxauthsize(crypto_aead_alg(aead));
>  }
>  
> +static inline struct aead_request *aead_request_cast(
> +					struct crypto_async_request *req)
> +{
> +	return container_of(req, struct aead_request, base);
> +}

Please drop this and use the aead_queue interface I just posted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
