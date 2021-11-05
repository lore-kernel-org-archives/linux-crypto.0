Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9571EC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 01:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C1161245
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 01:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhKEBX1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 21:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKEBX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 21:23:27 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80913C061714;
        Thu,  4 Nov 2021 18:20:47 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4CA3322221;
        Fri,  5 Nov 2021 02:20:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636075245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czoGMI7pSGD+jgK2GH+aWkW1UvHzzNCq7dk4XmwLUZ8=;
        b=kfu5PyBxJpoDNyt86ETewP7DrC0EwQNyd/TkGWVvffCKytziAa+Y/AK15hixRZbAi7+l09
        PQE/hW2FJOtJ+lKPXgG8XlEdiArx+GcTLhAMqxlRJjbDldeGJf9Xx0fChuMrNOL10PxNQg
        scPRzdhAHBKm1ydwi98uh2uWzhtocTY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 05 Nov 2021 02:20:43 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - check jr permissions before probing
In-Reply-To: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d5cf77b4734f9d60c8d61a2a0a799180@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrey,

Am 2021-11-04 17:21, schrieb Andrey Zhizhikin:
> Job Rings can be set to be exclusively used by TrustZone which makes 
> the
> access to those rings only possible from Secure World. This access
> separation is defined by setting bits in CAAM JRxDID_MS register. Once
> reserved to be owned by TrustZone, this Job Ring becomes unavailable 
> for
> the Kernel. This reservation is performed early in the boot process,
> even before the Kernel starts, which leads to unavailability of the HW
> at the probing stage. Moreover, the reservation can be done for any Job
> Ring and is not under control of the Kernel. The only condition that
> remains is: at least one Job Ring should be made available for the NS
> world.

Where is that written down?

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
> 
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> ---
>  drivers/crypto/caam/ctrl.c   | 18 ++++++++++++------
>  drivers/crypto/caam/intern.h |  1 +
>  drivers/crypto/caam/jr.c     | 17 +++++++++++++++++
>  drivers/crypto/caam/regs.h   |  8 +++++---
>  4 files changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index ca0361b2dbb0..c48506a02340 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -805,12 +805,18 @@ static int caam_probe(struct platform_device 
> *pdev)
>  	for_each_available_child_of_node(nprop, np)
>  		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
>  		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
> -			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
> -					     ((__force uint8_t *)ctrl +
> -					     (ring + JR_BLOCK_NUMBER) *
> -					      BLOCK_OFFSET
> -					     );
> -			ctrlpriv->total_jobrs++;
> +			/* Check if the JR is not owned exclusively by TZ */
> +			if (!((rd_reg32(&ctrl->jr_mid[ring].liodn_ms)) &
> +				(MSTRID_LOCK_TZ_OWN | MSTRID_LOCK_PRIM_TZ))) {

what is the PRIM_TZ bit? I don't see it in my reference manual
(which is for the LS1028A).

Can't we just do a
if (rd_reg32(&ctrl->jr_mid[ring].liodn_ms) &
     (MSTRID_LOCK_TZ_OWN | MSTRID_LOCK_PRIM_TZ))
	continue;

> +				ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
> +						     ((__force uint8_t *)ctrl +
> +						     (ring + JR_BLOCK_NUMBER) *
> +						      BLOCK_OFFSET
> +						     );

This isn't really used at all. Can we drop "jr" from
struct caam_drv_private altogether? See also below.

> +				/* Indicate that this JR is available for NS */
> +				ctrlpriv->jobr_ns_flags |= BIT(ring);
> +				ctrlpriv->total_jobrs++;

as well as this?

> +			}
>  			ring++;
>  		}
> 
> diff --git a/drivers/crypto/caam/intern.h 
> b/drivers/crypto/caam/intern.h
> index 7d45b21bd55a..2919af55dbfe 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -91,6 +91,7 @@ struct caam_drv_private {
>  	 * or from register-based version detection code
>  	 */
>  	u8 total_jobrs;		/* Total Job Rings in device */
> +	u8 jobr_ns_flags;	/* Flags for each Job Ring if it is not owned by 
> TZ*/
>  	u8 qi_present;		/* Nonzero if QI present in device */
>  	u8 mc_en;		/* Nonzero if MC f/w is active */
>  	int secvio_irq;		/* Security violation interrupt number */
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 7f2b1101f567..a260981e0843 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -511,10 +511,27 @@ static int caam_jr_probe(struct platform_device 
> *pdev)
>  	struct device_node *nprop;
>  	struct caam_job_ring __iomem *ctrl;
>  	struct caam_drv_private_jr *jrpriv;
> +	struct caam_drv_private *caamctrlpriv;
>  	static int total_jobrs;

ugh.

>  	struct resource *r;
>  	int error;
> 
> +	/* Before we proceed with the JR device probing, verify
> +	 * that the job ring itself is available to Non-Secure world.
> +	 * If the JR is owned exclusively by TZ - we should not even
> +	 * process it further.
> +	 */
> +	caamctrlpriv = dev_get_drvdata(pdev->dev.parent);
> +	if (!(caamctrlpriv->jobr_ns_flags & BIT(total_jobrs))) {

Is anything preventing from total_jobrs getting big? Can't
we get rid of this static variable somehow? Before this commit,
it was just used for messages. Can we check the TZ bit here
instead of doing that bitflags dance?

nitpick: in caam there are no netdev comments. So multiline
comments look like:
/*
  * this is a comment.
  */

> +		/* This job ring is marked to be exclusively used by TZ,
> +		 * do not proceed with probing as the HW block is inaccessible.
> +		 * Increment total seen JR devices since it is used as the index
> +		 * into verification and fail probing for this node.
> +		 */
> +		total_jobrs++;
> +		return -ENODEV;
> +	}
> +
>  	jrdev = &pdev->dev;
>  	jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
>  	if (!jrpriv)
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 3738625c0250..8ade617f9e65 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -445,10 +445,12 @@ struct caam_perfmon {
>  };
> 
>  /* LIODN programming for DMA configuration */
> -#define MSTRID_LOCK_LIODN	0x80000000
> -#define MSTRID_LOCK_MAKETRUSTED	0x00010000	/* only for JR masterid */
> +#define MSTRID_LOCK_LIODN		BIT(31)
> +#define MSTRID_LOCK_MAKETRUSTED	BIT(16)	/* only for JR: masterid */
> +#define MSTRID_LOCK_TZ_OWN		BIT(15)	/* only for JR: owned by TZ */
> +#define MSTRID_LOCK_PRIM_TZ		BIT(4)	/* only for JR: Primary TZ */

can't find that one.

in general, does these marcros match with your reference
manual? Which one do you have?

for me the bits are named:
LICID[31], AMTD[16], TZ[15] and SDID[11:0]
also the register is called JRnICID.

I wonder if the LS1028A has a newer/older CAAM version.
according to the device tree (fsl-ls1028a.dtsi) the
sec is v5.0 (and also compatible with v4.0). If you
have a look at the RM it says 7.0 (at least the MAJ_VER
in SECVID_MS is 7 accoring to the manual; i haven't
checked on the hardware for now.

Horia, can you shed some light here.

> -#define MSTRID_LIODN_MASK	0x0fff
> +#define MSTRID_LIODN_MASK		GENMASK(11, 0)
>  struct masterid {
>  	u32 liodn_ms;	/* lock and make-trusted control bits */
>  	u32 liodn_ls;	/* LIODN for non-sequence and seq access */
> 
> base-commit: 8a796a1dfca2780321755033a74bca2bbe651680

-- 
-michael
