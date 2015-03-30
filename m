From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 00/14] crypto: SHA glue code consolidation
Date: Mon, 30 Mar 2015 11:36:10 +0200
Message-ID: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33234 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbbC3Jgf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:36:35 -0400
Received: by wixm2 with SMTP id m2so81863903wix.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:36:33 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

This is v2 of what is now a complete glue code consolidation series
for generic, x86, arm and arm64 implementations of SHA-1, SHA-224/256
and SHA-384/512.

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

Ard Biesheuvel (14):
  crypto: sha512: implement base layer for SHA-512
  crypto: sha256: implement base layer for SHA-256
  crypto: sha1: implement base layer for SHA-1
  crypto: sha512-generic: move to generic glue implementation
  crypto: sha256-generic: move to generic glue implementation
  crypto: sha1-generic: move to generic glue implementation
  crypto/arm: move SHA-1 ARM asm implementation to base layer
  crypto/arm: move SHA-1 ARMv8 implementation to base layer
  crypto/arm: move SHA-224/256 ARMv8 implementation to base layer
  crypto/arm64: move SHA-1 ARMv8 implementation to base layer
  crypto/arm64: move SHA-224/256 ARMv8 implementation to base layer
  crypto/x86: move SHA-1 SSSE3 implementation to base layer
  crypto/x86: move SHA-224/256 SSSE3 implementation to base layer
  crypto/x86: move SHA-384/512 SSSE3 implementation to base layer

 arch/arm/crypto/Kconfig                  |   4 +-
 arch/arm/crypto/sha1-ce-glue.c           | 110 +++++-----------
 arch/arm/{include/asm => }/crypto/sha1.h |   3 +
 arch/arm/crypto/sha1_glue.c              | 117 ++++-------------
 arch/arm/crypto/sha2-ce-glue.c           | 151 +++++-----------------
 arch/arm64/crypto/Kconfig                |   2 +
 arch/arm64/crypto/sha1-ce-core.S         |  11 +-
 arch/arm64/crypto/sha1-ce-glue.c         | 132 ++++----------------
 arch/arm64/crypto/sha2-ce-core.S         |  11 +-
 arch/arm64/crypto/sha2-ce-glue.c         | 208 +++++--------------------------
 arch/x86/crypto/sha1_ssse3_glue.c        | 139 +++++----------------
 arch/x86/crypto/sha256_ssse3_glue.c      | 186 ++++++---------------------
 arch/x86/crypto/sha512_ssse3_glue.c      | 195 ++++++-----------------------
 crypto/Kconfig                           |  16 +++
 crypto/Makefile                          |   3 +
 crypto/sha1_base.c                       | 125 +++++++++++++++++++
 crypto/sha1_generic.c                    | 105 ++++------------
 crypto/sha256_base.c                     | 140 +++++++++++++++++++++
 crypto/sha256_generic.c                  | 139 ++++-----------------
 crypto/sha512_base.c                     | 143 +++++++++++++++++++++
 crypto/sha512_generic.c                  | 126 ++++---------------
 include/crypto/sha.h                     |  62 +++++++++
 22 files changed, 836 insertions(+), 1292 deletions(-)
 rename arch/arm/{include/asm => }/crypto/sha1.h (67%)
 create mode 100644 crypto/sha1_base.c
 create mode 100644 crypto/sha256_base.c
 create mode 100644 crypto/sha512_base.c

-- 
1.8.3.2
