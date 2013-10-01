From: oliver@neukum.org
Subject: [PATCH] sha256_ssse3: also test for BMI2
Date: Tue,  1 Oct 2013 14:34:46 +0200
Message-ID: <1380630886-6863-1-git-send-email-oliver@neukum.org>
Cc: Oliver Neukum <oneukum@suse.de>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:53543 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3JAMew (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Oct 2013 08:34:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Oliver Neukum <oneukum@suse.de>

The AVX2 implementation also uses BMI2 instructions,
but doesn't test for their availability. The assumption
that AVX2 and BMI2 always go together is false. Some
Haswells have AVX2 but not BMI2.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 50226c4..e52947f 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -281,7 +281,7 @@ static int __init sha256_ssse3_mod_init(void)
 	/* allow AVX to override SSSE3, it's a little faster */
 	if (avx_usable()) {
 #ifdef CONFIG_AS_AVX2
-		if (boot_cpu_has(X86_FEATURE_AVX2))
+		if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_BMI2))
 			sha256_transform_asm = sha256_transform_rorx;
 		else
 #endif
-- 
1.8.3.1
