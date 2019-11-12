Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C93C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 15:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F7521872
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 15:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EgVidAD9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfKLPNS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 10:13:18 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35888 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLPNR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 10:13:17 -0500
Received: by mail-wm1-f68.google.com with SMTP id c22so3363117wmd.1;
        Tue, 12 Nov 2019 07:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nEF0qKikqTlAnpShS2FcIHrm5l9Lahx1quofGqUiOc=;
        b=EgVidAD9FDkC5A71SMsUj1pakbjPpt3A/2Q1n5qjAbODshf40xWRhDdrsUJoJHjAr0
         +UhiZgkzyKKnuxsPFq8kYOVzyc1khRQzMJPRWiuTvDcX9487pTXVVgWHYWE0lluShNWu
         Yw7PD7tl/xkFciCFd1trYCvO+m/6xI3EKsc6ts4IjeYDB9ZzLdey6oSp06zTWOtASiu3
         pPzH4relz4TNi1EpCYa2/fkl8pLuh+K5AzPWfZgh62jDIYJQcY9Lsb8HWKtjl2Qe823z
         8ZLhY5vm7bwyjqFAvfULM6Lx0P0EViVo7a8f8Ro5qEPIekagNpjdsAWZ4y5kXZWbLPDM
         AB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nEF0qKikqTlAnpShS2FcIHrm5l9Lahx1quofGqUiOc=;
        b=syZYPEsncqZKWWzpiEsvo0BH/JVi55Hg8+1f4W1YEw1d/YKivGiIqVz5MPhsWybzZI
         hnjuZuzYQRtsygYaKX4gqRrUHIsNsqp42aG0Bk6a5NeMjQGdXeh8rjGNhek69mhQlLcN
         fvanKc1isMITbG88z6j/oQfU+65GRCUOCuJ1UcedM057JsADrVUn/FiA3Vv2IgTDiXHy
         8+Xa02VeX2Bo+V8OJM0jDwxsOXAmtWk4XH0osTIxVevNxeOkMxcJe+M1zCneW2xxqR91
         PGzGjWV4cqZ3ClLAXBvEjvRaI9iAZTvj7TdFZ9rLBf/uwaseuwKUOL1wRF4da6lLWkV4
         F33Q==
X-Gm-Message-State: APjAAAXBdwZEjcsFfkZ9g6Orta77nVGlbFOiVac+CbfukyDdOkw/lFDO
        hQe9krVpc/nonvp5hvYCMTqsr1XcNrG580BsP6w=
X-Google-Smtp-Source: APXvYqygK/Wn08Lde96j8W82CJ7mCPvYekJ3iLPSCP9mv3A9JKDTOoslxsRolBUoRE8YMai1/STgMSKB3+EnwLuPt6U=
X-Received: by 2002:a1c:e308:: with SMTP id a8mr4389172wmh.55.1573571594299;
 Tue, 12 Nov 2019 07:13:14 -0800 (PST)
MIME-Version: 1.0
References: <20191029162916.26579-1-andrew.smirnov@gmail.com>
 <226f5a669c2199408abcdec0ccddc9ff05672631.camel@pengutronix.de>
 <CAHQ1cqF3BgberQMMY3sKH5iabG3oN6-H=o-y00Q710zrB7KNgw@mail.gmail.com> <20191108151948.ojn6ga3preh66utl@gondor.apana.org.au>
In-Reply-To: <20191108151948.ojn6ga3preh66utl@gondor.apana.org.au>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 12 Nov 2019 07:13:02 -0800
Message-ID: <CAHQ1cqGAtw5UVqGbr-05Tg0V9bXRRyP6SjqrXCiuwmLbgRrOBA@mail.gmail.com>
Subject: Re: [PATCH 0/3] enable CAAM's HWRNG as default
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 8, 2019 at 7:19 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Oct 29, 2019 at 12:58:24PM -0700, Andrey Smirnov wrote:
> >
> > > I'm not sure if we can ever use the job based RNG interface to hook it
> > > up to the Linux HWRNG interface. After all the job based RNG interface
> > > is always a DRNG, which only gets seeded by the TRNG. The reseed
> > > interval is given in number of clock cycles, so there is no clear
> > > correlation between really true random input bits and the number of
> > > DRNG output bits.
> >
> > Doesn't enabling prediction resistance gives us that correlation? E.g.
> > that every time new random data is generated, DRNG is reseeded? I am
> > assuming even if this is true we'd have to significantly limit
> > generated data length (< seed length?), so maybe what you propose
> > below is still simpler.
>
> Prediction resistance should be sufficient in general.  However,
> is the prediction resistance reseeding done in real time?
>

If I am reading the datasheet right reseeding should be done every
time CAAM is asked to generated random data.

> > > I've hacked up some proof of concept code which uses the TRNG access in
> > > the control interface to get the raw TRNG random bits. This seems to
> > > yield about 6400 bit/s of true entropy. It may be better to use this
> > > interface to hook up to the Linux HWRNG framework.
> >
> > OK, I'll take a look into that and send out a v2 with results.
>
> I've backed out the patch-set for now but if we can clarify the
> prediction resistance implementation details then I'm happy to
> put it back in.

Even if prediction resistance is an acceptable approach, would it be
better to expose underlying TRNG and downgrade current CAAM hwrng code
to crypto rng API? If that's the best path forward, I am more than
happy to go that way in v2.

Thanks,
Andrey Smirnov
