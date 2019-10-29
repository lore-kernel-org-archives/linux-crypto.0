Return-Path: <SRS0=WkI6=YW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907F2CA9EAE
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 19:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D5842086A
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 19:58:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIfLPB0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfJ2T6i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Oct 2019 15:58:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45777 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfJ2T6i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Oct 2019 15:58:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id q13so14989274wrs.12;
        Tue, 29 Oct 2019 12:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b7IvYuP/9lAkoKJJR5jbNA9xfToVvOCAxEvOAT3opgI=;
        b=DIfLPB0ndh9iMMWhIe9GfJxhMem4O7bx1KQexiAM7D/v9DiOIldiQk1mbr5MIWI4MB
         398w+qJQad6XigNmOxC1ybZ7rVv5TOgKBg931XBqMx9NsyEE/mSEtCPNb7bXS3v4nkGT
         nsTJRyu7axYIfyZWqHwayHYFuPIAVdNWjXMVAow0VvV73VuglA3FQMUowOuwlkZbyMoz
         2XRDvLtQuFbdVeC6d22+n7smHVFUFLS79LrCxA+cX4bzFjUihOoCiaGrjqZKVbHKXhK0
         gQG3pCnZOx1i//kjRule98dXzsGFDfzfZq0NP1W3EI83bep3BV3Y2wvJoCjIKDS4qJbb
         tZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b7IvYuP/9lAkoKJJR5jbNA9xfToVvOCAxEvOAT3opgI=;
        b=BB/FvnF1Aiuz+W2D/wVvg2eSVEmFPEbHvFTwxC5CPWS2mDWywxWBq3q/JJTQZrSGPm
         zmmsWCSYTcBiqs5/7oujGMsX07e7wlfbgFUBN6jSzpni68gcX2XS0GIC3CGOIZtoo2dy
         7m1GOKUzv1e/+pPJNjfDBf/jL+6odt6rqanzSCWFvcM1AFGzhcW+CqffPaqOJarPDQ0N
         eeALR+CknYo6PM0+K+127bbUbmRuP0ejCgvdgk9jCc1S1+/TwJ27cTH71GVE4oBk9+io
         1DPkSTkL1goOBNYhU7XwcTMu2nYkttZl6vfI03rqM7FvnEyAxEdnydUjCfr/b2Y8ICwT
         qsSg==
X-Gm-Message-State: APjAAAUE18a8ICWrCemWE2+Nb8mKZu6C5zSIj58qFGjCzcPP0UWv0Piy
        TD9MY18V1PfCKxuaLFNceQ7P1XPrOK852fJYDwfFtw==
X-Google-Smtp-Source: APXvYqwMUZUIE4NWGMxmA5FuaGCauNE/7brDJDjAWOQsPbl8iqaD2FM3cbqhGEkBSVi2QlVXcssay2Cf7soKDLK1eTs=
X-Received: by 2002:a5d:444b:: with SMTP id x11mr21557409wrr.207.1572379115494;
 Tue, 29 Oct 2019 12:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191029162916.26579-1-andrew.smirnov@gmail.com> <226f5a669c2199408abcdec0ccddc9ff05672631.camel@pengutronix.de>
In-Reply-To: <226f5a669c2199408abcdec0ccddc9ff05672631.camel@pengutronix.de>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 29 Oct 2019 12:58:24 -0700
Message-ID: <CAHQ1cqF3BgberQMMY3sKH5iabG3oN6-H=o-y00Q710zrB7KNgw@mail.gmail.com>
Subject: Re: [PATCH 0/3] enable CAAM's HWRNG as default
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 29, 2019 at 9:43 AM Lucas Stach <l.stach@pengutronix.de> wrote:
>
> On Di, 2019-10-29 at 09:29 -0700, Andrey Smirnov wrote:
> > Everyone:
> >
> > This series is a continuation of original [discussion]. I don't know
> > if what's in the series is enough to use CAAMs HWRNG system wide, but
> > I am hoping that with enough iterations and feedback it will be.
> >
> > Feedback is welcome!
>
> I'm not sure if we can ever use the job based RNG interface to hook it
> up to the Linux HWRNG interface. After all the job based RNG interface
> is always a DRNG, which only gets seeded by the TRNG. The reseed
> interval is given in number of clock cycles, so there is no clear
> correlation between really true random input bits and the number of
> DRNG output bits.
>

Doesn't enabling prediction resistance gives us that correlation? E.g.
that every time new random data is generated, DRNG is reseeded? I am
assuming even if this is true we'd have to significantly limit
generated data length (< seed length?), so maybe what you propose
below is still simpler.

> I've hacked up some proof of concept code which uses the TRNG access in
> the control interface to get the raw TRNG random bits. This seems to
> yield about 6400 bit/s of true entropy. It may be better to use this
> interface to hook up to the Linux HWRNG framework.
>

OK, I'll take a look into that and send out a v2 with results.

Thanks,
Andrey Smirnov
