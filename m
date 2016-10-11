From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/8] crypto: ARM/arm64 - big endian fixes
Date: Tue, 11 Oct 2016 19:15:12 +0100
Message-ID: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        linux@arm.linux.org.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37023 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbcJKSQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Oct 2016 14:16:09 -0400
Received: by mail-wm0-f46.google.com with SMTP id b201so850000wmb.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2016 11:15:30 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As it turns out, none of the accelerated crypto routines under arch/arm64/crypto
currently work, or have ever worked correctly when built for big endian. So this
series fixes all of them. This v2 now includes a similar fix for 32-bit ARM as
well, and an additional fix for XTS which escaped my attention before.

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

Ard Biesheuvel (8):
  crypto: arm64/aes-ce - fix for big endian
  crypto: arm64/ghash-ce - fix for big endian
  crypto: arm64/sha1-ce - fix for big endian
  crypto: arm64/sha2-ce - fix for big endian
  crypto: arm64/aes-ccm-ce: fix for big endian
  crypto: arm64/aes-neon - fix for big endian
  crypto: arm64/aes-xts-ce: fix for big endian
  crypto: arm/aes-ce - fix for big endian

 arch/arm/crypto/aes-ce-glue.c       |  5 ++
 arch/arm64/crypto/aes-ce-ccm-core.S | 53 ++++++++++----------
 arch/arm64/crypto/aes-ce-cipher.c   | 25 +++++----
 arch/arm64/crypto/aes-ce.S          |  1 +
 arch/arm64/crypto/aes-modes.S       |  3 +-
 arch/arm64/crypto/aes-neon.S        | 25 +++++----
 arch/arm64/crypto/ghash-ce-core.S   |  6 +--
 arch/arm64/crypto/sha1-ce-core.S    |  4 +-
 arch/arm64/crypto/sha2-ce-core.S    |  4 +-
 9 files changed, 72 insertions(+), 54 deletions(-)

-- 
2.7.4
