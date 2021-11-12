Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2475C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B1D60F93
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhKLS6w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 13:58:52 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42059 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhKLS6w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 13:58:52 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B6D9F22175;
        Fri, 12 Nov 2021 19:55:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636743359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U99PJCQZZ5zpoyE4qwQrz53lDrxzH5XwFqX+5bww1Mc=;
        b=oovzYZtaDzS9XvK0r6tBxBhHRB7emOHjBgNRJJ6FCDlidWpxPU9dvEyRzbG3hRe/8vGcaY
        PF29NHE9tGNiGfDP01wXutF/vP8NhnyKNfafU8dro2L3LydNg376I9j0WTlAh+jU4QTe7e
        Wtuim3ynNCuY3xw7ieH8uJRaCW4ry1Q=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Nov 2021 19:55:56 +0100
From:   Michael Walle <michael@walle.cc>
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - check jr permissions before probing
In-Reply-To: <AM6PR06MB4691AA866740AE4F82EDF9E9A6939@AM6PR06MB4691.eurprd06.prod.outlook.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <d5cf77b4734f9d60c8d61a2a0a799180@walle.cc>
 <AM6PR06MB4691A6F69B509EF6B4BFF466A68E9@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <6f8e16378f797b5c562c5dcbe26426b6@walle.cc>
 <AM6PR06MB4691C8617888887449FDF7A0A6919@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <bcceda0207b5176999eebe613fdd9510@walle.cc>
 <AM6PR06MB4691AA866740AE4F82EDF9E9A6939@AM6PR06MB4691.eurprd06.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <035984b4223dbab1db83592f9718014b@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrey,

Am 2021-11-10 10:33, schrieb ZHIZHIKIN Andrey:
>> -----Original Message-----
>> From: Michael Walle <michael@walle.cc>
>> >> First, thank you for taking the extra step here. Does "reserved for
>> >> HAB"
>> >> mean TF-A is using it or is the BootROM already using it. TF-A is
>> >> optional (so is HAB
>> >> I guess?). So it might be possible to have jr0 in linux, right? If
>> >> that is correct, the
>> >> solution to disable the jr0 at compile time is wrong.
>> >
>> > From what I've seen in the U-Boot and ATF code, it seems that the JR0
>> > is reserved
>> > by BootROM. When the execution reaches the ATF (after SPL) those bits
>> > are already
>> > set which concludes that the reservation is done quite early. Since
>> > current U-Boot
>> > does not have any support for CAAM integrated yet (patchset is under
>> > review) -
>> > it makes me believe that the reservation is done in BootROM.
>> 
>> Ok. I guess we have to wait for an answer from NXP. But it strikes as
>> odd that it there is no Secure World, you'll loose one job ring.
> 
> From HW perspective, the JR is not lost - it is just assigned to S 
> world.

I said its lost if there is no Secure World (which IMHO is still a valid
case). I mean if its already the BootROM which assign it 
(unconditionally)
and there will be no secure world later in the boot process, then its 
lost.

> This also provides an opportunity (at least for i.MX8M series) to issue
> transactions and create Trusted descriptors in S world for NS world.
> This is achieved by 2 sets of ICID/DID pairs, and this is where USE_OUT
> bit is actually used. This however is missing on the LS series (SRM 
> does
> not state this is implemented), which leaves LS with only one ICID/DID
> pair per ring.

But this would also be possible if the JR is only acquired later by
TF-A (or optee), no?

> From OS perspective however, I would totally agree - the JR is indeed
> lost, even if there is no software running that required S world.
> 
> The only description of process for control transfer from S to NS world
> I was able to find is described in LS1028A SRM section 12.2.2.3, which
> only details ring user re-assignment, but it does not detail whether
> TZ_OWN can participate in this process (set or reset), and this is also
> similar for i.MX8M family.
> 
>> 
>> > It is correct though: if the JR is not reserved - then it is
>> > accessible in Linux, hence
>> > compile-time disabling does not looked like a good solution to me.
>> 
>> Mh, I had a closer look at the IMX8M SRM (I don't have one for the
>> IMX8MM yet). It looks like secure world can reassign the Job Ring
>> to non-secure world though (unless LDID is set). If that is the
>> case I think, deciding at probe time if a job ring is available is
>> not correct; as it can be reassigned later.
> 
> That's exactly the culprit here: the LDID is not set on the JR 
> reserved.
> 
> This makes it possible for the code executing in S to transfer the JR 
> to NS.
> Practically, I do not see that this would happen though, as even the 
> NXP
> proposed to disable the node at compile time, which gives me an 
> indication
> that the transfer was never planned. This is however a dangerous 
> assumption
> I have to admit, and in the general case - this transfer can occur.
> 
> Moreover, from what I read in the SRM of both i.MX8MM and LS1028A -
> there is no lock that is imposed on TZ_OWN bit by setting the LDID (or 
> LICID
> for LS family).

I've noticed that too, but then assumed that because TZ_PRIM=1 implies
TZ_OWN=1 and the lock bit will lock TZ_PRIM then TZ_OWN must also be 1.
But that's not the case for LS SoCs.

> Would it be possible for you to tell which section of SRM provides a 
> description
> of the JR transfer you mentioned above?

I don't have access to the IMX8M SEC right now. If memory serves 
correctly,
I just saw that on an overview. But I just had a look at the 
LS1028ASECRM,
and there is "SEC's Job Ring interface can be independently assigned
(and re-assigned) to different users." (ch 12.2).

> As for probing of the JR node, then I believe it is rather the 
> opposite:
> deciding whether the JR is available during probing provides an 
> opportunity to
> bind the device later on when it would be released from S to NS world
> (provided that this would ever occur). However, keeping in mind that 
> there is
> no HW mechanism to indicate that the JR appears in NS world after the 
> boot
> and the user transfer should be done manually by some other SW entity - 
> later
> bind can also be performed there.

Sure, but it will also be the other way around, no? Like S world can
"steal" the JR from NS world. And thats what I'm worried about.

> The only difference to the current proposed solution would be to 
> examine the
> CAAM control register instead of the flag from JR while probing, and
> this is what
> I'm currently testing on my end.
> 
>> 
>> So maybe u-boot (or TF-A) should mark that node as disabled after
>> all.
> 
> If the U-Boot implementation would come up with similar dynamic 
> recognition -
> then it would not be necessary to disable the node there as well.
> 
> This would also ensure that if in later derivatives or ATF code updates 
> another
> JR would be reserved as well - there would be no need to change and 
> align DTB
> to it, as it would be dynamically recognized.

To be clear, I don't talk about dynamic behavior here. Just try to
determine where the JR should be disabled/removed from the DT. And
I'm assuming a static partition of the JRs between S and NS world.

To recap, NXP suggested to disabled it in the SoC dtsi in
u-boot. This depends on whether the BootROM actually assignes
it to S worlds and there is no way for u-boot to regain access
(assuming that u-boot or u-boot SPL will be started in EL3). If
it is not possible to reassign it to NS world, then the JR should
be disabled in linux and u-boot DTs. If there is a chance to
regain control and that there might be no TF-A at all, then
statically disable the JR in u-boot is wrong. Instead it should
be determined at runtime (again just static partitioning, no
dynamic reassignment).

I had a fixup at runtime of the DT (both the active DT in
u-boot as well as the DT passed from u-boot to linux) in
mind. Check the TZ_OWN bit and remove/disable the JR.

There is also an ongoing discussion where and how the DT will
be passed to u-boot and linux. So I might be the case that
TF-A will allocate one JR to itself and just pass u-boot the
DT where that JR is disabled or removed. Which might also
fit the "fixup" in u-boot.

>> If the BootROM is actually already assigning this to secure world
>> (and setting the lock bit LDID). Then it can also be removed from
>> the linux dtsi, because there is no way it can be assigned to linux
>> anyways.
> 
> As I've indicated above: the LDID bit is not set on this JR.

Ok, then u-boot should be able to reset the JR to its defaults
if its started in EL3 (and there is no TF-A at all), right?

>> >> >> > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
>> >> >> > index
>> >> >> > 7f2b1101f567..a260981e0843 100644
>> >> >> > --- a/drivers/crypto/caam/jr.c
>> >> >> > +++ b/drivers/crypto/caam/jr.c
>> >> >> > @@ -511,10 +511,27 @@ static int caam_jr_probe(struct
>> >> >> > platform_device
>> >> >> > *pdev)
>> >> >> >       struct device_node *nprop;
>> >> >> >       struct caam_job_ring __iomem *ctrl;
>> >> >> >       struct caam_drv_private_jr *jrpriv;
>> >> >> > +     struct caam_drv_private *caamctrlpriv;
>> >> >> >       static int total_jobrs;
>> >> >>
>> >> >> ugh.
>> >> >
>> >> > Yes, I've seen that. At first, I even wanted to replace it with the
>> >> > ctrlpriv->total_jobrs,
>> >> > but decided not to do it in order to keep this patch focused.
>> >>
>> >> Having the total_jobrs (and using it for anything else than messages)
>> >> static will
>> >> create an unnecessary dependency on the correct probe order.
>> >
>> > Yes, I've stumbled upon this logical problem myself as well.
>> >
>> > I'd decided that this should go, and would replace it with the option
>> > to use
>> > IRBAR_JRx as the indexing, since it has the address aligned and can be
>> > used as a bit index.
>> > - For LS1028A it would look like: IRBAR_JR[ring_id] >>  16
>> > - For i.MX8M series it would be: IRBAR_JR[ring_id] >>  12
>> >
>> > As those offsets are defined in the HW, they can be reliably used as
>> > indexing parameter
>> > to interrogate the CAAM if the JR is reserved for TZ or not.
>> >
>> > In addition, in order not to access the caam_ctrl register set from
>> > caam_jr driver, I'd still
>> > prefer to use a bitmask and compare the bits set against that new
>> > indexing. This would
>> > allow the driver to get rid of that static total_jobrs part at all.
>> >
>> > I would appreciate the community opinion on the approach above whether
>> > it is plausible
>> > and does not violate any kernel rules.
>> 
>> Will try to follow you here later.
> 
> I'm now working on a patchset that would supersede this one, and would
> include the dynamic indexing based on the JR address instead of that 
> static
> variable used. This would also allow to re-order JR nodes inside the 
> DTS and
> do not rely on the order of appearance.
> 
>> 
>> ..
>> 
>> >> >> in general, does these marcros match with your reference manual?
>> >> >> Which one do you have?
>> >> >
>> >> > I'm working on the imx8m mini, which has a v4.0 of CAAM, and this bit
>> >> > is defined in JR[0:2]DID_MS registers.
>> >> >
>> >> > The map looks like following:
>> >> > LDID[31], USE_OUT[30], PRIM_ICID[29:19], LAMTD[17], AMTD[16],
>> >> > TZ_OWN[15], SDID_MS[14:5], PRIM_TZ[4], PRIM_DID[3:0]
>> >> >
>> >> > Perhaps, there is a deviation here between what is instantiated in LS
>> >> > vs i.MX series.
>> >> >
>> >> > At this point, I would also be interested to hear back from NXP on
>> >> > this.
>> >>
>> >> Probably, but that would also mean we'd have to distiguish between
>> >> these too.
>> >> You're checking PRIM_TZ which is SDID on the LS1028A (which is an
>> >> arbitrary
>> >> number if I understand it correctly). So the check above might
>> >> actually trigger
>> >> although it shouldn't.
>> >
>> > It's maybe the opposite though: on the LS1028A if the TZ is set, then
>> > NS would
>> > read SDID as all 0's. This presents the problem that PRIM_TZ bit
>> > defined for i.MX8M
>> > series would read as 0 on LS series and fail the reservation check.
>> 
>> I don't think you have to take the PRIM_TZ bit into account. PRIM_TZ=1
>> implies OWN_TZ=1. (I'm not sure what PRIM_TZ=0 and OWN_TZ=1 is good
>> for though). But as mentioned above, I'm not convinced that deciding
>> at probe time is the solution here.
> 
> From what I read, PRIM_TZ bit is mixed into the SDID and also "locks" 
> JR
> register interface to S world. Setting PRIM_TZ=0 and TZ_OWN=1 has
> primarily an influence of SDID construction, this is outlined in 
> JRsDID_MS
> register description.
> 
>> 
>> > At this point I'd really like someone from NXP to comment on it,
>> > specifically: is it enough
>> > to just check the TZ bit for all families to recognize that JR is
>> > reserved for usage in
>> > Secure world only?
>> 
>> yep.
> 
> I've compared both i.MX8M and LS family SRMs, and looks like the
> OWN_TZ bit is the only unification point here that can be verified.
> 
> I 'm currently testing the implementation where only that bit is
> checked and so far I have good results. I would post a V2 as a series
> and supersede this patch, where only that check would be included.
> 
>> 
>> >>
>> >> That said, whats PRIM_TZ? When is it set?
>> >
>> > It is set together with TZ_OWN early at the boot and is used for
>> > several purposes, namely:
>> > to derive SDID_MS (it is done dynamically), and also to indicate that
>> > the access to that JR
>> > registers (config, interrupt, buffers, etc.) are only possible from
>> > Secure World.
>> 
>> Thanks, I also read the SRM for this bit, right now.
>> 
>> -michael

-- 
-michael
