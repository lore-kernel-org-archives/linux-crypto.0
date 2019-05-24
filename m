Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA95C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 13:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FA1920644
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 13:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mYMsq9Jr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391496AbfEXNQN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 09:16:13 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52615 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391124AbfEXNQN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 09:16:13 -0400
Received: by mail-it1-f196.google.com with SMTP id t184so15646293itf.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 06:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=78fXlxCLXUHV0mjrAafvvRbvxn0nsYUXrTLP8yA2eqo=;
        b=mYMsq9JrQAt5KkVasB3MUtIYQ+ThUfSBcc71PpfgCO7VACFZSgOB+KFW1JYUoNWLUe
         Lxwpo6CB/6CwVWKO4NFF9uA6nRmaRy0RkCDuit/QnTLQ7cq6F7dpabCkZ9U5ITlv0XN9
         ntXUKrtGa3CY+6h0VpEvVI6AH/5V8DGbC6aWyL6KXrJIk3Y2j0IGwittttU7vkaEO5AK
         +0xJ6rdgMMIuH8u4+ZIeaKAqk0nzn0kZaSr45/zrAokEIGbmvLkGE1ThDKu5Ro4n3Isz
         t/uoBzdcavSOsj0L3hQ1pvrrz4hCqBr4oHHQtcwqvJavsYlVk+urVWldu4ThNPv5UnRP
         zG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=78fXlxCLXUHV0mjrAafvvRbvxn0nsYUXrTLP8yA2eqo=;
        b=dWtzdYZBWqq04ZcQMZr+11cPnizT9XKm7P2Cp9vxjRiDflBzIw2LsGF2lIz57nIFk8
         2vXYnU5yp6+iBWzzcZN6Mp5ZeHLMDO/yQNf5NVDz9d5wfQsRPTT53ho5dhszSWCxvLxF
         AHfhTbMeTxmPtZVvtf6Iv0sI0HjliNldehqgn2TaNQ2g6DSaZX+AQhcX2gqbbp6me+Z9
         W6iwffhWSZGhe+GfT2oGvHKF6z3hHg1QW6ise73rhwDu2WDvQwdYk35WZrgomaqilOia
         jIbtwmJBCUhyPgMyrsOThJCvNnlIzKjBgOK/CfPyiC8pKVWrr+vr1jyIHy/EX0GbXUMz
         TyJA==
X-Gm-Message-State: APjAAAX9AWWZpgaJQdEQ2Ogn6k8RfmUrO7RGK5T2P/OVxHSEf6k3qeps
        Wzfq2aAyAHJ0qzp51DdxVENM/GG7TtpNEOLHb/mp8Q==
X-Google-Smtp-Source: APXvYqwTR+tkWWRgVjsoxQLTHJvXCJCd/XIOde87VElhf7eh2aJ3GbcdBZ3OxVgreGRWMctVFJQ8SI5EQEIIyMhyu6U=
X-Received: by 2002:a02:a494:: with SMTP id d20mr3261224jam.62.1558703772728;
 Fri, 24 May 2019 06:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
 <20190430162910.16771-6-ard.biesheuvel@linaro.org> <CAL_JsqLioethaQ2ekxyeG1QkCwPQKcE4daDMAJXtWwXOEABmGQ@mail.gmail.com>
In-Reply-To: <CAL_JsqLioethaQ2ekxyeG1QkCwPQKcE4daDMAJXtWwXOEABmGQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 24 May 2019 15:15:59 +0200
Message-ID: <CAKv+Gu-55A=WCx+9He1rc52KKuQ53fMP8efw6DO+wkfr3K+Rdw@mail.gmail.com>
Subject: Re: [PATCH 5/5] dt-bindings: add Atmel SHA204A I2C crypto processor
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 24 May 2019 at 15:12, Rob Herring <robh+dt@kernel.org> wrote:
>
> On Tue, Apr 30, 2019 at 11:29 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > Add a compatible string for the Atmel SHA204A I2C crypto processor.
> >
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/crypto/atmel-crypto.txt | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> > index 6b458bb2440d..a93d4b024d0e 100644
> > --- a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> > +++ b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> > @@ -79,3 +79,16 @@ atecc508a@c0 {
> >         compatible = "atmel,atecc508a";
> >         reg = <0xC0>;
> >  };
> > +
> > +* Symmetric Cryptography (I2C)
>
> This doesn't really seem to be related to the rest of the file which
> are all sub-blocks on SoCs. You could just add this one to
> trivial-devices.yaml.
>
> > +
> > +Required properties:
> > +- compatible : must be "atmel,atsha204a".
> > +- reg: I2C bus address of the device.
> > +- clock-frequency: must be present in the i2c controller node.
>
> That's a property of the controller and doesn't belong here.
>

Both comments apply equally to the ECC508 above it, which I
duplicated. Would you like me to move that one into
trivial-devices.yaml as well? (and drop the clock-freq property)

> > +
> > +Example:
> > +atsha204a@c0 {
>
> crypto@c0
>

OK.

> > +       compatible = "atmel,atsha204a";
> > +       reg = <0xC0>;
> > +};
> > --
> > 2.20.1
> >
