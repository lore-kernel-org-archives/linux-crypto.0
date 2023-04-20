Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226EFC77B73
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Apr 2023 10:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbjDTKW4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Apr 2023 06:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbjDTKWY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2023 06:22:24 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F6D55A7
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2023 03:22:01 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ppRQJ-000YdC-0j; Thu, 20 Apr 2023 18:21:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Apr 2023 18:21:56 +0800
Date:   Thu, 20 Apr 2023 18:21:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 00/13] crypto: x86 - avoid absolute references
Message-ID: <ZEESRGc7VdXdYspd@gondor.apana.org.au>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 12, 2023 at 01:00:22PM +0200, Ard Biesheuvel wrote:
> This is preparatory work for allowing the x86 kernel to be built as a
> PIE executable, which relies mostly on RIP-relative symbol references
> from code, as these don't need to be updated when a binary is loaded at
> an address different from its link time address.
> 
> Most changes are quite straight-forward, i.e., just adding a (%rip)
> suffix is enough in many cases. However, some are slightly trickier, and
> need some minor reshuffling of the asm code to get rid of the absolute
> references in the code.
> 
> Tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on a x86 CPU that
> implements AVX, AVX2 and AVX512.
> 
> Changes since v1:
> - add missing tags from Thomas Garnier
> - simplify AES-NI GCM tail handling and drop an entire permute vector
>   table (patch #2)
> - add a couple of patches to switch to local labels, which removes ~1000
>   useless code symbols (e.g., _loop0, _loop1, _done etc etc) from
>   kallsyms
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> 
> Ard Biesheuvel (13):
>   crypto: x86/aegis128 - Use RIP-relative addressing
>   crypto: x86/aesni - Use RIP-relative addressing
>   crypto: x86/aria - Use RIP-relative addressing
>   crypto: x86/camellia - Use RIP-relative addressing
>   crypto: x86/cast5 - Use RIP-relative addressing
>   crypto: x86/cast6 - Use RIP-relative addressing
>   crypto: x86/crc32c - Use RIP-relative addressing
>   crypto: x86/des3 - Use RIP-relative addressing
>   crypto: x86/ghash - Use RIP-relative addressing
>   crypto: x86/sha256 - Use RIP-relative addressing
>   crypto: x86/aesni - Use local .L symbols for code
>   crypto: x86/crc32 - Use local .L symbols for code
>   crypto: x86/sha - Use local .L symbols for code
> 
>  arch/x86/crypto/aegis128-aesni-asm.S         |   6 +-
>  arch/x86/crypto/aesni-intel_asm.S            | 198 +++++++--------
>  arch/x86/crypto/aesni-intel_avx-x86_64.S     | 254 +++++++++-----------
>  arch/x86/crypto/aria-aesni-avx-asm_64.S      |  28 +--
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S     |  28 +--
>  arch/x86/crypto/aria-gfni-avx512-asm_64.S    |  24 +-
>  arch/x86/crypto/camellia-aesni-avx-asm_64.S  |  30 +--
>  arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  30 +--
>  arch/x86/crypto/camellia-x86_64-asm_64.S     |   6 +-
>  arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |  38 +--
>  arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |  32 +--
>  arch/x86/crypto/crc32-pclmul_asm.S           |  16 +-
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  70 +++---
>  arch/x86/crypto/des3_ede-asm_64.S            |  96 +++++---
>  arch/x86/crypto/ghash-clmulni-intel_asm.S    |   4 +-
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S       |  25 +-
>  arch/x86/crypto/sha256-avx-asm.S             |  16 +-
>  arch/x86/crypto/sha256-avx2-asm.S            |  54 +++--
>  arch/x86/crypto/sha256-ssse3-asm.S           |  16 +-
>  arch/x86/crypto/sha512-avx-asm.S             |   8 +-
>  arch/x86/crypto/sha512-avx2-asm.S            |  16 +-
>  arch/x86/crypto/sha512-ssse3-asm.S           |   8 +-
>  22 files changed, 509 insertions(+), 494 deletions(-)
> 
> -- 
> 2.39.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
