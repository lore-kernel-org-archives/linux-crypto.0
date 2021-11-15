Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984A9C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 11:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A9661C15
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 11:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhKOLnr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 06:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhKOLnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 06:43:06 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3F4C061766;
        Mon, 15 Nov 2021 03:40:05 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 95C6E22221;
        Mon, 15 Nov 2021 12:40:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636976404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k41bvqxzSbzpYpfyJbiT/KOBKfF0FJKxqyJz5IGzWdQ=;
        b=R62YyvqHvKYIIZ6Pmc7+BUgIXXv/sCDlqU1EcA0oUqDsnzTLh/PavO9ixGAKz2IezJWWta
        MEWbnwwHRgs2J8XS2m4BECpP1twEyFg3+oKV3OUEem/QIHULztNM/ynFsWX64fNO44KW06
        wUs35Vh34i4axM5AxF0WIsL3mB5l9E8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Nov 2021 12:40:03 +0100
From:   Michael Walle <michael@walle.cc>
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - check jr permissions before probing
In-Reply-To: <AM6PR06MB4691883CF12D1ADCA918D588A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <d5cf77b4734f9d60c8d61a2a0a799180@walle.cc>
 <AM6PR06MB4691A6F69B509EF6B4BFF466A68E9@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <6f8e16378f797b5c562c5dcbe26426b6@walle.cc>
 <AM6PR06MB4691C8617888887449FDF7A0A6919@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <bcceda0207b5176999eebe613fdd9510@walle.cc>
 <AM6PR06MB4691AA866740AE4F82EDF9E9A6939@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <035984b4223dbab1db83592f9718014b@walle.cc>
 <AM6PR06MB4691883CF12D1ADCA918D588A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <edca5c53c31b53e0121566fa20f8a6d1@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>> > As for probing of the JR node, then I believe it is rather the
>> > opposite:
>> > deciding whether the JR is available during probing provides an
>> > opportunity to bind the device later on when it would be released from
>> > S to NS world (provided that this would ever occur). However, keeping
>> > in mind that there is no HW mechanism to indicate that the JR appears
>> > in NS world after the boot and the user transfer should be done
>> > manually by some other SW entity - later bind can also be performed
>> > there.
>> 
>> Sure, but it will also be the other way around, no? Like S world can 
>> "steal" the JR
>> from NS world. And thats what I'm worried about.
> 
> This is actually the key point, and I neglected this a bit completely
> unintentionally.
> 
> If the software entity running in S World would like to reclaim the JR
> from Kernel,
> then it can do so at any given point of time. This for sure should be
> carefully crafted
> according to "Ring user (re-)assignment procedure" described in SRM,
> but what this
> would mean in practice for the Kernel is: any crypto operation running
> inside that JR
> would either complete or be abrupted. Once S World entity would reclaim 
> the JR,
> the NS Word software entity should unbind the JR and stop using it
> while submitting
> operations for CAAM Algos.
> 
> There is a conceptual problem here with this scenario, namely: S World
> should notify
> the NS World that a particular resource (JR in our case) is reserved
> and should not be
> used at all. AFAIK this mechanism is not present, and until it is not
> there - there
> would be no chance to realize that the JR is gone.
> 
> Please note, that this patch (and consecutive V2 series) are not
> addressing above
> problem and was never intended to. The scenario you're talking about
> is a part of
> a bigger task, which is separate from what this patch covers.

I didn't imply that it should, I just questioning wether we should
blindly trust the DT (and that would mean someone, i.e. u-boot
have to dynamically patch it) or we we shouldn't trust it and the
kernel should figure it out on its own (this patch).

Do you know if there are any drivers in linux doing the latter?


> Just to make it clear: this patch (and consecutive V2 series) tried to
> address the
> functionality to dynamically identify which JR is not available for NS
> World at the
> Kernel boot and mark them accordingly. This allows that different
> derivatives that
> have CAAM HW IP to have any JR reserved, and would not require no 
> changes in
> DTB to have a node disabled.
> 
> There are several key components running in S World before Kernel 
> (BootROM, SPL,
> ATF, OP-TEE) and they all can have JR reserved. If any of those
> software instances
> reserve the JR - then currently it should disable it in the DTB as
> well. This patch allows
> them not to do so, and moving the identification logic into the Kernel
> to dynamically
> figure out which resources are there to use.

And this is exactly what I'm worried about (or lets say unsure).
Whether we shouldn't trust the DT.

>> > The only difference to the current proposed solution would be to
>> > examine the CAAM control register instead of the flag from JR while
>> > probing, and this is what I'm currently testing on my end.
>> >
>> >>
>> >> So maybe u-boot (or TF-A) should mark that node as disabled after
>> >> all.
>> >
>> > If the U-Boot implementation would come up with similar dynamic
>> > recognition - then it would not be necessary to disable the node there
>> > as well.
>> >
>> > This would also ensure that if in later derivatives or ATF code
>> > updates another JR would be reserved as well - there would be no need
>> > to change and align DTB to it, as it would be dynamically recognized.
>> 
>> To be clear, I don't talk about dynamic behavior here. Just try to 
>> determine
>> where the JR should be disabled/removed from the DT. And I'm assuming 
>> a static
>> partition of the JRs between S and NS world.
> 
> As I've written above, I believe it would be hard to rely on static 
> partitioning
> between S and NS Worlds, as we have several S World agents in the game
> before Kernel starts. They either should have a clean contract to 
> establish this
> partitioning, or Kernel should be able to see which of those JRs are
> not available.
> This patch addresses the later since we do not have any rules regarding 
> the
> partitioning contract.

But isn't the contract the device tree?

>> To recap, NXP suggested to disabled it in the SoC dtsi in u-boot. This 
>> depends on
>> whether the BootROM actually assignes it to S worlds and there is no 
>> way for u-
>> boot to regain access (assuming that u-boot or u-boot SPL will be 
>> started in EL3).
>> If it is not possible to reassign it to NS world, then the JR should 
>> be disabled in
>> linux and u-boot DTs. If there is a chance to regain control and that 
>> there might
>> be no TF-A at all, then statically disable the JR in u-boot is wrong. 
>> Instead it should
>> be determined at runtime (again just static partitioning, no dynamic
>> reassignment).
> 
> Just to add: this proposal was done for i.MX8M Mini SoC only, which
> does not cover
> all other derivatives implementing CAAM.
> 
> I assume that if we go with DTB approach - all other derivatives
> should be revised
> and reserve nodes appropriate.

Yes, and I disagree how this is implemented in u-boot right now (or is
proposed) because its yet again the simple and fast solution. I still
think this should be done at runtime and the node should be disabled if
it looks like its not available. that is, it should do the same as you
are doing here. If there is some software in S world taking over the
JR sometime later, then the code in u-boot has to be revised (or the
device tree for this particular board has to be adapted).

>> I had a fixup at runtime of the DT (both the active DT in u-boot as 
>> well as the DT
>> passed from u-boot to linux) in mind. Check the TZ_OWN bit and 
>> remove/disable
>> the JR.
>> 
>> There is also an ongoing discussion where and how the DT will be 
>> passed to u-
>> boot and linux. So I might be the case that TF-A will allocate one JR 
>> to itself and
>> just pass u-boot the DT where that JR is disabled or removed. Which 
>> might also fit
>> the "fixup" in u-boot.
> 
> Yes, but in this case - all derivatives should have this done, right?

with derivatives you mean SoCs implementing CAAM? I thought of something
along the following:

ofnode_foreach_compatible_node(node, "fsl,sec-v4.0-job-ring") {
     if (caam_jr_is_unavailable())
         ofnode_set_enabled(node, false);
}

in the common dt_fixup for the SoC. So yes, this should be called for
all the SoCs which could have a CAAM. And it should also probably be
done for the control DT in u-boot.

> I'm not sure how
> this can be enforced, and also not sure how to keep this up in the 
> future...

I can't follow you here.

>> >> If the BootROM is actually already assigning this to secure world
>> >> (and setting the lock bit LDID). Then it can also be removed from the
>> >> linux dtsi, because there is no way it can be assigned to linux
>> >> anyways.
>> >
>> > As I've indicated above: the LDID bit is not set on this JR.
>> 
>> Ok, then u-boot should be able to reset the JR to its defaults if its 
>> started in EL3
>> (and there is no TF-A at all), right?
> 
> It can, if the CAAM driver finally lands in U-Boot and this 
> functionality is
> implemented in that driver. So far, both of those is not covered...
> 
> What I've just seen in V5 patch series for CAAM support in U-Boot [1],
> there is a dynamic reservation provisioned in SPL for any arbitrary JR 
> number.
> Therefore, I believe this patch makes total sense to isolate Kernel and 
> verify
> which JR is available at boot.

I still have to look at v5. but the one mail I got didn't look very
promising, as it says "we go with the "-u-boot.dtsi" approach
and just one jobring statically.

-michael
