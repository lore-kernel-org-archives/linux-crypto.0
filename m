From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm/crc32 - fix build error with outdated binutils
Date: Tue, 28 Feb 2017 14:36:56 +0000
Message-ID: <1488292617-27317-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, jonathanh@nvidia.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        arnd@arndb.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:36225 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdB1OhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2017 09:37:06 -0500
Received: by mail-wr0-f177.google.com with SMTP id u108so10177231wrb.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Feb 2017 06:37:05 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Annotate a vmov instruction with an explicit element size of 32 bits.
This is inferred by recent toolchains, but apparently, older versions
need some help figuring this out.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/crc32-ce-core.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/crc32-ce-core.S b/arch/arm/crypto/crc32-ce-core.S
index e63d400dc5c1..5cbd4a6fedad 100644
--- a/arch/arm/crypto/crc32-ce-core.S
+++ b/arch/arm/crypto/crc32-ce-core.S
@@ -135,7 +135,7 @@ ENTRY(crc32c_pmull_le)
 	vld1.8		{q3-q4}, [BUF, :128]!
 	vmov.i8		qzr, #0
 	vmov.i8		qCONSTANT, #0
-	vmov		dCONSTANTl[0], CRC
+	vmov.32		dCONSTANTl[0], CRC
 	veor.8		d2, d2, dCONSTANTl
 	sub		LEN, LEN, #0x40
 	cmp		LEN, #0x40
-- 
2.7.4
