Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EB1C4727D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 18:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AA0923741
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 18:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aT/zRmCF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgIXSWv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 14:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgIXSWv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 14:22:51 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E357C0613CE
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 11:22:51 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id p24so2685902vsf.8
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 11:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cnc4UKXmeC6M4cFM4kTTHFaNuZ4S5bDSYXAs4oBvTto=;
        b=aT/zRmCFygfeFgrdRsHme0j/lg5bkyBB/TSZ01P4CZNXDj8XMAEh+x3wmZE4FY66Ha
         OCE6+tVVoIpKd+RNEkLzD3FaFTsbvITCr3GnY+7zdBEmB0X96NwjB+TTRmhk7dUzFClq
         iweuTlRmCavmRfZcVlFv3B5uYdVpP5yVpc/ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cnc4UKXmeC6M4cFM4kTTHFaNuZ4S5bDSYXAs4oBvTto=;
        b=RqwPSHK5E2moxe4ZtjlfWhvHwZzBWXKvC0BmUaqVZP2feApFRxsNbY8WW35evgau+X
         eFK/l84wSFqgS2f1ePiY+OrAddrZAwWN+7i/vBbJjBmbln6Xrbr36kTExsS6G60vLUSO
         0Bmqtsjt3IvxFQzsABWPhIDHpHnCG7OQrQLtH7yMewDoDb/b34mxTZm8RY1AEB7RkTqy
         EVnRANS2U2lWFXcXpx4oH8YuGR0aIGvapS13v+N7/o/ZzO5VhioKlJB5Jx7SVSK8nWlj
         RSAHcraleVyIjxCQc6km3s0rk+Db7Y/4IqmTPBB6NfaKZbBLmLayC7xA7zbK3k0qNe1q
         IAEQ==
X-Gm-Message-State: AOAM531dH1yGoWeqifN45B85vvoAUQy7a1hnXgAJTyBXKkf0K1HK5lyr
        Btirn2Qk6yJA74M1+a+FOMDmd+NSqV/lSA==
X-Google-Smtp-Source: ABdhPJyJeZy4/uqu05Q06BTDBty8mNQBBo0pnXL3D+E7/arGExGSF4MKnTxqfNlW55TKZzIQwGFNQQ==
X-Received: by 2002:a67:e94f:: with SMTP id p15mr673659vso.30.1600971770374;
        Thu, 24 Sep 2020 11:22:50 -0700 (PDT)
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com. [209.85.221.179])
        by smtp.gmail.com with ESMTPSA id g197sm41335vkf.54.2020.09.24.11.22.49
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 11:22:49 -0700 (PDT)
Received: by mail-vk1-f179.google.com with SMTP id e5so26026vkm.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2020 11:22:49 -0700 (PDT)
X-Received: by 2002:ac5:c297:: with SMTP id h23mr473316vkk.21.1600971768821;
 Thu, 24 Sep 2020 11:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-3-ardb@kernel.org>
 <CAD=FV=XR6FRnwDbCix9cqB+28Jd_tHKqV8rEtkASy=FPoSs6-w@mail.gmail.com>
 <CAMj1kXFMYR5_4v3_dzEdvESzh65+ni5-8VUt0h7gC3D0mMhdaw@mail.gmail.com>
 <CAD=FV=V4C1MD1e1zR-ed7j7Ym4-FEjZKfhq4tm7bt2GHP2cR+A@mail.gmail.com> <CAMj1kXEYhRdtf-zcs3PQY4ooqQSO5D_15_CpTOb+UUQQcsZ8YQ@mail.gmail.com>
In-Reply-To: <CAMj1kXEYhRdtf-zcs3PQY4ooqQSO5D_15_CpTOb+UUQQcsZ8YQ@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 24 Sep 2020 11:22:37 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Vx+q=P+FrOX9m53uC365KEGZeffsOz9sqL1NP0Y_y+TQ@mail.gmail.com>
Message-ID: <CAD=FV=Vx+q=P+FrOX9m53uC365KEGZeffsOz9sqL1NP0Y_y+TQ@mail.gmail.com>
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

On Thu, Sep 24, 2020 at 8:36 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 24 Sep 2020 at 17:28, Doug Anderson <dianders@chromium.org> wrote:
> >
> > On Thu, Sep 24, 2020 at 1:32 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> ...
> > > > > +#define REPS           100
> > > >
> > > > Is this sufficient?  I'm not sure what the lower bound on what's
> > > > expected of ktime.  If I'm doing the math right, on your system
> > > > running 100 loops took 38802 ns in one case, since:
> > > >
> > > > (4096 * 1000 * 100) / 10556 = 38802
> > > >
> > > > If you happen to have your timer backed by a 32 kHz clock, one tick of
> > > > ktime could be as much as 31250 ns, right?  Maybe on systems backed
> > > > with a 32kHz clock they'll take longer, but it still seems moderately
> > > > iffy?  I dunno, maybe I'm just being paranoid.
> > > >
> > >
> > > No, that is a good point - I didn't really consider that ktime could
> > > be that coarse.
> > >
> > > OTOH, we don't really need the full 5 digits of precision either, as
> > > long as we don't misidentify the fastest algorithm.
> > >
> > > So I think it should be sufficient to bump this to 800. If my
> > > calculations are correct, this would limit any potential
> > > misidentification of algorithms performing below 10 GB/s to ones that
> > > only deviate in performance up to 10%.
> > >
> > > 800 * 1000 * 4096 / (10 * 31250) = 10485
> > > 800 * 1000 * 4096 / (11 * 31250) = 9532
> > >
> > > (10485/9532) / 10485 = 10%
> >
> > Seems OK to me.  Seems unlikely that super fast machine are going to
> > have a 32 kHz backed k_time and the worst case is that we'll pick a
> > slightly sub-optimal xor, I guess.  I assume your goal is to keep
> > things fitting in a 32-bit unsigned integer?  Looks like if your use
> > 1000 it also fits...
> >
>
> Yes, but the larger we make this number, the more time the test will
> take on such slow machines. Doing 1000 iterations of 4k on a low-end
> machine that only manages 500 MB/s (?) takes a couple of milliseconds,
> which is more than it does today when HZ=1000 I think.
>
> Not that 800 vs 1000 makes a great deal of difference in that regard,
> just illustrating that there is an upper bound as well.

Would it make sense to use some type of hybrid approach?  I know
getting ktime itself has some overhead so you don't want to do it in a
tight loop, but maybe calling it every once in a while would be
acceptable and if it's been more than 500 us then stop early?

-Doug
