Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66FEC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 16:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72FCF2173C
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 16:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sprO87q5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfBZQY0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Feb 2019 11:24:26 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:33092 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfBZQY0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Feb 2019 11:24:26 -0500
Received: by mail-ot1-f50.google.com with SMTP id q24so11624637otk.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 Feb 2019 08:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ii8t6GKeRyGLfcZ/XbGuPEBUo/LuML9Hzxpk6otHcUo=;
        b=sprO87q5UYZq+CJF9xjKoBHGpcYEJts2ZRrq6tfutWNE08ztfLLMJBjnNiurt/lyc2
         YRdC2ykKhJHBR547V5s5jekv1sDJacXl8QmA6qCCBRFOLdAm3MudqjJ07DOzdmk0gXUt
         C9UafHM+rn9qaQFLV2H0marX6shsdDQ+s8aTdSbCQ5kG/UKGXK3Ti41NstdAmDthYyNM
         qAh2PlHdHhSA4VkX+rGpFNrRLcGm1KNrH8sFfBE4almZH0YgFLxTh2tVkSAFHpsOadVL
         SXnPltP05Z+T1p4OreA9SCwMp/TokzybWBc1uHSdl5a8WWfPbuDCSjwi4Z/urkuJf5ag
         QoNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ii8t6GKeRyGLfcZ/XbGuPEBUo/LuML9Hzxpk6otHcUo=;
        b=jqPsOWWUhs98DqDMmrQB8SrTznxBSkYzlbV+uQ2OXJc9ln0fH0/Z5UGo8Kkvqqxb9n
         sVjt1i6fxzgdw6W1ElQHSLMXI+Aia3o3UwbK7vT0ELEsYF2WhRNQ1Bdw1wH12kgFJBcm
         CBpBtVabDOxyJtbyc+1p0upmDtL6ZqUoR1Nl0PD99Xb9D4XIcij4IWXLZnAhLxvhJpDM
         PW/Doli2zbta3gSqFDJAHUdzN4/4l+0/CsrtH0jkWNJJ6q5IoUqaLIDIpCDsytwpsqeh
         ZpeQI2t6JxEYwGAmAFENoKg5KU8jQD8EM96aKNNjzSjoB9kvPlsLllUMueWv3NfWEiBg
         /frw==
X-Gm-Message-State: AHQUAuY1WgMpSmJ2EDuzrnfnOVl7lZOYZx99sa4ujn5betsU32vhMPgp
        hRh+Tq5SM0fg9MeqN9IeWVl3SkxPoekZ8t+SZYFOF5+LMp8=
X-Google-Smtp-Source: AHgI3IbP0o3VpInj9EyXEN/BgEPC9/gkD1IUZYAEjpbCu5usb3fGeafvHxJ0X0AjtGRgwy9KDMqk8mBCg4vgHWp61R4=
X-Received: by 2002:a9d:6c48:: with SMTP id g8mr10763647otq.268.1551198265554;
 Tue, 26 Feb 2019 08:24:25 -0800 (PST)
MIME-Version: 1.0
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <20190222100613.2290-5-christopher.spencer@sea.co.uk> <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRTvXVU7vRicF=mR7xxCj=p+Sqj3aNnL2TezLZXhHFkvzA@mail.gmail.com> <VI1PR0402MB34857504705A898A59085B4B987B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34857504705A898A59085B4B987B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Tue, 26 Feb 2019 16:24:13 +0000
Message-ID: <CAGUNXRRcaiGAaKkUs2Tw_aZD4QKHtJMFLwkfu92pMu3jCBo5gw@mail.gmail.com>
Subject: Re: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 26 Feb 2019 at 14:53, Horia Geanta <horia.geanta@nxp.com> wrote:
> On 2/25/2019 4:37 PM, Chris Spencer wrote:
> > On Mon, 25 Feb 2019 at 14:22, Horia Geanta <horia.geanta@nxp.com> wrote:
> >>
> >> On 2/22/2019 12:07 PM, spencercw@gmail.com wrote:
> >>> From: Chris Spencer <christopher.spencer@sea.co.uk>
> >>>
> >>> This is required to support the i.MX8.
> >>>
> >> Why exactly is this required?
> >> You should provide more details.
> >
> > I don't know. :) These changes were made in [1], although the change
> > is actually described in [2] where it says: "Use a Job ring for RNG
> > instantiation rather than DECO, even for i.MX6/7 families." This does
> > indeed seem to be necessary to get it to work, but I can only
> > speculate why.
> >
> The commit messages you refer are indeed rather poor, however you need to
> understand the context: the history reflects NXP internal development.
>
> It's expected for the changes to be clearly explained, justified when reaching
> mainline kernel.

Ok, I will expand the commit message for the next version.

> > The original commit which added the run_descriptor_deco0 function [3]
> > states "[...] and another function that performs the running of the
> > said descriptor using the DECO debug mechanism." My best guess is that
> > the DECO debug mechanism is no longer available so it has to go via
> > the job ring.
> >
> This change is actually orthogonal to i.MX8 MQ support and is related to
> SECO-based i.MX8 SoCs (QXP, QM) and/or OP-TEE support.
>
> Access to CAAM global registers (CCSR page 0) won't be allowed in cases when
> Linux runs in Normal World.
> From this perspective, it makes sense to eliminate accesses to these registers.
> Some of the accesses are done for RNG initialization via the DECO debug
> mechanism; to remove them, RNG is initialized via the Job Ring interface.
> However, I still see some illegal accesses - for e.g. reading RDSTA register to
> check which virtual RNGs ("state handles" in RM terms) are already initialized.
>
> It looks like cutting access to CAAM global registers must come with some
> assumptions (since it implies some checks can no longer be performed, see RDSTA
> above).
> For e.g. in case OP-TEE is detected, we could assume that RNG was already
> initialized. Similar for other cases like SECO f/w (i.MX8 QM and QXP).
> If we make this assumption, it actually means RNG initialization is no longer
> needed:
>
> if (!ctrlpriv->mc_en && rng_vid >= 4 && !normal_world) {
>         ... // rng init as before - using DECO debug mechanism
> }

Thanks for the information. This is more problematic than I had
anticipated. It sounds like these are the possible scenarios:

1. Linux is running in the normal world without OP-TEE/SECO; RNG must
be initialised via the job ring. No way of checking whether the RNG is
already initialised.
2. Linux is running in the normal world with OP-TEE/SECO; RNG
initialisation is not required.
3. Linux is running in the secure world without OP-TEE/SECO; RNG can
be initialised via DECO debug mechanism or job ring.
4. Linux is running in the secure world with OP-TEE/SECO; RNG
initialisation is not required. This sounds like a very unlikely
configuration.

My build is currently sitting in scenario 1, which would explain why
the RNG initialisation via DECO was failing. Clearly it can be made to
work by running the initialisation via the job ring and assuming the
RNG has not already been initialised, but I'm getting the impression
that this may not be a sensible configuration.

Is running Linux in the secure world a typical configuration? It's not
a conscious choice I've made to run it in the normal world; that's
just what the TF-A is doing. I suppose it's either that or start using
OP-TEE so it can initialise the RNG.

As far as driver support goes, are we only interested in scenarios 2
and 3? I'm not really sure how we would detect which world we are
running in, or whether OP-TEE has initialised the RNG.

Thanks,
Chris
