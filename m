From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 0/3] crypto: time invariant AES for CCM (and CMAC/XCBC)
Date: Fri,  3 Feb 2017 14:49:34 +0000
Message-ID: <1486133377-23290-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers3@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37986 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdBCOtq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 09:49:46 -0500
Received: by mail-wm0-f44.google.com with SMTP id r141so30862133wmg.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 Feb 2017 06:49:46 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series is primarily directed at improving the performance and security
of CCM on the Rasperry Pi 3. This involves splitting the MAC handling of
CCM into a separate driver so that we can efficiently replace it by something
else using the ordinary algo resolution machinery.

Patch #1 adds some testcases for cbcmac(aes), which will be introduced later.

Patch #2 replaces the open coded CBC MAC hashing routines in the CCM driver
with calls to a cbcmac() hash, and implements a template for producing such
cbcmac transforms. This eliminates all the fuzzy scatterwalk code as well.

Patch #3 implements cbcmac(aes) using NEON on arm64, and CMAC/XCBC at the
same time, since it is trivially implemented reusing the same core transform

Changes since v2:
- dropped fixed time generic AES patch, this is only vaguely related, and can
  be discussed separately
- add CMAC and XCBC code to patch #3
- fix stack corruption bug in patch #2
- move patch #2 to use crypto_xor() for the cbcmac transform (which either needs
  an alignmask, or the updated alignment agnostic crypto_xor() code whose v2
  was sent out yesterday)

Changes since v1:
- remove ilen, and add missing flags assignment (#2)
- deal with zero cryptlen (#2)
- use correctly sized dg[] array in desc ctx (#3, #4)
- fix bug in update routine (#3)
- various other tweaks

Ard Biesheuvel (3):
  crypto: testmgr - add test cases for cbcmac(aes)
  crypto: ccm - switch to separate cbcmac driver
  crypto: arm64/aes - add NEON/Crypto Extensions CBCMAC/CMAC/XCBC driver

 arch/arm64/crypto/aes-glue.c  | 240 +++++++++++-
 arch/arm64/crypto/aes-modes.S |  29 +-
 crypto/Kconfig                |   1 +
 crypto/ccm.c                  | 381 +++++++++++++-------
 crypto/testmgr.c              |   7 +
 crypto/testmgr.h              |  60 +++
 6 files changed, 579 insertions(+), 139 deletions(-)

-- 
2.7.4
