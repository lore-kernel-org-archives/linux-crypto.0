Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:34559 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbeKGD3W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Nov 2018 22:29:22 -0500
Subject: Re: [PATCH] crypto: bcm: fix normal/non key hash algorithm failure
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Cc: bcm-kernel-feedback-list@broadcom.com
References: <1541492938-29261-1-git-send-email-raveendra.padasalagi@broadcom.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dbac8a57-a1dd-1926-624f-cdbb2e4f6dff@gmail.com>
Date: Tue, 6 Nov 2018 10:02:47 -0800
MIME-Version: 1.0
In-Reply-To: <1541492938-29261-1-git-send-email-raveendra.padasalagi@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/6/18 12:28 AM, Raveendra Padasalagi wrote:
> Remove setkey() callback handler for normal/non key
> hash algorithms and keep it for AES-CBC/CMAC which needs key.
> 
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>

Should this have the following Fixes tag?

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")

> ---
>  drivers/crypto/bcm/cipher.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index 2d1f1db..4d67e22 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -4652,12 +4652,16 @@ static int spu_register_ahash(struct iproc_alg_s *driver_alg)
>  	hash->halg.statesize = sizeof(struct spu_hash_export_s);
>  
>  	if (driver_alg->auth_info.mode != HASH_MODE_HMAC) {
> -		hash->setkey = ahash_setkey;
>  		hash->init = ahash_init;
>  		hash->update = ahash_update;
>  		hash->final = ahash_final;
>  		hash->finup = ahash_finup;
>  		hash->digest = ahash_digest;
> +		if ((driver_alg->auth_info.alg == HASH_ALG_AES) &&
> +		    ((driver_alg->auth_info.mode == HASH_MODE_XCBC) ||
> +		    (driver_alg->auth_info.mode == HASH_MODE_CMAC))) {
> +			hash->setkey = ahash_setkey;
> +		}
>  	} else {
>  		hash->setkey = ahash_hmac_setkey;
>  		hash->init = ahash_hmac_init;
> 


-- 
Florian
