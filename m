Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AD3C001DB
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 08:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjHDIbq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 04:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbjHDIbh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 04:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF19101
        for <linux-crypto@vger.kernel.org>; Fri,  4 Aug 2023 01:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1782361F64
        for <linux-crypto@vger.kernel.org>; Fri,  4 Aug 2023 08:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D7AC433C9
        for <linux-crypto@vger.kernel.org>; Fri,  4 Aug 2023 08:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691137895;
        bh=PMg5/i5K6XzQCEgkCjUpkRAzmh6AZZ34kkvt76wThO8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FVn33WJgCOhX/L/aX9CJo9m9KHr7oGPIwOtTaIpJW8jvpEcfdsY5eVpiqB5YO+aDZ
         nvP1uETCAOpaN/LJcmwHO7kNJcK2blZ1vvtuZ3S+zXS9RSdY8seY6FzLLCAaiAefkk
         654XZRJan4tiO8dnOw3unchH4AMv8o9RXHGLbmkG59t0f0/sWtHTreSzpneWDCDRwr
         RoXiY6TZcTQrAz87KJK668zhFFap36DB/I+fkX74Dbdq8aPMEhwnnjWVLVxBUOSyhq
         N6V0xj1J8ocj5QHDtWtydrnH1MDx772cV3RP/CwM5VFWSyobY4wV79Gi4OGPtUs6dH
         IRHR7xbZXvvIQ==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4fe389d6f19so3064605e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 04 Aug 2023 01:31:35 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy1k7rGfnOwYLEBlj/3QHaMJcDBBTdz/FoMkE0xmpU2jhRrk1Tn
        /KPJ0YMkynd5ICPaKXZu2OMA5xk/mLCfj7WfcW0=
X-Google-Smtp-Source: AGHT+IGsLEy22eau6dwanYbYK0CBYu/tLY4uxzo4SIr7505bHyyDhLiP3kxQdWQ+gmjVGSEjmDnEfOJPxSGDDrhY67w=
X-Received: by 2002:a05:6512:1cd:b0:4fb:8f79:631 with SMTP id
 f13-20020a05651201cd00b004fb8f790631mr690035lfp.46.1691137893509; Fri, 04 Aug
 2023 01:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230726172958.1215472-1-ardb@kernel.org> <ZMy1DkYRBc1PxC8e@gondor.apana.org.au>
In-Reply-To: <ZMy1DkYRBc1PxC8e@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 4 Aug 2023 10:31:22 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHCt6DJEZKYVYBXN0QhZ0w2ByCPUK2S2y2T5U06Ztrx9A@mail.gmail.com>
Message-ID: <CAMj1kXHCt6DJEZKYVYBXN0QhZ0w2ByCPUK2S2y2T5U06Ztrx9A@mail.gmail.com>
Subject: Re: [PATCH] crypto: riscv/aes - Implement scalar Zkn version for RV32
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Aug 2023 at 10:21, Herbert Xu <herbert@gondor.apana.org.au> wrote=
:
>
> On Wed, Jul 26, 2023 at 07:29:58PM +0200, Ard Biesheuvel wrote:
> > The generic AES implementation we rely on if no architecture specific
> > one is available relies on lookup tables that are relatively large with
> > respect to the typical L1 D-cache size, which not only affects
> > performance, it may also result in timing variances that correlate with
> > the encryption keys.
> >
> > So we tend to avoid the generic code if we can, usually by using a
> > driver that makes use of special AES instructions which supplant most o=
f
> > the logic of the table based implementation the AES algorithm.
> >
> > The Zkn RISC-V extension provides another interesting take on this: it
> > defines instructions operating on scalar registers that implement the
> > table lookups without relying on tables in memory. Those tables carry
> > 32-bit quantities, making them a natural fit for a 32-bit architecture.
> > And given the use of scalars, we don't have to rely in in-kernel SIMD,
> > which is a bonus.
> >
> > So let's use the instructions to implement the core AES cipher for RV32=
.
> >
> > Cc: Paul Walmsley <paul.walmsley@sifive.com>
> > Cc: Palmer Dabbelt <palmer@dabbelt.com>
> > Cc: Albert Ou <aou@eecs.berkeley.edu>
> > Cc: Christoph M=C3=BCllner <christoph.muellner@vrull.eu>
> > Cc: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/riscv/crypto/Kconfig             |  12 ++
> >  arch/riscv/crypto/Makefile            |   3 +
> >  arch/riscv/crypto/aes-riscv32-glue.c  |  75 ++++++++++++
> >  arch/riscv/crypto/aes-riscv32-zkned.S | 119 ++++++++++++++++++++
> >  4 files changed, 209 insertions(+)
>
> Hi Ard:
>
> Any chance you could postpone this til after I've finished removing
> crypto_cipher?
>

That's fine with me. Do you have an ETA on that? Need any help?

I have implemented the scalar 64-bit counterpart as well in the mean time
