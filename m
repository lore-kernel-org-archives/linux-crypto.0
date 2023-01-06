Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00627C5479D
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 15:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjAFPUD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 10:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbjAFPTc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 10:19:32 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5D98B742
        for <linux-crypto@vger.kernel.org>; Fri,  6 Jan 2023 07:19:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pDoVE-00Ec0v-2S; Fri, 06 Jan 2023 23:19:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Jan 2023 23:19:28 +0800
Date:   Fri, 6 Jan 2023 23:19:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net, x86@kernel.org,
        elliott@hpe.com, jussi.kivilinna@iki.fi, ebiggers@kernel.org
Subject: Re: [PATCH v8 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Message-ID: <Y7g8AAlMGXGjoYCR@gondor.apana.org.au>
References: <20230101091252.700117-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230101091252.700117-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jan 01, 2023 at 09:12:48AM +0000, Taehee Yoo wrote:
> This patchset is to implement aria-avx2 and aria-avx512.
> There are some differences between aria-avx, aria-avx2, and aria-avx512,
> but they are not core logic(s-box, diffusion layer).
> 
> ARIA-AVX2
> It supports 32way parallel processing using 256bit registers.
> Like ARIA-AVX, it supports both AES-NI based s-box layer algorithm and
> GFNI based s-box layer algorithm.
> These algorithms are the same as ARIA-AVX except that AES-NI doesn't
> support 256bit registers, so it is used twice.
> 
> ARIA-AVX512
> It supports 64way parallel processing using 512bit registers.
> It supports only GFNI based s-box layer algorithm.
> 
> Benchmarks with i3-12100
> commands: modprobe tcrypt mode=610 num_mb=8192
> 
> ARIA-AVX512(128bit and 256bit)
>     testing speed of multibuffer ecb(aria) (ecb-aria-avx512) encryption
> tcrypt: 1 operation in 1504 cycles (1024 bytes)
> tcrypt: 1 operation in 4595 cycles (4096 bytes)
> tcrypt: 1 operation in 1763 cycles (1024 bytes)
> tcrypt: 1 operation in 5540 cycles (4096 bytes)
>     testing speed of multibuffer ecb(aria) (ecb-aria-avx512) decryption
> tcrypt: 1 operation in 1502 cycles (1024 bytes)
> tcrypt: 1 operation in 4615 cycles (4096 bytes)
> tcrypt: 1 operation in 1759 cycles (1024 bytes)
> tcrypt: 1 operation in 5554 cycles (4096 bytes)
> 
> ARIA-AVX2 with GFNI(128bit and 256bit)
>     testing speed of multibuffer ecb(aria) (ecb-aria-avx2) encryption
> tcrypt: 1 operation in 2003 cycles (1024 bytes)
> tcrypt: 1 operation in 5867 cycles (4096 bytes)
> tcrypt: 1 operation in 2358 cycles (1024 bytes)
> tcrypt: 1 operation in 7295 cycles (4096 bytes)
>     testing speed of multibuffer ecb(aria) (ecb-aria-avx2) decryption
> tcrypt: 1 operation in 2004 cycles (1024 bytes)
> tcrypt: 1 operation in 5956 cycles (4096 bytes)
> tcrypt: 1 operation in 2409 cycles (1024 bytes)
> tcrypt: 1 operation in 7564 cycles (4096 bytes)
> 
> ARIA-AVX with GFNI(128bit and 256bit)
>     testing speed of multibuffer ecb(aria) (ecb-aria-avx) encryption
> tcrypt: 1 operation in 2761 cycles (1024 bytes)
> tcrypt: 1 operation in 9390 cycles (4096 bytes)
> tcrypt: 1 operation in 3401 cycles (1024 bytes)
> tcrypt: 1 operation in 11876 cycles (4096 bytes)
>     testing speed of multibuffer ecb(aria) (ecb-aria-avx) decryption
> tcrypt: 1 operation in 2735 cycles (1024 bytes)
> tcrypt: 1 operation in 9424 cycles (4096 bytes)
> tcrypt: 1 operation in 3369 cycles (1024 bytes)
> tcrypt: 1 operation in 11954 cycles (4096 bytes)
> 
> v8:
>  - Remove unnecessary code in aria-gfni-avx512-asm_64.S
>  - Do not use magic numbers in the aria-avx.h
>  - Rebase
> 
> v7:
>  - Use IS_ENABLED() instead of defined()
> 
> v6:
>  - Rebase for "CFI fixes" patchset.
>  - Use SYM_TYPED_FUNC_START instead of SYM_FUNC_START.
> 
> v5:
>  - Set CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE flag to avx2, and avx512.
> 
> v4:
>  - Use keystream array in the request ctx.
> 
> v3:
>  - Use ARIA_CTX_enc_key, ARIA_CTX_dec_key, and ARIA_CTX_rounds defines.
> 
> v2:
>  - Add new "add keystream array into struct aria_ctx" patch.
>  - Use keystream array in the aria_ctx instead of stack memory
> 
> Taehee Yoo (4):
>   crypto: aria: add keystream array into request ctx
>   crypto: aria: do not use magic number offsets of aria_ctx
>   crypto: aria: implement aria-avx2
>   crypto: aria: implement aria-avx512
> 
>  arch/x86/crypto/Kconfig                   |   38 +
>  arch/x86/crypto/Makefile                  |    6 +
>  arch/x86/crypto/aria-aesni-avx-asm_64.S   |   26 +-
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 1433 +++++++++++++++++++++
>  arch/x86/crypto/aria-avx.h                |   48 +-
>  arch/x86/crypto/aria-gfni-avx512-asm_64.S |  971 ++++++++++++++
>  arch/x86/crypto/aria_aesni_avx2_glue.c    |  252 ++++
>  arch/x86/crypto/aria_aesni_avx_glue.c     |   45 +-
>  arch/x86/crypto/aria_gfni_avx512_glue.c   |  250 ++++
>  arch/x86/kernel/asm-offsets.c             |    8 +
>  crypto/aria_generic.c                     |    4 +
>  11 files changed, 3052 insertions(+), 29 deletions(-)
>  create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
>  create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
>  create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
>  create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
