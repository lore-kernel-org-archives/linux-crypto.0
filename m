Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B02C2BA83
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 08:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB2122314
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 08:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581668579;
	bh=CAUDYOHAxpzgSk4dH9LzDgYMj7W1GehoHR0osfY9APc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=vWwgBVmDjnvFsNtndjbxfPmYOpdETVq+cZi/WAME/f09KgUedwKer/ZK1sU6oep2Q
	 WxqiR+SdemS6Gcu1D7VClHruNh0WDNATzAPBxKJAo5Pb/Rh+F1VepzEv5Go8pQ/wjq
	 2DASbIg+IrjGsGgDy/bZ2fsJuUfGs9iZCFfq+j4s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgBNIWz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Feb 2020 03:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgBNIWz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Feb 2020 03:22:55 -0500
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B2920873;
        Fri, 14 Feb 2020 08:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581668574;
        bh=CAUDYOHAxpzgSk4dH9LzDgYMj7W1GehoHR0osfY9APc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Uk6/mwLUR5W3/ud1sldmbeb45MCd1Fl1CKUbldrD04IuPHH/ZLbl0ppw0R9yZv9i3
         MYqeaD/5+8egtscadO1SPGl/hZpVw1cY2a51NMNUShHbEwXuB+xJCTyuTSZT50As+W
         UIn6gudlpV7virbsQwzApZbRkQ4X2GpOfTmh0J8s=
Received: by mail-lf1-f47.google.com with SMTP id 9so6167767lfq.10;
        Fri, 14 Feb 2020 00:22:54 -0800 (PST)
X-Gm-Message-State: APjAAAVnV8Yl5Acq7FO76omW5xjrxrgJQbYQ0y0cvXstucjEZE4toDv5
        StjkevlJyZDv2Kpil0DbWF+HU/h8cjioxfdYEjk=
X-Google-Smtp-Source: APXvYqygz595VZtIB1bmK9QpUmp9Hrm9Q60QrKMX39CEshybGg+QqX1q6wv8aokUdidPVihrSFK5z3hncXqLvwv2OHU=
X-Received: by 2002:a19:becc:: with SMTP id o195mr1090646lff.17.1581668572226;
 Fri, 14 Feb 2020 00:22:52 -0800 (PST)
MIME-Version: 1.0
References: <CGME20200213180724eucas1p1bb96993e9d0300cddf348d5d442f43aa@eucas1p1.samsung.com>
 <20200213172130.GA13395@embeddedor> <546155af-e766-1d13-013d-b8b073e262b5@samsung.com>
In-Reply-To: <546155af-e766-1d13-013d-b8b073e262b5@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 14 Feb 2020 09:22:40 +0100
X-Gmail-Original-Message-ID: <CAJKOXPeCF7be5xNO3uMmrJ1VC4MK61RxxhuAve6zi56rR1TZ=A@mail.gmail.com>
Message-ID: <CAJKOXPeCF7be5xNO3uMmrJ1VC4MK61RxxhuAve6zi56rR1TZ=A@mail.gmail.com>
Subject: Re: [PATCH] crypto: s5p-sss - Replace zero-length array with
 flexible-array member
To:     Kamil Konieczny <k.konieczny@samsung.com>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 14 Feb 2020 at 08:09, Kamil Konieczny <k.konieczny@samsung.com> wrote:
>
> On 13.02.2020 18:21, Gustavo A. R. Silva wrote:
> > The current codebase makes use of the zero-length array language
> > extension to the C90 standard, but the preferred mechanism to declare
> > variable-length types such as these ones is a flexible array member[1][2],
> > introduced in C99:
> >
> > struct foo {
> >         int stuff;
> >         struct boo array[];
> > };
> >
> > By making use of the mechanism above, we will get a compiler warning
> > in case the flexible array does not occur last in the structure, which
> > will help us prevent some kind of undefined behavior bugs from being
> > inadvertently introduced[3] to the codebase from now on.
> >
> > Also, notice that, dynamic memory allocations won't be affected by
> > this change:
> >
> > "Flexible array members have incomplete type, and so the sizeof operator
> > may not be applied. As a quirk of the original implementation of
> > zero-length arrays, sizeof evaluates to zero."[1]
> >
> > This issue was found with the help of Coccinelle.
> >
> > [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > [2] https://protect2.fireeye.com/url?k=7fbec6f4-22720d30-7fbf4dbb-0cc47a314e9a-2a4d03985644c7ed&u=https://github.com/KSPP/linux/issues/21
> > [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> >
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> >  drivers/crypto/s5p-sss.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > index d66e20a2f54c..2a16800d2579 100644
> > --- a/drivers/crypto/s5p-sss.c
> > +++ b/drivers/crypto/s5p-sss.c
> > @@ -369,7 +369,7 @@ struct s5p_hash_reqctx {
> >       bool                    error;
> >
> >       u32                     bufcnt;
> > -     u8                      buffer[0];
> > +     u8                      buffer[];
> >  };
> >
> >  /**
> >
>
> Looks good to me.
>
> Acked-by: Kamil Konieczny <k.konieczny@samsung.com>

Why not making it simple/obvious u8 *buffer? Or fixed length (BUFLEN length)?

Best regards,
Krzysztof
