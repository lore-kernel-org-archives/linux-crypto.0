Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21909C35254
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 13:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECDF820702
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 13:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aw+//1eW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgBENkT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 08:40:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42425 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgBENkS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 08:40:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id e8so896672plt.9;
        Wed, 05 Feb 2020 05:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T00hJf8Zau9OXAj1ZR0v+sEf9NavnQw2H4KNq+whO3w=;
        b=Aw+//1eW8gmUsbzag2FFcGcdxzB0EAaQzlkg1oNypkQzxwHGCIAayYa7UERZwbzJ4s
         9vp7r7TCm7ZD7Oqhmhz/O8HuUEaMke2MMWaF+U7gD5gmVf6/dD2ViDrFrTNam+ukarq3
         mu/omXxh9ye9JLtc1ceGIoPJUC8zJvULNChjJxrhOCRlzBNY6Qsh9gIRO0hwXyf2bSg9
         y/PlIAg35yYwuj+mE2wAWUew/AYdsdS7gEWeoHazsb1ckJtoSuenEsKOJbi++1rhpLcy
         +MMxcT+u43KmJSxcS4tOpob92/hPcocevZQKhvizs1yODQwAjT+I4wBhgtdnZe26p2L9
         472A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T00hJf8Zau9OXAj1ZR0v+sEf9NavnQw2H4KNq+whO3w=;
        b=C5/V9jJ9U7xIu1FLL7cLGZc8xRbDTOVH2NEh4akRdc8x1lnmJmGxdHzC/5biqT05NM
         tybcEEIWKq+3CwEo0h1lcrxUrzySOcz8Cuot7iRYNmAnVYMe8T/PCkAhiOwMRlJiAuWT
         7CJwtASgkJ/1czvioEI6z/oMC36kMbdnOO2GWRoZx3qAz5WvWUrXYqNAaQqASJqdNw1h
         avl5lsQSBe/11XPon5zy2ZPMdeafdbEdWQAHj3iU0+ENSPpWCvuYDt4s/Hn/B8bC86u6
         8bf0uFPDzWyUpRDelhvUlBratsRsmc/dnJzNI6DyeU13Csmetde6tUjLshcE1plZvq7S
         w1nQ==
X-Gm-Message-State: APjAAAUqov+0Ic9cYHT6Z80KyD44lNNji1yeOC0C80upZY5foP7eRtCI
        +cUDCU/ZbiHRqkDsY931nRbJq980q/HlWYHlK8c=
X-Google-Smtp-Source: APXvYqx10235/jHI+YTs5wYLM4+RQSDrWQ83PUoirazbmKVoXWCEwqkUJaEF/9RyiBg18qwt72DkutwcO9wQ7Myus+o=
X-Received: by 2002:a17:90a:b10b:: with SMTP id z11mr5829550pjq.132.1580910018046;
 Wed, 05 Feb 2020 05:40:18 -0800 (PST)
MIME-Version: 1.0
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
 <1580650021-8578-4-git-send-email-hadar.gat@arm.com> <CAHp75Vd4VYJD9kSgMU+iKOC5FOarPtMG4eG3Jbnf7OeebWuC7w@mail.gmail.com>
 <AM5PR0801MB166546181D4D2EB9AE8DD26CE9020@AM5PR0801MB1665.eurprd08.prod.outlook.com>
In-Reply-To: <AM5PR0801MB166546181D4D2EB9AE8DD26CE9020@AM5PR0801MB1665.eurprd08.prod.outlook.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 5 Feb 2020 15:40:09 +0200
Message-ID: <CAHp75VeRFUJiCsKew457dPt4WkP+uFjpgKAMErmXzffDMgH6vQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] MAINTAINERS: add HG as cctrng maintainer
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
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
        linux-crypto <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 5, 2020 at 11:22 AM Hadar Gat <Hadar.Gat@arm.com> wrote:
> > On Sun, Feb 2, 2020 at 3:29 PM Hadar Gat <hadar.gat@arm.com> wrote:

...

> > > +CCTRNG ARM TRUSTZONE CRYPTOCELL TRUE RANDOM NUMBER
> > GENERATOR (TRNG) DRIVER
> > > +M:     Hadar Gat <hadar.gat@arm.com>
> > > +L:     linux-crypto@vger.kernel.org
> > > +S:     Supported
> > > +F:     drivers/char/hw_random/cctrng.c
> > > +F:     drivers/char/hw_random/cctrng.h
> > > +F:     Documentation/devicetree/bindings/rng/arm-cctrng.txt
> > > +W:     https://developer.arm.com/products/system-ip/trustzone-
> > cryptocell/cryptocell-700-family

> > Had you run parse-maintainers.pl afterwards to be sure everything is okay?
>
> I run parse-maintainers.pl now and it seems everything is okay.

Good, thank you!

> But the generated MAINTAINERS file has many differences from the one I have all over it.

Don't worry about it, just keep your stuff in order.

> I couldn't find any documentation about this script (under Documentation/).
> Can you point me to the documentation if exists?

The documentation is in the top of MAINTAINERS. The script simple enforces it.

-- 
With Best Regards,
Andy Shevchenko
