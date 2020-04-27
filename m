Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C87C54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 07:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C500F2084D
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 07:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587972268;
	bh=y2j/hNS486RI1bnR+aDGuxSB9pse8rk5aZSv6RfS4FM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IkIVFAWthd5D6A7XBshr9s7CUViL/zy9riTFkuC3RvvxqoCpSlZhGuc6LTs2Chi7/
	 iJFznQy1WPsi39TWEEx1VGo3KmQCk9zZAUgHQ8uX17gDUmMAYUKyL71ebwo8g5D/ey
	 c+43qCGfgi7n6OB5DLBwE79J6mOgD7yCgcuqUC/c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgD0HY2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbgD0HY2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 03:24:28 -0400
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58EEA21835;
        Mon, 27 Apr 2020 07:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587972267;
        bh=y2j/hNS486RI1bnR+aDGuxSB9pse8rk5aZSv6RfS4FM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=puBU60g6Jc4kuYgN8/flCN8J7nKkf6DBCGJinCMgvK9s2wS28SlhyTnFYAFAnyDKU
         pKqI9og//Du2UTqU5Gwf5HzVZkpXukC1NNBU+z3oVL5uauqdndPG4we4woU2xYzbaS
         ssFAThyEH7/ZkYOLZnh7aZtGAZUcS3OrtHmM09AI=
Received: by mail-il1-f177.google.com with SMTP id w6so15769750ilg.1;
        Mon, 27 Apr 2020 00:24:27 -0700 (PDT)
X-Gm-Message-State: AGi0PubHGbH+df9UgKTPkmDXInsTO2lp0Awq/IY7HQrBHeU0S9Eev9tq
        J6AVeW9jiUGwOwKA5AyxPcwlai9Qsw3mgunt+ko=
X-Google-Smtp-Source: APiQypLTYbEngVS71XND42rFRz0BF/tYDA/z6GNs9SrDJWNULXkyWJU2rZxyV7HhyjNn72SQDFss31iJnQySUclx+q4=
X-Received: by 2002:a92:405:: with SMTP id 5mr19085583ile.279.1587972266674;
 Mon, 27 Apr 2020 00:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <1587966099-28139-1-git-send-email-hadar.gat@arm.com>
 <1587966099-28139-2-git-send-email-hadar.gat@arm.com> <CAMj1kXHN1qzoP9YNmrFcTJRncJE88Jyp_MS_9XrdAiY9v6DAyw@mail.gmail.com>
 <DB6PR0802MB253304D0FE37A3C99C1A1E4CE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB253304D0FE37A3C99C1A1E4CE9AF0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 27 Apr 2020 09:24:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFL7e9_=vax0t0YBEzk+hc-d1v0oGVnFO1mfmNPCDaEcQ@mail.gmail.com>
Message-ID: <CAMj1kXFL7e9_=vax0t0YBEzk+hc-d1v0oGVnFO1mfmNPCDaEcQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] hwrng: cctrng - Add dependency on OF
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 27 Apr 2020 at 09:23, Hadar Gat <Hadar.Gat@arm.com> wrote:
>
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > On Mon, 27 Apr 2020 at 07:42, Hadar Gat <hadar.gat@arm.com> wrote:
> > >
> > > The cctrng is unusable on non-DT systems so we should depend on it.
> > >
> > > Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> > > ---
> > >  drivers/char/hw_random/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/char/hw_random/Kconfig
> > > b/drivers/char/hw_random/Kconfig index 0c99735..df2d001 100644
> > > --- a/drivers/char/hw_random/Kconfig
> > > +++ b/drivers/char/hw_random/Kconfig
> > > @@ -476,7 +476,7 @@ config HW_RANDOM_KEYSTONE
> > >
> > >  config HW_RANDOM_CCTRNG
> > >         tristate "Arm CryptoCell True Random Number Generator support"
> > > -       depends on HAS_IOMEM
> > > +       depends on HAS_IOMEM & OF
> >
> > Does your driver in fact depend on CONFIG_HAS_IOMEM ?
>
> Yes, it uses devm_ioremap_resource() for registers mapping.
>

Fair enough
