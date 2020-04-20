Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968DFC3815B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 13:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8294E206E9
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 13:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgDTNpl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 09:45:41 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44888 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgDTNpl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 09:45:41 -0400
Received: by mail-oi1-f196.google.com with SMTP id a2so4129569oia.11;
        Mon, 20 Apr 2020 06:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2ghh1pPF1fsAsPGVZzPt9RKgESh8HbBU2W/jDg7F0c=;
        b=sz2E4b2PztQNahZiYkyEU0J3PMJJ/mPiaZ91IlSUJXHIGmoJw/i7KpCFwFH1KFBpXK
         Xyq8Q88USPJwFUui7aqCeoCpfFmurmhFI7fHPCwsejrddy0MtwQTDs/ucehHd+jI+D9b
         f2wKg4UNyJJPu2ha4RHXkBVETZU2anNIE8LNoeCik0cLu0u3FN6Eri2IJGV0/hdUZK2n
         fTV/2CeSY9c9m+e2io2e4+RA/94xHx6uHOMgYJPNIH51gKW61/zipQfZ+y0wr6r0w6W6
         dKuZlqc6SOntgm32b6VKZfgumdq3SS9KXCzF+BNWOJ45VhqZeFcCLjsmvna7wrxNA95W
         7spA==
X-Gm-Message-State: AGi0PuaNUTyUvozxy6U0UvhjHhHRegDXPoKrQu4IpAqHdlSOaB7k4GPr
        zht7TsdavUSAnY++Th8/jzixirOq7MPr1jTL0JM=
X-Google-Smtp-Source: APiQypIYWggq31kqe72PWGup1dXMLkkExcPMIqTIaghdiu2d6AzyZ3huwXP08u748n7J/APQ6LYfplz/CfuGBxsDgd0=
X-Received: by 2002:aca:f541:: with SMTP id t62mr10124295oih.148.1587390339921;
 Mon, 20 Apr 2020 06:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <CAMuHMdUUJATs+G-hvty=fgyrhyx1EafpFHoWfcm=V_tVLn3q2A@mail.gmail.com> <DB6PR0802MB25330E55914346B46288C712E9D40@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB25330E55914346B46288C712E9D40@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Apr 2020 15:45:28 +0200
Message-ID: <CAMuHMdV1Lp0uEOm_KtUA-nF7-6y1kfyvArcunrLipp6h5A_GMw@mail.gmail.com>
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
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hadar,

On Mon, Apr 20, 2020 at 2:27 PM Hadar Gat <Hadar.Gat@arm.com> wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > Sent: Monday, 20 April 2020 12:35
> >
> > On Fri, Mar 27, 2020 at 7:11 AM Hadar Gat <hadar.gat@arm.com> wrote:
> > > The Arm CryptoCell is a hardware security engine.
> > > This patch introduces driver for its TRNG (True Random Number
> > > Generator) engine.
> >
> > Thanks for your series!
> >
> > I am wondering what is the relation between this and
> > Documentation/devicetree/bindings/crypto/arm-cryptocell.txt?
>
> Arm TrustZone CryptoCell hardware contains both cryptographic engine (ccree) and true random number generator engine (cctrng).

OK.

> These are separate engines with some sharing in logic and interface.

Do they share the same register block?

> cctrng engine may not always be present.

I assume that applies to e.g. the older 630p?

> The devicetree documentation is in:
> For ccree - Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> For cctrng - Documentation/devicetree/bindings/rng/arm-cctrng.yaml

Thank you, I had already read both documents.


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
