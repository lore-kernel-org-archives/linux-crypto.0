From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: geode: add fallback for unsupported modes, take 2
Date: Tue, 6 Nov 2007 12:24:35 -0700
Message-ID: <20071106192435.GC21362@cosmic.amd.com>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc>
 <1192788233-14968-5-git-send-email-linux-crypto@ml.breakpoint.cc>
 <20071021083158.GD9397@gondor.apana.org.au>
 <20071104205923.GB25799@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:29001 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbXKFTZd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 14:25:33 -0500
In-Reply-To: <20071104205923.GB25799@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/11/07 21:59 +0100, Sebastian Siewior wrote:
> The Geode AES crypto engine supports only 128 bit long key. This
> patch adds fallback for other key sizes which are required by the
> AES standard.
> 
> Cc: Jordan Crouse <jordan.crouse@amd.com>
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Acked-by: Jordan Crouse <jordan.crouse@amd.com>

Thanks!

> ---
> 
> Herbert, as you suggested I splitted cipher & blk code.
> 
> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
> index da6164a..f2d4fba 100644
> --- a/drivers/crypto/geode-aes.c
> +++ b/drivers/crypto/geode-aes.c
> @@ -114,18 +114,103 @@ geode_aes_crypt(struct geode_aes_op *op)
>  
>  /* CRYPTO-API Functions */
>  
> -static int
> -geode_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int len)
> +static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
> +		unsigned int len)
>  {
>  	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> +	unsigned int ret;
> +
> +	op->keylen = len;
> +
> +	if (len == AES_KEYSIZE_128) {
> +		memcpy(op->key, key, len);
> +		return 0;
> +	}
>  
> -	if (len != AES_KEY_LENGTH) {
> +	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256) {
> +		/* not supported at all */
>  		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
>  		return -EINVAL;
>  	}
>  
> -	memcpy(op->key, key, len);
> -	return 0;
> +	/*
> +	 * The requested key size is not supported by HW, do a fallback
> +	 */
> +	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> +	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
> +
> +	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
> +	if (ret) {
> +		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
> +		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
> +	}
> +	return ret;
> +}
> +
> +static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
> +		unsigned int len)
> +{
> +	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> +	unsigned int ret;
> +
> +	op->keylen = len;
> +
> +	if (len == AES_KEYSIZE_128) {
> +		memcpy(op->key, key, len);
> +		return 0;
> +	}
> +
> +	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256) {
> +		/* not supported at all */
> +		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * The requested key size is not supported by HW, do a fallback
> +	 */
> +	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> +	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
> +
> +	ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
> +	if (ret) {
> +		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
> +		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
> +	}
> +	return ret;
> +}
> +
> +static int fallback_blk_dec(struct blkcipher_desc *desc,
> +		struct scatterlist *dst, struct scatterlist *src,
> +		unsigned int nbytes)
> +{
> +	unsigned int ret;
> +	struct crypto_blkcipher *tfm;
> +	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> +
> +	tfm = desc->tfm;
> +	desc->tfm = op->fallback.blk;
> +
> +	ret = crypto_blkcipher_decrypt(desc, dst, src, nbytes);
> +
> +	desc->tfm = tfm;
> +	return ret;
> +}
> +static int fallback_blk_enc(struct blkcipher_desc *desc,
> +		struct scatterlist *dst, struct scatterlist *src,
> +		unsigned int nbytes)
> +{
> +	unsigned int ret;
> +	struct crypto_blkcipher *tfm;
> +	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> +
> +	tfm = desc->tfm;
> +	desc->tfm = op->fallback.blk;
> +
> +	ret = crypto_blkcipher_encrypt(desc, dst, src, nbytes);
> +
> +	desc->tfm = tfm;
> +	return ret;
>  }
>  
>  static void
> @@ -133,8 +218,10 @@ geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
>  
> -	if ((out == NULL) || (in == NULL))
> +	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
> +		crypto_cipher_encrypt_one(op->fallback.cip, out, in);
>  		return;
> +	}
>  
>  	op->src = (void *) in;
>  	op->dst = (void *) out;
> @@ -152,8 +239,10 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
>  
> -	if ((out == NULL) || (in == NULL))
> +	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
> +		crypto_cipher_decrypt_one(op->fallback.cip, out, in);
>  		return;
> +	}
>  
>  	op->src = (void *) in;
>  	op->dst = (void *) out;
> @@ -165,24 +254,50 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  	geode_aes_crypt(op);
>  }
>  
> +static int fallback_init_cip(struct crypto_tfm *tfm)
> +{
> +	const char *name = tfm->__crt_alg->cra_name;
> +	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> +
> +	op->fallback.cip = crypto_alloc_cipher(name, 0,
> +				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +
> +	if (IS_ERR(op->fallback.cip)) {
> +		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
> +		return PTR_ERR(op->fallback.blk);
> +	}
> +
> +	return 0;
> +}
> +
> +static void fallback_exit_cip(struct crypto_tfm *tfm)
> +{
> +	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> +
> +	crypto_free_cipher(op->fallback.cip);
> +	op->fallback.cip = NULL;
> +}
>  
>  static struct crypto_alg geode_alg = {
> -	.cra_name               =       "aes",
> -	.cra_driver_name	=       "geode-aes-128",
> -	.cra_priority           =       300,
> -	.cra_alignmask          =       15,
> -	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
> +	.cra_name			=	"aes",
> +	.cra_driver_name	=	"geode-aes",
> +	.cra_priority		=	300,
> +	.cra_alignmask		=	15,
> +	.cra_flags			=	CRYPTO_ALG_TYPE_CIPHER |
> +							CRYPTO_ALG_NEED_FALLBACK,
> +	.cra_init			=	fallback_init_cip,
> +	.cra_exit			=	fallback_exit_cip,
>  	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
>  	.cra_ctxsize		=	sizeof(struct geode_aes_op),
> -	.cra_module		=	THIS_MODULE,
> -	.cra_list		=	LIST_HEAD_INIT(geode_alg.cra_list),
> -	.cra_u			=	{
> -		.cipher = {
> -			.cia_min_keysize	=  AES_KEY_LENGTH,
> -			.cia_max_keysize	=  AES_KEY_LENGTH,
> -			.cia_setkey		=  geode_setkey,
> -			.cia_encrypt		=  geode_encrypt,
> -			.cia_decrypt		=  geode_decrypt
> +	.cra_module			=	THIS_MODULE,
> +	.cra_list			=	LIST_HEAD_INIT(geode_alg.cra_list),
> +	.cra_u				=	{
> +		.cipher	=	{
> +			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
> +			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
> +			.cia_setkey			=	geode_setkey_cip,
> +			.cia_encrypt		=	geode_encrypt,
> +			.cia_decrypt		=	geode_decrypt
>  		}
>  	}
>  };
> @@ -196,6 +311,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err, ret;
>  
> +	if (unlikely(op->keylen != AES_KEYSIZE_128))
> +		return fallback_blk_dec(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
> @@ -226,6 +344,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err, ret;
>  
> +	if (unlikely(op->keylen != AES_KEYSIZE_128))
> +		return fallback_blk_enc(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
> @@ -246,22 +367,49 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
>  	return err;
>  }
>  
> +static int fallback_init_blk(struct crypto_tfm *tfm)
> +{
> +	const char *name = tfm->__crt_alg->cra_name;
> +	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> +
> +	op->fallback.blk = crypto_alloc_blkcipher(name, 0,
> +			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +
> +	if (IS_ERR(op->fallback.blk)) {
> +		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
> +		return PTR_ERR(op->fallback.blk);
> +	}
> +
> +	return 0;
> +}
> +
> +static void fallback_exit_blk(struct crypto_tfm *tfm)
> +{
> +	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
> +
> +	crypto_free_blkcipher(op->fallback.blk);
> +	op->fallback.blk = NULL;
> +}
> +
>  static struct crypto_alg geode_cbc_alg = {
>  	.cra_name		=	"cbc(aes)",
> -	.cra_driver_name	=	"cbc-aes-geode-128",
> +	.cra_driver_name	=	"cbc-aes-geode",
>  	.cra_priority		=	400,
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> +	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
> +							CRYPTO_ALG_NEED_FALLBACK,
> +	.cra_init			=	fallback_init_blk,
> +	.cra_exit			=	fallback_exit_blk,
>  	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
>  	.cra_ctxsize		=	sizeof(struct geode_aes_op),
>  	.cra_alignmask		=	15,
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_list		=	LIST_HEAD_INIT(geode_cbc_alg.cra_list),
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	AES_KEY_LENGTH,
> -			.max_keysize		=	AES_KEY_LENGTH,
> -			.setkey			=	geode_setkey,
> +	.cra_type			=	&crypto_blkcipher_type,
> +	.cra_module			=	THIS_MODULE,
> +	.cra_list			=	LIST_HEAD_INIT(geode_cbc_alg.cra_list),
> +	.cra_u				=	{
> +		.blkcipher	=	{
> +			.min_keysize	=	AES_MIN_KEY_SIZE,
> +			.max_keysize	=	AES_MAX_KEY_SIZE,
> +			.setkey			=	geode_setkey_blk,
>  			.encrypt		=	geode_cbc_encrypt,
>  			.decrypt		=	geode_cbc_decrypt,
>  			.ivsize			=	AES_IV_LENGTH,
> @@ -278,6 +426,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err, ret;
>  
> +	if (unlikely(op->keylen != AES_KEYSIZE_128))
> +		return fallback_blk_dec(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  
> @@ -305,6 +456,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err, ret;
>  
> +	if (unlikely(op->keylen != AES_KEYSIZE_128))
> +		return fallback_blk_enc(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  
> @@ -324,21 +478,24 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
>  }
>  
>  static struct crypto_alg geode_ecb_alg = {
> -	.cra_name		=	"ecb(aes)",
> -	.cra_driver_name	=	"ecb-aes-geode-128",
> +	.cra_name			=	"ecb(aes)",
> +	.cra_driver_name	=	"ecb-aes-geode",
>  	.cra_priority		=	400,
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> +	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
> +							CRYPTO_ALG_NEED_FALLBACK,
> +	.cra_init			=	fallback_init_blk,
> +	.cra_exit			=	fallback_exit_blk,
>  	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
>  	.cra_ctxsize		=	sizeof(struct geode_aes_op),
>  	.cra_alignmask		=	15,
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_list		=	LIST_HEAD_INIT(geode_ecb_alg.cra_list),
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	AES_KEY_LENGTH,
> -			.max_keysize		=	AES_KEY_LENGTH,
> -			.setkey			=	geode_setkey,
> +	.cra_type			=	&crypto_blkcipher_type,
> +	.cra_module			=	THIS_MODULE,
> +	.cra_list			=	LIST_HEAD_INIT(geode_ecb_alg.cra_list),
> +	.cra_u				=	{
> +		.blkcipher	=	{
> +			.min_keysize	=	AES_MIN_KEY_SIZE,
> +			.max_keysize	=	AES_MAX_KEY_SIZE,
> +			.setkey			=	geode_setkey_blk,
>  			.encrypt		=	geode_ecb_encrypt,
>  			.decrypt		=	geode_ecb_decrypt,
>  		}
> @@ -368,7 +525,7 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	if ((ret = pci_enable_device(dev)))
>  		return ret;
>  
> -	if ((ret = pci_request_regions(dev, "geode-aes-128")))
> +	if ((ret = pci_request_regions(dev, "geode-aes")))
>  		goto eenable;
>  
>  	_iobase = pci_iomap(dev, 0, 0);
> diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
> index 2f1d559..14cc763 100644
> --- a/drivers/crypto/geode-aes.h
> +++ b/drivers/crypto/geode-aes.h
> @@ -66,6 +66,12 @@ struct geode_aes_op {
>  
>  	u8 key[AES_KEY_LENGTH];
>  	u8 iv[AES_IV_LENGTH];
> +
> +	union {
> +		struct crypto_blkcipher *blk;
> +		struct crypto_cipher *cip;
> +	} fallback;
> +	u32 keylen;
>  };
>  
>  #endif
> -- 
> 1.5.3.4
> 
> 
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.
