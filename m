Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761BCC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 09:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343698AbiBKJhu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:37:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiBKJhs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 04:37:48 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBE9F5B
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 01:37:47 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nISN6-0004Vf-2c; Fri, 11 Feb 2022 20:37:45 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:37:43 +1100
Date:   Fri, 11 Feb 2022 20:37:43 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH v4 0/2] xor: enable auto-vectorization in Clang
Message-ID: <YgYuZ2jAhD9zzZjE@gondor.apana.org.au>
References: <20220205152346.237392-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205152346.237392-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 05, 2022 at 04:23:44PM +0100, Ard Biesheuvel wrote:
> Update the xor_blocks() prototypes so that the compiler understands that
> the inputs always refer to distinct regions of memory. This is implied
> by the existing implementations, as they use different granularities for
> the load/xor/store loops.
> 
> With that, we can fix the ARM/Clang version, which refuses to SIMD
> vectorize otherwise, and throws a spurious warning related to the GCC
> version being incompatible.
> 
> Changes since v3:
> - revert broken PPC argument rename - doing it fully results in too
>   much pointless churn, and the 'inner' altivec routines are not
>   strictly part of the xor_blocks API anyway
> 
> Changes since v2:
> - fix arm64 build after rebase
> - name PPC argument names consistently
> - add Nick's acks and link tags
> 
> Changes since v1:
> - fix PPC build
> - add Nathan's Tested-by
> 
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> 
> Ard Biesheuvel (2):
>   lib/xor: make xor prototypes more friendly to compiler vectorization
>   crypto: arm/xor - make vectorized C code Clang-friendly
> 
>  arch/alpha/include/asm/xor.h           | 53 ++++++++----
>  arch/arm/include/asm/xor.h             | 42 ++++++----
>  arch/arm/lib/xor-neon.c                | 12 +--
>  arch/arm64/include/asm/xor.h           | 21 +++--
>  arch/arm64/lib/xor-neon.c              | 46 +++++++----
>  arch/ia64/include/asm/xor.h            | 21 +++--
>  arch/powerpc/include/asm/xor_altivec.h | 25 +++---
>  arch/powerpc/lib/xor_vmx.c             | 28 ++++---
>  arch/powerpc/lib/xor_vmx.h             | 27 ++++---
>  arch/powerpc/lib/xor_vmx_glue.c        | 32 ++++----
>  arch/s390/lib/xor.c                    | 21 +++--
>  arch/sparc/include/asm/xor_32.h        | 21 +++--
>  arch/sparc/include/asm/xor_64.h        | 42 ++++++----
>  arch/x86/include/asm/xor.h             | 42 ++++++----
>  arch/x86/include/asm/xor_32.h          | 42 ++++++----
>  arch/x86/include/asm/xor_avx.h         | 21 +++--
>  include/asm-generic/xor.h              | 84 +++++++++++++-------
>  include/linux/raid/xor.h               | 21 +++--
>  18 files changed, 384 insertions(+), 217 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
