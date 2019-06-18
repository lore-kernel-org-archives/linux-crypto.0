Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E971C31E5B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 00:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49A2620861
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 00:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LiC+04T7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfFRAwv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 20:52:51 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36483 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRAwv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 20:52:51 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so25788757ioh.3;
        Mon, 17 Jun 2019 17:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TYOiO/xzGnV71TjcwwyNpG8oxTziqhWA9sPeUoiZcCk=;
        b=LiC+04T7sgr2ZsSyteDTIhkLHYKawG17xJC0E2z332b+oaIe35xDuLnryDndrLNJ87
         KtIl0JHjBX5TqkcKvlXMG47mKcLLI43L0KLXMOOYGOzNblNK1PixfMcfDyxoPyMHyujY
         emO9REDHcT8/23OniHmaQk9OhUrZpjZJLJnuBbmWG6jkhqx57mYpLSS/Mhj3owqyFIdv
         aVjhTfLeJE1/LE1E6A9Qt3lohWjMoGK5YxykgQUKAKsEiiDCoJJjLybLlqG5SJzGNCkd
         d5Kyp9FBQdxFGVVTMP7coneuAlm80Y+777iJ82EIzFNPJdKHYdarwQVV1Z7mAViYKRCN
         K04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TYOiO/xzGnV71TjcwwyNpG8oxTziqhWA9sPeUoiZcCk=;
        b=jZ31xPiVjRayQbw7UtYuQXZdXW2wKXkkEHHslxxQexbHJinIKsBjUi7TSEpH+a41IK
         3WBIYjFDUcQP1c0fWuWE7X98Y3xXXqGsEXkrQ89k4tIXOJHWX5jaE4PmK96wnf8mRkJF
         aDB8iLPppbr0W84D8HNNCFe94N7tPbdOGntqicjCGF78gFI5TVirbLZ0SUiCRjOIOAv0
         cE63dB9O/dW/YtIodyZ7XhLQblAg0/nzVvgiYVUa41NOieb9c+aXt4rdnuBavpk9uj+J
         ZQkVQqyvovAT87y1a/97Hy7xZWEmp87lOXzaMYXfcMTJBE611aBjh/ZGVqBSBRIwh29J
         n1qw==
X-Gm-Message-State: APjAAAWm9bzJnuy86myIrjEELkXVNSvUygzjAex7KRM+LHYXO9jdOzci
        gGOTVJKiyVJQB09DS2OM0t8Sty7ykg4fPx6KU68=
X-Google-Smtp-Source: APXvYqwUp47RJ9vyOSB/NYU9YjR0QBgRIjSN9OM3nRoTofrsUPgaIMhtXP5cV3YhKhpd/0zxlMWVWZ7IssV20V1cOjU=
X-Received: by 2002:a6b:f00c:: with SMTP id w12mr1676839ioc.280.1560819170596;
 Mon, 17 Jun 2019 17:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
 <20190617160339.29179-3-andrew.smirnov@gmail.com> <VI1PR04MB5055A9A725CED589FCF9254DEEEB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB5055A9A725CED589FCF9254DEEEB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 17 Jun 2019 17:52:39 -0700
Message-ID: <CAHQ1cqFVawQgCYbExj1_U05nwpbN+d9DaY+Giq3ErjKnE74ZzA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] crypto: caam - correct DMA address size for the i.MX8
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 12:24 PM Leonard Crestez
<leonard.crestez@nxp.com> wrote:
>
> On 6/17/2019 7:04 PM, Andrey Smirnov wrote:
> > From: Chris Spencer <christopher.spencer@sea.co.uk>
> >
> > The i.MX8 is arm64, but its CAAM DMA address size is 32-bits.
>
> > +/*
> > + * On i.MX8 boards the arch is arm64 but the CAAM dma address size is
> > + * 32 bits on 8MQ and 36 bits on 8QM and 8QXP.
> > + * For 8QM and 8QXP there is a configurable field PS called pointer size
> > + * in the MCFGR register to switch between 32 and 64 (default 32)
> > + * But this register is only accessible by the SECO and is left to its
> > + * default value.
> > + * Here we set the CAAM dma address size to 32 bits for all i.MX8
> > + */
> > +#if defined(CONFIG_ARM64) && defined(CONFIG_ARCH_MXC)
> > +#define caam_dma_addr_t u32
> > +#else
> > +#define caam_dma_addr_t dma_addr_t
> > +#endif
>
> Wait, doesn't this break Layerscape? Support for multiple SOC families
> can be enabled at the same time and it is something that we actually
> want to support.
>

Ugh, l think you are right. Will fix in next version.

Thanks,
Andrey Smirnov
