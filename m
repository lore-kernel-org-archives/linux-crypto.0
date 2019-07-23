Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07B9C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 14:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD29B227BE
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563892562;
	bh=RhgZmcSMrQfqbKW3yJR0qQgPijWPcwlwWIuyvyAMaj0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XVwyKK+A2g2b7ct1vAg4kbh5y+hqhryQceK1mMzPQBzc5D9Oc3lg0nw+bl6xK6L2V
	 JAnk+MjP6NQu3WZs/uKTGQv8rb5JaxTn6GY5BnU6/2bqJwHEiOTt3JCPAGJFqdDH1N
	 FrwNAurOA2wZvcA5im9kPfYlfYcgrdkMTrbqedfs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387987AbfGWOgB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 10:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732590AbfGWOgB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 10:36:01 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D152227BE;
        Tue, 23 Jul 2019 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563892560;
        bh=RhgZmcSMrQfqbKW3yJR0qQgPijWPcwlwWIuyvyAMaj0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wLzKco/ArT5Dvfhgx+RaF8Fzo9J01LD8d96HbTMMRKdSTPSycFxvhs5LCOraxZkJZ
         JkUM874oADKHLP14egH8DMTatS/Yt2U7n9FBkCxywEqixwbZPny1z7mEeiOeM5TeiK
         jnDroFl49M4ihJT2TP4q5KB7tPiKJpsXJPqPjJX8=
Received: by mail-qk1-f170.google.com with SMTP id s22so31295834qkj.12;
        Tue, 23 Jul 2019 07:36:00 -0700 (PDT)
X-Gm-Message-State: APjAAAVnMfvA9112Z+IklUnI3TUlOV542NX0V7aAXidWh3Gwxr5cA9Se
        BWWdbQQqCzkzoN2skbnvbzJTvQ833ug4/bsDPg==
X-Google-Smtp-Source: APXvYqwO37a9Uf29MCK2pQZVWi4gKhtu8lPzPkbArTZ/nniUVYHOSr3nEpVeFoaSFAMyZM3mOkSYpKT/tr0qovfkO7M=
X-Received: by 2002:a37:a48e:: with SMTP id n136mr51861407qke.223.1563892559731;
 Tue, 23 Jul 2019 07:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <1561361052-13072-1-git-send-email-neal.liu@mediatek.com>
 <1561361052-13072-3-git-send-email-neal.liu@mediatek.com> <20190722171320.GA9806@bogus>
 <1563848465.31451.4.camel@mtkswgap22>
In-Reply-To: <1563848465.31451.4.camel@mtkswgap22>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 23 Jul 2019 08:35:47 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+SRhd=-5O2G_CMfJX9Z188kvA05MQOXaU1J8iExwUixQ@mail.gmail.com>
Message-ID: <CAL_Jsq+SRhd=-5O2G_CMfJX9Z188kvA05MQOXaU1J8iExwUixQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] dt-bindings: rng: add bindings for MediaTek ARMv8 SoCs
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Sean Wang <sean.wang@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Q3J5c3RhbCBHdW8gKOmDreaZtik=?= <Crystal.Guo@mediatek.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 22, 2019 at 8:21 PM Neal Liu <neal.liu@mediatek.com> wrote:
>

Please don't top post to lists.

> Dear Rob,
>         You can check my driver for detail:
>         http://patchwork.kernel.org/patch/11012475/ or patchset 3/3

I could, or you could just answer my question.

>
>         This driver is registered as hardware random number generator, and
> combines with rng-core.
>         We want to add one rng hw based on the dts. Is this proper or do you
> have other suggestion to meet this requirement?

It depends. There doesn't appear to be any resource configuration, so
why does it need to be in DT. DT is not the only way instantiate
drivers.

Rob

>
>         Thanks
>
>
> On Tue, 2019-07-23 at 01:13 +0800, Rob Herring wrote:
> > On Mon, Jun 24, 2019 at 03:24:11PM +0800, Neal Liu wrote:
> > > Document the binding used by the MediaTek ARMv8 SoCs random
> > > number generator with TrustZone enabled.
> > >
> > > Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> > > ---
> > >  .../devicetree/bindings/rng/mtk-sec-rng.txt        |   10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/rng/mtk-sec-rng.txt
> > >
> > > diff --git a/Documentation/devicetree/bindings/rng/mtk-sec-rng.txt b/Documentation/devicetree/bindings/rng/mtk-sec-rng.txt
> > > new file mode 100644
> > > index 0000000..c04ce15
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/rng/mtk-sec-rng.txt
> > > @@ -0,0 +1,10 @@
> > > +MediaTek random number generator with TrustZone enabled
> > > +
> > > +Required properties:
> > > +- compatible : Should be "mediatek,mtk-sec-rng"
> >
> > What's the interface to access this?
> >
> > A node with a 'compatible' and nothing else is a sign of something that
> > a parent device should instantiate and doesn't need to be in DT. IOW,
> > what do complete bindings for firmware functions look like?
> >
> > > +
> > > +Example:
> > > +
> > > +hwrng: hwrng {
> > > +   compatible = "mediatek,mtk-sec-rng";
> > > +}
> > > --
> > > 1.7.9.5
> > >
> >
> > _______________________________________________
> > Linux-mediatek mailing list
> > Linux-mediatek@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-mediatek
>
>
