Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35117C4727D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 15:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFBA523787
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 15:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JEULxNCm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgIXP2f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgIXP2e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 11:28:34 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9087C0613CE
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 08:28:33 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id y194so2366290vsc.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 08:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pxDYAXbBnHH/wXFsDvf70ZvVX4FNDF/hUXKjmJvuChU=;
        b=JEULxNCm6DuLQ7lIR13P+q88O90145DKVvwd/n6U+lbdpkJySz57pwPJKgshh1tPlV
         OOGDXGCqMf3dEFdd4QG1di8F6qcmVNt/8aKnYT1PXxH8r7eTid+GDyM4r58eu/YjG+P5
         QZLLIsj2D/uJGEYcRUxwf94myeq7GSCGdtDmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pxDYAXbBnHH/wXFsDvf70ZvVX4FNDF/hUXKjmJvuChU=;
        b=GCRJrtIRmQR1VRWRziTlABaMtjOIPMG0N3qx1K9VGXVT4m+0GdRYGjeJwZTffUvm2v
         CZJemHafBTbr4zlizb0q5JlMdOx+dLD0Pso6abcKRT2PXCVh4dSXnUl/T1qrbXx+jCA1
         85+6zn7lIilYDDqLudF5k1OSJxO2AvyJWr2vIgTlfgx5hYVXHYOfUOqnPTHCB/TtnHlj
         v/laiQFvBWwH+ShGt1Zy8hbtfnteCl4FwRrBq4egeZZSF96RypJEbb4IFZA7RK2btU4k
         Q72kYgkH0VN+dNLzDAaXEYoSXMjxHzUHf4lpRAATvCYYrHLPA3XMGrdIEtu8dNSG4m6v
         I+og==
X-Gm-Message-State: AOAM530vdTlfDRnwTeCNtAxPG7NxN+JtcYL+ZmdXimZoG2cpdhRVTjKF
        NxYFch9/zlR849PqRdbXGbnEjyxpHOGxaQ==
X-Google-Smtp-Source: ABdhPJyE97sK7bTY+Ed3p6rwy58J+8PY+DLzMO5EZNFGeW3mebiSDVRZ8JEohZ8/AYsgY2LC4n28mQ==
X-Received: by 2002:a67:cb02:: with SMTP id b2mr4795268vsl.46.1600961312908;
        Thu, 24 Sep 2020 08:28:32 -0700 (PDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id e21sm313480uam.16.2020.09.24.08.28.32
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 08:28:32 -0700 (PDT)
Received: by mail-vs1-f49.google.com with SMTP id p24so2355658vsf.8
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 08:28:32 -0700 (PDT)
X-Received: by 2002:a67:f4c2:: with SMTP id s2mr4476913vsn.4.1600961311696;
 Thu, 24 Sep 2020 08:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-3-ardb@kernel.org>
 <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com> <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com>
In-Reply-To: <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 24 Sep 2020 08:28:19 -0700
X-Gmail-Original-Message-ID: <CAD=FV=V4C1MD1e1zR-ed7j7Ym4-FEjZKfhq4tm7bt2GHP2cR+A@mail.gmail.com>
Message-ID: <CAD=FV=V4C1MD1e1zR-ed7j7Ym4-FEjZKfhq4tm7bt2GHP2cR+A@mail.gmail.com>
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

On Thu, Sep 24, 2020 at 1:32 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 24 Sep 2020 at 02:36, Doug Anderson <dianders@chromium.org> wrote:
> >
> > Hi,
> >
> > On Wed, Sep 23, 2020 at 11:22 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > Currently, we use the jiffies counter as a time source, by staring at
> > > it until a HZ period elapses, and then staring at it again and perform
> > > as many XOR operations as we can at the same time until another HZ
> > > period elapses, so that we can calculate the throughput. This takes
> > > longer than necessary, and depends on HZ, which is undesirable, since
> > > HZ is system dependent.
> > >
> > > Let's use the ktime interface instead, and use it to time a fixed
> > > number of XOR operations, which can be done much faster, and makes
> > > the time spent depend on the performance level of the system itself,
> > > which is much more reasonable.
> > >
> > > On ThunderX2, I get the following results:
> > >
> > > Before:
> > >
> > >   [72625.956765] xor: measuring software checksum speed
> > >   [72625.993104]    8regs     : 10169.000 MB/sec
> > >   [72626.033099]    32regs    : 12050.000 MB/sec
> > >   [72626.073095]    arm64_neon: 11100.000 MB/sec
> > >   [72626.073097] xor: using function: 32regs (12050.000 MB/sec)
> > >
> > > After:
> > >
> > >   [ 2503.189696] xor: measuring software checksum speed
> > >   [ 2503.189896]    8regs           : 10556 MB/sec
> > >   [ 2503.190061]    32regs          : 12538 MB/sec
> > >   [ 2503.190250]    arm64_neon      : 11470 MB/sec
> > >   [ 2503.190252] xor: using function: 32regs (12538 MB/sec)
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  crypto/xor.c | 36 ++++++++------------
> > >  1 file changed, 15 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/crypto/xor.c b/crypto/xor.c
> > > index b42c38343733..23f98b451b69 100644
> > > --- a/crypto/xor.c
> > > +++ b/crypto/xor.c
> > > @@ -76,49 +76,43 @@ static int __init register_xor_blocks(void)
> > >  }
> > >  #endif
> > >
> > > -#define BENCH_SIZE (PAGE_SIZE)
> > > +#define BENCH_SIZE     4096
> >
> > I'm curious why the change away from PAGE_SIZE to using 4096.
> > Everything should work OK w/ using PAGE_SIZE, right?
> >
>
> Yes, but then the test will take 16x more time on a 64k page size
> system for no reason whatsoever.

Ah.  I wasn't sure if using PAGE_SIZE as trying to help avoid
measurement inaccuracies or make it work more like the real thing
(maybe the code that calls XOR often does it PAGE_SIZE at a time?)  I
definitely haven't played with it, but I could sorta imagine it making
some small differences.  Maybe the "prefetch" versions of the XOR ops
have some overhead but the overhead is mitigated with larger
operations?  Though both 4K and 64K are probably large enough and
probably it wouldn't affect the outcome of which algorithm is best...


> > > +#define REPS           100
> >
> > Is this sufficient?  I'm not sure what the lower bound on what's
> > expected of ktime.  If I'm doing the math right, on your system
> > running 100 loops took 38802 ns in one case, since:
> >
> > (4096 * 1000 * 100) / 10556 = 38802
> >
> > If you happen to have your timer backed by a 32 kHz clock, one tick of
> > ktime could be as much as 31250 ns, right?  Maybe on systems backed
> > with a 32kHz clock they'll take longer, but it still seems moderately
> > iffy?  I dunno, maybe I'm just being paranoid.
> >
>
> No, that is a good point - I didn't really consider that ktime could
> be that coarse.
>
> OTOH, we don't really need the full 5 digits of precision either, as
> long as we don't misidentify the fastest algorithm.
>
> So I think it should be sufficient to bump this to 800. If my
> calculations are correct, this would limit any potential
> misidentification of algorithms performing below 10 GB/s to ones that
> only deviate in performance up to 10%.
>
> 800 * 1000 * 4096 / (10 * 31250) = 10485
> 800 * 1000 * 4096 / (11 * 31250) = 9532
>
> (10485/9532) / 10485 = 10%

Seems OK to me.  Seems unlikely that super fast machine are going to
have a 32 kHz backed k_time and the worst case is that we'll pick a
slightly sub-optimal xor, I guess.  I assume your goal is to keep
things fitting in a 32-bit unsigned integer?  Looks like if your use
1000 it also fits...

-Doug
