Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98333C61DB3
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Jan 2023 16:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjAMQIt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Jan 2023 11:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjAMQIH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2023 11:08:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5486F840A7
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 08:01:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC09D6223B
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 16:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C28BC433D2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673625673;
        bh=Fjr2fqUyBjw35OWGyCUamLeFmb3xYQmYVa2js6xoEOo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l5lfWaGrCumzRnoyGYXhLHtmkTOm7WGUUey0wYbUhjuwx/Qmt0Scfb7VDE5+vV8p5
         yUhiG8mNJnZegSpznTmF4HvqGbnm7m5dP37Fh6jhJsH1kE8XRtoyINoPXtVGEonit7
         B6LwRvAhxEy+JZIHf3v7+E70AU9ZU6imnSVW1QEarYvXabbyHERgAJZQd9UddRUjtk
         F/lgw1CHJrYHweQYce+GSUdjjPKzey/6YywXk7dGniPByelOYf5iMa34hagQMbivFF
         mc5GJFku0hqjWnCj9iHKr+oeaxFh5upQ7q+JTJ3JzIjdqlOKQrxWjDb/ZxAHK+yTPb
         QfF2OtTrXm7Sg==
Received: by mail-lj1-f182.google.com with SMTP id y19so1589988ljq.7
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 08:01:13 -0800 (PST)
X-Gm-Message-State: AFqh2kpIgixNomW822NPMnnYZor4SXf3jU/ynJr0YcVbITnYdNpFivyV
        vqwcWMoxZ/xkIagO3YVZ1D27bDyyzlkiP7tAd9E=
X-Google-Smtp-Source: AMrXdXvfcPHyA6+Cc0dbtMkrmTxfdZlqGx7EMZ34+LlUKLjCu7VpU2zTtPODFjAD9Ia3um0QoiPN+q5oFtR19VlrtfA=
X-Received: by 2002:a05:651c:1987:b0:281:acef:7806 with SMTP id
 bx7-20020a05651c198700b00281acef7806mr2267368ljb.516.1673625671346; Fri, 13
 Jan 2023 08:01:11 -0800 (PST)
MIME-Version: 1.0
References: <20221214171957.2833419-1-ardb@kernel.org>
In-Reply-To: <20221214171957.2833419-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 13 Jan 2023 17:00:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG_btjHUVpN9m5NoBdFv=3JWt-piPx_u40KTv70CC-sRQ@mail.gmail.com>
Message-ID: <CAMj1kXG_btjHUVpN9m5NoBdFv=3JWt-piPx_u40KTv70CC-sRQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: Accelerated GCM for IPSec on ARM/arm64
To:     linux-crypto@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 14 Dec 2022 at 18:20, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> This is a v2 as patch #1 was sent out in isolation a couple of days ago.
>
> As it turns out, we can get ~10% speedup for RFC4106 on arm64
> (Cortex-A53) by giving it the same treatment as ARM, i.e., avoid the
> generic template and implement RFC4106 encapsulation directly in the
> driver
>
> Patch #3 adds larger key sizes to the tcrypt benchmark for RFC4106
>
> Patch #4 fixes some prose on AEAD that turned out to be inaccurate.
>
> Changes since v1:
> - minor tweaks to the asm code in patch #1, one of which to fix a Clang
>   build error
>
> Note: patch #1 depends on the softirq context patches for kernel mode
> NEON I sent out last week. More specifically, this implements a sync
> AEAD that does not implement a !simd fallback, as AEADs are not callable
> in hard IRQ context anyway.
>

These prerequisite changes have now been queued up in the ARM tree.

Note that these are runtime prerequisites only so I think this series
can be safely merged as well, as I don't think anyone builds cryptodev
for 32-bit ARM and tests it on 64-bit hardware (which is the only
hardware that implements the AES instructions that patch #1 relies on)


> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>
> Ard Biesheuvel (4):
>   crypto: arm/ghash - implement fused AES/GHASH version of AES-GCM
>   crypto: arm64/gcm - add RFC4106 support
>   crypto: tcrypt - include larger key sizes in RFC4106 benchmark
>   crypto: aead - fix inaccurate documentation
>
>  arch/arm/crypto/Kconfig           |   2 +
>  arch/arm/crypto/ghash-ce-core.S   | 382 +++++++++++++++++-
>  arch/arm/crypto/ghash-ce-glue.c   | 424 +++++++++++++++++++-
>  arch/arm64/crypto/ghash-ce-glue.c | 145 +++++--
>  crypto/tcrypt.c                   |   8 +-
>  crypto/tcrypt.h                   |   2 +-
>  include/crypto/aead.h             |  20 +-
>  7 files changed, 913 insertions(+), 70 deletions(-)
>
> --
> 2.35.1
>
