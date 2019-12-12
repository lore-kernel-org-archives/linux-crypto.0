Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60194C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C65721655
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XiZKyVtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfLLOED (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:04:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41052 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbfLLOEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 09:04:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so2850472wrw.8
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 06:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YadRPUKRq+F+OfrkUFp7sfL3GGaSi5RtCx1mrcXaajw=;
        b=XiZKyVtF24JXNcMYL8Xwe6LFXRC5rGLAOXIUebbHSaeHrG07WKUNr8RJwQ823LolID
         XnFR2jJK+OvfWeKwOzAJUnPI+UDjOIOAgaUxlmeNOgEYTjulFbraIKmKbxd3ld4BJepg
         G8B4irn4mFBPM4Zu1GzyaWBuarsTxkULoMSdz25SJyyVexc+thf8CLbZtfVE9FbRTaOh
         07zSU07GZuRh33XLh0EaBWoqfCLw6SwC7WrBpEUnaHaZ6x4A62aUKnANPqKliM4Y0vez
         uxK2fzumLw0PuinGG6OouRcXDf86rYM3J9sV+PomXgyY3qXZ+pLRC39ja+f/oDQUrtUn
         HCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YadRPUKRq+F+OfrkUFp7sfL3GGaSi5RtCx1mrcXaajw=;
        b=QENSq9EeQTYBkrz2D6geJQDdLLbUC/SkkJ8OnxJ0nFgu+e/YMysmJSvTo+qm2EY4uk
         u6ZKUG1CPDLjExRstKwN/B4yjXE2Rg0M8KvTe8KoZu9UM1vhBGOrdv9dfAtqbQOMlz93
         mVy4Pey/DUIsGmnqR1eZXliQ5RQ60DottORzg+TUFZxe8EF0nQVO7+Fs4Pxj+e28UUDN
         hFriBYBNLdMhDFq566m6gO/gBVr9SHIe1HXK3zioiVAlwAJ35bCbYZt+Sr9mGic0mzm4
         nMVgykucUgW4b05UVr5IR1JqRXDP+Jl6XrTQplx96DAuuNeRapspYZOFfTuUi9NLeTPn
         Li8A==
X-Gm-Message-State: APjAAAXiTaMGNX806gb5aqyLH9vG/JM7qFMoDlmckWglVIFFoSzul0gr
        4nDszBwqOpoaGZ4E0SOKJu8L+HL04FJ3dNmpBIu0RQ==
X-Google-Smtp-Source: APXvYqyP/fsTNrCsT+L04hV7mtxjhyRS7l6whdWu7iB4pHI+wGkJkmQ7EMGzQOTq1HesEWkup/WBxhYzqcz5ap1GBSE=
X-Received: by 2002:a5d:6652:: with SMTP id f18mr6737640wrw.246.1576159437310;
 Thu, 12 Dec 2019 06:03:57 -0800 (PST)
MIME-Version: 1.0
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
 <1574864578-467-4-git-send-email-neal.liu@mediatek.com> <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
 <1575027046.24848.4.camel@mtkswgap22> <CAKv+Gu_um7eRYXbieW7ogDX5mmZaxP7JQBJM9CajK+6CsO5RgQ@mail.gmail.com>
 <20191202191146.79e6368c@why> <299029b0-0689-c2c4-4656-36ced31ed513@gmail.com>
 <b7043e932211911a81383274e0cc983d@www.loen.fr> <1576127609.27185.8.camel@mtkswgap22>
 <a5982b8ed10440eef14c04df6e6060b6@www.loen.fr>
In-Reply-To: <a5982b8ed10440eef14c04df6e6060b6@www.loen.fr>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 12 Dec 2019 15:03:42 +0100
Message-ID: <CAKv+Gu9YhkzpKbrxa=xDOkS6=kZSMaidor_4DqGY6f1M0tO7kQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
To:     Marc Zyngier <maz@kernel.org>
Cc:     Neal Liu <neal.liu@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        DTML <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sean Wang <sean.wang@kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?B?Q3J5c3RhbCBHdW8gKOmDreaZtik=?= <crystal.guo@mediatek.com>,
        Will Deacon <will@kernel.org>, Lars Persson <lists@bofh.nu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 12 Dec 2019 at 12:45, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2019-12-12 05:13, Neal Liu wrote:
> > On Tue, 2019-12-03 at 11:17 +0000, Marc Zyngier wrote:
> >> On 2019-12-03 04:16, Florian Fainelli wrote:
> >> > On 12/2/2019 11:11 AM, Marc Zyngier wrote:
> >> >> On Mon, 2 Dec 2019 16:12:09 +0000
> >> >> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >> >>
> >> >>> (adding some more arm64 folks)
> >> >>>
> >> >>> On Fri, 29 Nov 2019 at 11:30, Neal Liu <neal.liu@mediatek.com>
> >> >>> wrote:
> >> >>>>
> >> >>>> On Fri, 2019-11-29 at 18:02 +0800, Lars Persson wrote:
> >> >>>>> Hi Neal,
> >> >>>>>
> >> >>>>> On Wed, Nov 27, 2019 at 3:23 PM Neal Liu
> >> <neal.liu@mediatek.com>
> >> >>>>> wrote:
> >> >>>>>>
> >> >>>>>> For MediaTek SoCs on ARMv8 with TrustZone enabled,
> >> peripherals
> >> >>>>>> like
> >> >>>>>> entropy sources is not accessible from normal world (linux)
> >> and
> >> >>>>>> rather accessible from secure world (ATF/TEE) only. This
> >> driver
> >> >>>>>> aims
> >> >>>>>> to provide a generic interface to ATF rng service.
> >> >>>>>>
> >> >>>>>
> >> >>>>> I am working on several SoCs that also will need this kind of
> >> >>>>> driver
> >> >>>>> to get entropy from Arm trusted firmware.
> >> >>>>> If you intend to make this a generic interface, please clean
> >> up
> >> >>>>> the
> >> >>>>> references to MediaTek and give it a more generic name. For
> >> >>>>> example
> >> >>>>> "Arm Trusted Firmware random number driver".
> >> >>>>>
> >> >>>>> It will also be helpful if the SMC call number is
> >> configurable.
> >> >>>>>
> >> >>>>> - Lars
> >> >>>>
> >> >>>> Yes, I'm trying to make this to a generic interface. I'll try
> >> to
> >> >>>> make
> >> >>>> HW/platform related dependency to be configurable and let it
> >> more
> >> >>>> generic.
> >> >>>> Thanks for your suggestion.
> >> >>>>
> >> >>>
> >> >>> I don't think it makes sense for each arm64 platform to expose
> >> an
> >> >>> entropy source via SMC calls in a slightly different way, and
> >> model
> >> >>> it
> >> >>> as a h/w driver. Instead, we should try to standardize this, and
> >> >>> perhaps expose it via the architectural helpers that already
> >> exist
> >> >>> (get_random_seed_long() and friends), so they get plugged into
> >> the
> >> >>> kernel random pool driver directly.
> >> >>
> >> >> Absolutely. I'd love to see a standard, ARM-specified,
> >> virtualizable
> >> >> RNG that is abstracted from the HW.
> >> >
> >> > Do you think we could use virtio-rng on top of a modified
> >> virtio-mmio
> >> > which instead of being backed by a hardware mailbox, could use
> >> > hvc/smc
> >> > calls to signal writes to shared memory and get notifications via
> >> an
> >> > interrupt? This would also open up the doors to other virtio uses
> >> > cases
> >> > beyond just RNG (e.g.: console, block devices?). If this is
> >> > completely
> >> > stupid, then please disregard this comment.
> >>
> >> The problem with a virtio device is that it is a ... device. What we
> >> want
> >> is to be able to have access to an entropy source extremely early in
> >> the
> >> kernel life, and devices tend to be available pretty late in the
> >> game.
> >> This means we cannot plug them in the architectural helpers that Ard
> >> mentions above.
> >>
> >> What you're suggesting looks more like a new kind of virtio
> >> transport,
> >> which is interesting, in a remarkably twisted way... ;-)
> >>
> >> Thanks,
> >>
> >>          M.
> >
> > In conclusion, is it helpful that hw_random has a generic interface
> > to
> > add device randomness by talking to hwrng which is implemented in the
> > firmware or the hypervisor?
> > For most chip vendors, I think the answer is yes. We already prepared
> > a
> > new patchset and need you agree with this idea.
>
> As long as it is a *unified* interface, I'm all for that.
>


Yeah, but I'm not sure it makes sense to model it as a device like
this. It would be nice if we could tie this into the ARM SMCCC
discovery, and use the SMC calls to back arch_get_random_seed_long()
[provided we fix the braindead way in which that is being used today
in the interrupt code]
