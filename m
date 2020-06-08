Return-Path: <SRS0=nn+h=7V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF36C433E2
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 07:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287082076A
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 07:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uLi1Rmjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgFHHtd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 03:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbgFHHtb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 03:49:31 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84471C08C5C3
        for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2020 00:49:29 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u16so9607267lfl.8
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2020 00:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=37K4gneCiuRGulLCKf4ynFvMW4e68flpa0GiDzEnHyg=;
        b=uLi1RmjhtH1FlDsw82tNk1UEqMah3505zWAqYW0iJnhsR3ofTEhFjqgg0bqVnddqZT
         wAxQu3f3tLu0IjoYRj/q5xCx5ttN12X/9cS1LPWtvPhLhxvS2znXsVPeT1APIbqa6lNe
         A4/si6/ECFxjTPLdooQi+BUYuS9FxroIrzWRnwuzUiDLj5axLDtmFK/fgmAKdII++gN0
         8H+slUd3WPMJbncGutqkddXFKaG9mJrXn4b9AcUYLERHHIRVN1uuOFicsU96UPRjItfA
         1eA5C+72CB02PbahRX0V2G87TOjsr01aUEtMLxh5bPLhc8KL2wa6RaC1xoAyU4lcJ6mb
         7heQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=37K4gneCiuRGulLCKf4ynFvMW4e68flpa0GiDzEnHyg=;
        b=ERjOcKRW+HJKau06LglOc34+k26o3nMxWppPHEcVxiYJ2P/WJWSj+ZZmtZWvH0bCJH
         vRfc9BaE+zu2wt+Ua7A2qcc0K9BgQpi6TQjxi/i/dHCCJVQA7BoNWato0PQEtlbnLLkD
         B1JzeiBZuKyVsjJknE21XHvFp/nZJqavrChXpk8arkzKmJbpjO1sPSVLFDqb6UHJYc0E
         nKjP9Tb+FWV/SqiI1uOjJWD9wr3lODV3hmihvlTLoxCnW25AokubMMkKcDf1XbVPIxJb
         mw+o+VA5u5zs6fAUxH22Xra0tt/ftSiBkyUatVaXEjEZqs6jIe4lbKDz7qqjLL7MzVzK
         Em4w==
X-Gm-Message-State: AOAM531l8HB0BN086StDO+fZ8QUV/sv3hsRokMjnHFyhau6AAw5XL/hS
        dKgKnxVpMCfLCFqjgQdvRR8w4WTUHH0z0n9ERA/ZFw==
X-Google-Smtp-Source: ABdhPJwxrOl8NL4ByK/Pfp55vHI3T08O8KOMm+uol36pOuMBluSdlFqIghiVrQxdlv6OnTL4mJMgM/2GivNrvUhScRE=
X-Received: by 2002:ac2:5473:: with SMTP id e19mr11864445lfn.21.1591602567899;
 Mon, 08 Jun 2020 00:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
 <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org> <1591169342.4878.9.camel@mtkswgap22>
 <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org> <20200603093416.GY1551@shell.armlinux.org.uk>
 <1591341543.19510.4.camel@mtkswgap22> <20200605080905.GF1551@shell.armlinux.org.uk>
 <1591347582.21704.9.camel@mtkswgap22>
In-Reply-To: <1591347582.21704.9.camel@mtkswgap22>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 8 Jun 2020 13:19:16 +0530
Message-ID: <CAFA6WYNqWmhiz=wvCTt1ubMtrhf+RtFSC2GiQQeteEbmrF1EnQ@mail.gmail.com>
Subject: Re: Security Random Number Generator support
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Julius Werner <jwerner@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Sean Wang <sean.wang@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?B?Q3J5c3RhbCBHdW8gKOmDreaZtik=?= <Crystal.Guo@mediatek.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Neal,

On Fri, 5 Jun 2020 at 14:40, Neal Liu <neal.liu@mediatek.com> wrote:
>
> On Fri, 2020-06-05 at 09:09 +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jun 05, 2020 at 03:19:03PM +0800, Neal Liu wrote:
> > > On Wed, 2020-06-03 at 17:34 +0800, Russell King - ARM Linux admin wrote:
> > > > This kind of thing is something that ARM have seems to shy away from
> > > > doing - it's a point I brought up many years ago when the whole
> > > > trustzone thing first appeared with its SMC call.  Those around the
> > > > conference table were not interested - ARM seemed to prefer every
> > > > vendor to do off and do their own thing with the SMC interface.
> > >
> > > Does that mean it make sense to model a sec-rng driver, and get each
> > > vendor's SMC function id by DT node?
> >
> > _If_ vendors have already gone off and decided to use different SMC
> > function IDs for this, while keeping the rest of the SMC interface
> > the same, then the choice has already been made.
> >
> > I know on 32-bit that some of the secure world implementations can't
> > be changed; they're burnt into the ROM. I believe on 64-bit that isn't
> > the case, which makes it easier to standardise.
> >
> > Do you have visibility of how this SMC is implemented in the secure
> > side?  Is it in ATF, and is it done as a vendor hack or is there an
> > element of generic implementation to it?  Has it been submitted
> > upstream to the main ATF repository?
> >
>
> Take MediaTek as an example, some SoCs are implemented in ATF, some of
> them are implemented in TEE.

In case your TEE implementation is derived from OP-TEE, then I will
suggest you to re-use OP-TEE based RNG driver [1]. With that, you just
need to implement an OP-TEE based pseudo trusted application (similar
to this [2]) specific to your platform and need to extend driver UUID
config table [3] with UUID of your platform specific pseudo TA. This
way you can avoid using hardcoded DT based SMC approach and rather use
auto RNG device detection provided by TEE bus.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/char/hw_random/optee-rng.c
[2] https://github.com/OP-TEE/optee_os/blob/master/core/arch/arm/plat-synquacer/rng_pta.c
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/char/hw_random/optee-rng.c#n273

-Sumit

> We have no plan to make generic
> implementation in "secure world".
>
> Due to there must have different implementation in secure world for
> vendors, we plan to provide a generic SMC interface in secure rng kernel
> driver for more flexibility.
>
> Vendors can decide which "secure world" they want (HYP/ATF/TEE) by
> different smc/hvc and different SMC function IDs in DT node.
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
