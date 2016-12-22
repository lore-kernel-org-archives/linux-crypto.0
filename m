From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/3] crypto: Change lz4 modules to work with new lz4
 compressor module version
Date: Thu, 22 Dec 2016 22:25:16 +0900
Message-ID: <20161222132516.GB413@tigerII.localdomain>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1482259992-16680-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482259992-16680-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Cc Herbert and linux-crypto on this

https://marc.info/?l=linux-kernel&m=148226084823926


On (12/20/16 19:53), Sven Schmidt wrote:
> 
> This patch updates the crypto modules using LZ4 compression to work with the
> new LZ4 kernel module version.
> 
> Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
> ---
>  crypto/lz4.c   | 93 +++++++--------------------------------------------------
>  crypto/lz4hc.c | 94 +++++++---------------------------------------------------
>  2 files changed, 22 insertions(+), 165 deletions(-)
> 
> diff --git a/crypto/lz4.c b/crypto/lz4.c
> index 99c1b2c..9fa217e 100644
> --- a/crypto/lz4.c
> +++ b/crypto/lz4.c
> @@ -23,53 +23,36 @@
>  #include <linux/crypto.h>
>  #include <linux/vmalloc.h>
>  #include <linux/lz4.h>
> -#include <crypto/internal/scompress.h>
>  
>  struct lz4_ctx {
>  	void *lz4_comp_mem;
>  };
>  
> -static void *lz4_alloc_ctx(struct crypto_scomp *tfm)
> -{
> -	void *ctx;
> -
> -	ctx = vmalloc(LZ4_MEM_COMPRESS);
> -	if (!ctx)
> -		return ERR_PTR(-ENOMEM);
> -
> -	return ctx;
> -}
> -
>  static int lz4_init(struct crypto_tfm *tfm)
>  {
>  	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
>  
> -	ctx->lz4_comp_mem = lz4_alloc_ctx(NULL);
> -	if (IS_ERR(ctx->lz4_comp_mem))
> +	ctx->lz4_comp_mem = vmalloc(LZ4_MEM_COMPRESS);
> +	if (!ctx->lz4_comp_mem)
>  		return -ENOMEM;
>  
>  	return 0;
>  }
>  
> -static void lz4_free_ctx(struct crypto_scomp *tfm, void *ctx)
> -{
> -	vfree(ctx);
> -}
> -
>  static void lz4_exit(struct crypto_tfm *tfm)
>  {
>  	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -	lz4_free_ctx(NULL, ctx->lz4_comp_mem);
> +	vfree(ctx->lz4_comp_mem);
>  }
>  
> -static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
> -				 u8 *dst, unsigned int *dlen, void *ctx)
> +static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
> +			    unsigned int slen, u8 *dst, unsigned int *dlen)
>  {
> +	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
>  	size_t tmp_len = *dlen;
>  	int err;
>  
> -	err = lz4_compress(src, slen, dst, &tmp_len, ctx);
> +	err = LZ4_compress_default(src, dst, slen, tmp_len, ctx->lz4_comp_mem);
>  
>  	if (err < 0)
>  		return -EINVAL;
> @@ -78,29 +61,14 @@ static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
>  	return 0;
>  }
>  
> -static int lz4_scompress(struct crypto_scomp *tfm, const u8 *src,
> -			 unsigned int slen, u8 *dst, unsigned int *dlen,
> -			 void *ctx)
> -{
> -	return __lz4_compress_crypto(src, slen, dst, dlen, ctx);
> -}
> -
> -static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
> -			       unsigned int slen, u8 *dst, unsigned int *dlen)
> -{
> -	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem);
> -}
> -
> -static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
> -				   u8 *dst, unsigned int *dlen, void *ctx)
> +static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
> +			      unsigned int slen, u8 *dst, unsigned int *dlen)
>  {
>  	int err;
>  	size_t tmp_len = *dlen;
>  	size_t __slen = slen;
>  
> -	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
> +	err = LZ4_decompress_safe(src, dst, __slen, tmp_len);
>  	if (err < 0)
>  		return -EINVAL;
>  
> @@ -108,20 +76,6 @@ static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
>  	return err;
>  }
>  
> -static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
> -			   unsigned int slen, u8 *dst, unsigned int *dlen,
> -			   void *ctx)
> -{
> -	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
> -}
> -
> -static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
> -				 unsigned int slen, u8 *dst,
> -				 unsigned int *dlen)
> -{
> -	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
> -}
> -
>  static struct crypto_alg alg_lz4 = {
>  	.cra_name		= "lz4",
>  	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
> @@ -135,39 +89,14 @@ static struct crypto_alg alg_lz4 = {
>  	.coa_decompress		= lz4_decompress_crypto } }
>  };
>  
> -static struct scomp_alg scomp = {
> -	.alloc_ctx		= lz4_alloc_ctx,
> -	.free_ctx		= lz4_free_ctx,
> -	.compress		= lz4_scompress,
> -	.decompress		= lz4_sdecompress,
> -	.base			= {
> -		.cra_name	= "lz4",
> -		.cra_driver_name = "lz4-scomp",
> -		.cra_module	 = THIS_MODULE,
> -	}
> -};
> -
>  static int __init lz4_mod_init(void)
>  {
> -	int ret;
> -
> -	ret = crypto_register_alg(&alg_lz4);
> -	if (ret)
> -		return ret;
> -
> -	ret = crypto_register_scomp(&scomp);
> -	if (ret) {
> -		crypto_unregister_alg(&alg_lz4);
> -		return ret;
> -	}
> -
> -	return ret;
> +	return crypto_register_alg(&alg_lz4);
>  }
>  
>  static void __exit lz4_mod_fini(void)
>  {
>  	crypto_unregister_alg(&alg_lz4);
> -	crypto_unregister_scomp(&scomp);
>  }
>  
>  module_init(lz4_mod_init);
> diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
> index 75ffc4a..aa1265c 100644
> --- a/crypto/lz4hc.c
> +++ b/crypto/lz4hc.c
> @@ -22,53 +22,37 @@
>  #include <linux/crypto.h>
>  #include <linux/vmalloc.h>
>  #include <linux/lz4.h>
> -#include <crypto/internal/scompress.h>
>  
>  struct lz4hc_ctx {
>  	void *lz4hc_comp_mem;
>  };
>  
> -static void *lz4hc_alloc_ctx(struct crypto_scomp *tfm)
> -{
> -	void *ctx;
> -
> -	ctx = vmalloc(LZ4HC_MEM_COMPRESS);
> -	if (!ctx)
> -		return ERR_PTR(-ENOMEM);
> -
> -	return ctx;
> -}
> -
>  static int lz4hc_init(struct crypto_tfm *tfm)
>  {
>  	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
>  
> -	ctx->lz4hc_comp_mem = lz4hc_alloc_ctx(NULL);
> -	if (IS_ERR(ctx->lz4hc_comp_mem))
> +	ctx->lz4hc_comp_mem = vmalloc(LZ4HC_MEM_COMPRESS);
> +	if (!ctx->lz4hc_comp_mem)
>  		return -ENOMEM;
>  
>  	return 0;
>  }
>  
> -static void lz4hc_free_ctx(struct crypto_scomp *tfm, void *ctx)
> -{
> -	vfree(ctx);
> -}
> -
>  static void lz4hc_exit(struct crypto_tfm *tfm)
>  {
>  	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
>  
> -	lz4hc_free_ctx(NULL, ctx->lz4hc_comp_mem);
> +	vfree(ctx->lz4hc_comp_mem);
>  }
>  
> -static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
> -				   u8 *dst, unsigned int *dlen, void *ctx)
> +static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
> +			    unsigned int slen, u8 *dst, unsigned int *dlen)
>  {
> +	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
>  	size_t tmp_len = *dlen;
>  	int err;
>  
> -	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx);
> +	err = LZ4_compress_HC(src, dst, slen, tmp_len, LZ4HC_DEFAULT_CLEVEL, ctx->lz4hc_comp_mem);
>  
>  	if (err < 0)
>  		return -EINVAL;
> @@ -77,31 +61,14 @@ static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
>  	return 0;
>  }
>  
> -static int lz4hc_scompress(struct crypto_scomp *tfm, const u8 *src,
> -			   unsigned int slen, u8 *dst, unsigned int *dlen,
> -			   void *ctx)
> -{
> -	return __lz4hc_compress_crypto(src, slen, dst, dlen, ctx);
> -}
> -
> -static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
> -				 unsigned int slen, u8 *dst,
> -				 unsigned int *dlen)
> -{
> -	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -	return __lz4hc_compress_crypto(src, slen, dst, dlen,
> -					ctx->lz4hc_comp_mem);
> -}
> -
> -static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
> -				     u8 *dst, unsigned int *dlen, void *ctx)
> +static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
> +			      unsigned int slen, u8 *dst, unsigned int *dlen)
>  {
>  	int err;
>  	size_t tmp_len = *dlen;
>  	size_t __slen = slen;
>  
> -	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
> +	err = LZ4_decompress_safe(src, dst, __slen, (int)tmp_len);
>  	if (err < 0)
>  		return -EINVAL;
>  
> @@ -109,20 +76,6 @@ static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
>  	return err;
>  }
>  
> -static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
> -			     unsigned int slen, u8 *dst, unsigned int *dlen,
> -			     void *ctx)
> -{
> -	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
> -}
> -
> -static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
> -				   unsigned int slen, u8 *dst,
> -				   unsigned int *dlen)
> -{
> -	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
> -}
> -
>  static struct crypto_alg alg_lz4hc = {
>  	.cra_name		= "lz4hc",
>  	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
> @@ -136,39 +89,14 @@ static struct crypto_alg alg_lz4hc = {
>  	.coa_decompress		= lz4hc_decompress_crypto } }
>  };
>  
> -static struct scomp_alg scomp = {
> -	.alloc_ctx		= lz4hc_alloc_ctx,
> -	.free_ctx		= lz4hc_free_ctx,
> -	.compress		= lz4hc_scompress,
> -	.decompress		= lz4hc_sdecompress,
> -	.base			= {
> -		.cra_name	= "lz4hc",
> -		.cra_driver_name = "lz4hc-scomp",
> -		.cra_module	 = THIS_MODULE,
> -	}
> -};
> -
>  static int __init lz4hc_mod_init(void)
>  {
> -	int ret;
> -
> -	ret = crypto_register_alg(&alg_lz4hc);
> -	if (ret)
> -		return ret;
> -
> -	ret = crypto_register_scomp(&scomp);
> -	if (ret) {
> -		crypto_unregister_alg(&alg_lz4hc);
> -		return ret;
> -	}
> -
> -	return ret;
> +	return crypto_register_alg(&alg_lz4hc);
>  }
>  
>  static void __exit lz4hc_mod_fini(void)
>  {
>  	crypto_unregister_alg(&alg_lz4hc);
> -	crypto_unregister_scomp(&scomp);
>  }
>  
>  module_init(lz4hc_mod_init);
> -- 
> 2.1.4
> 
