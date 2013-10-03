From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS modes
Date: Thu,  3 Oct 2013 23:59:23 +0200
Message-ID: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, patches@linaro.org, linux@arm.linux.org.uk,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62145 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3JCWAv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Oct 2013 18:00:51 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so738081wid.3
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2013 15:00:50 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is v2 of a series implementing a faster and more secure AES implementation
based on bit slicing using NEON instructions.

Changes since v1:
- implemented a suggestion by Jussi Kivilinna which substantially improves
  decryption performance, decryption speedup is now 25% on Cortex-A15 (up from
  5 - 10%), encryption speedup is still at 45%;
- fixed a potential issue with tail blocks in CTR mode;
- copied some comments about the origin of this code and the expected power
  efficiency from the cover letter to the commit log of patch 3;
- some cosmetic changes.

This code passes the builtin test 'modprobe tcrypt.ko mode=10' in both ARM and
Thumb-2 modes.

The core code has been adopted from the OpenSSL project (in collaboration
with the original author, on cc). For ease of maintenance, this version is
identical to the upstream OpenSSL code, i.e., all modifications that were
required to make it suitable for inclusion into the kernel have been made
upstream.

Note to reviewers:
Reviewing the file aesbs-core.S may be a bit overwhelming, so if there are any
questions or concerns, please refer the file bsaes-armv7.pl which can be found
at the link below. This is the original Perl script that gets called by
OpenSSL's build system during their build to generate the .S file on the fly.
[In the case of OpenSSL, this is used in some cases to target different
assemblers or ABIs]. This arrangement is not suitable (or required) for the
kernel, so I have taken the generated .S file instead.

    http://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=6f6a6130

This series still depends on commit a62b01cd (crypto: create generic version of
ablk_helper) which I omitted this time but which can be found in the cryptodev
tree or in linux-next.

Ard Biesheuvel (3):
  ARM: pull in <asm/simd.h> from asm-generic
  ARM: move AES typedefs and function prototypes to separate header
  ARM: add support for bit sliced AES using NEON instructions

 arch/arm/crypto/Makefile     |    6 +-
 arch/arm/crypto/aes_glue.c   |   22 +-
 arch/arm/crypto/aes_glue.h   |   19 +
 arch/arm/crypto/aesbs-core.S | 2544 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/crypto/aesbs-glue.c |  435 ++++++++
 arch/arm/include/asm/Kbuild  |    1 +
 crypto/Kconfig               |   16 +
 7 files changed, 3025 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/crypto/aes_glue.h
 create mode 100644 arch/arm/crypto/aesbs-core.S
 create mode 100644 arch/arm/crypto/aesbs-glue.c

-- 
1.8.1.2
