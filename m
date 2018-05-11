From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: reorder paes test lexicographically
Date: Fri, 11 May 2018 09:04:06 +0100
Message-ID: <1526025847-13134-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        sachinp <sachinp@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Due to a snafu "paes" testmgr tests were not ordered
lexicographically, which led to boot time warnings.
Reorder the tests as needed.

Fixes: a794d8d ("crypto: ccree - enable support for hardware keys")
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/testmgr.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c31da0f..b1b8ebb 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3012,13 +3012,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		/* Same as ecb(aes) except the key is stored in
-		 * hardware secure memory which we reference by index
-		 */
-		.alg = "ecb(paes)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
 		.alg = "ecb(khazad)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -3028,6 +3021,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/* Same as ecb(aes) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "ecb(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "ecb(seed)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -3610,21 +3610,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		/* Same as xts(aes) except the key is stored in
-		 * hardware secure memory which we reference by index
-		 */
-		.alg = "xts(paes)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "xts4096(paes)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "xts512(paes)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
 		.alg = "xts(camellia)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -3643,6 +3628,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/* Same as xts(aes) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "xts(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "xts(serpent)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -3679,6 +3671,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "xts4096(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "xts512(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "zlib-deflate",
 		.test = alg_test_comp,
 		.fips_allowed = 1,
-- 
2.7.4
