Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A0DC5DF64
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 15:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483C02166E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 15:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQxmhZ/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfKFPTe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 10:19:34 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55903 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfKFPTe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 10:19:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so1002519wmb.5;
        Wed, 06 Nov 2019 07:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M0IBd/SaidQNLpNJyp1ZZ/9s4QZhbQrts+pf5iBup6Y=;
        b=NQxmhZ/zqXbWVBCiPGzsl3D3RIFUUF4ypQ4anIvBWBLR1B9Y8TKbATJPi96yjViDUs
         siOaZWUp2L0eEgYliVDf4H0lChWL8pGwCxNyOBNbn51M7LlxSv0hiLztTbSvdOpAWBWV
         2qBTI7Dzwpifxv0EulFM1BXOf5yixLecc7KZ1FY8jW/cWtjVpukE9uhBx741z1SViV2G
         1cxq6QPk15IoXxJj+ZpLdFTuDI+apFi7MwBWVDcJkJp7913qCGiD9WI2wC4t2kksCekr
         I+DTO7W69UDvo0txALPY9rp5Eoo7PZkDaunrE8ZEFI8lY4qeyBxbMG7f6IVyZulqGXbD
         U5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M0IBd/SaidQNLpNJyp1ZZ/9s4QZhbQrts+pf5iBup6Y=;
        b=SU1enVUzt4k6ApGKKFG7UkTaLe6gPuMHjLJtKgcGpC7p8WBHsw96wuCS5W/phOh1Zy
         l7oLhNhSbV34ClLkcAWPmJuEp003qxnQNWbXjQQWIzrqNM2+ix4xmv8LWSakpdYmes3R
         Fm7KZKSAXARUYwnH2sWOXUngF56V0j0SeDAvN8zsZlFli1qQ5+dgUaS4CyBS/8suZD4P
         Wml52afQmzZ+hASSzxVo3eLiYzhxCixo8nrPPkitb9YkDyB+OMGdmWm1xB8/itMEM9EI
         jGtWKAkqtGxJ4pdNCDrqDDzSrC+Odtn9WrR51AG2PwvhC1SoW5Y69LSgYxlNyNNYITdG
         F8uA==
X-Gm-Message-State: APjAAAX4CglLTlkgPF3PyX/W1j7wlFLFFS16t6O73dv607+elEGgD9Wa
        VoiBoVMcOg8LaqfYg5szc2FtGeSHl7t3Mf9rP1Q=
X-Google-Smtp-Source: APXvYqybCTbTFcDNvJE4HOfXBlRBbmPwGUs4539jNxDeW3OCRe4wJrDeHxuPtlyFJW+a+YVjokWDyA3VZfFYikJDWCc=
X-Received: by 2002:a7b:ce11:: with SMTP id m17mr3204670wmc.113.1573053571949;
 Wed, 06 Nov 2019 07:19:31 -0800 (PST)
MIME-Version: 1.0
References: <20191105151353.6522-1-andrew.smirnov@gmail.com> <DB7PR04MB4620E3087C59A26B865DEE988B790@DB7PR04MB4620.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB4620E3087C59A26B865DEE988B790@DB7PR04MB4620.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 6 Nov 2019 07:19:20 -0800
Message-ID: <CAHQ1cqH5hstMwbO1vqOkZ3GVe-j5a+c3TX-yosq-TvuFFxPkHQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] CAAM JR lifecycle
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 5, 2019 at 11:27 PM Vakul Garg <vakul.garg@nxp.com> wrote:
>
>
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-
> > owner@vger.kernel.org> On Behalf Of Andrey Smirnov
> > Sent: Tuesday, November 5, 2019 8:44 PM
> > To: linux-crypto@vger.kernel.org
> > Cc: Andrey Smirnov <andrew.smirnov@gmail.com>; Chris Healy
> > <cphealy@gmail.com>; Lucas Stach <l.stach@pengutronix.de>; Horia Geanta
> > <horia.geanta@nxp.com>; Herbert Xu <herbert@gondor.apana.org.au>;
> > Iuliana Prodan <iuliana.prodan@nxp.com>; dl-linux-imx <linux-
> > imx@nxp.com>; linux-kernel@vger.kernel.org
> > Subject: [PATCH 0/5] CAAM JR lifecycle
> >
> > Everyone:
> >
> > This series is a different approach to addressing the issues brought up in
> > [discussion]. This time the proposition is to get away from creating per-JR
> > platfrom device, move all of the underlying code into caam.ko and disable
> > manual binding/unbinding of the CAAM device via sysfs. Note that this series
> > is a rough cut intented to gauge if this approach could be acceptable for
> > upstreaming.
> >
> > Thanks,
> > Andrey Smirnov
> >
> > [discussion] lore.kernel.org/lkml/20190904023515.7107-13-
> > andrew.smirnov@gmail.com
> >
> > Andrey Smirnov (5):
> >   crypto: caam - use static initialization
> >   crypto: caam - introduce caam_jr_cbk
> >   crypto: caam - convert JR API to use struct caam_drv_private_jr
> >   crypto: caam - do not create a platform devices for JRs
> >   crypto: caam - disable CAAM's bind/unbind attributes
> >
>
> To access caam jobrings from DPDK (user space drivers), we unbind job-ring's platform device from the kernel.
> What would be the alternate way to enable job ring drivers in user space?
>

Wouldn't either building your kernel with
CONFIG_CRYPTO_DEV_FSL_CAAM_JR=n (this series doesn't handle that right
currently due to being a rough cut) or disabling specific/all JRs via
DT accomplish the same goal?

Thanks,
Andrey Smirnov
