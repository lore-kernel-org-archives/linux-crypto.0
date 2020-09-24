Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AADFC4346E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 08:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC132376F
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 08:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600936325;
	bh=zekxZiEgzsbQy2evisDRCHtjovyjkGze2I72XWL5gyw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OIkSQ8C3laGrn4PPTimhFyhqLpe38voXw17Ywy8+SyU/f8gT1bRXII3gCE4cAC1Z5
	 E9Ys7+FQudF7gDv+kwkg/rRX2H4Ciz91ah4smcbpfSJGs/u2dvGy1ptVD6tuCw2yoN
	 JOJ2PIwefRarPbVQhqv69gU0nJ076hzW4QyiJcQE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgIXIcF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 04:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgIXIcD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 04:32:03 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1167C2396E
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 08:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600936322;
        bh=zekxZiEgzsbQy2evisDRCHtjovyjkGze2I72XWL5gyw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WVGUo4KnUCSkHcXLAz5UhIV7X73G7nj/+f+KMRYDMGOZIg+V9pWAABTIfy0a9wDPS
         tqEUUekylSWyXBOXa8srW/p2b7AQo/nB739DYIske9yFo9dA/CB97Nnbo0Z4lMa74b
         Lwz04PrdWkCAfNgLPMMH8dga0tHwp2da2yjNyYcw=
Received: by mail-ot1-f54.google.com with SMTP id y5so2407445otg.5
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 01:32:02 -0700 (PDT)
X-Gm-Message-State: AOAM530dQc7yzJPLvl6mOBL25ynMiOO44U+GQhHU3UZIjhGdw/c8xBmj
        t+DQU4t96Pjn5lbmpedDJ34aUOajV87MfgMlWhE=
X-Google-Smtp-Source: ABdhPJy67uw8mqrxfZL/m5wYsGes9nmTlqQHEKXkkzoCVcuh7C32ckV7DmJdcDwFGmFXbdlE8Cf0R/EVMA8NUw59MmU=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr2343952otk.108.1600936321214;
 Thu, 24 Sep 2020 01:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-3-ardb@kernel.org>
 <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
In-Reply-To: <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 24 Sep 2020 10:31:49 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com>
Message-ID: <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: xor - use ktime for template benchmarking
To:     Doug Anderson <dianders@chromium.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Sep 2020 at 02:36, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Wed, Sep 23, 2020 at 11:22 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Currently, we use the jiffies counter as a time source, by staring at
> > it until a HZ period elapses, and then staring at it again and perform
> > as many XOR operations as we can at the same time until another HZ
> > period elapses, so that we can calculate the throughput. This takes
> > longer than necessary, and depends on HZ, which is undesirable, since
> > HZ is system dependent.
> >
> > Let's use the ktime interface instead, and use it to time a fixed
> > number of XOR operations, which can be done much faster, and makes
> > the time spent depend on the performance level of the system itself,
> > which is much more reasonable.
> >
> > On ThunderX2, I get the following results:
> >
> > Before:
> >
> >   [72625.956765] xor: measuring software checksum speed
> >   [72625.993104]    8regs     : 10169.000 MB/sec
> >   [72626.033099]    32regs    : 12050.000 MB/sec
> >   [72626.073095]    arm64_neon: 11100.000 MB/sec
> >   [72626.073097] xor: using function: 32regs (12050.000 MB/sec)
> >
> > After:
> >
> >   [ 2503.189696] xor: measuring software checksum speed
> >   [ 2503.189896]    8regs           : 10556 MB/sec
> >   [ 2503.190061]    32regs          : 12538 MB/sec
> >   [ 2503.190250]    arm64_neon      : 11470 MB/sec
> >   [ 2503.190252] xor: using function: 32regs (12538 MB/sec)
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  crypto/xor.c | 36 ++++++++------------
> >  1 file changed, 15 insertions(+), 21 deletions(-)
> >
> > diff --git a/crypto/xor.c b/crypto/xor.c
> > index b42c38343733..23f98b451b69 100644
> > --- a/crypto/xor.c
> > +++ b/crypto/xor.c
> > @@ -76,49 +76,43 @@ static int __init register_xor_blocks(void)
> >  }
> >  #endif
> >
> > -#define BENCH_SIZE (PAGE_SIZE)
> > +#define BENCH_SIZE     4096
>
> I'm curious why the change away from PAGE_SIZE to using 4096.
> Everything should work OK w/ using PAGE_SIZE, right?
>

Yes, but then the test will take 16x more time on a 64k page size
system for no reason whatsoever.

>
> > +#define REPS           100
>
> Is this sufficient?  I'm not sure what the lower bound on what's
> expected of ktime.  If I'm doing the math right, on your system
> running 100 loops took 38802 ns in one case, since:
>
> (4096 * 1000 * 100) / 10556 = 38802
>
> If you happen to have your timer backed by a 32 kHz clock, one tick of
> ktime could be as much as 31250 ns, right?  Maybe on systems backed
> with a 32kHz clock they'll take longer, but it still seems moderately
> iffy?  I dunno, maybe I'm just being paranoid.
>

No, that is a good point - I didn't really consider that ktime could
be that coarse.

OTOH, we don't really need the full 5 digits of precision either, as
long as we don't misidentify the fastest algorithm.

So I think it should be sufficient to bump this to 800. If my
calculations are correct, this would limit any potential
misidentification of algorithms performing below 10 GB/s to ones that
only deviate in performance up to 10%.

800 * 1000 * 4096 / (10 * 31250) = 10485
800 * 1000 * 4096 / (11 * 31250) = 9532

(10485/9532) / 10485 = 10%

>
> >  static void __init
> >  do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
> >  {
> >         int speed;
> > -       unsigned long now, j;
> > -       int i, count, max;
> > +       int i, j, count;
> > +       ktime_t min, start, diff;
> >
> >         tmpl->next = template_list;
> >         template_list = tmpl;
> >
> >         preempt_disable();
> >
> > -       /*
> > -        * Count the number of XORs done during a whole jiffy, and use
> > -        * this to calculate the speed of checksumming.  We use a 2-page
> > -        * allocation to have guaranteed color L1-cache layout.
> > -        */
> > -       max = 0;
> > +       min = (ktime_t)S64_MAX;
> >         for (i = 0; i < 5; i++) {
> > -               j = jiffies;
> > -               count = 0;
> > -               while ((now = jiffies) == j)
> > -                       cpu_relax();
> > -               while (time_before(jiffies, now + 1)) {
> > +               start = ktime_get();
> > +               for (j = 0; j < REPS; j++) {
> >                         mb(); /* prevent loop optimzation */
> >                         tmpl->do_2(BENCH_SIZE, b1, b2);
> >                         mb();
> >                         count++;
> >                         mb();
> >                 }
> > -               if (count > max)
> > -                       max = count;
> > +               diff = ktime_sub(ktime_get(), start);
> > +               if (diff < min)
> > +                       min = diff;
> >         }
> >
> >         preempt_enable();
> >
> > -       speed = max * (HZ * BENCH_SIZE / 1024);
> > +       // bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
>
> Comment is super helpful, thanks!  ...but are folks really OK with
> "//" comments these days?
>

Linus said he is fine with it, and even prefers it for single line
comments, so I don't think it's a problem

>
> > +       speed = (1000 * REPS * BENCH_SIZE) / (u32)min;
>
> nit: Just for prettiness, maybe call ktime_to_ns(min)?
>
> optional nit: I always think of u32 as something for accessing
> hardware.  Maybe "unsigned int"?
>

Ack

>
> >         tmpl->speed = speed;
> >
> > -       printk(KERN_INFO "   %-10s: %5d.%03d MB/sec\n", tmpl->name,
> > -              speed / 1000, speed % 1000);
> > +       printk(KERN_INFO "   %-16s: %5d MB/sec\n", tmpl->name, speed);
>
> Since you're touching, switch to pr_info()?
>

Ack (x2)


>
> >  }
> >
> >  static int __init
> > @@ -158,8 +152,8 @@ calibrate_xor_blocks(void)
> >                 if (f->speed > fastest->speed)
> >                         fastest = f;
> >
> > -       printk(KERN_INFO "xor: using function: %s (%d.%03d MB/sec)\n",
> > -              fastest->name, fastest->speed / 1000, fastest->speed % 1000);
> > +       printk(KERN_INFO "xor: using function: %s (%d MB/sec)\n",
> > +              fastest->name, fastest->speed);
>
> Since you're touching, switch to pr_info()?
>
>
> -Doug
