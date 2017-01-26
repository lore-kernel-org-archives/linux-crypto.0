From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/4] crypto: time invariant AES for CCM (and GCM/CTR)
Date: Thu, 26 Jan 2017 17:17:39 +0000
Message-ID: <1485451063-11822-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37320 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbdAZRR6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 12:17:58 -0500
Received: by mail-wm0-f53.google.com with SMTP id c206so95635893wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jan 2017 09:17:57 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series is primarily directed at improving the performance and security
of CCM on the Rasperry Pi 3. This involves splitting the MAC handling of
CCM into a separate driver so that we can efficiently replace it by something
else using the ordinary algo resolution machinery.

Patch #1 adds some testcases for cbcmac(aes), which will be introduced later.

Patch #2 replaces the open coded CBC MAC hashing routines in the CCM driver
with calls to a cbcmac() hash, and implements a template for producing such
transforms. This eliminates all the fuzzy scatterwalk code as well.

Patch #3 implements cbcmac(aes) using NEON on arm64

Patch #4 is an RFC patch that implements ctr(aes) and cbcmac(aes) in a way
that is intended to eliminate observeable data dependent latencies in AES
processing, by replacing the usual 16 KB of lookup tables with a single
Sbox that is prefetched before processing each block. It is 50% slower than
generic AES, but this may be acceptable in many cases.

Ard Biesheuvel (4):
  crypto: testmgr - add test cases for cbcmac(aes)
  crypto: ccm - switch to separate cbcmac driver
  crypto: arm64/aes - add NEON and Crypto Extension CBC-MAC driver
  crypto: aes - add generic time invariant AES for CTR/CCM/GCM

 arch/arm64/crypto/aes-glue.c  | 102 ++++++
 arch/arm64/crypto/aes-modes.S |  19 +
 crypto/Kconfig                |  15 +
 crypto/Makefile               |   1 +
 crypto/aes_ti.c               | 314 ++++++++++++++++
 crypto/ccm.c                  | 373 +++++++++++++-------
 crypto/testmgr.c              |   7 +
 crypto/testmgr.h              |  58 +++
 8 files changed, 753 insertions(+), 136 deletions(-)
 create mode 100644 crypto/aes_ti.c

-- 
2.7.4
