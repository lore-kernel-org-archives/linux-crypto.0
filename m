Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC03C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Apr 2022 17:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbiDLRas (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355697AbiDLRas (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Apr 2022 13:30:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7714454680
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 10:28:29 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb4f03f212so163289587b3.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 10:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Twc/Ff7p8KJeWa7G/qM1YTbI72WgfNQZQGTMcSy+qfg=;
        b=aL9pzGGJu/w4pyPi8inAuAuglvSPgkEhFAh5A9LcRj7QALFR0JVOg3FOoNhZ5UqwxR
         UkYTt8w16R5CV8CfSwklpxKZzveWGEkyGYNZiMV7KWQSK+Ncz/ju/5TA2d/GDHmoWs2O
         3isc5UHa5o0Oj05XCmyuOrv42o9LrqYN6/fEq3mR+GUzVE63vbNzlz/ABiLtM6lbMvJw
         DVYDyusi/Czzr9yZ/FzssPIi7yJdWccoEM5SBoTEl7ceYY4uf+EvvUokpj/U6NQCPsEC
         ltYC1mcZTsgIVmrlVarquVUrd41ARDLoMHpk6z2ffHPEyJxRJujTSkXldC+DYsz3XXGd
         rPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Twc/Ff7p8KJeWa7G/qM1YTbI72WgfNQZQGTMcSy+qfg=;
        b=nRNBfJUPa7sksiqVuTLK2UgPpA0VIwu34Nvx8T5dqV14qSlWa3CadtLZ7wLEOTX43n
         NRd5EBl0KemYRUEra35Oi1hPAmMOTXJQbPaeChtDi8Lyf/+3s6FIub8VRflznSMU5/Ux
         yp2CPoSP1DZabNwQP/324cXJq7Vgsa0Ezb4C69z63yGO9RWbEOATVIIdIPiH7dUQasVd
         T0CEY2R9smSyZxSCEMn65KVjPVbALqpKc0I7U7O7F4fXfmjshz3ZFxwhY2xHKG3IATh7
         GC+kAGT6dcxg7O2bJPirzBmRglg2Gt+6Sjm1x7I+QfYag/EHzcq3PN9sd6irIvjOs4Z7
         5FYg==
X-Gm-Message-State: AOAM532FX0sIjvhZGGnPS++XZE2Le5wMp/2dsTdLafqw5cRM0KYvGMjI
        GSg3OLBrWh85IK4fT8Un6pUmdNiR3PZ+H8fqJ6rWJIdKrIHKFSWsMw1PiiRcc3GjiT6jFL5W3m/
        Vx4pzp3HWGJfVOykRCnHbXi+FVKhXUcbW5EgfqyscYAmQlkreT9BiIHSIGYDLz8H6t04=
X-Google-Smtp-Source: ABdhPJyo5lIxcqSCyMKvTmbrF3R6iMZ9c3cNPT2kneSj0UhGjqeUycI5APH7uIIFSRVM9kyw4+xD6VOsdQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:888f:0:b0:641:bbd1:5325 with SMTP id
 d15-20020a25888f000000b00641bbd15325mr1607638ybl.152.1649784508592; Tue, 12
 Apr 2022 10:28:28 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:28:08 +0000
Message-Id: <20220412172816.917723-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 0/8] crypto: HCTR2 support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

HCTR2 is a length-preserving encryption mode that is efficient on
processors with instructions to accelerate AES and carryless
multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
processors with the ARMv8 Crypto Extensions.

HCTR2 is specified in https://ia.cr/2021/1441 "Length-preserving encryption
with HCTR2" which shows that if AES is secure and HCTR2 is instantiated
with AES, then HCTR2 is secure.  Reference code and test vectors are at
https://github.com/google/hctr2.

As a length-preserving encryption mode, HCTR2 is suitable for applications
such as storage encryption where ciphertext expansion is not possible, and
thus authenticated encryption cannot be used.  Currently, such applications
usually use XTS, or in some cases Adiantum.  XTS has the disadvantage that
it is a narrow-block mode: a bitflip will only change 16 bytes in the
resulting ciphertext or plaintext.  This reveals more information to an
attacker than necessary.

HCTR2 is a wide-block mode, so it provides a stronger security property: a
bitflip will change the entire message.  HCTR2 is somewhat similar to
Adiantum, which is also a wide-block mode.  However, HCTR2 is designed to
take advantage of existing crypto instructions, while Adiantum targets
devices without such hardware support.  Adiantum is also designed with
longer messages in mind, while HCTR2 is designed to be efficient even on
short messages.

The first intended use of this mode in the kernel is for the encryption of
filenames, where for efficiency reasons encryption must be fully
deterministic (only one ciphertext for each plaintext) and the existing CBC
solution leaks more information than necessary for filenames with common
prefixes.

HCTR2 uses two passes of an =CE=B5-almost-=E2=88=86-universal hash function=
 called
POLYVAL and one pass of a block cipher mode called XCTR.  POLYVAL is a
polynomial hash designed for efficiency on modern processors and was
originally specified for use in AES-GCM-SIV (RFC 8452).  XCTR mode is a
variant of CTR mode that is more efficient on little-endian machines.

This patchset adds HCTR2 to Linux's crypto API, including generic
implementations of XCTR and POLYVAL, hardware accelerated implementations
of XCTR and POLYVAL for both x86-64 and ARM64, a templated implementation
of HCTR2, and an fscrypt policy for using HCTR2 for filename encryption.

Changes in v4:
 * Small style fixes in generic POLYVAL and XCTR
 * Move HCTR2 hash exporting/importing to helper functions
 * Rewrite montgomery reduction for x86-64 POLYVAL
 * Rewrite partial block handling for x86-64 POLYVAL
 * Optimize x86-64 POLYVAL loop handling
 * Remove ahash wrapper from x86-64 POLYVAL
 * Add simd-unavailable handling to x86-64 POLYVAL
 * Rewrite montgomery reduction for ARM64 POLYVAL
 * Rewrite partial block handling for ARM64 POLYVAL
 * Optimize ARM64 POLYVAL loop handling
 * Remove ahash wrapper from ARM64 POLYVAL
 * Add simd-unavailable handling to ARM64 POLYVAL

Changes in v3:
 * Improve testvec coverage for XCTR, POLYVAL and HCTR2
 * Fix endianness bug in xctr.c
 * Fix alignment issues in polyval-generic.c
 * Optimize hctr2.c by exporting/importing hash states
 * Fix blockcipher name derivation in hctr2.c
 * Move x86-64 XCTR implementation into aes_ctrby8_avx-x86_64.S
 * Reuse ARM64 CTR mode tail handling in ARM64 XCTR
 * Fix x86-64 POLYVAL comments
 * Fix x86-64 POLYVAL key_powers type to match asm
 * Fix ARM64 POLYVAL comments
 * Fix ARM64 POLYVAL key_powers type to match asm
 * Add XTS + HCTR2 policy to fscrypt

Nathan Huckleberry (8):
  crypto: xctr - Add XCTR support
  crypto: polyval - Add POLYVAL support
  crypto: hctr2 - Add HCTR2 support
  crypto: x86/aesni-xctr: Add accelerated implementation of XCTR
  crypto: arm64/aes-xctr: Add accelerated implementation of XCTR
  crypto: x86/polyval: Add PCLMULQDQ accelerated implementation of
    POLYVAL
  crypto: arm64/polyval: Add PMULL accelerated implementation of POLYVAL
  fscrypt: Add HCTR2 support for filename encryption

 Documentation/filesystems/fscrypt.rst   |   19 +-
 arch/arm64/crypto/Kconfig               |   10 +-
 arch/arm64/crypto/Makefile              |    3 +
 arch/arm64/crypto/aes-glue.c            |   65 +-
 arch/arm64/crypto/aes-modes.S           |  134 ++
 arch/arm64/crypto/polyval-ce-core.S     |  366 ++++++
 arch/arm64/crypto/polyval-ce-glue.c     |  240 ++++
 arch/x86/crypto/Makefile                |    3 +
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  233 ++--
 arch/x86/crypto/aesni-intel_asm.S       |   70 ++
 arch/x86/crypto/aesni-intel_glue.c      |   89 ++
 arch/x86/crypto/polyval-clmulni_asm.S   |  333 +++++
 arch/x86/crypto/polyval-clmulni_glue.c  |  234 ++++
 crypto/Kconfig                          |   40 +-
 crypto/Makefile                         |    3 +
 crypto/hctr2.c                          |  616 +++++++++
 crypto/polyval-generic.c                |  214 ++++
 crypto/tcrypt.c                         |   10 +
 crypto/testmgr.c                        |   20 +
 crypto/testmgr.h                        | 1536 +++++++++++++++++++++++
 crypto/xctr.c                           |  191 +++
 fs/crypto/fscrypt_private.h             |    2 +-
 fs/crypto/keysetup.c                    |    7 +
 fs/crypto/policy.c                      |    4 +
 include/crypto/polyval.h                |   17 +
 include/uapi/linux/fscrypt.h            |    3 +-
 tools/include/uapi/linux/fscrypt.h      |    3 +-
 27 files changed, 4376 insertions(+), 89 deletions(-)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 create mode 100644 crypto/hctr2.c
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/xctr.c
 create mode 100644 include/crypto/polyval.h

--=20
2.35.1.1178.g4f1659d476-goog

