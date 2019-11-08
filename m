Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A5EFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA3A121848
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215783;
	bh=FZgI1fL7L7eQKY2JO4ProUplrPTMc2PXqN0vDjuIYZo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=GoKkErGNuMc3jt0AvOuH2IAlFfe3L2y9k9XLAZ+vZHT7r84s93BrQWzLaB02FSAX7
	 bod5IGSaptyUtROGaY1YH7WARQZeWPn8UAZ0VmacMwwzDw1kCDKhyf7K7msfqbGbY3
	 2Aq2JFJiEIT2jOs2R4DtSReyKchkcf6DuqCugexU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfKHMXC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:02 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667BF206DF;
        Fri,  8 Nov 2019 12:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215780;
        bh=FZgI1fL7L7eQKY2JO4ProUplrPTMc2PXqN0vDjuIYZo=;
        h=From:To:Cc:Subject:Date:From;
        b=y21igJPOb8r1WztHrGtBmPY9StKdU438w0dp2ui1LeAmODh/Kgj5dUR1VhS0Wg4Fd
         chk2XWC6qxJhsAgpxnHpJxk90R3ms2EuftoQ4/uT2JSTxR2j2fpuvL6D43XJa+Qt6d
         WMSVA7RvD/kg5rYrKwQzcAISmew8vb8TzTrTs2RQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 00/34] crypto: crypto API library interfaces for WireGuard
Date:   Fri,  8 Nov 2019 13:22:06 +0100
Message-Id: <20191108122240.28479-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series implements the crypto library abstractions that are needed to
incorporate WireGuard into the mainline kernel.

Changes since v4:
- Address most review feedback from Eric, with the exception of the remark
  about libraries being selectable by the user - this is something we need
  to revisit in the context of moving to weak references or static calls to
  make accelerated versions of libraries loadable at any time. (Currently,
  loading an accelerated version at runtime will not supersede calls to the
  generic routines in the kernel proper, which is counterintuitive, and this
  is currently being addressed by making the generic library versions only
  selectable as modules if the accelerated ones are selected as modules as
  well)
- Align the generic blake2s Kconfig symbols, filenames etc with the recently
  added blake2b driver.
- Rewrote the blake2s selftest for better coverage of key length and input
  length combinations, and added a HMAC selftest as well.
- Rename blake2s_hmac() to blake2s256_hmac(), and drop the digest length
  argument, which was not implemented correctly, and never deviates from
  the full length in practice anyway.
- Update to more recent version of the blake2s x86 Zinc code

Changes since v3:
- Unify the way the generic vs arch libraries are organized between ChaCha20
  and Poly1305 on the one hand and Curve25519 and Blake2s on the other.
  All are now made up of a generic library, a generic crypto API driver
  (skcipher for [X]ChaCha, shash for Poly1305 and Blake2s and kpp for
  Curve25519) and optional per-arch versions providing both the library and
  the crypto API interfaces while potentially relying on the generic *library*
  only as a fallback (and not on the generic crypto API driver). Implementations
  of the libary interface that don't require the fallback don't pull in the
  generic code at all, but the generic crypto API drivers are tied to the
  generic implementations directly (this is necessary since we fuzz test the
  accelerated implementations against the generic implementations)
- Provide testmgr test vectors for the Curve25519 and Blake2s crypto API
  drivers that were added in this revision. This also required some changes
  to the KPP test routines so we can test for failures as well.
- Update to the latest version of Andy Polyakov's Poly1305 implementation for
  MIPS that incorporates Rene's improvements for 32r2
- Remove logic in the x86 and ARM implementations of ChaCha and Poly1305 to
  prefer the non-SIMD path for short inputs. This is no longer necessary, and
  even undesirable since it forced ChaCha20Poly1305's ChaCha pass generating
  the Poly1305 nonce to always take the slower scalar path.

Changes since v2:
- Reduce the cc: audience a bit, since I assumed that not everyone is
  interested in discussing the details of this.
- Incorporate scalar ARM code for ChaCha, and the 64-bit MIPS code for
  Poly1305. NOTE: the Cryptogams MIPS code now supports 32-bit MIPS as well,
  and not just 32r2, so I omitted Rene's Poly1305 implementation for now, and
  used Andy's code for everything.
- Incorporate NEON opt-out for Cortex-A5/A7. Note that the code is still
  exposed via the crypto API, but with a low prioririty, so it is still
  available and still gets test coverage, but is not used by default.
- Use static keys (*not* static calls) in the SIMD and bmi2/adx drivers to
  keep track of which implementation is being used, to avoid the memory
  load on each call.
- Defer using weak references or static calls until the dust around this has
  settled. Instead, rely on Kconfig constraints and symbol dependencies to
  ensure that the arch code is always used when it is loaded. This means
  you can only opt out of using the arch code if you disable it in Kconfig
  but this is something I can live with for now.
- Refactor the Curve25519 glue code slightly so that the call sites branch to
  the arch or generic code directly.
- Split up the Poly1305 refactoring patches so they can be reviewed more
  easily.

Changes since RFC/v1:
- dropped the WireGuard patch itself, and the followup patches - since the
  purpose was to illustrate the extent of the required changes, there is no
  reason to keep including them.
- import the MIPS 32r2 versions of ChaCha and Poly1305, but expose both the
  crypto API and library interfaces so that not only WireGuard but also IPsec
  and Adiantum can benefit immediately. (The latter required adding support for
  the reduced round version of ChaCha to the MIPS asm code)
- fix up various minor kconfig/build issues found in randconfig testing
  (thanks Arnd!)

Patches can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=wireguard-crypto-library-api-v5

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Martin Willi <martin@strongswan.org>
Cc: Rene van Dorst <opensource@vdorst.com>
Cc: David Sterba <dsterba@suse.com>

Ard Biesheuvel (27):
  crypto: tidy up lib/crypto Kconfig and Makefile
  crypto: chacha - move existing library code into lib/crypto
  crypto: x86/chacha - depend on generic chacha library instead of
    crypto driver
  crypto: x86/chacha - expose SIMD ChaCha routine as library function
  crypto: arm64/chacha - depend on generic chacha library instead of
    crypto driver
  crypto: arm64/chacha - expose arm64 ChaCha routine as library function
  crypto: arm/chacha - import Eric Biggers's scalar accelerated ChaCha
    code
  crypto: arm/chacha - remove dependency on generic ChaCha driver
  crypto: arm/chacha - expose ARM ChaCha routine as library function
  crypto: mips/chacha - wire up accelerated 32r2 code from Zinc
  crypto: chacha - unexport chacha_generic routines
  crypto: poly1305 - move core routines into a separate library
  crypto: x86/poly1305 - unify Poly1305 state struct with generic code
  crypto: poly1305 - expose init/update/final library interface
  crypto: x86/poly1305 - depend on generic library not generic shash
  crypto: x86/poly1305 - expose existing driver as poly1305 library
  crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON
    implementation
  crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON
    implementation
  crypto: mips/poly1305 - incorporate OpenSSL/CRYPTOGAMS optimized
    implementation
  int128: move __uint128_t compiler test to Kconfig
  crypto: testmgr - add test cases for Blake2s
  crypto: blake2s - implement generic shash driver
  crypto: curve25519 - add kpp selftest
  crypto: curve25519 - implement generic KPP driver
  crypto: lib/curve25519 - work around Clang stack spilling issue
  crypto: chacha20poly1305 - import construction and selftest from Zinc
  crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine

Jason A. Donenfeld (7):
  crypto: mips/chacha - import 32r2 ChaCha code from Zinc
  crypto: BLAKE2s - generic C library implementation and selftest
  crypto: BLAKE2s - x86_64 SIMD implementation
  crypto: Curve25519 - generic C library implementations
  crypto: Curve25519 - x86_64 library and KPP implementations
  crypto: arm - import Bernstein and Schwabe's Curve25519 ARM
    implementation
  crypto: arm/Curve25519 - wire up NEON implementation

 arch/arm/crypto/Kconfig                   |   16 +-
 arch/arm/crypto/Makefile                  |   17 +-
 arch/arm/crypto/chacha-glue.c             |  343 +
 arch/arm/crypto/chacha-neon-glue.c        |  202 -
 arch/arm/crypto/chacha-scalar-core.S      |  460 ++
 arch/arm/crypto/curve25519-core.S         | 2062 ++++++
 arch/arm/crypto/curve25519-glue.c         |  127 +
 arch/arm/crypto/poly1305-armv4.pl         | 1236 ++++
 arch/arm/crypto/poly1305-core.S_shipped   | 1158 +++
 arch/arm/crypto/poly1305-glue.c           |  276 +
 arch/arm64/Kconfig                        |    2 +-
 arch/arm64/crypto/Kconfig                 |    9 +-
 arch/arm64/crypto/Makefile                |   10 +-
 arch/arm64/crypto/chacha-neon-glue.c      |   81 +-
 arch/arm64/crypto/poly1305-armv8.pl       |  913 +++
 arch/arm64/crypto/poly1305-core.S_shipped |  835 +++
 arch/arm64/crypto/poly1305-glue.c         |  237 +
 arch/mips/Makefile                        |    2 +-
 arch/mips/crypto/Makefile                 |   18 +
 arch/mips/crypto/chacha-core.S            |  497 ++
 arch/mips/crypto/chacha-glue.c            |  150 +
 arch/mips/crypto/poly1305-glue.c          |  203 +
 arch/mips/crypto/poly1305-mips.pl         | 1273 ++++
 arch/riscv/Kconfig                        |    2 +-
 arch/x86/Kconfig                          |    2 +-
 arch/x86/crypto/Makefile                  |    3 +
 arch/x86/crypto/blake2s-core.S            |  258 +
 arch/x86/crypto/blake2s-glue.c            |  233 +
 arch/x86/crypto/chacha_glue.c             |  181 +-
 arch/x86/crypto/curve25519-x86_64.c       | 2475 +++++++
 arch/x86/crypto/poly1305_glue.c           |  199 +-
 crypto/Kconfig                            |   71 +-
 crypto/Makefile                           |    2 +
 crypto/adiantum.c                         |    5 +-
 crypto/blake2s_generic.c                  |  171 +
 crypto/chacha_generic.c                   |   84 +-
 crypto/curve25519-generic.c               |   90 +
 crypto/ecc.c                              |    2 +-
 crypto/nhpoly1305.c                       |    3 +-
 crypto/poly1305_generic.c                 |  228 +-
 crypto/testmgr.c                          |   30 +
 crypto/testmgr.h                          | 1520 +++-
 include/crypto/blake2s.h                  |  106 +
 include/crypto/chacha.h                   |   83 +-
 include/crypto/chacha20poly1305.h         |   48 +
 include/crypto/curve25519.h               |   71 +
 include/crypto/internal/blake2s.h         |   24 +
 include/crypto/internal/chacha.h          |   43 +
 include/crypto/internal/poly1305.h        |   58 +
 include/crypto/poly1305.h                 |   69 +-
 init/Kconfig                              |    4 +
 lib/Makefile                              |    3 +-
 lib/crypto/Kconfig                        |  130 +
 lib/crypto/Makefile                       |   42 +-
 lib/crypto/blake2s-generic.c              |  111 +
 lib/crypto/blake2s-selftest.c             |  622 ++
 lib/crypto/blake2s.c                      |  126 +
 lib/{ => crypto}/chacha.c                 |   20 +-
 lib/crypto/chacha20poly1305-selftest.c    | 7393 ++++++++++++++++++++
 lib/crypto/chacha20poly1305.c             |  369 +
 lib/crypto/curve25519-fiat32.c            |  864 +++
 lib/crypto/curve25519-hacl64.c            |  788 +++
 lib/crypto/curve25519.c                   |   25 +
 lib/crypto/libchacha.c                    |   35 +
 lib/crypto/poly1305.c                     |  232 +
 lib/ubsan.c                               |    2 +-
 lib/ubsan.h                               |    2 +-
 67 files changed, 26148 insertions(+), 808 deletions(-)
 create mode 100644 arch/arm/crypto/chacha-glue.c
 delete mode 100644 arch/arm/crypto/chacha-neon-glue.c
 create mode 100644 arch/arm/crypto/chacha-scalar-core.S
 create mode 100644 arch/arm/crypto/curve25519-core.S
 create mode 100644 arch/arm/crypto/curve25519-glue.c
 create mode 100644 arch/arm/crypto/poly1305-armv4.pl
 create mode 100644 arch/arm/crypto/poly1305-core.S_shipped
 create mode 100644 arch/arm/crypto/poly1305-glue.c
 create mode 100644 arch/arm64/crypto/poly1305-armv8.pl
 create mode 100644 arch/arm64/crypto/poly1305-core.S_shipped
 create mode 100644 arch/arm64/crypto/poly1305-glue.c
 create mode 100644 arch/mips/crypto/chacha-core.S
 create mode 100644 arch/mips/crypto/chacha-glue.c
 create mode 100644 arch/mips/crypto/poly1305-glue.c
 create mode 100644 arch/mips/crypto/poly1305-mips.pl
 create mode 100644 arch/x86/crypto/blake2s-core.S
 create mode 100644 arch/x86/crypto/blake2s-glue.c
 create mode 100644 arch/x86/crypto/curve25519-x86_64.c
 create mode 100644 crypto/blake2s_generic.c
 create mode 100644 crypto/curve25519-generic.c
 create mode 100644 include/crypto/blake2s.h
 create mode 100644 include/crypto/chacha20poly1305.h
 create mode 100644 include/crypto/curve25519.h
 create mode 100644 include/crypto/internal/blake2s.h
 create mode 100644 include/crypto/internal/chacha.h
 create mode 100644 include/crypto/internal/poly1305.h
 create mode 100644 lib/crypto/Kconfig
 create mode 100644 lib/crypto/blake2s-generic.c
 create mode 100644 lib/crypto/blake2s-selftest.c
 create mode 100644 lib/crypto/blake2s.c
 rename lib/{ => crypto}/chacha.c (88%)
 create mode 100644 lib/crypto/chacha20poly1305-selftest.c
 create mode 100644 lib/crypto/chacha20poly1305.c
 create mode 100644 lib/crypto/curve25519-fiat32.c
 create mode 100644 lib/crypto/curve25519-hacl64.c
 create mode 100644 lib/crypto/curve25519.c
 create mode 100644 lib/crypto/libchacha.c
 create mode 100644 lib/crypto/poly1305.c

-- 
2.20.1

