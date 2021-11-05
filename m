Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA29C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 23:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F43611C4
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 23:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhKEXTm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 19:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhKEXTm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 19:19:42 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22A6C061570;
        Fri,  5 Nov 2021 16:17:01 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 39F7522247;
        Sat,  6 Nov 2021 00:16:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636154217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCY87OXqBVjZ7E9BhLns54fdDgZz5DTHvQGcGwWECZU=;
        b=tABDgzQlmIr9fLF11lE2TwjvyQoUn+BUSy6aX8G729oXZmYoAcUBJQ8TXpIAFTHHEMikoD
        qnQTW+Z+S6BIK97RokVAN101WcCAk5+r7kOgeKVH3TMCC0aOja4x+0jSbaI7rW04bPJApd
        LcQR9hYOb6STJznxk/gXlypSoJO8eZ4=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 06 Nov 2021 00:16:55 +0100
From:   Michael Walle <michael@walle.cc>
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - check jr permissions before probing
In-Reply-To: <AM6PR06MB4691A6F69B509EF6B4BFF466A68E9@AM6PR06MB4691.eurprd06.prod.outlook.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <d5cf77b4734f9d60c8d61a2a0a799180@walle.cc>
 <AM6PR06MB4691A6F69B509EF6B4BFF466A68E9@AM6PR06MB4691.eurprd06.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <6f8e16378f797b5c562c5dcbe26426b6@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrey,

Am 2021-11-05 11:34, schrieb ZHIZHIKIN Andrey:
>> -----Original Message-----
>> From: Michael Walle <michael@walle.cc>
>> Sent: Friday, November 5, 2021 2:21 AM
>> To: ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
>> Cc: horia.geanta@nxp.com; pankaj.gupta@nxp.com;
>> herbert@gondor.apana.org.au; davem@davemloft.net;
>> iuliana.prodan@nxp.com; linux-crypto@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] crypto: caam - check jr permissions before 
>> probing
>> 
>> 
>> Hi Andrey,
>> 
>> Am 2021-11-04 17:21, schrieb Andrey Zhizhikin:
>> > Job Rings can be set to be exclusively used by TrustZone which makes
>> > the access to those rings only possible from Secure World. This access
>> > separation is defined by setting bits in CAAM JRxDID_MS register. Once
>> > reserved to be owned by TrustZone, this Job Ring becomes unavailable
>> > for the Kernel. This reservation is performed early in the boot
>> > process, even before the Kernel starts, which leads to unavailability
>> > of the HW at the probing stage. Moreover, the reservation can be done
>> > for any Job Ring and is not under control of the Kernel. The only
>> > condition that remains is: at least one Job Ring should be made
>> > available for the NS world.
>> 
>> Where is that written down?
> 
> If you refer to the condition statement: this is implied as without any 
> JR
> initialized - it would not be possible to register a single algo.
> 
> This stemmed out from the discussion of the patch in U-Boot (see [1]),
> where the it was indicated that JR0 is reserved for HAB on imx8m 
> series.
> 
> The naïve solution proposed was to just disable the child node, but I
> decided to look for a dynamic possibility to recognize those reserved 
> JR
> nodes, hence this patch came out.

First, thank you for taking the extra step here. Does "reserved for HAB"
mean TF-A is using it or is the BootROM already using it. TF-A is
optional (so is HAB I guess?). So it might be possible to have jr0 in 
linux,
right? If that is correct, the solution to disable the jr0 at compile 
time
is wrong.

Thus it has to be done at run time. Either by removing/disabling the 
node
in u-boot or by not probing it. I'm not sure whats the correct solution
here, though.

>> > Current implementation lists Job Rings as child nodes of CAAM driver,
>> > and tries to perform probing on those regardless of whether JR HW is
>> > accessible or not.
>> >
>> > This leads to the following error while probing:
>> > [    1.509894] caam 30900000.crypto: job rings = 3, qi = 0
>> > [    1.525201] caam_jr 30901000.jr: failed to flush job ring 0
>> > [    1.525214] caam_jr: probe of 30901000.jr failed with error -5
>> >
>> > Implement a dynamic mechanism to identify which Job Ring is actually
>> > marked as owned by TrustZone, and fail the probing of those child
>> > nodes with -ENODEV.
>> >
>> > Signed-off-by: Andrey Zhizhikin
>> > <andrey.zhizhikin@leica-geosystems.com>
>> > ---
>> >  drivers/crypto/caam/ctrl.c   | 18 ++++++++++++------
>> >  drivers/crypto/caam/intern.h |  1 +
>> >  drivers/crypto/caam/jr.c     | 17 +++++++++++++++++
>> >  drivers/crypto/caam/regs.h   |  8 +++++---
>> >  4 files changed, 35 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
>> > index ca0361b2dbb0..c48506a02340 100644
>> > --- a/drivers/crypto/caam/ctrl.c
>> > +++ b/drivers/crypto/caam/ctrl.c
>> > @@ -805,12 +805,18 @@ static int caam_probe(struct platform_device
>> > *pdev)
>> >       for_each_available_child_of_node(nprop, np)
>> >               if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
>> >                   of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
>> > -                     ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
>> > -                                          ((__force uint8_t *)ctrl +
>> > -                                          (ring + JR_BLOCK_NUMBER) *
>> > -                                           BLOCK_OFFSET
>> > -                                          );
>> > -                     ctrlpriv->total_jobrs++;
>> > +                     /* Check if the JR is not owned exclusively by TZ */
>> > +                     if (!((rd_reg32(&ctrl->jr_mid[ring].liodn_ms)) &
>> > +                             (MSTRID_LOCK_TZ_OWN |
>> > + MSTRID_LOCK_PRIM_TZ))) {
>> 
>> what is the PRIM_TZ bit? I don't see it in my reference manual (which 
>> is for the
>> LS1028A).
> 
> See my comment below regarding this bit.
> 
>> 
>> Can't we just do a
>> if (rd_reg32(&ctrl->jr_mid[ring].liodn_ms) &
>>      (MSTRID_LOCK_TZ_OWN | MSTRID_LOCK_PRIM_TZ))
>>         continue;
> 
> Yes, this would work as well. I'll address this is V2.
> 
>> 
>> > +                             ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
>> > +                                                  ((__force uint8_t *)ctrl +
>> > +                                                  (ring + JR_BLOCK_NUMBER) *
>> > +                                                   BLOCK_OFFSET
>> > +                                                  );
>> 
>> This isn't really used at all. Can we drop "jr" from struct 
>> caam_drv_private
>> altogether? See also below.
> 
> Agree. I was contemplating to remove this, as the caam_jr does its own
> devm_ioremap in the probe
> and does not use what caam driver passes along. But I decided not to
> address this with this patch,
> since this is not related to the issue this change addresses.
> 
> In general, this driver needs a bit of TLC, and I can take care of
> those points (together with
> ctrlpriv->total_jobrs) in a separate series, unless there are strong
> objections arises that this cleanup
> should come along this patch.

If you clean up later, probably most of this code is going away, no?
Then whats the point in having this patch in the first place. Usually
its the other way around.

>> > +                             /* Indicate that this JR is available for NS */
>> > +                             ctrlpriv->jobr_ns_flags |= BIT(ring);
>> > +                             ctrlpriv->total_jobrs++;
>> 
>> as well as this?
> 
> Noted.
> 
>> 
>> > +                     }
>> >                       ring++;
>> >               }
>> >
>> > diff --git a/drivers/crypto/caam/intern.h
>> > b/drivers/crypto/caam/intern.h index 7d45b21bd55a..2919af55dbfe 100644
>> > --- a/drivers/crypto/caam/intern.h
>> > +++ b/drivers/crypto/caam/intern.h
>> > @@ -91,6 +91,7 @@ struct caam_drv_private {
>> >        * or from register-based version detection code
>> >        */
>> >       u8 total_jobrs;         /* Total Job Rings in device */
>> > +     u8 jobr_ns_flags;       /* Flags for each Job Ring if it is not owned by
>> > TZ*/
>> >       u8 qi_present;          /* Nonzero if QI present in device */
>> >       u8 mc_en;               /* Nonzero if MC f/w is active */
>> >       int secvio_irq;         /* Security violation interrupt number */
>> > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
>> > 7f2b1101f567..a260981e0843 100644
>> > --- a/drivers/crypto/caam/jr.c
>> > +++ b/drivers/crypto/caam/jr.c
>> > @@ -511,10 +511,27 @@ static int caam_jr_probe(struct platform_device
>> > *pdev)
>> >       struct device_node *nprop;
>> >       struct caam_job_ring __iomem *ctrl;
>> >       struct caam_drv_private_jr *jrpriv;
>> > +     struct caam_drv_private *caamctrlpriv;
>> >       static int total_jobrs;
>> 
>> ugh.
> 
> Yes, I've seen that. At first, I even wanted to replace it with the
> ctrlpriv->total_jobrs,
> but decided not to do it in order to keep this patch focused.

Having the total_jobrs (and using it for anything else than messages)
static will create an unnecessary dependency on the correct probe
order.

>> >       struct resource *r;
>> >       int error;
>> >
>> > +     /* Before we proceed with the JR device probing, verify
>> > +      * that the job ring itself is available to Non-Secure world.
>> > +      * If the JR is owned exclusively by TZ - we should not even
>> > +      * process it further.
>> > +      */
>> > +     caamctrlpriv = dev_get_drvdata(pdev->dev.parent);
>> > +     if (!(caamctrlpriv->jobr_ns_flags & BIT(total_jobrs))) {
>> 
>> Is anything preventing from total_jobrs getting big? Can't we get rid 
>> of this static
>> variable somehow? Before this commit, it was just used for messages.
> 
> I guess not, the only limitation we have is the HW. Current imx8m mini 
> does have
> 3 Job Rings, and plus added one more. Since I do not have any 
> Layerscape HW -
> I cannot really tell if the number of instantiated Job Rings there is
> bigger than 8
> and would grow in the future.

For now the LS1028A has 4.

> I had a local implementation version with set_bit/test_bit variant, 
> perhaps that
> one would be more appropriate here. If it's OK - I can do that one and
> push it in V2.
> 
>> Can we check the TZ bit here instead of doing that bitflags dance?
> 
> Honestly, I had this implementation locally as well, but decided to go
> ahead with
> "the dance" in order not to access the registers of another module
> from this one.

Ahh I didn't notice that the register was part of the parent. Meh.

> Besides, the JR node loop in present caam_probe() got me tripped, as it 
> does an
> early lookup and analysis of JR child nodes and I found it a right
> place to analyze
> and record the JR availability.

I see. But we should really communicate whether the child should
return ENODEV in a different way. IMHO this static thing is really
fragile.

>> 
>> nitpick: in caam there are no netdev comments. So multiline comments 
>> look like:
>> /*
>>   * this is a comment.
>>   */
> 
> Noted, will be addressed in V2.
> 
>> 
>> > +             /* This job ring is marked to be exclusively used by TZ,
>> > +              * do not proceed with probing as the HW block is inaccessible.
>> > +              * Increment total seen JR devices since it is used as the index
>> > +              * into verification and fail probing for this node.
>> > +              */
>> > +             total_jobrs++;
>> > +             return -ENODEV;
>> > +     }
>> > +
>> >       jrdev = &pdev->dev;
>> >       jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
>> >       if (!jrpriv)
>> > diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
>> > index 3738625c0250..8ade617f9e65 100644
>> > --- a/drivers/crypto/caam/regs.h
>> > +++ b/drivers/crypto/caam/regs.h
>> > @@ -445,10 +445,12 @@ struct caam_perfmon {  };
>> >
>> >  /* LIODN programming for DMA configuration */
>> > -#define MSTRID_LOCK_LIODN    0x80000000
>> > -#define MSTRID_LOCK_MAKETRUSTED      0x00010000      /* only for JR
>> masterid */
>> > +#define MSTRID_LOCK_LIODN            BIT(31)
>> > +#define MSTRID_LOCK_MAKETRUSTED      BIT(16) /* only for JR: masterid */
>> > +#define MSTRID_LOCK_TZ_OWN           BIT(15) /* only for JR: owned by TZ */
>> > +#define MSTRID_LOCK_PRIM_TZ          BIT(4)  /* only for JR: Primary TZ */
>> 
>> can't find that one.
>> 
>> in general, does these marcros match with your reference manual? Which 
>> one do
>> you have?
> 
> I'm working on the imx8m mini, which has a v4.0 of CAAM, and this bit
> is defined in
> JR[0:2]DID_MS registers.
> 
> The map looks like following:
> LDID[31], USE_OUT[30], PRIM_ICID[29:19], LAMTD[17], AMTD[16],
> TZ_OWN[15], SDID_MS[14:5], PRIM_TZ[4], PRIM_DID[3:0]
> 
> Perhaps, there is a deviation here between what is instantiated in LS
> vs i.MX series.
> 
> At this point, I would also be interested to hear back from NXP on 
> this.

Probably, but that would also mean we'd have to distiguish
between these too. You're checking PRIM_TZ which is SDID
on the LS1028A (which is an arbitrary number if I understand
it correctly). So the check above might actually trigger although
it shouldn't.

That said, whats PRIM_TZ? When is it set?

>> for me the bits are named:
>> LICID[31], AMTD[16], TZ[15] and SDID[11:0] also the register is called 
>> JRnICID.
>> 
>> I wonder if the LS1028A has a newer/older CAAM version.
>> according to the device tree (fsl-ls1028a.dtsi) the sec is v5.0 (and 
>> also compatible
>> with v4.0). If you have a look at the RM it says 7.0 (at least the 
>> MAJ_VER in
>> SECVID_MS is 7 accoring to the manual; i haven't checked on the 
>> hardware for
>> now.
> 
> I've checked the imx8m mini HW, and it has reported:
> Major: 4
> Minor: 1
> Era: 9
> 
> I believe that the LS family has a newer version of CAAM instantiated, 
> which can
> be the reason on those register content deviations.

probably, but as said above, we'd then need to distiguish
between both. If you need to check PRIM_TZ which I haven't
fully understood for now.

> 
>> 
>> Horia, can you shed some light here.
> 
> +1
> 
>> 
>> > -#define MSTRID_LIODN_MASK    0x0fff
>> > +#define MSTRID_LIODN_MASK            GENMASK(11, 0)
>> >  struct masterid {
>> >       u32 liodn_ms;   /* lock and make-trusted control bits */
>> >       u32 liodn_ls;   /* LIODN for non-sequence and seq access */
>> >
>> > base-commit: 8a796a1dfca2780321755033a74bca2bbe651680
>> 
>> --
>> -michael
> 
> Link: [1]:
> http://patchwork.ozlabs.org/project/uboot/patch/20211026065554.29009-4-gaurav.jain@nxp.com/
> 
> -- andrey

-- 
-michael
