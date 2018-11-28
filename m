Return-Path: <SRS0=p+N9=OH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbeK1Rry (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Nov 2018 12:47:54 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] crypto: x86_64 optimized XChaCha and NHPoly1305 (for Adiantum)
Date: Tue, 27 Nov 2018 22:44:39 -0800
Message-Id: <20181128064445.3813-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series optimizes the Adiantum encryption mode for x86_64 by adding
SSE2 and AVX2 accelerated implementations of NHPoly1305, specifically
the NH part; and by modifying the existing x86_64 SSSE3/AVX2 ChaCha20
implementation to support XChaCha20 and XChaCha12.

This greatly improves Adiantum performance on x86_64.  For example, with
a 4096-byte input size on a Zen-based processor, which supports AVX2:

                           Before                After
                           --------              ---------
adiantum(xchacha12,aes)    505 MB/s              1250 MB/s
adiantum(xchacha20,aes)    387 MB/s              989 MB/s

Encryption and decryption are the same speed.

The biggest benefit comes from accelerating XChaCha.  Accelerating NH
gives a somewhat smaller, but still significant benefit.

Performance on 512-byte inputs is also improved, though that is much
slower in the first place.  When Adiantium is used with dm-crypt (or
cryptsetup), we recommend using a 4096-byte sector size.

For comparison, AES-256-XTS is 4140 MB/s on the same processor, but it
has the benefit of direct AES-NI hardware support for AES whereas
Adiantum is implemented entirely with general-purpose instructions
(scalar and SIMD).  The corresponding C implementation of AES-256-XTS is
only 288 MB/s, and AES isn't particularly well-suited for optimizing
with general-purpose SIMD instructions.  Also unlike Adiantum, XTS isn't
a super-pseudorandom permutation over the entire sector.

Note that XChaCha20 and XChaCha12 can be used for other purposes too.

Eric Biggers (6):
  crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305
  crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305
  crypto: x86/chacha20 - limit the preemption-disabled section
  crypto: x86/chacha20 - add XChaCha20 support
  crypto: x86/chacha20 - refactor to allow varying number of rounds
  crypto: x86/chacha - add XChaCha12 support

 arch/x86/crypto/Makefile                      |  13 +-
 ...a20-avx2-x86_64.S => chacha-avx2-x86_64.S} |  33 ++-
 ...0-ssse3-x86_64.S => chacha-ssse3-x86_64.S} |  99 +++++---
 arch/x86/crypto/chacha20_glue.c               | 168 -------------
 arch/x86/crypto/chacha_glue.c                 | 236 ++++++++++++++++++
 arch/x86/crypto/nh-avx2-x86_64.S              | 157 ++++++++++++
 arch/x86/crypto/nh-sse2-x86_64.S              | 123 +++++++++
 arch/x86/crypto/nhpoly1305-avx2-glue.c        |  77 ++++++
 arch/x86/crypto/nhpoly1305-sse2-glue.c        |  76 ++++++
 crypto/Kconfig                                |  28 ++-
 10 files changed, 778 insertions(+), 232 deletions(-)
 rename arch/x86/crypto/{chacha20-avx2-x86_64.S => chacha-avx2-x86_64.S} (97%)
 rename arch/x86/crypto/{chacha20-ssse3-x86_64.S => chacha-ssse3-x86_64.S} (93%)
 delete mode 100644 arch/x86/crypto/chacha20_glue.c
 create mode 100644 arch/x86/crypto/chacha_glue.c
 create mode 100644 arch/x86/crypto/nh-avx2-x86_64.S
 create mode 100644 arch/x86/crypto/nh-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/nhpoly1305-avx2-glue.c
 create mode 100644 arch/x86/crypto/nhpoly1305-sse2-glue.c

-- 
2.19.2
