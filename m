Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D192C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 10:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiKKKSU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 05:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbiKKKRg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 05:17:36 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539447E9A1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 02:17:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1otR6J-00Cyuq-QV; Fri, 11 Nov 2022 18:17:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Nov 2022 18:17:31 +0800
Date:   Fri, 11 Nov 2022 18:17:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, keescook@chromium.org,
        Eric Biggers <ebiggers@kernel.org>,
        Robert Elliott <elliott@hpe.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH v5 0/3] crypto: Add AES-GCM implementation to lib/crypto
Message-ID: <Y24hO3qElp9y6BoD@gondor.apana.org.au>
References: <20221103192259.2229-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103192259.2229-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 03, 2022 at 08:22:56PM +0100, Ard Biesheuvel wrote:
> Provide a generic library implementation of AES-GCM which can be used
> really early during boot, e.g., to communicate with the security
> coprocessor on SEV-SNP virtual machines to bring up secondary cores.
> This is needed because the crypto API is not available yet this early.
> 
> We cannot rely on special instructions for AES or polynomial
> multiplication, which are arch specific and rely on in-kernel SIMD
> infrastructure. Instead, add a generic C implementation that combines
> the existing C implementations of AES and multiplication in GF(2^128).
> 
> To reduce the risk of forgery attacks, replace data dependent table
> lookups and conditional branches in the used gf128mul routine with
> constant-time equivalents. The AES library has already been robustified
> to some extent to prevent known-plaintext timing attacks on the key, but
> we call it with interrupts disabled to make it a bit more robust. (Note
> that in SEV-SNP context, the VMM is untrusted, and is able to inject
> interrupts arbitrarily, and potentially maliciously.)
> 
> Changes since v4:
> - Rename CONFIG_CRYPTO_GF128MUL to CONFIG_CRYPTO_LIB_GF128MUL
> - Use bool return value for decrypt routine to align with other AEAD
>   library code
> - Return -ENODEV on selftest failure to align with other algos
> - Use pr_err() not WARN() on selftest failure for the same reason
> - Mention in a code comment that the counter cannot roll over or result
>   in a carry due to the width of the type representing the size of the
>   input
> 
> Changes since v3:
> - rename GCM-AES to AES-GCM
> 
> Changes since v2:
> - move gf128mul to lib/crypto
> - add patch #2 to make gf128mul_lle constant time
> - fix kerneldoc headers and drop them from the .h file
> 
> Changes since v1:
> - rename gcm to gcmaes to reflect that GCM is also used in
>   combination with other symmetric ciphers (Jason)
> - add Nikunj's Tested-by
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Robert Elliott <elliott@hpe.com>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> 
> Ard Biesheuvel (3):
>   crypto: move gf128mul library into lib/crypto
>   crypto: gf128mul - make gf128mul_lle time invariant
>   crypto: aesgcm - Provide minimal library implementation
> 
>  arch/arm/crypto/Kconfig           |   2 +-
>  arch/arm64/crypto/Kconfig         |   2 +-
>  crypto/Kconfig                    |   9 +-
>  crypto/Makefile                   |   1 -
>  drivers/crypto/chelsio/Kconfig    |   2 +-
>  include/crypto/gcm.h              |  22 +
>  lib/crypto/Kconfig                |   9 +
>  lib/crypto/Makefile               |   5 +
>  lib/crypto/aesgcm.c               | 727 ++++++++++++++++++++
>  {crypto => lib/crypto}/gf128mul.c |  58 +-
>  10 files changed, 808 insertions(+), 29 deletions(-)
>  create mode 100644 lib/crypto/aesgcm.c
>  rename {crypto => lib/crypto}/gf128mul.c (87%)
> 
> -- 
> 2.35.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
