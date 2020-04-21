Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E484C55183
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76D81206F4
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgDUNkF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:40:05 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46112 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgDUNkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 09:40:04 -0400
Received: by mail-oi1-f195.google.com with SMTP id q204so11970165oia.13;
        Tue, 21 Apr 2020 06:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3/1l4+L7c32gnSlR+jJxwn2uHEoI18nOZn1jAcK8+9Q=;
        b=qVWO7oiIChojoNCxQH8rGnO1CVw0zz2QrOO4Z+nt2O0mUtAoNVX7jlgmRi6ZJbdUYz
         EXPDych6FonQIco66FjGYP6BxiD4JVFLFaf94W2WgFDv2gMgjdASu4h+5MJyjXtZDsoK
         FUz00XV5Qyafy5bJG2Bt5iKZAfc39fTje+zGPn/aKXr7U+Btq9l9KdQRuFEXSSvsPJM4
         Q+FesvCsm4C4ud5j3bIRVit2YRPQDbRFren53Ujq10nLU1M4j29NGVa2dpnPLIUBKgXp
         RtUgeQvRcwFed5NZsTm2Q4xPDskRaJAAc3ct1Vb6rvg1+WXVyQs4F01ORfV0+RRr8Hv/
         4F4w==
X-Gm-Message-State: AGi0PuaPvH/9AoSKN/8xJVXF02dUkl2zQWvVO6Sc6HXrETsq2hWEju0D
        heJTnyzIKhn/qCfJXhoV48thCE8TKovN0GR2FfA=
X-Google-Smtp-Source: APiQypLnyE8M1S3nafbqgPsJWblXWZUy3OMvbgpZ18EMhwOIcc0Hy40xHYlEJ+5FEBBaTRknY0lppcu8TbDznbLPHQw=
X-Received: by 2002:aca:f541:: with SMTP id t62mr3020719oih.148.1587476402149;
 Tue, 21 Apr 2020 06:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <CAMuHMdUUJATs+G-hvty=fgyrhyx1EafpFHoWfcm=V_tVLn3q2A@mail.gmail.com>
 <DB6PR0802MB25330E55914346B46288C712E9D40@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAMuHMdV1Lp0uEOm_KtUA-nF7-6y1kfyvArcunrLipp6h5A_GMw@mail.gmail.com> <DB6PR0802MB25330B64ABAE083E31B427DDE9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB25330B64ABAE083E31B427DDE9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Apr 2020 15:39:50 +0200
Message-ID: <CAMuHMdWjBTEM-cU32ZcvvoYDcjdMzcKbQZUyvGggZRMRhkOmFg@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hw_random: introduce Arm CryptoCell TRNG driver
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
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
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hadar (and Gilad),

On Tue, Apr 21, 2020 at 3:13 PM Hadar Gat <Hadar.Gat@arm.com> wrote:
> To better explain the relationship between ccree and cctrng drivers, here an description of the underlying hardware and the relationship to the two drivers:
>
> Arm TrustZone CryptoCell is a hardware block that implements two separate and discreet, although related, interfaces: one for the Rich Execution Environment  (read: Linux) and the other for the Trusted Execution Environment (e.g. Trusty, Op-TEE).
>
> The ccree driver exposes the REE interface of CryptoCell to Linux. Where a SoC vendor implements both REE and TEE in their design, that is all that is needed.
>
> However, we have some customers that make use CryptoCell but never implement a Trusted Execution Environment. This is a design decision taken when the SoC hardware is being designed and not a software controlled configuration, as it involves how the buses are laid out. Some of these customers have requested from us to allow making use in Linux of the TRNG resources which are normally associated with the TEE side when it is not in use. For these customers, the cctrng driver allows making use in Linux the TRNG which is normally part of the TEE side of CryptoCell.

Thank you, that is the part I was missing.

BTW, there seems to be no mention of CryptoCell 630 on arm.com; it
covers only CC-300 and CC-700.
But from the (very limited) information about the crypto engine on R-Car
Gen3 SoCs, it looks like the RNG is indeed only present in the secure
(trusted) part.

> > -----Original Message-----
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > On Mon, Apr 20, 2020 at 2:27 PM Hadar Gat <Hadar.Gat@arm.com> wrote:
> > > > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > Sent: Monday, 20 April 2020 12:35
> > > >
> > > > On Fri, Mar 27, 2020 at 7:11 AM Hadar Gat <hadar.gat@arm.com> wrote:
> > > > > The Arm CryptoCell is a hardware security engine.
> > > > > This patch introduces driver for its TRNG (True Random Number
> > > > > Generator) engine.
> > > >
> > > > Thanks for your series!
> > > >
> > > > I am wondering what is the relation between this and
> > > > Documentation/devicetree/bindings/crypto/arm-cryptocell.txt?
> > >
> > > Arm TrustZone CryptoCell hardware contains both cryptographic engine
> > (ccree) and true random number generator engine (cctrng).
> >
> > OK.
> >
> > > These are separate engines with some sharing in logic and interface.
> >
> > Do they share the same register block?
> >
> > > cctrng engine may not always be present.
> >
> > I assume that applies to e.g. the older 630p?
> >
> > > The devicetree documentation is in:
> > > For ccree -
> > > Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> > > For cctrng - Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> >
> > Thank you, I had already read both documents.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
