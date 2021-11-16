Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9FCC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 03:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1563E63215
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 03:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbhKPDyp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 22:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbhKPDyo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 22:54:44 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3BDC1A2993
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 16:31:10 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 200so16035717pga.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 16:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zUAbk3pYDxq1bSuJItD74NAh/MbYUz0fiMi2jjsqIPc=;
        b=jkN0+anUkVZEafZbns3mnQH3BOzdPE6stTt8SrDHZFGkz5SQGDyxTuScjmOkAtjtG9
         AT2XFauNYqbJ3Hv+WUTHMAUTNsTes+od+8KqsU/GEVyVgjrYYw/xt4G0TAF8HM1LcPVm
         2WJe85H3kQUjZSV8Rb5yVnjCooZk+xWNu9wek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zUAbk3pYDxq1bSuJItD74NAh/MbYUz0fiMi2jjsqIPc=;
        b=RYiqPnD+WTii/r6m8K0xFQR9QjIwv6tTvAsu2Rb6g+R03bY2DoT0ANaNpZgwMW9s9h
         6ISM3nPEcbcOIoQ+duoqq8ufw4kNsda2OeNo4xjW7aZcGn/HT3Bgy/WL7AJRJIgBe/FL
         y+DID31mdUzKwrQ/hum409bc3OJA4mQSD+xUs/zGOIQi/t6XBunrHrKeSt39LQ/oGSed
         N9domuWuGPBYBkhCSE2FJVDiD37JqIEZHRb+EWnWbYJkaLzwRoPK67Zew4rUU4bm7ePM
         yn/DZ2XCemhTW5wBOe5gCYFNNDyZG4UyqDzkXu3+gpvvtQLoHN7I/MbB7h2oMRVkDwQ6
         gTJQ==
X-Gm-Message-State: AOAM530DawJ5yR33Ph01LjKs/SDr5AS8dDSXRUQyDQdtq5EvhquOxbyJ
        tY7GcIZ0SvOCy8zJ7gIwyDFLew==
X-Google-Smtp-Source: ABdhPJxDrEb7NedduOiss/lXzBJfLpYZT+5k0kObH71YXHTZztaI+VVMmjTV988TJQv8GS02GfUMPA==
X-Received: by 2002:a05:6a00:1945:b0:44c:a955:35ea with SMTP id s5-20020a056a00194500b0044ca95535eamr36094903pfk.85.1637022670112;
        Mon, 15 Nov 2021 16:31:10 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h21sm12755848pgk.74.2021.11.15.16.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 16:31:09 -0800 (PST)
Date:   Mon, 15 Nov 2021 16:31:09 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Marco Elver <elver@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Terrell <terrelln@fb.com>,
        Rob Clark <robdclark@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Anton Altaparmakov <anton@tuxera.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Joey Gouly <joey.gouly@arm.com>,
        Stan Skowronek <stan@corellium.com>,
        Hector Martin <marcan@marcan.st>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-ntfs-dev@lists.sourceforge.net,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: Build regressions/improvements in v5.16-rc1
Message-ID: <202111151624.91EDCFF7@keescook>
References: <20211115155105.3797527-1-geert@linux-m68k.org>
 <CAMuHMdUCsyUxaEf1Lz7+jMnur4ECwK+JoXQqmOCkRKqXdb1hTQ@mail.gmail.com>
 <YZKOce4XhAU49+Yn@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZKOce4XhAU49+Yn@elver.google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 15, 2021 at 05:44:33PM +0100, Marco Elver wrote:
> On Mon, Nov 15, 2021 at 05:12PM +0100, Geert Uytterhoeven wrote:
> [...]
> > >   + /kisskb/src/include/linux/fortify-string.h: error: call to '__read_overflow' declared with attribute error: detected read beyond size of object (1st parameter):  => 263:25, 277:17
> > 
> >     in lib/test_kasan.c
> > 
> > s390-all{mod,yes}config
> > arm64-allmodconfig (gcc11)
> 
> Kees, wasn't that what [1] was meant to fix?
> [1] https://lkml.kernel.org/r/20211006181544.1670992-1-keescook@chromium.org

[1] fixed the ones I found when scanning for __write_overflow(). [2]
fixed some others, so it's possible there are yet more to fix?

Taking a look at Linus's tree, though, the "263" and "277" lines don't
line up correctly. I'll go see if I can reproduce this. Is this with
W=1?

-Kees

[2] https://www.ozlabs.org/~akpm/mmotm/broken-out/kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch


-- 
Kees Cook
