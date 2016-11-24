From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/4] crypto: testmgr - add/enhance test cases for CRC-T10DIF
Date: Thu, 24 Nov 2016 15:43:19 +0000
Message-ID: <1480002201-1427-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, dingtianhong@huawei.com,
        yangshengkai@huawei.com, yuehaibing@huawei.com,
        hanjun.guo@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36740 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966618AbcKXPoc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2016 10:44:32 -0500
Received: by mail-wm0-f48.google.com with SMTP id g23so118687143wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2016 07:44:32 -0800 (PST)
In-Reply-To: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The existing test cases only exercise a small slice of the various
possible code paths through the x86 SSE/PCLMULQDQ implementation,
and the upcoming ports of it for arm64. So add one that exceeds 256
bytes in size, and convert another to a chunked test.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.h | 70 ++++++++++++--------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e64a4ef9d8ca..b7cd41b25a2a 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1334,36 +1334,50 @@ static struct hash_testvec rmd320_tv_template[] = {
 	}
 };
 
-#define CRCT10DIF_TEST_VECTORS	3
+#define CRCT10DIF_TEST_VECTORS	ARRAY_SIZE(crct10dif_tv_template)
 static struct hash_testvec crct10dif_tv_template[] = {
 	{
-		.plaintext = "abc",
-		.psize  = 3,
-#ifdef __LITTLE_ENDIAN
-		.digest = "\x3b\x44",
-#else
-		.digest = "\x44\x3b",
-#endif
-	}, {
-		.plaintext = "1234567890123456789012345678901234567890"
-			     "123456789012345678901234567890123456789",
-		.psize	= 79,
-#ifdef __LITTLE_ENDIAN
-		.digest	= "\x70\x4b",
-#else
-		.digest	= "\x4b\x70",
-#endif
-	}, {
-		.plaintext =
-		"abcddddddddddddddddddddddddddddddddddddddddddddddddddddd",
-		.psize  = 56,
-#ifdef __LITTLE_ENDIAN
-		.digest = "\xe3\x9c",
-#else
-		.digest = "\x9c\xe3",
-#endif
-		.np     = 2,
-		.tap    = { 28, 28 }
+		.plaintext	= "abc",
+		.psize		= 3,
+		.digest		= (u8 *)(u16 []){ 0x443b },
+	}, {
+		.plaintext 	= "1234567890123456789012345678901234567890"
+				  "123456789012345678901234567890123456789",
+		.psize		= 79,
+		.digest 	= (u8 *)(u16 []){ 0x4b70 },
+		.np		= 2,
+		.tap		= { 63, 16 },
+	}, {
+		.plaintext	= "abcdddddddddddddddddddddddddddddddddddddddd"
+				  "ddddddddddddd",
+		.psize		= 56,
+		.digest		= (u8 *)(u16 []){ 0x9ce3 },
+		.np		= 8,
+		.tap		= { 1, 2, 28, 7, 6, 5, 4, 3 },
+	}, {
+		.plaintext 	= "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "123456789012345678901234567890123456789",
+		.psize		= 319,
+		.digest		= (u8 *)((u16 []){ 0x44c6 }),
+	}, {
+		.plaintext 	= "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "1234567890123456789012345678901234567890"
+				  "123456789012345678901234567890123456789",
+		.psize		= 319,
+		.digest		= (u8 *)((u16 []){ 0x44c6 }),
+		.np		= 4,
+		.tap		= { 1, 255, 57, 6 },
 	}
 };
 
-- 
2.7.4
