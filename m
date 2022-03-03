Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C393C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 07:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiCCH1r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 02:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiCCH1p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 02:27:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F53216DAE3
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 23:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21BA1B82372
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 07:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCA9C004E1
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 07:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646292417;
        bh=g+Qkel0q81INfGY2BfeVP9mlM37Pf9LbpvJ+1Cv64rY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hO3XNfqiC9HOepl6idaTnPzypuRaVwuFakTSwQENEXX04Ejeb/+8S3I1l2pS2EWYa
         ujLFft8eoGb5qDE8ut/Zo16OgEMDptemnDmhqBSyvJl6WER+kF+V+vRkZY7B/DoWW7
         jMjzA1DDS/EfwYpwdZm/fM2+DeSP8ClAgtQy5gnZ5Rr3Q9geF1cSobIAEzHhBoVhpy
         1yePB5kq/ZxFT3Cfwkj6WOxXlucAQJYHCJxIaP++YHf1QP/VPvSdFkH0fl2RPZvz1O
         M9oC4IwdLDfCuNp8Yu1vKsTUs1DhTaVVDfMBf+yFqu32k0GjzJEOMRodcn19weD9nH
         xeHkxOeT0VH/A==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2dc348dab52so11473347b3.6
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 23:26:57 -0800 (PST)
X-Gm-Message-State: AOAM533MbXonbqM4xLO8NpKY9D+1DvUKsTTN0Ix1O2d2+AIZXA/0gk0U
        TVgPq/n3Zxhzl9he8VT/oazu9b1KMkynSIdiclM=
X-Google-Smtp-Source: ABdhPJyyJ7OePIxQ78awbDiflwiym3Cp0FbXGU9xOeN8uFu2PveWX+q+2FKzxeYN/qGMXODeiOJFU2ni2qMEWyEVU9Q=
X-Received: by 2002:a81:e90c:0:b0:2db:d63e:56ff with SMTP id
 d12-20020a81e90c000000b002dbd63e56ffmr13505259ywm.60.1646292416781; Wed, 02
 Mar 2022 23:26:56 -0800 (PST)
MIME-Version: 1.0
References: <20220302165438.1140256-1-broonie@kernel.org>
In-Reply-To: <20220302165438.1140256-1-broonie@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 3 Mar 2022 07:26:45 +0000
X-Gmail-Original-Message-ID: <CAMj1kXHhTNsB8V=4LNMqSXrAWXroHHNXzjS0xWERboG7a3G-Lg@mail.gmail.com>
Message-ID: <CAMj1kXHhTNsB8V=4LNMqSXrAWXroHHNXzjS0xWERboG7a3G-Lg@mail.gmail.com>
Subject: Re: [PATCH] arm64: crypto: Don't allow v8.2 extensions to be used
 with BROKEN_GAS_INST
To:     Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2 Mar 2022 at 16:54, Mark Brown <broonie@kernel.org> wrote:
>
> We support building the kernel with archaic versions of binutils which
> had some confusion regarding how instructions should be encoded for .inst
> which we work around with the __emit_inst() macro. Unfortunately we have
> not consistently used this macro, one of the places where it's missed being
> the macros that manually encode v8.2 crypto instructions. This means that
> kernels built with such toolchains have never supported use of the affected
> instructions correctly.
>
> Since these toolchains are very old (some idle research suggested 2015
> era) it seems more sensible to just refuse to build v8.2 crypto support
> with them, in the unlikely event that someone has a need to use such a
> toolchain to build a kernel which will run on a system with v8.2 crypto
> support they can always fix this properly but it seems more likely that
> we will deprecate support for these toolchains and remove __emit_inst()
> before that happens.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

IIRC this is not about .inst getting the encoding wrong, but about
confusion over the size of the generated opcode, resulting in problems
generating constants involving relative offsets between labels. (The
endian swap is there so that .long can be used on BE to emit the LE
opcodes)

This is not an issue here, so I don't think this change is necessary.

> ---
>  arch/arm64/crypto/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> index 2a965aa0188d..90dd62d46739 100644
> --- a/arch/arm64/crypto/Kconfig
> +++ b/arch/arm64/crypto/Kconfig
> @@ -32,12 +32,14 @@ config CRYPTO_SHA2_ARM64_CE
>  config CRYPTO_SHA512_ARM64_CE
>         tristate "SHA-384/SHA-512 digest algorithm (ARMv8 Crypto Extensions)"
>         depends on KERNEL_MODE_NEON
> +       depends on !BROKEN_GAS_INST
>         select CRYPTO_HASH
>         select CRYPTO_SHA512_ARM64
>
>  config CRYPTO_SHA3_ARM64
>         tristate "SHA3 digest algorithm (ARMv8.2 Crypto Extensions)"
>         depends on KERNEL_MODE_NEON
> +       depends on !BROKEN_GAS_INST
>         select CRYPTO_HASH
>         select CRYPTO_SHA3
>
> @@ -50,6 +52,7 @@ config CRYPTO_SM3_ARM64_CE
>  config CRYPTO_SM4_ARM64_CE
>         tristate "SM4 symmetric cipher (ARMv8.2 Crypto Extensions)"
>         depends on KERNEL_MODE_NEON
> +       depends on !BROKEN_GAS_INST
>         select CRYPTO_ALGAPI
>         select CRYPTO_LIB_SM4
>
> --
> 2.30.2
>
