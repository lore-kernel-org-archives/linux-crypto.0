Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C127BC433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 10:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FFE520C01
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 10:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="diz5DNBB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfG2KpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 06:45:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38530 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbfG2KpT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 06:45:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so61279994wrr.5
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 03:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1uRSJMzSbMgXzpr1bE0yMIan7guz+Q50RZKdFg1L8ZI=;
        b=diz5DNBBaMllCaVOjSe4ntiMRXjGrExzxzEV3+6ALGTP/jo/n40TIvljHrUEHDdvKL
         nTX2oAuyB5VwH42cCVv422oaQws43evrSKM9YuAB02ypPww1oQT3Fb48KB9+NlxBZFdI
         cd8OtZdiyMbMEE7nZ9jtdYvV43ZAa0rUWymXd6Q1YrOYs5LRnWTNSCjQDOP0xxLmNwkf
         TXDot5acyae9LCCtq/YpFP0UVfclbkQw6+KdsJR7hBE1C+r0LMaFnETD77odiNu2t0ar
         OD84NIlWi3jTeczZgwUUw+luNrVj84Q9dsuMJgNtz2BoK2bzZoujK0na9fK6mn79JQML
         CBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1uRSJMzSbMgXzpr1bE0yMIan7guz+Q50RZKdFg1L8ZI=;
        b=ZBeqf47tHvUCgLSwa513VZWeKhGSJIGUkXvOt7avOdKbarIr/A1xj9ot0wo8MktorV
         Kd1QTsZCphnFnkVlzN3cmAln9siGlVH2E7pf22lsMLrNNFXxq7TDzFj7qQiTGu7K8ArA
         Pf2AZtYFnYVQ8EvK/j7oLtSQuyzHI1tMp/moUe/e0Lt3rDEQy5XTWXOmzZNrW33VrEkw
         K+H7j4mTtFwWcv0WPrMb2/wqecdjUngF1Ru7ScGrIjdO7Mx0D/3u5rLfZf0Ac4XNZ4Dv
         8oy1lDoMEpoyzmc5XXxT74fdqjNvmEDOJ8/Pqt8bcjr9303NIfv+csfaORpqpH4hZk7j
         Gvjw==
X-Gm-Message-State: APjAAAUwilxnXHwbJ32oDCk/JepJxXLzfvmNOUhPFClN6OcUdEtxnxIs
        WB2kQdo2r8COVc16H4C3cfxPnNAwZBa+7CStDRFyEPzPjG4=
X-Google-Smtp-Source: APXvYqzxC8+U80dOcY3+0v4Gp3m8PnzizbVMbtGH045kogWUKhP/nD0Ks5xosy/Uu4eSBfLEYhftB+1kajaEKc1bUMg=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr10084364wrw.169.1564397117096;
 Mon, 29 Jul 2019 03:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190729095521.1916-1-ard.biesheuvel@linaro.org> <CAK8P3a1=6nW0d+LOp__tMepYwGCc5f+e6qb1D3wUtp6_79Yd-A@mail.gmail.com>
In-Reply-To: <CAK8P3a1=6nW0d+LOp__tMepYwGCc5f+e6qb1D3wUtp6_79Yd-A@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 29 Jul 2019 13:45:05 +0300
Message-ID: <CAKv+Gu_8nNd-td5F9u0dgH7x1kF+r8sCL432MvzmxqNZqqW-gA@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: make simd.h a mandatory include/asm header
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 29 Jul 2019 at 13:32, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Jul 29, 2019 at 11:55 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > The generic aegis128 software crypto driver recently gained support
> > for using SIMD intrinsics to increase performance, for which it
> > uncondionally #include's the <asm/simd.h> header. Unfortunately,
> > this header does not exist on many architectures, resulting in
> > build failures.
> >
> > Since asm-generic already has a version of simd.h, let's make it
> > a mandatory header so that it gets instantiated on all architectures
> > that don't provide their own version.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Looks good to me, if you want this to go through the crypto tree,
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>

Thanks.

> I noticed that this is the first such entry here, and went looking for
> other candidates:
>
> $ git grep -h generic-y arch/*/include/asm/Kbuild  | sort | uniq -c  |
> sort -nr | head -n 30
>      24 generic-y += mm-arch-hooks.h
>      23 generic-y += trace_clock.h
>      22 generic-y += preempt.h
>      21 generic-y += mcs_spinlock.h
>      21 generic-y += irq_work.h
>      21 generic-y += irq_regs.h
>      21 generic-y += emergency-restart.h
>      20 generic-y += mmiowb.h
>      19 generic-y += local.h
>      18 generic-y += word-at-a-time.h
>      18 generic-y += kvm_para.h
>      18 generic-y += exec.h
>      18 generic-y += div64.h
>      18 generic-y += compat.h
>      17 generic-y += xor.h
>      17 generic-y += percpu.h
>      17 generic-y += local64.h
>      17 generic-y += device.h
>      16 generic-y += kdebug.h
>      15 generic-y += dma-mapping.h
>      14 generic-y += vga.h
>      14 generic-y += topology.h
>      14 generic-y += kmap_types.h
>      14 generic-y += hw_irq.h
>      13 generic-y += serial.h
>      13 generic-y += kprobes.h
>      13 generic-y += fb.h
>      13 generic-y += extable.h
>      13 generic-y += current.h
>      12 generic-y += sections.h
>
> It looks like there are a number of these that could be handled the
> same way. Should we do that for the asm-generic tree afterwards?
>

I guess it depends whether any dependencies on those headers exist in
code that is truly generic. If they are only needed by some common
infrastructure that cannot be enabled for a certain architecture
anyway, I don't think making it a mandatory header is appropriate.

So I think the question is whether the first column and the number of
per-arch instances of that header add up to 25 (disregarding the
exception for arch/um for now)
