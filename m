From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/7] arm64/crypto: crc32: move literal data to .rodata section
Date: Wed, 10 Jan 2018 12:11:39 +0000
Message-ID: <20180110121142.18291-5-ard.biesheuvel@linaro.org>
References: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, dann.frazier@canonical.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:46136 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964968AbeAJMNl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 07:13:41 -0500
Received: by mail-wm0-f68.google.com with SMTP id 143so1570643wma.5
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2018 04:13:41 -0800 (PST)
In-Reply-To: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move CRC32 literal data to the .rodata section where it is safe from
being exploited by speculative execution.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crc32-ce-core.S | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/crc32-ce-core.S b/arch/arm64/crypto/crc32-ce-core.S
index 18f5a8442276..16ed3c7ebd37 100644
--- a/arch/arm64/crypto/crc32-ce-core.S
+++ b/arch/arm64/crypto/crc32-ce-core.S
@@ -50,7 +50,7 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.text
+	.section	".rodata", "a"
 	.align		6
 	.cpu		generic+crypto+crc
 
@@ -115,12 +115,13 @@
 	 * uint crc32_pmull_le(unsigned char const *buffer,
 	 *                     size_t len, uint crc32)
 	 */
+	.text
 ENTRY(crc32_pmull_le)
-	adr		x3, .Lcrc32_constants
+	adr_l		x3, .Lcrc32_constants
 	b		0f
 
 ENTRY(crc32c_pmull_le)
-	adr		x3, .Lcrc32c_constants
+	adr_l		x3, .Lcrc32c_constants
 
 0:	bic		LEN, LEN, #15
 	ld1		{v1.16b-v4.16b}, [BUF], #0x40
-- 
2.11.0
