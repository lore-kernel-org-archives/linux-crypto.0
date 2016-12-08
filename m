From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto: arm64/ARM: NEON accelerated ChaCha20
Date: Thu,  8 Dec 2016 14:28:57 +0000
Message-ID: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37901 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbcLHO3L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 09:29:11 -0500
Received: by mail-wm0-f52.google.com with SMTP id f82so28144042wmf.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Dec 2016 06:29:10 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Another port of existing x86 SSE code to NEON, again both for arm64 and ARM.

ChaCha20 is a stream cipher described in RFC 7539, and is intended to be
an efficient software implementable 'standby cipher', in case AES cannot
be used.

This NEON implementation is almost 2x as fast as the generic C code
(measured on Cortex-A57 using the arm64 version)

I'm aware that blkciphers are deprecated in favor of skciphers, but this
code (like the x86 version) uses the init and setkey routines of the generic
version, so it is probably better to port all implementations at once.

Ard Biesheuvel (2):
  crypto: arm64/chacha20 - implement NEON version based on SSE3 code
  crypto: arm/chacha20 - implement NEON version based on SSE3 code

 arch/arm/crypto/Kconfig                |   6 +
 arch/arm/crypto/Makefile               |   2 +
 arch/arm/crypto/chacha20-neon-core.S   | 524 ++++++++++++++++++++
 arch/arm/crypto/chacha20-neon-glue.c   | 136 +++++
 arch/arm64/crypto/Kconfig              |   6 +
 arch/arm64/crypto/Makefile             |   3 +
 arch/arm64/crypto/chacha20-neon-core.S | 480 ++++++++++++++++++
 arch/arm64/crypto/chacha20-neon-glue.c | 131 +++++
 8 files changed, 1288 insertions(+)
 create mode 100644 arch/arm/crypto/chacha20-neon-core.S
 create mode 100644 arch/arm/crypto/chacha20-neon-glue.c
 create mode 100644 arch/arm64/crypto/chacha20-neon-core.S
 create mode 100644 arch/arm64/crypto/chacha20-neon-glue.c

-- 
2.7.4
