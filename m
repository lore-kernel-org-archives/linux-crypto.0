Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39447C4346E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 15:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCDB62344C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600961785;
	bh=I2TWx9Op6anjKjYUpCeziCXvkOBowBk2gwk+06/5KHw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=dQmNz+4moBZg4/YkP15VBLXk0YaKwvfJVAbRqFin/ov47fj9VpWMocHA5V0yPHpzv
	 e/Lzmc9aIAwc8Rc+qPcPWJAuQcTXPK1FqrusT91qxV8CrFczv0L6m6vHZe6zarV7lz
	 voUc1ws4eKxOn2bghKcwIOD6FsgvL973M0TPkbv4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgIXPgZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgIXPgZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 11:36:25 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0FD72311A
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600961784;
        bh=I2TWx9Op6anjKjYUpCeziCXvkOBowBk2gwk+06/5KHw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sqfkoz8TsPTkLpxvDsChbx9zQhsAPTjSyfmNViZo8O8uLtJH8rwXsIeKpgLetJUhf
         RDpzyxWzdqR9zbZVBnhFJ2KCrCZumqRLcERn1urju/+hh+xpEu+RQRNeqEFvocqRjB
         pxQXp67v4j6WNQg4wpSN2RzrPEPlrNcJ7jcl7fbo=
Received: by mail-oi1-f169.google.com with SMTP id 185so4042013oie.11
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 08:36:24 -0700 (PDT)
X-Gm-Message-State: AOAM5313SnGPr9IjZCL3V5vlN0DZ4njUsse0X194AgnwHdDPrQ1ktZGF
        qRFI17xJcNw4BOH+Xd7AJnx3FjvNTNHaJxDmvQo=
X-Google-Smtp-Source: ABdhPJwtXsHpdmoAWQAfvLBEnf2nEt/PloTFfIi7EtAZUjzIMEvOW5je2QrrwXeCrL5XLU3pqBSKlZz5Qgz1O2woUmo=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr2829291oic.33.1600961783851;
 Thu, 24 Sep 2020 08:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-3-ardb@kernel.org>
 <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
 <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com> <CAD=FV=V4C1MD1e1zR-ed7j7Ym4-FEjZKfhq4tm7bt2GHP2cR+A@mail.gmail.com>
In-Reply-To: <CAD=FV=V4C1MD1e1zR-ed7j7Ym4-FEjZKfhq4tm7bt2GHP2cR+A@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 24 Sep 2020 17:36:12 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEYhRdtf-zcs3PQY4ooqQSO5D_15_CpTOb+UUQQcsZ8YQ@mail.gmail.com>
Message-ID: <CAMj1kXEYhRdtf-zcs3PQY4ooqQSO5D_15_CpTOb+UUQQcsZ8YQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: xor - use ktime for template benchmarking
To:     Doug Anderson <dianders@chromium.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Sep 2020 at 17:28, Doug Anderson <dianders@chromium.org> wrote:
>
> On Thu, Sep 24, 2020 at 1:32 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
...
> > > > +#define REPS           100
> > >
> > > Is this sufficient?  I'm not sure what the lower bound on what's
> > > expected of ktime.  If I'm doing the math right, on your system
> > > running 100 loops took 38802 ns in one case, since:
> > >
> > > (4096 * 1000 * 100) / 10556 = 38802
> > >
> > > If you happen to have your timer backed by a 32 kHz clock, one tick of
> > > ktime could be as much as 31250 ns, right?  Maybe on systems backed
> > > with a 32kHz clock they'll take longer, but it still seems moderately
> > > iffy?  I dunno, maybe I'm just being paranoid.
> > >
> >
> > No, that is a good point - I didn't really consider that ktime could
> > be that coarse.
> >
> > OTOH, we don't really need the full 5 digits of precision either, as
> > long as we don't misidentify the fastest algorithm.
> >
> > So I think it should be sufficient to bump this to 800. If my
> > calculations are correct, this would limit any potential
> > misidentification of algorithms performing below 10 GB/s to ones that
> > only deviate in performance up to 10%.
> >
> > 800 * 1000 * 4096 / (10 * 31250) = 10485
> > 800 * 1000 * 4096 / (11 * 31250) = 9532
> >
> > (10485/9532) / 10485 = 10%
>
> Seems OK to me.  Seems unlikely that super fast machine are going to
> have a 32 kHz backed k_time and the worst case is that we'll pick a
> slightly sub-optimal xor, I guess.  I assume your goal is to keep
> things fitting in a 32-bit unsigned integer?  Looks like if your use
> 1000 it also fits...
>

Yes, but the larger we make this number, the more time the test will
take on such slow machines. Doing 1000 iterations of 4k on a low-end
machine that only manages 500 MB/s (?) takes a couple of milliseconds,
which is more than it does today when HZ=1000 I think.

Not that 800 vs 1000 makes a great deal of difference in that regard,
just illustrating that there is an upper bound as well.
