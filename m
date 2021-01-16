Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0CDC433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 320D520791
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbhAPRUH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbhAPRUG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E93DD23382;
        Sat, 16 Jan 2021 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610816090;
        bh=aAxYMVAsUeoF4CVOhIXaZwp2MvSPjBImiW+eo3kDHKY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hpzZdlJminatwp9JlZypGE4aZswa0ekU4lJxAwzWsZI5nyCVauje3JGx1zQwZhNIU
         W0Mpd1jewzuL5AoV1PLvn6J9FUyw3rI24ROFETqiysFM/1wwASQ75IDVyrwr4NvUAU
         PoVSYOfdmrcuH51Dybs6CsTgpxq4QUg1fNn+wQHbXjSk2DBxOJxE0ww4ZlNU5af0IC
         pkI2VxQFSK7C77gIDZ7RikGZeqXCijpkDUFqLBNGcmPdDYnMbD2hFF5SMOcTpZyu3B
         pmymqh0QPRGj3AY1SJfOlzkLl0i+N17305dvfKPDUETywqmjTOYfiQ1gnyxCAu2K0A
         jAyQl/sJR3G/A==
Received: by mail-ot1-f46.google.com with SMTP id d8so11871539otq.6;
        Sat, 16 Jan 2021 08:54:49 -0800 (PST)
X-Gm-Message-State: AOAM530nwVCXRjcpaHBxpKYCZ/dh2FElY3m8GtnNKdlEtJA421p5VZ8Q
        vP72nJXYPdM7VOilnqHetOJCHRvB8RpdMTVao4s=
X-Google-Smtp-Source: ABdhPJx3QtYh30q003OyCCTPQfe1O6bzFjbaLXqegynzA8+H/M3Ejf10HFOndqqORBG4ecSEXorD+tK1P4drlIC1SDo=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr12134380ote.108.1610816089305;
 Sat, 16 Jan 2021 08:54:49 -0800 (PST)
MIME-Version: 1.0
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com> <1608325864-4033-2-git-send-email-megha.dey@intel.com>
In-Reply-To: <1608325864-4033-2-git-send-email-megha.dey@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 16 Jan 2021 17:54:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGJD1FdixURybqZEOJV+h1-QESp=WCJVPo-Bvd7Zh9j1Q@mail.gmail.com>
Message-ID: <CAMj1kXGJD1FdixURybqZEOJV+h1-QESp=WCJVPo-Bvd7Zh9j1Q@mail.gmail.com>
Subject: Re: [RFC V1 1/7] x86: Probe assembler capabilities for VAES and
 VPLCMULQDQ support
To:     Megha Dey <megha.dey@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, Dave Hansen <dave.hansen@intel.com>,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 18 Dec 2020 at 22:07, Megha Dey <megha.dey@intel.com> wrote:
>
> This is a preparatory patch to introduce the optimized crypto algorithms
> using AVX512 instructions which would require VAES and VPLCMULQDQ support.
>
> Check for VAES and VPCLMULQDQ assembler support using AVX512 registers.
>
> Cc: x86@kernel.org
> Signed-off-by: Megha Dey <megha.dey@intel.com>
> ---
>  arch/x86/Kconfig.assembler | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
> index 26b8c08..9ea0bc8 100644
> --- a/arch/x86/Kconfig.assembler
> +++ b/arch/x86/Kconfig.assembler
> @@ -1,6 +1,16 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
>
> +config AS_VAES_AVX512
> +       def_bool $(as-instr,vaesenc %zmm0$(comma)%zmm1$(comma)%zmm1) && 64BIT

Is the '&& 64BIT' necessary here, but not below?

In any case, better to use a separate 'depends on' line, for legibility

> +       help
> +         Supported by binutils >= 2.30 and LLVM integrated assembler
> +
> +config AS_VPCLMULQDQ
> +       def_bool $(as-instr,vpclmulqdq \$0$(comma)%zmm2$(comma)%zmm6$(comma)%zmm4)
> +       help
> +         Supported by binutils >= 2.30 and LLVM integrated assembler
> +
>  config AS_AVX512
>         def_bool $(as-instr,vpmovm2b %k1$(comma)%zmm5)
>         help
> --
> 2.7.4
>
