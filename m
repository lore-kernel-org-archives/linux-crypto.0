From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/2] crypto-testmgr: Use common error handling code in
 drbg_cavs_test()
Date: Sat, 21 Oct 2017 19:53:54 +0200
Message-ID: <7aa0ec0b-c00e-44c0-1c07-6bd87e2b6c47@users.sourceforge.net>
References: <7c2b4df8-a04b-cacd-13ba-4d9afb346263@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7c2b4df8-a04b-cacd-13ba-4d9afb346263@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 21 Oct 2017 19:29:11 +0200

Adjust jump targets so that a bit of exception handling can be better
reused at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 crypto/testmgr.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index dd9c7f1c1c7b..76c5128284f8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1914,8 +1914,8 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 	if (IS_ERR(drng)) {
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
-		kzfree(buf);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_buffer;
 	}
 
 	test_data.testentropy = &testentropy;
@@ -1924,7 +1924,7 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 	ret = crypto_drbg_reset_test(drng, &pers, &test_data);
 	if (ret) {
 		printk(KERN_ERR "alg: drbg: Failed to reset rng\n");
-		goto outbuf;
+		goto free_rng;
 	}
 
 	drbg_string_fill(&addtl, test->addtla, test->addtllen);
@@ -1936,11 +1936,9 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 		ret = crypto_drbg_get_bytes_addtl(drng,
 			buf, test->expectedlen, &addtl);
 	}
-	if (ret < 0) {
-		printk(KERN_ERR "alg: drbg: could not obtain random data for "
-		       "driver %s\n", driver);
-		goto outbuf;
-	}
+
+	if (ret < 0)
+		goto report_failure;
 
 	drbg_string_fill(&addtl, test->addtlb, test->addtllen);
 	if (pr) {
@@ -1951,18 +1949,21 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 		ret = crypto_drbg_get_bytes_addtl(drng,
 			buf, test->expectedlen, &addtl);
 	}
-	if (ret < 0) {
-		printk(KERN_ERR "alg: drbg: could not obtain random data for "
-		       "driver %s\n", driver);
-		goto outbuf;
-	}
 
-	ret = memcmp(test->expected, buf, test->expectedlen);
+	if (ret < 0)
+		goto report_failure;
 
-outbuf:
+	ret = memcmp(test->expected, buf, test->expectedlen);
+free_rng:
 	crypto_free_rng(drng);
+free_buffer:
 	kzfree(buf);
 	return ret;
+
+report_failure:
+	pr_err("alg: drbg: could not obtain random data for driver %s\n",
+	       driver);
+	goto free_rng;
 }
 
 
-- 
2.14.2
