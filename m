Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE52C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Apr 2022 00:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356359AbiD0AlQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356322AbiD0AlO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 20:41:14 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDB0387AB
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 17:38:04 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id i4-20020ab04744000000b003520c239119so84164uac.18
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 17:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=DTB4R+sTRqpbz5hLk1mfQJALJeMBahBc8FvPYuHn2fs=;
        b=Q/COuypGTQzjkI81EQnH4Z0lt7B7LCpkJQjk15unSi/oy9DtZbyXrbxkg9vbiwiW04
         PBUkdsDm9tQTvEeRB8B5LEo4MWHnKD914fczy8X2hPBGABaUe8pWTRclYXXM2yhJAC2Q
         4wv4svGWHGAp50VBP2rDk1wHxFkQyRQuCs6qS2qtaWeBv9i0UARAHs8u65hLE7j8roNX
         /mfstl2h8GOq/S0vZ+qwqeYZ6KGlmhtJhfDPohZagpsZfUnhEH+OL3M+vDgn8Pp+yz4W
         WlvjX56eg6SXRumH5o0fr15HPbxXxXWM3PD0XZLQFK6Nl3xF3sH+TFRBEaZ2je3K+wRD
         Xukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=DTB4R+sTRqpbz5hLk1mfQJALJeMBahBc8FvPYuHn2fs=;
        b=AiubBSZBx4ex6FUTqmxWrM4RJZlvkYQAhw9sqtkX3NZisUHUfPoU/F1kBBMM9O1An/
         x7UOQYgR+FLSgSzN7VnbtT87BboxeRq86skkp+k4CYJKBPvhoViPx1m2xHTOAW5ZnD6v
         P0GQG+2lTu3y9eIXac7paiT+yr2ZHVv7j07yuSJ/bSVh/HS+jR2SA2WK1J49uyp2CeTN
         8sEn1JDd84xbP9XhmfAji4aqfra6nx1EeofsPjBpNxGaQv9XUUDYJkn3efPPx5OA3Lng
         ubm+mP+UedNG++PW1a4gbx/AqlkMHFv0/YXSyS4nGoOUGxs7p+7py1xWTLi88KYK8y9f
         Q6Jw==
X-Gm-Message-State: AOAM533/0fMdXAaexTF1LSo980HpgksTLHlUO1BH62JwW/x3Cs7XXT+D
        5k2eHwbNuXZ0tflZ+Sz2SFwjoQqvKIsPjDZJqKNfiQ6OYAH4WsAh/+IsjQtV49J/lF4RllOObqY
        vCUMYPKyKiNZQAZ8LQIN8vDbcXwaB7pZ2kBc82CpKg89RkY18w1yjABae1ouo+2L0HT0=
X-Google-Smtp-Source: ABdhPJzJtX225emeVY2ouGJecO+mlp14wIY6NbL3d2uxntv4Rm9qA9ptDIjtMalx9tedKmacXXVBUu+6yQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:ab0:148d:0:b0:35c:dc01:a673 with SMTP id
 d13-20020ab0148d000000b0035cdc01a673mr7527404uae.18.1651019883225; Tue, 26
 Apr 2022 17:38:03 -0700 (PDT)
Date:   Wed, 27 Apr 2022 00:37:51 +0000
Message-Id: <20220427003759.1115361-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v5 0/8] crypto: HCTR2 support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
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

Changes in v5:
 * Refactor HCTR2 tweak hashing
 * Remove non-AVX x86-64 XCTR implementation
 * Combine arm64 CTR and XCTR modes
 * Comment and alias CTR and XCTR modes
 * Move generic fallback code for simd POLYVAL into polyval-generic.c
 * Various small style fixes

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

 Documentation/filesystems/fscrypt.rst   |   22 +-
 arch/arm64/crypto/Kconfig               |    9 +-
 arch/arm64/crypto/Makefile              |    3 +
 arch/arm64/crypto/aes-glue.c            |   64 +-
 arch/arm64/crypto/aes-modes.S           |  290 +++--
 arch/arm64/crypto/polyval-ce-core.S     |  369 ++++++
 arch/arm64/crypto/polyval-ce-glue.c     |  194 +++
 arch/x86/crypto/Makefile                |    3 +
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  232 ++--
 arch/x86/crypto/aesni-intel_glue.c      |  109 ++
 arch/x86/crypto/polyval-clmulni_asm.S   |  330 +++++
 arch/x86/crypto/polyval-clmulni_glue.c  |  200 +++
 crypto/Kconfig                          |   39 +-
 crypto/Makefile                         |    3 +
 crypto/hctr2.c                          |  580 +++++++++
 crypto/polyval-generic.c                |  242 ++++
 crypto/tcrypt.c                         |   10 +
 crypto/testmgr.c                        |   20 +
 crypto/testmgr.h                        | 1536 +++++++++++++++++++++++
 crypto/xctr.c                           |  191 +++
 fs/crypto/fscrypt_private.h             |    2 +-
 fs/crypto/keysetup.c                    |    7 +
 fs/crypto/policy.c                      |   14 +-
 include/crypto/polyval.h                |   26 +
 include/uapi/linux/fscrypt.h            |    3 +-
 25 files changed, 4306 insertions(+), 192 deletions(-)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 create mode 100644 crypto/hctr2.c
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/xctr.c
 create mode 100644 include/crypto/polyval.h

--=20
2.36.0.rc2.479.g8af0fa9b8e-goog

