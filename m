Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbfAJUSX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:23 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 04/11] crypto: testmgr - handle endianness correctly in alg_test_crc32c()
Date: Thu, 10 Jan 2019 12:17:55 -0800
Message-Id: <20190110201802.82442-5-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The crc32c context is in CPU endianness, whereas the final digest is
little endian.  alg_test_crc32c() got this mixed up.  Fix it.

The test passes both before and after, but this patch fixes the
following sparse warning:

    crypto/testmgr.c:1912:24: warning: cast to restricted __le32

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f684a414acbe..10b7208bd40be 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1889,7 +1889,7 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 			   const char *driver, u32 type, u32 mask)
 {
 	struct crypto_shash *tfm;
-	u32 val;
+	__le32 val;
 	int err;
 
 	err = alg_test_hash(desc, driver, type, mask);
@@ -1911,7 +1911,7 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 		shash->tfm = tfm;
 		shash->flags = 0;
 
-		*ctx = le32_to_cpu(420553207);
+		*ctx = 420553207;
 		err = crypto_shash_final(shash, (u8 *)&val);
 		if (err) {
 			printk(KERN_ERR "alg: crc32c: Operation failed for "
@@ -1919,9 +1919,9 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 			break;
 		}
 
-		if (val != ~420553207) {
-			printk(KERN_ERR "alg: crc32c: Test failed for %s: "
-			       "%d\n", driver, val);
+		if (val != cpu_to_le32(~420553207)) {
+			pr_err("alg: crc32c: Test failed for %s: %u\n",
+			       driver, le32_to_cpu(val));
 			err = -EINVAL;
 		}
 	} while (0);
-- 
2.20.1.97.g81188d93c3-goog
