Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A04C35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 125DB206ED
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581446403;
	bh=8M/DAG01uY5J9fd/tBLodsJqKBMrf7Ga37UsLPhdF40=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lwGCInsrNH5jZBnU5WQbExocfqq7AoWSdrBvslmGHbIE0Yc9Ang/h9TV2PRnRegjY
	 Wk7ec62nl9I2FFTHnuQjMknQuVqPbdYe/okDIVbqyczDDnLmrG3UyQ03OtOXXueIFw
	 nNNBzMJ+2iQUArA+HlCk4g5a8MfI7EmE1P1OPbzA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbgBKSj7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbgBKSj7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:39:59 -0500
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4921F21D7D;
        Tue, 11 Feb 2020 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581446398;
        bh=8M/DAG01uY5J9fd/tBLodsJqKBMrf7Ga37UsLPhdF40=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Yfk9Aym71n7UY3UN+lE89eXVArMALR9RRSHjbU15nRwqPGHFXoA1ja8mq0zCDu7dz
         cv2te3hN261YhwgJ10ebBHRilfffIdsTNqcNVRWvxX0TU9Hzil0PMwUjOlsYlxxhlr
         rP+mcFu9cI0LU1orG7grfVpIZhfV8oQvpb2Jyi5w=
Received: by mail-qt1-f179.google.com with SMTP id d18so8716950qtj.10;
        Tue, 11 Feb 2020 10:39:58 -0800 (PST)
X-Gm-Message-State: APjAAAURRG7PxfC6lUuzI/d3gzYvUNwOoSCQAoug+q5qn3mAWQ0Oyz7c
        huGRVKqPOhxKhxQ6Nk4TpY9tPCSdMB5H0tJW2w==
X-Google-Smtp-Source: APXvYqxq3NT0xWbTbROx8zhNE6oXAj1noFgXpEXEkK4QFM7vJR0BN9sVbCnbiqH/hOyqmUsIGCM+GWUAroGve6ESwsc=
X-Received: by 2002:ac8:1415:: with SMTP id k21mr3808050qtj.300.1581446397230;
 Tue, 11 Feb 2020 10:39:57 -0800 (PST)
MIME-Version: 1.0
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
 <1580650021-8578-2-git-send-email-hadar.gat@arm.com> <20200206185651.GA14044@bogus>
 <AM5PR0801MB16657EDAA54655B7CBA46AF5E91E0@AM5PR0801MB1665.eurprd08.prod.outlook.com>
In-Reply-To: <AM5PR0801MB16657EDAA54655B7CBA46AF5E91E0@AM5PR0801MB1665.eurprd08.prod.outlook.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 11 Feb 2020 12:39:46 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+F8mW7oUBCXMgzEVb3Bz2pHxU=bFjo97QisMZN92PaQw@mail.gmail.com>
Message-ID: <CAL_Jsq+F8mW7oUBCXMgzEVb3Bz2pHxU=bFjo97QisMZN92PaQw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 9, 2020 at 3:34 AM Hadar Gat <Hadar.Gat@arm.com> wrote:
>
> Hi Rob,
> Thanks for remarks.
> Please see my answers.
> Hadar
>
> > On Sun, Feb 02, 2020 at 03:26:59PM +0200, Hadar Gat wrote:
> > > The Arm CryptoCell is a hardware security engine. This patch adds DT
> > > bindings for its TRNG (True Random Number Generator) engine.
> > >
> > > Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> > > ---
> > >  .../devicetree/bindings/rng/arm-cctrng.yaml        | 51
> > ++++++++++++++++++++++
> > >  1 file changed, 51 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > > b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > > new file mode 100644
> > > index 0000000..fe9422e
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > > @@ -0,0 +1,51 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> >
> > Dual license new bindings:
> >
> > (GPL-2.0-only OR BSD-2-Clause)
> >
> Okay.
>
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/rng/arm-cctrng.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Arm ZrustZone CryptoCell TRNG engine
> > > +
> > > +maintainers:
> > > +  - Hadar Gat <hadar.gat@arm.com>
> > > +
> > > +description: |+
> > > +  Arm ZrustZone CryptoCell TRNG (True Random Number Generator)
> > engine.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    description: Should be "arm,cryptocell-7x3-trng"
> >
> > Drop. That's what the schema says.
> >
> Okay.
>
> > > +    const: arm,cryptocell-7x3-trng
> >
> > Is 'x' a wildcard? We don't do wildcards unless you have other ways to get the
> > specific version.
> >
> Kind of a wildcard. It stands for either 703 or 713.
> Should I fix this to the specific versions?
> OR,
> Since the specific version doesn't matter to the driver, should it changed?

Maybe not now, but both will always have the same errata and features?
2 is not a large number, so just do 2.

Of course, errata can vary by revision. Most Arm IP has version
registers, so I assume that's true here. If not, we'd need per SoC
implementation compatible strings here.

> (checking out other rng drivers, I see this example in Samsung,exynos4.yaml:
>   - samsung,exynos4-rng # for Exynos4210 and Exynos4412 )

Well, there's lots of bad examples, and also, some Samsung bindings
are declared to not be stable.

>
> > > +
> > > +  interrupts:
> > > +    description: Interrupt number for the device.
> >
> > Drop. That's all 'interrupts'.
> >
> Okay.
>
> > > +    maxItems: 1
> > > +
> > > +  reg:
> > > +    description: Base physical address of the engine and length of memory
> > > +                 mapped region.
> >
> > Drop.
> >
> Okay.
>
> > > +    maxItems: 1
> > > +
> > > +  rosc-ratio:
> > > +    description: Sampling ratio values from calibration for 4 ring oscillators.
> > > +    maxItems: 1
> >
> > Is this an array?
> >
> Yes, array of 4. (I'll mention in the description)

Don't need a description as that's constraints the schema should express.

> > Needs a vendor prefix, a type ref and any constraints you can come up with.
> >
> Do you mean in the name? instead of "rosc-ratio"?

arm,rosc-ratio:
  allOf:
    - $ref: /schemas/types.yaml#/definitions/uint32-array
  maxItems: 4

> I didn't find anything about it in the documentation or examples in other rng drivers..
>
> > > +
> > > +  clocks:
> > > +    description: Reference to the crypto engine clock.
> >
> > How many clocks?
> >
> One clock. (I will change clocks --> clock)

No, the property name is always 'clocks'. You need just 'maxItems: 1'
if there's a single clock.

Rob
