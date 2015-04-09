From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 00/16] crypto: SHA glue code consolidation
Date: Thu,  9 Apr 2015 12:55:32 +0200
Message-ID: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32947 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbDIK4G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:06 -0400
Received: by wgin8 with SMTP id n8so115957038wgi.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:04 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

This is v4 of what is now a complete glue code consolidation series
for generic, x86, arm and arm64 implementations of SHA-1, SHA-224/256
and SHA-384/512.

The purpose is to have a single, canonical implementation of the core
logic that gets reused by all versions of the algorithm. Note that this
is not about saving space in the binary, but about ensuring that the same
code is used everywhere, reducing the maintenance burden.

The base layer implements all the update and finalization logic around
the block transforms, where the prototypes of the latter look something
like this:

typedef void (shaXXX_block_fn)(struct sha###_state *, u8 const *src, int blocks)

Note that the definitions of sha1_state, sha256_state and sha512_state are
updated to put the state[] member first: this allows us to easily cast
existing asm implementation that take a state[] member as first argument
to the above prototype.

Note that the base functions prototypes are all 'returning int' but
they all return 0. They should be invoked as tail calls where possible
to eliminate some of the function call overhead. If that is not possible,
the return values can be safely ignored.

Changes since v3:
- adopted Herbert't suggestion to get rid of the additional arguments in the
  prototype; instead, the prototype now takes a 'struct shaXXX_state' pointer,
  which can be overloaded if there is additional state that needs to be passed
  between the glue layer and the block transform (look at patches #12 and #13
  for examples)
- dropped all export() and import() functions and .statesize members: these are
  only required if statesize != descsize, otherwise, the default implementations
  in the crypto api layer are perfectly adequate
- reshuffled some x86 code so that the existing asm transforms adhere to the
  above prototype (modulo casting), allowing them to be passed to the base layer
  directly

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
 arch/arm/crypto/sha1-ce-core.S           |  23 +---
 arch/arm/crypto/sha1-ce-glue.c           | 110 ++++-----------
 arch/arm/{include/asm => }/crypto/sha1.h |   3 +
 arch/arm/crypto/sha1_glue.c              | 112 +++------------
 arch/arm/crypto/sha1_neon_glue.c         | 137 ++++---------------
 arch/arm/crypto/sha2-ce-core.S           |  19 +--
 arch/arm/crypto/sha2-ce-glue.c           | 155 +++++----------------
 arch/arm/crypto/sha256_glue.c            | 170 ++++-------------------
 arch/arm/crypto/sha256_glue.h            |  17 +--
 arch/arm/crypto/sha256_neon_glue.c       | 143 +++++--------------
 arch/arm64/crypto/sha1-ce-core.S         |  33 ++---
 arch/arm64/crypto/sha1-ce-glue.c         | 151 ++++++--------------
 arch/arm64/crypto/sha2-ce-core.S         |  29 ++--
 arch/arm64/crypto/sha2-ce-glue.c         | 227 +++++++------------------------
 arch/x86/crypto/sha1_ssse3_glue.c        | 139 ++++---------------
 arch/x86/crypto/sha256-avx-asm.S         |  10 +-
 arch/x86/crypto/sha256-avx2-asm.S        |  10 +-
 arch/x86/crypto/sha256-ssse3-asm.S       |  10 +-
 arch/x86/crypto/sha256_ssse3_glue.c      | 193 +++++---------------------
 arch/x86/crypto/sha512-avx-asm.S         |   6 +-
 arch/x86/crypto/sha512-avx2-asm.S        |   6 +-
 arch/x86/crypto/sha512-ssse3-asm.S       |   6 +-
 arch/x86/crypto/sha512_ssse3_glue.c      | 202 +++++----------------------
 crypto/sha1_generic.c                    | 102 +++-----------
 crypto/sha256_generic.c                  | 133 +++---------------
 crypto/sha512_generic.c                  | 123 +++--------------
 include/crypto/sha.h                     |  15 +-
 include/crypto/sha1_base.h               | 106 +++++++++++++++
 include/crypto/sha256_base.h             | 128 +++++++++++++++++
 include/crypto/sha512_base.h             | 131 ++++++++++++++++++
 31 files changed, 866 insertions(+), 1786 deletions(-)
 rename arch/arm/{include/asm => }/crypto/sha1.h (67%)
 create mode 100644 include/crypto/sha1_base.h
 create mode 100644 include/crypto/sha256_base.h
 create mode 100644 include/crypto/sha512_base.h

-- 
1.8.3.2
