From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 00/16] crypto: SHA glue code consolidation
Date: Tue,  7 Apr 2015 10:51:48 +0200
Message-ID: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37881 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbDGIwX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:23 -0400
Received: by wiaa2 with SMTP id a2so9770731wia.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:22 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

This is v3 of what is now a complete glue code consolidation series
for generic, x86, arm and arm64 implementations of SHA-1, SHA-224/256
and SHA-384/512.

The purpose is to have a single, canonical implementation of the core
logic that gets reused by all versions of the algorithm. Note that this
is not about saving space in the binary, but about ensuring that the same
code is used everywhere, reducing the maintenance burden.

The base layer implements all the update and finalization logic around
the block transforms, where the prototypes of the latter look something
like this:

typedef void (shaXXX_block_fn)(int blocks, u8 const *src, uXX *state,
                             const u8 *head, void *p);

The block implementation should process the head block first, then
process the requested number of block starting at 'src'. The generic
pointer 'p' is passed down from the do_update/do_finalize() versions;
this is used for instance by the ARM64 implementations to indicate to
the core ASM implementation that it should finalize the digest, which
it will do only if the input was a round multiple of the block size.
The generic pointer is used here as a means of conveying that information
back and forth.

Note that the base functions prototypes are all 'returning int' but
they all return 0. They should be invoked as tail calls where possible
to eliminate some of the function call overhead. If that is not possible,
the return values can be safely ignored.

Changes since v2:
- Replace the base modules with header files containing static inlines that
  implement the core logic. This avoids introducing new modules or new
  inter-module dependencies, and gives the compiler the opportunity for
  optimization.
- Now includes new glue fo the existing SHA-1 NEON module and Sami's new
  SHA-224/256 ASM+NEON module
- Use direct assigments instead of memcpy() to set the initial state (as is
  done in many of the call sites of the various init functions that are being
  converted by this series)

Changes since v1 (RFC):
- prefixed globally visible generic symbols with crypto_
- added SHA-1 base layer
- updated init code to only set the initial constants and clear the
  count, clearing the buffer is unnecessary [Markus]
- favor the small update path in crypto_sha_XXX_base_do_update() [Markus]
- update crypto_sha_XXX_do_finalize() to use memset() on the buffer directly
  rather than copying a statically allocated padding buffer into it
  [Markus]
- moved a bunch of existing arm and x86 implementations to use the new base
  layers

Note: looking at the generated asm (for arm64), I noticed that the memcpy/memset
invocations with compile time constant src and len arguments (which includes
the empty struct assignments) are eliminated completely, and replaced by
direct loads and stores. Hopefully this addresses the concern raised by Markus
regarding this.

Ard Biesheuvel (16):
  crypto: sha1: implement base layer for SHA-1
  crypto: sha256: implement base layer for SHA-256
  crypto: sha512: implement base layer for SHA-512
  crypto: sha1-generic: move to generic glue implementation
  crypto: sha256-generic: move to generic glue implementation
  crypto: sha512-generic: move to generic glue implementation
  crypto/arm: move SHA-1 ARM asm implementation to base layer
  crypto/arm: move SHA-1 NEON implementation to base layer
  crypto/arm: move SHA-1 ARMv8 implementation to base layer
  crypto/arm: move SHA-224/256 ASM/NEON implementation to base layer
  crypto/arm: move SHA-224/256 ARMv8 implementation to base layer
  crypto/arm64: move SHA-1 ARMv8 implementation to base layer
  crypto/arm64: move SHA-224/256 ARMv8 implementation to base layer
  crypto/x86: move SHA-1 SSSE3 implementation to base layer
  crypto/x86: move SHA-224/256 SSSE3 implementation to base layer
  crypto/x86: move SHA-384/512 SSSE3 implementation to base layer

 arch/arm/crypto/Kconfig                  |   3 +-
 arch/arm/crypto/sha1-ce-glue.c           | 111 +++++-----------
 arch/arm/{include/asm => }/crypto/sha1.h |   3 +
 arch/arm/crypto/sha1_glue.c              | 116 ++++-------------
 arch/arm/crypto/sha1_neon_glue.c         | 139 +++++---------------
 arch/arm/crypto/sha2-ce-glue.c           | 154 ++++++-----------------
 arch/arm/crypto/sha256_glue.c            | 174 +++++--------------------
 arch/arm/crypto/sha256_glue.h            |  17 +--
 arch/arm/crypto/sha256_neon_glue.c       | 144 +++++++--------------
 arch/arm64/crypto/sha1-ce-core.S         |  11 +-
 arch/arm64/crypto/sha1-ce-glue.c         | 133 ++++----------------
 arch/arm64/crypto/sha2-ce-core.S         |  11 +-
 arch/arm64/crypto/sha2-ce-glue.c         | 209 +++++--------------------------
 arch/x86/crypto/sha1_ssse3_glue.c        | 136 +++++---------------
 arch/x86/crypto/sha256_ssse3_glue.c      | 184 ++++++---------------------
 arch/x86/crypto/sha512_ssse3_glue.c      | 193 ++++++----------------------
 crypto/sha1_generic.c                    | 108 +++++-----------
 crypto/sha256_generic.c                  | 140 +++++----------------
 crypto/sha512_generic.c                  | 127 ++++---------------
 include/crypto/sha.h                     |   9 ++
 include/crypto/sha1_base.h               | 123 ++++++++++++++++++
 include/crypto/sha256_base.h             | 144 +++++++++++++++++++++
 include/crypto/sha512_base.h             | 147 ++++++++++++++++++++++
 23 files changed, 880 insertions(+), 1656 deletions(-)
 rename arch/arm/{include/asm => }/crypto/sha1.h (67%)
 create mode 100644 include/crypto/sha1_base.h
 create mode 100644 include/crypto/sha256_base.h
 create mode 100644 include/crypto/sha512_base.h

-- 
1.8.3.2
