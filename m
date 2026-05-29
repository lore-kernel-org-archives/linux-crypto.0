Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D130310777;
	Fri, 29 May 2026 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780060905; cv=none; b=ouOrvs7AtfOsoHnD6MwIBWE0qsI2mDruzea6RCQaTkb053+knzkWFURfZDmWMPhKsTsg/QblS+FFknjcKa9qUtZ86K0mR2nepZ/Pr3XD/FAOXE3fjOB6AXcU2optBwgZThEQbKJKrgfPRIARYJITuAL21DjqFhSdSAl3sgrRCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780060905; c=relaxed/simple;
	bh=EJ4wEVzp2uBwsSEhaQiExbLdRgtiLXaH0v5Dqt2TXUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ift8oJFJNeEvdu3qj/hloQmERAZQnnOdkrOx+VPZhbxqT2VeZE4FqXsb+HkG2CsI9zonpN7rs5hOh1JuWRUOHl7dEjfYMFT28RKGkunDqK0+wR1+kxCwJfYbyult2Yw0I3Ca1lYRKvwCUi31NwjDHhEnOYjdHtZYnkg1J7uP+cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQ1YtH0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQ1YtH0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D321F00893;
	Fri, 29 May 2026 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780060904;
	bh=ilKNT0BnEYa+r6YXK2ssr+TFhSBMtrfe/bSzt/gJnqM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JQ1YtH0oLVFeVmN171sbSRssotb1+fV7LyAA1RUX9psUxAHHwerB5RYNlrAvssuAX
	 Rbx1ugbUWuLgXoiyUATpPnEMgJyWp3MEKxMSmcWX4BtqYzSUcXZMBMCF+80s9/tZ5j
	 c3eBUfLCTEUhIMw7A/LdGQexKoUtW2GiODUUwEZlniHe4V/Kn/nQXWqUkGj5tV49/n
	 p9fB277BnZngRCSR215NZA+2ZOgkezuoRDBssJuATW3W2vOHpUPjw6S4LLO4hzfdY4
	 8c+cROT9tsejCjN9SAH4UpRk2WnqVtz4dE6RQR5u8KJHlAUm/aqH4QBncBn4bhxQH9
	 Gn8Uur/ZRWnVA==
Message-ID: <22245899-e046-41f1-8707-94f172b310e9@kernel.org>
Date: Fri, 29 May 2026 15:21:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/29] crypto: talitos - Prepare crypto implementation
 file splitting
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-5-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-5-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Paul,

Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Remove the static qualifier on multiple function that will be called
> inside each crypto implementation file.
> Add them to the main driver header file.

I didn't have time to look at the generated text yet but I'm a bit 
sceptic with this change, or more than the change itself, about its 
purpose. And even more when I see patches 24 and 25.

Most functions here are small helpers. To be shared between several C 
files they deserve becoming static inlines in talitos.h, not global 
functions.

Indeed, most of the time is_sec1 is known at build time because in most 
cases has_ftr_sec1() will constant fold into true or false during build. 
This is because it is very unlikely that someone build a kernel to run 
on both MPC 82xx and MPC 83xx at the same time. Therefore it is really 
unlikely that this in built with both CRYPTO_DEV_TALITOS1 and 
CRYPTO_DEV_TALITOS2 at the same time.

I can understand for a function like talitos_submit() but not for 
functions like to_talitos_ptr() or to_talitos_ptr_ext_set() whose 
purpose is really to get inlined into the caller.

Christophe


> 
> Add the common structures too.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>   drivers/crypto/talitos/talitos.c | 123 ++++++++++++++-------------------------
>   drivers/crypto/talitos/talitos.h |  91 +++++++++++++++++++++++++++++
>   2 files changed, 135 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index f5feff8f7d3d..3fc1069062da 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -40,8 +40,8 @@
>   
>   #include "talitos.h"
>   
> -static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
> -			   unsigned int len, bool is_sec1)
> +void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
> +		    unsigned int len, bool is_sec1)
>   {
>   	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
>   	if (is_sec1) {
> @@ -52,8 +52,8 @@ static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
>   	}
>   }
>   
> -static void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
> -			     struct talitos_ptr *src_ptr, bool is_sec1)
> +void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
> +		      struct talitos_ptr *src_ptr, bool is_sec1)
>   {
>   	dst_ptr->ptr = src_ptr->ptr;
>   	if (is_sec1) {
> @@ -64,8 +64,8 @@ static void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
>   	}
>   }
>   
> -static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
> -					   bool is_sec1)
> +unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
> +				    bool is_sec1)
>   {
>   	if (is_sec1)
>   		return be16_to_cpu(ptr->len1);
> @@ -73,14 +73,14 @@ static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
>   		return be16_to_cpu(ptr->len);
>   }
>   
> -static void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
> -				   bool is_sec1)
> +void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
> +			    bool is_sec1)
>   {
>   	if (!is_sec1)
>   		ptr->j_extent = val;
>   }
>   
> -static void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1)
> +void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1)
>   {
>   	if (!is_sec1)
>   		ptr->j_extent |= val;
> @@ -102,15 +102,15 @@ static void __map_single_talitos_ptr(struct device *dev,
>   	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
>   }
>   
> -static void map_single_talitos_ptr(struct device *dev,
> -				   struct talitos_ptr *ptr,
> -				   unsigned int len, void *data,
> -				   enum dma_data_direction dir)
> +void map_single_talitos_ptr(struct device *dev,
> +			    struct talitos_ptr *ptr,
> +			    unsigned int len, void *data,
> +			    enum dma_data_direction dir)
>   {
>   	__map_single_talitos_ptr(dev, ptr, len, data, dir, 0);
>   }
>   
> -static void map_single_talitos_ptr_nosync(struct device *dev,
> +void map_single_talitos_ptr_nosync(struct device *dev,
>   					  struct talitos_ptr *ptr,
>   					  unsigned int len, void *data,
>   					  enum dma_data_direction dir)
> @@ -122,9 +122,9 @@ static void map_single_talitos_ptr_nosync(struct device *dev,
>   /*
>    * unmap bus single (contiguous) h/w descriptor pointer
>    */
> -static void unmap_single_talitos_ptr(struct device *dev,
> -				     struct talitos_ptr *ptr,
> -				     enum dma_data_direction dir)
> +void unmap_single_talitos_ptr(struct device *dev,
> +			      struct talitos_ptr *ptr,
> +			      enum dma_data_direction dir)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	bool is_sec1 = has_ftr_sec1(priv);
> @@ -303,11 +303,11 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
>    * callback must check err and feedback in descriptor header
>    * for device processing status.
>    */
> -static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
> -			  void (*callback)(struct device *dev,
> -					   struct talitos_desc *desc,
> -					   void *context, int error),
> -			  void *context)
> +int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
> +		   void (*callback)(struct device *dev,
> +				    struct talitos_desc *desc,
> +				    void *context, int error),
> +		   void *context)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	struct talitos_request *request;
> @@ -830,24 +830,6 @@ DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
>    * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
>    */
>   #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
> -#ifdef CONFIG_CRYPTO_DEV_TALITOS2
> -#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
> -#else
> -#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
> -#endif
> -#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
> -
> -struct talitos_ctx {
> -	struct device *dev;
> -	int ch;
> -	__be32 desc_hdr_template;
> -	u8 key[TALITOS_MAX_KEY_SIZE];
> -	u8 iv[TALITOS_MAX_IV_LENGTH];
> -	dma_addr_t dma_key;
> -	unsigned int keylen;
> -	unsigned int enckeylen;
> -	unsigned int authkeylen;
> -};
>   
>   #define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
>   #define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
> @@ -939,7 +921,7 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
>   	return err;
>   }
>   
> -static void talitos_sg_unmap(struct device *dev,
> +void talitos_sg_unmap(struct device *dev,
>   			     struct talitos_edesc *edesc,
>   			     struct scatterlist *src,
>   			     struct scatterlist *dst,
> @@ -1124,7 +1106,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
>   	return count;
>   }
>   
> -static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
> +int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
>   			      unsigned int len, struct talitos_edesc *edesc,
>   			      struct talitos_ptr *ptr, int sg_count,
>   			      unsigned int offset, int tbl_off, int elen,
> @@ -1161,7 +1143,7 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
>   	return sg_count;
>   }
>   
> -static int talitos_sg_map(struct device *dev, struct scatterlist *src,
> +int talitos_sg_map(struct device *dev, struct scatterlist *src,
>   			  unsigned int len, struct talitos_edesc *edesc,
>   			  struct talitos_ptr *ptr, int sg_count,
>   			  unsigned int offset, int tbl_off)
> @@ -1299,17 +1281,17 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   /*
>    * allocate and map the extended descriptor
>    */
> -static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
> -						 struct scatterlist *src,
> -						 struct scatterlist *dst,
> -						 u8 *iv,
> -						 unsigned int assoclen,
> -						 unsigned int cryptlen,
> -						 unsigned int authsize,
> -						 unsigned int ivsize,
> -						 int icv_stashing,
> -						 u32 cryptoflags,
> -						 bool encrypt)
> +struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
> +					  struct scatterlist *src,
> +					  struct scatterlist *dst,
> +					  u8 *iv,
> +					  unsigned int assoclen,
> +					  unsigned int cryptlen,
> +					  unsigned int authsize,
> +					  unsigned int ivsize,
> +					  int icv_stashing,
> +					  u32 cryptoflags,
> +					  bool encrypt)
>   {
>   	struct talitos_edesc *edesc;
>   	int src_nents, dst_nents, alloc_len, dma_len, src_len, dst_len;
> @@ -2172,18 +2154,6 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
>   	return 0;
>   }
>   
> -
> -struct talitos_alg_template {
> -	u32 type;
> -	u32 priority;
> -	union {
> -		struct skcipher_alg skcipher;
> -		struct ahash_alg hash;
> -		struct aead_alg aead;
> -	} alg;
> -	__be32 desc_hdr_template;
> -};
> -
>   static struct talitos_alg_template driver_algs[] = {
>   	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> @@ -2998,14 +2968,8 @@ static struct talitos_alg_template driver_algs[] = {
>   	}
>   };
>   
> -struct talitos_crypto_alg {
> -	struct list_head entry;
> -	struct device *dev;
> -	struct talitos_alg_template algt;
> -};
> -
> -static int talitos_init_common(struct talitos_ctx *ctx,
> -			       struct talitos_crypto_alg *talitos_alg)
> +int talitos_init_common(struct talitos_ctx *ctx,
> +			struct talitos_crypto_alg *talitos_alg)
>   {
>   	struct talitos_private *priv;
>   
> @@ -3066,7 +3030,7 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
>   	return talitos_init_common(ctx, talitos_alg);
>   }
>   
> -static void talitos_cra_exit(struct crypto_tfm *tfm)
> +void talitos_cra_exit(struct crypto_tfm *tfm)
>   {
>   	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
>   	struct device *dev = ctx->dev;
> @@ -3080,7 +3044,7 @@ static void talitos_cra_exit(struct crypto_tfm *tfm)
>    * type and primary/secondary execution units required match the hw
>    * capabilities description provided in the device tree node.
>    */
> -static int hw_supports(struct device *dev, __be32 desc_hdr_template)
> +int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	int ret;
> @@ -3117,7 +3081,7 @@ static void talitos_remove(struct platform_device *ofdev)
>   		list_del(&t_alg->entry);
>   	}
>   
> -	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
> +	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG))
>   		talitos_unregister_rng(dev);
>   
>   	for (i = 0; i < 2; i++)
> @@ -3426,7 +3390,7 @@ static int talitos_probe(struct platform_device *ofdev)
>   	}
>   
>   	/* register the RNG, if available */
> -	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
> +	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG)) {
>   		err = talitos_register_rng(dev);
>   		if (err) {
>   			dev_err(dev, "failed to register hwrng: %d\n", err);
> @@ -3437,7 +3401,8 @@ static int talitos_probe(struct platform_device *ofdev)
>   
>   	/* register crypto algorithms the device supports */
>   	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
> -		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
> +		if (talitos_hw_supports(dev,
> +					driver_algs[i].desc_hdr_template)) {
>   			struct talitos_crypto_alg *t_alg;
>   			struct crypto_alg *alg = NULL;
>   
> diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
> index fa8c71b1f90f..1f81d336dae8 100644
> --- a/drivers/crypto/talitos/talitos.h
> +++ b/drivers/crypto/talitos/talitos.h
> @@ -5,7 +5,13 @@
>    * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
>    */
>   
> +#include <crypto/aes.h>
> +#include <crypto/internal/aead.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/sha2.h>
>   #include <linux/device.h>
> +#include <linux/dma-mapping.h>
>   #include <linux/hw_random.h>
>   #include <linux/interrupt.h>
>   #include <linux/scatterlist.h>
> @@ -19,6 +25,13 @@
>   #define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
>   #define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
>   
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS2
> +#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
> +#else
> +#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
> +#endif
> +#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
> +
>   /* descriptor pointer entry */
>   struct talitos_ptr {
>   	union {
> @@ -174,6 +187,35 @@ struct talitos_private {
>   
>   };
>   
> +struct talitos_ctx {
> +	struct device *dev;
> +	int ch;
> +	__be32 desc_hdr_template;
> +	u8 key[TALITOS_MAX_KEY_SIZE];
> +	u8 iv[TALITOS_MAX_IV_LENGTH];
> +	dma_addr_t dma_key;
> +	unsigned int keylen;
> +	unsigned int enckeylen;
> +	unsigned int authkeylen;
> +};
> +
> +struct talitos_alg_template {
> +	u32 type;
> +	u32 priority;
> +	union {
> +		struct skcipher_alg skcipher;
> +		struct ahash_alg hash;
> +		struct aead_alg aead;
> +	} alg;
> +	__be32 desc_hdr_template;
> +};
> +
> +struct talitos_crypto_alg {
> +	struct list_head entry;
> +	struct device *dev;
> +	struct talitos_alg_template algt;
> +};
> +
>   /* .features flag */
>   #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
>   #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
> @@ -432,6 +474,55 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
>   #define DESC_PTR_LNKTBL_RET			0x02
>   #define DESC_PTR_LNKTBL_NEXT			0x01
>   
> +void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
> +		    unsigned int len, bool is_sec1);
> +void copy_talitos_ptr(struct talitos_ptr *dst_ptr, struct talitos_ptr *src_ptr,
> +		      bool is_sec1);
> +unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr, bool is_sec1);
> +void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val, bool is_sec1);
> +void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1);
> +
> +void map_single_talitos_ptr(struct device *dev, struct talitos_ptr *ptr,
> +			    unsigned int len, void *data,
> +			    enum dma_data_direction dir);
> +void map_single_talitos_ptr_nosync(struct device *dev, struct talitos_ptr *ptr,
> +				   unsigned int len, void *data,
> +				   enum dma_data_direction dir);
> +void unmap_single_talitos_ptr(struct device *dev, struct talitos_ptr *ptr,
> +			      enum dma_data_direction dir);
> +
> +int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
> +		   void (*callback)(struct device *dev,
> +				    struct talitos_desc *desc, void *context,
> +				    int error),
> +		   void *context);
> +
> +void talitos_sg_unmap(struct device *dev, struct talitos_edesc *edesc,
> +		      struct scatterlist *src, struct scatterlist *dst,
> +		      unsigned int len, unsigned int offset);
> +int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
> +		       unsigned int len, struct talitos_edesc *edesc,
> +		       struct talitos_ptr *ptr, int sg_count,
> +		       unsigned int offset, int tbl_off, int elen, bool force,
> +		       int align);
> +int talitos_sg_map(struct device *dev, struct scatterlist *src,
> +		   unsigned int len, struct talitos_edesc *edesc,
> +		   struct talitos_ptr *ptr, int sg_count, unsigned int offset,
> +		   int tbl_off);
> +
> +struct talitos_edesc *
> +talitos_edesc_alloc(struct device *dev, struct scatterlist *src,
> +		    struct scatterlist *dst, u8 *iv, unsigned int assoclen,
> +		    unsigned int cryptlen, unsigned int authsize,
> +		    unsigned int ivsize, int icv_stashing, u32 cryptoflags,
> +		    bool encrypt);
> +
> +int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template);
> +
> +int talitos_init_common(struct talitos_ctx *ctx,
> +			struct talitos_crypto_alg *talitos_alg);
> +void talitos_cra_exit(struct crypto_tfm *tfm);
> +
>   /* Hardware RNG */
>   
>   int talitos_register_rng(struct device *dev);
> 

