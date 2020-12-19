Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E833DC4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 17:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA3923A82
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 17:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgLSREi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Dec 2020 12:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgLSREi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Dec 2020 12:04:38 -0500
X-Gm-Message-State: AOAM530nRVO4byzdjQIkxha02M8QUroLBuC/2063pep9Lsd+ocRVLfxn
        AZDqV1RX1IuCieU1cugWTnRzFHaaBNTKoZSqnEU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608397437;
        bh=jMd64Y98HYg9Pc5iPttx4Zs2a10gF/R04G0BXFnA1Eg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jDG87XETapDsMPsb8vl9LyXhAqeJMLaBAdf57bfHLZ+K2FxUg4aBE0D3m9yIUXFNE
         a8tn57xC2n+om98be5nzbyP+EreK21eDSxDzu2u8py+kF7pclknsxDhZhEKuWc94ry
         VFZZSj/GxK08AueZOKkvCN7Tjp/oywRrVxijfNZwAsPtS7cFbot7GBfKM9IqrTJeHu
         fD8m1bsNpU7e5+d78EWwhu0hjofFj4vmK4euDP1P3479zYt33kSSmb/LXEtiyZ/K/h
         XzWaRTItCJNiTh5QTBaQap6ecWQ0CyY8vCB1uK0CJY3xAWULMOfVBd5n4HN0dmHqN1
         e+i0i/ZghekJQ==
X-Google-Smtp-Source: ABdhPJy0ae32ogaCBJeS+aI32wYWUGyWLISLB3QkwQrTmS55zGVNdnrFzh0EghXebM6rtY3WnSuOwbssfMbahmmgvgA=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr6336934oig.33.1608397436892;
 Sat, 19 Dec 2020 09:03:56 -0800 (PST)
MIME-Version: 1.0
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com> <1608325864-4033-4-git-send-email-megha.dey@intel.com>
In-Reply-To: <1608325864-4033-4-git-send-email-megha.dey@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 19 Dec 2020 18:03:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
Message-ID: <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
Subject: Re: [RFC V1 3/7] crypto: ghash - Optimized GHASH computations
To:     Megha Dey <megha.dey@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 18 Dec 2020 at 22:07, Megha Dey <megha.dey@intel.com> wrote:
>
> From: Kyung Min Park <kyung.min.park@intel.com>
>
> Optimize GHASH computations with the 512 bit wide VPCLMULQDQ instructions.
> The new instruction allows to work on 4 x 16 byte blocks at the time.
> For best parallelism and deeper out of order execution, the main loop of
> the code works on 16 x 16 byte blocks at the time and performs reduction
> every 48 x 16 byte blocks. Such approach needs 48 precomputed GHASH subkeys
> and the precompute operation has been optimized as well to leverage 512 bit
> registers, parallel carry less multiply and reduction.
>
> VPCLMULQDQ instruction is used to accelerate the most time-consuming
> part of GHASH, carry-less multiplication. VPCLMULQDQ instruction
> with AVX-512F adds EVEX encoded 512 bit version of PCLMULQDQ instruction.
>
> The glue code in ghash_clmulni_intel module overrides existing PCLMULQDQ
> version with the VPCLMULQDQ version when the following criteria are met:
> At compile time:
> 1. CONFIG_CRYPTO_AVX512 is enabled
> 2. toolchain(assembler) supports VPCLMULQDQ instructions
> At runtime:
> 1. VPCLMULQDQ and AVX512VL features are supported on a platform (currently
>    only Icelake)
> 2. If compiled as built-in module, ghash_clmulni_intel.use_avx512 is set at
>    boot time or /sys/module/ghash_clmulni_intel/parameters/use_avx512 is set
>    to 1 after boot.
>    If compiled as loadable module, use_avx512 module parameter must be set:
>    modprobe ghash_clmulni_intel use_avx512=1
>
> With new implementation, tcrypt ghash speed test shows about 4x to 10x
> speedup improvement for GHASH calculation compared to the original
> implementation with PCLMULQDQ when the bytes per update size is 256 Bytes
> or above. Detailed results for a variety of block sizes and update
> sizes are in the table below. The test was performed on Icelake based
> platform with constant frequency set for CPU.
>
> The average performance improvement of the AVX512 version over the current
> implementation is as follows:
> For bytes per update >= 1KB, we see the average improvement of 882%(~8.8x).
> For bytes per update < 1KB, we see the average improvement of 370%(~3.7x).
>
> A typical run of tcrypt with GHASH calculation with PCLMULQDQ instruction
> and VPCLMULQDQ instruction shows the following results.
>
> ---------------------------------------------------------------------------
> |            |            |         cycles/operation         |            |
> |            |            |       (the lower the better)     |            |
> |    byte    |   bytes    |----------------------------------| percentage |
> |   blocks   | per update |   GHASH test   |   GHASH test    | loss/gain  |
> |            |            | with PCLMULQDQ | with VPCLMULQDQ |            |
> |------------|------------|----------------|-----------------|------------|
> |      16    |     16     |       144      |        233      |   -38.0    |
> |      64    |     16     |       535      |        709      |   -24.5    |
> |      64    |     64     |       210      |        146      |    43.8    |
> |     256    |     16     |      1808      |       1911      |    -5.4    |
> |     256    |     64     |       865      |        581      |    48.9    |
> |     256    |    256     |       682      |        170      |   301.0    |
> |    1024    |     16     |      6746      |       6935      |    -2.7    |
> |    1024    |    256     |      2829      |        714      |   296.0    |
> |    1024    |   1024     |      2543      |        341      |   645.0    |
> |    2048    |     16     |     13219      |      13403      |    -1.3    |
> |    2048    |    256     |      5435      |       1408      |   286.0    |
> |    2048    |   1024     |      5218      |        685      |   661.0    |
> |    2048    |   2048     |      5061      |        565      |   796.0    |
> |    4096    |     16     |     40793      |      27615      |    47.8    |
> |    4096    |    256     |     10662      |       2689      |   297.0    |
> |    4096    |   1024     |     10196      |       1333      |   665.0    |
> |    4096    |   4096     |     10049      |       1011      |   894.0    |
> |    8192    |     16     |     51672      |      54599      |    -5.3    |
> |    8192    |    256     |     21228      |       5284      |   301.0    |
> |    8192    |   1024     |     20306      |       2556      |   694.0    |
> |    8192    |   4096     |     20076      |       2044      |   882.0    |
> |    8192    |   8192     |     20071      |       2017      |   895.0    |
> ---------------------------------------------------------------------------
>
> This work was inspired by the AES GCM mode optimization published
> in Intel Optimized IPSEC Cryptographic library.
> https://github.com/intel/intel-ipsec-mb/lib/avx512/gcm_vaes_avx512.asm
>
> Co-developed-by: Greg Tucker <greg.b.tucker@intel.com>
> Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
> Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> Co-developed-by: Megha Dey <megha.dey@intel.com>
> Signed-off-by: Megha Dey <megha.dey@intel.com>

Hello Megha,

What is the purpose of this separate GHASH module? GHASH is only used
in combination with AES-CTR to produce GCM, and this series already
contains a GCM driver.

Do cores exist that implement PCLMULQDQ but not AES-NI?

If not, I think we should be able to drop this patch (and remove the
existing PCLMULQDQ GHASH driver as well)
