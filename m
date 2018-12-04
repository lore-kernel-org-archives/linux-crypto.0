Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbeLDD4I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Dec 2018 22:56:08 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] crypto: ARM64 NEON optimized XChaCha and NHPoly1305 (for Adiantum)
Date: Mon,  3 Dec 2018 19:52:48 -0800
Message-Id: <20181204035252.14853-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series optimizes the Adiantum encryption mode for ARM64 by adding
an ARM64 NEON accelerated implementation of NHPoly1305, specifically the
NH part; and by modifying the existing ARM64 NEON implementation of
ChaCha20 to support XChaCha20 and XChaCha12.

This greatly improves Adiantum performance on ARM64.  For example,
encrypting 4096-byte messages (single-threaded) on a Raspberry Pi 3
Model B v1.2, which has a Cortex-A53 processor:

                           Before            After
                           ---------         ---------
adiantum(xchacha12,aes)    44.1 MB/s         82.7 MB/s
adiantum(xchacha20,aes)    35.5 MB/s         65.7 MB/s

Decryption is almost exactly the same speed as encryption.

The biggest benefit comes from accelerating XChaCha.  Accelerating NH
gives a somewhat smaller, but still significant benefit.

Performance on 512-byte inputs is also improved, though that is much
slower in the first place.  When Adiantium is used with dm-crypt (or
cryptsetup), we recommend using a 4096-byte sector size.

For comparison, on the same hardware AES-256-XTS encryption is only
24.5 MB/s and decryption 21.6 MB/s, both using the NEON-bitsliced
implementation ("xts-aes-neonbs").  That is the fastest AES-256-XTS
implementation on this processor, since it doesn't have the ARMv8
Cryptography Extensions.  This is despite Adiantum also being a super-
pseudorandom permutation (SPRP) over the entire sector, unlike XTS.

Note that XChaCha20 and XChaCha12 can be used for other purposes too.

Changed since v1:
  - Create full stack frame in hchacha_block_neon() and
    chacha_block_xor_neon().
  - Use x30 instead of lr.
  - Fix whitespace in nh-neon-core.S.

Eric Biggers (4):
  crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305
  crypto: arm64/chacha20 - add XChaCha20 support
  crypto: arm64/chacha20 - refactor to allow varying number of rounds
  crypto: arm64/chacha - add XChaCha12 support

 arch/arm64/crypto/Kconfig                     |   7 +-
 arch/arm64/crypto/Makefile                    |   7 +-
 ...hacha20-neon-core.S => chacha-neon-core.S} |  92 +++++---
 arch/arm64/crypto/chacha-neon-glue.c          | 207 ++++++++++++++++++
 arch/arm64/crypto/chacha20-neon-glue.c        | 133 -----------
 arch/arm64/crypto/nh-neon-core.S              | 103 +++++++++
 arch/arm64/crypto/nhpoly1305-neon-glue.c      |  77 +++++++
 7 files changed, 461 insertions(+), 165 deletions(-)
 rename arch/arm64/crypto/{chacha20-neon-core.S => chacha-neon-core.S} (90%)
 create mode 100644 arch/arm64/crypto/chacha-neon-glue.c
 delete mode 100644 arch/arm64/crypto/chacha20-neon-glue.c
 create mode 100644 arch/arm64/crypto/nh-neon-core.S
 create mode 100644 arch/arm64/crypto/nhpoly1305-neon-glue.c

-- 
2.19.2
