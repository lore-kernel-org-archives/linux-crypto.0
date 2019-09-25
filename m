Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FFDC4360C
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D71F321D81
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yL35Gubi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbfIYQNv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:13:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56146 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732807AbfIYQNv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:13:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so6366907wma.5
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ep/yuSVAFYEgAMQn7Kisz/KWJ9mfZfT3VNc1Z4+7S5k=;
        b=yL35GubiRvm7VFaewczEIvWMjzKcEJe9sy7IZqqjKdJonHFOANM6DR0tZ69NppJVNx
         QVUI5vrpRYyYFWmRIrA4WvJ5z9VgWTktuUMC0X5J8NL/IMk6X09XhE/9jn7hUQ0sxwPP
         e96BUxiU8I9rDK8zOEmjKgwqqG1WCqfPTm0pCBFwOwRJg9N0Ggp0UDQfSMXfM57CQW3Z
         81lDxBCoyRzR859OkO8ZFNmlpmb4nhx+1AbOAv0Qrf0rw95w5ZT/L/3Pr6hZOJWx1urB
         bgTMh+BXII0fOWOnjOkw83W+oiTOiA5ID+Yl+WRr8c7WtI38RVjZ/6SAouJo8C+gItRG
         V2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ep/yuSVAFYEgAMQn7Kisz/KWJ9mfZfT3VNc1Z4+7S5k=;
        b=c8cf2qT1VPjltfvB8gwq7ZbEB3HFPaQgDHXMvXsotjTe9uTYZA64PIfUQtd+td8/QD
         wBH8Tfcb5iLPdj6fncXCTDhrG7n7XW9lCHU4ork/zc7k0N4crNBPG+moxULiAdAFKfev
         8Ours6FwIBSsg4MVf6hkqVVfwybFnoNOfUtqPd3p5jxlQ21yGDVBuHYx3N73vojMmLBM
         o4NJnBtmL37OasVUJcWEzhc0N5GkZLuIeAThZy0TxTrknrSItmAP7lksZqvgJB88ZHOS
         itjTk0HMeUoLwSpiiZqyVWPi15fTvhYz4Xl7B1hIiJ9QrCMPSEMbt+xNGRRtaqZZSfX+
         lCyg==
X-Gm-Message-State: APjAAAVBEgbnwU0oY5euOhPRGZoONTNrRQT2C3h/EcCA1jjr2hxjCEAm
        mkBZMM42Iw7eWv5pWMl1U/pgaJz7hZMSKK0G
X-Google-Smtp-Source: APXvYqxIvbCkyRYCrwtNGwpQSjTiroTmsCbVNp3o6Q5ayy/B6opbSf2X7M+JU6MsURH6ejUOD8a07Q==
X-Received: by 2002:a1c:2d85:: with SMTP id t127mr9040688wmt.81.1569428026587;
        Wed, 25 Sep 2019 09:13:46 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:13:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
Date:   Wed, 25 Sep 2019 18:12:37 +0200
Message-Id: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series proposes a way to incorporate WireGuard into the kernel
without relying on a wholesale replacement of the existing crypto
stack. It addresses two issues with the existing crypto API, i.e.,
the need to do a kmalloc() allocation for each request, and the fact
that it can only operate on scatterlists, which limits the user to
data that is already accessible via an address in the linear map.

In the implementation of WireGuard, there are a number of dependencies
on cryptographic transformations:
- curve25519, blake2s, and [x]chach20poy1305 are all being used in the
  protocol handling, handshakes etc, mostly using inputs of a fixed, short
  length, mostly allocated on the stack
- chach20poy1305 is used for en/decrypting the actual packet data, using
  scatterlists to describe where the packet data is stored in memory.

The latter transformation is 99% compatible with the existing RFC7539
IPsec template in the crypto API, which means we already have the
plumbing to instantiate the correct transforms based on implementations
of ChaCha20 and Poly1305 that are provided per-architecture. Patch #18
shows the changes that need to be made to WireGuard to switch to the
crypto API for handling the packets. 

The remaining uses of [x]chacha20poly1305 operate on stack buffers, and
so switching to the crypto AEAD API is not as straight forward. However,
for these cases, as well as the uses of blake2s and curve25519, the fact
that they operate on small, fixed size buffers means that there is
really no point in providing alternative, SIMD based implementations of
these, and we can limit ourselves to generic C library version. 

Patches #1 .. #8 make some changes to the existing RFC7539 template and
the underlying ChaCha and Poly1305 drivers to reduce the number of times
that the template calls into the drivers, and to permit users of the
template to allocate the request structure on the stack instead of on
the heap, which removes the need for doing per-packet heap allocations
on the hot path.

Patches #9 and #10 refactor the existing Poly1305 code so we can easily
layer the Chacha20Poly1305 construction library on top in patch #14.

Patches #12 and #13 import the C implementations of blake2s and Curev25519
from the Zinc patch set, but moves them into lib/crypto, which is where
we keep generic crypto library C code. (Patch #11 is a preparatory patch for
patch #13.) The selftests are included as well.

Patch #14 incorporates the [x]chach20poly1305 library interface from Zinc,
but instead of providing numerous new implementation of Chacha20 and Poly1305,
it is built on top of the existing Chacha and Poly1305 library code that we
already have in the kernel. The original selftests that operate on 64-bit
nonces are included as well. (The ones using 96-bit nonces were dropped,
since the library interface [as it was defined originally] only supports
64-bit nonces in the first place)

Patch #15 is the original patch that adds WireGuard itself, and was taken
from the last series that Jason sent to the list ~6 months ago. It is
included verbatim to better illustrate the nature of the changes being
applied in the move to the crypto API.

Patch #16 is a followup fix for WireGuard that was taken from Jason's
repository, and is required to run WireGuard on recent kernels.

Patch #17 moves wireguard over to the crypto library headers in crypto/
rather than in zinc/

Patch #18 switches wireguard from the chach20poly1305 library API to
the crypto API. Note that RFC7539 defines a 96-bit nonce whereas WireGuard
only uses 64-bits, so some of the changes in this patch were needed just to
account for that.

Note that support for the rfc7539(chacha20,poly1305) algorithm has already
been implemented by at least two drivers for asynchronous accelerators, and
it seems relatively straight-forward to modify WireGuard further to support
asynchronous completions, and offload all the per-packet crypto to a separate
IP block. (People have argued in the past that accelerators are irrelevant
since CPUs perform better, but 'speed' is not the only performance metric
that people care about - 'battery life' is another one that comes to mind)

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

Ard Biesheuvel (15):
  crypto: shash - add plumbing for operating on scatterlists
  crypto: x86/poly1305 - implement .update_from_sg method
  crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON
    implementation
  crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON
    implementation
  crypto: chacha - move existing library code into lib/crypto
  crypto: rfc7539 - switch to shash for Poly1305
  crypto: rfc7539 - use zero reqsize for sync instantiations without
    alignmask
  crypto: testmgr - add a chacha20poly1305 test case
  crypto: poly1305 - move core algorithm into lib/crypto
  crypto: poly1305 - add init/update/final library routines
  int128: move __uint128_t compiler test to Kconfig
  crypto: chacha20poly1305 - import construction and selftest from Zinc
  netlink: use new strict length types in policy for 5.2
  wg switch to lib/crypto algos
  net: wireguard - switch to crypto API for packet encryption

Jason A. Donenfeld (3):
  crypto: BLAKE2s - generic C library implementation and selftest
  crypto: Curve25519 - generic C library implementations and selftest
  net: WireGuard secure network tunnel

 MAINTAINERS                                  |    8 +
 arch/arm/crypto/Kconfig                      |    3 +
 arch/arm/crypto/Makefile                     |    7 +-
 arch/arm/crypto/chacha-neon-glue.c           |    2 +-
 arch/arm/crypto/poly1305-armv4.pl            | 1236 ++++
 arch/arm/crypto/poly1305-core.S_shipped      | 1158 +++
 arch/arm/crypto/poly1305-glue.c              |  253 +
 arch/arm64/crypto/Kconfig                    |    4 +
 arch/arm64/crypto/Makefile                   |    9 +-
 arch/arm64/crypto/chacha-neon-glue.c         |    2 +-
 arch/arm64/crypto/poly1305-armv8.pl          |  913 +++
 arch/arm64/crypto/poly1305-core.S_shipped    |  835 +++
 arch/arm64/crypto/poly1305-glue.c            |  215 +
 arch/x86/crypto/chacha_glue.c                |    2 +-
 arch/x86/crypto/poly1305_glue.c              |   56 +-
 crypto/Kconfig                               |   14 +
 crypto/adiantum.c                            |    5 +-
 crypto/ahash.c                               |   18 +
 crypto/chacha20poly1305.c                    |  540 +-
 crypto/chacha_generic.c                      |   42 +-
 crypto/ecc.c                                 |    2 +-
 crypto/nhpoly1305.c                          |    3 +-
 crypto/poly1305_generic.c                    |  218 +-
 crypto/shash.c                               |   24 +
 crypto/testmgr.h                             |   45 +
 drivers/net/Kconfig                          |   30 +
 drivers/net/Makefile                         |    1 +
 drivers/net/wireguard/Makefile               |   18 +
 drivers/net/wireguard/allowedips.c           |  377 +
 drivers/net/wireguard/allowedips.h           |   59 +
 drivers/net/wireguard/cookie.c               |  236 +
 drivers/net/wireguard/cookie.h               |   59 +
 drivers/net/wireguard/device.c               |  460 ++
 drivers/net/wireguard/device.h               |   65 +
 drivers/net/wireguard/main.c                 |   64 +
 drivers/net/wireguard/messages.h             |  128 +
 drivers/net/wireguard/netlink.c              |  621 ++
 drivers/net/wireguard/netlink.h              |   12 +
 drivers/net/wireguard/noise.c                |  837 +++
 drivers/net/wireguard/noise.h                |  132 +
 drivers/net/wireguard/peer.c                 |  239 +
 drivers/net/wireguard/peer.h                 |   83 +
 drivers/net/wireguard/peerlookup.c           |  221 +
 drivers/net/wireguard/peerlookup.h           |   64 +
 drivers/net/wireguard/queueing.c             |   53 +
 drivers/net/wireguard/queueing.h             |  199 +
 drivers/net/wireguard/ratelimiter.c          |  223 +
 drivers/net/wireguard/ratelimiter.h          |   19 +
 drivers/net/wireguard/receive.c              |  617 ++
 drivers/net/wireguard/selftest/allowedips.c  |  682 ++
 drivers/net/wireguard/selftest/counter.c     |  104 +
 drivers/net/wireguard/selftest/ratelimiter.c |  226 +
 drivers/net/wireguard/send.c                 |  442 ++
 drivers/net/wireguard/socket.c               |  433 ++
 drivers/net/wireguard/socket.h               |   44 +
 drivers/net/wireguard/timers.c               |  241 +
 drivers/net/wireguard/timers.h               |   31 +
 drivers/net/wireguard/version.h              |    1 +
 include/crypto/blake2s.h                     |   56 +
 include/crypto/chacha.h                      |   37 +-
 include/crypto/chacha20poly1305.h            |   37 +
 include/crypto/curve25519.h                  |   28 +
 include/crypto/hash.h                        |    3 +
 include/crypto/internal/chacha.h             |   25 +
 include/crypto/internal/hash.h               |   19 +
 include/crypto/internal/poly1305.h           |   33 +
 include/crypto/poly1305.h                    |   34 +-
 include/uapi/linux/wireguard.h               |  190 +
 init/Kconfig                                 |    1 +
 lib/Makefile                                 |    3 +-
 lib/crypto/Makefile                          |   39 +-
 lib/crypto/blake2s-selftest.c                | 2093 ++++++
 lib/crypto/blake2s.c                         |  274 +
 lib/{ => crypto}/chacha.c                    |   23 +
 lib/crypto/chacha20poly1305-selftest.c       | 7349 ++++++++++++++++++++
 lib/crypto/chacha20poly1305.c                |  216 +
 lib/crypto/curve25519-fiat32.c               |  864 +++
 lib/crypto/curve25519-hacl64.c               |  788 +++
 lib/crypto/curve25519-selftest.c             | 1321 ++++
 lib/crypto/curve25519.c                      |   73 +
 lib/crypto/poly1305.c                        |  216 +
 lib/ubsan.c                                  |    2 +-
 lib/ubsan.h                                  |    2 +-
 tools/testing/selftests/wireguard/netns.sh   |  503 ++
 84 files changed, 26192 insertions(+), 672 deletions(-)
 create mode 100644 arch/arm/crypto/poly1305-armv4.pl
 create mode 100644 arch/arm/crypto/poly1305-core.S_shipped
 create mode 100644 arch/arm/crypto/poly1305-glue.c
 create mode 100644 arch/arm64/crypto/poly1305-armv8.pl
 create mode 100644 arch/arm64/crypto/poly1305-core.S_shipped
 create mode 100644 arch/arm64/crypto/poly1305-glue.c
 create mode 100644 drivers/net/wireguard/Makefile
 create mode 100644 drivers/net/wireguard/allowedips.c
 create mode 100644 drivers/net/wireguard/allowedips.h
 create mode 100644 drivers/net/wireguard/cookie.c
 create mode 100644 drivers/net/wireguard/cookie.h
 create mode 100644 drivers/net/wireguard/device.c
 create mode 100644 drivers/net/wireguard/device.h
 create mode 100644 drivers/net/wireguard/main.c
 create mode 100644 drivers/net/wireguard/messages.h
 create mode 100644 drivers/net/wireguard/netlink.c
 create mode 100644 drivers/net/wireguard/netlink.h
 create mode 100644 drivers/net/wireguard/noise.c
 create mode 100644 drivers/net/wireguard/noise.h
 create mode 100644 drivers/net/wireguard/peer.c
 create mode 100644 drivers/net/wireguard/peer.h
 create mode 100644 drivers/net/wireguard/peerlookup.c
 create mode 100644 drivers/net/wireguard/peerlookup.h
 create mode 100644 drivers/net/wireguard/queueing.c
 create mode 100644 drivers/net/wireguard/queueing.h
 create mode 100644 drivers/net/wireguard/ratelimiter.c
 create mode 100644 drivers/net/wireguard/ratelimiter.h
 create mode 100644 drivers/net/wireguard/receive.c
 create mode 100644 drivers/net/wireguard/selftest/allowedips.c
 create mode 100644 drivers/net/wireguard/selftest/counter.c
 create mode 100644 drivers/net/wireguard/selftest/ratelimiter.c
 create mode 100644 drivers/net/wireguard/send.c
 create mode 100644 drivers/net/wireguard/socket.c
 create mode 100644 drivers/net/wireguard/socket.h
 create mode 100644 drivers/net/wireguard/timers.c
 create mode 100644 drivers/net/wireguard/timers.h
 create mode 100644 drivers/net/wireguard/version.h
 create mode 100644 include/crypto/blake2s.h
 create mode 100644 include/crypto/chacha20poly1305.h
 create mode 100644 include/crypto/curve25519.h
 create mode 100644 include/crypto/internal/chacha.h
 create mode 100644 include/crypto/internal/poly1305.h
 create mode 100644 include/uapi/linux/wireguard.h
 create mode 100644 lib/crypto/blake2s-selftest.c
 create mode 100644 lib/crypto/blake2s.c
 rename lib/{ => crypto}/chacha.c (85%)
 create mode 100644 lib/crypto/chacha20poly1305-selftest.c
 create mode 100644 lib/crypto/chacha20poly1305.c
 create mode 100644 lib/crypto/curve25519-fiat32.c
 create mode 100644 lib/crypto/curve25519-hacl64.c
 create mode 100644 lib/crypto/curve25519-selftest.c
 create mode 100644 lib/crypto/curve25519.c
 create mode 100644 lib/crypto/poly1305.c
 create mode 100755 tools/testing/selftests/wireguard/netns.sh

-- 
2.20.1

