From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v3]
Date: Wed, 12 Nov 2008 18:33:59 -0600
Message-ID: <20081112183359.2ba1e894.kim.phillips@freescale.com>
References: <1226097047.5078.23.camel@jhsiao-usb>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	jwboyer@linux.vnet.ibm.com
To: jhsiao@amcc.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:35354 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYKMAcd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 19:32:33 -0500
In-Reply-To: <1226097047.5078.23.camel@jhsiao-usb>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 07 Nov 2008 14:30:47 -0800
James Hsiao <jhsiao@amcc.com> wrote:

> diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
> index dececc4..43d4f91 100644
> --- a/arch/powerpc/boot/dts/kilauea.dts
> +++ b/arch/powerpc/boot/dts/kilauea.dts
> @@ -94,6 +94,13 @@
>  			dcr-reg = <0x010 0x002>;
>  		};
>  
> +		CRYPTO: crypto@ef700000 {
> +			compatible = "amcc,crypto-405ex", "amcc,ppc4xx-crypto";

one prepends "crypto-" and the other postpends "-crypto"?  nomenclature
usually is "company,CHIP-device".  How about:

compatible = "amcc,ppc405ex-crypto", "amcc,ppc4xx-crypto";

btw, the 405ex fixup can be done in the bootloader.

> + * Changes:
> + *	James Hsiao:	10/04/08
> + *			crypto4xx_encrypt, crypto4xx_decrypt,
> + *			crypto4xx_setkey_aes_cbc not inline.
> + *			return from crypto4xx_alloc_sa now check return code
> + *			instead of of check sa_in_dma_addr and sa_out_dma_addr

git keeps the change log.

> +#include <crypto/internal/hash.h>

does something in crypto/internal/hash.h need to be moved to
crypto/hash.h?

This was brought up on an earlier review, yet it wasn't addressed.
To avoid this redundancy in the future, please reply to this mail with
your comments inline with the posters (i.e., no top-posting), thanks.

> +#include <linux/pci.h>

doubt you meant to include this.  makes me wonder what other includes
are unnecessary.

> +	/*
> +	 * Application only provided ptr for the rctx
> +	 * we alloc memory for it.
> +	 * And along we alloc memory for the sa in it.
> +	 */
> +	ctx->use_rctx = 1;
> +	ctx->direction = CRYPTO_OUTBOUND;
> +	rc = crypto4xx_alloc_sa_rctx(ctx, rctx);
> +	if (rc)
> +		return -ENOMEM;

if (IS_ERR(rc))
	return rc;

> +static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
> +				 const u8 *key,
> +				 unsigned int keylen,
> +				 unsigned char cm,
> +				 u8 fb)

bad alignment ('c' in const not directly under 's' in struct), and less
lines can be used.

> +{
> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct dynamic_sa_ctl *sa;
> +	int    rc;
> +
> +	if ((keylen != 256/8) &&  (keylen != 128/8) &&  (keylen != 192/8)) {

unnecessary inner parens.  Can we also use predefined AES_KEYSIZE_256
and friends?

> +		crypto_ablkcipher_set_flags(cipher,
> +				CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -1;

return -EINVAL;

> +	}
> +
> +	/* Create SA */
> +	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
> +		crypto4xx_free_sa(ctx);
> +
> +	if (keylen == 256/8)
> +		rc = crypto4xx_alloc_sa(ctx, SA_AES256_LEN);
> +	else if (keylen == 192/8)
> +		rc = crypto4xx_alloc_sa(ctx, SA_AES192_LEN);
> +	else
> +		rc = crypto4xx_alloc_sa(ctx, SA_AES128_LEN);

do this using arithmetic to avoid all this unnecessary change of flow.

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

this change of flow can be avoided too - use an array lookup to get the
sa_contents.  Stash the lookup array in a new top level member struct
that includes basic_algs under it, like other drivers do.

> +static inline int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
> +					   const u8 *key, unsigned int keylen)
> +{
> +	return crypto4xx_setkey_aes(cipher, key, keylen,
> +				    CRYPTO_MODE_CBC,
> +				    CRYPTO_FEEDBACK_MODE_NO_FB);
> +}

you're inlining a function whose address is being assigned to a
pointer. I'd say inline crypto_4xx_setkey_aes instead, but this
crypto4xx_setkey_aes_cbc wrapper fn seems extraneous until other modes
of aes are supported.

> +static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
> +				   unsigned int sa_len,
> +				   unsigned char ha,
> +				   unsigned char hm)

alignment: 'u' in unsigned goes under 's' in struct, and number of
lines can be reduced.

> +	sa = (struct dynamic_sa_ctl *)(ctx->sa_in);

parens not needed

> +	/* load hash state set to no load, since we don't no init idigest  */

sorry, I can't make sense of this comment.

> +	/* dynamic sa, need to set it to  rev 2 */
> +	sa->sa_command_1.bf.sa_rev = 1;

perhaps a define for the sa_rev enumeration would make the rev 2
comment less misleading.

> +		memset(sa_in->inner_digest, 0, 20);
> +		memset(sa_in->outer_digest, 0, 20);

don't hardcode; use sizeof().

> +	} else {
> +		printk(KERN_ERR "ERROR: invalid hash");
> +				" algorithm used \n");

use dev_err and make fit on one line.  Wait, I don't see how this else
clause is ever reached.

> +static int crypto4xx_hash_init(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	int ds;
> +	struct dynamic_sa_ctl *sa;
> +
> +	ctx->use_rctx = 0;
> +	sa = (struct dynamic_sa_ctl *)ctx->sa_in;
> +	ds = crypto_ahash_digestsize(
> +			__crypto_ahash_cast(req->base.tfm));
> +	sa->sa_command_0.bf.digest_len = ds>>2;
> +	sa->sa_command_0.bf.load_hash_state = SA_LOAD_HASH_FROM_SA;
> +	ctx->is_hash = 1;
> +	ctx->direction = CRYPTO_INBOUND;

can we reuse something like IPSEC_DIR_INBOUND instead of polluting
global-implying CRYPTO_* namespace to the reader here?

> +static int crypto4xx_hash_update(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +
> +	ctx->is_hash = 1;
> +	ctx->hash_final = 0;
> +	ctx->use_rctx = 0;
> +	ctx->pd_ctl = 0x11;

magic number; give it a name using a macro.

> +static int crypto4xx_hash_final(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *rctx = ahash_request_ctx(req);
> +
> +	crypto4xx_free_sa_rctx(rctx);
> +	return 0;

add a blank line before the return 0 to enhance readability.

> +static int crypto4xx_hash_digest(struct ahash_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	ctx->use_rctx = 0;

use blank lines to separate variable declarations from statement blocks.

> +/**
> + * SHA1 and SHA2 Algorithm
> + */
> +static int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm)
> +{
> +	return crypto4xx_hash_alg_init(tfm,
> +				       SA_HASH160_LEN,
> +				       SA_HASH_ALG_SHA1,
> +				       SA_HASH_MODE_HASH);

can fit in less lines, but why does this wrapper function exist in the
first place?

> +struct crypto_alg crypto4xx_basic_alg[] = {
> +
> +	/* Crypto AES modes */
> +	{.cra_name 		= "cbc(aes)",
> +	 .cra_driver_name 	= "cbc-aes-ppc4xx",
> +	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
> +	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> +	 .cra_blocksize 	= 16,	/* 128-bits block */

use AES_BLOCK_SIZE and lose the comment.

> +	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
> +	 .cra_alignmask 	= 0,
> +	 .cra_type 		= &crypto_ablkcipher_type,
> +	 .cra_module 		= THIS_MODULE,
> +	 .cra_u 		= {.ablkcipher = {
> +	 .min_keysize 		= 16,	/* AES min key size is 128-bits */

same - AES_KEYSIZE_128

> +	 .max_keysize 		= 32,	/* AES max key size is 256-bits */

AES_KEYSIZE_256

> +	 .ivsize 		= 16,	/* IV size is 16 bytes */

AES_BLOCK_SIZE

> +	 .setkey 		= crypto4xx_setkey_aes_cbc,
> +	 .encrypt 		= crypto4xx_encrypt,
> +	 .decrypt 		= crypto4xx_decrypt,
> +	 } }
> +	},

nest level is somewhat hidden from the reader.

> +	/* Hash SHA1, SHA2 */

looks like it's only SHA1?

> +	{.cra_name 		= "sha1",
> +	 .cra_driver_name 	= "sha1-ppc4xx",
> +	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
> +	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
> +	 .cra_blocksize 	= 64,	/* SHA1 block size is 512-bits */

SHA1_BLOCK_SIZE

> +	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
> +	 .cra_alignmask 	= 0,
> +	 .cra_type   		= &crypto_ahash_type,
> +	 .cra_init 		= crypto4xx_sha1_alg_init,
> +	 .cra_module 		= THIS_MODULE,
> +	 .cra_u  		= {.ahash = {
> +	 .digestsize 		= 20,	/* Disgest is 160-bits */

SHA1_DIGEST_SIZE

> + * Changes:
> + *	James Hsiao:	10/04/08
> + *			replace global variable lsec_core with data in
> + *			in struct device.
> + *			add parameter to various functions due to
> + *			to remove of global variable lsec_core
> + *			crypto4xx_alloc_sa now return error code.
> + *			not using PVR to identify which CPU, using DTS.
> + *			move this into the probe function.
> + *			pass struct device pointer to dma_alloc_coherent
> + *			and dma_free_coherent functions.
> + *			make function static where ever is possible.
> + *			remove crypto4xx_start_device.
> + *			remove crypt4xx_setup_crypto.
> + *			in crypto4xx_crypt_remove add kill tasklet.
> + *			in crypto4xx_stop_all unmap ce_base and free core_dev.
> + *			add lock to all get/put pd/sd/gd functions.
> + *			change PPC4XX_SEC_VERSION_STR to "0.3"

no changes list please.

> +static inline void crypto4xx_write32(struct crypto4xx_device *dev,
> +					u32 reg, u32 val)
> +{
> +	writel(val, dev->ce_base + reg);
> +}
> +
> +static inline void crypto4xx_read32(struct crypto4xx_device *dev,
> +					u32 reg, u32 *val)

alignment, might consider unwrapping these fns too, esp. since
crypto4xx_read32 is never called.

<big snip>

> +	if (sg_is_last(src) && (sg_is_last(dst) || ctx->is_hash))
> +		return crypto4xx_build_pd_normal(dev,
> +						req,
> +						ctx,
> +						src,
> +						dst,
> +						datalen,
> +						type);

:( less lines please

> +
> +	/*
> +	 * We need to use scatter/gather array
> +	 * Crypto Engine require consecutive descriptors
> +	 * disable irq to make sure not to preempted here
> +	 */
> +	local_irq_disable();

I doubt ppc4xx users would want their IRQs disabled while all this code
runs:

> +	pd_entry = crypto4xx_get_pd_from_pdr_nolock(dev);
> +	if (pd_entry == ERING_WAS_FULL) {
> +		local_irq_enable();
> +		return -EAGAIN;
> +	}
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
> +		pd->src = dma_map_page(dev->core_dev->device, sg_page(src),
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
> +		if (gd_idx == ERING_WAS_FULL)
> +			goto err_get_first_gd;
> +
> +		pd_uinfo->first_gd = gd_idx;
> +		gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
> +		pd->src = gd_dma;
> +		/* Enable gather */
> +		sa->sa_command_0.bf.gather = 1;
> +		idx = 0;
> +
> +		/*
> +		 * walk the sg, and setup gather array
> +		 * CRYPTO ENGINE DMA is byte align,
> +		 * so we can use ptr directly from sg
> +		 */
> +		while (nbytes != 0) {
> +			sg = &src[idx];
> +			addr = dma_map_page(dev->core_dev->device, sg_page(sg),
> +					    sg->offset, sg->length,
> +					    DMA_TO_DEVICE);
> +			gd->ptr = addr;
> +			gd->ctl_len.len = sg->length;
> +			gd->ctl_len.done = 0;
> +			gd->ctl_len.ready = 1;
> +			/* when using tcrypt, sum of sg->lenght maybe > nbytps*/
> +			if (sg->length >= nbytes)
> +				break;
> +			nbytes -= sg->length;
> +			/* Get first gd we are going to use */
> +			gd_idx = crypto4xx_get_gd_from_gdr(dev);
> +			if (gd_idx == ERING_WAS_FULL)
> +				goto err_get_gd;
> +
> +			gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
> +			pd_uinfo->last_gd = gd_idx;
> +			idx++;
> +		}
> +	}
> +
> +	if (ctx->is_hash || sg_is_last(dst)) {
> +		/*
> +		 * we know application give us dst a whole piece of memory
> +		 * no need to use scatter ring
> +		 */
> +		pd_uinfo->using_sd = 0;
> +		pd_uinfo->first_sd = pd_uinfo->last_sd = 0xffffffff;
> +		pd_uinfo->dest_va = dst;
> +		sa->sa_command_0.bf.scatter = 0;
> +		if (ctx->is_hash)
> +			pd->dest = virt_to_phys((void *)dst);
> +		else
> +			pd->dest = dma_map_page(dev->core_dev->device,
> +						sg_page(dst),
> +						dst->offset, dst->length,
> +						DMA_TO_DEVICE);
> +	} else {
> +		nbytes = datalen;
> +		sa->sa_command_0.bf.scatter = 1;
> +		pd_uinfo->using_sd = 1;
> +
> +		sd_idx = crypto4xx_get_sd_from_sdr(dev);
> +		if (sd_idx == ERING_WAS_FULL)
> +			goto err_get_first_sd;
> +
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
> +			if (sd_idx == ERING_WAS_FULL)
> +				goto err_get_sd;
> +
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
> +	crypto4xx_write32(dev, CRYPTO_ENGINE_INT_DESCR_RD, 1);
> +	local_irq_enable();
> +	return -EINPROGRESS;

..this is the type of reason why linuxppc-dev must be cc'd on this
patch; one is supposed to dynamically allocate and populate the
descriptor for the h/w, then grab the queue lock, quickly instruct the
h/w where to find it, and then immediately release it.  This is covered
in the Linux Device Drivers book, and further details can be found under
Documentation/, see e.g. spinlocks.txt.

I recommend you seek to get Josh Boyer's (amcc maintainer) acceptance
of this patch.

Kim
