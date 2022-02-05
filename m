Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325E3C433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379011AbiBEE0W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:26:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34004 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbiBEE0U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:26:20 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCeP-0001wp-Sm; Sat, 05 Feb 2022 15:26:19 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:26:17 +1100
Date:   Sat, 5 Feb 2022 15:26:17 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 1/2] lib/xor: make xor prototypes more friendely to
 compiler vectorization
Message-ID: <Yf38aavc1CH1Vcfk@gondor.apana.org.au>
References: <20220127081227.2430-1-ardb@kernel.org>
 <20220127081227.2430-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220127081227.2430-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 09:12:26AM +0100, Ard Biesheuvel wrote:
>
> diff --git a/arch/arm64/lib/xor-neon.c b/arch/arm64/lib/xor-neon.c
> index d189cf4e70ea..64c9577fcf0f 100644
> --- a/arch/arm64/lib/xor-neon.c
> +++ b/arch/arm64/lib/xor-neon.c

This fails to build:

../arch/arm64/lib/xor-neon.c:13:6: warning: no previous prototype for ‘xor_arm64_neon_2’ [-Wmissing-prototypes]
   13 | void xor_arm64_neon_2(unsigned long bytes, unsigned long * __restrict p1,
      |      ^~~~~~~~~~~~~~~~
../arch/arm64/lib/xor-neon.c:40:6: warning: no previous prototype for ‘xor_arm64_neon_3’ [-Wmissing-prototypes]
   40 | void xor_arm64_neon_3(unsigned long bytes, unsigned long * __restrict p1,
      |      ^~~~~~~~~~~~~~~~
../arch/arm64/lib/xor-neon.c:76:6: warning: no previous prototype for ‘xor_arm64_neon_4’ [-Wmissing-prototypes]
   76 | void xor_arm64_neon_4(unsigned long bytes, unsigned long * __restrict p1,
      |      ^~~~~~~~~~~~~~~~
../arch/arm64/lib/xor-neon.c:121:6: warning: no previous prototype for ‘xor_arm64_neon_5’ [-Wmissing-prototypes]
  121 | void xor_arm64_neon_5(unsigned long bytes, unsigned long * __restrict p1,
      |      ^~~~~~~~~~~~~~~~
../arch/arm64/lib/xor-neon.c: In function ‘xor_neon_init’:
../arch/arm64/lib/xor-neon.c:316:29: error: assignment to ‘void (*)(long unsigned int,  long unsigned int * __restrict__,  const long unsigned int * __restrict__,  const long unsigned int * __restrict__)’ from incompatible pointer type ‘void (*)(long unsigned int,  long unsigned int *, long unsigned int *, long unsigned int *)’ [-Werror=incompatible-pointer-types]
  316 |   xor_block_inner_neon.do_3 = xor_arm64_eor3_3;
      |                             ^
../arch/arm64/lib/xor-neon.c:317:29: error: assignment to ‘void (*)(long unsigned int,  long unsigned int * __restrict__,  const long unsigned int * __restrict__,  const long unsigned int * __restrict__,  const long unsigned int * __restrict__)’ from incompatible pointer type ‘void (*)(long unsigned int,  long unsigned int *, long unsigned int *, long unsigned int *, long unsigned int *)’ [-Werror=incompatible-pointer-types]
  317 |   xor_block_inner_neon.do_4 = xor_arm64_eor3_4;
      |                             ^
../arch/arm64/lib/xor-neon.c:318:29: error: assignment to ‘void (*)(long unsigned int,  long unsigned int * __restrict__,  const long unsigned int * __restrict__,  const long unsigned int * __restrict__,  const long unsigned int * __restrict__,  const long unsigned int * __restrict__)’ from incompatible pointer type ‘void (*)(long unsigned int,  long unsigned int *, long unsigned int *, long unsigned int *, long unsigned int *, long unsigned int *)’ [-Werror=incompatible-pointer-types]
  318 |   xor_block_inner_neon.do_5 = xor_arm64_eor3_5;
      |                             ^
cc1: some warnings being treated as errors

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
