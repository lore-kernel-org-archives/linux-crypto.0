Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54410C4363D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 18:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095C62064B
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600972839;
	bh=CwoWn4pPpGJc8jFhcSgJEUsOzTd+e2vfSBl12+Mdrks=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=g8pRKpp4kqmLptL4LkBp2T54gSQ6/ifvsz75kW3heGg9+Kq5RqYy37fJvLjLvbqXg
	 9U8re79F2w5H20UpnRo5/NO1X59HbVIoy2iuknpFWxSYACrapw1Q23PEiQ1S34/e5H
	 YiIkcIjCMq2odQuZaAaX6j70CHE6x6rKLyDvebQs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgIXSki (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 14:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgIXSkh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 14:40:37 -0400
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB062074B
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600972837;
        bh=CwoWn4pPpGJc8jFhcSgJEUsOzTd+e2vfSBl12+Mdrks=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZNuFW5VFy1gaC+iI8wbjtwoGmb9qQ9O4tSbA6rF5VMV6bryEkSW7bU6rkzbeVXSmy
         M5A0Wuke01NkJtCJmru0lBMNRxrW963+51yKVFXnR5vFeExEEpfoZgs9TTTL4vBVd1
         O28Iult3sLeUDAlD41y08JBz+jW0Buxyy2M5LGC0=
Received: by mail-oo1-f49.google.com with SMTP id r4so110714ooq.7
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 11:40:37 -0700 (PDT)
X-Gm-Message-State: AOAM532M7/sEwC4r4g3PehtoPxLaIVc7gxpD9JnI9Tpbq1qtL9p9rw9g
        IcpGPuxIaSqnRY8XSHIIH84Duz/p5U5OREPPV60=
X-Google-Smtp-Source: ABdhPJzJ6fXIxLFMoDAhSD3+0oRCYecjmhpEjnS1L454rkNd7lWcVNXqj+RsS/UwaZErnDWz/BFR3aUfypfdyGp5cbk=
X-Received: by 2002:a4a:b443:: with SMTP id h3mr391558ooo.45.1600972836710;
 Thu, 24 Sep 2020 11:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-3-ardb@kernel.org>
 <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
 <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com>
 <CAD=FV=V4C1MD1e1zR-ed7j7Ym4-FEjZKfhq4tm7bt2GHP2cR+A@mail.gmail.com>
 <CAMj1kXEYhRdtf-zcs3PQY4ooqQSO5D_15_CpTOb+UUQQcsZ8YQ@mail.gmail.com> <CAD=FV=Vx+q=P+FrOX9m53uC365KEGZeffsOz9sqL1NP0Y_y+TQ@mail.gmail.com>
In-Reply-To: <CAD=FV=Vx+q=P+FrOX9m53uC365KEGZeffsOz9sqL1NP0Y_y+TQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 24 Sep 2020 20:40:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFfjcfqFuRV_4o8LB5icyv4LR2MLFH-pBzLtas-dMjt2g@mail.gmail.com>
Message-ID: <CAMj1kXFfjcfqFuRV_4o8LB5icyv4LR2MLFH-pBzLtas-dMjt2g@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: xor - use ktime for template benchmarking
To:     Doug Anderson <dianders@chromium.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Sep 2020 at 20:22, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Thu, Sep 24, 2020 at 8:36 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Thu, 24 Sep 2020 at 17:28, Doug Anderson <dianders@chromium.org> wrote:
> > >
> > > On Thu, Sep 24, 2020 at 1:32 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > ...
> > > > > > +#define REPS           100
> > > > >
> > > > > Is this sufficient?  I'm not sure what the lower bound on what's
> > > > > expected of ktime.  If I'm doing the math right, on your system
> > > > > running 100 loops took 38802 ns in one case, since:
> > > > >
> > > > > (4096 * 1000 * 100) / 10556 = 38802
> > > > >
> > > > > If you happen to have your timer backed by a 32 kHz clock, one tick of
> > > > > ktime could be as much as 31250 ns, right?  Maybe on systems backed
> > > > > with a 32kHz clock they'll take longer, but it still seems moderately
> > > > > iffy?  I dunno, maybe I'm just being paranoid.
> > > > >
> > > >
> > > > No, that is a good point - I didn't really consider that ktime could
> > > > be that coarse.
> > > >
> > > > OTOH, we don't really need the full 5 digits of precision either, as
> > > > long as we don't misidentify the fastest algorithm.
> > > >
> > > > So I think it should be sufficient to bump this to 800. If my
> > > > calculations are correct, this would limit any potential
> > > > misidentification of algorithms performing below 10 GB/s to ones that
> > > > only deviate in performance up to 10%.
> > > >
> > > > 800 * 1000 * 4096 / (10 * 31250) = 10485
> > > > 800 * 1000 * 4096 / (11 * 31250) = 9532
> > > >
> > > > (10485/9532) / 10485 = 10%
> > >
> > > Seems OK to me.  Seems unlikely that super fast machine are going to
> > > have a 32 kHz backed k_time and the worst case is that we'll pick a
> > > slightly sub-optimal xor, I guess.  I assume your goal is to keep
> > > things fitting in a 32-bit unsigned integer?  Looks like if your use
> > > 1000 it also fits...
> > >
> >
> > Yes, but the larger we make this number, the more time the test will
> > take on such slow machines. Doing 1000 iterations of 4k on a low-end
> > machine that only manages 500 MB/s (?) takes a couple of milliseconds,
> > which is more than it does today when HZ=1000 I think.
> >
> > Not that 800 vs 1000 makes a great deal of difference in that regard,
> > just illustrating that there is an upper bound as well.
>
> Would it make sense to use some type of hybrid approach?  I know
> getting ktime itself has some overhead so you don't want to do it in a
> tight loop, but maybe calling it every once in a while would be
> acceptable and if it's been more than 500 us then stop early?
>

To be honest, I don't think we don't need complexity like this - if
boot time is critical on such a slow system, you probable won't have
XOR built in, assuming it even makes sense to do software XOR on such
a system.

It is indeed preferable to have a numerator that fits in a U32, and so
1000 would be equally suitable in that regard, but I think I will
stick with 800 if you don't mind.
