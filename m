Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F8EC3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913AD2077C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5GqyvBC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfHPHIz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 03:08:55 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43585 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfHPHIy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 03:08:54 -0400
Received: by mail-pf1-f175.google.com with SMTP id v12so2656931pfn.10
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 00:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bWiAoe+gK8jziCl/V5duDiKDckl5BO2yBTCVW/CX3vs=;
        b=j5GqyvBC3G4liHuK2mA9vCDKnDSqQh4DrOcM6goqFN4gNz5g3qNCFPWRN9qqvakagK
         kg7YAjNi0PuGzqukj4FboLsx11mMMVyPMTv81bd87sJ9NxzokHNGXI5cxbJI5mIa6i5X
         M99eex2BgOw7rdAc/zx5Tci3GPLsF2EzU6MGcVjVxubMm0FklnR3dcTH52Ptan1l1mHZ
         DJROkRgsPJ0XBlV1bUZmj93P6vfEk/w4p3m83Q1FM9UBpar6L8FEEq+pz7hBS9Ny+uXo
         AYSPxfGR29moRKLjwDrbSeJ1W0PL2qPCwtf+00QM7cuwx2b08CT/oCxKURI6Fgw2YzkL
         OdWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bWiAoe+gK8jziCl/V5duDiKDckl5BO2yBTCVW/CX3vs=;
        b=Ha0jfyUUHSlGpO3flSMdFsO0D/+z6qtpoC1c9pGKrgbcO7R6JVOyRyLiJx6WpCUgT+
         +E/VGPNvahhlZJlL/JLGO4KKtkeJScL68c1U9SS+NZYUwzmV9kXYnj6aFXrFKHRO5jHz
         G5ZiwuBbkC+V/DXfpKaR9Q9jguj7wvgRgqQB7KNsi6XVJ9QWtFOps70C19wYLl8lmPcW
         /rKBhJTT4ife+wxajbgj+amxivydJeL39ALEEaWlqmXF56lyQPwAzyklFizL87HpRwz6
         ShrtPSws+cGKwYnfz7uTNdD/lVmDo3TGOyxZMTG0VO7ZLraSN49kzVUmLWZwMq13z9oL
         n6Dg==
X-Gm-Message-State: APjAAAWkdCQ7NlDUPqNV6Kkz0pqCh44N1R2l0NLxdVxcoV6xmZI7r8yh
        flReEhpQY0vvySoPMyIe9qFU6OXl3fPOo4tFNmmz90XUO05Y1A==
X-Google-Smtp-Source: APXvYqzOa7JcmpXLi1TMBuMnlFdNjbSO8cgWefDE2QKJxaY9oipfAx8JtgOaVORxFEldvE0UjjUTuBtk7vu6tfSN1jw=
X-Received: by 2002:a17:90a:be07:: with SMTP id a7mr5789193pjs.88.1565939334170;
 Fri, 16 Aug 2019 00:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190815120313.GA29253@gondor.apana.org.au> <5D556981.2080309@hisilicon.com>
 <20190815224207.GA3047@gondor.apana.org.au> <CAAUqJDsvG-c=svGzszE8nCXwjGSYUa9BB1Jj0srY+_rX0X-jyw@mail.gmail.com>
In-Reply-To: <CAAUqJDsvG-c=svGzszE8nCXwjGSYUa9BB1Jj0srY+_rX0X-jyw@mail.gmail.com>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Fri, 16 Aug 2019 09:08:42 +0200
Message-ID: <CAAUqJDuzUPUW=qvhEo6tU==Ycw0aijJM9pQk5W50kw=EgEG3ow@mail.gmail.com>
Subject: Re: crypto: hisilicon - Fix warning on printing %p with dma_addr_t
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Zhou Wang <wangzhou1@hisilicon.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pi 16. 8. 2019 o 9:02 Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com> nap=
=C3=ADsal(a):
> Hi Herbert,
>
> pi 16. 8. 2019 o 1:52 Herbert Xu <herbert@gondor.apana.org.au> nap=C3=ADs=
al(a):
> > On Thu, Aug 15, 2019 at 10:17:37PM +0800, Zhou Wang wrote:
> > >
> > > > -   dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%pad\n",=
 queue,
> > > > -           cmd, dma_addr);
> > > > +   dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%#lxad\n=
",
> > > > +           queue, cmd, (unsigned long)dma_addr);
> > >
> > > Thanks. However, to be honest I can't get why we fix it like this.
> > > Can you give me a clue?
> >
> > dma_addr_t is not a pointer.  It's an integer type and therefore
> > you need to print it out as such.
>
> According to Documentation/core-api/printk-formats.rst, %pad is the
> format specifier intended specifically for dma_addr_t [1], so perhaps
> the kbuild robot warning was in fact bogus?
>
> [1] https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#d=
ma-address-types-dma-addr-t

Oh, wait, in that section it actually says "Passed by reference.", so
Zhou is most likely right that the proper fix is to pass a pointer to
the variable containing the address (I assume this is to make the
generic GCC's format checking pass even if dma_addr_t is not actually
a pointer).

>
> >
> > Actually my patch is buggy too, on some architectures it can be
> > a long long so we need to cast is such.
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
