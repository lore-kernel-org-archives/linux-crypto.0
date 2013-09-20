From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/4] ARM: NEON based fast(er) AES in CBC/CTR/XTS modes
Date: Fri, 20 Sep 2013 20:46:47 +0200
Message-ID: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:58560 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3ITSre (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Sep 2013 14:47:34 -0400
Received: by mail-we0-f180.google.com with SMTP id u57so902801wes.11
        for <linux-crypto@vger.kernel.org>; Fri, 20 Sep 2013 11:47:33 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This implementation of the AES algorithm gives around 45% speedup on Cortex-A15
for CTR mode and for XTS in encryption mode. Both CBC and XTS in decryption mode
are slightly faster (5 - 10% on Cortex-A15). [As CBC in encryption mode can only
be performed sequentially, there is no speedup in this case.]

Unlike the core AES cipher (on which this module also depends), this algorithm
uses bit slicing to process up to 8 blocks in parallel in constant time. This
algorithm does not rely on any lookup tables so it is believed to be
invulnerable to cache timing attacks.

The core code has been adopted from the OpenSSL project (in collaboration
with the original author, on cc). For ease of maintenance, this version is
identical to the upstream OpenSSL code, i.e., all modifications that were
required to make it suitable for inclusion into the kernel have already been
merged upstream.

This code passes the builtin test 'modprobe tcrypt.ko mode=10' in both ARM and
Thumb-2 modes.

Note to reviewers:
Reviewing the file aesbs-core.S may be a bit overwhelming, so if there are any
questions or concerns, please refer to the link below. This is the original Perl
script that gets called by OpenSSL's build system during their build to generate
the .S file on the fly. [In the case of OpenSSL, this is used in some cases to
target different assemblers or ABIs]. This arrangement is not suitable (or 
required) for the kernel, so I have taken the generated .S file instead.

http://git.openssl.org/gitweb/?p=openssl.git;f=crypto/aes/asm/bsaes-armv7.pl;a=blob


Note to integrators:
While this implementation is significantly faster, especially in CTR mode, it is
unclear whether the net impact on power efficiency is favorable or not, so
please refrain from making any assumptions to that effect.


Ard Biesheuvel (4):
  crypto: create generic version of ablk_helper
  ARM: pull in <asm/simd.h> from asm-generic
  ARM: move AES typedefs and function prototypes to separate header
  ARM: add support for bit sliced AES using NEON instructions

 arch/arm/crypto/Makefile     |    6 +-
 arch/arm/crypto/aes_glue.c   |   22 +-
 arch/arm/crypto/aes_glue.h   |   19 +
 arch/arm/crypto/aesbs-core.S | 2603 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/crypto/aesbs-glue.c |  449 ++++++++
 arch/arm/include/asm/Kbuild  |    1 +
 crypto/Kconfig               |   20 +
 crypto/Makefile              |    1 +
 crypto/ablk_helper.c         |  150 +++
 include/asm-generic/simd.h   |   14 +
 include/crypto/ablk_helper.h |   31 +
 11 files changed, 3298 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/crypto/aes_glue.h
 create mode 100644 arch/arm/crypto/aesbs-core.S
 create mode 100644 arch/arm/crypto/aesbs-glue.c
 create mode 100644 crypto/ablk_helper.c
 create mode 100644 include/asm-generic/simd.h
 create mode 100644 include/crypto/ablk_helper.h

-- 
1.8.1.2
