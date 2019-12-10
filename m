Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4034BC00454
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 15:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CAD5207FF
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 15:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfLJP1m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 10:27:42 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35121 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfLJP1l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 10:27:41 -0500
Received: from erbse.hi.pengutronix.de ([2001:67c:670:100:9e5c:8eff:fece:cdfe])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <bst@pengutronix.de>)
        id 1iehQJ-0000QG-8V; Tue, 10 Dec 2019 16:27:39 +0100
From:   Bastian Krause <bst@pengutronix.de>
Subject: Re: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx <linux-imx@nxp.com>,
        kernel@pengutronix.de
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
Message-ID: <c0fa1e68-107d-f9ee-fbf2-0d0e6ef8d39d@pengutronix.de>
Date:   Tue, 10 Dec 2019 16:27:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:9e5c:8eff:fece:cdfe
X-SA-Exim-Mail-From: bst@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hi Iulia,

On 11/17/19 11:30 PM, Iuliana Prodan wrote:
> Integrate crypto_engine into CAAM, to make use of the engine queue.
> Add support for SKCIPHER algorithms.
> 
> This is intended to be used for CAAM backlogging support.
> The requests, with backlog flag (e.g. from dm-crypt) will be listed
> into crypto-engine queue and processed by CAAM when free.
> This changes the return codes for caam_jr_enqueue:
> -EINPROGRESS if OK, -EBUSY if request is backlogged,
> -ENOSPC if the queue is full, -EIO if it cannot map the caller's
> descriptor, -EINVAL if crypto_tfm not supported by crypto_engine.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/Kconfig   |  1 +
>  drivers/crypto/caam/caamalg.c | 84 +++++++++++++++++++++++++++++++++++--------
>  drivers/crypto/caam/intern.h  |  2 ++
>  drivers/crypto/caam/jr.c      | 51 ++++++++++++++++++++++++--
>  4 files changed, 122 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
> index 87053e4..1930e19 100644
> --- a/drivers/crypto/caam/Kconfig
> +++ b/drivers/crypto/caam/Kconfig
> @@ -33,6 +33,7 @@ config CRYPTO_DEV_FSL_CAAM_DEBUG
>  
>  menuconfig CRYPTO_DEV_FSL_CAAM_JR
>  	tristate "Freescale CAAM Job Ring driver backend"
> +	select CRYPTO_ENGINE
>  	default y
>  	help
>  	  Enables the driver module for Job Rings which are part of
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index abebcfc..23de94d 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -56,6 +56,7 @@
>  #include "sg_sw_sec4.h"
>  #include "key_gen.h"
>  #include "caamalg_desc.h"
> +#include <crypto/engine.h>
>  
>  /*
>   * crypto alg
> @@ -101,6 +102,7 @@ struct caam_skcipher_alg {
>   * per-session context
>   */
>  struct caam_ctx {
> +	struct crypto_engine_ctx enginectx;
>  	u32 sh_desc_enc[DESC_MAX_USED_LEN];
>  	u32 sh_desc_dec[DESC_MAX_USED_LEN];
>  	u8 key[CAAM_MAX_KEY_SIZE];
> @@ -114,6 +116,12 @@ struct caam_ctx {
>  	unsigned int authsize;
>  };
>  
> +struct caam_skcipher_req_ctx {
> +	struct skcipher_edesc *edesc;
> +	void (*skcipher_op_done)(struct device *jrdev, u32 *desc, u32 err,
> +				 void *context);
> +};
> +
>  static int aead_null_set_sh_desc(struct crypto_aead *aead)
>  {
>  	struct caam_ctx *ctx = crypto_aead_ctx(aead);
> @@ -992,13 +1000,15 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
>  	struct caam_jr_request_entry *jrentry = context;
>  	struct skcipher_request *req = skcipher_request_cast(jrentry->base);
>  	struct skcipher_edesc *edesc;
> +	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
>  	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
> +	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
>  	int ivsize = crypto_skcipher_ivsize(skcipher);
>  	int ecode = 0;
>  
>  	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
>  
> -	edesc = container_of(desc, struct skcipher_edesc, hw_desc[0]);
> +	edesc = rctx->edesc;
>  	if (err)
>  		ecode = caam_jr_strstatus(jrdev, err);
>  
> @@ -1024,7 +1034,14 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
>  
>  	kfree(edesc);
>  
> -	skcipher_request_complete(req, ecode);
> +	/*
> +	 * If no backlog flag, the completion of the request is done
> +	 * by CAAM, not crypto engine.
> +	 */
> +	if (!jrentry->bklog)
> +		skcipher_request_complete(req, ecode);
> +	else
> +		crypto_finalize_skcipher_request(jrp->engine, req, ecode);
>  }
>  
>  /*
> @@ -1553,6 +1570,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
>  {
>  	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
>  	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
> +	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
>  	struct device *jrdev = ctx->jrdev;
>  	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>  		       GFP_KERNEL : GFP_ATOMIC;
> @@ -1653,6 +1671,9 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
>  						  desc_bytes);
>  	edesc->jrentry.base = &req->base;
>  
> +	rctx->edesc = edesc;
> +	rctx->skcipher_op_done = skcipher_crypt_done;
> +
>  	/* Make sure IV is located in a DMAable area */
>  	if (ivsize) {
>  		iv = (u8 *)edesc->sec4_sg + sec4_sg_bytes;
> @@ -1707,13 +1728,37 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
>  	return edesc;
>  }
>  
> +static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
> +{
> +	struct skcipher_request *req = skcipher_request_cast(areq);
> +	struct caam_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> +	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
> +	struct caam_jr_request_entry *jrentry;
> +	u32 *desc = rctx->edesc->hw_desc;
> +	int ret;
> +
> +	jrentry = &rctx->edesc->jrentry;
> +	jrentry->bklog = true;
> +
> +	ret = caam_jr_enqueue_no_bklog(ctx->jrdev, desc,
> +				       rctx->skcipher_op_done, jrentry);
> +
> +	if (ret != -EINPROGRESS) {
> +		skcipher_unmap(ctx->jrdev, rctx->edesc, req);
> +		kfree(rctx->edesc);
> +	} else {
> +		ret = 0;
> +	}
> +
> +	return ret;

While testing this on a i.MX6 DualLite I see -ENOSPC being returned here
after a couple of GiB of data being encrypted (via dm-crypt with LUKS
extension). This results in these messages from crypto_engine:

  caam_jr 2101000.jr0: Failed to do one request from queue: -28

And later..

  Buffer I/O error on device dm-0, logical block 59392
  JBD2: Detected IO errors while flushing file data on dm-0-8

Reproducible with something like this:

  echo "testkey" | cryptsetup luksFormat \
    --cipher=aes-cbc-essiv:sha256 \
    --key-file=- \
    --key-size=256 \
    /dev/mmcblk1p8
  echo "testkey" | cryptsetup open \
    --type luks \
    --key-file=- \
    /dev/mmcblk1p8 data

  mkfs.ext4 /dev/mapper/data
  mount /dev/mapper/data /mnt

  set -x
  while [ true ]; do
    dd if=/dev/zero of=/mnt/big_file bs=1M count=1024
    sync
  done

Any ideas?

Regards,
Bastian


> +}
> +
>  static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
>  {
>  	struct skcipher_edesc *edesc;
>  	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
>  	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
>  	struct device *jrdev = ctx->jrdev;
> -	struct caam_jr_request_entry *jrentry;
>  	u32 *desc;
>  	int ret = 0;
>  
> @@ -1727,16 +1772,15 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
>  
>  	/* Create and submit job descriptor*/
>  	init_skcipher_job(req, edesc, encrypt);
> +	desc = edesc->hw_desc;
>  
>  	print_hex_dump_debug("skcipher jobdesc@" __stringify(__LINE__)": ",
> -			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
> -			     desc_bytes(edesc->hw_desc), 1);
> -
> -	desc = edesc->hw_desc;
> -	jrentry = &edesc->jrentry;
> +			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
> +			     desc_bytes(desc), 1);
>  
> -	ret = caam_jr_enqueue(jrdev, desc, skcipher_crypt_done, jrentry);
> -	if (ret != -EINPROGRESS) {
> +	ret = caam_jr_enqueue(jrdev, desc, skcipher_crypt_done,
> +			      &edesc->jrentry);
> +	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
>  		skcipher_unmap(jrdev, edesc, req);
>  		kfree(edesc);
>  	}
> @@ -3272,7 +3316,9 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
>  
>  	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_enc,
>  					offsetof(struct caam_ctx,
> -						 sh_desc_enc_dma),
> +						 sh_desc_enc_dma) -
> +					offsetof(struct caam_ctx,
> +						 sh_desc_enc),
>  					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
>  	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
>  		dev_err(ctx->jrdev, "unable to map key, shared descriptors\n");
> @@ -3282,8 +3328,12 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
>  
>  	ctx->sh_desc_enc_dma = dma_addr;
>  	ctx->sh_desc_dec_dma = dma_addr + offsetof(struct caam_ctx,
> -						   sh_desc_dec);
> -	ctx->key_dma = dma_addr + offsetof(struct caam_ctx, key);
> +						   sh_desc_dec) -
> +					offsetof(struct caam_ctx,
> +						 sh_desc_enc);
> +	ctx->key_dma = dma_addr + offsetof(struct caam_ctx, key) -
> +					offsetof(struct caam_ctx,
> +						 sh_desc_enc);
>  
>  	/* copy descriptor header template value */
>  	ctx->cdata.algtype = OP_TYPE_CLASS1_ALG | caam->class1_alg_type;
> @@ -3297,6 +3347,11 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
>  	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
>  	struct caam_skcipher_alg *caam_alg =
>  		container_of(alg, typeof(*caam_alg), skcipher);
> +	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
> +
> +	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
>  
>  	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
>  				false);
> @@ -3315,7 +3370,8 @@ static int caam_aead_init(struct crypto_aead *tfm)
>  static void caam_exit_common(struct caam_ctx *ctx)
>  {
>  	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_enc_dma,
> -			       offsetof(struct caam_ctx, sh_desc_enc_dma),
> +			       offsetof(struct caam_ctx, sh_desc_enc_dma) -
> +			       offsetof(struct caam_ctx, sh_desc_enc),
>  			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
>  	caam_jr_free(ctx->jrdev);
>  }
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
> index 58be66c..31abb94 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -12,6 +12,7 @@
>  
>  #include "ctrl.h"
>  #include "regs.h"
> +#include <crypto/engine.h>
>  
>  /* Currently comes from Kconfig param as a ^2 (driver-required) */
>  #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
> @@ -61,6 +62,7 @@ struct caam_drv_private_jr {
>  	int out_ring_read_index;	/* Output index "tail" */
>  	int tail;			/* entinfo (s/w ring) tail index */
>  	void *outring;			/* Base of output ring, DMA-safe */
> +	struct crypto_engine *engine;
>  };
>  
>  /*
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 544cafa..5c55d3d 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -62,6 +62,15 @@ static void unregister_algs(void)
>  	mutex_unlock(&algs_lock);
>  }
>  
> +static void caam_jr_crypto_engine_exit(void *data)
> +{
> +	struct device *jrdev = data;
> +	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
> +
> +	/* Free the resources of crypto-engine */
> +	crypto_engine_exit(jrpriv->engine);
> +}
> +
>  static int caam_reset_hw_jr(struct device *dev)
>  {
>  	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
> @@ -418,10 +427,23 @@ int caam_jr_enqueue_no_bklog(struct device *dev, u32 *desc,
>  }
>  EXPORT_SYMBOL(caam_jr_enqueue_no_bklog);
>  
> +static int transfer_request_to_engine(struct crypto_engine *engine,
> +				      struct crypto_async_request *req)
> +{
> +	switch (crypto_tfm_alg_type(req->tfm)) {
> +	case CRYPTO_ALG_TYPE_SKCIPHER:
> +		return crypto_transfer_skcipher_request_to_engine(engine,
> +								  skcipher_request_cast(req));
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  /**
>   * caam_jr_enqueue() - Enqueue a job descriptor head. Returns -EINPROGRESS
> - * if OK, -ENOSPC if the queue is full, -EIO if it cannot map the caller's
> - * descriptor.
> + * if OK, -EBUSY if request is backlogged, -ENOSPC if the queue is full,
> + * -EIO if it cannot map the caller's descriptor, -EINVAL if crypto_tfm
> + * not supported by crypto_engine.
>   * @dev:  device of the job ring to be used. This device should have
>   *        been assigned prior by caam_jr_register().
>   * @desc: points to a job descriptor that execute our request. All
> @@ -451,7 +473,12 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
>  				u32 status, void *areq),
>  		    void *areq)
>  {
> +	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(dev);
>  	struct caam_jr_request_entry *jrentry = areq;
> +	struct crypto_async_request *req = jrentry->base;
> +
> +	if (req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
> +		return transfer_request_to_engine(jrpriv->engine, req);
>  
>  	return caam_jr_enqueue_no_bklog(dev, desc, cbk, jrentry);
>  }
> @@ -577,6 +604,26 @@ static int caam_jr_probe(struct platform_device *pdev)
>  		return error;
>  	}
>  
> +	/* Initialize crypto engine */
> +	jrpriv->engine = crypto_engine_alloc_init(jrdev, false);
> +	if (!jrpriv->engine) {
> +		dev_err(jrdev, "Could not init crypto-engine\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Start crypto engine */
> +	error = crypto_engine_start(jrpriv->engine);
> +	if (error) {
> +		dev_err(jrdev, "Could not start crypto-engine\n");
> +		crypto_engine_exit(jrpriv->engine);
> +		return error;
> +	}
> +
> +	error = devm_add_action_or_reset(jrdev, caam_jr_crypto_engine_exit,
> +					 jrdev);
> +	if (error)
> +		return error;
> +
>  	/* Identify the interrupt */
>  	jrpriv->irq = irq_of_parse_and_map(nprop, 0);
>  	if (!jrpriv->irq) {
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
