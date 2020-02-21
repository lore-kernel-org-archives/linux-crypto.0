Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3FBC35641
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC66E206DB
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:43:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=tq-group.com header.i=@tq-group.com header.b="UEJqXgOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgBUInr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 03:43:47 -0500
Received: from mx1.tq-group.com ([62.157.118.193]:63503 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbgBUInq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 03:43:46 -0500
IronPort-SDR: VOLac6V/tQXPcJ3dGxdub1nTzBvhoCDb09oeNI2J2RELlZCa2vZln8OAsUkHqFEpHmGgtcC7yf
 ANhIgG8dxlgD+JsLSViuP6xBX5+IxKNIaATb/0ApC+VMAKOn9vs7v5ebB86txgXjGR/nOVyPH6
 PocCkTMR1+wfL2QScRUcue+gU1yO4hkhThCxAKoe9ppBBRGICdtRZthl22wYGtM1/MhFA0puM1
 nGz+i81f29BJ0MlEZtp6///IcyxTd+qeybWBfFiXxLxyiJ+66DeaVMFXj2dzzFbNTv/5mZgqTQ
 rIw=
X-IronPort-AV: E=Sophos;i="5.70,467,1574118000"; 
   d="scan'208";a="11051213"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 21 Feb 2020 09:43:44 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 21 Feb 2020 09:43:44 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 21 Feb 2020 09:43:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1582274624; x=1613810624;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oflfLwYqW5xFExYToNds3TpPpBbjgoa1J9+oBBMC8D4=;
  b=UEJqXgOB148Nqx80QcL4FmjjfhdCTSc/QlekE1+uooidjzkmxPOZYvOl
   tjY7CZ/xKaSfAqii5MQJo7/RfsGVz/0F/aPdILCz37i5CvSDKHzAtlT8Z
   ZZF4HxsqKxRqF6kBwN/7Ifwe1pwqHGUIwOb3zdc7YZlMfxQy8hpooXu65
   BtUDskF32YGADsFuU3iFgNmI+SC+x7Be95HID9EGfmnOtMay+5se3LLzy
   ZkkjLi5DhdF8sZkGXHy+H2pv39C0lDwo87CgiF2Qu2Ay/HJNHLJZin+0r
   wA3fl+39G+70Ms8SQYlE14GhGgRC6SUJvR49LAaUKMfrcmD4vzqUF3Amb
   g==;
IronPort-SDR: rTRCYoXQqhnGRFfeir1O7hIu2Cs2JQwqGtp4Nsz3f76Ax0PXoEo/CHuCPj2qdMeTkM5xAKdFkV
 jxu2TReDm2mIX10N752Aq/g+c/gQyB845zY3D7v1bawchfR/vR1/AlfsJJESmDexofDCb+wPpb
 EtBaGajN5/1QObbpgQVw0yWmf9NtupHz1TMhKtKsqXfPpitHUX6G+SVxKB7EDL/VcCBowOQ6Yz
 0cjWOxz62xMC48tLBfwGoTuy6sDIU+mdtYEDpKwRthmxsvZvXs2Q89KNm2K1Xal83hMXyJ5hCS
 ZqQ=
X-IronPort-AV: E=Sophos;i="5.70,467,1574118000"; 
   d="scan'208";a="11051212"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 21 Feb 2020 09:43:44 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id E277C280065;
        Fri, 21 Feb 2020 09:43:45 +0100 (CET)
Message-ID: <eca3c07767f2451590496bc890b235c8285f1a0b.camel@ew.tq-group.com>
Subject: Re: [RFC] crypto: caam: re-init JR on resume
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 21 Feb 2020 09:43:41 +0100
In-Reply-To: <20200203101850.22570-1-matthias.schiffer@ew.tq-group.com>
References: <20200203101850.22570-1-matthias.schiffer@ew.tq-group.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-02-03 at 11:18 +0100, Matthias Schiffer wrote:
> The JR loses its configuration during suspend-to-RAM (at least on
> i.MX6UL). Re-initialize the hardware on resume.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> ---
> 
> I've come across the issue that the CAAM would not work anymore after
> deep sleep on i.MX6UL. It turned out that the CAAM loses its state
> during suspend-to-RAM, so all registers read as zero and need to be
> reinitialized.
> 
> This patch is my first attempt at fixing the issue. It seems to work
> well enough, but I assume I'm missing some synchronization to prevent
> that some CAAM operation is currently under way when the suspend
> happens? I don't know the PM and crypto subsystems well enough to
> judge
> if this is possible, and if it is, how to prevent it.
> 
> I've only compile-tested this version of the patch, as I had to port
> it
> from our board kernel, which is based on the heavily-modified NXP
> branch.

It would be great to get some feedback on this patch. Is the hardware
support to lose its state? Does my fix look correct?

Kind regards,
Matthias



> 
> 
>  drivers/crypto/caam/intern.h |  3 ++
>  drivers/crypto/caam/jr.c     | 62 +++++++++++++++++++++++++---------
> --
>  2 files changed, 46 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/crypto/caam/intern.h
> b/drivers/crypto/caam/intern.h
> index c7c10c90464b..5d2e9091d5c2 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -47,6 +47,9 @@ struct caam_drv_private_jr {
>  	struct tasklet_struct irqtask;
>  	int irq;			/* One per queue */
>  
> +	dma_addr_t inpbusaddr;
> +	dma_addr_t outbusaddr;
> +
>  	/* Number of scatterlist crypt transforms active on the JobR */
>  	atomic_t tfm_count ____cacheline_aligned;
>  
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index fc97cde27059..2dabf5fd7818 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -418,13 +418,31 @@ int caam_jr_enqueue(struct device *dev, u32
> *desc,
>  }
>  EXPORT_SYMBOL(caam_jr_enqueue);
>  
> +static void caam_jr_setup_rings(struct caam_drv_private_jr *jrp)
> +{
> +	jrp->out_ring_read_index = 0;
> +	jrp->head = 0;
> +	jrp->tail = 0;
> +
> +	wr_reg64(&jrp->rregs->inpring_base, jrp->inpbusaddr);
> +	wr_reg64(&jrp->rregs->outring_base, jrp->outbusaddr);
> +	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
> +	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
> +
> +	jrp->inpring_avail = JOBR_DEPTH;
> +
> +	/* Select interrupt coalescing parameters */
> +	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JOBR_INTC |
> +		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
> +		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
> +}
> +
>  /*
>   * Init JobR independent of platform property detection
>   */
>  static int caam_jr_init(struct device *dev)
>  {
>  	struct caam_drv_private_jr *jrp;
> -	dma_addr_t inpbusaddr, outbusaddr;
>  	int i, error;
>  
>  	jrp = dev_get_drvdata(dev);
> @@ -434,13 +452,13 @@ static int caam_jr_init(struct device *dev)
>  		return error;
>  
>  	jrp->inpring = dmam_alloc_coherent(dev, SIZEOF_JR_INPENTRY *
> -					   JOBR_DEPTH, &inpbusaddr,
> +					   JOBR_DEPTH, &jrp-
> >inpbusaddr,
>  					   GFP_KERNEL);
>  	if (!jrp->inpring)
>  		return -ENOMEM;
>  
>  	jrp->outring = dmam_alloc_coherent(dev, SIZEOF_JR_OUTENTRY *
> -					   JOBR_DEPTH, &outbusaddr,
> +					   JOBR_DEPTH, &jrp-
> >outbusaddr,
>  					   GFP_KERNEL);
>  	if (!jrp->outring)
>  		return -ENOMEM;
> @@ -453,24 +471,9 @@ static int caam_jr_init(struct device *dev)
>  	for (i = 0; i < JOBR_DEPTH; i++)
>  		jrp->entinfo[i].desc_addr_dma = !0;
>  
> -	/* Setup rings */
> -	jrp->out_ring_read_index = 0;
> -	jrp->head = 0;
> -	jrp->tail = 0;
> -
> -	wr_reg64(&jrp->rregs->inpring_base, inpbusaddr);
> -	wr_reg64(&jrp->rregs->outring_base, outbusaddr);
> -	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
> -	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
> -
> -	jrp->inpring_avail = JOBR_DEPTH;
> -
>  	spin_lock_init(&jrp->inplock);
>  
> -	/* Select interrupt coalescing parameters */
> -	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JOBR_INTC |
> -		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
> -		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
> +	caam_jr_setup_rings(jrp);
>  
>  	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned
> long)dev);
>  
> @@ -486,6 +489,20 @@ static int caam_jr_init(struct device *dev)
>  	return error;
>  }
>  
> +static int caam_jr_reinit(struct device *dev)
> +{
> +	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
> +	int error;
> +
> +	error = caam_reset_hw_jr(dev);
> +	if (error)
> +		return error;
> +
> +	caam_jr_setup_rings(jrp);
> +
> +	return 0;
> +}
> +
>  static void caam_jr_irq_dispose_mapping(void *data)
>  {
>  	irq_dispose_mapping((unsigned long)data);
> @@ -578,10 +595,17 @@ static const struct of_device_id
> caam_jr_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, caam_jr_match);
>  
> +#ifdef CONFIG_PM
> +static SIMPLE_DEV_PM_OPS(caam_jr_pm_ops, caam_reset_hw_jr,
> caam_jr_reinit);
> +#endif
> +
>  static struct platform_driver caam_jr_driver = {
>  	.driver = {
>  		.name = "caam_jr",
>  		.of_match_table = caam_jr_match,
> +#ifdef CONFIG_PM
> +		.pm = &caam_jr_pm_ops,
> +#endif
>  	},
>  	.probe       = caam_jr_probe,
>  	.remove      = caam_jr_remove,

