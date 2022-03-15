Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC9FC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Mar 2022 23:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiCOXCB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349524AbiCOXCA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Mar 2022 19:02:00 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1D15D64B
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:00:47 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id o25-20020ab008d9000000b0034c03fd28b8so254258uaf.14
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=8CJhO1qSe4NJZ0C6gYEijooQzmBofhmFB7H2qKUutZU=;
        b=DKnwVlBgGDWAtCjjmYuNW3kDpge37IbqI91ix4NvKCcTdhFxDmAGNCInBjH7gh4Fyz
         g5X84axTLKd3qvGUZkezWe7bIlXZDbq337+D8IAici/fPg/Kp9v4eyqdLaalIEdFbrAM
         9Q1iztkqno60X7tUy+W9bF0aA2wDkzinX5w+kqrRJGzOGZ3uQpvemCSzU2c5KY85sRGm
         GR+bxAd1Q/uFjs8otC7DNsEBzib12W1MLo2tfDXHQ8NI0PYEA+i4jcBIWykDVoxzpDdS
         0sbrSEOM2+eJsUWTzaqKsGErfMsKX7nHB4gV6pHVIBnHX0RgdouYaYRJKNf2GK18UelW
         B37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=8CJhO1qSe4NJZ0C6gYEijooQzmBofhmFB7H2qKUutZU=;
        b=YBwZkavBHCOtey8U3Q9OAhABeOoXuI2lGx3Ez8LTJidNKuqWM5ySfR81KEHUG8KFV6
         uj064wFZ8t0PS2kj7CTMpH8UWbp+OLAEPJGx31QwTrpQSHYq98C+M/7fQSufjYZWbK3j
         8I41Q7H/D4xgiIyz5i9sFpCEZ8qMORqAkET5hScHXB7KpmMl7+Pl7RKJ36O6hUtXZDB/
         wZrAeWJCEYEwXhRRRRLvG13BORC29rRWnQpf2cym80p4UdlqL7xbT72h+K+F4R/eTW7a
         nqpA1XCxY2FB8Yr9lfGUD1Bf0B8gyysU6NO3VPGCss5DP0+gZYPGhVxk51S126LPeCwx
         o4xw==
X-Gm-Message-State: AOAM532scE+8ezF31in/Xb3kGwuqPeMw3Bqh3qkuyeDWL1aubcoVCexh
        aXS5ma3zQnDodU9Wv7WMZWHon+vUQHkLHxzCg5F1gNO/tT05kYgkPyVGsGzbi327+z4rmx0Ol5u
        XBPfFuAGlc0E8c/RY58eJ2G5NWd+KxMu3dhk7TxLEYORN2YQDpWa+QNf2tMhB8topaPM=
X-Google-Smtp-Source: ABdhPJxTeI8lqGEnpC8FJix7+F9pP1Z1yMFMFRx6hBas9tNVQlTFdA/2oHxf9tmBc7fs4Snlye/3LZyI+w==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6102:2ee:b0:320:d2e5:1eed with SMTP id
 j14-20020a05610202ee00b00320d2e51eedmr13429656vsj.63.1647385246650; Tue, 15
 Mar 2022 16:00:46 -0700 (PDT)
Date:   Tue, 15 Mar 2022 23:00:27 +0000
Message-Id: <20220315230035.3792663-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v3 0/8] crypto: HCTR2 support
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

HCTR2 is specified in https://ia.cr/2021/1441 "Length-preserving
encryption with HCTR2" which shows that if AES is secure and HCTR2 is
instantiated with AES, then HCTR2 is secure.  Reference code and test
vectors are at https://github.com/google/hctr2.

As a length-preserving encryption mode, HCTR2 is suitable for applications
such as storage encryption where ciphertext expansion is not possible, and
thus authenticated encryption cannot be used.  Currently, such
applications usually use XTS, or in some cases Adiantum.  XTS has the
disadvantage that it is a narrow-block mode: a bitflip will only change 16
bytes in the resulting ciphertext or plaintext.  This reveals more
information to an attacker than necessary.

HCTR2 is a wide-block mode, so it provides a stronger security property: a
bitflip will change the entire message.  HCTR2 is somewhat similar to
Adiantum, which is also a wide-block mode.  However, HCTR2 is designed to
take advantage of existing crypto instructions, while Adiantum targets
devices without such hardware support.  Adiantum is also designed with
longer messages in mind, while HCTR2 is designed to be efficient even on
short messages.

The first intended use of this mode in the kernel is for the encryption of
filenames, where for efficiency reasons encryption must be fully
deterministic (only one ciphertext for each plaintext) and the existing
CBC solution leaks more information than necessary for filenames with
common prefixes.

HCTR2 uses two passes of an =CE=B5-almost-=E2=88=86-universal hash function=
 called
POLYVAL and one pass of a block cipher mode called XCTR.  POLYVAL is a
polynomial hash designed for efficiency on modern processors and was
originally specified for use in AES-GCM-SIV (RFC 8452).  XCTR mode is a
variant of CTR mode that is more efficient on little-endian machines.

This patchset adds HCTR2 to Linux's crypto API, including generic
implementations of XCTR and POLYVAL, hardware accelerated implementations o=
f
XCTR and POLYVAL for both x86-64 and ARM64, a templated implementation of H=
CTR2,
and an fscrypt policy for using HCTR2 for filename encryption.

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
 arch/arm64/crypto/Kconfig               |   11 +-
 arch/arm64/crypto/Makefile              |    3 +
 arch/arm64/crypto/aes-glue.c            |   65 +-
 arch/arm64/crypto/aes-modes.S           |  134 ++
 arch/arm64/crypto/polyval-ce-core.S     |  372 ++++++
 arch/arm64/crypto/polyval-ce-glue.c     |  363 ++++++
 arch/x86/crypto/Makefile                |    3 +
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  233 ++--
 arch/x86/crypto/aesni-intel_asm.S       |   70 ++
 arch/x86/crypto/aesni-intel_glue.c      |   89 ++
 arch/x86/crypto/polyval-clmulni_asm.S   |  376 ++++++
 arch/x86/crypto/polyval-clmulni_glue.c  |  361 ++++++
 crypto/Kconfig                          |   40 +-
 crypto/Makefile                         |    3 +
 crypto/hctr2.c                          |  580 +++++++++
 crypto/polyval-generic.c                |  205 +++
 crypto/tcrypt.c                         |   10 +
 crypto/testmgr.c                        |   20 +
 crypto/testmgr.h                        | 1536 +++++++++++++++++++++++
 crypto/xctr.c                           |  193 +++
 fs/crypto/fscrypt_private.h             |    2 +-
 fs/crypto/keysetup.c                    |    7 +
 fs/crypto/policy.c                      |    4 +
 include/crypto/polyval.h                |   17 +
 include/uapi/linux/fscrypt.h            |    3 +-
 tools/include/uapi/linux/fscrypt.h      |    3 +-
 27 files changed, 4633 insertions(+), 89 deletions(-)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 create mode 100644 crypto/hctr2.c
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/xctr.c
 create mode 100644 include/crypto/polyval.h

--=20
2.35.1.723.g4982287a31-goog

