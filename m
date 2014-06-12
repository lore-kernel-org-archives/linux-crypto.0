From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: add 4 more test vectors for GHASH
Date: Thu, 12 Jun 2014 17:01:50 +0200
Message-ID: <1402585310-1377-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:62313 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbaFLPCE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jun 2014 11:02:04 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so1401298wes.7
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jun 2014 08:01:56 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds 4 test vectors for GHASH (of which one for chunked mode), making
a total of 5.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.h | 49 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 69d0dd8ef27e..126b6f9531b2 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1807,18 +1807,59 @@ static struct hash_testvec tgr128_tv_template[] = {
 	},
 };
 
-#define GHASH_TEST_VECTORS 1
+#define GHASH_TEST_VECTORS 5
 
 static struct hash_testvec ghash_tv_template[] =
 {
 	{
-
-		.key	= "\xdf\xa6\xbf\x4d\xed\x81\xdb\x03\xff\xca\xff\x95\xf8\x30\xf0\x61",
+		.key	= "\xdf\xa6\xbf\x4d\xed\x81\xdb\x03"
+			  "\xff\xca\xff\x95\xf8\x30\xf0\x61",
 		.ksize	= 16,
-		.plaintext = "\x95\x2b\x2a\x56\xa5\x60\x04a\xc0\xb3\x2b\x66\x56\xa0\x5b\x40\xb6",
+		.plaintext = "\x95\x2b\x2a\x56\xa5\x60\x04a\xc0"
+			     "\xb3\x2b\x66\x56\xa0\x5b\x40\xb6",
 		.psize	= 16,
 		.digest	= "\xda\x53\xeb\x0a\xd2\xc5\x5b\xb6"
 			  "\x4f\xc4\x80\x2c\xc3\xfe\xda\x60",
+	}, {
+		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
+		.ksize	= 16,
+		.plaintext = "what do ya want for nothing?",
+		.psize	= 28,
+		.digest	= "\x3e\x1f\x5c\x4d\x65\xf0\xef\xce"
+			  "\x0d\x61\x06\x27\x66\x51\xd5\xe2",
+		.np	= 2,
+		.tap	= {14, 14}
+	}, {
+		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
+		.ksize	= 16,
+		.plaintext = "\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd",
+		.psize	= 50,
+		.digest	= "\xfb\x49\x8a\x36\xe1\x96\xe1\x96"
+			  "\xe1\x96\xe1\x96\xe1\x96\xe1\x96",
+	}, {
+		.key	= "\xda\x53\xeb\x0a\xd2\xc5\x5b\xb6"
+			  "\x4f\xc4\x80\x2c\xc3\xfe\xda\x60",
+		.ksize	= 16,
+		.plaintext = "\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd",
+		.psize	= 50,
+		.digest	= "\x2b\x5c\x0c\x7f\x52\xd1\x60\xc2"
+			  "\x49\xed\x6e\x32\x7a\xa9\xbe\x08",
+	}, {
+		.key	= "\x95\x2b\x2a\x56\xa5\x60\x04a\xc0"
+			  "\xb3\x2b\x66\x56\xa0\x5b\x40\xb6",
+		.ksize	= 16,
+		.plaintext = "Test With Truncation",
+		.psize	= 20,
+		.digest	= "\xf8\x94\x87\x2a\x4b\x63\x99\x28"
+			  "\x23\xf7\x93\xf7\x19\xf5\x96\xd9",
 	},
 };
 
-- 
1.8.3.2
