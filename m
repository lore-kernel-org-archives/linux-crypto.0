From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Sun, 18 Jan 2015 23:58:25 +0100
Message-ID: <2741490.jjzJISez4X@tachyon.chronox.de>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: 'Herbert Xu' <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2587101.YvN0IxRmOH@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 18. Januar 2015, 23:56:03 schrieb Stephan Mueller:

Hi Tadeusz,

> The cipher registered as __driver-gcm-aes-aesni is never intended
> to be used directly by any caller. Instead it is a service mechanism to
> rfc4106-gcm-aesni.
> 
> The kernel crypto API unconditionally calls the registered setkey
> function. In case a caller erroneously uses __driver-gcm-aes-aesni a
> call to crypto_aead_setkey will cause a NULL pointer dereference without
> this patch.

I tested that patch and can confirm that this patch fixes the kernel crash 
triggered through the AF_ALG interface for AEAD ciphers that is currently 
under development reported earlier. 
> 
> CC: Tadeusz Struk <tadeusz.struk@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c
> b/arch/x86/crypto/aesni-intel_glue.c index 947c6bf..a278ef9 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1012,6 +1012,16 @@ static int rfc4106_decrypt(struct aead_request *req)
>  	}
>  }
> 
> +static int __driver_rfc4106_set_key(struct crypto_aead *parent,
> +				    const u8 *key, unsigned int key_len)
> +{
> +	/*
> +	 * __driver-gcm-aes-aesni is only a backend for rfc4106-gcm-aesni
> +	 * and is never intended to be used as a regular cipher.
> +	 */
> +	return -EOPNOTSUPP;
> +}
> +
>  static int __driver_rfc4106_encrypt(struct aead_request *req)
>  {
>  	u8 one_entry_in_sg = 0;
> @@ -1366,6 +1376,7 @@ static struct crypto_alg aesni_algs[] = { {
>  	.cra_module		= THIS_MODULE,
>  	.cra_u = {
>  		.aead = {
> +			.setkey		= __driver_rfc4106_set_key,
>  			.encrypt	= __driver_rfc4106_encrypt,
>  			.decrypt	= __driver_rfc4106_decrypt,
>  		},


-- 
Ciao
Stephan
