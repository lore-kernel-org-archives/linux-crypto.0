Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48077C432C3
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 06:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17DF520730
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 06:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgOwvPAx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfKQGPw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 01:15:52 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55736 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfKQGPv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 01:15:51 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so13997058wmb.5;
        Sat, 16 Nov 2019 22:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EyNqLWyu6a7Cs2JPGUTSzAWG/6GCveav2mKSjBErowo=;
        b=cgOwvPAxaH/n63Wg25tXMcm2kFvQNkQ6C3fJxB75FISbd+/+3ZKYYQDA/WdV+ErTMW
         M+wkpYzIImb61DSmNWELZCAEWsgl6a78nnMyjddYQ7FKpQ/jFh3KK49qbmlNP7oBYvWh
         z0mYXOrDmM4n+Uq51brbWpFBr52bPV7shjiyJ4iQ0aeHhXphBe3P62AsVcLWmw/HfX0G
         4lyjpCC7hEdBW4cwdVe/1AAL/Hl9hFFJpzu8DFSCeclPBX3jR1JXTtrq/GH6QdwNs3+9
         tH7UqbWzA/qR4Pw7mwhIS2w+tY6KOe6Wy2QHhQG/iw//8Tz/nup9KrpKKRc++R1TMVLA
         TICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EyNqLWyu6a7Cs2JPGUTSzAWG/6GCveav2mKSjBErowo=;
        b=L/IjnV4E7EiwSbkbtyC2u0x+Z5g1FAKUcbZ2L5mv2odAih69h+9+WjqyQuokCDqHEK
         /vbde3CkqzGwsPlTzSBTdXpFPit19+Tbt3Rc6SofYSPIqxT+Y9Rb6RRaia5qZHw5A9Ek
         MKPuHd5+PTccM48x76H9IffWIt/aam+oz8aAx/ioU4uwMbpk10Mr2hpmQZK2SHKbl08G
         VwXtGyJryVkJeTNCkCzX/fLYndBLraHaf/GTcQ0LfLecxJxan1mb99h/IS54hs37GFFU
         9FBCzS/gcECXYGW0ExA1VMtkaHc5uaDhsAN8olz8NvytoS4yD8vggzKszJ2qet387DWp
         UIvg==
X-Gm-Message-State: APjAAAX4vbxmE9a3xOovYTUfV8NtJmE+YPnoiDWLXubjjKOlNz7LZmif
        0H0hb0NQMZPSN4T/Km0Wi/NObKeQ4DKLmWNBvkQ=
X-Google-Smtp-Source: APXvYqx57AovMcTShdige/GJB4acv8FfpRlEPpn6owfAYHaZ8lJYhiSzJ1E4FBLOQr3BcxVRNA37QNEcUFK2aWHRSqI=
X-Received: by 2002:a7b:ce11:: with SMTP id m17mr24822936wmc.113.1573971349494;
 Sat, 16 Nov 2019 22:15:49 -0800 (PST)
MIME-Version: 1.0
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
 <DB7PR04MB4620E3087C59A26B865DEE988B790@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <CAHQ1cqH5hstMwbO1vqOkZ3GVe-j5a+c3TX-yosq-TvuFFxPkHQ@mail.gmail.com>
 <VI1PR0402MB34851C1681F8A18341A8971098760@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqFPmJ7AR3ftTyCy4DiE0YQgspPBnp+EQLPOwxXo6tTcYg@mail.gmail.com>
In-Reply-To: <CAHQ1cqFPmJ7AR3ftTyCy4DiE0YQgspPBnp+EQLPOwxXo6tTcYg@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Sat, 16 Nov 2019 22:15:36 -0800
Message-ID: <CAHQ1cqE2PGKUPfc8SUAw2TkuDXRbFtnyux=bWyOny21KK8dhjA@mail.gmail.com>
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

On Wed, Nov 13, 2019 at 11:25 AM Andrey Smirnov
<andrew.smirnov@gmail.com> wrote:
>
> On Wed, Nov 13, 2019 at 10:57 AM Horia Geanta <horia.geanta@nxp.com> wrote:
> >
> > On 11/6/2019 5:19 PM, Andrey Smirnov wrote:
> > > On Tue, Nov 5, 2019 at 11:27 PM Vakul Garg <vakul.garg@nxp.com> wrote:
> > >>
> > >>
> > >>
> > >>> -----Original Message-----
> > >>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-
> > >>> owner@vger.kernel.org> On Behalf Of Andrey Smirnov
> > >>> Sent: Tuesday, November 5, 2019 8:44 PM
> > >>> To: linux-crypto@vger.kernel.org
> > >>> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>; Chris Healy
> > >>> <cphealy@gmail.com>; Lucas Stach <l.stach@pengutronix.de>; Horia Geanta
> > >>> <horia.geanta@nxp.com>; Herbert Xu <herbert@gondor.apana.org.au>;
> > >>> Iuliana Prodan <iuliana.prodan@nxp.com>; dl-linux-imx <linux-
> > >>> imx@nxp.com>; linux-kernel@vger.kernel.org
> > >>> Subject: [PATCH 0/5] CAAM JR lifecycle
> > >>>
> > >>> Everyone:
> > >>>
> > >>> This series is a different approach to addressing the issues brought up in
> > >>> [discussion]. This time the proposition is to get away from creating per-JR
> > >>> platfrom device, move all of the underlying code into caam.ko and disable
> > >>> manual binding/unbinding of the CAAM device via sysfs. Note that this series
> > >>> is a rough cut intented to gauge if this approach could be acceptable for
> > >>> upstreaming.
> > >>>
> > >>> Thanks,
> > >>> Andrey Smirnov
> > >>>
> > >>> [discussion] lore.kernel.org/lkml/20190904023515.7107-13-
> > >>> andrew.smirnov@gmail.com
> > >>>
> > >>> Andrey Smirnov (5):
> > >>>   crypto: caam - use static initialization
> > >>>   crypto: caam - introduce caam_jr_cbk
> > >>>   crypto: caam - convert JR API to use struct caam_drv_private_jr
> > >>>   crypto: caam - do not create a platform devices for JRs
> > >>>   crypto: caam - disable CAAM's bind/unbind attributes
> > >>>
> > >>
> > >> To access caam jobrings from DPDK (user space drivers), we unbind job-ring's platform device from the kernel.
> > >> What would be the alternate way to enable job ring drivers in user space?
> > >>
> > >
> > > Wouldn't either building your kernel with
> > > CONFIG_CRYPTO_DEV_FSL_CAAM_JR=n (this series doesn't handle that right
> > > currently due to being a rough cut) or disabling specific/all JRs via
> > > DT accomplish the same goal?
> > >
> > It's not a 1:1 match, the ability to move a ring to user space / VM etc.
> > *dynamically* goes away.
> >
>
> Wouldn't it be possible to do that dynamically using DT overlays? That
> is "modprobe -r caam; <apply overlay>; modprobe caam"?
>

Or, alternatively, could adding a module parameter, say "jr_mask", to
limit JRs controlled by the driver cover dynamic use case?

Thanks,
Andrey Smirnov
