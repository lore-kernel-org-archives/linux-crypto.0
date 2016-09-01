From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/3] crypto: arm and cryptd fixes
Date: Thu,  1 Sep 2016 14:25:40 +0100
Message-ID: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37895 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754807AbcIAN1Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 09:27:16 -0400
Received: by mail-wm0-f51.google.com with SMTP id 1so94994798wmz.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2016 06:27:15 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch #1 fixes a trivial code generation issue on ARM.

Patch #2 and #3 fix the broken GHASH on ARM using the v8 Crypto Extensions
pmull.64 instructions. The problem seems to be that it is allowed to call
.import() without .init() (at least, that is what the test cases do), but
this means that the initialization to tie the shash_desc's to their child
transforms needs to execute in the .import() context as well.

Perhaps Herbert could shed some light on this? Thanks.

In any case, these patches are both necessary (and sufficient) to get GHASH
on ARM working again, including the boot time selftests


Ard Biesheuvel (3):
  crypto: arm/sha1-neon - add support for building in Thumb2 mode
  crypto: arm/ghash-ce - add missing async import/export
  crypto: cryptd - initialize child shash_desc on import

 arch/arm/crypto/ghash-ce-glue.c   | 24 ++++++++++++++++++++
 arch/arm/crypto/sha1-armv7-neon.S |  1 -
 crypto/cryptd.c                   |  9 ++++++--
 3 files changed, 31 insertions(+), 3 deletions(-)

-- 
2.7.4
