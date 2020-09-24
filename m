Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDF4C4363D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 18:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 811B223600
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 18:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eGfpgt8Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgIXSxJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 14:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgIXSxI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 14:53:08 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0656DC0613CE
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 11:53:07 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id a16so2726764vsp.12
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 11:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mT72rm8aIeA5OKsWkhk1S6/B1aayEuL3CMeOL7guIKU=;
        b=eGfpgt8QZ2ymfvMv8oAcRngxRGpyHjKLwAcfaZNW91lGEDXCbhPgCVBFHebLrIVQ4D
         G1iKRav3k0TmvQRo2nB+3AfNiKCECtApAqfCiV2tBbtyXwjl4ceF5CchDdySlFXcikmu
         a1Pr6soGiOTjGgW4KxfUTHMAFfJR6xBH4nHCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mT72rm8aIeA5OKsWkhk1S6/B1aayEuL3CMeOL7guIKU=;
        b=tgplB6oz2EksI7UJUpumNDY0cEjOJd6fHUc9ORoGhviDfJpkhbE40iyTK/8tokKvbp
         WQy5tVfzYBGk59n10Ru6nTV7Wb8glQ7eoZ34jOnOpMmo6JpPjk2V/pOPG2uxByMyBKCw
         dYYdKkfTrG2B0suuIaPwgRGQCoh18uuLAhQWpuJ2m41Hz3tQQRS3GTGVzOAkO8iRJOC0
         t7oGcCcVVx4Z86OwyCpUcl/0fVv65qvs9AFzjHxLgRdHbSeX9w5hoBdRkFKbugVNkQ4q
         zRJ4t63MZo+VX4EAVN2+8iAeiFGd0Zi17MYvfpyAV2aKdQ8fGeKJ7nak9QQSHcokEeeQ
         BE1g==
X-Gm-Message-State: AOAM532WaQxW7G9OgRymNfOTYqB5lYMcUdKX+XLgh/3Oy8sobQmWWvyK
        e9oGzhn0MHDIw4Vyug/RMCh86acWC82N0Q==
X-Google-Smtp-Source: ABdhPJwqZ4gx9QuXUv7FNvds/3FtnpHQgjFHaaZIcz22FkqhjiQ6dh43/vfm8YoKeDdhQbA49d8YEw==
X-Received: by 2002:a05:6102:3107:: with SMTP id e7mr583571vsh.1.1600973586849;
        Thu, 24 Sep 2020 11:53:06 -0700 (PDT)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id z81sm56752vkd.22.2020.09.24.11.53.05
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 11:53:06 -0700 (PDT)
Received: by mail-vk1-f170.google.com with SMTP id a16so46133vke.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 11:53:05 -0700 (PDT)
X-Received: by 2002:ac5:cced:: with SMTP id k13mr663650vkn.7.1600973585517;
 Thu, 24 Sep 2020 11:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-3-ardb@kernel.org>
 <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
 <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com>
 <CAD=FV=V4C1MD1e1zR-ed7j7Ym4-FEjZKfhq4tm7bt2GHP2cR+A@mail.gmail.com>
 <CAMj1kXEYhRdtf-zcs3PQY4ooqQSO5D_15_CpTOb+UUQQcsZ8YQ@mail.gmail.com>
 <CAD=FV=Vx+q=P+FrOX9m53uC365KEGZeffsOz9sqL1NP0Y_y+TQ@mail.gmail.com> <CAMj1kXFfjcfqFuRV_4o8LB5icyv4LR2MLFH-pBzLtas-dMjt2g@mail.gmail.com>
In-Reply-To: <CAMj1kXFfjcfqFuRV_4o8LB5icyv4LR2MLFH-pBzLtas-dMjt2g@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 24 Sep 2020 11:52:54 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WxT1re11-hMPH=dVTw67cj-16UY5ybWv-C2+Z05DsE_g@mail.gmail.com>
Message-ID: <CAD=FV=WxT1re11-hMPH=dVTw67cj-16UY5ybWv-C2+Z05DsE_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: xor - use ktime for template benchmarking
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Sep 24, 2020 at 11:40 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 24 Sep 2020 at 20:22, Doug Anderson <dianders@chromium.org> wrote:
> >
> > Hi,
> >
> > On Thu, Sep 24, 2020 at 8:36 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > On Thu, 24 Sep 2020 at 17:28, Doug Anderson <dianders@chromium.org> wrote:
> > > >
> > > > On Thu, Sep 24, 2020 at 1:32 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > > >
> > > ...
> > > > > > > +#define REPS           100
> > > > > >
> > > > > > Is this sufficient?  I'm not sure what the lower bound on what's
> > > > > > expected of ktime.  If I'm doing the math right, on your system
> > > > > > running 100 loops took 38802 ns in one case, since:
> > > > > >
> > > > > > (4096 * 1000 * 100) / 10556 = 38802
> > > > > >
> > > > > > If you happen to have your timer backed by a 32 kHz clock, one tick of
> > > > > > ktime could be as much as 31250 ns, right?  Maybe on systems backed
> > > > > > with a 32kHz clock they'll take longer, but it still seems moderately
> > > > > > iffy?  I dunno, maybe I'm just being paranoid.
> > > > > >
> > > > >
> > > > > No, that is a good point - I didn't really consider that ktime could
> > > > > be that coarse.
> > > > >
> > > > > OTOH, we don't really need the full 5 digits of precision either, as
> > > > > long as we don't misidentify the fastest algorithm.
> > > > >
> > > > > So I think it should be sufficient to bump this to 800. If my
> > > > > calculations are correct, this would limit any potential
> > > > > misidentification of algorithms performing below 10 GB/s to ones that
> > > > > only deviate in performance up to 10%.
> > > > >
> > > > > 800 * 1000 * 4096 / (10 * 31250) = 10485
> > > > > 800 * 1000 * 4096 / (11 * 31250) = 9532
> > > > >
> > > > > (10485/9532) / 10485 = 10%
> > > >
> > > > Seems OK to me.  Seems unlikely that super fast machine are going to
> > > > have a 32 kHz backed k_time and the worst case is that we'll pick a
> > > > slightly sub-optimal xor, I guess.  I assume your goal is to keep
> > > > things fitting in a 32-bit unsigned integer?  Looks like if your use
> > > > 1000 it also fits...
> > > >
> > >
> > > Yes, but the larger we make this number, the more time the test will
> > > take on such slow machines. Doing 1000 iterations of 4k on a low-end
> > > machine that only manages 500 MB/s (?) takes a couple of milliseconds,
> > > which is more than it does today when HZ=1000 I think.
> > >
> > > Not that 800 vs 1000 makes a great deal of difference in that regard,
> > > just illustrating that there is an upper bound as well.
> >
> > Would it make sense to use some type of hybrid approach?  I know
> > getting ktime itself has some overhead so you don't want to do it in a
> > tight loop, but maybe calling it every once in a while would be
> > acceptable and if it's been more than 500 us then stop early?
> >
>
> To be honest, I don't think we don't need complexity like this - if
> boot time is critical on such a slow system, you probable won't have
> XOR built in, assuming it even makes sense to do software XOR on such
> a system.
>
> It is indeed preferable to have a numerator that fits in a U32, and so
> 1000 would be equally suitable in that regard, but I think I will
> stick with 800 if you don't mind.

OK, fair enough.

-Doug
