Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429DDC352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1CF9222BE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="flG6udTV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfJBORl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52793 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfJBORl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id r19so7410561wmh.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JmyXVAPapm4ETcc609z5ERzmHRrWtAYsnBCWRJ7D4Wk=;
        b=flG6udTVE8I7KduEdhkztfVv6UMQn2hhfPDPjeejrhUqMnXGOxPGjxnwT5/Gi7JwqI
         0Yv8VZhDQGGUIXOB5pYzNh0MHT06FWYLmp9Zx3Cv2xT3WpkkyRD0iCl7Jja7e6GRlIaT
         sBy8Ey6AW0dQEBQ9dwDm+WoxDNk43PCvaa0s2BVpLaolBMptNjmE4ccNUNJCsTwY7pTJ
         dmRnSW+lqcJ7q/V/ujPH5J2QmzFyRrlimeS244bf5IaaPkHgiskqbhiVHWkX4NlLqhRQ
         l1kD3cicsp4Nu/1eGcDbWyO/ATSgrV6wPWYwa157e7CZE8m1pAsO9md5r8MCl+J8Wppn
         lzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JmyXVAPapm4ETcc609z5ERzmHRrWtAYsnBCWRJ7D4Wk=;
        b=aQr+2xpoc7p9t97Vxd/DlSfHNDvcbQhPO3nWAjrN45EBM1/ZtqzdBpc4a0DwqWN9s4
         9X24YUL5WeBZytoxCztocdOJfBWAzyPlrydVi7vFj2vX/s98cH0tzPWXKZqITSsTEd7Z
         bfHCX6kJ5oypjSCfNFfp6fJ/fobT6FM7KeYvF8uJ0H+NQyL6cBDLnBPv5sRT17VANdWD
         rQNSF7Na+wcheW+MSoagPcWu3qZO7Z5cHIMcuoEBKsGteEXEPPDAk4eKs+9DP7bP71AR
         mnMFOthPd+F9ZRhPUWtYj+xCcmsmZzZyxuEIhz6mWKaUTewYnj7J4DiPDawrWXLs4rkh
         7kRA==
X-Gm-Message-State: APjAAAWHRC+jKebudVENvwLhkWVRgh8RB/iHfouIgwkjgy0aAuHpsMjE
        umUFuj0riLo4mFKU3PrllDY0bCcXPr34oMJH
X-Google-Smtp-Source: APXvYqyWCKCIhGq7WpP1sHKn5J7AgnhoqEHT7kPDh5vSmRiA4Trov9Ybl9KYXDRycOoV9gE21yBzEg==
X-Received: by 2002:a1c:a7d2:: with SMTP id q201mr3005677wme.146.1570025858312;
        Wed, 02 Oct 2019 07:17:38 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
Date:   Wed,  2 Oct 2019 16:16:53 +0200
Message-Id: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a followup to RFC 'crypto: wireguard with crypto API library interface'
[0]. Since no objections were raised to my approach, I've proceeded to fix up
some minor issues, and incorporate [most of] the missing MIPS code.

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

In the future, I would like to extend these interfaces to use static calls,
so that the accelerated implementations can be [un]plugged at runtime. For
the time being, we rely on weak aliases and conditional exports so that the
users of the library interfaces link directly to the accelerated versions,
but without the ability to unplug them.

Patches can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=wireguard-crypto-library-api-v2

Cc: Herbert Xu <herbert@gondor.apana.org.au> 
Cc: David Miller <davem@davemloft.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Martin Willi <martin@strongswan.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>

[0] https://lore.kernel.org/linux-crypto/20190929173850.26055-1-ard.biesheuvel@linaro.org/

Ard Biesheuvel (14):
  crypto: chacha - move existing library code into lib/crypto
  crypto: x86/chacha - expose SIMD ChaCha routine as library function
  crypto: arm64/chacha - expose arm64 ChaCha routine as library function
  crypto: arm/chacha - expose ARM ChaCha routine as library function
  crypto: mips/chacha - import accelerated 32r2 code from Zinc
  crypto: poly1305 - move into lib/crypto and refactor into library
  crypto: x86/poly1305 - expose existing driver as poly1305 library
  crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON
    implementation
  crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON
    implementation
  crypto: mips/poly1305 - import accelerated 32r2 code from Zinc
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

 arch/arm/crypto/Kconfig                   |   11 +
 arch/arm/crypto/Makefile                  |   13 +-
 arch/arm/crypto/chacha-neon-glue.c        |   42 +-
 arch/arm/crypto/curve25519-core.S         | 2062 ++++++
 arch/arm/crypto/curve25519-glue.c         |   45 +
 arch/arm/crypto/poly1305-armv4.pl         | 1236 ++++
 arch/arm/crypto/poly1305-core.S_shipped   | 1158 +++
 arch/arm/crypto/poly1305-glue.c           |  274 +
 arch/arm64/Kconfig                        |    2 +-
 arch/arm64/crypto/Kconfig                 |    6 +
 arch/arm64/crypto/Makefile                |   10 +-
 arch/arm64/crypto/chacha-neon-glue.c      |   32 +-
 arch/arm64/crypto/poly1305-armv8.pl       |  913 +++
 arch/arm64/crypto/poly1305-core.S_shipped |  835 +++
 arch/arm64/crypto/poly1305-glue.c         |  229 +
 arch/mips/Makefile                        |    2 +-
 arch/mips/crypto/Makefile                 |    6 +
 arch/mips/crypto/chacha-core.S            |  424 ++
 arch/mips/crypto/chacha-glue.c            |  161 +
 arch/mips/crypto/poly1305-core.S          |  407 ++
 arch/mips/crypto/poly1305-glue.c          |  203 +
 arch/riscv/Kconfig                        |    2 +-
 arch/x86/Kconfig                          |    2 +-
 arch/x86/crypto/Makefile                  |    3 +
 arch/x86/crypto/blake2s-core.S            |  685 ++
 arch/x86/crypto/blake2s-glue.c            |   76 +
 arch/x86/crypto/chacha_glue.c             |   38 +-
 arch/x86/crypto/curve25519-x86_64.c       | 2381 +++++++
 arch/x86/crypto/poly1305_glue.c           |  145 +-
 crypto/Kconfig                            |   70 +
 crypto/adiantum.c                         |    5 +-
 crypto/chacha_generic.c                   |   44 +-
 crypto/ecc.c                              |    2 +-
 crypto/nhpoly1305.c                       |    3 +-
 crypto/poly1305_generic.c                 |  196 +-
 include/crypto/blake2s.h                  |   56 +
 include/crypto/chacha.h                   |   36 +-
 include/crypto/chacha20poly1305.h         |   48 +
 include/crypto/curve25519.h               |   28 +
 include/crypto/internal/chacha.h          |   25 +
 include/crypto/internal/poly1305.h        |   45 +
 include/crypto/poly1305.h                 |   43 +-
 init/Kconfig                              |    4 +
 lib/Makefile                              |    3 +-
 lib/crypto/Makefile                       |   40 +-
 lib/crypto/blake2s-selftest.c             | 2093 ++++++
 lib/crypto/blake2s.c                      |  281 +
 lib/{ => crypto}/chacha.c                 |   25 +-
 lib/crypto/chacha20poly1305-selftest.c    | 7394 ++++++++++++++++++++
 lib/crypto/chacha20poly1305.c             |  369 +
 lib/crypto/curve25519-fiat32.c            |  864 +++
 lib/crypto/curve25519-hacl64.c            |  788 +++
 lib/crypto/curve25519-selftest.c          | 1321 ++++
 lib/crypto/curve25519.c                   |   86 +
 lib/crypto/libchacha.c                    |   67 +
 lib/crypto/poly1305.c                     |  248 +
 lib/ubsan.c                               |    2 +-
 lib/ubsan.h                               |    2 +-
 58 files changed, 25213 insertions(+), 378 deletions(-)
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
 create mode 100644 arch/mips/crypto/poly1305-core.S
 create mode 100644 arch/mips/crypto/poly1305-glue.c
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

