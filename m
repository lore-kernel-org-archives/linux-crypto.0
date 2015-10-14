From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] s390: crypto: replace raw value by their coresponding define
Date: Wed, 14 Oct 2015 21:11:00 +0200
Message-ID: <1444849860-16334-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
To: davem@davemloft.net, heiko.carstens@de.ibm.com,
	herbert@gondor.apana.org.au, schwidefsky@de.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37137 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbbJNTLL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 15:11:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SHA_MAX_STATE_SIZE is just the number of u32 word for SHA512.
So replace the raw value "16" by their meaning (SHA512_DIGEST_SIZE / 4)

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 arch/s390/crypto/sha.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index f4e9dc7..10f2007 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -19,7 +19,7 @@
 #include <crypto/sha.h>
 
 /* must be big enough for the largest SHA variant */
-#define SHA_MAX_STATE_SIZE	16
+#define SHA_MAX_STATE_SIZE	(SHA512_DIGEST_SIZE / 4)
 #define SHA_MAX_BLOCK_SIZE      SHA512_BLOCK_SIZE
 
 struct s390_sha_ctx {
-- 
2.4.9
