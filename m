Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1CCC5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 06:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 593BA21881
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 06:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oQrvKYN6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfGCGhr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 02:37:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40495 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfGCGhq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 02:37:46 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so2153457ioc.7;
        Tue, 02 Jul 2019 23:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FOIxNlDzVh5kXdl9uOiCioxQI2rCCNBXDcfxZ9oiGn4=;
        b=oQrvKYN6+Oa/mi5oqHJm/0u1d3bIJSZvqt/2eGg8P4ktEZTx14HyMyCIxEvYI2B47V
         4VsUmdNttA9TSM+TZLgpm0PDvKjyAgy6GUAREped91mDu/QX+CltfgdXh38jba5ZKmhd
         P2AK0d/w1qNtPkjFY9xb5mktdhaE7uih5Av11615R4hJy0wb0yzqczDF7HYpVFJpv6/6
         s3hCxB8VolfGSXpmccI/iIYtGaaqPGqKhLuh5cU3IXY74iOMUdruB89oozjiPO3Dy+gr
         pZlFmom46AbUUceksx7V0grs2DsemIajtC3WLtW8zVxkoNwidJm0HYjD3bK6ejRS98NQ
         05ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FOIxNlDzVh5kXdl9uOiCioxQI2rCCNBXDcfxZ9oiGn4=;
        b=UEDxaF+aYdGrgVc3Gt1/Du0+jG0uYirsVwt55eUdCSEG6tO0p1Vv3dHiQ8PrAuVDEf
         jRVl4RybltNLOPkjXod4eA+ZtgPV4Ih9JvvtCo9B4I1av7KxDyMNh7d6n3FyiQJSwp3Z
         BXZMva5a1U33rOC9phhiA5fKVB825N8TxCxdnmyfUpDFfn0pDsFArBZKL3L1khQv5SaH
         xUHteoje2g+A4F6EEACFCaY/CaWkf8EQcVMiah6GL4aeNKQhYRMpi1EP2+fpAmQ/B1O6
         LsXpmiDerVCnaigWPAKAfeEUgewQiOlprSn/AuIng+pfKT/V/1tVxXWvR08vvhN6ZmMo
         cNmw==
X-Gm-Message-State: APjAAAUPHhJ/YlGRPF5U4A60Bw0qsM33lvgcZHAbsfIqA+A7dYQxmDeG
        7cVp5ZWeJFeBtFKUEuqAQLqGtgDl9yHi6h83ROeqpeV+
X-Google-Smtp-Source: APXvYqzUoLIbKm+T5fsnG1Of6uNoe9L4Lk43sPF5Mm1NCv7QtIHFm6oVd5rzrOle8bjQuRlwvYUdK+/9Ip+p+q6a0f8=
X-Received: by 2002:a6b:4107:: with SMTP id n7mr4379048ioa.12.1562135865720;
 Tue, 02 Jul 2019 23:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
 <20190617160339.29179-2-andrew.smirnov@gmail.com> <VI1PR0402MB3485542286BC0F8814DE4EB098FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485542286BC0F8814DE4EB098FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 2 Jul 2019 23:37:41 -0700
Message-ID: <CAHQ1cqH4t7zge8ceNQ9GSA=ioMNJxerz9qJ4vtgY_Gh0Bz689A@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] crypto: caam - move DMA mask selection into a function
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 27, 2019 at 3:50 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 6/17/2019 7:04 PM, Andrey Smirnov wrote:
> > Exactly the same code to figure out DMA mask is repeated twice in the
> > driver code. To avoid repetition, move that logic into a standalone
> > subroutine in intern.h. While at it re-shuffle the code to make it
> > more readable with early returns.
> >
> > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > Cc: Chris Spencer <christopher.spencer@sea.co.uk>
> > Cc: Cory Tusar <cory.tusar@zii.aero>
> > Cc: Chris Healy <cphealy@gmail.com>
> > Cc: Lucas Stach <l.stach@pengutronix.de>
> > Cc: Horia Geant=C4=83 <horia.geanta@nxp.com>
> > Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> > Cc: Leonard Crestez <leonard.crestez@nxp.com>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
>
> Being the 1st patch in the series and not i.MX8-specific, I'd say it shou=
ld
> be merged separately.
>

Can it be done by cherry picking it from the series or does it have to
be submitted as a separate patch? I am hoping the former is possible
since it'd make life easier for me.

Thanks,
Andrey Smirnov
