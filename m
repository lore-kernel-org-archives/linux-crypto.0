From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/5] crypto: arm - enable module autoloading
Date: Sun, 21 May 2017 10:23:35 +0000
Message-ID: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35292 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752645AbdEUKXs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 06:23:48 -0400
Received: by mail-wm0-f47.google.com with SMTP id b84so267509320wmh.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 03:23:47 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that the prerequisite changes are in place, we can modify the
various accelerated crypto modules that use special instructions to
expose the CPU feature they depend on. This allows udev to autoload
the module at boot.

Ard Biesheuvel (5):
  crypto: arm/aes-ce - enable module autoloading based on CPU feature
    bits
  crypto: arm/ghash-ce - enable module autoloading based on CPU feature
    bits
  crypto: arm/sha1-ce - enable module autoloading based on CPU feature
    bits
  crypto: arm/sha2-ce - enable module autoloading based on CPU feature
    bits
  crypto: arm/crc32 - enable module autoloading based on CPU feature
    bits

 arch/arm/crypto/aes-ce-glue.c   | 6 ++----
 arch/arm/crypto/crc32-ce-glue.c | 6 ++++++
 arch/arm/crypto/ghash-ce-glue.c | 6 ++----
 arch/arm/crypto/sha1-ce-glue.c  | 5 ++---
 arch/arm/crypto/sha2-ce-glue.c  | 5 ++---
 5 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.7.4
