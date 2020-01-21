Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27292C2D0CE
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A268722522
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=seznam.cz header.i=@seznam.cz header.b="IE9xlTDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgAUJYN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 04:24:13 -0500
Received: from mxs2.seznam.cz ([77.75.76.125]:44159 "EHLO mxs2.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgAUJYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 04:24:12 -0500
Received: from email.seznam.cz
        by email-smtpc10a.ng.seznam.cz (email-smtpc10a.ng.seznam.cz [10.23.11.45])
        id 5e3ef5adeb6594bf5e37107e;
        Tue, 21 Jan 2020 10:24:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1579598648; bh=OT+xbUv8cjEv+qrpU5WuR7eI/tdo+Txmw4WhYAiAIh0=;
        h=Received:Reply-To:Subject:To:Cc:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=IE9xlTDs14Pdd3EXqeWI/iJ0XtD0XS8280fC79hVw8/o5bTOh6hOx5ME2emKZPKPj
         GTtHenoLcCdJ91gSa3KA1vlKuVOh7R5zzG79PK3MhBQci+VmHed76ut/jegjkBYL4s
         cWytk+WncBbRE6Y5seui1yY3wZCo+xkVvXzkymio=
Received: from [77.75.76.48] (unknown-62-130.xilinx.com [149.199.62.130])
        by email-relay5.ng.seznam.cz (Seznam SMTPD 1.3.108) with ESMTP;
        Tue, 21 Jan 2020 10:24:03 +0100 (CET)  
Reply-To: monstr@monstr.eu
Subject: Re: [PATCH V4 4/4] crypto: Add Xilinx AES driver
To:     Kalyani Akula <kalyani.akula@xilinx.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan <mohand@xilinx.com>, Kalyani Akul <kalyania@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
 <1574235842-7930-5-git-send-email-kalyani.akula@xilinx.com>
From:   Michal Simek <monstr@seznam.cz>
Message-ID: <4e3a98c8-667a-97c6-d41b-ba571f652bad@seznam.cz>
Date:   Tue, 21 Jan 2020 10:23:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1574235842-7930-5-git-send-email-kalyani.akula@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20. 11. 19 8:44, Kalyani Akula wrote:
> This patch adds AES driver support for the Xilinx ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---
>  drivers/crypto/Kconfig                 |  11 +
>  drivers/crypto/Makefile                |   1 +
>  drivers/crypto/xilinx/Makefile         |   3 +
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 469 +++++++++++++++++++++++++++++++++
>  4 files changed, 484 insertions(+)
>  create mode 100644 drivers/crypto/xilinx/Makefile
>  create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 1fb622f..8e7d3a9 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -696,6 +696,17 @@ config CRYPTO_DEV_ROCKCHIP
>  	help
>  	  This driver interfaces with the hardware crypto accelerator.
>  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.

Here should be newline.

> +config CRYPTO_DEV_ZYNQMP_AES
> +	tristate "Support for Xilinx ZynqMP AES hw accelerator"
> +	depends on ARCH_ZYNQMP || COMPILE_TEST

depends on ZYNQMP_FIRMWARE || COMPILE_TEST
is better here because you can use it only on Versal.


> +	select CRYPTO_AES
> +	select CRYPTO_ENGINE
> +	select CRYPTO_AEAD
> +	help
> +	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
> +	  encryption and decryption. This driver interfaces with AES hw
> +	  accelerator. Select this if you want to use the ZynqMP module
> +	  for AES algorithms.
>  
>  config CRYPTO_DEV_MEDIATEK
>  	tristate "MediaTek's EIP97 Cryptographic Engine driver"
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index afc4753..50184377 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -47,4 +47,5 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
>  obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
>  obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
>  obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
> +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += xilinx/
>  obj-y += hisilicon/
> diff --git a/drivers/crypto/xilinx/Makefile b/drivers/crypto/xilinx/Makefile
> new file mode 100644
> index 0000000..16bdda7
> --- /dev/null
> +++ b/drivers/crypto/xilinx/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
> +

This looks like additional newline.

> diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> new file mode 100644
> index 0000000..534105b
> --- /dev/null
> +++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> @@ -0,0 +1,469 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Xilinx ZynqMP AES Driver.
> + * Copyright (c) 2019 Xilinx Inc.
> + */
> +
> +#include <crypto/aes.h>
> +#include <crypto/engine.h>
> +#include <crypto/gcm.h>
> +#include <crypto/internal/aead.h>
> +#include <crypto/scatterwalk.h>
> +
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/firmware/xlnx-zynqmp.h>
> +
> +#define DRIVER_NAME		"zynqmp-aes"

nite: Use only once - that's why you can just use directly.

> +#define ZYNQMP_DMA_BIT_MASK	32U
> +
> +#define ZYNQMP_AES_KEY_SIZE		AES_KEYSIZE_256
> +#define ZYNQMP_AES_AUTH_SIZE		16U
> +#define ZYNQMP_KEY_SRC_SEL_KEY_LEN	1U
> +#define ZYNQMP_AES_BLK_SIZE		1U
> +#define ZYNQMP_AES_MIN_INPUT_BLK_SIZE	4U
> +#define ZYNQMP_AES_WORD_LEN		4U
> +
> +#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
> +#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
> +#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
> +
> +enum zynqmp_aead_op {
> +	ZYNQMP_AES_DECRYPT = 0,
> +	ZYNQMP_AES_ENCRYPT
> +};
> +
> +enum zynqmp_aead_keysrc {
> +	ZYNQMP_AES_KUP_KEY = 0,
> +	ZYNQMP_AES_DEV_KEY,
> +	ZYNQMP_AES_PUF_KEY
> +};
> +
> +struct zynqmp_aead_drv_ctx {
> +	union {
> +		struct aead_alg aead;
> +	} alg;
> +	struct device *dev;
> +	struct crypto_engine *engine;
> +	const struct zynqmp_eemi_ops *eemi_ops;
> +};
> +
> +struct zynqmp_aead_hw_req {
> +	u64 src;
> +	u64 iv;
> +	u64 key;
> +	u64 dst;
> +	u64 size;
> +	u64 op;
> +	u64 keysrc;
> +};
> +
> +struct zynqmp_aead_tfm_ctx {
> +	struct crypto_engine_ctx engine_ctx;
> +	struct device *dev;
> +	u8 key[ZYNQMP_AES_KEY_SIZE];
> +	u8 *iv;
> +	u32 keylen;
> +	u32 authsize;
> +	enum zynqmp_aead_keysrc keysrc;
> +	struct crypto_aead *fbk_cipher;
> +};
> +
> +struct zynqmp_aead_req_ctx {
> +	enum zynqmp_aead_op op;
> +};
> +
> +static int zynqmp_aes_aead_cipher(struct aead_request *req)
> +{
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
> +	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
> +	struct device *dev = tfm_ctx->dev;
> +	struct aead_alg *alg = crypto_aead_alg(aead);
> +	struct zynqmp_aead_drv_ctx *drv_ctx;
> +	struct zynqmp_aead_hw_req *hwreq;
> +	dma_addr_t dma_addr_data, dma_addr_hw_req;
> +	unsigned int data_size;
> +	unsigned int status;
> +	size_t dma_size;
> +	char *kbuf;
> +	int err;
> +
> +	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
> +
> +	if (!drv_ctx->eemi_ops->aes)
> +		return -ENOTSUPP;
> +
> +	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY)
> +		dma_size = req->cryptlen + ZYNQMP_AES_KEY_SIZE
> +			   + GCM_AES_IV_SIZE;
> +	else
> +		dma_size = req->cryptlen + GCM_AES_IV_SIZE;
> +
> +	kbuf = dma_alloc_coherent(dev, dma_size, &dma_addr_data, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	hwreq = dma_alloc_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
> +				   &dma_addr_hw_req, GFP_KERNEL);
> +	if (!hwreq) {
> +		dma_free_coherent(dev, dma_size, kbuf, dma_addr_data);
> +		return -ENOMEM;
> +	}
> +
> +	data_size = req->cryptlen;
> +	scatterwalk_map_and_copy(kbuf, req->src, 0, req->cryptlen, 0);
> +	memcpy(kbuf + data_size, req->iv, GCM_AES_IV_SIZE);
> +
> +	hwreq->src = dma_addr_data;
> +	hwreq->dst = dma_addr_data;
> +	hwreq->iv = hwreq->src + data_size;
> +	hwreq->keysrc = tfm_ctx->keysrc;
> +	hwreq->op = rq_ctx->op;
> +
> +	if (hwreq->op == ZYNQMP_AES_ENCRYPT)
> +		hwreq->size = data_size;
> +	else
> +		hwreq->size = data_size - ZYNQMP_AES_AUTH_SIZE;
> +
> +	if (hwreq->keysrc == ZYNQMP_AES_KUP_KEY) {
> +		memcpy(kbuf + data_size + GCM_AES_IV_SIZE,
> +		       tfm_ctx->key, ZYNQMP_AES_KEY_SIZE);
> +
> +		hwreq->key = hwreq->src + data_size + GCM_AES_IV_SIZE;
> +	} else {
> +		hwreq->key = 0;
> +	}
> +
> +	drv_ctx->eemi_ops->aes(dma_addr_hw_req, &status);
> +
> +	if (status) {
> +		switch (status) {
> +		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
> +			dev_err(dev, "ERROR: Gcm Tag mismatch\n");
> +			break;
> +		case ZYNQMP_AES_WRONG_KEY_SRC_ERR:
> +			dev_err(dev, "ERROR: Wrong KeySrc, enable secure mode\n");
> +			break;
> +		case ZYNQMP_AES_PUF_NOT_PROGRAMMED:
> +			dev_err(dev, "ERROR: PUF is not registered\n");
> +			break;
> +		default:
> +			dev_err(dev, "ERROR: Unknown error\n");
> +			break;
> +		}
> +		err = -status;
> +	} else {
> +		if (hwreq->op == ZYNQMP_AES_ENCRYPT)
> +			data_size = data_size + ZYNQMP_AES_AUTH_SIZE;
> +		else
> +			data_size = data_size - ZYNQMP_AES_AUTH_SIZE;
> +
> +		sg_copy_from_buffer(req->dst, sg_nents(req->dst),
> +				    kbuf, data_size);
> +		err = 0;
> +	}
> +
> +	if (kbuf) {
> +		memzero_explicit(kbuf, dma_size);
> +		dma_free_coherent(dev, dma_size, kbuf, dma_addr_data);
> +	}
> +	if (hwreq) {
> +		memzero_explicit(hwreq, sizeof(struct zynqmp_aead_hw_req));
> +		dma_free_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
> +				  hwreq, dma_addr_hw_req);
> +	}
> +	return err;
> +}
> +
> +static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
> +				 struct aead_request *req)
> +{
> +	int need_fallback = 0;
> +	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
> +
> +	if (tfm_ctx->authsize != ZYNQMP_AES_AUTH_SIZE)
> +		need_fallback = 1;
> +
> +	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
> +	    tfm_ctx->keylen != ZYNQMP_AES_KEY_SIZE) {
> +		need_fallback = 1;
> +	}
> +	if (req->assoclen != 0 ||
> +	    req->cryptlen < ZYNQMP_AES_MIN_INPUT_BLK_SIZE) {
> +		need_fallback = 1;
> +	}
> +	if ((req->cryptlen % ZYNQMP_AES_WORD_LEN) != 0)
> +		need_fallback = 1;
> +
> +	if (rq_ctx->op == ZYNQMP_AES_DECRYPT &&
> +	    req->cryptlen <= ZYNQMP_AES_AUTH_SIZE) {
> +		need_fallback = 1;
> +	}
> +	return need_fallback;
> +}
> +
> +static int zynqmp_handle_aes_req(struct crypto_engine *engine,
> +				 void *req)
> +{
> +	struct aead_request *areq =
> +				container_of(req, struct aead_request, base);
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
> +	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(areq);
> +	struct aead_request *subreq = aead_request_ctx(req);
> +	int need_fallback;
> +	int err;
> +
> +	need_fallback = zynqmp_fallback_check(tfm_ctx, areq);
> +
> +	if (need_fallback) {
> +		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
> +
> +		aead_request_set_callback(subreq, areq->base.flags,
> +					  NULL, NULL);
> +		aead_request_set_crypt(subreq, areq->src, areq->dst,
> +				       areq->cryptlen, areq->iv);
> +		aead_request_set_ad(subreq, areq->assoclen);
> +		if (rq_ctx->op == ZYNQMP_AES_ENCRYPT)
> +			err = crypto_aead_encrypt(subreq);
> +		else
> +			err = crypto_aead_decrypt(subreq);
> +	} else {
> +		err = zynqmp_aes_aead_cipher(areq);
> +	}
> +
> +	crypto_finalize_aead_request(engine, areq, err);
> +	return 0;
> +}
> +
> +static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
> +				  unsigned int keylen)
> +{
> +	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx =
> +			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
> +	unsigned char keysrc;
> +	int err;
> +
> +	if (keylen == ZYNQMP_KEY_SRC_SEL_KEY_LEN) {
> +		keysrc = *key;
> +		if (keysrc == ZYNQMP_AES_KUP_KEY ||
> +		    keysrc == ZYNQMP_AES_DEV_KEY ||
> +		    keysrc == ZYNQMP_AES_PUF_KEY) {
> +			tfm_ctx->keysrc = (enum zynqmp_aead_keysrc)keysrc;
> +		} else {
> +			tfm_ctx->keylen = keylen;
> +		}
> +	} else {
> +		tfm_ctx->keylen = keylen;
> +		if (keylen == ZYNQMP_AES_KEY_SIZE) {
> +			tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
> +			memcpy(tfm_ctx->key, key, keylen);
> +		}
> +	}
> +
> +	tfm_ctx->fbk_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> +	tfm_ctx->fbk_cipher->base.crt_flags |= (aead->base.crt_flags &
> +					CRYPTO_TFM_REQ_MASK);
> +
> +	err = crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
> +	if (err) {
> +		aead->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
> +		aead->base.crt_flags |=
> +				(tfm_ctx->fbk_cipher->base.crt_flags &
> +				 CRYPTO_TFM_RES_MASK);
> +	}
> +
> +	return err;
> +}
> +
> +static int zynqmp_aes_aead_setauthsize(struct crypto_aead *aead,
> +				       unsigned int authsize)
> +{
> +	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx =
> +			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
> +
> +	tfm_ctx->authsize = authsize;
> +	return crypto_aead_setauthsize(tfm_ctx->fbk_cipher, authsize);
> +}
> +
> +static int zynqmp_aes_aead_encrypt(struct aead_request *req)
> +{
> +	struct zynqmp_aead_drv_ctx *drv_ctx;
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct aead_alg *alg = crypto_aead_alg(aead);
> +	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
> +
> +	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
> +	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
> +
> +	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
> +}
> +
> +static int zynqmp_aes_aead_decrypt(struct aead_request *req)
> +{
> +	struct zynqmp_aead_drv_ctx *drv_ctx;
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct aead_alg *alg = crypto_aead_alg(aead);
> +	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
> +
> +	rq_ctx->op = ZYNQMP_AES_DECRYPT;
> +	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
> +
> +	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
> +}
> +
> +static int zynqmp_aes_aead_init(struct crypto_aead *aead)
> +{
> +	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx =
> +		(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
> +	struct zynqmp_aead_drv_ctx *drv_ctx;
> +	struct aead_alg *alg = crypto_aead_alg(aead);
> +
> +	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
> +	tfm_ctx->dev = drv_ctx->dev;
> +
> +	tfm_ctx->engine_ctx.op.do_one_request = zynqmp_handle_aes_req;
> +	tfm_ctx->engine_ctx.op.prepare_request = NULL;
> +	tfm_ctx->engine_ctx.op.unprepare_request = NULL;
> +
> +	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->alg.aead.base.cra_name,
> +						0,
> +						CRYPTO_ALG_NEED_FALLBACK);
> +
> +	if (IS_ERR(tfm_ctx->fbk_cipher)) {
> +		pr_err("%s() Error: failed to allocate fallback for %s\n",
> +		       __func__, drv_ctx->alg.aead.base.cra_name);
> +		return PTR_ERR(tfm_ctx->fbk_cipher);
> +	}
> +
> +	crypto_aead_set_reqsize(aead,
> +				max(sizeof(struct zynqmp_aead_req_ctx),
> +				    sizeof(struct aead_request) +
> +				    crypto_aead_reqsize(tfm_ctx->fbk_cipher)));
> +	return 0;
> +}
> +
> +static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
> +{
> +	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx =
> +			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
> +
> +	if (tfm_ctx->fbk_cipher) {
> +		crypto_free_aead(tfm_ctx->fbk_cipher);
> +		tfm_ctx->fbk_cipher = NULL;
> +	}
> +	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
> +}
> +
> +static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
> +	.alg.aead = {
> +		.setkey		= zynqmp_aes_aead_setkey,
> +		.setauthsize	= zynqmp_aes_aead_setauthsize,
> +		.encrypt	= zynqmp_aes_aead_encrypt,
> +		.decrypt	= zynqmp_aes_aead_decrypt,
> +		.init		= zynqmp_aes_aead_init,
> +		.exit		= zynqmp_aes_aead_exit,
> +		.ivsize		= GCM_AES_IV_SIZE,
> +		.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
> +		.base = {
> +		.cra_name		= "gcm(aes)",
> +		.cra_driver_name	= "xilinx-zynqmp-aes-gcm",
> +		.cra_priority		= 200,
> +		.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
> +					  CRYPTO_ALG_ASYNC |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY |
> +					  CRYPTO_ALG_NEED_FALLBACK,
> +		.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
> +		.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
> +		.cra_module		= THIS_MODULE,
> +		}
> +	}
> +};
> +
> +static int zynqmp_aes_aead_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	int err = -1;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;

I would remove this.

> +
> +	/* ZynqMp AES driver supports only one instance */

ZynqMP

> +	if (!aes_drv_ctx.dev)
> +		aes_drv_ctx.dev = dev;
> +
> +	aes_drv_ctx.eemi_ops = zynqmp_pm_get_eemi_ops();
> +	if (IS_ERR(aes_drv_ctx.eemi_ops)) {
> +		dev_err(dev, "Failed to get ZynqMP EEMI interface\n");
> +		return PTR_ERR(aes_drv_ctx.eemi_ops);
> +	}
> +
> +	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
> +	if (err < 0) {
> +		dev_err(dev, "No usable DMA configuration\n");
> +		return err;
> +	}
> +
> +	aes_drv_ctx.engine = crypto_engine_alloc_init(dev, 1);
> +	if (!aes_drv_ctx.engine) {
> +		dev_err(dev, "Cannot alloc AES engine\n");
> +		err = -ENOMEM;
> +		goto err_engine;
> +	}
> +
> +	err = crypto_engine_start(aes_drv_ctx.engine);
> +	if (err) {
> +		dev_err(dev, "Cannot start AES engine\n");
> +		goto err_engine;
> +	}
> +
> +	err = crypto_register_aead(&aes_drv_ctx.alg.aead);
> +	if (err < 0) {
> +		dev_err(dev, "Failed to register AEAD alg.\n");
> +		goto err_aead;
> +	}
> +	return 0;
> +
> +err_aead:
> +	crypto_unregister_aead(&aes_drv_ctx.alg.aead);
> +
> +err_engine:
> +	if (aes_drv_ctx.engine)
> +		crypto_engine_exit(aes_drv_ctx.engine);
> +
> +	return err;
> +}
> +
> +static int zynqmp_aes_aead_remove(struct platform_device *pdev)
> +{
> +	crypto_engine_exit(aes_drv_ctx.engine);
> +	crypto_unregister_aead(&aes_drv_ctx.alg.aead);

newline here.

> +	return 0;
> +}
> +
> +static const struct of_device_id zynqmp_aes_dt_ids[] = {
> +	{ .compatible = "xlnx,zynqmp-aes" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
> +
> +static struct platform_driver zynqmp_aes_driver = {
> +	.probe	= zynqmp_aes_aead_probe,
> +	.remove = zynqmp_aes_aead_remove,
> +	.driver = {
> +		.name		= DRIVER_NAME,
> +		.of_match_table = zynqmp_aes_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(zynqmp_aes_driver);
> +
> +MODULE_LICENSE("GPL");
> +

Remove this newline at the end.


Thanks,
Michal
