Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E400C282DD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BE052067D
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uEShmPzw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgAHPu0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:50:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45844 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgAHPu0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 10:50:26 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so3841922wrj.12;
        Wed, 08 Jan 2020 07:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0N3N55mKu7D6d7h9hmn6IsvaDLGUWysqQq54G06xnmc=;
        b=uEShmPzw5xgcVfK3GcKJ1pcAbUUKIEsRASYH9i+gdlGVyVcjN/bjZt8ucd4xpTahK6
         glwEk3CBwPVEP34eMIfafPiylQFDJd7Ee75Er8GaCG0KEfZpuynSACF69GFFom7n499C
         uQslmQ7fcLEVWISoJY2nFAJNc/282zr360qcqlhazBJBXjVoawMpqJW6jC0zOLV9MDXa
         EPuF3iAtAPF2sCwRpZEdnFbml75XX3/6YdRh2iSR+mdI/WXQKIkTUj4BrMocvw6GmbsX
         8plbDRm4oHg/3sCv9OkAsPM/6HY18h0R28eeMwKk5ty2UYPaXCcJj7MvTj03fR6BP4HK
         Zh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0N3N55mKu7D6d7h9hmn6IsvaDLGUWysqQq54G06xnmc=;
        b=gYpO2GtInG8wYMJwWMQZam20NhqumYmtwjxrQ40UUkbLqfbLUHd56pkLWbKh1F4o6z
         kc6McJiSrxYyEAWOvKxjW86Y8mEnIAUdWPNXLZ/LWqB9yJ/SVPIpijgQF+cz4SChDwXm
         4XtgVgW+1zzci3YU+sOpDPuhJ0n0D1Ccq0PHUJqOfVDuYVGI+dL2RZAdCF2MPaYpD1j/
         wVuEJhC70ljvbEMGsT4/54t3kd7aHVwTVTXfTmGAGC9XwCKOdOxAmMZ0dqwLq9kD8Wiv
         g13iLej5R5rJJjjD5ibTWb9kUM/IEgut+0vkSqls3e+b8r7iTDQcdFH8f/Q2fRdNMtR3
         UNeg==
X-Gm-Message-State: APjAAAWmxCphBSRdbuADFplYmylcLDvkMcFEBbWFLio37+r0Hc3BWIwZ
        yyKffDSRYvtEn+j87U8ZUUIqvS7nxcSVKUurFXQ=
X-Google-Smtp-Source: APXvYqxPEibow2/dOPHBHRrXKbKanMI8VD5bNxb9vyWi016tP8DINM//hzIULp8SZLVtL0ef1MxEO7LiWO1kexZKxMk=
X-Received: by 2002:adf:e78b:: with SMTP id n11mr5355464wrm.10.1578498624011;
 Wed, 08 Jan 2020 07:50:24 -0800 (PST)
MIME-Version: 1.0
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
 <DB7PR04MB4620E3087C59A26B865DEE988B790@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <CAHQ1cqH5hstMwbO1vqOkZ3GVe-j5a+c3TX-yosq-TvuFFxPkHQ@mail.gmail.com>
 <VI1PR0402MB34851C1681F8A18341A8971098760@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqFPmJ7AR3ftTyCy4DiE0YQgspPBnp+EQLPOwxXo6tTcYg@mail.gmail.com> <CAHQ1cqE2PGKUPfc8SUAw2TkuDXRbFtnyux=bWyOny21KK8dhjA@mail.gmail.com>
In-Reply-To: <CAHQ1cqE2PGKUPfc8SUAw2TkuDXRbFtnyux=bWyOny21KK8dhjA@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 8 Jan 2020 07:50:12 -0800
Message-ID: <CAHQ1cqFR4ztK7zToN3OeTDYEXaGMkLa8uY3ka+Sgmf3dwxJsFg@mail.gmail.com>
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

On Sat, Nov 16, 2019 at 10:15 PM Andrey Smirnov
<andrew.smirnov@gmail.com> wrote:
>
> On Wed, Nov 13, 2019 at 11:25 AM Andrey Smirnov
> <andrew.smirnov@gmail.com> wrote:
> >
> > On Wed, Nov 13, 2019 at 10:57 AM Horia Geanta <horia.geanta@nxp.com> wrote:
> > >
> > > On 11/6/2019 5:19 PM, Andrey Smirnov wrote:
> > > > On Tue, Nov 5, 2019 at 11:27 PM Vakul Garg <vakul.garg@nxp.com> wrote:
> > > >>
> > > >>
> > > >>
> > > >>> -----Original Message-----
> > > >>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-
> > > >>> owner@vger.kernel.org> On Behalf Of Andrey Smirnov
> > > >>> Sent: Tuesday, November 5, 2019 8:44 PM
> > > >>> To: linux-crypto@vger.kernel.org
> > > >>> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>; Chris Healy
> > > >>> <cphealy@gmail.com>; Lucas Stach <l.stach@pengutronix.de>; Horia Geanta
> > > >>> <horia.geanta@nxp.com>; Herbert Xu <herbert@gondor.apana.org.au>;
> > > >>> Iuliana Prodan <iuliana.prodan@nxp.com>; dl-linux-imx <linux-
> > > >>> imx@nxp.com>; linux-kernel@vger.kernel.org
> > > >>> Subject: [PATCH 0/5] CAAM JR lifecycle
> > > >>>
> > > >>> Everyone:
> > > >>>
> > > >>> This series is a different approach to addressing the issues brought up in
> > > >>> [discussion]. This time the proposition is to get away from creating per-JR
> > > >>> platfrom device, move all of the underlying code into caam.ko and disable
> > > >>> manual binding/unbinding of the CAAM device via sysfs. Note that this series
> > > >>> is a rough cut intented to gauge if this approach could be acceptable for
> > > >>> upstreaming.
> > > >>>
> > > >>> Thanks,
> > > >>> Andrey Smirnov
> > > >>>
> > > >>> [discussion] lore.kernel.org/lkml/20190904023515.7107-13-
> > > >>> andrew.smirnov@gmail.com
> > > >>>
> > > >>> Andrey Smirnov (5):
> > > >>>   crypto: caam - use static initialization
> > > >>>   crypto: caam - introduce caam_jr_cbk
> > > >>>   crypto: caam - convert JR API to use struct caam_drv_private_jr
> > > >>>   crypto: caam - do not create a platform devices for JRs
> > > >>>   crypto: caam - disable CAAM's bind/unbind attributes
> > > >>>
> > > >>
> > > >> To access caam jobrings from DPDK (user space drivers), we unbind job-ring's platform device from the kernel.
> > > >> What would be the alternate way to enable job ring drivers in user space?
> > > >>
> > > >
> > > > Wouldn't either building your kernel with
> > > > CONFIG_CRYPTO_DEV_FSL_CAAM_JR=n (this series doesn't handle that right
> > > > currently due to being a rough cut) or disabling specific/all JRs via
> > > > DT accomplish the same goal?
> > > >
> > > It's not a 1:1 match, the ability to move a ring to user space / VM etc.
> > > *dynamically* goes away.
> > >
> >
> > Wouldn't it be possible to do that dynamically using DT overlays? That
> > is "modprobe -r caam; <apply overlay>; modprobe caam"?
> >
>
> Or, alternatively, could adding a module parameter, say "jr_mask", to
> limit JRs controlled by the driver cover dynamic use case?
>

Horia, could you please comment on the above? I think getting rid of
struct device for JRs is the best approach to dealing with described
corner case problems + it will allows us to get rid of this custom JR
users lifecycle management
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/crypto/caam/jr.c?h=v5.4.8#n26
since it can be just done as a part for caam_probe(), so I'd like to
either move forward on this series or close this discussion.

Thanks,
Andrey Smirnov
