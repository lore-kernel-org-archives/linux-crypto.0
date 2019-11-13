Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62995C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 19:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B74A2206D5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 19:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WB6tjTaI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfKMT0E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 14:26:04 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55733 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfKMT0D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 14:26:03 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so3216127wmb.5;
        Wed, 13 Nov 2019 11:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eJks9EMjmgWp8wZx+kLzfc16SG/mFPriDGfSeGmYPKg=;
        b=WB6tjTaIP2JoResHDKgFXt1N+ObwsAn73Hc0YKf7QlYuffJRlsk67Zmp1Zo8mCjyyW
         SEpXM4H+YSTmqPVE57A9lfbRLK48xJV/dbGWbKFr5Ki94DT7OEiJ+k5NUMzRz5h5iW2R
         /3vg9DaCBC2xG/llimZkknnlv8xb9FKQAyAn6uIT0EGGJPvzlJ5ksc1uNoeO92+q/nxx
         A8aiRR0WmwNuCREr7PzZvsfYdq1JmrLRrQEvKJqphwiYMQvhSYlMTJpjc90/+nCzMCXX
         +OscUG4FVn8XCrW2rNSjy9Vbgs3BjUGa7AY9Cz3fbJxCE1wlw0qMcPjUNX0IaSFOrkJY
         WF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eJks9EMjmgWp8wZx+kLzfc16SG/mFPriDGfSeGmYPKg=;
        b=WXnFoupalaCr3MUQ99juaefuqfB3MuCgZE0Q7UYjcVMZQcMS32x625rSTCMZzNcVjK
         oVY3X7AX/rdAVAlx5KQOCHjko1g8KAxAtolTTt0TnEEv5DPPT3ruiTi2NCLu89+5+EUu
         UMKPme96BjpOqZcn+rdD0V02VM35nghj07FlzatV/PfGWJ4X+RL/NtOw3pjH0HaCnNcr
         103XPgL6fODVSlDHUcsf/OA8Ie6sg6or9DTJvPsBFXpKipC881j60ipX+ZbyynTiawKS
         G5z3+0MXPRvJxqvjiE2OJMoKtVhKLK3fjLqzYib9NWXw7igRz2nRkLAFoVgCLk26iYQE
         Py4A==
X-Gm-Message-State: APjAAAX6l7y5wB4tHfVHB+l+xIjJXOaNH5YU0AsqFkb/q7SZUNUyMDDg
        id+xLuWGhuv9fE63pXhqvoCalca/d2gq1HOom/M=
X-Google-Smtp-Source: APXvYqyfg9Z7FZ27gYaCUT8OP1K/853AXCJJ6Bc+DrJlBjUKCn7VCUopN9J24WeCv3cBMDEMrcoINLa7LPnzLpgUzjQ=
X-Received: by 2002:a1c:720b:: with SMTP id n11mr3942813wmc.60.1573673161167;
 Wed, 13 Nov 2019 11:26:01 -0800 (PST)
MIME-Version: 1.0
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
 <DB7PR04MB4620E3087C59A26B865DEE988B790@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <CAHQ1cqH5hstMwbO1vqOkZ3GVe-j5a+c3TX-yosq-TvuFFxPkHQ@mail.gmail.com> <VI1PR0402MB34851C1681F8A18341A8971098760@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34851C1681F8A18341A8971098760@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 13 Nov 2019 11:25:50 -0800
Message-ID: <CAHQ1cqFPmJ7AR3ftTyCy4DiE0YQgspPBnp+EQLPOwxXo6tTcYg@mail.gmail.com>
Subject: Re: [PATCH 0/5] CAAM JR lifecycle
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 13, 2019 at 10:57 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 11/6/2019 5:19 PM, Andrey Smirnov wrote:
> > On Tue, Nov 5, 2019 at 11:27 PM Vakul Garg <vakul.garg@nxp.com> wrote:
> >>
> >>
> >>
> >>> -----Original Message-----
> >>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-
> >>> owner@vger.kernel.org> On Behalf Of Andrey Smirnov
> >>> Sent: Tuesday, November 5, 2019 8:44 PM
> >>> To: linux-crypto@vger.kernel.org
> >>> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>; Chris Healy
> >>> <cphealy@gmail.com>; Lucas Stach <l.stach@pengutronix.de>; Horia Geanta
> >>> <horia.geanta@nxp.com>; Herbert Xu <herbert@gondor.apana.org.au>;
> >>> Iuliana Prodan <iuliana.prodan@nxp.com>; dl-linux-imx <linux-
> >>> imx@nxp.com>; linux-kernel@vger.kernel.org
> >>> Subject: [PATCH 0/5] CAAM JR lifecycle
> >>>
> >>> Everyone:
> >>>
> >>> This series is a different approach to addressing the issues brought up in
> >>> [discussion]. This time the proposition is to get away from creating per-JR
> >>> platfrom device, move all of the underlying code into caam.ko and disable
> >>> manual binding/unbinding of the CAAM device via sysfs. Note that this series
> >>> is a rough cut intented to gauge if this approach could be acceptable for
> >>> upstreaming.
> >>>
> >>> Thanks,
> >>> Andrey Smirnov
> >>>
> >>> [discussion] lore.kernel.org/lkml/20190904023515.7107-13-
> >>> andrew.smirnov@gmail.com
> >>>
> >>> Andrey Smirnov (5):
> >>>   crypto: caam - use static initialization
> >>>   crypto: caam - introduce caam_jr_cbk
> >>>   crypto: caam - convert JR API to use struct caam_drv_private_jr
> >>>   crypto: caam - do not create a platform devices for JRs
> >>>   crypto: caam - disable CAAM's bind/unbind attributes
> >>>
> >>
> >> To access caam jobrings from DPDK (user space drivers), we unbind job-ring's platform device from the kernel.
> >> What would be the alternate way to enable job ring drivers in user space?
> >>
> >
> > Wouldn't either building your kernel with
> > CONFIG_CRYPTO_DEV_FSL_CAAM_JR=n (this series doesn't handle that right
> > currently due to being a rough cut) or disabling specific/all JRs via
> > DT accomplish the same goal?
> >
> It's not a 1:1 match, the ability to move a ring to user space / VM etc.
> *dynamically* goes away.
>

Wouldn't it be possible to do that dynamically using DT overlays? That
is "modprobe -r caam; <apply overlay>; modprobe caam"?

Thanks,
Andrey Smirnov
