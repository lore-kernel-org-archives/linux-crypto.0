From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/3] crypto: x86/sha1 - re-enable the AVX variant
Date: Mon, 24 Mar 2014 17:10:37 +0100
Message-ID: <1395677439-7478-2-git-send-email-minipli@googlemail.com>
References: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54095 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaCXQKt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 12:10:49 -0400
Received: by mail-bk0-f54.google.com with SMTP id 6so580431bkj.13
        for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2014 09:10:48 -0700 (PDT)
In-Reply-To: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 7c1da8d0d0 "crypto: sha - SHA1 transform x86_64 AVX2"
accidentally disabled the AVX variant by making the avx_usable() test
not only fail in case the CPU doesn't support AVX or OSXSAVE but also
if it doesn't support AVX2.

Fix that regression by splitting up the AVX/AVX2 test into two
functions. Also test for the BMI1 extension in the avx2_usable() test
as the AVX2 implementation not only makes use of BMI2 but also BMI1
instructions.

Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/sha1_ssse3_glue.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 139a55c04d..74d16ef707 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -208,11 +208,7 @@ static bool __init avx_usable(void)
 {
 	u64 xcr0;
 
-#if defined(CONFIG_AS_AVX2)
-	if (!cpu_has_avx || !cpu_has_avx2 || !cpu_has_osxsave)
-#else
 	if (!cpu_has_avx || !cpu_has_osxsave)
-#endif
 		return false;
 
 	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
@@ -224,11 +220,23 @@ static bool __init avx_usable(void)
 
 	return true;
 }
+
+#ifdef CONFIG_AS_AVX2
+static bool __init avx2_usable(void)
+{
+	if (avx_usable() && cpu_has_avx2 && boot_cpu_has(X86_FEATURE_BMI1) &&
+	    boot_cpu_has(X86_FEATURE_BMI2))
+		return true;
+
+	return false;
+}
+#endif
 #endif
 
 static int __init sha1_ssse3_mod_init(void)
 {
 	char *algo_name;
+
 	/* test for SSSE3 first */
 	if (cpu_has_ssse3) {
 		sha1_transform_asm = sha1_transform_ssse3;
@@ -238,13 +246,11 @@ static int __init sha1_ssse3_mod_init(void)
 #ifdef CONFIG_AS_AVX
 	/* allow AVX to override SSSE3, it's a little faster */
 	if (avx_usable()) {
-		if (cpu_has_avx) {
-			sha1_transform_asm = sha1_transform_avx;
-			algo_name = "AVX";
-		}
+		sha1_transform_asm = sha1_transform_avx;
+		algo_name = "AVX";
 #ifdef CONFIG_AS_AVX2
-		if (cpu_has_avx2 && boot_cpu_has(X86_FEATURE_BMI2)) {
-			/* allow AVX2 to override AVX, it's a little faster */
+		/* allow AVX2 to override AVX, it's a little faster */
+		if (avx2_usable()) {
 			sha1_transform_asm = sha1_apply_transform_avx2;
 			algo_name = "AVX2";
 		}
-- 
1.7.10.4
