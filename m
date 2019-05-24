Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372EFC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 13:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D3BC217F9
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 13:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558705003;
	bh=tMBECbiBS4GeoIN2QdWttyV14DSkMjIwIZ/HSg2Q84U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=etEPLSsFdndiGmrlWK/ISd2skYaWFhuffGWQCT5gTkXdTx3iT4SpAwTE3kp1vQP1j
	 s6yfva9cH+/75cPwhNDUxHav47+EPkVeBuBZfKIikuOkmXSYgV+O2yzVWZLBSlEK/n
	 J6yBYIXgvx1sr3wF1W5DxNFbKGeC8XFdEP6JIL/U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391395AbfEXNgm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 09:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391361AbfEXNgl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 09:36:41 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 640DB21855
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558705000;
        bh=tMBECbiBS4GeoIN2QdWttyV14DSkMjIwIZ/HSg2Q84U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LumGEaPFodLNRDIkJbwtxOQRllCWgShXM8+qzkOK+Ni3o4sYZfMnhUOe/gR4dkkhw
         gV60MWootRXVlod34UxYtYXjshnADlFDmcdBbY7zq9IuSAg6JD9PknJRhUFEF1Hgn/
         2ik0nXGzGxaJ/MHJT2iI4Po8UguGa3Zi2IB/B8Jw=
Received: by mail-qk1-f182.google.com with SMTP id j1so7539571qkk.12
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 06:36:40 -0700 (PDT)
X-Gm-Message-State: APjAAAUKsL52KCgCpUYT3X8vbLjkwmp2fmOqEdYFZ9yIG2B2vPLMGqkn
        rzOg9qkBo8wB4K/thCF7BHEVnZ9yQxA5z6cVoQ==
X-Google-Smtp-Source: APXvYqxi31jvwVnuoPYdTSkbUOepa7ShFSTbIUTj/vbeGx8mToTz3KIi5CJt8R/7dYqqEkH90BLcKawOmgOCrK8tmzU=
X-Received: by 2002:ac8:6b14:: with SMTP id w20mr65181261qts.110.1558704999637;
 Fri, 24 May 2019 06:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
 <20190430162910.16771-6-ard.biesheuvel@linaro.org> <CAL_JsqLioethaQ2ekxyeG1QkCwPQKcE4daDMAJXtWwXOEABmGQ@mail.gmail.com>
 <CAKv+Gu-55A=WCx+9He1rc52KKuQ53fMP8efw6DO+wkfr3K+Rdw@mail.gmail.com>
In-Reply-To: <CAKv+Gu-55A=WCx+9He1rc52KKuQ53fMP8efw6DO+wkfr3K+Rdw@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 24 May 2019 08:36:28 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLMubawNufJySC-iS0ELwRC4hk+yMNZMVuMD3FbJPQYWw@mail.gmail.com>
Message-ID: <CAL_JsqLMubawNufJySC-iS0ELwRC4hk+yMNZMVuMD3FbJPQYWw@mail.gmail.com>
Subject: Re: [PATCH 5/5] dt-bindings: add Atmel SHA204A I2C crypto processor
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

On Fri, May 24, 2019 at 8:16 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Fri, 24 May 2019 at 15:12, Rob Herring <robh+dt@kernel.org> wrote:
> >
> > On Tue, Apr 30, 2019 at 11:29 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >
> > > Add a compatible string for the Atmel SHA204A I2C crypto processor.
> > >
> > > Cc: Rob Herring <robh+dt@kernel.org>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  Documentation/devicetree/bindings/crypto/atmel-crypto.txt | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> > > index 6b458bb2440d..a93d4b024d0e 100644
> > > --- a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> > > +++ b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
> > > @@ -79,3 +79,16 @@ atecc508a@c0 {
> > >         compatible = "atmel,atecc508a";
> > >         reg = <0xC0>;
> > >  };
> > > +
> > > +* Symmetric Cryptography (I2C)
> >
> > This doesn't really seem to be related to the rest of the file which
> > are all sub-blocks on SoCs. You could just add this one to
> > trivial-devices.yaml.
> >
> > > +
> > > +Required properties:
> > > +- compatible : must be "atmel,atsha204a".
> > > +- reg: I2C bus address of the device.
> > > +- clock-frequency: must be present in the i2c controller node.
> >
> > That's a property of the controller and doesn't belong here.
> >
>
> Both comments apply equally to the ECC508 above it, which I
> duplicated.

Okay, I only quickly scanned it. The problem for this file will be
when converting to schema, it's generally 1 binding per file.

> Would you like me to move that one into
> trivial-devices.yaml as well? (and drop the clock-freq property)

If you want, but that can be a separate patch.

Rob
