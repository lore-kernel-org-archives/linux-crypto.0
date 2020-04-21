Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F440C54FD0
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 16:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39AA8206E9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 16:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDUQ1K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 12:27:10 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42559 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgDUQ1J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 12:27:09 -0400
Received: by mail-ot1-f67.google.com with SMTP id m18so11642105otq.9;
        Tue, 21 Apr 2020 09:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z1ojXwNxr6fCrXSGTkvpXUDrRNbvPdHnN0pbWQDg8tI=;
        b=Aa2d1pVkGDl9x3TnUJag2Vo6eoTDZoKpgQdpL0awnF7isiOL4vfLBAPNP54pvctNNT
         3mO92ONefT+13qV2DyUcOGC0zQeO1KILzmtJotApa2aywxAjfOac20Bd8A6mrkSN8arp
         3kch/yf9+JqGc7W8MafPXh+xZnY54ajTCcvTZa7H4VRDByJHJrw/3E7BStEKo3+flQ72
         JLLrNoN587VACLbkeoC3UU0GTWLZwIsZt2XHUbkxpqaLXHZpInuyC9lBSVgmvLRYvwW1
         xXY3VzhtgWpqw0F3UMtkssylhtX6P1c10B1RCAuBeXwRvJeA8mYnKRhPE0uRjY3wsZLq
         srcw==
X-Gm-Message-State: AGi0Pua/uV7hpIimDHxOjhgEobdQubTloaZW3fFnjJ0o+Ias1ED1WRWb
        KNblCRk8q2L71lvfvIulg/0trV9ZES3cqYGIDsg=
X-Google-Smtp-Source: APiQypIgjJPykdfEevGKb/2cffNOv+ps81j/7PYsnO1VUUkclaMSWdBbtbbqnNQUgCd31g2SXhEjkUxwnK7jaBN7I8o=
X-Received: by 2002:a05:6830:3104:: with SMTP id b4mr10595518ots.250.1587486427362;
 Tue, 21 Apr 2020 09:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <1585289423-18440-3-git-send-email-hadar.gat@arm.com> <CAMuHMdV6Uce79MPs7jfJfX3WOqAMH22vf2V_=Ui0zLHYqsJ+Xg@mail.gmail.com>
 <DB6PR0802MB25338BD19DD2F7E662BB1065E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <CAMuHMdWujabV8dr=EojXFBVD0TcUuZ2kCGjjo93u=PE-AmzVHA@mail.gmail.com> <DB6PR0802MB2533347A35A466B99ADD4D23E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB2533347A35A466B99ADD4D23E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Apr 2020 18:26:56 +0200
Message-ID: <CAMuHMdVGwLQxDj9dtF02L3P5MxBCZAiJ1_4OyK3Yomn9y-nPzQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] hw_random: cctrng: introduce Arm CryptoCell driver
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

On Tue, Apr 21, 2020 at 5:13 PM Hadar Gat <Hadar.Gat@arm.com> wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > On Tue, Apr 21, 2020 at 3:16 PM Hadar Gat <Hadar.Gat@arm.com> wrote:
> > > > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > Sent: Monday, 20 April 2020 16:45
> > > > On Fri, Mar 27, 2020 at 7:11 AM Hadar Gat <hadar.gat@arm.com> wrote:
> > > > > Introduce low level Arm CryptoCell TRNG HW support.
> > > > > --- /dev/null
> > > > > +++ b/drivers/char/hw_random/cctrng.c
> > > >
> > > > > +static int cctrng_probe(struct platform_device *pdev) {

> > > > > +       /* register the driver isr function */
> > > > > +       rc = devm_request_irq(dev, irq, cc_isr, IRQF_SHARED,
> > > > > + "cctrng", drvdata);
> > > >
> > > > Shoudn't this be done after clearing the pending interrupts below?
> > >
> > > I'm not sure what do you mean in your question...
> > > I assume you're suggesting that the registration of the driver ISR function
> > should be done only after clearing the pending interrupts?!
> >
> > Indeed.
> >
> > > Anyway, any pending interrupt that might exist is irrelevant to the
> > > current cctrng driver which just started (we're in the probe function)
> >
> > If there is a pending interrupt, your interrupt handler (which returns
> > IRQ_NONE in this case) will be called repeatedly, until the driver gets to
> > clearing the pending interrupts below, or until the interrupt core decides to
> > give up, and disable it for good.
>
> Ok, I get your point now.
> But note that when the cctrng HW boots, the default is that all interrupts are masked, hence the interrupt handler will not be called.

Is that also the case when booting into a new kernel using kexec?

> The unmask of the RNG interrupts is done afterwards and only then ISR may potentially be called.

> > > > > +       if (rc) {
> > > > > +               dev_err(dev, "Could not register to interrupt %d\n", irq);
> > > > > +               goto post_clk_err;
> > > > > +       }
> > > > > +       dev_dbg(dev, "Registered to IRQ: %d\n", irq);
> > > > > +
> > > > > +       /* Clear all pending interrupts */
> > > > > +       val = cc_ioread(drvdata, CC_HOST_RGF_IRR_REG_OFFSET);
> > > > > +       dev_dbg(dev, "IRR=0x%08X\n", val);
> > > > > +       cc_iowrite(drvdata, CC_HOST_RGF_ICR_REG_OFFSET, val);
> > > >
> > > > The above accesses the engine's registers...
> > >
> > > That is right.
> > >
> > > > > +
> > > > > +       /* unmask HOST RNG interrupt */
> > > > > +       cc_iowrite(drvdata, CC_HOST_RGF_IMR_REG_OFFSET,
> > > > > +                  cc_ioread(drvdata, CC_HOST_RGF_IMR_REG_OFFSET) &
> > > > > +                  ~CC_HOST_RNG_IRQ_MASK);
>
> The above unmask the RNG interrupt.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
