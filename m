Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2954FC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 21:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A11B60C51
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 21:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhKLVUz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 16:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbhKLVUy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 16:20:54 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A68C061766;
        Fri, 12 Nov 2021 13:18:02 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DA77722175;
        Fri, 12 Nov 2021 22:17:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636751880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hE/NLM5PyvF/iHtnTPaAlITOzlFT/NldAZ4tUsD593E=;
        b=QLs5pBZKQRQqTcXpeSIrfXTl9b3ZSVDk5G1Lj7hta8mxYA8rIb7w6wCXU/aHrorz3BrVDD
        xszi44iYfCidG+wMFaxy4LBGn0qGymZ+NgePpVfoHFNxOGMd78H8M8Zjj7u6hOvxcsiOx6
        okRaKLGTtorID6NjfozssRmrNWWGSkI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Nov 2021 22:17:59 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: caam - check jr permissions before probing
In-Reply-To: <20211111164601.13135-3-andrey.zhizhikin@leica-geosystems.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-3-andrey.zhizhikin@leica-geosystems.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <e8456cc0bb9e4fc306e8188c5bd666d0@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 2021-11-11 17:46, schrieb Andrey Zhizhikin:
> Job Rings can be set to be exclusively used by TrustZone which makes 
> the
> access to those rings only possible from Secure World. This access
> separation is defined by setting bits in CAAM JRxDID_MS register. Once
> reserved to be owned by TrustZone, this Job Ring becomes unavailable 
> for
> the Kernel. This reservation is performed early in the boot process,
> even before the Kernel starts, which leads to unavailability of the HW
> at the probing stage. Moreover, the reservation can be done for any Job
> Ring and is not under control of the Kernel.
> 
> Current implementation lists Job Rings as child nodes of CAAM driver,
> and tries to perform probing on those regardless of whether JR HW is
> accessible or not.
> 
> This leads to the following error while probing:
> [    1.509894] caam 30900000.crypto: job rings = 3, qi = 0
> [    1.525201] caam_jr 30901000.jr: failed to flush job ring 0
> [    1.525214] caam_jr: probe of 30901000.jr failed with error -5
> 
> Implement a dynamic mechanism to identify which Job Ring is actually
> marked as owned by TrustZone, and fail the probing of those child nodes
> with -ENODEV.

For other reviewers/maintainers: I'm still not sure this is the way
to go. Instead one can let u-boot fix up the device tree and remove
or disable the JR node if its not available.

> If the Job Ring is released from the Secure World at the later stage,
> then bind can be performed, which would check the Ring availability and
> proceed with probing if the Ring is released.

But what if its the other way around and S world will "steal" it from
NS world.

> 
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> ---
> Changes in V2:
> - Create and export new method in CAAM control driver to verify JR
>   validity based on the address supplied.
> - Re-work the logic JR driver to call CAAM control method instead of 
> bit
>   verification. This ensures the actual information retrival from CAAM
>   module during JR probe.
> - Clean-up of internal static job indexes used during probing, new
>   indexing is performed based on the address supplied in DTB node.
> 
>  drivers/crypto/caam/ctrl.c   | 63 ++++++++++++++++++++++++++++++------
>  drivers/crypto/caam/intern.h |  2 ++
>  drivers/crypto/caam/jr.c     | 33 ++++++++++++++++---
>  drivers/crypto/caam/regs.h   |  7 ++--
>  4 files changed, 87 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 7a14a69d89c7..ffe233f2c4ef 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -79,6 +79,42 @@ static void build_deinstantiation_desc(u32 *desc, 
> int handle)
>  	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
>  }
> 
> +/*
> + * caam_ctrl_check_jr_perm - check if the job ring can be accessed
> + *				from Non-Secure World.
> + * @ctrldev - pointer to CAAM control device
> + * @ring_addr - input address of Job Ring, which access should be 
> verified
> + *
> + * Return: - 0 if Job Ring is available in NS World
> + *	    - 1 if Job Ring is reserved in the Secure World
> + */
> +inline int caam_ctrl_check_jr_perm(struct device *ctrldev, u32 
> ring_addr)

inline?
static int caam_ctrl_..

> +{
> +	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
> +	struct caam_ctrl __iomem *ctrl = ctrlpriv->ctrl;
> +	u32 ring_id;
> +
> +	ring_id = ring_addr >>
> +		((ctrlpriv->caam_caps & CAAM_CAPS_64K_PAGESIZE) ?
> +		16 : 12);

mh also here:
if (ctrlpriv->caam_caps & CAAM_CAPS_64K_PAGESIZE)
   ring_id = ring_addr >> 16;
else
   ring_id = ring_addr >> 12;

Is there something to replace that "16" and "12" by the SZ_ macros,
btw?

> +	/*
> +	 * Check if the JR is not owned exclusively by TZ,
> +	 * and update capabilities bitmap to indicate that
> +	 * the Job Ring is available.
> +	 * Note: Ring index is 0-based in the register map
> +	 */
> +	if (!((rd_reg32(&ctrl->jr_mid[ring_id - 1].liodn_ms)) &
> +		MSTRID_LOCK_TZ_OWN)) {
> +		ctrlpriv->caam_caps |= BIT(ring_id);

See also the former patch, this should be a macro.

> +		return 0;
> +	}
> +
> +	/* Job Ring is reserved, clear bit if is was set before */
> +	ctrlpriv->caam_caps &= ~BIT(ring_id);
> +	return 1;
> +}
> +EXPORT_SYMBOL(caam_ctrl_check_jr_perm);

no need for exporting this, no?

> +
>  /*
>   * run_descriptor_deco0 - runs a descriptor on DECO0, under direct 
> control of
>   *			  the software (no JR/QI used).
> @@ -612,7 +648,7 @@ static bool check_version(struct fsl_mc_version
> *mc_version, u32 major,
>  /* Probe routine for CAAM top (controller) level */
>  static int caam_probe(struct platform_device *pdev)
>  {
> -	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
> +	int ret, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
>  	u64 caam_id;
>  	const struct soc_device_attribute *imx_soc_match;
>  	struct device *dev;
> @@ -803,20 +839,27 @@ static int caam_probe(struct platform_device 
> *pdev)
>  #endif
>  	}
> 
> -	ring = 0;
>  	for_each_available_child_of_node(nprop, np)
>  		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
>  		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
> -			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
> -					     ((__force uint8_t *)ctrl +
> -					     (ring + JR_BLOCK_NUMBER) *
> -					      BLOCK_OFFSET
> -					     );
> -			ring++;
> -			ctrlpriv->caam_caps |= BIT(ring);
> +			u32 ring_id;
> +			/*
> +			 * Get register page to see the start address of CB
> +			 * This is used to index into the bitmap of available
> +			 * job rings and indicate if it is available in NS world.
> +			 */
> +			ret = of_property_read_u32(np, "reg", &ring_id);

Not sure about this one, but I don't have any better idea.


> +			if (ret) {
> +				dev_err(dev, "failed to get register address for jobr\n");
> +				continue;
> +			}
> +			caam_ctrl_check_jr_perm(dev, ring_id);

What about
if (!caam_ctrl_is_jr_available(dev, ring_id))
    ctrlpriv->caam_caps &= ~BIT(ring_id);

Again BIT() should be its own macro.

>  		}
> 
> -	/* If no QI and no rings specified, quit and go home */
> +	/*
> +	 * If no QI, no rings specified or no rings available for NS -
> +	 * quit and go home
> +	 */
>  	if (!(ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) &&
>  	    (hweight_long(ctrlpriv->caam_caps & CAAM_CAPS_JOBRS_MASK) == 0)) 
> {
>  		dev_err(dev, "no queues configured, terminating\n");
> diff --git a/drivers/crypto/caam/intern.h 
> b/drivers/crypto/caam/intern.h
> index 37f0b93c7087..8d6a0cff556a 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -115,6 +115,8 @@ struct caam_drv_private {
>  #endif
>  };
> 
> +inline int caam_ctrl_check_jr_perm(struct device *ctrldev, u32 
> ring_addr);
> +
>  #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API
> 
>  int caam_algapi_init(struct device *dev);
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 7f2b1101f567..e1bc1ce5515e 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -90,7 +90,7 @@ static int caam_reset_hw_jr(struct device *dev)
> 
>  	if ((rd_reg32(&jrp->rregs->jrintstatus) & JRINT_ERR_HALT_MASK) !=
>  	    JRINT_ERR_HALT_COMPLETE || timeout == 0) {
> -		dev_err(dev, "failed to flush job ring %d\n", jrp->ridx);
> +		dev_err(dev, "failed to flush job ring %x\n", jrp->ridx);

mh? why changing this?

>  		return -EIO;
>  	}
> 
> @@ -101,7 +101,7 @@ static int caam_reset_hw_jr(struct device *dev)
>  		cpu_relax();
> 
>  	if (timeout == 0) {
> -		dev_err(dev, "failed to reset job ring %d\n", jrp->ridx);
> +		dev_err(dev, "failed to reset job ring %x\n", jrp->ridx);
>  		return -EIO;
>  	}
> 
> @@ -489,7 +489,7 @@ static int caam_jr_init(struct device *dev)
>  	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, 
> IRQF_SHARED,
>  				 dev_name(dev), dev);
>  	if (error) {
> -		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
> +		dev_err(dev, "can't connect JobR %x interrupt (%d)\n",
>  			jrp->ridx, jrp->irq);
>  		tasklet_kill(&jrp->irqtask);
>  	}
> @@ -511,10 +511,33 @@ static int caam_jr_probe(struct platform_device 
> *pdev)
>  	struct device_node *nprop;
>  	struct caam_job_ring __iomem *ctrl;
>  	struct caam_drv_private_jr *jrpriv;
> -	static int total_jobrs;
> +	u32 ring_addr;
>  	struct resource *r;
>  	int error;
> 
> +	/*
> +	 * Get register page to see the start address of CB.
> +	 * Job Rings have their respective input base addresses
> +	 * defined in the register IRBAR_JRx. This address is
> +	 * present in the DT node and is aligned to the page
> +	 * size defined at CAAM compile time.
> +	 */
> +	if (of_property_read_u32(pdev->dev.of_node, "reg", &ring_addr)) {
> +		dev_err(&pdev->dev, "failed to get register address for jobr\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (caam_ctrl_check_jr_perm(pdev->dev.parent, ring_addr)) {

With the change above, this will also have no bogus side effects
on caam_caps.

> +		/*
> +		 * This job ring is marked to be exclusively used by TZ,
> +		 * do not proceed with probing as the HW block is inaccessible.
> +		 * Defer this device probing for later, it might be released
> +		 * into NS world.
> +		 */
> +		dev_info(&pdev->dev, "job ring is reserved in secure world\n");
> +		return -ENODEV;
> +	}
> +
>  	jrdev = &pdev->dev;
>  	jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
>  	if (!jrpriv)
> @@ -523,7 +546,7 @@ static int caam_jr_probe(struct platform_device 
> *pdev)
>  	dev_set_drvdata(jrdev, jrpriv);
> 
>  	/* save ring identity relative to detection */
> -	jrpriv->ridx = total_jobrs++;
> +	jrpriv->ridx = ring_addr;
> 
>  	nprop = pdev->dev.of_node;
>  	/* Get configuration properties from device tree */
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 186e76e6a3e7..c4e8574bc570 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -445,10 +445,11 @@ struct caam_perfmon {
>  };
> 
>  /* LIODN programming for DMA configuration */
> -#define MSTRID_LOCK_LIODN	0x80000000
> -#define MSTRID_LOCK_MAKETRUSTED	0x00010000	/* only for JR masterid */
> +#define MSTRID_LOCK_LIODN		BIT(31)
> +#define MSTRID_LOCK_MAKETRUSTED	BIT(16)	/* only for JR: masterid */
> +#define MSTRID_LOCK_TZ_OWN		BIT(15)	/* only for JR: owned by TZ */
> 
> -#define MSTRID_LIODN_MASK	0x0fff
> +#define MSTRID_LIODN_MASK		GENMASK(11, 0)
>  struct masterid {
>  	u32 liodn_ms;	/* lock and make-trusted control bits */
>  	u32 liodn_ls;	/* LIODN for non-sequence and seq access */

-- 
-michael
