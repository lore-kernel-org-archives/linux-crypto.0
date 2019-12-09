Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E0EC04E30
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375D9207FD
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="udziYz2d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfLIQr1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 11:47:27 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39636 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIQr0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 11:47:26 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so15468735ioh.6;
        Mon, 09 Dec 2019 08:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XHum4FDJDIcgTeOwvhbTJMdsl7kGHy76x1fPGptU0Ec=;
        b=udziYz2dZA3xvFqA3QmslCERX0mkXTBQnwhiY585MQJ/oxeg4n8eBFiLdH/jTCa9VF
         QMeKhP4j8Whn63LiUzZk2afaYl18gR8ZiV/okxSNcgW4FTki5hTkdPIVMkHS5g9eH9M4
         zHhZs425J0FiJkW884QLhuPZrgc67h4LbuvWSNeMWR5+AZ7dlAVzXsZOQaLMbTbiIlKy
         iXX64YMFlMeM4nFli7q6FzA+0hH75n4/Fj2xusjLxbAVzrwTbNGX4punKE1HosatLHxd
         wngfe/KRWwgURMfP+qbt0/t/FaozZl/F9FCgTNtMcxictPVnzFGKaa2DngeaYwBGqcdT
         04dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XHum4FDJDIcgTeOwvhbTJMdsl7kGHy76x1fPGptU0Ec=;
        b=GWwUmQ3r6Uiza/CHpGybLGQz1Zv18i+Jy45kn+KnQhE2Q8J3mts1T8EYxrnsdHhLpS
         51SUpcETvq+p2fYxfbJ4JeYWbvLqBoHQO5U64+qKFerFi+xqvotyCQAYVYEuWKPVu38M
         vOQGu6TO/PFrZm4GPICdXtMQs7shtw3RjBjAkry//Zj1FgMCcdb9cibX9XmG/0PVBnKn
         IDUBJSX1lILT5TQ6gChVzxQEfR/WyBvsMNvRqoSgoKRCcXsh71HptMGoPxXM+kiwNqJA
         JfLGXBk91C5WyhJlH9i+queLP7sHP3yVREjbMMhT8Aer3C8UjtB70dP/FV+jZOhnc1gd
         P7QA==
X-Gm-Message-State: APjAAAWvAJrh0IVpZrOyufEEgnWWMaWl5YTDC8KoNXADwB9s3QNXdB03
        4hLOxMo+B+KiIm0dZW+UUa6BECiwDOBIYDvj+hE=
X-Google-Smtp-Source: APXvYqyRfLHLHr8UPDK5Qg/R0LOdnqfw2mns2KoezyJYWV0kZLZ9FzWmbX14ZpFaRwTi7GmfNPgc2uuS2/cMCzOhYbc=
X-Received: by 2002:a02:13c2:: with SMTP id 185mr21935228jaz.0.1575910045615;
 Mon, 09 Dec 2019 08:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20191130225153.30111-1-aford173@gmail.com> <20191130225153.30111-2-aford173@gmail.com>
 <VI1PR0402MB348586BEDA9BE13CEB10C75698580@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348586BEDA9BE13CEB10C75698580@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 9 Dec 2019 10:47:14 -0600
Message-ID: <CAHCN7x+roEAmteNLT9KkLxPvL6AFFHMUW=J_cLcSdE50kODZQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: imx8mm: Add Crypto CAAM support
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 9, 2019 at 10:23 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 12/1/2019 12:52 AM, Adam Ford wrote:
> > The i.MX8M Mini supports the same crypto engine as what is in
> > the i.MX8MQ, but it is not currently present in the device tree,
> > because it may be resricted by security features.
> >
> What exactly are you referring to?

I don't know this hardware very well, but on a different platform, we
needed to make the crypto engines as disabled if they were being
accessed through secure operations which made it unavailable to Linux
without using some special barriers. I didn't have the special
hardware on the other platform that required it that way, so I can't
really explain it well.  I know on those special cases, because some
people were accessing these registers through other means, the devices
had to be marked as 'disabled' so to avoid breaking something.  Since
I wasn't sure if this was left out of the i.MX8M Mini on purpose, I
let this disabled just in case this hardware platform was also
affected in a similar and people wanting to use it could mark it as
'okay'

adam

>
> > This patch places in into the device tree and marks it as disabled,
> > but anyone not restricting the CAAM with secure mode functions
> > can mark it as enabled.
> >
> Even if - due to export control regulations - CAAM is "trimmed down",
> it loses only the encryption capabilities (hashing etc. still working).
>
> Again, please clarify what you mean by "secure mode functions",
> "security features" etc.
>
> Horia
