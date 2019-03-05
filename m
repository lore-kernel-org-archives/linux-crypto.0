Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7765C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 08:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB00D20675
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 08:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tY9GM1Jp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfCEIyg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:54:36 -0500
Received: from mail-oi1-f173.google.com ([209.85.167.173]:42504 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfCEIyg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 03:54:36 -0500
Received: by mail-oi1-f173.google.com with SMTP id s16so6222088oih.9
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2019 00:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VBrEn/x1wOmoRSQBJX/Vg3OR9P5ptySKlzmV9bvsmhg=;
        b=tY9GM1JpWnK0WlqO9zE+bmo9aDV6cATCWK9Aul/sE0GCKnSjabfv36H/kS80H6KSrv
         Bo4fJcZfIk/xa/q5tyYiZlIPmHG25GiOYcnfqS1q8m/ASdqWcDZxZ6G6Ny2cv/Y1aYXW
         Jok27ygIJUAlkU/8SQcnVVN2IgQtwKdawqz/tAqMRsR9AlT5ia7YGYfzWpv//l1Bp1eE
         ruEXUmY42R/xep/hdDR6vsQZyR2TnEeFFp8wKgAxhafSISYpgFHlJxT3JybXr5KnJtzd
         DXcsW8l+lie3thEGgVRERC/f81tEuel3P0XQW6eW4RCxCQf1zI+Sv9W9EEAj/RjOpoKq
         Rxyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VBrEn/x1wOmoRSQBJX/Vg3OR9P5ptySKlzmV9bvsmhg=;
        b=lw309IRZBGFgoLIwH14bHJ90v2Ywkd0sfTOUobMnMm3rT4ztxmLEyamKepqyVNxr2T
         ESs8epBYqmsAWcww7muYgv/9z8kaKypJZqsspqhlQZeKDWyn+do9butabHlxnhnaq2iR
         bXLHg5FIECI8gU5e0xb2IcvtflaQkmaiUQPk0j4zPQ7G451XVT+U60HTcmPcG8OWH9f/
         /LauXMctOyDFV82fyTdllNL8t6B0tJ7JZmKlxhSnwZ9x/mtxEe8SAPg4dwE60iod5Ets
         +K4s79m3uA/WdEmtCtM3CEWzSxNsK4wGPAF0H3cTAj5AVkDMK+Ssp65UD88fWS3xCUJW
         /yPg==
X-Gm-Message-State: AHQUAubdpm/dQz4fMSSbC1pM5ybeV7x1f9Dc3NrWy+0mAn4k76dsWKhZ
        Yyon15LTODrl5yNjlZeMc6dgjIA4WoCbzm+5AOaPLjn+mVg=
X-Google-Smtp-Source: APXvYqzfCVBM1Wz6DACjm0t/CtiGASt7o9wCOL7t7ZkeSuJSPEXnudxqRF/nZCnWK0INFNq1Vp/R4I0pSwyCXdlK3pE=
X-Received: by 2002:aca:bc0b:: with SMTP id m11mr14084782oif.41.1551776075003;
 Tue, 05 Mar 2019 00:54:35 -0800 (PST)
MIME-Version: 1.0
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <20190222100613.2290-5-christopher.spencer@sea.co.uk> <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRTvXVU7vRicF=mR7xxCj=p+Sqj3aNnL2TezLZXhHFkvzA@mail.gmail.com>
 <VI1PR0402MB34857504705A898A59085B4B987B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRRcaiGAaKkUs2Tw_aZD4QKHtJMFLwkfu92pMu3jCBo5gw@mail.gmail.com>
 <CAGUNXRTR3=xbj-scY=t4jqErcxQTsWHJM=sVESKZxNVHrLB_0g@mail.gmail.com> <VI1PR0402MB3485DD524A658329D51258F498710@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485DD524A658329D51258F498710@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Tue, 5 Mar 2019 08:54:23 +0000
Message-ID: <CAGUNXRQdO2K7eayqDt7WqNGo7Vohr0x1S43XSpjr4f+fcBPFcg@mail.gmail.com>
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

Hi Horia,

On Mon, 4 Mar 2019 at 18:13, Horia Geanta <horia.geanta@nxp.com> wrote:
> > I don't have the i.MX8 security reference manual so there's only so
> RM should be available from here:
> https://www.nxp.com/webapp/sps/download/mod_download.jsp?colCode=IMX8MDQLQSRM&location=null&appType=moderated

Unfortunately this requires an NXP Salesperson/FAE Name and FAE Email
Address, which I don't have. I did put in a request on Thursday via
the live chat, but so far nobody from sales has contacted me.

> > much analysis I can do, but it seems that virtualisation is enabled in
> > hardware without the registers reflecting that appropriately. If I
> > patch the TF-A to set SCFGR_VIRT_EN = 1 in the same place it sets
> > CAAM_JRxMID = 1 then everything seems to work, but I've got no idea if
> > that is an appropriate change to make.
> >
> RNG initialization should work in both cases.
>
> The root cause for the failure in case virtualization is disabled is probably
> the lack of setup of DECO DID registers (offsets A0h, A4h).
>
> Section "Register-based service interface" mentions:
> "But before requesting a DECO, software must specify the DID and SDID values
> that will be used when executing descriptors under direct software control. When
> virtualization is disabled (SCFGR[VIRT_EN]=0), these values are specified by
> writing DID and SDID values into the appropriate DECO DID_MS and DECO DID_LS
> registers."

Not having much luck here either. In the TF-A it sets JRxMID to 1; I
have added extra lines in the same place to set DECO0MID_MS
(0x309000a0) to 1 and DECO0MID_LS (0x309000a4) to 0x10001, but it
still fails to acquire the DECO when initialising the RNG.

It's possible I'm just using the wrong values. I'm still working from
the i.MX6 security reference manual which doesn't seem to talk about
DIDs or SDIDs so I don't know what these mean.

Thanks,
Chris
