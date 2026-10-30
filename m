Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793383226;
	b=3V44GXRYsQ0fCVG+omzSI9Fb/1iGWGSQU8WPXQcF+xlzU2gUFKeZATUtN18nw6XprzZL
	 j53NPFBPpns8we8jAk7LHJXSMp4I79ZQ/TqyUWyA5vGAESusr6GnbNqWNkX31KEqTAJ8Z
	 fGnCZxzhWH154QOy9mqKApXNuVJPxXlClDGJLB0ODRl9b/YhLpG+UqRVAaelblmQaVY4f
	 CWCJ4ui5pyHihmzmm8I5WFKXAOQ/vlW/VWnMnoY4Q1GdGyB6lY1i8LX7sGn+pmkWOQFZZ
	 moU9Q8vaGMXMxM4D4FqLYNWHOPpdFZDNCCCeaiWJfdIXTk0qh/U+DpdVvSzw9cUy1tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793383226;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XJ1UiHkcIvflSbSGVPK6Hu2S34JKM/E9F535+MmeXYM=;
	b=Fo0AUR1vhu0rVG2ymYGZJXyPTBT6oN73BhnR3EdGKqFhFwPTGYPshP2l+pPAnY4ryOXW
	 tBT53Qkj+BN5TGxjB/dc8ziu7OUf0kbb9jl/0gnpv4w1ZiUuXFiD2T8v+Ooz3Vh/xUhpv
	 bm7Z5Ze+f9j0TgvbrknxBcYLCypLFjyav1CWDRBkaT2fbIn3zQ/0RAE66GoE585Gt+6MN
	 NxaQUDpEZxUGvPL0AUS+QIBYSLII2Emn5EnEzodGDzHa99h6lkV1JBjXppC9owYfp9QZp
	 nnWaA1g5XL+aJTJJuuX6u6PHXRQhgA/cIXLLg+Mzrtt+lXcFBqt/Huml5MS/JhV/Gjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="mG8Pm/6O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DAC60A2638;
	Fri, 30 Oct 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mG8Pm/6O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DB11F00A17;
	Fri, 30 Oct 2026 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793383225;
	bh=XJ1UiHkcIvflSbSGVPK6Hu2S34JKM/E9F535+MmeXYM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mG8Pm/6OLZz5agNpCL4G97i50lbAp4/1dfTvkOaNFv4ZbdZAX0AyRfS2Ja3mWaatO
	 4shAdpr271e80F6hEFa2Mh/ZJUBxm6gW+Hh6x4xg0ar73Xaqc7ALb+0oGbU/u1aVET
	 lK1DjQqfEhyvcfrbHQfelHAVPex9NFX42GHeDs8jfmgfAnW5X+FLLd9tslxLOMKS5T
	 gr1Pq14hlELaCEHvWMyF938z54CC3WNnTjBlv355fzvmpTnaEzFcPBMQGExIM4sCWt
	 lUdVU88y9F0Wba1orMjnCjFtB9QZiMWv/zuvK9prfN+Yxn4WaksURluvxe4GsxAeJ9
	 qyjypFsuJx0Hg==
Message-ID: <sashiko-outbox-191385@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v27 2/4] crypto: spacc - Add SPAcc ahash support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pavitrakumar Managutte" <pavitrakumarm@vayavyalabs.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk@kernel.org, conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com, nazim.khan@vayavyalabs.com
In-Reply-To: <20261030172456.274744-3-pavitrakumarm@vayavyalabs.com>
References: <20261030172456.274744-1-pavitrakumarm@vayavyalabs.com>
 <20261030172456.274744-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:00:24 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] crypto: spacc: statesize overflow and broken BLOCK_ONLY in spacc_r=
egister_hash()
- [High] crypto: spacc: teardown race and use-after-free in spacc_crypto_re=
move()
- [High] crypto: spacc - unsplit >64KB or boundary-crossing SG entries in s=
pacc_sg_to_ddt()
- [High] crypto: spacc - hardirq livelock in spacc_process_irq() in IRQ mode
- [Medium] crypto: spacc: sleeping lock in spacc_hash_setkey() and persiste=
nt hw handle
- [Medium] crypto: spacc - unlocked IRQ state and register setup in spacc_i=
nit_device()
--

commit 39aecabd458071b66bf2f10317714fe1849c6141
Author: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

crypto: spacc - Add SPAcc ahash support

This commit adds core SPAcc driver infrastructure and ahash algorithm
support for MD5, SHA-1, SHA-2, SHA-3, HMAC, and SM4 CMAC/XCBC.

> diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dwc-=
spacc/spacc_ahash.c
> new file mode 100644
> index 0000000000000..4437abd02176a
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c

[ ... ]

> +static int spacc_hash_commit_key(struct crypto_ahash *tfm,
> +				 struct spacc_priv *priv,
> +				 const u8 *key, unsigned int keylen,
> +				 const u8 *keybuf, unsigned int klen)
> +{
> +	struct spacc_crypto_ctx *tctx =3D crypto_ahash_ctx(tfm);
> +	struct crypto_ahash *fb;
> +	int ret;
> +
> +	guard(mutex)(&tctx->lock);

[ ... ]

> +static int spacc_hash_try_hw(struct spacc_crypto_ctx *tctx,
> +			     struct spacc_priv *priv,
> +			     const struct spacc_alg *salg,
> +			     struct crypto_ahash *reqtfm,
> +			     struct ahash_request *req)
> +{
> +	int rc;
> +
> +	guard(mutex)(&tctx->lock);
> +
> +	if (tctx->handle < 0 || !tctx->ctx_valid) {
> +		/*
> +		 * spacc_open() acquires ctx_sem which may sleep;
> +		 * do_one_request runs in the crypto_engine workqueue
> +		 * which is a sleepable context, so this is safe.
> +		 */
> +		tctx->handle =3D spacc_open(&priv->spacc,
> +					  CRYPTO_MODE_NULL, salg->mode->id,
> +					  -1, 0, spacc_digest_cb, reqtfm);

[ ... ]

> +		memzero_explicit(tctx->ipad, sizeof(tctx->ipad));
> +		tctx->ctx_valid =3D true;
> +	}

[Severity: Medium]
As reported by Herbert Xu on v12 [1], crypto_ahash_setkey() should not
sleep, and hardware handles can be allocated and released per request in
spacc_hash_do_one_request().

In spacc_hash_setkey() -> spacc_hash_commit_key(), acquiring tctx->lock
still sleeps if crypto_ahash_setkey() is called from atomic context.

Additionally, spacc_hash_try_hw() opens a persistent tctx->handle on the
transform context, zeroes tctx->ipad, and clones a second job slot
(ctx->acb.new_handle) via spacc_hash_init_dma() -> spacc_ctx_clone_handle().
When the request completes, spacc_digest_cb() only closes cb->new_handle,
leaving tctx->handle and its scarce hardware context slot pinned across idle
transforms until spacc_hash_exit_tfm() or a subsequent setkey.

Could tctx->ipad be retained across requests and the hardware handle opened
and closed per request inside spacc_hash_do_one_request() / spacc_digest_cb=
()
so that setkey does not need a sleeping lock or persistent context?

[ ... ]

> +static const struct ahash_engine_alg spacc_hash_template =3D {
> +	.base =3D {
> +		.init		=3D spacc_hash_init,
> +		.update		=3D spacc_hash_update,
> +		.final		=3D spacc_hash_final,
> +		.finup		=3D spacc_hash_finup,
> +		.digest		=3D spacc_hash_digest,
> +		.setkey		=3D spacc_hash_setkey,
> +		.export		=3D spacc_hash_export,
> +		.import		=3D spacc_hash_import,
> +		.init_tfm	=3D spacc_hash_init_tfm,
> +		.exit_tfm	=3D spacc_hash_exit_tfm,
> +
> +		.halg.base =3D {
> +			.cra_priority	=3D 300,
> +			.cra_module	=3D THIS_MODULE,
> +			.cra_ctxsize	=3D sizeof(struct spacc_crypto_ctx),
> +			.cra_reqsize	=3D sizeof(struct spacc_crypto_reqctx),
> +			.cra_destroy	=3D spacc_hash_alg_destroy,
> +			.cra_flags	=3D CRYPTO_ALG_TYPE_AHASH		|
> +					  CRYPTO_ALG_ASYNC		|
> +					  CRYPTO_AHASH_ALG_BLOCK_ONLY
> +		},
> +	},
> +	.op =3D {
> +		.do_one_request =3D spacc_hash_do_one_request,
> +	},
> +};

[ ... ]

> +static int spacc_register_hash(struct spacc_alg *salg)
> +{
> +	int rc =3D 0;
> +	struct spacc_priv *priv =3D dev_get_drvdata(salg->dev);
> +
> +	salg->calg =3D &salg->alg.hash.base.halg.base;
> +	salg->alg.hash =3D spacc_hash_template;
> +
> +	/* Unkeyed digests must not advertise a setkey. */
> +	if (!spacc_mode_is_keyed(salg->mode->id))
> +		salg->alg.hash.base.setkey =3D NULL;
> +
> +	rc =3D spacc_init_calg(salg->calg, salg->mode);
> +	if (rc)
> +		return rc;
> +
> +	salg->alg.hash.base.halg.digestsize =3D salg->mode->hashlen;
> +	salg->alg.hash.base.halg.statesize =3D HASH_MAX_STATESIZE;
> +
> +	rc =3D crypto_engine_register_ahash(&salg->alg.hash);

[Severity: High]
As reported by Sashiko on v26 [2], does setting CRYPTO_AHASH_ALG_BLOCK_ONLY
on spacc_hash_template combined with halg.statesize =3D HASH_MAX_STATESIZE =
in
spacc_register_hash() break state export/import and virtual-address request=
s?

In spacc_ahash.c, spacc_hash_init(), spacc_hash_update(), spacc_hash_final(=
),
spacc_hash_finup(), spacc_hash_export(), and spacc_hash_import() delegate
full-state operations to the software fallback (fbreq) rather than
implementing block-only core state operations (for instance,
spacc_hash_update() delegates to crypto_ahash_update(fbreq) and returns 0
rather than returning the leftover partial-block byte count expected by
CRYPTO_AHASH_ALG_BLOCK_ONLY).

When spacc_register_hash() calls crypto_engine_register_ahash() ->
crypto_register_ahash() -> ahash_prepare_alg() with CRYPTO_AHASH_ALG_BLOCK_=
ONLY
set, ahash_prepare_alg() adds cra_blocksize + 1 to alg->halg.statesize:

    crypto_ahash_statesize(tfm) =3D HASH_MAX_STATESIZE + cra_blocksize + 1

This exceeds HASH_MAX_STATESIZE for every registered SPAcc algorithm, which
causes:

1. ahash_do_req_chain() to reject all virtual-address requests
   (CRYPTO_AHASH_REQ_VIRT, including testmgr virtual-address tests and
   crypto/hmac.c wrapping unkeyed SPAcc hashes) with -ENOSYS because
   crypto_ahash_statesize(tfm) > HASH_MAX_STATESIZE.

2. crypto_ahash_export() to write cra_blocksize + 1 bytes at
   out + HASH_MAX_STATESIZE after spacc_hash_export() copies
   HASH_MAX_STATESIZE bytes, overflowing any HASH_MAX_STATESIZE-sized export
   buffer.

Should CRYPTO_AHASH_ALG_BLOCK_ONLY be dropped from spacc_hash_template since
incremental hashing is handled entirely by the software fallback?

> diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-s=
pacc/spacc_core.c
> new file mode 100644
> index 0000000000000..d26b5e30777e9
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_core.c

[ ... ]

> +int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
> +		    int nbytes, struct pdu_ddt *ddt, int dma_direction)
> +{
> +	int i;
> +	int nents;
> +	int rc =3D 0;
> +	int orig_nents;
> +	struct scatterlist *sg_entry;
> +
> +	/* Count the SG entries needed to cover the requested length. */
> +	orig_nents =3D sg_nents_for_len(sg, nbytes);
> +	if (orig_nents <=3D 0)
> +		return orig_nents;
> +
> +	nents =3D dma_map_sg(dev, sg, orig_nents, dma_direction);
> +	if (nents <=3D 0)
> +		return -ENOMEM;
> +
> +	rc =3D pdu_ddt_init(dev, ddt, nents | 0x80000000);
> +	if (rc < 0) {
> +		dma_unmap_sg(dev, sg, orig_nents, dma_direction);
> +		return -EIO;
> +	}
> +
> +	/* Populate the descriptor table with the DMA-mapped SG entries. */
> +	for_each_sg(sg, sg_entry, nents, i) {
> +		pdu_ddt_add(dev, ddt, sg_dma_address(sg_entry),
> +			    sg_dma_len(sg_entry));
> +	}
> +
> +	return orig_nents;
> +}

[Severity: High]
What happens in spacc_sg_to_ddt() when an input scatterlist entry is larger
than 64KB (SPACC_DMA_BOUNDARY) or straddles a 64KB DMA address boundary?

In spacc_init_device(), the driver notes that each DDT fragment must be
<=3D 64KB and must not straddle a 64KB boundary, and sets priv->max_msg_len=
 to
priv->spacc.config.max_msg_size (up to 512KB) while relying on
dma_set_max_seg_size() and dma_set_seg_boundary().

However, dma_map_sg() maps entries in-place into the caller-supplied sg arr=
ay
of orig_nents elements; while those DMA parameters prevent an IOMMU from
merging adjacent SG entries across a 64KB boundary, dma_map_sg() cannot spl=
it
a single scatterlist entry that is already > 64KB (such as a high-order fol=
io
or kmalloc buffer) or that crosses a 64KB boundary on a dma-direct system.

Since spacc_sg_to_ddt() passes each mapped sg_entry directly to
pdu_ddt_add(), won't such requests violate the hardware's 64KB DDT fragment
limit and trigger SPACC_MEMERR or DMA-API debug warnings?

> diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc=
-spacc/spacc_device.c
> new file mode 100644
> index 0000000000000..4620281d3e1a9
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_device.c

[ ... ]

> +	irq_ret =3D devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
> +			     IRQF_SHARED, dev_name(&pdev->dev),
> +			     &pdev->dev);
> +	if (irq_ret) {
> +		dev_err(&pdev->dev, "Failed to request IRQ : %d\n", irq_ret);
> +		err =3D irq_ret;
> +		goto free_spacc_workq;
> +	}
> +
> +	priv->spacc.irq_cb_stat	=3D spacc_stat_process;
> +	priv->spacc.irq_cb_cmdx	=3D spacc_cmd_process;
> +	oldmode			=3D priv->spacc.op_mode;
> +	priv->spacc.op_mode	=3D SPACC_OP_MODE_IRQ;
> +
> +	/* Enable STAT and CMD interrupts */
> +	spacc_irq_stat_enable(&priv->spacc, 1);
> +	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> +	spacc_irq_stat_wd_disable(&priv->spacc);
> +	spacc_irq_glbl_enable(&priv->spacc);

[Severity: Medium]
As reported by Sashiko on v26 [2], in spacc_init_device(), after
devm_request_irq() registers spacc_irq_handler() with IRQF_SHARED, can a
shared interrupt (or an immediate CMD0 interrupt once SPACC_IRQ_EN_CMD(0) is
enabled) race with this unlocked initialization block?

spacc_process_irq() runs under priv->spacc.lock, reads spacc->op_mode and
spacc->irq_cb_*, and performs read-modify-write updates on SPACC_REG_IRQ_CT=
RL
and SPACC_REG_IRQ_EN, whereas spacc_init_device() updates irq_cb_stat,
irq_cb_cmdx, op_mode, SPACC_REG_IRQ_CTRL, and SPACC_REG_IRQ_EN here without
holding priv->spacc.lock (unlike the second IRQ configuration block further
down in spacc_init_device()).

[ ... ]

> +static void spacc_crypto_remove(struct platform_device *pdev)
> +{
> +	struct spacc_priv *priv =3D platform_get_drvdata(pdev);
> +	unsigned long flags;
> +
> +	/*
> +	 * Set before anything else: sysfs unbind (unlike rmmod) has no
> +	 * built-in wait for existing tfms to be freed, so a request can
> +	 * reach spacc_hash_digest() at any point during this function.
> +	 * This flag, checked under the same lock there, blocks any new
> +	 * submission attempt from this point on.
> +	 */
> +	spin_lock_irqsave(&priv->spacc.lock, flags);
> +	priv->removing =3D true;
> +	spin_unlock_irqrestore(&priv->spacc.lock, flags);
> +
> +	/* Stop the crypto API from handing out any new tfms. */
> +	spacc_unregister_algs(priv);
> +
> +	wait_event(priv->drain_wq, !atomic_read(&priv->dma_ref_cnt));
> +
> +	if (priv->engine)
> +		crypto_engine_exit(priv->engine);
> +
> +	/* Nothing can dispatch new work past this point. */
> +	spin_lock_irqsave(&priv->spacc.lock, flags);
> +	spacc_irq_glbl_disable(&priv->spacc);
> +	spin_unlock_irqrestore(&priv->spacc.lock, flags);
> +
> +	devm_free_irq(&pdev->dev, priv->irq, &pdev->dev);
> +
> +	if (priv->spacc_wq)
> +		destroy_workqueue(priv->spacc_wq);
> +
> +	/* No job can still reference this pool past the drain above. */
> +	dma_pool_destroy(priv->hash_pool);
> +	priv->hash_pool =3D NULL;
> +
> +	spacc_remove(pdev);
> +	platform_set_drvdata(pdev, NULL);
> +}

[Severity: High]
As reported by Sashiko on v26 [2], can spacc_crypto_remove() race with
in-flight requests and surviving transforms during sysfs unbind, leading to=
 a
use-after-free of priv, priv->engine, spacc->job, and spacc->ctx?

First, in spacc_hash_digest(), priv->removing is checked under
priv->spacc.lock, and the lock is dropped before calling
crypto_transfer_hash_request_to_engine(priv->engine, req):

	spin_lock_irqsave(&priv->spacc.lock, flags);
	removing =3D priv->removing;
	spin_unlock_irqrestore(&priv->spacc.lock, flags);

	if (removing)
		return -ENODEV;

	return crypto_transfer_hash_request_to_engine(priv->engine, req);

Meanwhile, priv->dma_ref_cnt is not incremented until the crypto_engine
worker runs spacc_hash_do_one_request() and finishes spacc_hash_try_hw().
Because spacc_crypto_remove() waits on drain_wq before calling
crypto_engine_exit(priv->engine), any request that has passed the
priv->removing check in spacc_hash_digest(), is queued in priv->engine, or =
is
inside spacc_hash_try_hw() has not incremented dma_ref_cnt yet, allowing
wait_event(priv->drain_wq, ...) to return prematurely.

Second, on sysfs unbind, existing crypto_ahash transforms remain alive after
spacc_crypto_remove() returns. While spacc_hash_init_tfm() calls
get_device(salg->dev), that only pins the struct device kobject and does not
prevent devres from freeing devm_kzalloc()-allocated priv when
spacc_crypto_remove() finishes. In addition, spacc_remove(pdev) frees
spacc->ctx and spacc->job before platform_set_drvdata(pdev, NULL) is called,
and concurrent calls to spacc_hash_exit_tfm(), spacc_hash_setkey(), or
spacc_hash_digest() read dev_get_drvdata(tctx->dev) without synchronization
against teardown.

> diff --git a/drivers/crypto/dwc-spacc/spacc_interrupt.c b/drivers/crypto/=
dwc-spacc/spacc_interrupt.c
> new file mode 100644
> index 0000000000000..863b8c0b32402
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_interrupt.c

[ ... ]

> +	/* clear interrupt pin and run registered callback */
> +	if (irq_status & SPACC_IRQ_STAT_STAT) {
> +		handled |=3D SPACC_IRQ_STAT_STAT;
> +		SPACC_IRQ_STAT_CLEAR_STAT(spacc);
> +		if (spacc->op_mode =3D=3D SPACC_OP_MODE_IRQ &&
> +				spacc->wd_cnt_limit) {
> +			spacc_irq_cmdx_disable(spacc, 0);
> +			spacc_irq_stat_enable(spacc,
> +					spacc->config.ideal_stat_level);
> +			spacc_irq_stat_wd_enable(spacc);
> +			spacc->wdcnt =3D 0;
> +			spacc->op_mode =3D SPACC_OP_MODE_WD;
> +			spacc->wd_cnt_limit =3D false;
> +		} else if (spacc->op_mode =3D=3D SPACC_OP_MODE_IRQ) {
> +			spacc->config.fifo_cnt <<=3D 2;
> +			spacc->config.fifo_cnt =3D min(spacc->config.fifo_cnt,
> +					spacc->config.stat_fifo_depth);
> +
> +			/* update fifo count to allow more stats to pile up */
> +			spacc_irq_stat_enable(spacc, spacc->config.fifo_cnt);
> +
> +
> +			/* re-enable CMD0 empty interrupt */
> +			spacc_irq_cmdx_enable(spacc, 0, 0);
> +		}
> +		if (spacc->irq_cb_stat)
> +			spacc->irq_cb_stat(spacc);
> +	}

[ ... ]

> +	if (spacc->op_mode =3D=3D SPACC_OP_MODE_IRQ) {
> +		cmd_max =3D (spacc->config.is_qos ? SPACC_CMDX_MAX_QOS :
> +				SPACC_CMDX_MAX);
> +		for (x =3D 0; x < cmd_max; x++) {
> +			if (irq_status & SPACC_IRQ_STAT_CMDX(x)) {
> +				handled |=3D SPACC_IRQ_STAT_CMDX(x);
> +				spacc->config.fifo_cnt =3D 1;
> +
> +				/* disable CMD0 interrupt since STAT=3D1 */
> +				spacc_irq_cmdx_disable(spacc, x);
> +				spacc_irq_stat_enable(spacc,
> +						spacc->config.fifo_cnt);
> +
> +				SPACC_IRQ_STAT_CLEAR_CMDX(spacc, x);
> +
> +				/* run registered callback */
> +				if (spacc->irq_cb_cmdx)
> +					spacc->irq_cb_cmdx(spacc, x);
> +			}
> +		}
> +	}

[Severity: High]
Won't spacc_process_irq() livelock in hardirq context when operating in
SPACC_OP_MODE_IRQ?

In spacc_device.c, spacc_stat_process() and spacc_cmd_process() defer poppi=
ng
the STATUS FIFO to priv->pop_jobs on the priv->spacc_wq workqueue rather th=
an
draining the FIFO in the interrupt handler.

When a job completes in SPACC_OP_MODE_IRQ (STATUS FIFO count is 1, CMD0 FIFO
is empty), the SPACC_IRQ_STAT_STAT branch raises spacc->config.fifo_cnt,
calls spacc_irq_stat_enable(spacc, spacc->config.fifo_cnt), and enables the
CMD0 empty interrupt via spacc_irq_cmdx_enable(spacc, 0, 0).

Because CMD0 is currently empty, enabling CMD0 IRQ with threshold 0
immediately asserts SPACC_IRQ_STAT_CMDX(0) before the workqueue can run. The
next hardirq enters the SPACC_IRQ_STAT_CMDX(0) branch, disables CMD0 IRQ, a=
nd
lowers the STAT threshold back to 1 via spacc_irq_stat_enable(spacc, 1).
Because the completed job is still unpopped in the STATUS FIFO, lowering the
STAT threshold to 1 immediately re-asserts SPACC_IRQ_STAT_STAT, which
re-enables CMD0 IRQ and traps the CPU in an infinite interrupt loop.

[1] https://lore.kernel.org/r/aflklGva2ZoAz-A9@gondor.apana.org.au
[2] https://lore.kernel.org/r/20261019162457.1000115-3-pavitrakumarm@vayavy=
alabs.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030172456.2747=
44-1-pavitrakumarm@vayavyalabs.com?part=3D2
