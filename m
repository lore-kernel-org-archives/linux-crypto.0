Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B0C1DA3D;
	Mon, 30 Sep 2024 13:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727703286; cv=none; b=exi6N15CEQkxyIVOwgfSjcb30jhooX2x+PEqW3xpLM2NxkQPmmIGh6boU23FAbMWpnJiKhT8hcohf03KTRNfYUWLo0P6bFgsrbj40YE6B40Fp0CNjMPZpCN3TYLhL+Orpd4bl6ij96k0AIlxKc7IP2GyN9B8mPoZwgXi5toqJW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727703286; c=relaxed/simple;
	bh=VzrKIg1Ki7EopKHoTRFn20chqJoSZWgF2LfGVWnMCTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SORBXkWQimx2l5v0v1LI78rpokoBTNgZ2vr8nEllEY1P7llXKcrEgqPAcVUMJt8b4V5x60K09CkgFNujacaaadngbERCJFAAQYYuTsMsszraJ7MlJtucy2cyATpmSgwrSDuucCZ9Wdw0Anpf4jhw1DMeWq/UlXX3elp94i0Ft+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCD0XQap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCD0XQap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10EAC4CEC7;
	Mon, 30 Sep 2024 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727703286;
	bh=VzrKIg1Ki7EopKHoTRFn20chqJoSZWgF2LfGVWnMCTo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eCD0XQap/4TtomxVJ7TK2DvcbASEYlCoRwZtxRpRt+Td7vRdUw2wIZn3cobLOGoEg
	 qyXoqVP9GrkBqQvG+n3aP19WXBigjRNzpCxDQItofCs4woPTUgPEhjnFZo5NE5goTT
	 I+/VvUH8ePBMpJ9Rhpll+OPeJ11aT9Cgu9G0iY35lKXCJmFfDIPiqFZNnTckbNUfWU
	 xJLCYnJ7vd5pqqjgDgtjGWdjXHosSQXLTUUeKhsB4Zepx120t49tGvbXsIwizKVj/W
	 dIftxy6Y2g7QUAxEp3ME+NBbPEMPRNM5uBnhHF6ZhorELgXzUwS2uRBPaXDw4lrg/X
	 QiVC5bLpvsLxQ==
Message-ID: <96ee9d92-4344-44de-a398-68edcf29c546@kernel.org>
Date: Mon, 30 Sep 2024 15:34:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/7] Add SPAcc Skcipher support
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, robh@kernel.org
Cc: Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com, Shweta Raikar <shwetar@vayavyalabs.com>
References: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
 <20240930093054.215809-2-pavitrakumarm@vayavyalabs.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <20240930093054.215809-2-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/09/2024 11:30, Pavitrakumar M wrote:
> Add SPAcc Skcipher support to Synopsys Protocol Accelerator(SPAcc) IP,
> which is a crypto accelerator engine.
> SPAcc supports ciphers, hashes and AEAD algorithms such as
> AES in different modes, SHA variants, AES-GCM, Chacha-poly1305 etc.
> 

...

> +
> +	/* reset registers */
> +	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
> +	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
> +	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
> +
> +	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
> +
> +	pdu_ddt_free(&ddt);
> +	dma_free_coherent(get_ddt_device(), 256, virt, dma);
> +
> +	return CRYPTO_OK;
> +}
> +
> +/* free up the memory */
> +void spacc_fini(struct spacc_device *spacc)
> +{
> +	vfree(spacc->ctx);
> +	vfree(spacc->job);
> +}
> +
> +int spacc_init(void __iomem *baseaddr, struct spacc_device *spacc,
> +	       struct pdu_info *info)
> +{
> +	unsigned long id;
> +	char version_string[3][16]  = { "SPACC", "SPACC-PDU" };
> +	char idx_string[2][16]      = { "(Normal Port)", "(Secure Port)" };
> +	char dma_type_string[4][16] = { "Unknown", "Scattergather", "Linear",
> +					"Unknown" };
> +
> +	if (!baseaddr) {
> +		pr_debug("ERR: baseaddr is NULL\n");

You must use dev_ instead.

> +		return -1;

What is -1? No, use errno numbers.

> +	}
> +	if (!spacc) {
> +		pr_debug("ERR: spacc is NULL\n");
> +		return -1;

Same problems. How is this even possible? Don't add dead code.

> +	}
> +
> +	memset(spacc, 0, sizeof(*spacc));
> +	spin_lock_init(&spacc->lock);
> +	spin_lock_init(&spacc->ctx_lock);
> +
> +	/* assign the baseaddr*/

The missing space before */ is just sloppy. Please write good, readable
code so review will be able to focus on important things not such nitpicks.

> +	spacc->regmap = baseaddr;
> +
> +	/* version info*/
> +	spacc->config.version     = info->spacc_version.version;
> +	spacc->config.pdu_version = (info->pdu_config.major << 4) |
> +				    info->pdu_config.minor;
> +	spacc->config.project     = info->spacc_version.project;
> +	spacc->config.is_pdu      = info->spacc_version.is_pdu;
> +	spacc->config.is_qos      = info->spacc_version.qos;
> +
> +	/* misc*/
> +	spacc->config.is_partial        = info->spacc_version.partial;
> +	spacc->config.num_ctx           = info->spacc_config.num_ctx;
> +	spacc->config.ciph_page_size    = 1U <<
> +					  info->spacc_config.ciph_ctx_page_size;
> +
> +	spacc->config.hash_page_size    = 1U <<
> +					  info->spacc_config.hash_ctx_page_size;
> +
> +	spacc->config.dma_type          = info->spacc_config.dma_type;
> +	spacc->config.idx               = info->spacc_version.vspacc_id;
> +	spacc->config.cmd0_fifo_depth   = info->spacc_config.cmd0_fifo_depth;
> +	spacc->config.cmd1_fifo_depth   = info->spacc_config.cmd1_fifo_depth;
> +	spacc->config.cmd2_fifo_depth   = info->spacc_config.cmd2_fifo_depth;
> +	spacc->config.stat_fifo_depth   = info->spacc_config.stat_fifo_depth;
> +	spacc->config.fifo_cnt          = 1;
> +	spacc->config.is_ivimport       = info->spacc_version.ivimport;
> +
> +	/* ctrl register map*/
> +	if (spacc->config.version <= 0x4E)
> +		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_0];
> +	else if (spacc->config.version <= 0x60)
> +		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_1];
> +	else
> +		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_2];
> +
> +	spacc->job_next_swid   = 0;
> +	spacc->wdcnt           = 0;
> +	spacc->config.wd_timer = SPACC_WD_TIMER_INIT;
> +
> +	/* version 4.10 uses IRQ,

Please use Linux coding style comments for given subsystem. See Coding
style.

> +	 * above uses WD and we don't support below 4.00
> +	 */
> +	if (spacc->config.version < 0x40) {
> +		pr_debug("ERR: Unsupported SPAcc version\n");
> +		return -EIO;
> +	} else if (spacc->config.version < 0x4B) {
> +		spacc->op_mode = SPACC_OP_MODE_IRQ;
> +	} else {
> +		spacc->op_mode = SPACC_OP_MODE_WD;
> +	}
> +
> +	/* set threshold and enable irq
> +	 * on 4.11 and newer cores we can derive this
> +	 * from the HW reported depths.
> +	 */
> +	if (spacc->config.stat_fifo_depth == 1)
> +		spacc->config.ideal_stat_level = 1;
> +	else if (spacc->config.stat_fifo_depth <= 4)
> +		spacc->config.ideal_stat_level =
> +					spacc->config.stat_fifo_depth - 1;
> +	else if (spacc->config.stat_fifo_depth <= 8)
> +		spacc->config.ideal_stat_level =
> +					spacc->config.stat_fifo_depth - 2;
> +	else
> +		spacc->config.ideal_stat_level =
> +					spacc->config.stat_fifo_depth - 4;
> +
> +	/* determine max PROClen value */
> +	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_PROC_LEN);
> +	spacc->config.max_msg_size = readl(spacc->regmap + SPACC_REG_PROC_LEN);
> +
> +	/* read config info*/
> +	if (spacc->config.is_pdu) {
> +		pr_debug("PDU:\n");
> +		pr_debug("   MAJOR      : %u\n", info->pdu_config.major);
> +		pr_debug("   MINOR      : %u\n", info->pdu_config.minor);


Why?

> +	}
> +
> +	id = readl(spacc->regmap + SPACC_REG_ID);
> +	pr_debug("SPACC ID: (%08lx)\n", (unsigned long)id);
> +	pr_debug("   MAJOR      : %x\n", info->spacc_version.major);
> +	pr_debug("   MINOR      : %x\n", info->spacc_version.minor);
> +	pr_debug("   QOS        : %x\n", info->spacc_version.qos);
> +	pr_debug("   IVIMPORT   : %x\n", spacc->config.is_ivimport);

What are you going to debug here?

> +
> +	if (spacc->config.version >= 0x48)
> +		pr_debug("   TYPE       : %lx (%s)\n", SPACC_ID_TYPE(id),
> +			version_string[SPACC_ID_TYPE(id) & 3]);
> +
> +	pr_debug("   AUX        : %x\n", info->spacc_version.qos);
> +	pr_debug("   IDX        : %lx %s\n", SPACC_ID_VIDX(id),
> +			spacc->config.is_secure ?
> +			(idx_string[spacc->config.is_secure_port & 1]) : "");
> +	pr_debug("   PARTIAL    : %x\n", info->spacc_version.partial);
> +	pr_debug("   PROJECT    : %x\n", info->spacc_version.project);
> +
> +	if (spacc->config.version >= 0x48)
> +		id = readl(spacc->regmap + SPACC_REG_CONFIG);
> +	else
> +		id = 0xFFFFFFFF;
> +
> +	pr_debug("SPACC CFG: (%08lx)\n", id);
> +	pr_debug("   CTX CNT    : %u\n", info->spacc_config.num_ctx);
> +	pr_debug("   VSPACC CNT : %u\n", info->spacc_config.num_vspacc);
> +	pr_debug("   CIPH SZ    : %-3lu bytes\n", 1UL <<
> +				  info->spacc_config.ciph_ctx_page_size);
> +	pr_debug("   HASH SZ    : %-3lu bytes\n", 1UL <<
> +				  info->spacc_config.hash_ctx_page_size);
> +	pr_debug("   DMA TYPE   : %u (%s)\n", info->spacc_config.dma_type,
> +			dma_type_string[info->spacc_config.dma_type & 3]);
> +	pr_debug("   MAX PROCLEN: %lu bytes\n", (unsigned long)
> +				  spacc->config.max_msg_size);
> +	pr_debug("   FIFO CONFIG :\n");
> +	pr_debug("      CMD0 DEPTH: %d\n", spacc->config.cmd0_fifo_depth);

You could not flood dmesg with more debugging, could you?


> +
> +	if (spacc->config.is_qos) {
> +		pr_debug("      CMD1 DEPTH: %d\n",
> +				spacc->config.cmd1_fifo_depth);
> +		pr_debug("      CMD2 DEPTH: %d\n",
> +				spacc->config.cmd2_fifo_depth);
> +	}
> +	pr_debug("      STAT DEPTH: %d\n", spacc->config.stat_fifo_depth);
> +
> +	if (spacc->config.dma_type == SPACC_DMA_DDT) {
> +		writel(0x1234567F, baseaddr + SPACC_REG_DST_PTR);
> +		writel(0xDEADBEEF, baseaddr + SPACC_REG_SRC_PTR);
> +
> +		if (((readl(baseaddr + SPACC_REG_DST_PTR)) !=
> +					(0x1234567F & SPACC_DST_PTR_PTR)) ||
> +		    ((readl(baseaddr + SPACC_REG_SRC_PTR)) !=
> +		     (0xDEADBEEF & SPACC_SRC_PTR_PTR))) {
> +			pr_debug("ERR: Failed to set pointers\n");
> +			goto ERR;
> +		}
> +	}
> +
> +	/* zero the IRQ CTRL/EN register
> +	 * (to make sure we're in a sane state)
> +	 */
> +	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
> +	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
> +	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
> +
> +	/* init cache*/
> +	memset(&spacc->cache, 0, sizeof(spacc->cache));
> +	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_ICV_OFFSET);
> +	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_POST_AAD_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_IV_OFFSET);
> +	writel(0, spacc->regmap + SPACC_REG_OFFSET);
> +	writel(0, spacc->regmap + SPACC_REG_AUX_INFO);
> +
> +	spacc->ctx = vmalloc(sizeof(struct spacc_ctx) * spacc->config.num_ctx);
> +	if (!spacc->ctx)
> +		goto ERR;
> +
> +	spacc->job = vmalloc(sizeof(struct spacc_job) * SPACC_MAX_JOBS);
> +	if (!spacc->job)
> +		goto ERR;
> +
> +	/* initialize job_idx and lookup table */
> +	spacc_job_init_all(spacc);
> +
> +	/* initialize contexts */
> +	spacc_ctx_init_all(spacc);
> +
> +	/* autodetect and set string size setting*/
> +	if (spacc->config.version == 0x61 || spacc->config.version >= 0x65)
> +		spacc_xof_stringsize_autodetect(spacc);
> +
> +	return CRYPTO_OK;

??? Please do not redefine numbers.

Missing blank line

> +ERR:


> +	spacc_fini(spacc);
> +	pr_debug("ERR: Crypto Failed\n");

Drop



> +
> +	return -EIO;
> +}
> +
> +/* callback function to initialize tasklet running */
> +void spacc_pop_jobs(unsigned long data)
> +{
> +	int num = 0;
> +	struct spacc_priv *priv =  (struct spacc_priv *)data;
> +	struct spacc_device *spacc = &priv->spacc;
> +
> +	/* decrement the WD CNT here since
> +	 * now we're actually going to respond
> +	 * to the IRQ completely
> +	 */
> +	if (spacc->wdcnt)
> +		--(spacc->wdcnt);
> +
> +	spacc_pop_packets(spacc, &num);
> +}
> +
> +int spacc_remove(struct platform_device *pdev)
> +{
> +	struct spacc_device *spacc;
> +	struct spacc_priv *priv = platform_get_drvdata(pdev);
> +
> +	/* free test vector memory*/
> +	spacc = &priv->spacc;
> +	spacc_fini(spacc);
> +
> +	tasklet_kill(&priv->pop_jobs);
> +
> +	/* devm functions do proper cleanup */
> +	pdu_mem_deinit(&pdev->dev);
> +	dev_dbg(&pdev->dev, "removed!\n");
> +
> +	return 0;
> +}
> +
> +int spacc_set_key_exp(struct spacc_device *spacc, int job_idx)
> +{
> +	struct spacc_ctx *ctx = NULL;
> +	struct spacc_job *job = NULL;
> +
> +	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS) {
> +		pr_debug("ERR: Invalid Job id specified (out of range)\n");
> +		return -ENXIO;
> +	}
> +
> +	job = &spacc->job[job_idx];
> +	ctx = context_lookup_by_job(spacc, job_idx);
> +
> +	if (!ctx) {
> +		pr_debug("ERR: Failed to find ctx id\n");
> +		return -EIO;
> +	}
> +
> +	job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
> +
> +	return CRYPTO_OK;

This code has terrible quality and does not fit basic Linux coding
style. Why v9 has trivial issues like this? I don't understand.

Please cleanup your code thoroughly from all such weird
all-platform-Windows-downstream junk.

This code is just not ready for submission.

> +}


> +
> +int spacc_compute_xcbc_key(struct spacc_device *spacc, int mode_id,
> +			   int job_idx, const unsigned char *key,
> +			   int keylen, unsigned char *xcbc_out)
> +{
> +	unsigned char *buf;
> +	dma_addr_t bufphys;
> +	struct pdu_ddt ddt;
> +	unsigned char iv[16];
> +	int err, i, handle, usecbc, ctx_idx;
> +
> +	if (job_idx >= 0 && job_idx < SPACC_MAX_JOBS)
> +		ctx_idx = spacc->job[job_idx].ctx_idx;
> +	else
> +		ctx_idx = -1;
> +
> +	if (mode_id == CRYPTO_MODE_MAC_XCBC) {
> +		/* figure out if we can schedule the key  */
> +		if (spacc_isenabled(spacc, CRYPTO_MODE_AES_ECB, 16))
> +			usecbc = 0;
> +		else if (spacc_isenabled(spacc, CRYPTO_MODE_AES_CBC, 16))
> +			usecbc = 1;
> +		else
> +			return -1;
> +	} else if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
> +		/* figure out if we can schedule the key  */
> +		if (spacc_isenabled(spacc, CRYPTO_MODE_SM4_ECB, 16))
> +			usecbc = 0;
> +		else if (spacc_isenabled(spacc, CRYPTO_MODE_SM4_CBC, 16))
> +			usecbc = 1;
> +		else
> +			return -1;
> +	} else {
> +		return -1;

What is -1?

> +	}
> +
> +	memset(iv, 0, sizeof(iv));
> +	memset(&ddt, 0, sizeof(ddt));
> +
> +	buf = dma_alloc_coherent(get_ddt_device(), 64, &bufphys, GFP_KERNEL);
> +	if (!buf)
> +		return -EINVAL;

and here -EINVAL? So what was the meaning of -1?

This is terrible code.



> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_device.c
> @@ -0,0 +1,296 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include "spacc_device.h"
> +
> +static struct platform_device *spacc_pdev;

This is too much. NAK.

Code has terrible quality but what is worse: you ignored several
comments, which means code does not improve. You send the same code over
and over.

Sending same code with same junk is not acceptable. You waste reviewer's
time.


Best regards,
Krzysztof

