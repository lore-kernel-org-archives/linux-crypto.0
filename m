Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627DFEE49A6
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 14:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbjHUOgq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 10:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbjHUOgp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 10:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CF8E2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 07:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B8561A17
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 14:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7B6C433C8
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692628602;
        bh=rhJXoGtKmdSiSlFzUhoJCM+jVNFK1EdabB2iDQghH3s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EdtVf/g2X7jdUUagVyWv/LU/h0Og+JGuERVLRZ+/jr9Kv+O/1qUpsrvVSSUf4+UOL
         YVHibS4gqVI508dpNI2F2jZSdAb9nQFUvsFcrKdPiHC01nXlq1Rh1WYwi3F02rPSdl
         SsEzV7+OckMH/rFCdqIVMfydv886fEjyM8q4QRbIRcNO1PEaWoncDpfX0HkGMofvf3
         hzVWMsCrZJx8oySpt8Pv/kty66xy/RgGVirUYyh0KdcWnHtNt3h4z2SQQeWIeVv2OP
         dCwPOGczC7trjN0mbjiUu6e6wHQ+1YqAKUGHmfiE0fnvHUlu0fWt1DP6KfYloPf76q
         MBYuwq3AKD6zQ==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-4ff8cf11b90so5203949e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 07:36:42 -0700 (PDT)
X-Gm-Message-State: AOJu0YyfQ1QHnw1F99dInGv5sbwhe8lEjSTPsNjxRyRcS7FYWMNZKe9h
        pczltbGQzhz6Q2WrQDdqtp/epB3VggaCQq6JqOA=
X-Google-Smtp-Source: AGHT+IFsgUbPE9vPoryh1sd/8gYDg8SHEm7MoPC+fsQI99DHlsC/Mo0CDg4R5ybzwlQP5FGVkHe/cPY5+o2j3sb5jlw=
X-Received: by 2002:a05:6512:2303:b0:4f8:6a29:b59b with SMTP id
 o3-20020a056512230300b004f86a29b59bmr5155024lfu.64.1692628600881; Mon, 21 Aug
 2023 07:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230811140749.5202-1-qianweili@huawei.com> <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au> <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au> <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
 <ZOMeKhMOIEe+VKPt@gondor.apana.org.au> <20230821102632.GA19294@willie-the-truck>
 <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
In-Reply-To: <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 21 Aug 2023 16:36:29 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH5YWZ1i0=1MVo0kaxSbQWFF6QyGvLUv_K5mqApASzy5w@mail.gmail.com>
Message-ID: <CAMj1kXH5YWZ1i0=1MVo0kaxSbQWFF6QyGvLUv_K5mqApASzy5w@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
To:     Weili Qian <qianweili@huawei.com>
Cc:     Will Deacon <will@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        shenyang39@huawei.com, liulongfang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Aug 2023 at 14:45, Weili Qian <qianweili@huawei.com> wrote:
>
>
>
> On 2023/8/21 18:26, Will Deacon wrote:
> > On Mon, Aug 21, 2023 at 04:19:54PM +0800, Herbert Xu wrote:
> >> On Sat, Aug 19, 2023 at 09:33:18AM +0200, Ard Biesheuvel wrote:
> >>>
> >>> No, that otx2_write128() routine looks buggy, actually, The ! at the
> >>> end means writeback, and so the register holding addr will be
> >>> modified, which is not reflect in the asm constraints. It also lacks a
> >>> barrier.
> >>
> >> OK.  But at least having a helper called write128 looks a lot
> >> cleaner than just having unexplained assembly in the code.
> >
> > I guess we want something similar to how writeq() is handled on 32-bit
> > architectures (see include/linux/io-64-nonatomic-{hi-lo,lo-hi}.h.
> >
> > It's then CPU-dependent on whether you get atomicity.
> >
> > Will
> > .
> >
>
> Thanks for the review.
>
> Since the HiSilicon accelerator devices are supported only on the ARM64 platform,
> the following 128bit read and write interfaces are added to the driver, is this OK?

No, this does not belong in the driver. As Will is suggesting, we
should define some generic helpers for this, and provide an arm64
implementation if the generic one does not result in the correct
codegen.

>
> #if defined(CONFIG_ARM64)
> static void qm_write128(void __iomem *addr, const void *buffer)
> {
>         unsigned long tmp0 = 0, tmp1 = 0;
>
>         asm volatile("ldp %0, %1, %3\n"
>                      "stp %0, %1, %2\n"
>                      "dmb oshst\n"
>                      : "=&r" (tmp0),
>                      "=&r" (tmp1),
>                      "+Q" (*((char __iomem *)addr))

This constraint describes the first byte of addr, which is sloppy but
probably works fine.

>                      : "Q" (*((char *)buffer))

This constraint describes the first byte of buffer, which might cause
problems because the asm reads the entire buffer not just the first
byte.

>                      : "memory");
> }
>
> static void qm_read128(void *buffer, const void __iomem *addr)
> {
>         unsigned long tmp0 = 0, tmp1 = 0;
>
>         asm volatile("ldp %0, %1, %3\n"
>                      "stp %0, %1, %2\n"
>                      "dmb oshst\n"

Is this the right barrier for a read?

>                      : "=&r" (tmp0),
>                        "=&r" (tmp1),
>                        "+Q" (*((char *)buffer))
>                      : "Q" (*((char __iomem *)addr))
>                      : "memory");
> }
>
> #else
> static void qm_write128(void __iomem *addr, const void *buffer)
> {
>
> }
>
> static void qm_read128(void *buffer, const void __iomem *addr)
> {
>
> }
> #endif
>

Have you tried using __uint128_t accesses instead?

E.g., something like

static void qm_write128(void __iomem *addr, const void *buffer)
{
    volatile __uint128_t *dst = (volatile __uint128_t __force *)addr;
    const __uint128_t *src __aligned(1) = buffer;

    WRITE_ONCE(*dst, *src);
    dma_wmb();
}

should produce the right instruction sequence, and works on all
architectures that have CONFIG_ARCH_SUPPORTS_INT128=y

This needs a big fat comment describing that the MMIO access needs to
be atomic, but we could consider it as a fallback if we decide not to
bother with special MMIO accessors, although I suspect we'll be
needing them more widely at some point anyway.
