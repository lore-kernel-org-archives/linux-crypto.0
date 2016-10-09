From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/6] crypto: arm64 - big endian fixes
Date: Sun,  9 Oct 2016 18:42:19 +0100
Message-ID: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34571 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbcJIRmh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 13:42:37 -0400
Received: by mail-lf0-f42.google.com with SMTP id b81so84305914lfe.1
        for <linux-crypto@vger.kernel.org>; Sun, 09 Oct 2016 10:42:36 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As it turns out, none of the accelerated crypto routines under arch/arm64/crypto
currently work, or have ever worked correctly when built for big endian. So this
series fixes all of them.

Each of these patches carries a fixes tag, and could be backported to stable.
However, for patches #1 and #5, the fixes tag denotes the oldest commit that the
fix is compatible with, not the patch that introduced the algorithm. This is due
to the fact that the key schedules are incompatible between generic AES and the
arm64 Crypto Extensions implementation (but only when building for big endian)
This is not a problem in practice, but it does mean that the AES-CCM and AES in
EBC/CBC/CTR/XTS mode implementations before v3.19 require a different fix, i.e.,
one that is compatible with the generic AES key schedule generation code (which
it currently no longer uses)

In any case, please apply with cc to stable.

Ard Biesheuvel (6):
  crypto: arm64/aes-ce - fix for big endian
  crypto: arm64/ghash-ce - fix for big endian
  crypto: arm64/sha1-ce - fix for big endian
  crypto: arm64/sha2-ce - fix for big endian
  crypto: arm64/aes-ccm-ce: fix for big endian
  crypto: arm64/aes-neon - fix for big endian

 arch/arm64/crypto/aes-ce-ccm-core.S | 53 ++++++++++----------
 arch/arm64/crypto/aes-ce-cipher.c   | 25 +++++----
 arch/arm64/crypto/aes-neon.S        | 25 +++++----
 arch/arm64/crypto/ghash-ce-core.S   |  6 +--
 arch/arm64/crypto/sha1-ce-core.S    |  4 +-
 arch/arm64/crypto/sha2-ce-core.S    |  4 +-
 6 files changed, 64 insertions(+), 53 deletions(-)

-- 
2.7.4
