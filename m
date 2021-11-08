Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D8DC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Nov 2021 16:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B616108B
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Nov 2021 16:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbhKHQPu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Nov 2021 11:15:50 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:56689 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhKHQPu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Nov 2021 11:15:50 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 987C722205;
        Mon,  8 Nov 2021 17:13:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636387984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POvg+BNL8NwXSzoRJKTqHI/1qXD2AMb5vY8D+/30P9o=;
        b=shyodCA3ds4woFmwTQ6T391pahpgLah+ikz5qkQ1m5plo/AB2GpXzF0YjwFiw9oYsHRnpu
        9AtmAcTN2wSgqwgzgy03AcUQt/R/+9OFHCSzZ/6rTRaA9kZaNQZSssASqXtH6LHb7HIAiE
        e9oIpmG+LalbM5jU5aEAVSE9Kkt4FxA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Nov 2021 17:13:02 +0100
From:   Michael Walle <michael@walle.cc>
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - check jr permissions before probing
In-Reply-To: <AM6PR06MB4691C8617888887449FDF7A0A6919@AM6PR06MB4691.eurprd06.prod.outlook.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <d5cf77b4734f9d60c8d61a2a0a799180@walle.cc>
 <AM6PR06MB4691A6F69B509EF6B4BFF466A68E9@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <6f8e16378f797b5c562c5dcbe26426b6@walle.cc>
 <AM6PR06MB4691C8617888887449FDF7A0A6919@AM6PR06MB4691.eurprd06.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <bcceda0207b5176999eebe613fdd9510@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrey,

>> First, thank you for taking the extra step here. Does "reserved for 
>> HAB"
>> mean TF-A is using it or is the BootROM already using it. TF-A is 
>> optional (so is HAB
>> I guess?). So it might be possible to have jr0 in linux, right? If 
>> that is correct, the
>> solution to disable the jr0 at compile time is wrong.
> 
> From what I've seen in the U-Boot and ATF code, it seems that the JR0
> is reserved
> by BootROM. When the execution reaches the ATF (after SPL) those bits
> are already
> set which concludes that the reservation is done quite early. Since
> current U-Boot
> does not have any support for CAAM integrated yet (patchset is under 
> review) -
> it makes me believe that the reservation is done in BootROM.

Ok. I guess we have to wait for an answer from NXP. But it strikes as
odd that it there is no Secure World, you'll loose one job ring.

> It is correct though: if the JR is not reserved - then it is
> accessible in Linux, hence
> compile-time disabling does not looked like a good solution to me.

Mh, I had a closer look at the IMX8M SRM (I don't have one for the
IMX8MM yet). It looks like secure world can reassign the Job Ring
to non-secure world though (unless LDID is set). If that is the
case I think, deciding at probe time if a job ring is available is
not correct; as it can be reassigned later.

So maybe u-boot (or TF-A) should mark that node as disabled after
all.

If the BootROM is actually already assigning this to secure world
(and setting the lock bit LDID). Then it can also be removed from
the linux dtsi, because there is no way it can be assigned to linux
anyways.

..

>> >> > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
>> >> > index
>> >> > 7f2b1101f567..a260981e0843 100644
>> >> > --- a/drivers/crypto/caam/jr.c
>> >> > +++ b/drivers/crypto/caam/jr.c
>> >> > @@ -511,10 +511,27 @@ static int caam_jr_probe(struct
>> >> > platform_device
>> >> > *pdev)
>> >> >       struct device_node *nprop;
>> >> >       struct caam_job_ring __iomem *ctrl;
>> >> >       struct caam_drv_private_jr *jrpriv;
>> >> > +     struct caam_drv_private *caamctrlpriv;
>> >> >       static int total_jobrs;
>> >>
>> >> ugh.
>> >
>> > Yes, I've seen that. At first, I even wanted to replace it with the
>> > ctrlpriv->total_jobrs,
>> > but decided not to do it in order to keep this patch focused.
>> 
>> Having the total_jobrs (and using it for anything else than messages) 
>> static will
>> create an unnecessary dependency on the correct probe order.
> 
> Yes, I've stumbled upon this logical problem myself as well.
> 
> I'd decided that this should go, and would replace it with the option 
> to use
> IRBAR_JRx as the indexing, since it has the address aligned and can be
> used as a bit index.
> - For LS1028A it would look like: IRBAR_JR[ring_id] >>  16
> - For i.MX8M series it would be: IRBAR_JR[ring_id] >>  12
> 
> As those offsets are defined in the HW, they can be reliably used as
> indexing parameter
> to interrogate the CAAM if the JR is reserved for TZ or not.
> 
> In addition, in order not to access the caam_ctrl register set from
> caam_jr driver, I'd still
> prefer to use a bitmask and compare the bits set against that new
> indexing. This would
> allow the driver to get rid of that static total_jobrs part at all.
> 
> I would appreciate the community opinion on the approach above whether
> it is plausible
> and does not violate any kernel rules.

Will try to follow you here later.

..

>> >> in general, does these marcros match with your reference manual?
>> >> Which one do you have?
>> >
>> > I'm working on the imx8m mini, which has a v4.0 of CAAM, and this bit
>> > is defined in JR[0:2]DID_MS registers.
>> >
>> > The map looks like following:
>> > LDID[31], USE_OUT[30], PRIM_ICID[29:19], LAMTD[17], AMTD[16],
>> > TZ_OWN[15], SDID_MS[14:5], PRIM_TZ[4], PRIM_DID[3:0]
>> >
>> > Perhaps, there is a deviation here between what is instantiated in LS
>> > vs i.MX series.
>> >
>> > At this point, I would also be interested to hear back from NXP on
>> > this.
>> 
>> Probably, but that would also mean we'd have to distiguish between 
>> these too.
>> You're checking PRIM_TZ which is SDID on the LS1028A (which is an 
>> arbitrary
>> number if I understand it correctly). So the check above might 
>> actually trigger
>> although it shouldn't.
> 
> It's maybe the opposite though: on the LS1028A if the TZ is set, then 
> NS would
> read SDID as all 0's. This presents the problem that PRIM_TZ bit
> defined for i.MX8M
> series would read as 0 on LS series and fail the reservation check.

I don't think you have to take the PRIM_TZ bit into account. PRIM_TZ=1
implies OWN_TZ=1. (I'm not sure what PRIM_TZ=0 and OWN_TZ=1 is good
for though). But as mentioned above, I'm not convinced that deciding
at probe time is the solution here.

> At this point I'd really like someone from NXP to comment on it,
> specifically: is it enough
> to just check the TZ bit for all families to recognize that JR is
> reserved for usage in
> Secure world only?

yep.

>> 
>> That said, whats PRIM_TZ? When is it set?
> 
> It is set together with TZ_OWN early at the boot and is used for
> several purposes, namely:
> to derive SDID_MS (it is done dynamically), and also to indicate that
> the access to that JR
> registers (config, interrupt, buffers, etc.) are only possible from
> Secure World.

Thanks, I also read the SRM for this bit, right now.

-michael
