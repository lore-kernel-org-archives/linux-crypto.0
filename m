Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B782C43331
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 03:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 727D32082D
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 03:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585278264;
	bh=1QaBX/TCVQartJ3XCSnS4hcC6ju0GnYBjA0EyGXhNwU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=TQHRuSHYq5uQu0af1QfyyFOEM3otsARMswmGdqRSfhbqRfnwQdxPpBoCUY+eCY+6k
	 Q4P3lODqopsVIcDeiYp3SYiJDZoB7RlezKvL3ZITDa3yt3NUXk1wJ/8NiZTprSUppl
	 vE0+RhOUvI+cGGHCSVUAhVIyitrbfUH5k8Y4TmLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgC0DEV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 23:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgC0DEU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 23:04:20 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B8420A8B;
        Fri, 27 Mar 2020 03:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585278260;
        bh=1QaBX/TCVQartJ3XCSnS4hcC6ju0GnYBjA0EyGXhNwU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g3V4/S5yj0lkokrjq4rHn0YaOs5ktFQxGyBri6i9mLjh0c1xqkKhIao0TOazbBZSq
         84E9NQfJ6lh/3VfY4GH7c4g9VxS8lbiPEUpO/xEZHNMYAlz9jR2eaDufUTrUFb89ap
         E0Tlfdi5n3a+n5Qctfr8SHGWQZONpmPqCMGrQVYI=
Received: by mail-qt1-f182.google.com with SMTP id m33so7502289qtb.3;
        Thu, 26 Mar 2020 20:04:20 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2VxEIU5dlPF61a6ilq7N7voIXoaMD18r4RsryKpNUHE96d6N/u
        /p48aB1klGYeGoGxnST56SbKYHubaDhMrWhEFA==
X-Google-Smtp-Source: ADFU+vumdp+yoHmOndReHPe5KBTcIwfbcpwYm2SJv4vxq3LNPhVocpSd6D04SDQe+ewv6F3wC3JVyohcF8lQkB31Pr8=
X-Received: by 2002:aed:3461:: with SMTP id w88mr12145077qtd.143.1585278259310;
 Thu, 26 Mar 2020 20:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <1585114871-6912-1-git-send-email-hadar.gat@arm.com>
 <1585114871-6912-2-git-send-email-hadar.gat@arm.com> <20200326194104.GA4118@bogus>
 <DB6PR0802MB25334E308B8D4B10D2562460E9CF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB25334E308B8D4B10D2562460E9CF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 26 Mar 2020 21:04:07 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+KJyZLncOTB8CwgjvRQvkgc+8=hqHKA87aJ4LoYYXnvQ@mail.gmail.com>
Message-ID: <CAL_Jsq+KJyZLncOTB8CwgjvRQvkgc+8=hqHKA87aJ4LoYYXnvQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
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

On Thu, Mar 26, 2020 at 3:05 PM Hadar Gat <Hadar.Gat@arm.com> wrote:
>
> Hi Rob,
>
> >
> > On Wed, Mar 25, 2020 at 07:41:09AM +0200, Hadar Gat wrote:
> > > The Arm CryptoCell is a hardware security engine. This patch adds DT
> > > bindings for its TRNG (True Random Number Generator) engine.
> > >
> > > Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> > > ---
> > >  .../devicetree/bindings/rng/arm-cctrng.yaml        | 55
> > ++++++++++++++++++++++
> > >  1 file changed, 55 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > > b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > > new file mode 100644
> > > index 0000000..7f70e4b
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> > > @@ -0,0 +1,55 @@
> > > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause) %YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/rng/arm-cctrng.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Arm TrustZone CryptoCell TRNG engine
> > > +
> > > +maintainers:
> > > +  - Hadar Gat <hadar.gat@arm.com>
> > > +
> > > +description: |+
> > > +  Arm TrustZone CryptoCell TRNG (True Random Number Generator)
> > engine.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    enum:
> > > +      - arm,cryptocell-713-trng
> > > +      - arm,cryptocell-703-trng
> > > +
> > > +  interrupts:
> > > +    maxItems: 1
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +  arm,rosc-ratio:
> > > +    description:
> > > +      Arm TrustZone CryptoCell TRNG engine has 4 ring oscillators.
> > > +      Sampling ratio values for these 4 ring oscillators. (from calibration)
> > > +    allOf:
> > > +      - $ref: /schemas/types.yaml#/definitions/uint32-array
> > > +      - items:
> > > +          minItems: 4
> > > +          maxItems: 4
> >
> > Aren't there some constraints on the values?
> >
> > If not, then just this is enough:
> >
> > - maxItems: 4
> >
> The constraint is just on the array size and not on the values.
> The array is of 4 elements for the CryptoCell 4 ring oscillators.
> Isn't 'minitems:' is about the array min size? Isn't it the way to block less than 4 items? This is what I want to do.
> I'm a bit confused if it is required or not..

Essentially, we always require bounds on the array size, so if you
only specify one of minItems or maxItems it's implied to be a fixed
size. IOW, you only have to specify both if you have a variable number
of items. Also, note that an 'items' list implies the exact size. Both
of these are not the default behavior for json-schema.

Hope that helps.

Rob
