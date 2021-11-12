Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2B7C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 19:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FAB461026
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 19:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhKLTZ3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 14:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhKLTZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 14:25:28 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58CFC061766;
        Fri, 12 Nov 2021 11:22:37 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7BA3D22175;
        Fri, 12 Nov 2021 20:22:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636744954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwmWf4bNByUx3caBNPYLLoXiXShP9v+D0gb4EJjxeFs=;
        b=go/wznunzd/4QbCDg7+WJNfHtWXC93NojG62OE0RW/owQDCVvKplkvOUrgtXL9MAaNJxZl
        lw1wY3//gANeSEorZHAVwbMHUJsLcR9N5Wy/f2Dws2r0HPW66KWDDdMRNnPMGpHg9fYKBq
        xqdqG3T7cT1t/teWfaWIh+Dj0XN4Rew=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Nov 2021 20:22:33 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: caam - convert to use capabilities
In-Reply-To: <20211111164601.13135-2-andrey.zhizhikin@leica-geosystems.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-2-andrey.zhizhikin@leica-geosystems.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <39b3abc52848f00d8952f703ae60988e@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 2021-11-11 17:46, schrieb Andrey Zhizhikin:
> CAAM driver contains several variables, which are used for indication
> that ertail capabilities are detected during initial probing of the
> device. They are defined as u8, but mainly used as boolean variables to
> identify capabillities.
> 
> Clean-up all assorted variables, collect them into one bitfield value
> which encodes capabilities as bit, and use them in the execution flow
> instead.
> 
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> ---
> Changes in V2: No change, this patch is newly introduced
> 
>  drivers/crypto/caam/caamalg_qi.c |  2 +-
>  drivers/crypto/caam/ctrl.c       | 49 ++++++++++++++++++--------------
>  drivers/crypto/caam/intern.h     | 16 +++++------
>  drivers/crypto/caam/regs.h       |  2 --
>  4 files changed, 36 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg_qi.c 
> b/drivers/crypto/caam/caamalg_qi.c
> index 189a7438b29c..372a319e8434 100644
> --- a/drivers/crypto/caam/caamalg_qi.c
> +++ b/drivers/crypto/caam/caamalg_qi.c
> @@ -2610,7 +2610,7 @@ int caam_qi_algapi_init(struct device *ctrldev)
>  	bool registered = false;
> 
>  	/* Make sure this runs only on (DPAA 1.x) QI */
> -	if (!priv->qi_present || caam_dpaa2)
> +	if (!(priv->caam_caps | CAAM_CAPS_QI_PRESENT) || caam_dpaa2)

Typo?
if (!(priv->caam_caps & CAAM_CAPS_QI_PRESENT) || caam_dpaa2)


>  		return 0;
> 
>  	/*
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index ca0361b2dbb0..7a14a69d89c7 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -100,7 +100,7 @@ static inline int run_descriptor_deco0(struct
> device *ctrldev, u32 *desc,
>  	int i;
> 
> 
> -	if (ctrlpriv->virt_en == 1 ||
> +	if ((ctrlpriv->caam_caps & CAAM_CAPS_VIRT_ENABLED) ||
>  	    /*
>  	     * Apparently on i.MX8M{Q,M,N,P} it doesn't matter if virt_en == 
> 1
>  	     * and the following steps should be performed regardless
> @@ -169,7 +169,7 @@ static inline int run_descriptor_deco0(struct
> device *ctrldev, u32 *desc,
>  	*status = rd_reg32(&deco->op_status_hi) &
>  		  DECO_OP_STATUS_HI_ERR_MASK;
> 
> -	if (ctrlpriv->virt_en == 1)
> +	if (ctrlpriv->caam_caps & CAAM_CAPS_VIRT_ENABLED)
>  		clrsetbits_32(&ctrl->deco_rsr, DECORSR_JR0, 0);
> 
>  	/* Mark the DECO as free */
> @@ -622,7 +622,6 @@ static int caam_probe(struct platform_device *pdev)
>  	struct dentry *dfs_root;
>  	u32 scfgr, comp_params;
>  	u8 rng_vid;
> -	int pg_size;
>  	int BLOCK_OFFSET = 0;
>  	bool pr_support = false;
> 
> @@ -666,11 +665,12 @@ static int caam_probe(struct platform_device 
> *pdev)
>  	else
>  		caam_ptr_sz = sizeof(u32);
>  	caam_dpaa2 = !!(comp_params & CTPR_MS_DPAA2);
> -	ctrlpriv->qi_present = !!(comp_params & CTPR_MS_QI_MASK);
> +	ctrlpriv->caam_caps |= (!!(comp_params & CTPR_MS_QI_MASK)) ?
> +		CAAM_CAPS_QI_PRESENT : 0;

"!!" is superfluous here. and the braces, too. But IMHO this is
easier on the eye:
if (comp_params & CTPR_MS_QI_MASK)
   ctrl->priv->caam_cap |= CAAM_CAPS_QI_PRESENT;


>  #ifdef CONFIG_CAAM_QI
>  	/* If (DPAA 1.x) QI present, check whether dependencies are available 
> */
> -	if (ctrlpriv->qi_present && !caam_dpaa2) {
> +	if ((ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) && !caam_dpaa2) {
>  		ret = qman_is_probed();
>  		if (!ret) {
>  			return -EPROBE_DEFER;
> @@ -692,11 +692,14 @@ static int caam_probe(struct platform_device 
> *pdev)
>  	/* Allocating the BLOCK_OFFSET based on the supported page size on
>  	 * the platform
>  	 */
> -	pg_size = (comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT;
> -	if (pg_size == 0)
> -		BLOCK_OFFSET = PG_SIZE_4K;
> +	ctrlpriv->caam_caps |=
> +		(!!((comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT)) ?
> +		CAAM_CAPS_64K_PAGESIZE : 0;

same here as above.

if (comp_params & CTPR_MS_PG_SZ_MASK)
   ctrl->priv->caam_cap |= CAAM_CAPS_64K_PAGESIZE;

Assuming that SZ_MASK and SZ_SHIFT fits together ;)

> +
> +	if (ctrlpriv->caam_caps & CAAM_CAPS_64K_PAGESIZE)
> +		BLOCK_OFFSET = SZ_64K;
>  	else
> -		BLOCK_OFFSET = PG_SIZE_64K;
> +		BLOCK_OFFSET = SZ_4K;

btw.. that all uppercase BLOCK_OFFSET looks super odd. Can we get
rid of that too? I haven't checked but pg_size didn't make any
sense before, did it? At least if SZ_MASK has more than one bit.

>  	ctrlpriv->ctrl = (struct caam_ctrl __iomem __force *)ctrl;
>  	ctrlpriv->assure = (struct caam_assurance __iomem __force *)
> @@ -711,11 +714,11 @@ static int caam_probe(struct platform_device 
> *pdev)
>  	/* Get the IRQ of the controller (for security violations only) */
>  	ctrlpriv->secvio_irq = irq_of_parse_and_map(nprop, 0);
>  	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");
> -	ctrlpriv->mc_en = !!np;
> +	ctrlpriv->caam_caps |= (!!np) ? CAAM_CAPS_MC_ENABLED : 0;

if (np)
   ctrlpriv->caam_caps |= CAAM_CAPS_MC_ENABLED;

>  	of_node_put(np);
> 
>  #ifdef CONFIG_FSL_MC_BUS
> -	if (ctrlpriv->mc_en) {
> +	if (ctrlpriv->caam_caps & CAAM_CAPS_MC_ENABLED) {
>  		struct fsl_mc_version *mc_version;
> 
>  		mc_version = fsl_mc_get_version();
> @@ -732,7 +735,7 @@ static int caam_probe(struct platform_device *pdev)
>  	 * In case of SoCs with Management Complex, MC f/w performs
>  	 * the configuration.
>  	 */
> -	if (!ctrlpriv->mc_en)
> +	if (!(ctrlpriv->caam_caps & CAAM_CAPS_MC_ENABLED))
>  		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK,
>  			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |
>  			      MCFGR_WDENABLE | MCFGR_LARGE_BURST);
> @@ -745,7 +748,6 @@ static int caam_probe(struct platform_device *pdev)
>  	 */
>  	scfgr = rd_reg32(&ctrl->scfgr);
> 
> -	ctrlpriv->virt_en = 0;
>  	if (comp_params & CTPR_MS_VIRT_EN_INCL) {
>  		/* VIRT_EN_INCL = 1 & VIRT_EN_POR = 1 or
>  		 * VIRT_EN_INCL = 1 & VIRT_EN_POR = 0 & SCFGR_VIRT_EN = 1
> @@ -753,14 +755,14 @@ static int caam_probe(struct platform_device 
> *pdev)
>  		if ((comp_params & CTPR_MS_VIRT_EN_POR) ||
>  		    (!(comp_params & CTPR_MS_VIRT_EN_POR) &&
>  		       (scfgr & SCFGR_VIRT_EN)))
> -				ctrlpriv->virt_en = 1;
> +			ctrlpriv->caam_caps |= CAAM_CAPS_VIRT_ENABLED;

at first sight it looked like a wrong indendation, but it the old
code was wrong.

>  	} else {
>  		/* VIRT_EN_INCL = 0 && VIRT_EN_POR_VALUE = 1 */
>  		if (comp_params & CTPR_MS_VIRT_EN_POR)
> -				ctrlpriv->virt_en = 1;
> +			ctrlpriv->caam_caps |= CAAM_CAPS_VIRT_ENABLED;
>  	}
> 
> -	if (ctrlpriv->virt_en == 1)
> +	if (ctrlpriv->caam_caps & CAAM_CAPS_VIRT_ENABLED)
>  		clrsetbits_32(&ctrl->jrstart, 0, JRSTART_JR0_START |
>  			      JRSTART_JR1_START | JRSTART_JR2_START |
>  			      JRSTART_JR3_START);
> @@ -785,7 +787,7 @@ static int caam_probe(struct platform_device *pdev)
>  	caam_debugfs_init(ctrlpriv, dfs_root);
> 
>  	/* Check to see if (DPAA 1.x) QI present. If so, enable */
> -	if (ctrlpriv->qi_present && !caam_dpaa2) {
> +	if ((ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) && !caam_dpaa2) {
>  		ctrlpriv->qi = (struct caam_queue_if __iomem __force *)
>  			       ((__force uint8_t *)ctrl +
>  				 BLOCK_OFFSET * QI_BLOCK_NUMBER
> @@ -810,12 +812,13 @@ static int caam_probe(struct platform_device 
> *pdev)
>  					     (ring + JR_BLOCK_NUMBER) *
>  					      BLOCK_OFFSET
>  					     );
> -			ctrlpriv->total_jobrs++;
>  			ring++;
> +			ctrlpriv->caam_caps |= BIT(ring);

I think this deserves an own macro. At the moment you assume that
the lower bits are for the rings, right? I'd like to see something
like
ctrlpriv->caam_caps |= JR_PRESENT(ring);

then have
#define JR_PRESENT_MASK GENMASK(7, 0)
#define JR_PRESENT(x) (BIT(x) & JR_PRESENT_MASK)
together with all the other bits in caam_caps. Or something
along that. I guess you got the idea.


>  		}
> 
>  	/* If no QI and no rings specified, quit and go home */
> -	if ((!ctrlpriv->qi_present) && (!ctrlpriv->total_jobrs)) {
> +	if (!(ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) &&
> +	    (hweight_long(ctrlpriv->caam_caps & CAAM_CAPS_JOBRS_MASK) == 0)) 
> {
>  		dev_err(dev, "no queues configured, terminating\n");
>  		return -ENOMEM;
>  	}
> @@ -832,7 +835,8 @@ static int caam_probe(struct platform_device *pdev)
>  	 * already instantiated, do RNG instantiation
>  	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
>  	 */
> -	if (!(ctrlpriv->mc_en && pr_support) && rng_vid >= 4) {
> +	if (!((ctrlpriv->caam_caps & CAAM_CAPS_MC_ENABLED) && pr_support) &&
> +	    rng_vid >= 4) {
>  		ctrlpriv->rng4_sh_init =
>  			rd_reg32(&ctrl->r4tst[0].rdsta);
>  		/*
> @@ -900,8 +904,9 @@ static int caam_probe(struct platform_device *pdev)
>  	/* Report "alive" for developer to see */
>  	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
>  		 ctrlpriv->era);
> -	dev_info(dev, "job rings = %d, qi = %d\n",
> -		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
> +	dev_info(dev, "job rings = %ld, qi = %s\n",
> +		 hweight_long(ctrlpriv->caam_caps & CAAM_CAPS_JOBRS_MASK),
> +		 (ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) ? "yes" : "no");
> 
>  	ret = devm_of_platform_populate(dev);
>  	if (ret)
> diff --git a/drivers/crypto/caam/intern.h 
> b/drivers/crypto/caam/intern.h
> index 7d45b21bd55a..37f0b93c7087 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -86,15 +86,15 @@ struct caam_drv_private {
> 
>  	struct iommu_domain *domain;
> 
> -	/*
> -	 * Detected geometry block. Filled in from device tree if powerpc,
> -	 * or from register-based version detection code
> -	 */
> -	u8 total_jobrs;		/* Total Job Rings in device */
> -	u8 qi_present;		/* Nonzero if QI present in device */
> -	u8 mc_en;		/* Nonzero if MC f/w is active */
> +	unsigned long caam_caps; /* CAAM Module capabilities */
> +
> +#define CAAM_CAPS_QI_PRESENT	BIT(0)	/* Queue Manager interface (QI)
> implemented */
> +#define CAAM_CAPS_JOBRS_MASK	GENMASK(15, 1)	/* Job Ring is available
> in NS World */

ok I see you already have something like that. See above. That BIT()
in the code above should go away.

> +#define CAAM_CAPS_MC_ENABLED	BIT(16)	/* Management Complex is enabled
> (F/W is active) */
> +#define CAAM_CAPS_VIRT_ENABLED	BIT(17)	/* Virtualization enabled */
> +#define CAAM_CAPS_64K_PAGESIZE	BIT(18)	/* CAAM register page size
> (64KB if set, 4KB if unset) */
> +
>  	int secvio_irq;		/* Security violation interrupt number */
> -	int virt_en;		/* Virtualization enabled in CAAM */
>  	int era;		/* CAAM Era (internal HW revision) */
> 
>  #define	RNG4_MAX_HANDLES 2
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 3738625c0250..186e76e6a3e7 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -1023,6 +1023,4 @@ struct caam_deco {
>  #define ASSURE_BLOCK_NUMBER	6
>  #define QI_BLOCK_NUMBER		7
>  #define DECO_BLOCK_NUMBER	8
> -#define PG_SIZE_4K		0x1000
> -#define PG_SIZE_64K		0x10000

nice ;)

>  #endif /* REGS_H */

Otherwise, I really like this cleanup.

Thanks,
-michael
