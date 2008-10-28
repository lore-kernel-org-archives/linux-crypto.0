From: James Hsiao <jhsiao@amcc.com>
Subject: [PATCH] AMCC Crypto4xx Device Driver v2
Date: Mon, 27 Oct 2008 18:55:32 -0700
Message-ID: <1225158932.4768.29.camel@jhsiao-usb>
References: <1225158336-8777-1-git-send-email-jhsiao@amcc.com>
Reply-To: jhsiao@amcc.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:52277 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYJ1ByU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Oct 2008 21:54:20 -0400
In-Reply-To: <1225158336-8777-1-git-send-email-jhsiao@amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

This patch was reviewed by Kim Phillips. 
Kim suggest us submit this to linuxppc-dev for more review.

Regards
James
> Signed-off-by: James Hsiao <jhsiao@amcc.com>
> ---
>  arch/powerpc/boot/dts/kilauea.dts       |   10 +-
>  drivers/crypto/Kconfig                  |    9 +
>  drivers/crypto/Makefile                 |    1 +
>  drivers/crypto/amcc/Makefile            |   27 +
>  drivers/crypto/amcc/crypto4xx_alg.c     |  404 ++++++++++
>  drivers/crypto/amcc/crypto4xx_core.c    | 1220 +++++++++++++++++++++++++++++++
>  drivers/crypto/amcc/crypto4xx_core.h    |  200 +++++
>  drivers/crypto/amcc/crypto4xx_reg_def.h |  291 ++++++++
>  drivers/crypto/amcc/crypto4xx_sa.c      |   98 +++
>  drivers/crypto/amcc/crypto4xx_sa.h      |  223 ++++++
>  10 files changed, 2482 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/crypto/amcc/Makefile
>  create mode 100644 drivers/crypto/amcc/crypto4xx_alg.c
>  create mode 100644 drivers/crypto/amcc/crypto4xx_core.c
>  create mode 100644 drivers/crypto/amcc/crypto4xx_core.h
>  create mode 100644 drivers/crypto/amcc/crypto4xx_reg_def.h
>  create mode 100644 drivers/crypto/amcc/crypto4xx_sa.c
>  create mode 100644 drivers/crypto/amcc/crypto4xx_sa.h
> 
> diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
> index dececc4..58b48a0 100644
> --- a/arch/powerpc/boot/dts/kilauea.dts
> +++ b/arch/powerpc/boot/dts/kilauea.dts
> @@ -1,4 +1,4 @@
> -/*
> +/* 
>   * Device Tree Source for AMCC Kilauea (405EX)
>   *
>   * Copyright 2007 DENX Software Engineering, Stefan Roese <sr@denx.de>
> @@ -94,6 +94,14 @@
>  			dcr-reg = <0x010 0x002>;
>  		};
>  
> +		CRYPTO: crypto@ef700000 {
> +			device_type = "crypto";	
> +			compatible = "amcc,ppc4xx-crypto";
> +			reg = <0xef700000 0x80400>;
> +			interrupt-parent = <&UIC0>;
> +			interrupts = <0x17 0x2>;
> +		};
> +
>  		MAL0: mcmal {
>  			compatible = "ibm,mcmal-405ex", "ibm,mcmal2";
>  			dcr-reg = <0x180 0x062>;
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index e522144..d761664 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -200,4 +200,13 @@ config CRYPTO_DEV_IXP4XX
>  	help
>  	  Driver for the IXP4xx NPE crypto engine.
>  
> +config CRYPTO_DEV_PPC4XX
> +	tristate "Driver AMCC PPC4XX crypto accelerator"
> +	depends on PPC && 4xx
> +	select CRYPTO_HASH
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_BLKCIPHER
> +	help
> +	  This option allows you to have support for AMCC crypto acceleration.
> +
>  endif # CRYPTO_HW
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 73557b2..9bf4a2b 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -4,3 +4,4 @@ obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
>  obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
>  obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
> +obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
> diff --git a/drivers/crypto/amcc/Makefile b/drivers/crypto/amcc/Makefile
> new file mode 100644
> index 0000000..4b06655
> --- /dev/null
> +++ b/drivers/crypto/amcc/Makefile
> @@ -0,0 +1,27 @@
> +################################################################################
> +#  (C) Copyright 2007 Applied Micro Circuits Corporation
> +#  James Hsiao, AMCC, support@amcc.com
> +# 
> +#  This program is free software; you can redistribute it and/or
> +#  modify it under the terms of the GNU General Public License as
> +#  published by the Free Software Foundation; either version 2 of
> +#  the License, or (at your option) any later version.
> +# 
> +#  This program is distributed in the hope that it will be useful,
> +#  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +#  GNU General Public License for more details.
> +# 
> +#  You should have received a copy of the GNU General Public License
> +#  along with this program; if not, write to the Free Software
> +#  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> +#  MA 02111-1307 USA
> +# 
> +################################################################################
> +#
> +# Makefile for the AMCC Crypto Acclerator Device Driver
> +#
> +
> +obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += crypto4xx.o
> +
> +crypto4xx-objs :=  crypto4xx_core.o crypto4xx_alg.o crypto4xx_sa.o
> diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
> new file mode 100644
> index 0000000..7dfe6a6
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_alg.c
> @@ -0,0 +1,404 @@
> +/*****************************************************************************
> + * AMCC SoC Crypto4XX Driver
> + *
> + * Copyright (c) 2008 Applied Micro Circuits Corporation.
> + * All rights reserved. James Hsiao <jhsiao@amcc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * @file crypto4xx_alg.c
> + *
> + * This file implements the Linux crypto algorithms.
> + *
> + *****************************************************************************
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock_types.h>
> +#include <linux/highmem.h>
> +#include <linux/scatterlist.h>
> +#include <linux/crypto.h>
> +#include <linux/hash.h>
> +#include <crypto/internal/hash.h>
> +#include <linux/pci.h>
> +#include <linux/rtnetlink.h>
> +#include <crypto/aead.h>
> +#include <crypto/algapi.h>
> +#include <crypto/des.h>
> +#include <crypto/authenc.h>
> +
> +#include "crypto4xx_reg_def.h"
> +#include "crypto4xx_sa.h"
> +#include "crypto4xx_core.h"
> +
> +static inline int crypto4xx_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct crypto4xx_ctx *rctx = ablkcipher_request_ctx(req);
> +	int    rc;
> +
> +	/*
> +	 * Application only provided ptr for the rctx
> +	 * we alloc memory for it.
> +	 * And along we alloc memory for the sa in it.
> +	 */
> +	ctx->use_rctx = 1;
> +	ctx->direction = CRYPTO_OUTBOUND;
> +	rc = crypto4xx_alloc_sa_rctx(ctx, rctx);
> +	if (rc)
> +		goto err_nomem;
> +	memcpy((void *)(rctx->sa_out +
> +		get_dynamic_sa_offset_state_ptr_field(rctx)),
> +		(void *)&(rctx->state_record_dma_addr), 4);
> +	/* copy req->iv to state_record->iv */
> +	if (req->info)
> +		crypto4xx_memcpy_le(rctx->state_record, req->info,
> +				get_dynamic_sa_iv_size(rctx));
> +	else
> +		memset(rctx->state_record, 0, get_dynamic_sa_iv_size(rctx));
> +	rctx->hash_final = 0;
> +	rctx->is_hash = 0;
> +	rctx->pd_ctl = 0x1;
> +	rctx->direction = CRYPTO_OUTBOUND;
> +
> +	return crypto4xx_handle_req(&req->base);
> +
> +err_nomem:
> +	return -ENOMEM;
> +}
> +
> +static inline int crypto4xx_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct crypto4xx_ctx *rctx = ablkcipher_request_ctx(req);
> +	int    rc;
> +
> +	/*
> +	 * Application only provided ptr for the rctx
> +	 * we alloc memory for it.
> +	 * And along we alloc memory for the sa in it
> +	 */
> +	ctx->use_rctx = 1;
> +	ctx->direction = CRYPTO_INBOUND;
> +	rc = crypto4xx_alloc_sa_rctx(ctx, rctx);
> +	if (rc != 0)
> +		goto err_nomem;
> +
> +	memcpy((void *)(rctx->sa_in +
> +		get_dynamic_sa_offset_state_ptr_field(rctx)),
> +		(void *)&(rctx->state_record_dma_addr), 4);
> +	/* copy req->iv to state_record->iv */
> +	if (req->info)
> +		crypto4xx_memcpy_le(rctx->state_record, req->info,
> +				get_dynamic_sa_iv_size(rctx));
> +	else
> +		memset(rctx->state_record, 0, get_dynamic_sa_iv_size(rctx));
> +
> +	rctx->hash_final = 0;
> +	rctx->is_hash = 0;
> +	rctx->pd_ctl = 1;
> +	rctx->direction = CRYPTO_INBOUND;
> +
> +	return crypto4xx_handle_req(&req->base);
> +
> +err_nomem:
> +	return -ENOMEM;
> +}
> +
> +/**
> + * AES Functions
> + *
> + */
> +static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
> +				 const u8 *key,
> +				 unsigned int keylen,
> +				 unsigned char cm,
> +				 u8 fb)
> +{
> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct dynamic_sa_ctl *sa;
> +	int    rc;
> +
> +	if ((keylen != 256/8) &&  (keylen != 128/8) &&  (keylen != 192/8)) {
> +		crypto_ablkcipher_set_flags(cipher,
> +				CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -1;
> +	}
> +
> +	/* Create SA */
> +	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
> +		crypto4xx_free_sa(ctx);
> +
> +	if (keylen == 256/8)
> +		crypto4xx_alloc_sa(ctx, SA_AES256_LEN);
> +	else if (keylen == 192/8)
> +		crypto4xx_alloc_sa(ctx, SA_AES192_LEN);
> +	else
> +		crypto4xx_alloc_sa(ctx, SA_AES128_LEN);
> +
> +	if (!ctx->sa_in_dma_addr || !ctx->sa_out_dma_addr)
> +		goto err_nomem;
> +	if (ctx->state_record_dma_addr == 0) {
> +		rc = crypto4xx_alloc_state_record(ctx);
> +		if (rc != 0)
> +			goto err_nomem_sr;
> +	}
> +	/* Setup SA */
> +	sa = (struct dynamic_sa_ctl *)(ctx->sa_in);
> +	ctx->hash_final = 0;
> +	sa->sa_command_0.bf.hash_alg = SA_HASH_ALG_NULL;
> +	sa->sa_command_0.bf.cipher_alg = SA_CIPHER_ALG_AES;
> +	sa->sa_command_0.bf.opcode = SA_OPCODE_ENCRYPT;
> +	sa->sa_command_0.bf.load_iv = 2;
> +
> +	sa->sa_command_1.bf.sa_rev = 1;
> +	sa->sa_command_1.bf.copy_payload = 0;
> +	sa->sa_command_1.bf.crypto_mode31 = (cm & 4) >> 2;
> +	sa->sa_command_1.bf.crypto_mode9_8 = (cm & 3);
> +	sa->sa_command_1.bf.feedback_mode = fb;
> +	sa->sa_command_1.bf.mutable_bit_proc = 1;
> +
> +	if (keylen >= 256/8) {
> +		crypto4xx_memcpy_le(((struct dynamic_sa_aes256 *)sa)->key,
> +					key, keylen);
> +		sa->sa_contents = SA_AES256_CONTENTS;
> +		sa->sa_command_1.bf.key_len = SA_AES_KEY_LEN_256;
> +	} else if (keylen >= 192/8) {
> +		crypto4xx_memcpy_le(((struct dynamic_sa_aes192 *)sa)->key,
> +					key, keylen);
> +		sa->sa_contents = SA_AES192_CONTENTS;
> +		sa->sa_command_1.bf.key_len = SA_AES_KEY_LEN_192;
> +	} else {
> +		crypto4xx_memcpy_le(((struct dynamic_sa_aes128 *)sa)->key,
> +					key, keylen);
> +		sa->sa_contents = SA_AES128_CONTENTS;
> +		sa->sa_command_1.bf.key_len = SA_AES_KEY_LEN_128;
> +	}
> +	ctx->is_hash = 0;
> +	ctx->direction = CRYPTO_INBOUND;
> +	sa->sa_command_0.bf.dir = CRYPTO_INBOUND;
> +	memcpy(ctx->sa_in + get_dynamic_sa_offset_state_ptr_field(ctx),
> +			(void *)&(ctx->state_record_dma_addr), 4);
> +	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len*4);
> +	sa = (struct dynamic_sa_ctl *)(ctx->sa_out);
> +	sa->sa_command_0.bf.dir = CRYPTO_OUTBOUND;
> +
> +	return 0;
> +
> +err_nomem_sr:
> +	crypto4xx_free_sa(ctx);
> +
> +err_nomem:
> +	return -ENOMEM;
> +
> +}
> +
> +static inline int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
> +					   const u8 *key, unsigned int keylen)
> +{
> +	return crypto4xx_setkey_aes(cipher, key, keylen,
> +				    CRYPTO_MODE_CBC,
> +				    CRYPTO_FEEDBACK_MODE_NO_FB);
> +}
> +
> +/**
> + * HASH SHA1 Functions
> + *
> + */
> +static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
> +				   unsigned int sa_len,
> +				   unsigned char ha,
> +				   unsigned char hm)
> +{
> +	struct crypto_alg *alg = tfm->__crt_alg;
> +	struct crypto4xx_alg *my_alg = crypto_alg_to_crypto4xx_alg(alg);
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct dynamic_sa_ctl *sa;
> +
> +	ctx->dev   = my_alg->dev;
> +	ctx->is_hash = 1;
> +	ctx->hash_final = 0;
> +
> +	/* Create SA */
> +	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
> +		crypto4xx_free_sa(ctx);
> +
> +	crypto4xx_alloc_sa(ctx, sa_len);
> +	if (!ctx->sa_in_dma_addr || !ctx->sa_out_dma_addr)
> +		goto err_nomem;
> +
> +	if (ctx->state_record_dma_addr == 0) {
> +		crypto4xx_alloc_state_record(ctx);
> +		if (!ctx->state_record_dma_addr)
> +			goto err_nomem_sr;
> +	}
> +
> +	tfm->crt_ahash.reqsize = sizeof(struct crypto4xx_ctx);
> +	sa = (struct dynamic_sa_ctl *)(ctx->sa_in);
> +
> +	/* Setup hash algorithm and hash mode */
> +	sa->sa_command_0.w = 0;
> +	sa->sa_command_0.bf.hash_alg = ha;
> +	sa->sa_command_0.bf.gather = 0;
> +	sa->sa_command_0.bf.save_hash_state = 1;
> +	sa->sa_command_0.bf.cipher_alg = SA_CIPHER_ALG_NULL;
> +	sa->sa_command_0.bf.opcode = SA_OPCODE_HASH;
> +
> +	/* load hash state set to no load, since we don't no init idigest  */
> +	sa->sa_command_0.bf.load_hash_state = 3;
> +	sa->sa_command_0.bf.dir = 0;
> +	sa->sa_command_0.bf.opcode = SA_OPCODE_HASH;
> +	sa->sa_command_1.w = 0;
> +	sa->sa_command_1.bf.hmac_muting = 0;
> +	/* dynamic sa, need to set it to  rev 2 */
> +	sa->sa_command_1.bf.sa_rev = 1;
> +	sa->sa_command_1.bf.copy_payload = 0;
> +	sa->sa_command_1.bf.mutable_bit_proc = 1;
> +
> +	/* Need to zero hash digest in SA */
> +	if (ha == SA_HASH_ALG_SHA1) {
> +		sa->sa_contents = SA_HASH160_CONTENTS;
> +		memset(((struct dynamic_sa_hash160 *)
> +				(ctx->sa_in))->inner_digest, 0, 20);
> +		memset(((struct dynamic_sa_hash160 *)
> +				(ctx->sa_in))->outer_digest, 0, 20);
> +		((struct dynamic_sa_hash160 *)(ctx->sa_in))->state_ptr
> +				= ctx->state_record_dma_addr;
> +	} else {
> +		printk(KERN_ERR "ERROR: invalid hash"
> +				" algorithm used \n");
> +	}
> +
> +	return 0;
> +
> +err_nomem_sr:
> +	crypto4xx_free_sa(ctx);
> +err_nomem:
> +	return -ENOMEM;
> +
> +}
> +
> +static int crypto4xx_hash_init(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	int ds;
> +	struct dynamic_sa_ctl *sa;
> +
> +	ctx->use_rctx = 0;
> +	sa = (struct dynamic_sa_ctl *)(ctx->sa_in);
> +	ds = crypto_ahash_digestsize(
> +			__crypto_ahash_cast(req->base.tfm));
> +	sa->sa_command_0.bf.digest_len = ds>>2;
> +	sa->sa_command_0.bf.load_hash_state = SA_LOAD_HASH_FROM_SA;
> +	ctx->is_hash = 1;
> +	ctx->direction = CRYPTO_INBOUND;
> +
> +	return 0;
> +}
> +
> +static int crypto4xx_hash_update(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +
> +	ctx->is_hash = 1;
> +	ctx->hash_final = 0;
> +	ctx->use_rctx = 0;
> +	ctx->pd_ctl = 0x11;
> +	ctx->direction = CRYPTO_INBOUND;
> +	return crypto4xx_handle_req(&req->base);
> +}
> +
> +static int crypto4xx_hash_final(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *rctx = ahash_request_ctx(req);
> +
> +	crypto4xx_free_sa_rctx(rctx);
> +	return 0;
> +}
> +
> +static int crypto4xx_hash_digest(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	ctx->use_rctx = 0;
> +	ctx->hash_final = 1;
> +	ctx->pd_ctl = 0x11;
> +	ctx->direction = CRYPTO_INBOUND;
> +	return crypto4xx_handle_req(&req->base);
> +}
> +
> +/**
> + * SHA1 and SHA2 Algorithm
> + */
> +static int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm)
> +{
> +	return crypto4xx_hash_alg_init(tfm,
> +				       SA_HASH160_LEN,
> +				       SA_HASH_ALG_SHA1,
> +				       SA_HASH_MODE_HASH);
> +}
> +
> +/**
> + * Support Crypto Algorithms
> + */
> +struct crypto_alg crypto4xx_basic_alg[] = {
> +
> +	/* Crypto AES modes */
> +	{.cra_name 		= "cbc(aes)",
> +	 .cra_driver_name 	= "cbc-aes-ppc4xx",
> +	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
> +	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> +	 .cra_blocksize 	= 16,	/* 128-bits block */
> +	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
> +	 .cra_alignmask 	= 0,
> +	 .cra_type 		= &crypto_ablkcipher_type,
> +	 .cra_module 		= THIS_MODULE,
> +	 .cra_u 		= {.ablkcipher = {
> +	 .min_keysize 		= 16,	/* AES min key size is 128-bits */
> +	 .max_keysize 		= 32,	/* AES max key size is 256-bits */
> +	 .ivsize 		= 16,	/* IV size is 16 bytes */
> +	 .setkey 		= crypto4xx_setkey_aes_cbc,
> +	 .encrypt 		= crypto4xx_encrypt,
> +	 .decrypt 		= crypto4xx_decrypt,
> +	 } }
> +	},
> +	/* Hash SHA1, SHA2 */
> +	{.cra_name 		= "sha1",
> +	 .cra_driver_name 	= "sha1-ppc4xx",
> +	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
> +	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
> +	 .cra_blocksize 	= 64,	/* SHA1 block size is 512-bits */
> +	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
> +	 .cra_alignmask 	= 0,
> +	 .cra_type   		= &crypto_ahash_type,
> +	 .cra_init 		= crypto4xx_sha1_alg_init,
> +	 .cra_module 		= THIS_MODULE,
> +	 .cra_u  		= {.ahash = {
> +	 .digestsize 		= 20,	/* Disgest is 160-bits */
> +	 .init   		= crypto4xx_hash_init,
> +	 .update 		= crypto4xx_hash_update,
> +	 .final  		= crypto4xx_hash_final,
> +	 .digest 		= crypto4xx_hash_digest,
> +	 } }
> +	},
> +};
> +
> +int crypto4xx_register_basic_alg(void)
> +{
> +	return crypto4xx_register_alg(&lsec_core.dev,
> +					crypto4xx_basic_alg,
> +					ARRAY_SIZE(crypto4xx_basic_alg));
> +}
> +
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> new file mode 100644
> index 0000000..7845a25
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -0,0 +1,1220 @@
> +/****************************************************************************
> + * AMCC SoC Crypto4XX Driver
> + *
> + * Copyright (c) 2008 Applied Micro Circuits Corporation.
> + * All rights reserved. James Hsiao <jhsiao@amcc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * @file   crypto4xx_core.c
> + *
> + * This file implements AMCC crypto offload Linux device driver for use with
> + * Linux CryptoAPI.
> + *
> + ****************************************************************************
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/interrupt.h>
> +#include <linux/completion.h>
> +#include <linux/spinlock_types.h>
> +#include <linux/highmem.h>
> +#include <linux/random.h>
> +#include <linux/scatterlist.h>
> +#include <linux/crypto.h>
> +#include <crypto/algapi.h>
> +#include <crypto/des.h>
> +#include <linux/slab.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/proc_fs.h>
> +#include <linux/timer.h>
> +#include <linux/of_platform.h>
> +#include <asm/dcr.h>
> +#include <asm/dcr-regs.h>
> +#include <asm/cacheflush.h>
> +#include <crypto/internal/hash.h>
> +#include "crypto4xx_reg_def.h"
> +#include "crypto4xx_core.h"
> +#include "crypto4xx_sa.h"
> +
> +#define CRYPTO4XX_CRYPTO_PRIORITY	300
> +#define PPC4XX_SEC_VERSION_STR		"0.1"
> +
> +struct crypto4xx_core_device lsec_core;
> +
> +u32 crypto4xx_write32(u32 reg, u32 val)
> +{
> +	writel(val, lsec_core.ce_base + reg);
> +	return 0;
> +}
> +
> +u32 crypto4xx_read32(u32 reg, u32 *val)
> +{
> +	*val = readl(lsec_core.ce_base + reg);
> +	return 0;
> +}
> +
> +/**
> + * PPC4XX Crypto Engine Initialization Routine
> + */
> +int32_t crypto4xx_init(struct crypto4xx_device  *dev)
> +{
> +	u32 rc = 0;
> +	union ce_ring_size ring_size;
> +	union ce_ring_contol ring_ctrl;
> +	union ce_part_ring_size part_ring_size;
> +	union ce_io_threshold io_threshold;
> +	u32 rand_num;
> +
> +	union ce_pe_dma_cfg pe_dma_cfg;
> +	if ((cur_cpu_spec->pvr_value & 0xffff0000) == 0x13020000) {
> +		mtdcri(SDR0, 0x201, mfdcri(SDR0, 0x201) | 0x08000000);
> +		mtdcri(SDR0, 0x201, mfdcri(SDR0, 0x201) & ~0x08000000);
> +	} else if  ((cur_cpu_spec->pvr_value & 0xffff0000) == 0x12910000) {
> +		mtdcri(SDR0, 0x200, mfdcri(SDR0, 0x200) | 0x00000008);
> +		mtdcri(SDR0, 0x200, mfdcri(SDR0, 0x200) & ~0x00000008);
> +	} else if ((cur_cpu_spec->pvr_value & 0xffff0000) == 0x13540000) {
> +		mtdcri(SDR0, 0x201, mfdcri(SDR0, 0x201) | 0x20000000);
> +		mtdcri(SDR0, 0x201, mfdcri(SDR0, 0x201) & ~0x20000000);
> +	} else {
> +		printk(KERN_ERR "Crypto Function Not supported!\n");
> +		return -EINVAL;
> +	}
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_BYTE_ORDER_CFG, 0x22222);
> +
> +	/* setup pe dma, include reset sg, pdr and pe, then release reset */
> +	pe_dma_cfg.w = 0;
> +
> +	pe_dma_cfg.bf.bo_sgpd_en = 1;
> +	pe_dma_cfg.bf.bo_data_en = 0;
> +	pe_dma_cfg.bf.bo_sa_en = 1;
> +	pe_dma_cfg.bf.bo_pd_en = 1;
> +
> +	pe_dma_cfg.bf.dynamic_sa_en = 1;
> +	pe_dma_cfg.bf.reset_sg = 1;
> +	pe_dma_cfg.bf.reset_pdr = 1;
> +	pe_dma_cfg.bf.reset_pe = 1;
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_PE_DMA_CFG, pe_dma_cfg.w);
> +
> +	/* un reset pe,sg and pdr */
> +	pe_dma_cfg.bf.pe_mode = 0;
> +	pe_dma_cfg.bf.reset_sg = 0;
> +	pe_dma_cfg.bf.reset_pdr = 0;
> +	pe_dma_cfg.bf.reset_pe = 0;
> +	pe_dma_cfg.bf.bo_td_en = 0;
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_PE_DMA_CFG, pe_dma_cfg.w);
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_PDR_BASE, dev->pdr_pa);
> +	crypto4xx_write32(CRYPTO_ENGINE_RDR_BASE, dev->pdr_pa);
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_PRNG_CTRL, 3);
> +	get_random_bytes(&rand_num, sizeof(rand_num));
> +	crypto4xx_write32(CRYPTO_ENGINE_PRNG_SEED_L, rand_num);
> +	get_random_bytes(&rand_num, sizeof(rand_num));
> +	crypto4xx_write32(CRYPTO_ENGINE_PRNG_SEED_L, rand_num);
> +
> +	ring_size.w = 0;
> +	ring_size.bf.ring_offset = PPC4XX_PD_SIZE;
> +	ring_size.bf.ring_size   = PPC4XX_NUM_PD;
> +	crypto4xx_write32(CRYPTO_ENGINE_RING_SIZE, ring_size.w);
> +
> +	ring_ctrl.w = 0;
> +	crypto4xx_write32(CRYPTO_ENGINE_RING_CTRL, ring_ctrl.w);
> +	crypto4xx_write32(CRYPTO_ENGINE_DC_CTRL, 1);
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_GATH_RING_BASE, dev->gdr_pa);
> +	crypto4xx_write32(CRYPTO_ENGINE_SCAT_RING_BASE, dev->sdr_pa);
> +
> +	part_ring_size.w = 0;
> +	part_ring_size.bf.sdr_size = PPC4XX_SDR_SIZE;
> +	part_ring_size.bf.gdr_size = PPC4XX_GDR_SIZE;
> +	crypto4xx_write32(CRYPTO_ENGINE_PART_RING_SIZE, part_ring_size.w);
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_PART_RING_CFG,
> +			  0x0000ffff & PPC4XX_SD_BUFFER_SIZE);
> +	io_threshold.w = 0;
> +	io_threshold.bf.output_threshold = PPC4XX_OUTPUT_THRESHOLD;
> +	io_threshold.bf.input_threshold  = PPC4XX_INPUT_THRESHOLD;
> +	crypto4xx_write32(CRYPTO_ENGINE_IO_THRESHOLD, io_threshold.w);
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_PDR_BASE_UADDR, 0x0);
> +	crypto4xx_write32(CRYPTO_ENGINE_RDR_BASE_UADDR, 0x0);
> +	crypto4xx_write32(CRYPTO_ENGINE_PKT_SRC_UADDR, 0x0);
> +	crypto4xx_write32(CRYPTO_ENGINE_PKT_DEST_UADDR, 0x0);
> +	crypto4xx_write32(CRYPTO_ENGINE_SA_UADDR, 0x0);
> +	crypto4xx_write32(CRYPTO_ENGINE_GATH_RING_BASE_UADDR, 0x0);
> +	crypto4xx_write32(CRYPTO_ENGINE_SCAT_RING_BASE_UADDR, 0x0);
> +
> +	/* un reset pe,sg and pdr */
> +	pe_dma_cfg.bf.pe_mode = 1;
> +	pe_dma_cfg.bf.reset_sg = 0;
> +	pe_dma_cfg.bf.reset_pdr = 0;
> +	pe_dma_cfg.bf.reset_pe = 0;
> +	pe_dma_cfg.bf.bo_td_en = 0;
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_PE_DMA_CFG, pe_dma_cfg.w);
> +	/*clear all pending interrupt*/
> +	crypto4xx_write32(CRYPTO_ENGINE_INT_CLR, 0x3ffff);
> +	crypto4xx_write32(CRYPTO_ENGINE_INT_DESCR_CNT, PPC4XX_INT_DESCR_CNT);
> +
> +	crypto4xx_write32(CRYPTO_ENGINE_INT_TIMEOUT_CNT,
> +			  PPC4XX_INT_TIMEOUT_CNT);
> +	crypto4xx_write32(CRYPTO_ENGINE_INT_CFG, PPC4XX_INT_CFG);
> +	crypto4xx_write32(CRYPTO_ENGINE_INT_EN, CRYPTO_PD_DONE_INT);
> +
> +	return rc;
> +}
> +
> +void crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size)
> +{
> +	ctx->sa_in = dma_alloc_coherent(NULL, size * 4,
> +					&ctx->sa_in_dma_addr, GFP_ATOMIC);
> +	ctx->sa_out = dma_alloc_coherent(NULL, size * 4,
> +					&ctx->sa_out_dma_addr, GFP_ATOMIC);
> +	ctx->sa_len = size;
> +}
> +
> +void crypto4xx_free_sa(struct crypto4xx_ctx *ctx)
> +{
> +	if (ctx->sa_in != NULL)
> +		dma_free_coherent(NULL, ctx->sa_len*4,
> +				ctx->sa_in, ctx->sa_in_dma_addr);
> +	if (ctx->sa_out != NULL)
> +		dma_free_coherent(NULL, ctx->sa_len*4,
> +				ctx->sa_out, ctx->sa_out_dma_addr);
> +
> +	ctx->sa_in_dma_addr = 0;
> +	ctx->sa_out_dma_addr = 0;
> +	ctx->sa_len = 0;
> +}
> +
> +u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx)
> +{
> +	ctx->state_record = dma_alloc_coherent(NULL,
> +				sizeof(struct dynamic_sa_state_record),
> +				&ctx->state_record_dma_addr, GFP_ATOMIC);
> +	if (!ctx->state_record_dma_addr)
> +		return -ENOMEM;
> +	memset(ctx->state_record, 0, sizeof(struct dynamic_sa_state_record));
> +	return 0;
> +}
> +
> +void crypto4xx_free_state_record(struct crypto4xx_ctx *ctx)
> +{
> +	if (ctx->state_record != NULL)
> +		dma_free_coherent(NULL,
> +				    sizeof(struct dynamic_sa_state_record),
> +				    ctx->state_record,
> +				    ctx->state_record_dma_addr);
> +	ctx->state_record_dma_addr = 0;
> +}
> +
> +/**
> + * alloc memory for the gather ring
> + * no need to alloc buf for the ring
> + * gdr_tail, gdr_head and gdr_count are initialized by this function
> + */
> +u32 crypto4xx_build_pdr(struct crypto4xx_device  *dev)
> +{
> +	dev->pdr = dma_alloc_coherent(NULL,
> +					sizeof(struct ce_pd) * PPC4XX_NUM_PD,
> +					&dev->pdr_pa, GFP_ATOMIC);
> +	if (!dev->pdr)
> +		return -ENOMEM;
> +	dev->pdr_uinfo = kzalloc(sizeof(struct pd_uinfo) * PPC4XX_NUM_PD,
> +					GFP_KERNEL);
> +	if (!dev->pdr_uinfo)
> +		return -ENOMEM;
> +
> +	memset(dev->pdr, 0,  sizeof(struct ce_pd) * PPC4XX_NUM_PD);
> +	return 0;
> +}
> +
> +void crypto4xx_destroy_pdr(struct crypto4xx_device  *dev)
> +{
> +	if (dev->pdr != NULL)
> +		dma_free_coherent(NULL,
> +				sizeof(struct ce_pd) * PPC4XX_NUM_PD,
> +				dev->pdr,
> +				dev->pdr_pa);
> +	if (dev->pdr_uinfo != NULL)
> +		kfree(dev->pdr_uinfo);
> +}
> +
> +u32 crypto4xx_get_pd_from_pdr(struct crypto4xx_device *dev)
> +{
> +	u32 retval;
> +	u32 tmp;
> +
> +	retval = dev->pdr_head;
> +	tmp = (dev->pdr_head + 1) % PPC4XX_NUM_PD;
> +
> +	if (tmp == dev->pdr_tail)
> +		return ERING_WAS_FULL;
> +	dev->pdr_head = tmp;
> +
> +	return retval;
> +}
> +
> +
> +u32 crypto4xx_put_pd_to_pdr(struct crypto4xx_device *dev, u32 idx)
> +{
> +	struct pd_uinfo *pd_uinfo;
> +
> +	pd_uinfo = (struct pd_uinfo *)((dev->pdr_uinfo) +
> +					sizeof(struct pd_uinfo)*idx);
> +
> +	if (dev->pdr_tail != PPC4XX_LAST_PD)
> +		dev->pdr_tail++;
> +	else
> +		dev->pdr_tail = 0;
> +	pd_uinfo->state = PD_ENTRY_FREE;
> +
> +	return 0;
> +}
> +
> +struct ce_pd *crypto4xx_get_pdp(struct crypto4xx_device *dev,
> +				dma_addr_t *pd_dma, u32 idx)
> +{
> +	*pd_dma = dev->pdr_pa + sizeof(struct ce_pd) * idx;
> +	return dev->pdr + sizeof(struct ce_pd)*idx;
> +}
> +
> +/**
> + * alloc memory for the gather ring
> + * no need to alloc buf for the ring
> + * gdr_tail, gdr_head and gdr_count are initialized by this function
> + */
> +u32 crypto4xx_build_gdr(struct crypto4xx_device  *dev)
> +{
> +	dev->gdr = dma_alloc_coherent(NULL,
> +				sizeof(struct ce_gd) * PPC4XX_NUM_GD,
> +				&dev->gdr_pa, GFP_ATOMIC);
> +	if (!dev->gdr)
> +		return -ENOMEM;
> +	memset(dev->gdr, 0,  sizeof(struct ce_gd) * PPC4XX_NUM_GD);
> +	return 0;
> +}
> +
> +void crypto4xx_destroy_gdr(struct crypto4xx_device  *dev)
> +{
> +	dma_free_coherent(NULL,
> +				sizeof(struct ce_gd) * PPC4XX_NUM_GD,
> +				dev->gdr, dev->gdr_pa);
> +}
> +
> +u32 crypto4xx_get_gd_from_gdr(struct crypto4xx_device *dev)
> +{
> +	u32 retval;
> +	u32 tmp;
> +
> +	retval = dev->gdr_head;
> +	tmp = (dev->gdr_head+1) % PPC4XX_NUM_GD;
> +
> +	if (tmp == dev->gdr_tail)
> +		return ERING_WAS_FULL;
> +	dev->gdr_head = tmp;
> +	return retval;
> +}
> +
> +u32 crypto4xx_put_gd_to_gdr(struct crypto4xx_device *dev)
> +{
> +	if (dev->gdr_tail == dev->gdr_head)
> +		return 0;
> +
> +	if (dev->gdr_tail != PPC4XX_LAST_GD)
> +		dev->gdr_tail++;
> +	else
> +		dev->gdr_tail = 0;
> +
> +	return 0;
> +}
> +
> +struct ce_gd *crypto4xx_get_gdp(struct crypto4xx_device *dev,
> +				dma_addr_t *gd_dma, u32 idx)
> +{
> +	*gd_dma = dev->gdr_pa + sizeof(struct ce_gd)*idx;
> +	return (struct ce_gd *) (dev->gdr + sizeof(struct ce_gd) * idx);
> +}
> +
> +/**
> + * alloc memory for the scatter ring
> + * need to alloc buf for the ring
> + * sdr_tail, sdr_head and sdr_count are initialized by this function
> + */
> +u32 crypto4xx_build_sdr(struct crypto4xx_device  *dev)
> +{
> +	int i;
> +	struct ce_sd *sd_array;
> +	/* alloc memory for scatter descriptor ring */
> +	dev->sdr = dma_alloc_coherent(NULL,
> +					sizeof(struct ce_sd) * PPC4XX_NUM_SD,
> +					&dev->sdr_pa, GFP_ATOMIC);
> +	if (!dev->sdr)
> +		return -ENOMEM;
> +
> +	dev->scatter_buffer_size = PPC4XX_SD_BUFFER_SIZE;
> +	dev->scatter_buffer_va =
> +		dma_alloc_coherent(NULL,
> +			     dev->scatter_buffer_size * PPC4XX_NUM_SD,
> +			     &dev->scatter_buffer_pa, GFP_ATOMIC);
> +	if (!dev->scatter_buffer_va)
> +		return -ENOMEM;
> +
> +	sd_array = dev->sdr;
> +
> +	for (i = 0; i < PPC4XX_NUM_SD; i++) {
> +		sd_array[i].ptr = dev->scatter_buffer_pa +
> +		dev->scatter_buffer_size * i;
> +	}
> +	return 0;
> +}
> +
> +void crypto4xx_destroy_sdr(struct crypto4xx_device  *dev)
> +{
> +	dma_free_coherent(NULL,
> +				sizeof(struct ce_sd) * PPC4XX_NUM_SD,
> +				dev->sdr,
> +				dev->sdr_pa);
> +
> +	dma_free_coherent(NULL,
> +				dev->scatter_buffer_size * PPC4XX_NUM_SD,
> +				dev->scatter_buffer_va,
> +				dev->scatter_buffer_pa);
> +}
> +
> +u32 crypto4xx_get_sd_from_sdr(struct crypto4xx_device *dev)
> +{
> +	u32 retval;
> +	u32 tmp;
> +
> +	retval = dev->sdr_head;
> +	tmp  = (dev->sdr_head+1) % PPC4XX_NUM_SD;
> +
> +	if (tmp == dev->sdr_tail)
> +		return ERING_WAS_FULL;
> +
> +	dev->sdr_head = tmp;
> +	return retval;
> +}
> +
> +u32 crypto4xx_put_sd_to_sdr(struct crypto4xx_device *dev)
> +{
> +	if (dev->sdr_tail == dev->sdr_head)
> +		return 0;
> +
> +	if (dev->sdr_tail != PPC4XX_LAST_SD)
> +		dev->sdr_tail++;
> +	else
> +		dev->sdr_tail = 0;
> +
> +	return 0;
> +}
> +
> +struct ce_sd *crypto4xx_get_sdp(struct crypto4xx_device *dev,
> +				dma_addr_t *sd_dma, u32 idx)
> +{
> +	*sd_dma = dev->sdr_pa + sizeof(struct ce_sd) * idx;
> +	return  (struct ce_sd *)(dev->sdr + sizeof(struct ce_sd) * idx);
> +}
> +
> +u32 crypto4xx_fill_one_page(dma_addr_t *addr, u32 *length,
> +			  u32 *idx, u32 *offset, u32 *nbytes)
> +
> +{
> +	struct crypto4xx_device *dev = &(lsec_core.dev);
> +	u32 len;
> +	if ((*length) > dev->scatter_buffer_size) {
> +		memcpy(phys_to_virt(*addr),
> +			dev->scatter_buffer_va +
> +			(*idx)*dev->scatter_buffer_size + (*offset),
> +			dev->scatter_buffer_size);
> +		*offset = 0;
> +		*length -= dev->scatter_buffer_size;
> +		*nbytes -= dev->scatter_buffer_size;
> +		if (*idx == PPC4XX_LAST_SD)
> +			*idx = 0;
> +		else
> +			(*idx)++;
> +		*addr = *addr +  dev->scatter_buffer_size;
> +		return 1;
> +	} else if ((*length) < dev->scatter_buffer_size) {
> +		memcpy(phys_to_virt(*addr),
> +		dev->scatter_buffer_va +
> +		(*idx)*dev->scatter_buffer_size + (*offset),
> +		*length);
> +		if ((*offset + *length) == dev->scatter_buffer_size) {
> +			if (*idx == PPC4XX_LAST_SD)
> +				*idx = 0;
> +			else
> +				(*idx)++;
> +			*nbytes -= *length;
> +			*offset = 0;
> +		} else {
> +			*nbytes -= *length;
> +			*offset += *length;
> +		}
> +
> +		return 0;
> +	} else {
> +		len = (*nbytes <=
> +		dev->scatter_buffer_size) ?
> +		(*nbytes) : dev->scatter_buffer_size;
> +		memcpy(phys_to_virt(*addr),
> +			dev->scatter_buffer_va +
> +			(*idx)*dev->scatter_buffer_size + (*offset),
> +			len);
> +	*offset = 0;
> +	*nbytes -= len;
> +
> +	if (*idx == PPC4XX_LAST_SD)
> +		*idx = 0;
> +	else
> +		(*idx)++;
> +
> +	return 0;
> +    }
> +}
> +
> +void crypto4xx_copy_pkt_to_dst(struct ce_pd *pd,
> +			       struct pd_uinfo *pd_uinfo,
> +			       u32 nbytes,
> +			       struct scatterlist *dst,
> +			       u8 type)
> +{
> +	struct crypto4xx_device *dev = &(lsec_core.dev);
> +	dma_addr_t addr;
> +	u32 this_sd;
> +	u32 offset;
> +	u32 len;
> +	u32 i;
> +	u32 sg_len;
> +	struct scatterlist *sg;
> +	this_sd = pd_uinfo->first_sd;
> +	offset = 0;
> +	i = 0;
> +
> +	while (nbytes) {
> +		sg = &dst[i];
> +		sg_len = sg->length;
> +		addr = dma_map_page(NULL, sg_page(sg), sg->offset,
> +					sg->length, DMA_TO_DEVICE);
> +
> +		if (offset == 0) {
> +			len = (nbytes <= sg->length) ? nbytes : sg->length;
> +			while (crypto4xx_fill_one_page(&addr, &len,
> +				&this_sd, &offset, &nbytes))
> +				;
> +		if (!nbytes)
> +			return ;
> +	    i++;
> +
> +	} else {
> +		len = (nbytes <= (dev->scatter_buffer_size - offset)) ?
> +			nbytes : (dev->scatter_buffer_size - offset);
> +		len = (sg->length < len) ? sg->length : len;
> +		while (crypto4xx_fill_one_page(&addr,
> +				&len, &this_sd, &offset, &nbytes))
> +			;
> +		if (!nbytes)
> +			return;
> +		sg_len -= len;
> +		if (sg_len) {
> +			addr += len;
> +			while (crypto4xx_fill_one_page(&addr, &sg_len,
> +				&this_sd, &offset, &nbytes))
> +				;
> +		}
> +		i++;
> +	}
> +    }
> +}
> +
> +u32 crypto4xx_copy_digest_to_dst(struct pd_uinfo *pd_uinfo,
> +				 struct crypto4xx_ctx *ctx)
> +{
> +	struct dynamic_sa_ctl *sa = (struct dynamic_sa_ctl *)(ctx->sa_in);
> +	struct dynamic_sa_state_record *state_record =
> +			(struct dynamic_sa_state_record *)(ctx->state_record);
> +
> +	if (sa->sa_command_0.bf.hash_alg == SA_HASH_ALG_SHA1) {
> +		memcpy((void *)pd_uinfo->dest_va, state_record->save_digest,
> +				SA_HASH_ALG_SHA1_DIGEST_SIZE);
> +	}
> +	return 0;
> +}
> +
> +
> +void crypto4xx_ret_sg_desc(struct crypto4xx_device *dev,
> +				struct pd_uinfo *pd_uinfo)
> +{
> +	int i;
> +	struct ce_sd *sd = NULL;
> +
> +	if (pd_uinfo->first_gd != 0xffffffff) {
> +		if (pd_uinfo->first_gd  <= pd_uinfo->last_gd) {
> +			for (i = pd_uinfo->first_gd;
> +				i <= pd_uinfo->last_gd; i++)
> +				crypto4xx_put_gd_to_gdr(dev);
> +
> +		} else {
> +			for (i = pd_uinfo->first_gd;
> +				i < PPC4XX_NUM_GD; i++)
> +				crypto4xx_put_gd_to_gdr(dev);
> +			for (i = 0; i <= pd_uinfo->last_gd; i++)
> +				crypto4xx_put_gd_to_gdr(dev);
> +		}
> +	}
> +
> +	if (pd_uinfo->first_sd != 0xffffffff) {
> +		if (pd_uinfo->first_sd  <= pd_uinfo->last_sd) {
> +			for (i = pd_uinfo->first_sd;
> +				i <= pd_uinfo->last_sd; i++) {
> +				sd = (struct ce_sd *)(dev->sdr +
> +						sizeof(struct ce_sd)*i);
> +				sd->ctl.done = 0;
> +				sd->ctl.rdy = 0;
> +				crypto4xx_put_sd_to_sdr(dev);
> +			}
> +		} else {
> +			for (i = pd_uinfo->first_sd; i < PPC4XX_NUM_SD; i++) {
> +				sd = (struct ce_sd *)(dev->sdr +
> +						sizeof(struct ce_sd)*i);
> +				sd->ctl.done = 0;
> +				sd->ctl.rdy = 0;
> +				crypto4xx_put_sd_to_sdr(dev);
> +			}
> +			for (i = 0; i <= pd_uinfo->last_sd; i++) {
> +				sd = (struct ce_sd *)(dev->sdr +
> +						sizeof(struct ce_sd)*i);
> +				sd->ctl.done = 0;
> +				sd->ctl.rdy = 0;
> +				crypto4xx_put_sd_to_sdr(dev);
> +			}
> +		}
> +	}
> +
> +	pd_uinfo->first_gd = pd_uinfo->last_gd = 0xffffffff;
> +	pd_uinfo->first_sd = pd_uinfo->last_sd = 0xffffffff;
> +}
> +
> +
> +u32 crypto4xx_ablkcipher_done(struct pd_uinfo *pd_uinfo, struct ce_pd *pd)
> +{
> +	struct crypto4xx_ctx *ctx;
> +	struct crypto4xx_ctx *rctx = NULL;
> +	struct ablkcipher_request *ablk_req;
> +	struct scatterlist *dst;
> +	dma_addr_t addr;
> +
> +	ablk_req = ablkcipher_request_cast(pd_uinfo->async_req);
> +	ctx  = crypto_tfm_ctx(ablk_req->base.tfm);
> +
> +	if (ctx->use_rctx == 1)
> +		rctx = ablkcipher_request_ctx(ablk_req);
> +
> +	if (pd_uinfo->using_sd) {
> +		crypto4xx_copy_pkt_to_dst(pd,
> +					  pd_uinfo,
> +					  ablk_req->nbytes,
> +					  ablk_req->dst,
> +					  CRYPTO_ALG_TYPE_ABLKCIPHER);
> +	} else {
> +		dst = pd_uinfo->dest_va;
> +		addr = dma_map_page(NULL, sg_page(dst), dst->offset,
> +				    dst->length, DMA_FROM_DEVICE);
> +	}
> +	crypto4xx_ret_sg_desc(&(lsec_core.dev), pd_uinfo);
> +	if (rctx != NULL)
> +		crypto4xx_free_sa_rctx(rctx);
> +	if (ablk_req->base.complete != NULL)
> +		ablk_req->base.complete(&ablk_req->base, 0);
> +	return 0;
> +}
> +
> +u32 crypto4xx_ahash_done(struct pd_uinfo *pd_uinfo)
> +{
> +	struct crypto4xx_ctx *ctx;
> +	struct crypto4xx_ctx *rctx = NULL;
> +	struct ahash_request *ahash_req;
> +
> +	ahash_req = ahash_request_cast(pd_uinfo->async_req);
> +	ctx  = crypto_tfm_ctx(ahash_req->base.tfm);
> +
> +	crypto4xx_copy_digest_to_dst(pd_uinfo,
> +				crypto_tfm_ctx(ahash_req->base.tfm));
> +	crypto4xx_ret_sg_desc(&(lsec_core.dev), pd_uinfo);
> +
> +	if (ctx->use_rctx == 1) {
> +		rctx = ahash_request_ctx(ahash_req);
> +		if (rctx != NULL) {
> +			if (rctx->sa_in_dma_addr)
> +				dma_free_coherent(NULL,
> +						rctx->sa_len * 4,
> +						rctx->sa_in,
> +						rctx->sa_in_dma_addr);
> +			if (rctx->sa_out_dma_addr)
> +				dma_free_coherent(NULL,
> +						rctx->sa_len * 4,
> +						rctx->sa_out,
> +						rctx->sa_out_dma_addr);
> +		}
> +	}
> +	/* call user provided callback function x */
> +	if (ahash_req->base.complete != NULL)
> +		ahash_req->base.complete(&ahash_req->base, 0);
> +	return 0;
> +}
> +
> +u32 crypto4xx_pd_done(struct crypto4xx_core_device *lsec, u32 idx)
> +{
> +	struct ce_pd *pd;
> +	struct pd_uinfo *pd_uinfo;
> +
> +	pd =  lsec->dev.pdr + sizeof(struct ce_pd)*idx;
> +	pd_uinfo = lsec->dev.pdr_uinfo + sizeof(struct pd_uinfo)*idx;
> +	if (crypto_tfm_alg_type(pd_uinfo->async_req->tfm) ==
> +			CRYPTO_ALG_TYPE_ABLKCIPHER)
> +		return crypto4xx_ablkcipher_done(pd_uinfo, pd);
> +	else
> +		return crypto4xx_ahash_done(pd_uinfo);
> +	return 0;
> +}
> +
> +u32 crypto4xx_alloc_sa_rctx(struct crypto4xx_ctx *ctx,
> +				struct crypto4xx_ctx *rctx)
> +{
> +	int    rc;
> +	struct dynamic_sa_ctl *sa = NULL;
> +
> +	if (ctx->direction == CRYPTO_INBOUND) {
> +		sa = (struct dynamic_sa_ctl *)(ctx->sa_in);
> +		rctx->sa_in = dma_alloc_coherent(NULL,
> +				ctx->sa_len*4,
> +				&rctx->sa_in_dma_addr, GFP_ATOMIC);
> +		if (rctx->sa_in == NULL)
> +			return -ENOMEM;
> +		memcpy(rctx->sa_in, ctx->sa_in, ctx->sa_len*4);
> +		rctx->sa_out = NULL;
> +		rctx->sa_out_dma_addr = 0;
> +	} else {
> +		sa = (struct dynamic_sa_ctl *)(ctx->sa_out);
> +		rctx->sa_out = dma_alloc_coherent(NULL,
> +				ctx->sa_len*4,
> +				&rctx->sa_out_dma_addr, GFP_ATOMIC);
> +		if (rctx->sa_out == NULL)
> +			return -ENOMEM;
> +
> +		memcpy(rctx->sa_out, ctx->sa_out, ctx->sa_len*4);
> +		rctx->sa_in = NULL;
> +		rctx->sa_in_dma_addr = 0;
> +	}
> +
> +	if (sa->sa_contents & 0x20000000) {
> +		rc = crypto4xx_alloc_state_record(rctx);
> +		if (rc != 0)
> +			return -ENOMEM;
> +
> +		memcpy(rctx->state_record, ctx->state_record, 16);
> +	} else {
> +		rctx->state_record = NULL;
> +	}
> +
> +	rctx->direction = ctx->direction;
> +	rctx->sa_len = ctx->sa_len;
> +	rctx->bypass = ctx->bypass;
> +
> +	return 0;
> +}
> +
> +void crypto4xx_free_sa_rctx(struct crypto4xx_ctx *rctx)
> +{
> +	if (rctx->sa_in != NULL)
> +		dma_free_coherent(NULL,
> +				rctx->sa_len * 4,
> +				rctx->sa_in,
> +				rctx->sa_in_dma_addr);
> +
> +	if (rctx->sa_out != NULL)
> +		dma_free_coherent(NULL,
> +				rctx->sa_len * 4,
> +				rctx->sa_out,
> +				rctx->sa_out_dma_addr);
> +
> +	crypto4xx_free_state_record(rctx);
> +	rctx->sa_len = 0;
> +	rctx->state_record = NULL;
> +	rctx->state_record_dma_addr = 0;
> +}
> +
> +void crypto4xx_memcpy_le(unsigned int *dst,
> +			 const unsigned char *buf,
> +			 int len)
> +{
> +	/* SA is in big endian */
> +	for (; len; buf += 4, len -= 4)
> +		*dst++ = cpu_to_le32(*(unsigned int *) buf);
> +}
> +
> +u32 crypto4xx_stop_all(void)
> +{
> +	crypto4xx_destroy_pdr(&lsec_core.dev);
> +	crypto4xx_destroy_sdr(&lsec_core.dev);
> +	crypto4xx_destroy_gdr(&lsec_core.dev);
> +
> +	return 0;
> +}
> +
> +u32 crypto4xx_build_pd(struct crypto4xx_device  *dev,
> +		       struct crypto_async_request *req,
> +		       u32 pd_entry,
> +		       struct crypto4xx_ctx *ctx,
> +		       struct scatterlist *src,
> +		       struct scatterlist *dst,
> +		       u16 datalen,
> +		       u8 type)
> +{
> +	dma_addr_t addr, pd_dma, sd_dma, gd_dma;
> +	struct dynamic_sa_ctl *sa;
> +	struct scatterlist *sg;
> +	struct ce_pd *pd;
> +	struct pd_uinfo *pd_uinfo;
> +	unsigned int nbytes = datalen, idx;
> +	struct ce_gd *gd = NULL;
> +	u32 gd_idx = 0;
> +	struct ce_sd *sd = NULL;
> +	u32 sd_idx = 0;
> +
> +	pd = crypto4xx_get_pdp(dev, &pd_dma, pd_entry);
> +	pd_uinfo = (struct pd_uinfo *)((dev->pdr_uinfo) +
> +			sizeof(struct pd_uinfo)*pd_entry);
> +	pd_uinfo->async_req = req;
> +
> +	if (ctx->direction == CRYPTO_INBOUND) {
> +		pd->sa = ctx->sa_in_dma_addr;
> +		sa = (struct dynamic_sa_ctl *)ctx->sa_in;
> +	} else {
> +		pd->sa = ctx->sa_out_dma_addr;
> +		sa = (struct dynamic_sa_ctl *)ctx->sa_out;
> +	}
> +
> +	pd->sa_len = ctx->sa_len;
> +
> +	/* If first is last then we are single */
> +	if (sg_is_last(src)) {
> +		pd->src = dma_map_page(NULL, sg_page(src),
> +				    src->offset, src->length,
> +				    DMA_TO_DEVICE);
> +		/* Disable gather in sa command */
> +		sa->sa_command_0.bf.gather = 0;
> +		/* Indicate gather array is not used */
> +		pd_uinfo->first_gd = pd_uinfo->last_gd = 0xffffffff;
> +	} else {
> +		src = &src[0];
> +		/* get first gd we are going to use */
> +		gd_idx = crypto4xx_get_gd_from_gdr(dev);
> +		if (gd_idx == ERING_WAS_FULL) {
> +			crypto4xx_ret_sg_desc(dev, pd_uinfo);
> +			return -EAGAIN;
> +		}
> +		pd_uinfo->first_gd = gd_idx;
> +		gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
> +		pd->src = gd_dma;
> +		/* Enable gather */
> +		sa->sa_command_0.bf.gather = 1;
> +		idx = 0;
> +
> +		/* walk the sg, and setup gather array */
> +		/* Seems that CRYPTO_ENGINE DMA is byte align,
> +		so we can use ptr directly from sg */
> +		while (nbytes != 0) {
> +			sg = &src[idx];
> +			addr = dma_map_page(NULL, sg_page(sg),
> +					    sg->offset, sg->length,
> +					    DMA_TO_DEVICE);
> +			gd->ptr = addr;
> +			gd->ctl_len.len = sg->length;
> +			gd->ctl_len.done = 0;
> +			gd->ctl_len.ready = 1;
> +			nbytes -= sg->length;
> +			if (!nbytes)
> +				break;
> +			/* Get first gd we are going to use */
> +			gd_idx = crypto4xx_get_gd_from_gdr(dev);
> +			if (gd_idx == ERING_WAS_FULL) {
> +				crypto4xx_ret_sg_desc(dev, pd_uinfo);
> +				return -EAGAIN;
> +			}
> +			gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
> +			pd_uinfo->last_gd = gd_idx;
> +			idx++;
> +		}
> +	}
> +
> +
> +	if (ctx->is_hash  || sg_is_last(dst)) {
> +		/* we know application give us dst a whole piece of memory */
> +		/* no need to use scatter ring */
> +		pd_uinfo->using_sd = 0;
> +		pd_uinfo->first_sd = pd_uinfo->last_sd = 0xffffffff;
> +		pd_uinfo->dest_va = dst;
> +		sa->sa_command_0.bf.scatter = 0;
> +		if (ctx->is_hash) {
> +			pd->dest = virt_to_phys((void *)dst);
> +		} else {
> +			pd->dest = dma_map_page(NULL, sg_page(dst),
> +				    dst->offset, dst->length,
> +				    DMA_TO_DEVICE);
> +		}
> +
> +	} else {
> +		nbytes = datalen;
> +		sa->sa_command_0.bf.scatter = 1;
> +		pd_uinfo->using_sd = 1;
> +
> +		sd_idx = crypto4xx_get_sd_from_sdr(dev);
> +		if (sd_idx == ERING_WAS_FULL) {
> +			crypto4xx_ret_sg_desc(dev, pd_uinfo);
> +			return -EAGAIN;
> +		}
> +		pd_uinfo->first_sd = pd_uinfo->last_sd = sd_idx;
> +		sd = crypto4xx_get_sdp(dev, &sd_dma, sd_idx);
> +		pd->dest = sd_dma;
> +		wmb();
> +		/* setup scatter descriptor */
> +		sd->ctl.done = 0;
> +		sd->ctl.rdy = 1;
> +		/* sd->ptr should be setup by sd_init routine*/
> +		if (nbytes >= PPC4XX_SD_BUFFER_SIZE)
> +			nbytes -= PPC4XX_SD_BUFFER_SIZE;
> +		else if (nbytes < PPC4XX_SD_BUFFER_SIZE)
> +			nbytes = 0;
> +		while (nbytes) {
> +			sd_idx = crypto4xx_get_sd_from_sdr(dev);
> +			if (sd_idx == ERING_WAS_FULL) {
> +				crypto4xx_ret_sg_desc(dev, pd_uinfo);
> +				/*Fixme implement some error code later */
> +				return -EAGAIN;
> +			}
> +			sd = crypto4xx_get_sdp(dev, &sd_dma, sd_idx);
> +			pd_uinfo->last_sd = sd_idx;
> +			/* setup scatter descriptor */
> +			sd->ctl.done = 0;
> +			sd->ctl.rdy = 1;
> +			if (nbytes >= PPC4XX_SD_BUFFER_SIZE)
> +				nbytes -= PPC4XX_SD_BUFFER_SIZE;
> +			else
> +				nbytes = 0;
> +		}
> +	}
> +	pd->pd_ctl.w = ctx->pd_ctl;
> +	pd->pd_ctl_len.w = 0x00400000 | (ctx->bypass<<24) | datalen;
> +	pd_uinfo->state = PD_ENTRY_INUSE;
> +	crypto4xx_write32(CRYPTO_ENGINE_INT_DESCR_RD, 1);
> +
> +	return -EINPROGRESS;
> +
> +}
> +
> +u32 crypto4xx_start_device(struct crypto4xx_device *dev)
> +{
> +	u32 rc ;
> +	rc = crypto4xx_init(dev);
> +	return rc;
> +}
> +
> +int crypto4xx_handle_req(struct crypto_async_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->tfm);
> +	struct crypto4xx_device *dev = ctx->dev;
> +	struct crypto4xx_ctx *rctx;
> +	struct pd_uinfo *pd_uinfo;
> +
> +	int ret = -EAGAIN;
> +
> +	u32 pd_entry;
> +
> +	pd_entry = crypto4xx_get_pd_from_pdr(dev);  /* index to the entry */
> +	if (pd_entry == ERING_WAS_FULL)
> +		return -EAGAIN;
> +
> +	pd_uinfo = (struct pd_uinfo *)((dev->pdr_uinfo) +
> +				       sizeof(struct pd_uinfo)*pd_entry);
> +
> +	if (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_ABLKCIPHER) {
> +		struct ablkcipher_request *ablk_req;
> +		ablk_req = ablkcipher_request_cast(req);
> +		if (ctx->use_rctx) {
> +			rctx = ablkcipher_request_ctx(ablk_req);
> +			return crypto4xx_build_pd(dev, req, pd_entry, rctx,
> +						  ablk_req->src, ablk_req->dst,
> +						  ablk_req->nbytes, ABLK);
> +		} else {
> +			return crypto4xx_build_pd(dev, req, pd_entry, ctx,
> +						  ablk_req->src, ablk_req->dst,
> +						  ablk_req->nbytes,
> +						  ABLK);
> +		}
> +	} else {
> +		struct ahash_request *ahash_req;
> +		ahash_req = ahash_request_cast(req);
> +		if (ctx->use_rctx) {
> +			rctx = ahash_request_ctx(ahash_req);
> +			return crypto4xx_build_pd(dev, req, pd_entry, rctx,
> +				ahash_req->src,
> +				(struct scatterlist *) ahash_req->result,
> +				ahash_req->nbytes,
> +				AHASH);
> +		} else {
> +			return crypto4xx_build_pd(dev, req, pd_entry, ctx,
> +				ahash_req->src,
> +				(struct scatterlist *) ahash_req->result,
> +				ahash_req->nbytes,
> +				AHASH);
> +		}
> +	}
> +	return ret;
> +}
> +
> +int crypto4xx_setup_crypto(struct crypto_async_request *req)
> +{
> +	return crypto4xx_handle_req(req);
> +}
> +
> +/**
> + * Algorithm Registration Functions
> + *
> + */
> +static int crypto4xx_alg_init(struct crypto_tfm *tfm)
> +{
> +	struct crypto_alg    *alg = tfm->__crt_alg;
> +	struct crypto4xx_alg *amcc_alg = crypto_alg_to_crypto4xx_alg(alg);
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	ctx->dev = amcc_alg->dev;
> +	ctx->sa_in = NULL;
> +	ctx->sa_out = NULL;
> +	ctx->sa_in_dma_addr = 0;
> +	ctx->sa_out_dma_addr = 0;
> +	ctx->sa_len = 0;
> +
> +	if (alg->cra_type == &crypto_ablkcipher_type)
> +		tfm->crt_ablkcipher.reqsize = sizeof(struct crypto4xx_ctx);
> +	else if (alg->cra_type == &crypto_ahash_type)
> +		tfm->crt_ahash.reqsize = sizeof(struct crypto4xx_ctx);
> +	return 0;
> +}
> +
> +void crypto4xx_alg_exit(struct crypto_tfm *tfm)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
> +	crypto4xx_free_sa(ctx);
> +	crypto4xx_free_state_record(ctx);
> +}
> +
> +int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
> +			   struct crypto_alg *crypto_alg, int array_size)
> +{
> +	struct crypto4xx_alg *alg;
> +	int i;
> +	int rc = 0;
> +
> +	for (i = 0; i < array_size; i++) {
> +		alg = kzalloc(sizeof(struct crypto4xx_alg), GFP_KERNEL);
> +		if (!alg)
> +			return -ENOMEM;
> +
> +		alg->alg = crypto_alg[i];
> +		INIT_LIST_HEAD(&alg->alg.cra_list);
> +		if (alg->alg.cra_init == NULL)
> +			alg->alg.cra_init = crypto4xx_alg_init;
> +		if (alg->alg.cra_exit == NULL)
> +			alg->alg.cra_exit = crypto4xx_alg_exit;
> +		alg->dev = sec_dev;
> +		list_add_tail(&alg->entry, &sec_dev->alg_list);
> +		rc = crypto_register_alg(&alg->alg);
> +		if (rc) {
> +			list_del(&alg->entry);
> +			kfree(alg);
> +			return rc;
> +		}
> +	}
> +	return rc;
> +}
> +
> +static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
> +{
> +	struct crypto4xx_alg *alg, *tmp;
> +
> +	list_for_each_entry_safe(alg, tmp, &sec_dev->alg_list, entry) {
> +		list_del(&alg->entry);
> +		crypto_unregister_alg(&alg->alg);
> +		kfree(alg);
> +	}
> +}
> +
> +static void crypto4xx_bh_tasklet_cb(unsigned long data)
> +{
> +	struct crypto4xx_core_device *lsec;
> +	struct pd_uinfo *pd_uinfo;
> +	struct ce_pd *pd;
> +	u32 tail;
> +
> +	lsec = (struct crypto4xx_core_device *) data;
> +
> +	while (lsec->dev.pdr_head != lsec->dev.pdr_tail) {
> +		tail = lsec->dev.pdr_tail;
> +		pd_uinfo = lsec->dev.pdr_uinfo + sizeof(struct pd_uinfo)*tail;
> +		pd =  lsec->dev.pdr + sizeof(struct ce_pd)*tail;
> +		if ((pd_uinfo->state == PD_ENTRY_INUSE) &&
> +				   pd->pd_ctl.bf.pe_done &&
> +				   !pd->pd_ctl.bf.host_ready) {
> +			pd->pd_ctl.bf.pe_done = 0;
> +			crypto4xx_pd_done(lsec, tail);
> +			crypto4xx_put_pd_to_pdr(&(lsec->dev), tail);
> +			pd_uinfo->state = PD_ENTRY_FREE;
> +		} else {
> +			/* if tail not done, break */
> +			break;
> +		}
> +	}
> +}
> +
> +/**
> + * Top Half of isr.
> + */
> +static int crypto4xx_ce_interrupt_handler(int irq, void *id)
> +{
> +	if (lsec_core.ce_base == 0)
> +		return 0;
> +
> +	lsec_core.irq_cnt++;
> +	crypto4xx_write32(CRYPTO_ENGINE_INT_CLR, 0x3ffff);
> +	tasklet_schedule(&lsec_core.tasklet);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * Module Initialization Routine
> + *
> + */
> +static int __init crypto4xx_crypto_probe(struct of_device *ofdev,
> +				      const struct of_device_id *match)
> +{
> +	int rc;
> +	struct resource res;
> +
> +	lsec_core.ce_base = 0;
> +	lsec_core.irq_cnt = 0ll;
> +
> +	memset(&lsec_core.dev, 0, sizeof(struct crypto4xx_device));
> +
> +	INIT_LIST_HEAD(&lsec_core.dev.alg_list);
> +
> +	crypto4xx_build_pdr(&(lsec_core.dev));
> +	crypto4xx_build_gdr(&(lsec_core.dev));
> +	crypto4xx_build_sdr(&(lsec_core.dev));
> +
> +	/* Init tasklet for bottom half processing */
> +	tasklet_init(&lsec_core.tasklet, crypto4xx_bh_tasklet_cb,
> +			(unsigned long)&lsec_core);
> +
> +	/* Register for Crypto isr, Crypto Engine IRQ */
> +	lsec_core.irq = of_irq_to_resource(ofdev->node, 0, NULL);
> +	rc = request_irq(lsec_core.irq, crypto4xx_ce_interrupt_handler, 0,
> +			 lsec_core.dev.name, NULL);
> +	if (rc)
> +		goto err_request_irq;
> +
> +	rc = of_address_to_resource(ofdev->node, 0, &res);
> +	if (rc)
> +		return -ENODEV;
> +
> +	lsec_core.ce_phy_address = res.start;
> +	lsec_core.ce_base = ioremap(lsec_core.ce_phy_address,
> +					res.end - res.start + 1);
> +
> +	/* need to setup pdr, rdr, gdr and sdr */
> +	rc = crypto4xx_start_device(&lsec_core.dev);
> +	if (rc)
> +		goto err_start_device;
> +
> +	/* Register security algorithms with Linux CryptoAPI */
> +	rc = crypto4xx_register_basic_alg();
> +	if (rc)
> +		goto err_register_alg;
> +
> +	printk(KERN_INFO "Loaded AMCC PPC4XX crypto "
> +	       "accelerator driver v%s\n", PPC4XX_SEC_VERSION_STR);
> +
> +	return rc;
> +
> +err_register_alg:
> +	crypto4xx_unregister_alg(&lsec_core.dev);
> +err_start_device:
> +	free_irq(lsec_core.irq, &lsec_core.dev.name);
> +err_request_irq:
> +	crypto4xx_stop_all();
> +
> +	return rc;
> +}
> +
> +static int __exit crypto4xx_crypto_remove(struct of_device *dev)
> +{
> +	free_irq(lsec_core.irq, NULL);
> +	/* Un-register with Linux CryptoAPI */
> +	crypto4xx_unregister_alg(&lsec_core.dev);
> +	/* Free all allocated memory */
> +	crypto4xx_stop_all();
> +
> +	printk(KERN_INFO "Unloaded AMCC PPC4XX crypto "
> +	       "accelerator driver v%s\n", PPC4XX_SEC_VERSION_STR);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id crypto4xx_crypto_match[] = {
> +	{ .compatible      = "amcc,ppc4xx-crypto",},
> +	{ },
> +};
> +
> +static struct of_platform_driver crypto4xx_crypto_driver = {
> +	.name		= "crypto4xx-crypto",
> +	.match_table	= crypto4xx_crypto_match,
> +	.probe		= crypto4xx_crypto_probe,
> +	.remove		= crypto4xx_crypto_remove,
> +};
> +
> +static int __init crypto4xx_lsec_init(void)
> +{
> +	return of_register_platform_driver(&crypto4xx_crypto_driver);
> +}
> +
> +static void __exit crypto4xx_lsec_exit(void)
> +{
> +	of_unregister_platform_driver(&crypto4xx_crypto_driver);
> +}
> +
> +module_init(crypto4xx_lsec_init);
> +module_exit(crypto4xx_lsec_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("James Hsiao <jhsiao@amcc.com>");
> +MODULE_DESCRIPTION("Driver for AMCC PPC4xx crypto accelerator");
> +
> diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
> new file mode 100644
> index 0000000..b7a6191
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_core.h
> @@ -0,0 +1,200 @@
> +/*******************************************************************************
> + * AMCC SoC Crypto4XX Driver
> + *
> + * Copyright (c) 2008 Applied Micro Circuits Corporation.
> + * All rights reserved. James Hsiao <jhsiao@amcc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * @file   crypto4xx_core.h
> + *
> + * This is the header file for AMCC Crypto offload Linux device driver for
> + * use with Linux CryptoAPI.
> + *
> + *******************************************************************************
> + */
> +
> +#ifndef __CRYPTO4XX_CORE_H__
> +#define __CRYPTO4XX_CORE_H__
> +
> +#define CRYPTO4XX_CRYPTO_PRIORITY	300
> +
> +#define PPC4XX_LAST_PD			63
> +#define PPC4XX_NUM_PD			64
> +
> +#define PPC4XX_LAST_GD			1023
> +#define PPC4XX_NUM_GD			1024
> +
> +#define PPC4XX_LAST_SD			63
> +#define PPC4XX_NUM_SD			64
> +
> +#define PPC4XX_SD_BUFFER_SIZE		2048
> +
> +#define PPC4XX_INT_DESCR_CNT		4
> +#define PPC4XX_INT_TIMEOUT_CNT		0
> +/* FIXme arbitory number*/
> +#define PPC4XX_INT_CFG			1
> +/*
> + * These define will be used in crypto4xx_build_pd
> + * AHASH don't have dst scatterlist iso u8*
> + * with the type field it can destinguish what is
> + */
> +#define ABLK				0
> +#define AHASH				1
> +
> +#define PD_ENTRY_INUSE			1
> +#define PD_ENTRY_FREE			0
> +
> +#define EALLOC_MEM_FAIL			0xfffffffd
> +#define EDOWNSEMA_FAIL			0xfffffffe
> +#define ERING_WAS_FULL			0xffffffff
> +
> +struct crypto4xx_device;
> +extern struct crypto4xx_core_device lsec_core;
> +extern struct crypto_alg crypto4xx_basic_alg[];
> +
> +struct pd_uinfo {
> +	struct crypto4xx_device *dev;
> +	u32   state;
> +	u32 using_sd;
> +	void *pd_va;                             /* offset from pdr */
> +	void *rd_va;                             /* offset from rdr, could be
> +						 same as pdr(same as pd_va)*/
> +	u32 first_gd;                            /* first gather discriptor
> +							used by this packet */
> +	u32 last_gd;                             /* last gather discriptor
> +							used by this packet */
> +	u32 first_sd;                            /* first scatter discriptor
> +							used by this packet */
> +	u32 last_sd;                             /* last scatter discriptor
> +							used by this packet */
> +	u32 first_done;
> +	u32 last_done;
> +	struct scatterlist *dest_va;
> +	u32 cryptype;
> +	struct crypto_async_request *async_req;  /* base crypto request
> +							for this packet */
> +};
> +
> +struct crypto4xx_device {
> +	u8   dev_id;			/* Device ID - id of device to
> +						send request to */
> +	char *name;
> +	void *pdr;			/* base address of packet
> +						descriptor ring */
> +	dma_addr_t pdr_pa;		/* physical address used to
> +						program ce pdr_base_register */
> +	void *rdr;			/* result descriptor ring, maybe same
> +						location as pdr */
> +	dma_addr_t rdr_pa;             /* physical address used to
> +						program ce rdr_base_register */
> +	void *gdr;                     /* gather descriptor ring,
> +						for inbound packet/fragments */
> +					/* address of particle is
> +						from the request, src sg*/
> +	dma_addr_t gdr_pa;		/* physical address used to
> +						program ce gdr_base_register */
> +	void *sdr;			/* scatter descriptor ring,for outbound
> +						packet/fragments
> +						must be same size, so init them
> +						to 2k each safe for large
> +						packets */
> +	dma_addr_t sdr_pa;		/* physical address used to
> +						program ce sdr_base_register */
> +	dma_addr_t scatter_buffer_pa;
> +	void *scatter_buffer_va;
> +	u32 scatter_buffer_size;
> +	int pdr_tail;
> +	int pdr_head;
> +	u32 gdr_tail;
> +	u32 gdr_head;
> +	u32 sdr_tail;
> +	u32 sdr_head;
> +	void *pdr_uinfo;
> +	struct list_head alg_list;	/* List of algorithm supported
> +							by this device */
> +};
> +
> +struct crypto4xx_core_device {
> +	struct crypto4xx_device dev;
> +	u32 int_status;
> +	u32 irq;
> +	u64 irq_cnt;
> +	struct tasklet_struct tasklet;
> +	u64  ce_phy_address;
> +	void __iomem *ce_base;
> +};
> +
> +struct crypto4xx_ctx {
> +	struct crypto4xx_device *dev;
> +	void *sa_in;
> +	dma_addr_t sa_in_dma_addr;
> +	void *sa_out;
> +	dma_addr_t sa_out_dma_addr;
> +	void *state_record;
> +	dma_addr_t state_record_dma_addr;
> +	u16 sa_len;
> +	u32 direction;
> +	u32 use_rctx;
> +	u32 next_hdr;
> +	u32 save_iv;
> +	u32 pd_ctl_len;
> +	u32 pd_ctl;
> +	u32 bypass;
> +	u32 is_hash;
> +	u32 hash_final;
> +};
> +
> +struct crypto4xx_req_ctx {
> +	struct crypto4xx_device *dev;	/* Device in which
> +					operation to send to */
> +	void  *sa;
> +	dma_addr_t sa_dma_addr;
> +	u16 sa_len;
> +};
> +
> +struct crypto4xx_alg {
> +	struct list_head  entry;
> +	struct crypto_alg alg;
> +	struct crypto4xx_device *dev;
> +};
> +
> +#define crypto_alg_to_crypto4xx_alg(x) \
> +		container_of(x, struct crypto4xx_alg, alg)
> +
> +extern void crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
> +extern u32 crypto4xx_alloc_sa_rctx(struct crypto4xx_ctx *ctx,
> +				   struct crypto4xx_ctx *rctx);
> +extern void crypto4xx_free_ctx(struct crypto4xx_ctx   *ctx);
> +extern u32 crypto4xx_pd_done(struct crypto4xx_core_device *lsec, u32 idx);
> +extern void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
> +extern u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx);
> +extern void crypto4xx_free_state_record(struct crypto4xx_ctx *ctx);
> +
> +extern u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx);
> +extern u32 get_dynamic_sa_offset_iv_field(struct crypto4xx_ctx *ctx);
> +extern u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx);
> +extern void crypto4xx_memcpy_le(unsigned int *dst,
> +				const unsigned char *buf, int len);
> +extern void crypto4xx_free_sa_rctx(struct crypto4xx_ctx *rctx);
> +extern int crypto4xx_handle_req(struct crypto_async_request *req);
> +extern u32 crypto4xx_build_pd(struct crypto4xx_device  *dev,
> +			      struct crypto_async_request *req,
> +			      u32 pd_entry,
> +			      struct crypto4xx_ctx *ctx,
> +			      struct scatterlist *src,
> +			      struct scatterlist *dst,
> +			      u16 datalen,
> +			      u8 type);
> +extern int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
> +			  struct crypto_alg *crypto_alg, int array_size);
> +extern int crypto4xx_register_basic_alg(void);
> +#endif
> diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
> new file mode 100644
> index 0000000..73003b1
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
> @@ -0,0 +1,291 @@
> +/****************************************************************************
> + * AMCC SoC Crypto4XX Driver
> + *
> + * Copyright (c) 2008 Applied Micro Circuits Corporation.
> + * All rights reserved. James Hsiao <jhsiao@amcc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * @file crypto4xx_reg_def.h
> + *
> + * This filr defines the register set for Security Subsystem
> + *
> + ****************************************************************************
> + */
> +
> +#ifndef __CRYPTO_ENGINE_REG_DEF_H__
> +#define __CRYPTO_ENGINE_REG_DEF_H__
> +
> +/* CRYPTO_ENGINE Register offset */
> +#define CRYPTO_ENGINE_DESCRIPTOR			0x00000000
> +#define CRYPTO_ENGINE_CTRL_STAT				0x00000000
> +#define CRYPTO_ENGINE_SOURCE				0x00000004
> +#define CRYPTO_ENGINE_DEST				0x00000008
> +#define CRYPTO_ENGINE_SA				0x0000000C
> +#define CRYPTO_ENGINE_SA_LENGTH				0x00000010
> +#define CRYPTO_ENGINE_LENGTH				0x00000014
> +
> +
> +#define CRYPTO_ENGINE_PE_DMA_CFG			0x00000040
> +#define CRYPTO_ENGINE_PE_DMA_STAT			0x00000044
> +#define CRYPTO_ENGINE_PDR_BASE				0x00000048
> +#define CRYPTO_ENGINE_RDR_BASE				0x0000004c
> +#define CRYPTO_ENGINE_RING_SIZE				0x00000050
> +#define CRYPTO_ENGINE_RING_CTRL				0x00000054
> +#define CRYPTO_ENGINE_INT_RING_STAT			0x00000058
> +#define CRYPTO_ENGINE_EXT_RING_STAT			0x0000005c
> +#define CRYPTO_ENGINE_IO_THRESHOLD			0x00000060
> +#define CRYPTO_ENGINE_GATH_RING_BASE			0x00000064
> +#define CRYPTO_ENGINE_SCAT_RING_BASE			0x00000068
> +#define CRYPTO_ENGINE_PART_RING_SIZE			0x0000006c
> +#define CRYPTO_ENGINE_PART_RING_CFG		        0x00000070
> +
> +#define CRYPTO_ENGINE_PDR_BASE_UADDR			0x00000080
> +#define CRYPTO_ENGINE_RDR_BASE_UADDR			0x00000084
> +#define CRYPTO_ENGINE_PKT_SRC_UADDR			0x00000088
> +#define CRYPTO_ENGINE_PKT_DEST_UADDR			0x0000008c
> +#define CRYPTO_ENGINE_SA_UADDR				0x00000090
> +#define CRYPTO_ENGINE_GATH_RING_BASE_UADDR		0x000000A0
> +#define CRYPTO_ENGINE_SCAT_RING_BASE_UADDR		0x000000A4
> +
> +#define CRYPTO_ENGINE_SEQ_RD				0x00000408
> +#define CRYPTO_ENGINE_SEQ_MASK_RD			0x0000040C
> +
> +#define CRYPTO_ENGINE_SA_CMD_0				0x00010600
> +#define CRYPTO_ENGINE_SA_CMD_1				0x00010604
> +
> +#define CRYPTO_ENGINE_STATE_PTR				0x000106dc
> +#define CRYPTO_ENGINE_STATE_IV				0x00010700
> +#define CRYPTO_ENGINE_STATE_HASH_BYTE_CNT_0		0x00010710
> +#define CRYPTO_ENGINE_STATE_HASH_BYTE_CNT_1		0x00010714
> +
> +#define CRYPTO_ENGINE_STATE_IDIGEST_0			0x00010718
> +#define CRYPTO_ENGINE_STATE_IDIGEST_1			0x0001071c
> +
> +#define CRYPTO_ENGINE_DATA_IN				0x00018000
> +#define CRYPTO_ENGINE_DATA_OUT			        0x0001c000
> +
> +
> +#define CRYPTO_ENGINE_INT_UNMASK_STAT			0x000500a0
> +#define CRYPTO_ENGINE_INT_MASK_STAT			0x000500a4
> +#define CRYPTO_ENGINE_INT_CLR				0x000500a4
> +#define CRYPTO_ENGINE_INT_EN				0x000500a8
> +
> +#define CRYPTO_ENGINE_INT_PKA				0x00000002
> +#define CRYPTO_ENGINE_INT_PDR_DONE			0x00008000
> +#define CRYPTO_ENGINE_INT_MA_WR_ERR			0x00020000
> +#define CRYPTO_ENGINE_INT_MA_RD_ERR			0x00010000
> +#define CRYPTO_ENGINE_INT_PE_ERR			0x00000200
> +#define CRYPTO_ENGINE_INT_USER_DMA_ERR			0x00000040
> +#define CRYPTO_ENGINE_INT_SLAVE_ERR			0x00000010
> +#define CRYPTO_ENGINE_INT_MASTER_ERR			0x00000008
> +#define CRYPTO_ENGINE_INT_ERROR				0x00030258
> +
> +#define CRYPTO_ENGINE_INT_CFG				0x000500ac
> +#define CRYPTO_ENGINE_INT_DESCR_RD			0x000500b0
> +#define CRYPTO_ENGINE_INT_DESCR_CNT			0x000500b4
> +#define CRYPTO_ENGINE_INT_TIMEOUT_CNT			0x000500b8
> +
> +#define CRYPTO_ENGINE_DC_CTRL				0x00060080
> +#define CRYPTO_ENGINE_DEVICE_ID				0x00060084
> +#define CRYPTO_ENGINE_DEVICE_INFO			0x00060088
> +#define CRYPTO_ENGINE_DMA_USER_SRC			0x00060094
> +#define CRYPTO_ENGINE_DMA_USER_DEST			0x00060098
> +#define CRYPTO_ENGINE_DMA_USER_CMD			0x0006009C
> +
> +#define CRYPTO_ENGINE_DMA_CFG	        		0x000600d4
> +#define CRYPTO_ENGINE_BYTE_ORDER_CFG 			0x000600d8
> +#define CRYPTO_ENGINE_ENDIAN_CFG			0x000600d8
> +
> +#define CRYPTO_ENGINE_PRNG_STAT				0x00070000
> +#define CRYPTO_ENGINE_PRNG_CTRL				0x00070004
> +#define CRYPTO_ENGINE_PRNG_SEED_L			0x00070008
> +#define CRYPTO_ENGINE_PRNG_SEED_H			0x0007000c
> +
> +#define CRYPTO_ENGINE_PRNG_RES_0			0x00070020
> +#define CRYPTO_ENGINE_PRNG_RES_1			0x00070024
> +#define CRYPTO_ENGINE_PRNG_RES_2			0x00070028
> +#define CRYPTO_ENGINE_PRNG_RES_3			0x0007002C
> +
> +#define CRYPTO_ENGINE_PRNG_LFSR_L			0x00070030
> +#define CRYPTO_ENGINE_PRNG_LFSR_H			0x00070034
> +
> +/**
> + * Initilize CRYPTO ENGINE registers, and memory bases.
> + */
> +
> +#define PPC4XX_PDR_POLL			0x3ff
> +#define PPC4XX_OUTPUT_THRESHOLD		2
> +#define PPC4XX_INPUT_THRESHOLD		2
> +#define PPC4XX_PD_SIZE			6
> +#define CRYPTO_CTX_DONE_INT		0x2000
> +#define CRYPTO_PD_DONE_INT		0x8000
> +/**
> + * all follow define are ad hoc
> + */
> +#define PPC4XX_RING_RETRY		100
> +#define PPC4XX_RING_POLL		100
> +#define PPC4XX_SDR_SIZE			PPC4XX_NUM_SD
> +#define PPC4XX_GDR_SIZE			PPC4XX_NUM_GD
> +
> +/**
> + *
> + * IPE Generic Security Association (SA) with all possible fields. These will
> + * never likely used except for reference purpose. These structure format
> + * can be not changed as the hardware expects them to be layout as defined.
> + * Field can be removed or reduced but ordering can not be changed.
> + *
> + *
> + */
> +
> +#define CRYPTO_ENGINE_DMA_CFG_OFFSET			0x40
> +union ce_pe_dma_cfg {
> +	struct {
> +		u32 rsv:7;
> +		u32 dir_host:1;
> +		u32 rsv1:2;
> +		u32 bo_td_en:1;
> +		u32 dis_pdr_upd:1;
> +		u32 bo_sgpd_en:1;
> +		u32 bo_data_en:1;
> +		u32 bo_sa_en:1;
> +		u32 bo_pd_en:1;
> +		u32 rsv2:4;
> +		u32 dynamic_sa_en:1;
> +		u32 pdr_mode:2;
> +		u32 pe_mode:1;
> +		u32 rsv3:5;
> +		u32 reset_sg:1;
> +		u32 reset_pdr:1;
> +		u32 reset_pe:1;
> +	} bf;
> +    u32 w;
> +} __attribute__((packed));
> +
> +#define CRYPTO_ENGINE_PDR_BASE_OFFSET			0x48
> +#define CRYPTO_ENGINE_RDR_BASE_OFFSET			0x4c
> +
> +#define CRYPTO_ENGINE_RING_SIZE_OFFSET			0x50
> +union ce_ring_size {
> +	struct {
> +		u32 ring_offset:16;
> +		u32 rsv:6;
> +		u32 ring_size:10;
> +	} bf;
> +    u32 w;
> +} __attribute__((packed));
> +
> +#define CRYPTO_ENGINE_RING_CONTROL_OFFSET		0x54
> +union ce_ring_contol {
> +	struct {
> +		u32 continuous:1;
> +		u32 rsv:5;
> +		u32 ring_retry_divisor:10;
> +		u32 rsv1:4;
> +		u32 ring_poll_divisor:10;
> +	} bf;
> +    u32 w;
> +} __attribute__((packed));
> +
> +#define CRYPTO_ENGINE_IO_THRESHOLD_OFFSET		0x60
> +union ce_io_threshold {
> +	struct {
> +		u32 rsv:6;
> +		u32 output_threshold:10;
> +		u32 rsv1:6;
> +		u32 input_threshold:10;
> +	} bf;
> +    u32 w;
> +} __attribute__((packed));
> +
> +#define CRYPTO_ENGINE_GATHER_RING_BASE_OFFSET		0x64
> +#define CRYPTO_ENGINE_SCATTER_RING_BASE_OFFSET		0x68
> +
> +union ce_part_ring_size  {
> +	struct {
> +		u32 sdr_size:16;
> +		u32 gdr_size:16;
> +	} bf;
> +    u32 w;
> +} __attribute__((packed));
> +
> +#define MAX_BURST_SIZE_32	0
> +#define MAX_BURST_SIZE_64	1
> +#define MAX_BURST_SIZE_128	2
> +#define MAX_BURST_SIZE_256	3
> +
> +/* gather descriptor control length */
> +struct gd_ctl_len {
> +	u32 len:16;
> +	u32 rsv:14;
> +	u32 done:1;
> +	u32 ready:1;
> +} __attribute__((packed));
> +
> +struct ce_gd {
> +	u32 ptr;
> +	struct gd_ctl_len ctl_len;
> +} __attribute__((packed));
> +
> +struct sd_ctl {
> +	u32 ctl:30;
> +	u32 done:1;
> +	u32 rdy:1;
> +} __attribute__((packed));
> +
> +struct ce_sd {
> +    u32 ptr;
> +	struct sd_ctl ctl;
> +} __attribute__((packed));
> +
> +#define PD_PAD_CTL_32	0x10
> +#define PD_PAD_CTL_64	0x20
> +#define PD_PAD_CTL_128	0x40
> +#define PD_PAD_CTL_256	0x80
> +union ce_pd_ctl {
> +	struct {
> +		u32 pd_pad_ctl:8;
> +		u32 status:8;
> +		u32 next_hdr:8;
> +		u32 rsv:2;
> +		u32 cached_sa:1;
> +		u32 hash_final:1;
> +		u32 init_arc4:1;
> +		u32 rsv1:1;
> +		u32 pe_done:1;
> +		u32 host_ready:1;
> +	} bf;
> +	u32 w;
> +} __attribute__((packed));
> +
> +union ce_pd_ctl_len {
> +	struct {
> +		u32 bypass:8;
> +		u32 pe_done:1;
> +		u32 host_ready:1;
> +		u32 rsv:2;
> +		u32 pkt_len:20;
> +	} bf;
> +	u32 w;
> +} __attribute__((packed));
> +
> +struct ce_pd {
> +	union ce_pd_ctl   pd_ctl;
> +	dma_addr_t src;
> +	dma_addr_t dest;
> +	dma_addr_t sa;                 /* get from ctx->sa_dma_addr */
> +	u32 sa_len;                    /* only if dynamic sa is used */
> +	union ce_pd_ctl_len pd_ctl_len;
> +
> +} __attribute__((packed));
> +
> +
> +#endif
> diff --git a/drivers/crypto/amcc/crypto4xx_sa.c b/drivers/crypto/amcc/crypto4xx_sa.c
> new file mode 100644
> index 0000000..a7adfcf
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_sa.c
> @@ -0,0 +1,98 @@
> +/****************************************************************************
> + * AMCC SoC Crypto4XX Driver
> + *
> + * Copyright (c) 2008 Applied Micro Circuits Corporation.
> + * All rights reserved. James Hsiao <jhsiao@amcc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * @file crypto4xx_sa.c
> + *
> + * This file implements the security context
> + * assoicate format.
> + *
> + ****************************************************************************
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock_types.h>
> +#include <linux/highmem.h>
> +#include <linux/scatterlist.h>
> +#include <linux/crypto.h>
> +#include <crypto/algapi.h>
> +#include <crypto/des.h>
> +#include "crypto4xx_reg_def.h"
> +#include "crypto4xx_sa.h"
> +#include "crypto4xx_core.h"
> +
> +u32 get_dynamic_sa_offset_iv_field(struct crypto4xx_ctx *ctx)
> +{
> +	u32 offset;
> +	union dynamic_sa_contents cts;
> +
> +	if (ctx->direction == CRYPTO_INBOUND)
> +		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
> +	else
> +		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
> +	offset = cts.bf.key_size
> +		+ cts.bf.inner_size
> +		+ cts.bf.outer_size
> +		+ cts.bf.spi
> +		+ cts.bf.seq_num0
> +		+ cts.bf.seq_num1
> +		+ cts.bf.seq_num_mask0
> +		+ cts.bf.seq_num_mask1
> +		+ cts.bf.seq_num_mask2
> +		+ cts.bf.seq_num_mask3;
> +
> +	return sizeof(struct dynamic_sa_ctl) + offset * 4;
> +}
> +
> +u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx)
> +{
> +	u32 offset;
> +	union dynamic_sa_contents cts;
> +
> +	if (ctx->direction == CRYPTO_INBOUND)
> +		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
> +	else
> +		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
> +	offset = cts.bf.key_size
> +		+ cts.bf.inner_size
> +		+ cts.bf.outer_size
> +		+ cts.bf.spi
> +		+ cts.bf.seq_num0
> +		+ cts.bf.seq_num1
> +		+ cts.bf.seq_num_mask0
> +		+ cts.bf.seq_num_mask1
> +		+ cts.bf.seq_num_mask2
> +		+ cts.bf.seq_num_mask3
> +		+ cts.bf.iv0
> +		+ cts.bf.iv1
> +		+ cts.bf.iv2
> +		+ cts.bf.iv3;
> +
> +	return sizeof(struct dynamic_sa_ctl) + offset * 4;
> +}
> +
> +u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx)
> +{
> +	union dynamic_sa_contents cts;
> +
> +	if (ctx->direction == CRYPTO_INBOUND)
> +		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
> +	else
> +		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
> +	return (cts.bf.iv0 + cts.bf.iv1 + cts.bf.iv2 + cts.bf.iv3) * 4;
> +}
> diff --git a/drivers/crypto/amcc/crypto4xx_sa.h b/drivers/crypto/amcc/crypto4xx_sa.h
> new file mode 100644
> index 0000000..f60a9d8
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_sa.h
> @@ -0,0 +1,223 @@
> +/****************************************************************************
> + * AMCC SoC Crypto4XX Driver
> + *
> + * Copyright (c) 2008 Applied Micro Circuits Corporation.
> + * All rights reserved. James Hsiao <jhsiao@amcc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * @file crypto4xx_sa.h
> + *
> + * This file defines the security context
> + * assoicate format.
> + *
> + ****************************************************************************
> + */
> +
> +#ifndef __CRYPTO4XX_SA_H__
> +#define __CRYPTO4XX_SA_H__
> +
> +#define u32 unsigned int
> +
> +/**
> + *
> + * Contents of Dynamic Security Association (SA) with all possible fields
> + */
> +union dynamic_sa_contents {
> +	struct {
> +		u32 arc4_state_ptr:1;
> +		u32 arc4_ij_ptr:1;
> +		u32 state_ptr:1;
> +		u32 iv3:1;
> +		u32 iv2:1;
> +		u32 iv1:1;
> +		u32 iv0:1;
> +		u32 seq_num_mask3:1;
> +		u32 seq_num_mask2:1;
> +		u32 seq_num_mask1:1;
> +		u32 seq_num_mask0:1;
> +		u32 seq_num1:1;
> +		u32 seq_num0:1;
> +		u32 spi:1;
> +		u32 outer_size:5;
> +		u32 inner_size:5;
> +		u32 key_size:4;
> +		u32 cmd_size:4;
> +	} bf;
> +	u32 w;
> +} __attribute__((packed));
> +
> +#define CRYPTO_OUTBOUND                 0
> +#define CRYPTO_INBOUND                  1
> +
> +#define SA_OPCODE_ENCRYPT               0
> +#define SA_OPCODE_DECRYPT               0
> +
> +#define SA_OPCODE_HASH                  3
> +
> +#define SA_CIPHER_ALG_DES               0
> +#define SA_CIPHER_ALG_3DES              1
> +#define SA_CIPHER_ALG_ARC4              2
> +#define SA_CIPHER_ALG_AES               3
> +#define SA_CIPHER_ALG_KASUMI            4
> +#define SA_CIPHER_ALG_NULL             15
> +
> +#define SA_HASH_ALG_MD5                 0
> +#define SA_HASH_ALG_SHA1                1
> +#define SA_HASH_ALG_NULL               15
> +
> +#define SA_HASH_ALG_SHA1_DIGEST_SIZE   20
> +
> +#define SA_LOAD_HASH_FROM_SA            0
> +#define SA_LOAD_HASH_FROM_STATE         2
> +#define SA_LOAD_HASH_NO_LOAD            3
> +
> +union sa_command_0 {
> +	struct {
> +		u32 scatter:1;
> +		u32 gather:1;
> +		u32 save_hash_state:1;
> +		u32 save_iv:1;
> +		u32 load_hash_state:2;
> +		u32 load_iv:2;
> +		u32 digest_len:4;
> +		u32 hdr_proc:1;
> +		u32 extend_pad:1;
> +		u32 stream_cipher_pad:1;
> +		u32 rsv:1;
> +		u32 hash_alg:4;
> +		u32 cipher_alg:4;
> +		u32 pad_type:2;
> +		u32 op_group:2;
> +		u32 dir:1;
> +		u32 opcode:3;
> +	} bf;
> +	u32 w;
> +} __attribute__((packed));
> +
> +#define CRYPTO_MODE_ECB                  0
> +#define CRYPTO_MODE_CBC                  1
> +
> +#define CRYPTO_FEEDBACK_MODE_NO_FB       0
> +#define CRYPTO_FEEDBACK_MODE_64BIT_OFB   0
> +#define CRYPTO_FEEDBACK_MODE_8BIT_CFB    1
> +#define CRYPTO_FEEDBACK_MODE_1BIT_CFB    2
> +#define CRYPTO_FEEDBACK_MODE_128BIT_CFB  3
> +
> +#define SA_AES_KEY_LEN_128               2
> +#define SA_AES_KEY_LEN_192               3
> +#define SA_AES_KEY_LEN_256               4
> +
> +/**
> + * The follow 4 defines usage of hmac_muting bit in sa_command_1
> + * In Basic hash mode  this bit define simple hash or hmac.
> + * In IPsec mode, this bit define muting control.
> + */
> +#define SA_HASH_MODE_HASH                0
> +#define SA_HASH_MODE_HMAC                1
> +
> +union sa_command_1 {
> +	struct {
> +		u32 crypto_mode31:1;
> +		u32 save_arc4_state:1;
> +		u32 arc4_stateful:1;
> +		u32 key_len:5;
> +		u32 hash_crypto_offset:8;
> +		u32 sa_rev:2;
> +		u32 byte_offset:1;
> +		u32 hmac_muting:1;
> +		u32 feedback_mode:2;
> +		u32 crypto_mode9_8:2;
> +		u32 extended_seq_num:1;
> +		u32 seq_num_mask:1;
> +		u32 mutable_bit_proc:1;
> +		u32 ip_version:1;
> +		u32 copy_pad:1;
> +		u32 copy_payload:1;
> +		u32 copy_hdr:1;
> +		u32 rsv1:1;
> +	} bf;
> +	u32 w;
> +} __attribute__((packed));
> +
> +struct dynamic_sa_ctl {
> +	u32 sa_contents;
> +	union sa_command_0 sa_command_0;
> +	union sa_command_1 sa_command_1;
> +
> +} __attribute__((packed));
> +
> +/**
> + * State Record for Security Association (SA)
> + */
> +struct  dynamic_sa_state_record {
> +	u32 save_iv[4];
> +	u32 save_hash_byte_cnt[2];
> +	u32 save_digest[16];
> +} __attribute__((packed));
> +
> +/**
> + * Security Association (SA) for AES128
> + *
> + */
> +struct dynamic_sa_aes128 {
> +	struct dynamic_sa_ctl	ctrl;
> +	u32 key[4];
> +	u32 iv[4]; /* for CBC, OFC, and CFB mode */
> +	u32 state_ptr;
> +	u32 reserved;
> +} __attribute__((packed));
> +
> +#define SA_AES128_LEN		(sizeof(struct dynamic_sa_aes128)/4)
> +#define SA_AES128_CONTENTS      0x3e000042
> +
> +/*
> + * Security Association (SA) for AES192
> + */
> +struct dynamic_sa_aes192 {
> +	struct dynamic_sa_ctl ctrl;
> +	u32 key[6];
> +	u32 iv[4]; /* for CBC, OFC, and CFB mode */
> +	u32 state_ptr;
> +	u32 reserved;
> +} __attribute__((packed));
> +
> +#define SA_AES192_LEN		(sizeof(struct dynamic_sa_aes192)/4)
> +#define SA_AES192_CONTENTS	0x3e000062
> +
> +/**
> + * Security Association (SA) for AES256
> + */
> +struct dynamic_sa_aes256 {
> +	struct dynamic_sa_ctl ctrl;
> +	u32 key[8];
> +	u32 iv[4]; /* for CBC, OFC, and CFB mode */
> +	u32 state_ptr;
> +	u32 reserved;
> +} __attribute__((packed));
> +
> +#define SA_AES256_LEN		(sizeof(struct dynamic_sa_aes256)/4)
> +#define SA_AES256_CONTENTS	0x3e000082
> +
> +/**
> + * Security Association (SA) for HASH160: HMAC-SHA1
> + */
> +struct dynamic_sa_hash160 {
> +	struct dynamic_sa_ctl ctrl;
> +	u32 inner_digest[5];
> +	u32 outer_digest[5];
> +	u32 state_ptr;
> +	u32 reserved;
> +} __attribute__((packed));
> +#define SA_HASH160_LEN		(sizeof(struct dynamic_sa_hash160)/4)
> +#define SA_HASH160_CONTENTS     0x2000a502
> +
> +#endif

