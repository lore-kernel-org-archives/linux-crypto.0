Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9FAC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87F832189F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfGZMbY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:31:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46378 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfGZMbY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:31:24 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzNZ-0003iG-50; Fri, 26 Jul 2019 22:31:21 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzNY-00027F-8B; Fri, 26 Jul 2019 22:31:20 +1000
Date:   Fri, 26 Jul 2019 22:31:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@google.com,
        ard.biesheuvel@linaro.org
Subject: Re: [PATCH v4 00/32] crypto: AES cleanup
Message-ID: <20190726123120.GA8126@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This started out as an attempt to provide synchronous SIMD based GCM
> on 32-bit ARM, but along the way, I ended up changing and cleaning up
> so many things that it is more of a general AES cleanup now rather than
> anything else.
> 
> Changes since v3:
> - fix build warning due to missing array dimensions of exported sboxes
> - rename the internal sparc64 AES routines so they don't clash with the
>  new library symbols
> - fix a couple of comments that got truncated
> 
> Changes since v2:
> - fix a bug in the CTR helper function - use chunksize not blocksize of the
>  skcipher as the blocksize of the CTR transformation
> - add a couple of patches so all AES implementation share the forward and
>  inverse Sboxes that are in the AES library.
> - unexpert data structures and helpers that are not actually (or should be)
>  used outside the drivers that define them
> 
> Code can be found here:
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=aes-cleanup-v4
> 
> Changes since v1/RFC:
> - rename x86 AES-NI and padlock routines as well, in order to avoid clashes (#2)
> - move irq en/disabling out of the AES library into the callers (aes-ti
>  and the skcipher helper for sync ctr(aes) added in #17)
> - align 32-bit ARM CE key schedule endianness with other AES drivers, to
>  avoid problems on BE systems when using the synchronous ctr fallback (#18)
> - replace some occurrences where a "aes" or "aes-generic" cipher was allocated
>  explicitly, and use library calls instead.
> - use a generic helper in crypto/ctr.h instead of adding a CTR helper to the
>  AES library for providing the synchronous CTR fallback code.
> 
> Some users of the AES cipher are being switched to other algorithms (i.e.,
> SipHash for TCP fastopen and CCM or cbcmac for wusb and lib80211). These
> have been posted separately, since they have no build time interdependencies.
> 
> ----- Original blurb below ------
> 
> On 32-bit ARM, asynchronous GCM can be provided by the following drivers:
> 
>                                              |  cycles per byte on low end Si
>  gcm_base(ctr(aes-generic),ghash-generic)    |            65.3
>  gcm_base(ctr-aes-neonbs,ghash-ce) [*]       |            27.7
>  gcm_base(ctr-aes-ce,ghash-ce) [**]          |             3.7
> 
>  [*]  ghash-ce using vmull.p8 instructions
>  [**] ghash-ce using optional vmull.p64 instructions
> 
> The third and fastest option is actually only available on 32-bit cores that
> implement the v8 Crypto Extensions, which are rare, but the NEON based runner
> up is obviously a huge improvement over the generic code, not only in terms of
> performance, but also because it is time invariant (generic AES and generic
> GHASH are both implemented using lookup tables, which are susceptible to
> cache timing attacks)
> 
> However, when allocating the gcm(aes) skcipher in synchronous mode, we end up
> with the generic code, due to the fact that the NEON code has no handling for
> invocations that occur from a context where the NEON cannot be used, and so
> it defers the processing to a kthread, which is only permitted for asynchronous
> ciphers.
> 
> So let's implement this fallback handling, by reusing some of the logic that
> has already been implemented for arm64. Note that these fallbacks are rarely
> called in practice, but the API requires the functionality to be there.
> This is implemented in patches 16-22.
> 
> All the patches leading up to that are cleanups for the AES code, to reduce
> the dependency on the generic table based AES code, or in some cases, hardcoded
> dependencies on the scalar arm64 asm code which suffers from the same problem.
> It also removes redundant key expansion routines, and gets rid of the x86
> scalar asm code, which is a maintenance burden and is not actually faster than
> the generic code built with a modern compiler.
> 
> Ard Biesheuvel (32):
>  crypto: arm/aes-ce - cosmetic/whitespace cleanup
>  crypto: aes - rename local routines to prevent future clashes
>  crypto: aes/fixed-time - align key schedule with other implementations
>  crypto: aes - create AES library based on the fixed time AES code
>  crypto: x86/aes-ni - switch to generic for fallback and key routines
>  crypto: x86/aes - drop scalar assembler implementations
>  crypto: padlock/aes - switch to library version of key expansion
>    routine
>  crypto: cesa/aes - switch to library version of key expansion routine
>  crypto: safexcel/aes - switch to library version of key expansion
>    routine
>  crypto: arm64/ghash - switch to AES library
>  crypto: arm/aes-neonbs - switch to library version of key expansion
>    routine
>  crypto: arm64/aes-ccm - switch to AES library
>  crypto: arm64/aes-neonbs - switch to library version of key expansion
>    routine
>  crypto: arm64/aes-ce - switch to library version of key expansion
>    routine
>  crypto: generic/aes - drop key expansion routine in favor of library
>    version
>  crypto: ctr - add helper for performing a CTR encryption walk
>  crypto: aes - move sync ctr(aes) to AES library and generic helper
>  crypto: arm64/aes-ce-cipher - use AES library as fallback
>  crypto: aes/arm - use native endiannes for key schedule
>  crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
>  crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
>  crypto: arm/ghash - provide a synchronous version
>  bluetooth: switch to AES library
>  crypto: amcc/aes - switch to AES library for GCM key derivation
>  crypto: ccp - move to AES library for CMAC key derivation
>  crypto: chelsio/aes - replace AES cipher calls with library calls
>  crypto: aes/generic - unexport last-round AES tables
>  crypto: lib/aes - export sbox and inverse sbox
>  crypto: arm64/aes-neon - switch to shared AES Sboxes
>  crypto: arm/aes-cipher - switch to shared AES inverse Sbox
>  crypto: arm64/aes-cipher - switch to shared AES inverse Sbox
>  crypto: arm/aes-scalar - unexport en/decryption routines
> 
> arch/arm/crypto/Kconfig                       |   2 +-
> arch/arm/crypto/aes-ce-core.S                 |  20 +-
> arch/arm/crypto/aes-ce-glue.c                 | 168 ++++----
> arch/arm/crypto/aes-cipher-core.S             |  40 +-
> arch/arm/crypto/aes-cipher-glue.c             |  11 +-
> arch/arm/crypto/aes-neonbs-glue.c             |  69 +++-
> arch/arm/crypto/ghash-ce-glue.c               |  78 ++--
> arch/arm64/crypto/Kconfig                     |  10 +-
> arch/arm64/crypto/aes-ce-ccm-glue.c           |  18 +-
> arch/arm64/crypto/aes-ce-glue.c               |   7 +-
> arch/arm64/crypto/aes-cipher-core.S           |  40 +-
> arch/arm64/crypto/aes-cipher-glue.c           |  11 +-
> arch/arm64/crypto/aes-ctr-fallback.h          |  53 ---
> arch/arm64/crypto/aes-glue.c                  |  39 +-
> arch/arm64/crypto/aes-neon.S                  |  74 +---
> arch/arm64/crypto/aes-neonbs-glue.c           |  29 +-
> arch/arm64/crypto/ghash-ce-glue.c             |  30 +-
> arch/sparc/crypto/aes_glue.c                  |   8 +-
> arch/x86/crypto/Makefile                      |   4 -
> arch/x86/crypto/aes-i586-asm_32.S             | 362 ------------------
> arch/x86/crypto/aes-x86_64-asm_64.S           | 185 ---------
> arch/x86/crypto/aes_glue.c                    |  70 ----
> arch/x86/crypto/aesni-intel_glue.c            |  23 +-
> arch/x86/include/asm/crypto/aes.h             |  12 -
> crypto/Kconfig                                |  52 +--
> crypto/aes_generic.c                          | 167 +-------
> crypto/aes_ti.c                               | 317 +--------------
> drivers/crypto/Kconfig                        |   8 +-
> drivers/crypto/amcc/crypto4xx_alg.c           |  24 +-
> drivers/crypto/ccp/Kconfig                    |   1 +
> drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |  25 +-
> drivers/crypto/ccp/ccp-crypto.h               |   3 -
> drivers/crypto/chelsio/Kconfig                |   1 +
> drivers/crypto/chelsio/chcr_algo.c            |  46 +--
> drivers/crypto/chelsio/chcr_crypto.h          |   1 -
> drivers/crypto/chelsio/chcr_ipsec.c           |  19 +-
> drivers/crypto/chelsio/chtls/chtls_hw.c       |  20 +-
> .../crypto/inside-secure/safexcel_cipher.c    |   2 +-
> drivers/crypto/marvell/cipher.c               |   2 +-
> drivers/crypto/padlock-aes.c                  |  10 +-
> include/crypto/aes.h                          |  41 +-
> include/crypto/ctr.h                          |  50 +++
> lib/crypto/Makefile                           |   3 +
> lib/crypto/aes.c                              | 356 +++++++++++++++++
> net/bluetooth/Kconfig                         |   3 +-
> net/bluetooth/smp.c                           | 103 ++---
> 46 files changed, 877 insertions(+), 1740 deletions(-)
> delete mode 100644 arch/arm64/crypto/aes-ctr-fallback.h
> delete mode 100644 arch/x86/crypto/aes-i586-asm_32.S
> delete mode 100644 arch/x86/crypto/aes-x86_64-asm_64.S
> delete mode 100644 arch/x86/crypto/aes_glue.c
> delete mode 100644 arch/x86/include/asm/crypto/aes.h
> create mode 100644 lib/crypto/aes.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
