From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v4]
Date: Thu, 4 Dec 2008 19:32:56 -0600
Message-ID: <20081204193256.12dbc306.kim.phillips@freescale.com>
References: <1228256232.4770.47.camel@jhsiao-usb>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: jhsiao@amcc.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:53664 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYLEBar (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 20:30:47 -0500
In-Reply-To: <1228256232.4770.47.camel@jhsiao-usb>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 02 Dec 2008 14:17:12 -0800
James Hsiao <jhsiao@amcc.com> wrote:

> Hi,
> 
> This patch add canyonlands support.
> 
> Few performance optimizations:
> Redesigned the crypto4xx_build_pd(), which now calculate number of
> scatter and gather descriptors need before taking them. Instead take 
> these descriptors one by one, now we take them together. Doing this way
> the time needed to be locked is much reduced. This function now supports
> aad which needed by future release. 
> 
> Introduced functions to setup the commands registers. This is to reduce
> code space and increase the likelihood for cache hit.
> 
> Eliminate the need for dynamically alloc memory for request context, by
> cache up per packet 'sa' in pd_uinfo.
> 
> Response to previous review:
> Removed not needed includes.
> Avoid using if else flow as Kim suggested in few places.
> lineup multiline parameters of functions.
> removed change log.
> 
> We still include crypto/internal/hash.h because we support 'ahash' which
> need that header file.
> 
> We still have the wrapper function for alg_init(), because  we will have
> multiple algorithm files and external define for the struct ...alg[]
> does not work.
> 
> Thanks
> James
> 
> 
> Signed-off-by: James Hsiao <jhsiao@amcc.com>
> ---

just fyi, all text above the --- line above is part of the git commit
message - might want to help the maintainers by cleaning up things like
"Hi" etc. and moving them here, below the --- line.

> diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
> index 79fe412..b0f0096 100644
> --- a/arch/powerpc/boot/dts/canyonlands.dts
> +++ b/arch/powerpc/boot/dts/canyonlands.dts
> @@ -116,6 +116,13 @@
>  			dcr-reg = <0x010 0x002>;
>  		};
>  
> +		CRYPTO: crypto@180000 {
> +			compatible = "amcc,ppc460ex-crypto", "amcc,ppc4xx-crypto";
> +			reg = <4 0x00180000 0x80400>;
> +			interrupt-parent = <&UIC0>;
> +			interrupts = <0x1d 0x4>;

that's odd, according to the current canyonlands.dts, irq 0x1d is
already assigned to UART2 (and the request_irq this driver makes
doesn't specify a shared flag).

> diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
> new file mode 100644
> index 0000000..7a693e4
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_alg.c
> +static int crypto4xx_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +
> +	ctx->direction = DIR_INBOUND;
> +	ctx->hash_final = 0;
> +	ctx->is_hash = 0;
> +	ctx->pd_ctl = 1;
> +	ctx->direction = DIR_INBOUND;

duplicate assignment

> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> +/*
> + * derive number of elements in scatterlist
> + * Shamlessly copy from talitos.c

this fn should one day be refactored and placed in lib/scatterlist.c -
all the crypto drivers currently implement their own version.

> + */
> +static int get_sg_count(struct scatterlist *sg_list, int nbytes)
> +{
> +	struct scatterlist *sg = sg_list;
> +	int sg_nents = 0;
> +
> +	while (nbytes) {
> +		sg_nents++;
> +		if (sg->length > nbytes)
> +			break;

this is slightly different - this condition shouldn't need checking
here - see [1] below..

> +		nbytes -= sg->length;
> +		sg = sg_next(sg);
> +	}
> +
> +	return sg_nents;
> +}

> +u32 crypto4xx_build_pd(struct crypto_async_request *req,
> +			struct crypto4xx_ctx *ctx,
> +			struct scatterlist *src,
> +			struct scatterlist *dst,
> +			unsigned int datalen,
> +			struct scatterlist *assoc,
> +			u32 aad_len, void *iv, u32 iv_len)
> +{
> +	struct crypto4xx_device *dev = ctx->dev;
> +	dma_addr_t addr, pd_dma, sd_dma, gd_dma;
> +	struct dynamic_sa_ctl *sa;
> +	struct scatterlist *sg;
> +	struct scatterlist *aad;
> +	struct ce_gd *gd;
> +	struct ce_pd *pd;
> +	u32 num_gd, num_sd;
> +	u32 fst_gd = 0xffffffff;
> +	u32 fst_sd = 0xffffffff;
> +	u32 pd_entry;
> +	struct pd_uinfo *pd_uinfo = NULL;
> +	unsigned int nbytes = datalen, idx;
> +	unsigned int aadlen = 0;
> +	unsigned int ivlen = 0;
> +	u32 gd_idx = 0;
> +
> +	/* figure how many gd is needed */
> +	if (aad_len) {
> +		num_gd = get_sg_count(assoc, aad_len) +
> +			get_sg_count(src, datalen);

this is dead code - aad_len is never non-zero - is there some code
missing from crypto4xx_alg.c?  Also, IIRC, assoc is a superset of src,
so I believe something like num_gd = get_sg_count(assoc, aad_len +
datalen) would work better - this should also permit removal of the
nbytes reached check in [1] in get_sg_count.

> +	/*
> +	 * The follow section of code needs to be protected
> +	 * The gather ring and scatter ring needs to be consecutive
> +	 * In case of run out of any kind of descriptor, the descriptor
> +	 * already got must be return the original place. So, here
> +	 * we disable interrupt.
> +	 * We found using irq disable here is 30% faster than
> +	 * using preempt disable.
> +	 */
> +	local_irq_disable();

the 30% increase in speed shouldn't be for the preemption-off case, and
not using preempt_{en,dis}able adds latency outside of this driver for
users that have preemption turned on (local_irq_enable doesn't check to
reschedule).  To satisfy memory barrier (completely absent here),
preemption, and smp requirements, use of spin_lock methods is
recommended.  Performance shouldn't be negatively affected if
CONFIG_SMP and CONFIG_PREEMPT are turned off.

> +		while (nbytes) {
> +			sd_idx = get_next_sd(sd_idx);
> +			sd = crypto4xx_get_sdp(dev, &sd_dma, sd_idx);
> +			/* setup scatter descriptor */
> +			sd->ctl.done = 0;
> +			sd->ctl.rdy = 1;
> +			if (nbytes >= PPC4XX_SD_BUFFER_SIZE)
> +				nbytes -= PPC4XX_SD_BUFFER_SIZE;
> +			else
> +				/*
> +				 * SD entry can hold PPC4XX_SD_BUFFER_SIZE,
> +				 * which is more than nbytes, so done.
> +				 */
> +			    nbytes = 0;

alignment

> +/**
> + * Algorithm Registration Functions
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

insert blank line here please

> +	return 0;
> +}
> +
> +static void crypto4xx_alg_exit(struct crypto_tfm *tfm)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);

insert blank line here please

> +	crypto4xx_free_sa(ctx);
<snip>
> +	printk(KERN_INFO "Loaded AMCC PPC4xx crypto "
> +	       "accelerator driver v%s\n", PPC4XX_SEC_VERSION_STR);
> +
> +	return rc;
> +
> +err_start_dev:
> +err_register_alg:

no redundant labels, please.

also, if some algorithms succeed registration, and then one fails, this
code doesn't handle the de-registration of the ones that succeeded -
not nice if the user wants this situation to revert to s/w crypto.

> +	iounmap(core_dev->dev->ce_base);
> +	free_irq(core_dev->irq, dev);
> +	irq_dispose_mapping(core_dev->irq);
> +err_request_irq:

irq_dispose_mapping goes here

> +err_build_sdr:
> +	crypto4xx_destroy_gdr(core_dev->dev);

destroy_sdr, no?

> +err_build_gdr:

destroy_gdr should probably go here

> +err_build_pdr:
> +	crypto4xx_destroy_pdr(core_dev->dev);
> +	kfree(core_dev->dev);
> +err_alloc_dev:
> +	kfree(core_dev);
> +
> +	return rc;
> +}

missing at least a tasklet_kill and an iounmap

> diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
> new file mode 100644
> index 0000000..7d27959
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_core.h
> @@ -0,0 +1,190 @@

> +extern struct crypto4xx_core_device lsec_core;

this appears to be leftovers from prior versions of this patch

> +extern struct crypto_alg crypto4xx_basic_alg[];

afaict, this isn't necessary either

> diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
> new file mode 100644
> index 0000000..9db78e8
> --- /dev/null
> +++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
> @@ -0,0 +1,283 @@
> +#ifndef __CRYPTO_ENGINE_REG_DEF_H__
> +#define __CRYPTO_ENGINE_REG_DEF_H__
> +
> +/* CRYPTO_ENGINE Register offset */
> +#define CRYPTO_ENGINE_DESCRIPTOR			0x00000000

can we s/CRYPTO_ENGINE_/PPC4XX_/g (or CRYPTO4XX_?) so as to not pollute
CRYPTO_ namespace?

Thanks,

Kim
