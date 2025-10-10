Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78B014286;
	Fri, 10 Oct 2025 06:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760079193; cv=none; b=b3wfiMPrri5SRJon2ahYTNjZ0BFQM9kA947POvnWR4OO9Wunt1oFgy4fksVDv042spsQkIrsxJt/tVIr2hIib3/NUg3pF/K1UvYdZaG+ksKN6cp6xGoPm5SehCTq+n7AoXRz1aeAMXVA7KiWBoXb3HiXhz6U6fow2UP2vZYhLG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760079193; c=relaxed/simple;
	bh=gfwG0aCYhsHTDT+b8VFJnsDeKc74rXvjOdDae94MYuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YsHJg9uKU8ZLoCwYwUAjD4l87Nd0CHaLZYBZ36P7PN2bJUtM7g93/FHMCmyg49ydcSSw5ldQx5js/I/UqtC/j32xzr9y63zKoDVTeHYvO0WekLTLjhV9C9QGvruGIttqXL0lFGzJgCK2FzYyoCdlrKP+mt+7apvy28Zczy7GP0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=g93F8CBb; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="g93F8CBb"
Received: from lelvem-sh01.itg.ti.com ([10.180.77.71])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59A6qxrj631500;
	Fri, 10 Oct 2025 01:52:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1760079179;
	bh=+HlKS0pc1nxNdLZuPPcuGKiXGG+XftG3oUJq8GFlUqo=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=g93F8CBbz0AzYh9EFPxYZoHdA4pOoU09VVophfWWRX4lLM4H/VsdDcUO3r1Jmg5yW
	 myvysDhbAVTEm7xqPkeOS/sGhr5/D2tyYUumrPgR3bcqGBkZGi35ppfCt6hsSxsT9l
	 XX1Q+vKO7R00CmEpj+ZHowBGjJdAtfCDrTcCaE0Y=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
	by lelvem-sh01.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59A6qwcK869270
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Fri, 10 Oct 2025 01:52:58 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Fri, 10
 Oct 2025 01:52:58 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 10 Oct 2025 01:52:58 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59A6qsej1249086;
	Fri, 10 Oct 2025 01:52:54 -0500
Message-ID: <d2ac59ca-5c44-44c0-af9a-cdfda9d4ed1c@ti.com>
Date: Fri, 10 Oct 2025 12:22:53 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] Add SPAcc ahash support
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <robh@kernel.org>
CC: <krzk+dt@kernel.org>, <conor+dt@kernel.org>, <Ruud.Derwig@synopsys.com>,
        <manjunath.hadli@vayavyalabs.com>, <adityak@vayavyalabs.com>,
        Bhoomika Kadabi
	<bhoomikak@vayavyalabs.com>
References: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
 <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi,
On 07/10/25 12:20, Pavitrakumar Managutte wrote:
> Add ahash support to SPAcc driver.

> 
> diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dwc-spacc/spacc_ahash.c
> new file mode 100644
> index 000000000000..99a609f89eaf
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> @@ -0,0 +1,980 @@
> +// SPDX-License-Identifier: GPL-2.0
[...]> +
> +static int spacc_hash_init_dma(struct device *dev, struct ahash_request *req)
> +{
> +	int rc = -1;
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
> +	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +
> +	gfp_t mflags = GFP_ATOMIC;
> +
> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
> +		mflags = GFP_KERNEL;

GFP_ATOMIC should preferably only be used in contexts which cannot sleep (inside interrupt handlers, spinlocks, etc.). Otherwise prefer GFP_KERNEL.

> +
> +	ctx->digest_buf = dma_pool_alloc(spacc_hash_pool, mflags,
> +					 &ctx->digest_dma);
> +
> +	if (!ctx->digest_buf)
> +		return -ENOMEM;
> +
> +	rc = pdu_ddt_init(dev, &ctx->dst, 1 | 0x80000000);
> +	if (rc < 0) {
> +		dev_err(dev, "ERR: PDU DDT init error\n");
> +		rc = -EIO;
> +		goto err_free_digest;
> +	}
> +
> +	pdu_ddt_add(dev, &ctx->dst, ctx->digest_dma, SPACC_MAX_DIGEST_SIZE);
> +
> +	if (ctx->total_nents > 0 && ctx->single_shot) {
> +		/* single shot */
> +		spacc_ctx_clone_handle(req);
> +
> +		if (req->nbytes) {
> +			rc = spacc_sg_to_ddt(dev, req->src, req->nbytes,
> +					     &ctx->src, DMA_TO_DEVICE);
> +		} else {
> +			memset(tctx->tmp_buffer, '\0', PPP_BUF_SIZE);
> +			sg_set_buf(&tctx->tmp_sgl[0], tctx->tmp_buffer,
> +				   PPP_BUF_SIZE);
> +			rc = spacc_sg_to_ddt(dev, &tctx->tmp_sgl[0],
> +					     tctx->tmp_sgl[0].length,
> +					     &ctx->src, DMA_TO_DEVICE);
> +		}
> +	} else if (ctx->total_nents == 0 && req->nbytes == 0) {
> +		spacc_ctx_clone_handle(req);
> +
> +		/* zero length case */
> +		memset(tctx->tmp_buffer, '\0', PPP_BUF_SIZE);
> +		sg_set_buf(&tctx->tmp_sgl[0], tctx->tmp_buffer, PPP_BUF_SIZE);
> +		rc = spacc_sg_to_ddt(dev, &tctx->tmp_sgl[0],
> +				     tctx->tmp_sgl[0].length,
> +				     &ctx->src, DMA_TO_DEVICE);
> +	}
> +
> +	if (rc < 0)
> +		goto err_free_dst;
> +
> +	ctx->src_nents = rc;
> +
> +	return rc;
> +
> +err_free_dst:
> +	pdu_ddt_free(&ctx->dst);
> +err_free_digest:
> +	dma_pool_free(spacc_hash_pool, ctx->digest_buf, ctx->digest_dma);
> +
> +	return rc;
> +}
> +
[...]> +
> +static int do_shash(struct device *dev, unsigned char *name,
> +		    unsigned char *result, const u8 *data1,
> +		    unsigned int data1_len, const u8 *data2,
> +		    unsigned int data2_len, const u8 *key,
> +		    unsigned int key_len)
> +{
> +	int rc = 0;
> +	unsigned int size;
> +	struct sdesc *sdesc;
> +	struct crypto_shash *hash;
> +
> +	hash = crypto_alloc_shash(name, 0, 0);
> +	if (IS_ERR(hash)) {
> +		rc = PTR_ERR(hash);
> +		dev_err(dev, "ERR: Crypto %s allocation error %d\n", name, rc);
> +		return rc;
> +	}
> +
> +	size = sizeof(struct shash_desc) + crypto_shash_descsize(hash);
> +	sdesc = kmalloc(size, GFP_KERNEL);
> +	if (!sdesc) {
> +		rc = -ENOMEM;
> +		goto do_shash_err;
> +	}
> +	sdesc->shash.tfm = hash;
> +
> +	if (key_len > 0) {
> +		rc = crypto_shash_setkey(hash, key, key_len);
> +		if (rc) {
> +			dev_err(dev, "ERR: Could not setkey %s shash\n", name);
> +			goto do_shash_err;
> +		}
> +	}
> +
> +	rc = crypto_shash_init(&sdesc->shash);
> +	if (rc) {
> +		dev_err(dev, "ERR: Could not init %s shash\n", name);
> +		goto do_shash_err;
> +	}
> +
> +	rc = crypto_shash_update(&sdesc->shash, data1, data1_len);
> +	if (rc) {
> +		dev_err(dev, "ERR: Could not update1\n");
> +		goto do_shash_err;
> +	}
> +
> +	if (data2 && data2_len) {
> +		rc = crypto_shash_update(&sdesc->shash, data2, data2_len);
> +		if (rc) {
> +			dev_err(dev, "ERR: Could not update2\n");
> +			goto do_shash_err;
> +		}
> +	}
> +
> +	rc = crypto_shash_final(&sdesc->shash, result);
> +	if (rc)
> +		dev_err(dev, "ERR: Could not generate %s hash\n", name);
> +
> +do_shash_err:
> +	crypto_free_shash(hash);
> +	kfree(sdesc);
> +
> +	return rc;
> +}
> +
> +static int spacc_hash_setkey(struct crypto_ahash *tfm, const u8 *key,
> +			     unsigned int keylen)
> +{
> +	int rc = 0;
> +	int ret = 0;
> +	unsigned int block_size;
> +	unsigned int digest_size;
> +	char hash_alg[CRYPTO_MAX_ALG_NAME];
> +	const struct spacc_alg *salg = spacc_tfm_ahash(&tfm->base);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
> +	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
> +
> +	block_size = crypto_tfm_alg_blocksize(&tfm->base);
> +	digest_size = crypto_ahash_digestsize(tfm);
> +
> +	/*
> +	 * We will not use the hardware in case of HMACs
If you are always going to do HMAC in software fallback, maybe don't register them in your driver? Why go through the unnecessary overhead when the users can directly use the software implementation.
Although, it looks like you are only computing the hashed keys for HMAC here in software, If that is the case, clarify the comments that you are only not doing key pre-processing for HMAC in hardware.

Also, all invocations of do_shash function are only below, and all are passing (NULL, 0) for (key, keylen). You can just not set the key in the software invocation for simple hashing. Same with (data2, data2_len). It is never used. You can change the function signature and remove these arguments (along with, obviously, removing their usage in the function do_shash).

> +	 * This was meant for hashes but it works for cmac/xcbc since we
> +	 * only intend to support 128-bit keys...
> +	 */
> +	if (keylen > block_size && salg->mode->id != CRYPTO_MODE_MAC_CMAC) {
> +		dev_dbg(salg->dev, "Exceeds keylen: %u\n", keylen);
> +		dev_dbg(salg->dev, "Req. keylen hashing %s\n",
> +			salg->calg->cra_name);
> +
> +		memset(hash_alg, 0x00, CRYPTO_MAX_ALG_NAME);
> +		switch (salg->mode->id)	{
> +		case CRYPTO_MODE_HMAC_SHA224:
> +			rc = do_shash(salg->dev, "sha224", tctx->ipad, key,
> +				      keylen, NULL, 0, NULL, 0);
> +			break;
> +
> +		case CRYPTO_MODE_HMAC_SHA256:
> +			rc = do_shash(salg->dev, "sha256", tctx->ipad, key,
> +				      keylen, NULL, 0, NULL, 0);
> +			break;
> +
> +		case CRYPTO_MODE_HMAC_SHA384:
> +			rc = do_shash(salg->dev, "sha384", tctx->ipad, key,
> +				      keylen, NULL, 0, NULL, 0);
> +			break;
> +
> +		case CRYPTO_MODE_HMAC_SHA512:
> +			rc = do_shash(salg->dev, "sha512", tctx->ipad, key,
> +				      keylen, NULL, 0, NULL, 0);
> +			break;
> +
> +		case CRYPTO_MODE_HMAC_MD5:
> +			rc = do_shash(salg->dev, "md5", tctx->ipad, key,
> +				      keylen, NULL, 0, NULL, 0);
> +			break;
> +
> +		case CRYPTO_MODE_HMAC_SHA1:
> +			rc = do_shash(salg->dev, "sha1", tctx->ipad, key,
> +				      keylen, NULL, 0, NULL, 0);
> +			break;
> +		case CRYPTO_MODE_HMAC_SM3:
> +			rc = do_shash(salg->dev, "sm3", tctx->ipad, key,
> +				      keylen, NULL, 0, NULL, 0);
> +			break;
> +
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		if (rc < 0) {
> +			dev_err(salg->dev, "ERR: %d computing shash for %s\n",
> +				rc, hash_alg);
> +			return -EIO;
> +		}
> +
> +		keylen = digest_size;
> +		dev_dbg(salg->dev, "updated keylen: %u\n", keylen);
> +
> +		tctx->ctx_valid = false;
> +
> +		rc = crypto_ahash_setkey(tctx->fb.hash,
> +				tctx->ipad, keylen);
> +		if (rc < 0)
> +			return rc;
> +	} else {
> +		memcpy(tctx->ipad, key, keylen);
> +		tctx->ctx_valid = false;
> +
> +		rc = crypto_ahash_setkey(tctx->fb.hash, key, keylen);
> +		if (rc < 0)
> +			return rc;
> +	}
> +
> +	/* close handle since key size may have changed */
> +	if (tctx->handle >= 0) {
> +		spacc_close(&priv->spacc, tctx->handle);
> +		put_device(tctx->dev);
> +		tctx->handle = -1;
> +		tctx->dev = NULL;
> +	}
> +
> +	/* reset priv */
> +	priv = NULL;
> +	priv = dev_get_drvdata(salg->dev);
> +	tctx->dev = get_device(salg->dev);
> +	ret = spacc_is_mode_keysize_supported(&priv->spacc, salg->mode->id,
> +					      keylen, 1);
> +	if (ret) {
> +		/* Grab the spacc context if no one is waiting */
> +		tctx->handle = spacc_open(&priv->spacc,
> +					  CRYPTO_MODE_NULL,
> +					  salg->mode->id, -1,
> +					  0, spacc_digest_cb, tfm);
> +		if (tctx->handle < 0) {
> +			dev_err(salg->dev, "ERR: Failed to open SPAcc context\n");
> +			put_device(salg->dev);
> +			return -EIO;
> +		}
> +
> +	} else {
> +		dev_err(salg->dev, "Keylen: %d not enabled for algo: %d",
> +			keylen, salg->mode->id);
> +	}
> +
> +	rc = spacc_set_operation(&priv->spacc, tctx->handle, OP_ENCRYPT,
> +				 ICV_HASH, IP_ICV_OFFSET, 0, 0, 0);
> +	if (rc < 0) {
> +		spacc_close(&priv->spacc, tctx->handle);
> +		tctx->handle = -1;
> +		put_device(tctx->dev);
> +		return -EIO;
> +	}
> +
> +	if (salg->mode->id == CRYPTO_MODE_MAC_XCBC ||
> +	    salg->mode->id == CRYPTO_MODE_MAC_SM4_XCBC) {
> +		rc = spacc_compute_xcbc_key(&priv->spacc, salg->mode->id,
> +					    tctx->handle, tctx->ipad,
> +					    keylen, tctx->ipad);
> +		if (rc < 0) {
> +			dev_err(tctx->dev,
> +				"Failed to compute XCBC key: %d\n", rc);
> +			return -EIO;
> +		}
> +		rc = spacc_write_context(&priv->spacc, tctx->handle,
> +					 SPACC_HASH_OPERATION, tctx->ipad,
> +					 32 + keylen, NULL, 0);
> +	} else {
> +		rc = spacc_write_context(&priv->spacc, tctx->handle,
> +					 SPACC_HASH_OPERATION, tctx->ipad,
> +					 keylen, NULL, 0);
> +	}
> +
> +	memset(tctx->ipad, 0, sizeof(tctx->ipad));
> +	if (rc < 0) {
> +		dev_err(tctx->dev, "ERR: Failed to write SPAcc context\n");
> +		/* Non-fatal, we continue with the software fallback */
> +		return 0;
> +	}
> +
> +	tctx->ctx_valid = true;
> +
> +	return 0;
> +}
> +
[...]> diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
> new file mode 100644
> index 000000000000..ca9fc032d7c6
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_core.c
> @@ -0,0 +1,1292 @@
> +// SPDX-License-Identifier: GPL-2.0

> +
> +int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
> +		    int nbytes, struct pdu_ddt *ddt, int dma_direction)
> +{
> +	int i;
> +	int nents;
> +	int rc = 0;
> +	int orig_nents;
> +	struct scatterlist *sgl;
> +	struct scatterlist *sg_entry;
> +
> +	orig_nents = sg_nents(sg);
> +	if (orig_nents > 1) {
> +		sgl = sg_last(sg, orig_nents);
> +		if (sgl->length == 0)
> +			orig_nents--;
> +	}
> +
> +	nents = dma_map_sg(dev, sg, orig_nents, dma_direction);
> +	if (nents <= 0)
> +		return -ENOMEM;
> +
> +	/* require ATOMIC operations */
Why? spacc_sg_to_ddt() is only being called from spacc_hash_init_dma(), which in turn is only being called from your crypto_engine's do_one_request callback function. This is not in interrupt context. Crypto engine uses workqueues to schedule these. You don't *NEED* GFP_ATOMIC allocations here.
  > +	rc = pdu_ddt_init(dev, ddt, nents | 0x80000000);
> +	if (rc < 0) {
> +		dma_unmap_sg(dev, sg, nents, dma_direction);
dma_unmap_sg() should be called with the same number of nents as dma_map_sg() was called, not the mapped nents returned by it.

> +		return -EIO;
> +	}
> +
> +	for_each_sg(sg, sg_entry, nents, i) {
> +		pdu_ddt_add(dev, ddt, sg_dma_address(sg_entry),
> +			    sg_dma_len(sg_entry));
> +	}
> +
> +	dma_sync_sg_for_device(dev, sg, nents, dma_direction);
> +
> +	return nents;

This return value is set in your ctx->src_nents. You'll also need to correct the dma_unmap_sg() in your cleanup functions.

> +}
> +

> diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
> new file mode 100644
> index 000000000000..b8b47915f4ca
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_device.c
> @@ -0,0 +1,283 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include <linux/completion.h>
> +#include <linux/workqueue.h>
> +#include <crypto/engine.h>
> +#include "spacc_device.h"
> +
> +static void spacc_cmd_process(struct spacc_device *spacc, int x)
> +{
> +	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
> +
> +	if (!work_pending(&priv->pop_jobs))
> +		queue_work(priv->spacc_wq, &priv->pop_jobs);
> +}
> +
> +static void spacc_stat_process(struct spacc_device *spacc)
> +{
> +	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
> +
> +	if (!work_pending(&priv->pop_jobs))
> +		queue_work(priv->spacc_wq, &priv->pop_jobs);
> +}
> +
> +static int spacc_init_device(struct platform_device *pdev)
> +{
> +	void __iomem *baseaddr;
> +	struct pdu_info   info;
> +	struct spacc_priv *priv;
> +	int err = 0;
> +	int ret = 0;
> +	int oldmode;
> +	int irq_num;
> +	int irq_ret;
> +	const u64 oldtimer = SPACC_OLD_TIMER;
> +
> +	/* initialize DDT DMA pools based on this device's resources */
> +	if (pdu_mem_init(&pdev->dev)) {
> +		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
> +		return -ENOMEM;
> +	}
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		err = -ENOMEM;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	/* default to little-endian */
> +	priv->spacc.config.big_endian	 = false;
> +	priv->spacc.config.little_endian = true;
> +
> +	priv->spacc.config.oldtimer = oldtimer;
> +
> +	/* Set the SPAcc internal counter value from kernel config */
> +	priv->spacc.config.timer = (u64)CONFIG_CRYPTO_DEV_SPACC_INTERNAL_COUNTER;
> +	dev_dbg(&pdev->dev, "SPAcc internal counter set to: %llu\n",
> +		priv->spacc.config.timer);
> +
> +	baseaddr = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(baseaddr)) {
> +		dev_err(&pdev->dev, "Unable to map iomem\n");
> +		err = PTR_ERR(baseaddr);
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	pdu_get_version(baseaddr, &info);
> +
> +	ret = spacc_init(baseaddr, &priv->spacc, &info);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to initialize SPAcc device\n");
> +		err = ret;
> +		goto free_ddt_mem_pool;
> +	}
> +
> +	/* Set the priority from kernel config */
> +	priv->spacc.config.priority = CONFIG_CRYPTO_DEV_SPACC_PRIORITY;
> +	dev_dbg(&pdev->dev, "VSPACC priority set from config: %u\n",
> +		priv->spacc.config.priority);
> +
> +	/* Set the priority for this virtual SPAcc instance */
> +	spacc_set_priority(&priv->spacc, priv->spacc.config.priority);
> +
> +	/* Initialize crypto engine */
> +	priv->engine = crypto_engine_alloc_init(&pdev->dev, true);
> +	if (!priv->engine) {
> +		dev_err(&pdev->dev, "Could not allocate crypto engine\n");
> +		err = -ENOMEM;
> +		goto free_spacc_ctx;
> +	}
> +
> +	err = crypto_engine_start(priv->engine);
> +	if (err) {
> +		dev_err(&pdev->dev, "Could not start crypto engine\n");
> +		goto free_engine;
> +	}
> +
> +	priv->spacc_wq = alloc_workqueue("spacc_workqueue", WQ_UNBOUND, 0);
> +	if (!priv->spacc_wq) {
> +		err = -ENOMEM;
> +		goto stop_engine;
> +	}
> +
> +	INIT_WORK(&priv->pop_jobs, spacc_pop_jobs);
> +	spacc_irq_glbl_disable(&priv->spacc);
> +
> +	priv->spacc.dptr = &pdev->dev;
> +	platform_set_drvdata(pdev, priv);
> +
> +	irq_num = platform_get_irq(pdev, 0);
> +	if (irq_num < 0) {
> +		err = irq_num;
> +		goto free_spacc_workq;
> +	}
> +
> +	/* determine configured maximum message length */
> +	priv->max_msg_len = priv->spacc.config.max_msg_size;
> +
> +	irq_ret = devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
> +			     IRQF_SHARED, dev_name(&pdev->dev),
> +			     &pdev->dev);
> +	if (irq_ret) {
> +		dev_err(&pdev->dev, "Failed to request IRQ : %d\n", irq_ret);
> +		err = irq_ret;
> +		goto free_spacc_workq;
> +	}
> +
> +	priv->spacc.irq_cb_stat = spacc_stat_process;
> +	priv->spacc.irq_cb_cmdx = spacc_cmd_process;
> +	oldmode			= priv->spacc.op_mode;
> +	priv->spacc.op_mode     = SPACC_OP_MODE_IRQ;
> +
> +	/* Enable STAT and CMD interrupts */
> +	spacc_irq_stat_enable(&priv->spacc, 1);
> +	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> +	spacc_irq_stat_wd_disable(&priv->spacc);
> +	spacc_irq_glbl_enable(&priv->spacc);
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
> +
> +	err = spacc_autodetect(&priv->spacc);
> +	if (err < 0) {
> +		spacc_irq_glbl_disable(&priv->spacc);
> +		goto free_spacc_workq;
> +	}
> +#else
> +	err = spacc_static_config(&priv->spacc);
> +	if (err < 0) {
> +		spacc_irq_glbl_disable(&priv->spacc);
> +		goto free_spacc_workq;
> +	}
> +#endif
> +
> +	priv->spacc.op_mode = oldmode;
> +	if (priv->spacc.op_mode == SPACC_OP_MODE_IRQ) {
> +		priv->spacc.irq_cb_stat = spacc_stat_process;
> +		priv->spacc.irq_cb_cmdx = spacc_cmd_process;
> +
> +		/* Enable STAT and CMD interrupts */
> +		spacc_irq_stat_enable(&priv->spacc, 1);
> +		spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> +		spacc_irq_glbl_enable(&priv->spacc);
> +	} else {
> +		priv->spacc.irq_cb_stat = spacc_stat_process;
> +		priv->spacc.irq_cb_stat_wd = spacc_stat_process;
> +
> +		spacc_irq_stat_enable(&priv->spacc,
> +				      priv->spacc.config.ideal_stat_level);
> +
> +		/* Enable STAT and WD interrupts */
> +		spacc_irq_cmdx_disable(&priv->spacc, 0);
> +		spacc_irq_stat_wd_enable(&priv->spacc);
> +		spacc_irq_glbl_enable(&priv->spacc);
> +
> +		/* enable the wd by setting the wd_timer = 100000 */
> +		spacc_set_wd_count(&priv->spacc,
> +				   priv->spacc.config.wd_timer =
> +						priv->spacc.config.timer);
> +	}
> +
> +	/* unlock normal */
> +	if (priv->spacc.config.is_secure_port) {
> +		u32 t;
> +
> +		t = readl(baseaddr + SPACC_REG_SECURE_CTRL);
> +		t &= ~(1UL << 31);
> +		writel(t, baseaddr + SPACC_REG_SECURE_CTRL);
> +	}
> +
> +	/* unlock device by default */
> +	writel(0, baseaddr + SPACC_REG_SECURE_CTRL);
> +
> +	return err;
> +
> +free_spacc_workq:
> +	flush_workqueue(priv->spacc_wq);
> +	destroy_workqueue(priv->spacc_wq);

destroy_workqueue() calls __flush_workqueue() (through drain_workqueue()). Just use destroy_workqueue().

> +
> +stop_engine:
> +	crypto_engine_stop(priv->engine);
> +
> +free_engine:
> +	crypto_engine_exit(priv->engine);

crypto_engine_exit() calls crypto_engine_stop(). Just call crypto_engine_exit()

> +
> +free_spacc_ctx:
> +	spacc_fini(&priv->spacc);
> +
> +free_ddt_mem_pool:
> +	pdu_mem_deinit(&pdev->dev);
> +
> +	return err;
> +}
> +
> +static void spacc_unregister_algs(void)
> +{
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
> +	spacc_unregister_hash_algs();
> +#endif
> +}
> +
> +static int spacc_crypto_probe(struct platform_device *pdev)
> +{
> +	int rc = 0;
> +
> +	rc = spacc_init_device(pdev);
> +	if (rc < 0)
> +		goto err;
> +
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
> +	rc = spacc_probe_hashes(pdev);
> +	if (rc < 0)
> +		goto err;
> +#endif
> +
> +	return 0;
> +err:
> +	spacc_unregister_algs();
> +
> +	return rc;
> +}
> +
> +static void spacc_crypto_remove(struct platform_device *pdev)
> +{
> +	struct spacc_priv *priv = platform_get_drvdata(pdev);
> +
> +	if (priv->engine) {
> +		crypto_engine_stop(priv->engine);
> +		crypto_engine_exit(priv->engine);

Again, same.

> +	}
> +
> +	if (priv->spacc_wq) {
> +		flush_workqueue(priv->spacc_wq);
> +		destroy_workqueue(priv->spacc_wq);

Again, same.

> +	}
> +
> +	spacc_unregister_algs();
> +	spacc_remove(pdev);
> +}
> +
> +static const struct of_device_id snps_spacc_id[] = {
> +	{.compatible = "snps,nsimosci-hs-spacc" },
> +	{ /* sentinel */        }
> +};
> +
> +MODULE_DEVICE_TABLE(of, snps_spacc_id);
> +
> +static struct platform_driver spacc_driver = {
> +	.probe  = spacc_crypto_probe,
> +	.remove = spacc_crypto_remove,
> +	.driver = {
> +		.name  = "spacc",
> +		.of_match_table = snps_spacc_id,
> +	},
> +};
> +
> +module_platform_driver(spacc_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Synopsys, Inc.");
> +MODULE_DESCRIPTION("SPAcc Crypto Accelerator Driver");

-- 
Regards
T Pratham <t-pratham@ti.com>
