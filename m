From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 6/7] arm64/crypto: sha2-ce: move the round constant table to .rodata section
Date: Wed, 10 Jan 2018 12:11:41 +0000
Message-ID: <20180110121142.18291-7-ard.biesheuvel@linaro.org>
References: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, dann.frazier@canonical.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:45848 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964968AbeAJMNq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 07:13:46 -0500
Received: by mail-wm0-f68.google.com with SMTP id i186so10102158wmi.4
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2018 04:13:45 -0800 (PST)
In-Reply-To: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the SHA2 round constant table to the .rodata section where it is
safe from being exploited by speculative execution.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha2-ce-core.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 679c6c002f4f..4c3c89b812ce 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -53,6 +53,7 @@
 	/*
 	 * The SHA-256 round constants
 	 */
+	.section	".rodata", "a"
 	.align		4
 .Lsha2_rcon:
 	.word		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5
@@ -76,9 +77,10 @@
 	 * void sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
 	 *			  int blocks)
 	 */
+	.text
 ENTRY(sha2_ce_transform)
 	/* load round constants */
-	adr		x8, .Lsha2_rcon
+	adr_l		x8, .Lsha2_rcon
 	ld1		{ v0.4s- v3.4s}, [x8], #64
 	ld1		{ v4.4s- v7.4s}, [x8], #64
 	ld1		{ v8.4s-v11.4s}, [x8], #64
-- 
2.11.0
