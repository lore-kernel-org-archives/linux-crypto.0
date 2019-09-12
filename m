Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0110AC4CEC6
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 20:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D213E20830
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 20:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfILU0n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 16:26:43 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37635 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfILU0n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 16:26:43 -0400
Received: by mail-ed1-f65.google.com with SMTP id i1so25155333edv.4;
        Thu, 12 Sep 2019 13:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l8Ov5y/tQkSs6Q5vM7CFAAbYYGZtyUJhfeWygf8r9JE=;
        b=DUKiaa93yxqkZlKe2P9Io/rbo5CT3/lhzRapUCY299lLoQLdYbR+rksUrrkVzol0YJ
         SG7qrYboLo1JqYc0kq6y3PMoNNAy0xCp1uKntDWbhCo7pPvjkkgCJsI3Puz0j+9pfqMt
         KX4g1P7IzVEmz9+TAPuDkEmjIQjXYWy+LhYF47QL3OSLBzzOHddfDkzDgGHA2/C8t2HT
         arwedseo9gZjrokH8AwSLjl394GK6OGTi/7MPhdQRkeTvgphtbW+1K54owytHTamV7pX
         bGu17ayVFvogdPBjiLqYw0O74clezXXJ8DpCHHce18UioojLgHxjpyS5B/8JnYcLvF7w
         GbLg==
X-Gm-Message-State: APjAAAWhwlzLVQl/xWanhEz5hJO6g/925zi/hBOtcz9ybCMcwXdbVdTW
        4yfEv5WXlhS9ifoDIEnP+XdO7LiwAGg=
X-Google-Smtp-Source: APXvYqy+AQuZFjynxt4UGxkI7i+2IDwTi5qdCyBm2CXUTley8B3GQJRRFV6oSKcynInpCM21ehiSBg==
X-Received: by 2002:a50:9e08:: with SMTP id z8mr45137282ede.305.1568320000893;
        Thu, 12 Sep 2019 13:26:40 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id k11sm2725434ejr.3.2019.09.12.13.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2019 13:26:40 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id l11so29784855wrx.5;
        Thu, 12 Sep 2019 13:26:40 -0700 (PDT)
X-Received: by 2002:a5d:6785:: with SMTP id v5mr12785154wru.9.1568319999923;
 Thu, 12 Sep 2019 13:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-4-clabbe.montjoie@gmail.com> <20190907040116.lib532o2eqt4qnvv@flea>
 <20190911183158.GA8264@Red> <20190912093737.s6iu63sdncij2qib@localhost.localdomain>
In-Reply-To: <20190912093737.s6iu63sdncij2qib@localhost.localdomain>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Thu, 12 Sep 2019 21:26:27 +0100
X-Gmail-Original-Message-ID: <CAGb2v678WGQm5PNy8GhOTpz+fYeLP3k0dnR0F00yyZpSRcA4yA@mail.gmail.com>
Message-ID: <CAGb2v678WGQm5PNy8GhOTpz+fYeLP3k0dnR0F00yyZpSRcA4yA@mail.gmail.com>
Subject: Re: [PATCH 3/9] dt-bindings: crypto: Add DT bindings documentation
 for sun8i-ce Crypto Engine
To:     Maxime Ripard <mripard@kernel.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <linux@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 12, 2019 at 10:37 AM Maxime Ripard <mripard@kernel.org> wrote:
>
> Hi Corentin,
>
> On Wed, Sep 11, 2019 at 08:31:58PM +0200, Corentin Labbe wrote:
> > On Sat, Sep 07, 2019 at 07:01:16AM +0300, Maxime Ripard wrote:
> > > On Fri, Sep 06, 2019 at 08:45:45PM +0200, Corentin Labbe wrote:
> > > > This patch adds documentation for Device-Tree bindings for the
> > > > Crypto Engine cryptographic accelerator driver.
> > > >
> > > > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > > ---
> > > >  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 84 +++++++++++++++++++
> > > >  1 file changed, 84 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> > [...]
> > > > +else:
> > > > +  clocks:
> > > > +    items:
> > > > +      - description: Bus clock
> > > > +      - description: Module clock
> > > > +
> > > > +  clock-names:
> > > > +    items:
> > > > +      - const: ahb
> > > > +      - const: mod
> > > > +
> > > > +  resets:
> > > > +    maxItems: 1
> > > > +
> > > > +  reset-names:
> > > > +    const: ahb
> > >
> > > This prevents the usage of the additionalProperties property, which
> > > you should really use.
> > >
> > > What you can do instead is moving the clocks and clock-names
> > > description under properties, with a minItems of 2 and a maxItems of
> > > 3. Then you can restrict the length of that property to either 2 or 3
> > > depending on the case here.
> > >
> >
> > Hello
> >
> > I fail to do this.
> > I do the following (keeped only clock stuff)
> > properties:
> >
> >   clocks:
> >     items:
> >       - description: Bus clock
> >       - description: Module clock
> >       - description: MBus clock
>
> Add minItems: 2  and maxItems: 3 at the same level than items
>
> >
> >   clock-names:
> >     items:
> >       - const: ahb
> >       - const: mod
> >       - const: mbus
>
> And here as well
>
> Something I missed earlier though was that we've tried to unify as
> much as possible the ahb / apb / axi clocks around the bus name, it
> would be great if you could do it.

I think we also want to standardize "mbus" as "dram"?

ChenYu

> >
> > if:
> >   properties:
> >     compatible:
> >       items:
> >         const: allwinner,sun50i-h6-crypto
> > then:
> >   properties:
> >       clocks:
> >         minItems: 3
> >         maxItems: 3
> >       clock-names:
> >         minItems: 3
> >         maxItems: 3
>
> You don't need to duplicate the min and maxItems here
>
> Maxime
