Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD1AC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 11:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F0E0214D8
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 11:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjExTvxQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfB1Ld5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:33:57 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:36163 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfB1Ld5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 06:33:57 -0500
Received: by mail-oi1-f180.google.com with SMTP id t206so16215055oib.3
        for <linux-crypto@vger.kernel.org>; Thu, 28 Feb 2019 03:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1jFSg0fKYlWrBV7DBpRNBaeyfHSNAVhC1HkbCxFI8js=;
        b=hjExTvxQ4w5+EzlG2d3qP8MU/7jlCNGLKXSGpYkmh+f4BemLbCjizO06NLNTMtCnw8
         UCOL4gKfq2rCCvSEKTMV6w65OchMHGxw1B/+PyPj/9H3unfnwc2aQS2OqkIXEMKo3gfu
         b/oEpaE8EGo5D7UY/OcQc7dP2KuwQAnTHTdlTpvgTcrkcldaGd0Yski3K1oFDF80Wuu0
         4uyckaUksO4Qb7X4D0xgyLhgM7w/P5/SnB+a/DsmHHjP9v9yeG6lHdjTU7WKhBE34XbG
         jyEg950vR0Dbs7Dwpl2gVTuKrICMYpz2iiYsw6Jl93uLfbRVZ1qFLRnZuuKD4R3qVZNa
         90VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1jFSg0fKYlWrBV7DBpRNBaeyfHSNAVhC1HkbCxFI8js=;
        b=ksGSoy7m8ax1zD5lVj9/rZBY3nnie0MCe5L/aPkbRTRUFlNbU+gjYpXEYEX8ByRGf9
         eD7xQtRc8p5rT9cqa5RQeaZWABUSiXjoswYzZLWEtL/oefFwzZPWhQA5B1WnSi/hdq76
         zGviMwImAUPIMIP9ZFxj9CEegr/g6O1009M2ziRNJV4L+ewD819p6a9fAo0sCH8x3efa
         DV9zp6sjY9Xk8vu6Gm4YBJ6Jf/8cJO+8d8C1OreV6fO3P1DLdH/rZG8IIjryf4quUP7t
         ivUWesqOoykuipdg7inIwe4CUTl2IEzMhoGUu/9IohTg9YyskwxnPK8lo1ATcsOEPoZJ
         ibaQ==
X-Gm-Message-State: AHQUAuZvUZ3byxMKamyMnHxHQEIjRqgSV8Z+2rA/BS6cmBPahIu6NyPR
        r1dLWvrYkaSNv+N0bvzgGCUM2r/58a/7MPaIB24=
X-Google-Smtp-Source: AHgI3IZT9mBnE/m15HkCzFPhi6yKdUiehwlstqxk5B6OEKJ/IATcUzLFZaJIFdcUsOOpvp2TicPCfmphGmoERjwI8uI=
X-Received: by 2002:aca:da43:: with SMTP id r64mr2620680oig.119.1551353636153;
 Thu, 28 Feb 2019 03:33:56 -0800 (PST)
MIME-Version: 1.0
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <20190222100613.2290-5-christopher.spencer@sea.co.uk> <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRTvXVU7vRicF=mR7xxCj=p+Sqj3aNnL2TezLZXhHFkvzA@mail.gmail.com>
 <VI1PR0402MB34857504705A898A59085B4B987B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRRcaiGAaKkUs2Tw_aZD4QKHtJMFLwkfu92pMu3jCBo5gw@mail.gmail.com>
In-Reply-To: <CAGUNXRRcaiGAaKkUs2Tw_aZD4QKHtJMFLwkfu92pMu3jCBo5gw@mail.gmail.com>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Thu, 28 Feb 2019 11:33:44 +0000
Message-ID: <CAGUNXRTR3=xbj-scY=t4jqErcxQTsWHJM=sVESKZxNVHrLB_0g@mail.gmail.com>
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

On Tue, 26 Feb 2019 at 16:24, Chris Spencer <spencercw@gmail.com> wrote:
> > > The original commit which added the run_descriptor_deco0 function [3]
> > > states "[...] and another function that performs the running of the
> > > said descriptor using the DECO debug mechanism." My best guess is that
> > > the DECO debug mechanism is no longer available so it has to go via
> > > the job ring.
> > >
> > This change is actually orthogonal to i.MX8 MQ support and is related to
> > SECO-based i.MX8 SoCs (QXP, QM) and/or OP-TEE support.
> >
> > Access to CAAM global registers (CCSR page 0) won't be allowed in cases when
> > Linux runs in Normal World.
> > From this perspective, it makes sense to eliminate accesses to these registers.
> > Some of the accesses are done for RNG initialization via the DECO debug
> > mechanism; to remove them, RNG is initialized via the Job Ring interface.
> > However, I still see some illegal accesses - for e.g. reading RDSTA register to
> > check which virtual RNGs ("state handles" in RM terms) are already initialized.
> >
> > It looks like cutting access to CAAM global registers must come with some
> > assumptions (since it implies some checks can no longer be performed, see RDSTA
> > above).
> > For e.g. in case OP-TEE is detected, we could assume that RNG was already
> > initialized. Similar for other cases like SECO f/w (i.MX8 QM and QXP).
> > If we make this assumption, it actually means RNG initialization is no longer
> > needed:
> >
> > if (!ctrlpriv->mc_en && rng_vid >= 4 && !normal_world) {
> >         ... // rng init as before - using DECO debug mechanism
> > }
>
> Thanks for the information. This is more problematic than I had
> anticipated. It sounds like these are the possible scenarios:
>
> 1. Linux is running in the normal world without OP-TEE/SECO; RNG must
> be initialised via the job ring. No way of checking whether the RNG is
> already initialised.
> 2. Linux is running in the normal world with OP-TEE/SECO; RNG
> initialisation is not required.
> 3. Linux is running in the secure world without OP-TEE/SECO; RNG can
> be initialised via DECO debug mechanism or job ring.
> 4. Linux is running in the secure world with OP-TEE/SECO; RNG
> initialisation is not required. This sounds like a very unlikely
> configuration.
>
> My build is currently sitting in scenario 1, which would explain why
> the RNG initialisation via DECO was failing. Clearly it can be made to
> work by running the initialisation via the job ring and assuming the
> RNG has not already been initialised, but I'm getting the impression
> that this may not be a sensible configuration.
>
> Is running Linux in the secure world a typical configuration? It's not
> a conscious choice I've made to run it in the normal world; that's
> just what the TF-A is doing. I suppose it's either that or start using
> OP-TEE so it can initialise the RNG.
>
> As far as driver support goes, are we only interested in scenarios 2
> and 3? I'm not really sure how we would detect which world we are
> running in, or whether OP-TEE has initialised the RNG.

Alright I think I'm making some progress on this. It seems that page 0
*is* available on the i.MX8M. I think it is the non-M variants with
the SECO which don't have this access.

What I have found is that if I set virt_en = 1 then the RNG is able to
initialise correctly via the DECO. The register values I am seeing
are:

comp_params = 01914201
scfgr = 00000001

So:
VIRT_EN_INCL = 1 & VIRT_EN_POR = 0 & SCFGR_VIRT_EN = 0

I don't have the i.MX8 security reference manual so there's only so
much analysis I can do, but it seems that virtualisation is enabled in
hardware without the registers reflecting that appropriately. If I
patch the TF-A to set SCFGR_VIRT_EN = 1 in the same place it sets
CAAM_JRxMID = 1 then everything seems to work, but I've got no idea if
that is an appropriate change to make.

Chris
