From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v2 4/5] x86: Move kernel_fpu_using to irq_is_fpu_using
	in asm/i387.h
Date: Thu, 6 Aug 2009 15:37:19 +1000
Message-ID: <20090806053719.GD23557@gondor.apana.org.au>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com> <1249285531-22422-2-git-send-email-ying.huang@intel.com> <1249285531-22422-3-git-send-email-ying.huang@intel.com> <1249285531-22422-4-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59394 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753738AbZHFFhV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2009 01:37:21 -0400
Content-Disposition: inline
In-Reply-To: <1249285531-22422-4-git-send-email-ying.huang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 03, 2009 at 03:45:30PM +0800, Huang Ying wrote:
> This is used by AES-NI accelerated AES implementation and PCLMULQDQ
> accelerated GHASH implementation.
> 
> v2:
>  - Renamed to irq_is_fpu_using to reflect the real situation.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/crypto/aesni-intel_glue.c |   17 +++++------------
>  arch/x86/include/asm/i387.h        |   10 ++++++++++
>  2 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index d3ec8d5..aa68a4d 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -59,13 +59,6 @@ asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
>  asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
>  			      const u8 *in, unsigned int len, u8 *iv);
>  
> -static inline int kernel_fpu_using(void)
> -{
> -	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> -		return 1;
> -	return 0;
> -}
> -
>  static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
>  {
>  	unsigned long addr = (unsigned long)raw_ctx;
> @@ -89,7 +82,7 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
>  		return -EINVAL;
>  	}
>  
> -	if (kernel_fpu_using())
> +	if (irq_is_fpu_using())
>  		err = crypto_aes_expand_key(ctx, in_key, key_len);
>  	else {
>  		kernel_fpu_begin();
> @@ -110,7 +103,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
>  {
>  	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
>  
> -	if (kernel_fpu_using())
> +	if (irq_is_fpu_using())
>  		crypto_aes_encrypt_x86(ctx, dst, src);
>  	else {
>  		kernel_fpu_begin();
> @@ -123,7 +116,7 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
>  {
>  	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
>  
> -	if (kernel_fpu_using())
> +	if (irq_is_fpu_using())
>  		crypto_aes_decrypt_x86(ctx, dst, src);
>  	else {
>  		kernel_fpu_begin();
> @@ -349,7 +342,7 @@ static int ablk_encrypt(struct ablkcipher_request *req)
>  	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
>  	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>  
> -	if (kernel_fpu_using()) {
> +	if (irq_is_fpu_using()) {
>  		struct ablkcipher_request *cryptd_req =
>  			ablkcipher_request_ctx(req);
>  		memcpy(cryptd_req, req, sizeof(*req));
> @@ -370,7 +363,7 @@ static int ablk_decrypt(struct ablkcipher_request *req)
>  	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
>  	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>  
> -	if (kernel_fpu_using()) {
> +	if (irq_is_fpu_using()) {
>  		struct ablkcipher_request *cryptd_req =
>  			ablkcipher_request_ctx(req);
>  		memcpy(cryptd_req, req, sizeof(*req));
> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
> index 175adf5..1d08300 100644
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -301,6 +301,16 @@ static inline void kernel_fpu_end(void)
>  	preempt_enable();
>  }
>  
> +static inline bool is_fpu_using(void)
> +{
> +	return !(read_cr0() & X86_CR0_TS);
> +}
> +
> +static inline bool irq_is_fpu_using(void)
> +{
> +	return in_interrupt() && is_fpu_using();
> +}
> +
>  /*
>   * Some instructions like VIA's padlock instructions generate a spurious
>   * DNA fault but don't modify SSE registers. And these instructions

Peter, do you want to apply this patch in your tree or would
you prefer for it to go through my tree along with the rest of
the series?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
