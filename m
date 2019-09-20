Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82878C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FAEA206B6
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfITNgz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:36:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44329 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfITNgz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 09:36:55 -0400
Received: by mail-qt1-f196.google.com with SMTP id u40so8620596qth.11;
        Fri, 20 Sep 2019 06:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CvmD4YNxBRUn/0UjBurEbyET+Nr9/JlVxXl8gG9TzCg=;
        b=VKu/r0POY5GoRKZM4pey3qwQ9U7MrUqYDObvUlXIfmpm006b3nz2KHFjWTfp0067AD
         8idVMmNBQYgJIfEJeYHxgkaKVgtQrRThQq9Stxvb08QNV0WFREDgWA/fDOivWLOYZRsI
         3tesfcmGYu2DoQIWToto8AR13jqzpR6MPBDdfl3uiZklX6XUmzusQoiBLYWLaH2sy+im
         1WkHH8M+hSIoiUITjudNf4474/SXJN1VR8yrQ6mhjpC6+H35JQc//h7x4qgZ404RuaKr
         3aGOHUW0a7ZjWaiSAzk2mTSdaTdbxo3gkbLS3f/rDtHNyI6IA3nwoJ8jDp43qI0hMGAh
         1A3A==
X-Gm-Message-State: APjAAAWGCncYMWRDCg+Jspx61qPH1VAoCs2XvIjOD3+1EMV1uTeHS8u0
        Z1rx+14s7kzvl2YyPYTz/DkZLQdwA8DL1Krpu6UOFuku51k=
X-Google-Smtp-Source: APXvYqyQGHB2PqaqICxgJ766QECqxNAyubMx+mviAbBi99RelszSOpH5XZsbwFLC1tCMa2yp9BiKGJ+Iwy37J4ssnUw=
X-Received: by 2002:a0c:e74b:: with SMTP id g11mr12883090qvn.62.1568986613979;
 Fri, 20 Sep 2019 06:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190919140650.1289963-2-arnd@arndb.de> <20190919140917.1290556-1-arnd@arndb.de>
 <f801a4c1-8fa6-8c14-120c-49c24ec84449@huawei.com> <CAK8P3a3jCv--VHu9r4ZTnLXXGaCjdJ6royP5LFk_9RCTTRsRBA@mail.gmail.com>
In-Reply-To: <CAK8P3a3jCv--VHu9r4ZTnLXXGaCjdJ6royP5LFk_9RCTTRsRBA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 20 Sep 2019 15:36:37 +0200
Message-ID: <CAK8P3a1AgZePpZdYXh2w1BHAJZZbAjZjN8MZyVS4bPo4gVVgPg@mail.gmail.com>
Subject: Re: [PATCH 2/2] [v2] crypto: hisilicon - allow compile-testing on x86
To:     John Garry <john.garry@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Mao Wenan <maowenan@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 20, 2019 at 3:26 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Sep 20, 2019 at 10:34 AM John Garry <john.garry@huawei.com> wrote:
>
> > > +     if (!IS_ENABLED(CONFIG_ARM64)) {
> > > +             memcpy_toio(fun_base, src, 16);
> > > +             wmb();
> > > +             return;
> > > +     }
> > > +
> > >       asm volatile("ldp %0, %1, %3\n"
> > >                    "stp %0, %1, %2\n"
> > >                    "dsb sy\n"
> > >
> >
> > As I understand, this operation needs to be done atomically. So - even
> > though your change is just for compile testing - the memcpy_to_io() may
> > not do the same thing on other archs, right?
> >
> > I just wonder if it's right to make that change, or at least warn the
> > imaginary user of possible malfunction for !arm64.
>
> It's probably not necessary here. From what I can tell from the documentation,
> this is only safe on ARMv8.4 or higher anyway, earlier ARMv8.x implementations
> don't guarantee that an stp arrives on the bus in one piece either.
>
> Usually, hardware like this has no hard requirement on an atomic store,
> it just needs the individual bits to arrive in a particular order, and then
> triggers the update on the last bit that gets stored. If that is the case here
> as well, it might actually be better to use two writeq_relaxed() and
> a barrier. This would also solve the endianess issue.

See also https://lkml.org/lkml/2018/1/26/554 for a previous attempt
to introduce 128-bit MMIO accessors, this got rejected since they
are not atomic even on ARMv8.4.

    Arnd
