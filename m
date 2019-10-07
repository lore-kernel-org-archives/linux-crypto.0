Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0056C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B037B20700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fhFWjU+f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfJGQqX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55381 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfJGQqX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id a6so196047wma.5
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pogvIvCVi6pKWjXnNS4Vm16o6O0Ivdee/8uKLNhNjfM=;
        b=fhFWjU+fNHBR2UdErTFLjA9g6XEqj1dnlAwlBX4nyBPfFte5HkX5kvqEfqhjkb330q
         KZeFFLVfSXlEiYPjpv2s9OWGGkZYfq8my8DIQ8j3LrZNX6Wh2iReflg7xON3T+CRAjbV
         jPooGaHpdJ0LMReJLcI4S/p8B6e9KZLggruIHrN82utI5iLyhuTVI93LwC3Gi4qn1vWU
         ZJU74vIiu1lOd5rppALsa+JkkND8TnuUI1OxTp4BjsuMK5vQLX82VjkGERfFcYpeAhTI
         d2n3TJYRNI82GRmCBwoNYkJL2ET4Yrp49975MSqAKD1I3BfnWrSpT2hNMWsDullGoqNq
         N+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pogvIvCVi6pKWjXnNS4Vm16o6O0Ivdee/8uKLNhNjfM=;
        b=QiRIxpTS+j5rYQ1M1m6RlgFKly4JMYt0b5WGfTZqjbuLEQhM8wt3vn0FZXYxsmgs2m
         socaoCtH2U+tL4shvJNMtD4DbhSTWINOWAvy3UDR7ixoJ+2qIPoL8kCbvG8Qn8VhXF7+
         y5J47OYzRS7lC9ppW3bCu4EfG2as/yF5wqTdRFztC94mVtlG3RPL/Eg99qXzwJ4TV2gN
         cYU4xS6UXx7ftNdI7LwokVUIEkuU9f+BX32s7JnVMEbEfKI44EBkEX2b3qW76qxLVNHi
         pe5veqsKzh5OG/ZVP3SF/IlMYpMJcfxhCCuFKRlg8fydPcmKGQJvooThJ6eSmaXfWXrt
         4fJQ==
X-Gm-Message-State: APjAAAVlBTDHPcWhcEVRKPqfc1wlo2cO0N61uQuyw7oQmVvHG0iPFBaQ
        krgEgo5gi0sYNXy2oJys0OOtP0HYs6BRJw==
X-Google-Smtp-Source: APXvYqyKVh0pNJFwH72X4Qae7ua1ol6E2dy7oIb+KLzMfka6XR/DTQPDong7Dcy8P7xhLhZ5J/yobA==
X-Received: by 2002:a7b:c74a:: with SMTP id w10mr189706wmk.30.1570466779241;
        Mon, 07 Oct 2019 09:46:19 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 00/29] crypto: crypto API library interfaces for WireGuard
Date:   Mon,  7 Oct 2019 18:45:41 +0200
Message-Id: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=wireguard-crypto-library-api-v3

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Martin Willi <martin@strongswan.org>
Cc: Rene van Dorst <opensource@vdorst.com>

Ard Biesheuvel (23):
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
  crypto: mips/chacha - import 32r2 ChaCha code from Zinc
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
  crypto: lib/curve25519 - work around Clang stack spilling issue
  crypto: chacha20poly1305 - import construction and selftest from Zinc
  crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine

Jason A. Donenfeld (6):
  crypto: BLAKE2s - generic C library implementation and selftest
  crypto: BLAKE2s - x86_64 library implementation
  crypto: Curve25519 - generic C library implementations and selftest
  crypto: Curve25519 - x86_64 library implementation
  crypto: arm - import Bernstein and Schwabe's Curve25519 ARM
    implementation
  crypto: arm/Curve25519 - wire up NEON implementation

 arch/arm/crypto/Kconfig                   |   16 +-
 arch/arm/crypto/Makefile                  |   16 +-
 arch/arm/crypto/chacha-glue.c             |  385 +
 arch/arm/crypto/chacha-neon-glue.c        |  202 -
 arch/arm/crypto/chacha-scalar-core.S      |  460 ++
 arch/arm/crypto/curve25519-core.S         | 2062 ++++++
 arch/arm/crypto/curve25519-glue.c         |   52 +
 arch/arm/crypto/poly1305-armv4.pl         | 1236 ++++
 arch/arm/crypto/poly1305-core.S_shipped   | 1158 +++
 arch/arm/crypto/poly1305-glue.c           |  273 +
 arch/arm64/Kconfig                        |    2 +-
 arch/arm64/crypto/Kconfig                 |    9 +-
 arch/arm64/crypto/Makefile                |   10 +-
 arch/arm64/crypto/chacha-neon-glue.c      |   99 +-
 arch/arm64/crypto/poly1305-armv8.pl       |  913 +++
 arch/arm64/crypto/poly1305-core.S_shipped |  835 +++
 arch/arm64/crypto/poly1305-glue.c         |  239 +
 arch/mips/Makefile                        |    2 +-
 arch/mips/crypto/Makefile                 |   18 +
 arch/mips/crypto/chacha-core.S            |  497 ++
 arch/mips/crypto/chacha-glue.c            |  162 +
 arch/mips/crypto/poly1305-glue.c          |  203 +
 arch/mips/crypto/poly1305-mips.pl         | 1246 ++++
 arch/riscv/Kconfig                        |    2 +-
 arch/x86/Kconfig                          |    2 +-
 arch/x86/crypto/Makefile                  |    3 +
 arch/x86/crypto/blake2s-core.S            |  685 ++
 arch/x86/crypto/blake2s-glue.c            |   85 +
 arch/x86/crypto/chacha_glue.c             |  167 +-
 arch/x86/crypto/curve25519-x86_64.c       | 2384 +++++++
 arch/x86/crypto/poly1305_glue.c           |  200 +-
 crypto/Kconfig                            |   87 +-
 crypto/adiantum.c                         |    5 +-
 crypto/chacha_generic.c                   |   80 +-
 crypto/ecc.c                              |    2 +-
 crypto/nhpoly1305.c                       |    3 +-
 crypto/poly1305_generic.c                 |  228 +-
 include/crypto/blake2s.h                  |   56 +
 include/crypto/chacha.h                   |   54 +-
 include/crypto/chacha20poly1305.h         |   48 +
 include/crypto/curve25519.h               |   69 +
 include/crypto/internal/chacha.h          |   31 +
 include/crypto/internal/poly1305.h        |   67 +
 include/crypto/poly1305.h                 |   43 +-
 init/Kconfig                              |    4 +
 lib/Makefile                              |    3 +-
 lib/crypto/Makefile                       |   40 +-
 lib/crypto/blake2s-selftest.c             | 2093 ++++++
 lib/crypto/blake2s.c                      |  281 +
 lib/{ => crypto}/chacha.c                 |   25 +-
 lib/crypto/chacha20poly1305-selftest.c    | 7393 ++++++++++++++++++++
 lib/crypto/chacha20poly1305.c             |  369 +
 lib/crypto/curve25519-fiat32.c            |  864 +++
 lib/crypto/curve25519-hacl64.c            |  788 +++
 lib/crypto/curve25519-selftest.c          | 1321 ++++
 lib/crypto/curve25519.c                   |   41 +
 lib/crypto/libchacha.c                    |   49 +
 lib/crypto/poly1305.c                     |  248 +
 lib/ubsan.c                               |    2 +-
 lib/ubsan.h                               |    2 +-
 60 files changed, 27185 insertions(+), 734 deletions(-)
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
 create mode 100644 include/crypto/blake2s.h
 create mode 100644 include/crypto/chacha20poly1305.h
 create mode 100644 include/crypto/curve25519.h
 create mode 100644 include/crypto/internal/chacha.h
 create mode 100644 include/crypto/internal/poly1305.h
 create mode 100644 lib/crypto/blake2s-selftest.c
 create mode 100644 lib/crypto/blake2s.c
 rename lib/{ => crypto}/chacha.c (84%)
 create mode 100644 lib/crypto/chacha20poly1305-selftest.c
 create mode 100644 lib/crypto/chacha20poly1305.c
 create mode 100644 lib/crypto/curve25519-fiat32.c
 create mode 100644 lib/crypto/curve25519-hacl64.c
 create mode 100644 lib/crypto/curve25519-selftest.c
 create mode 100644 lib/crypto/curve25519.c
 create mode 100644 lib/crypto/libchacha.c
 create mode 100644 lib/crypto/poly1305.c

-- 
2.20.1

