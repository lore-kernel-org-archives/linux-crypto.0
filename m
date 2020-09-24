Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1D7C4727E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 00:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4915B2145D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 00:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZsfNczrP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgIXAgz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 20:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgIXAgz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 20:36:55 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F570C0613CE
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2020 17:36:55 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id q13so480818vkd.0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2020 17:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ownl6X4TLG7HJ/BT1cLhaIpcym2r9QAn594yCtxkLGk=;
        b=ZsfNczrPWwXMBO1ejTN0CR1CswZyRhk1gXL4A6k4hkvFBEd7oC1P8FDLr6nHdWjLXA
         c7XXXa9Pgjp8YocyRXExQ8bHztk0Bi031mcLvIbOtFZ12iW7GG6Umf4AyXLgat20OsSO
         hP/WLu4SJRyloa8B/f/5EYzer9AVgBklyhqzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ownl6X4TLG7HJ/BT1cLhaIpcym2r9QAn594yCtxkLGk=;
        b=UZGJgXC3Og3bNQ6RcBzKjfFHlNY+z83nO/Jslnaka3s75+Neue4kPVj8Xj/zAtFTkg
         nXVzNTbfgfUC1iVR+ImUiBYq55Fv9YHqvCor01YLXVMdbGYeB8ZX4MzL3VhaMl8eT1Cz
         R2KnM/e+DlUnZWLkmOa40Rbzzw0PxRyL1pBYl767uH8FkeJ3aRd2bjKSMZ1/lRp+Tzcu
         QQ+zoe1dn78pkb1Wh7LT6I18vY4ohxjEZ4iw1MoMqAGLeu6eoah0luHd5LCG8DByUKyY
         Y1dy3+Wce/NMmPMD/jj7lfx2HiA5fHoM4A61O3H1X5gw4ecohnUCDOjDRO2/tj0MoMOP
         cyxA==
X-Gm-Message-State: AOAM533wLu6lx7ouSIZCjwSqr/vXvlUc5fScV448U1lV/YR8q0R2V0eu
        sXG1cjS2R2PxKK74yME1V3WRe2LfhXsXGA==
X-Google-Smtp-Source: ABdhPJz6P3vb/1x9qfPmv4XC6TJ+9DYmwZXkYjSq7LFTsSGb92mDuFJTKc0L675HNGC3Ax7IdvbfJQ==
X-Received: by 2002:a1f:5f05:: with SMTP id t5mr2351409vkb.8.1600907813944;
        Wed, 23 Sep 2020 17:36:53 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id y81sm239522vkd.6.2020.09.23.17.36.53
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:36:53 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id o64so469417uao.1
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2020 17:36:53 -0700 (PDT)
X-Received: by 2002:ab0:6984:: with SMTP id t4mr1655808uaq.0.1600907812637;
 Wed, 23 Sep 2020 17:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-3-ardb@kernel.org>
In-Reply-To: <20200923182230.22715-3-ardb@kernel.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 23 Sep 2020 17:36:40 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
Message-ID: <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: xor - use ktime for template benchmarking
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Wed, Sep 23, 2020 at 11:22 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Currently, we use the jiffies counter as a time source, by staring at
> it until a HZ period elapses, and then staring at it again and perform
> as many XOR operations as we can at the same time until another HZ
> period elapses, so that we can calculate the throughput. This takes
> longer than necessary, and depends on HZ, which is undesirable, since
> HZ is system dependent.
>
> Let's use the ktime interface instead, and use it to time a fixed
> number of XOR operations, which can be done much faster, and makes
> the time spent depend on the performance level of the system itself,
> which is much more reasonable.
>
> On ThunderX2, I get the following results:
>
> Before:
>
>   [72625.956765] xor: measuring software checksum speed
>   [72625.993104]    8regs     : 10169.000 MB/sec
>   [72626.033099]    32regs    : 12050.000 MB/sec
>   [72626.073095]    arm64_neon: 11100.000 MB/sec
>   [72626.073097] xor: using function: 32regs (12050.000 MB/sec)
>
> After:
>
>   [ 2503.189696] xor: measuring software checksum speed
>   [ 2503.189896]    8regs           : 10556 MB/sec
>   [ 2503.190061]    32regs          : 12538 MB/sec
>   [ 2503.190250]    arm64_neon      : 11470 MB/sec
>   [ 2503.190252] xor: using function: 32regs (12538 MB/sec)
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/xor.c | 36 ++++++++------------
>  1 file changed, 15 insertions(+), 21 deletions(-)
>
> diff --git a/crypto/xor.c b/crypto/xor.c
> index b42c38343733..23f98b451b69 100644
> --- a/crypto/xor.c
> +++ b/crypto/xor.c
> @@ -76,49 +76,43 @@ static int __init register_xor_blocks(void)
>  }
>  #endif
>
> -#define BENCH_SIZE (PAGE_SIZE)
> +#define BENCH_SIZE     4096

I'm curious why the change away from PAGE_SIZE to using 4096.
Everything should work OK w/ using PAGE_SIZE, right?


> +#define REPS           100

Is this sufficient?  I'm not sure what the lower bound on what's
expected of ktime.  If I'm doing the math right, on your system
running 100 loops took 38802 ns in one case, since:

(4096 * 1000 * 100) / 10556 = 38802

If you happen to have your timer backed by a 32 kHz clock, one tick of
ktime could be as much as 31250 ns, right?  Maybe on systems backed
with a 32kHz clock they'll take longer, but it still seems moderately
iffy?  I dunno, maybe I'm just being paranoid.


>  static void __init
>  do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
>  {
>         int speed;
> -       unsigned long now, j;
> -       int i, count, max;
> +       int i, j, count;
> +       ktime_t min, start, diff;
>
>         tmpl->next = template_list;
>         template_list = tmpl;
>
>         preempt_disable();
>
> -       /*
> -        * Count the number of XORs done during a whole jiffy, and use
> -        * this to calculate the speed of checksumming.  We use a 2-page
> -        * allocation to have guaranteed color L1-cache layout.
> -        */
> -       max = 0;
> +       min = (ktime_t)S64_MAX;
>         for (i = 0; i < 5; i++) {
> -               j = jiffies;
> -               count = 0;
> -               while ((now = jiffies) == j)
> -                       cpu_relax();
> -               while (time_before(jiffies, now + 1)) {
> +               start = ktime_get();
> +               for (j = 0; j < REPS; j++) {
>                         mb(); /* prevent loop optimzation */
>                         tmpl->do_2(BENCH_SIZE, b1, b2);
>                         mb();
>                         count++;
>                         mb();
>                 }
> -               if (count > max)
> -                       max = count;
> +               diff = ktime_sub(ktime_get(), start);
> +               if (diff < min)
> +                       min = diff;
>         }
>
>         preempt_enable();
>
> -       speed = max * (HZ * BENCH_SIZE / 1024);
> +       // bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]

Comment is super helpful, thanks!  ...but are folks really OK with
"//" comments these days?


> +       speed = (1000 * REPS * BENCH_SIZE) / (u32)min;

nit: Just for prettiness, maybe call ktime_to_ns(min)?

optional nit: I always think of u32 as something for accessing
hardware.  Maybe "unsigned int"?


>         tmpl->speed = speed;
>
> -       printk(KERN_INFO "   %-10s: %5d.%03d MB/sec\n", tmpl->name,
> -              speed / 1000, speed % 1000);
> +       printk(KERN_INFO "   %-16s: %5d MB/sec\n", tmpl->name, speed);

Since you're touching, switch to pr_info()?


>  }
>
>  static int __init
> @@ -158,8 +152,8 @@ calibrate_xor_blocks(void)
>                 if (f->speed > fastest->speed)
>                         fastest = f;
>
> -       printk(KERN_INFO "xor: using function: %s (%d.%03d MB/sec)\n",
> -              fastest->name, fastest->speed / 1000, fastest->speed % 1000);
> +       printk(KERN_INFO "xor: using function: %s (%d MB/sec)\n",
> +              fastest->name, fastest->speed);

Since you're touching, switch to pr_info()?


-Doug
