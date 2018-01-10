From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/7] arm64: move literal data into .rodata section
Date: Wed, 10 Jan 2018 12:11:35 +0000
Message-ID: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, dann.frazier@canonical.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35086 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbeAJMLv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 07:11:51 -0500
Received: by mail-wm0-f68.google.com with SMTP id r78so1361879wme.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2018 04:11:50 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Prevent inadvertently creating speculative gadgets by moving literal data
into the .rodata section.

Patch #1 enables this for C code, by reverting a change that disables the
GCC feature implementing this. Note that this conflicts with the mitigation
of erratum #843419 for Cortex-A53.

Patch #2 - #7 update the crypto asm code to move sboxes and round constant
tables (which may or may not be hiding 'interesting' opcodes) from .text
to .rodata

Ard Biesheuvel (7):
  arm64: kernel: avoid executable literal pools
  arm64/crypto: aes-cipher: move S-box to .rodata section
  arm64/crypto: aes-neon: move literal data to .rodata section
  arm64/crypto: crc32: move literal data to .rodata section
  arm64/crypto: crct10dif: move literal data to .rodata section
  arm64/crypto: sha2-ce: move the round constant table to .rodata
    section
  arm64/crypto: sha1-ce: get rid of literal pool

 arch/arm64/Makefile                   |  4 ++--
 arch/arm64/crypto/aes-cipher-core.S   | 19 ++++++++++---------
 arch/arm64/crypto/aes-neon.S          |  8 ++++----
 arch/arm64/crypto/crc32-ce-core.S     |  7 ++++---
 arch/arm64/crypto/crct10dif-ce-core.S | 17 +++++++++--------
 arch/arm64/crypto/sha1-ce-core.S      | 20 +++++++++-----------
 arch/arm64/crypto/sha2-ce-core.S      |  4 +++-
 7 files changed, 41 insertions(+), 38 deletions(-)

-- 
2.11.0
