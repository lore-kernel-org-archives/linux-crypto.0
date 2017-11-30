From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 3/6] crypto: tcrypt: allow setting num of bufs
Date: Thu, 30 Nov 2017 10:09:29 +0000
Message-ID: <1512036574-26665-4-git-send-email-gilad@benyossef.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

For multiple buffers speed tests, the number of buffers, or
requests, used actually sets the level of parallelism a tfm
provider may utilize to hide latency. The existing number
(of 8) is good for some software based providers but not
enough for many HW providers with deep FIFOs.

Add a module parameter that allows setting the number of
multiple buffers/requests used, leaving the default at 8.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 56fb6a6..447b18c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -67,6 +67,7 @@ static char *alg = NULL;
 static u32 type;
 static u32 mask;
 static int mode;
+static u32 num_mb = 8;
 static char *tvmem[TVMEMSIZE];
 
 static char *check[] = {
@@ -411,7 +412,7 @@ struct test_mb_ahash_data {
 };
 
 static void test_mb_ahash_speed(const char *algo, unsigned int sec,
-				struct hash_speed *speed)
+				struct hash_speed *speed, u32 num_mb)
 {
 	struct test_mb_ahash_data *data;
 	struct crypto_ahash *tfm;
@@ -420,7 +421,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 	unsigned int i, j, k;
 	int ret;
 
-	data = kzalloc(sizeof(*data) * 8, GFP_KERNEL);
+	data = kcalloc(num_mb, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return;
 
@@ -431,7 +432,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 		goto free_data;
 	}
 
-	for (i = 0; i < 8; ++i) {
+	for (i = 0; i < num_mb; ++i) {
 		if (testmgr_alloc_buf(data[i].xbuf))
 			goto out;
 
@@ -471,7 +472,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 		if (speed[i].klen)
 			crypto_ahash_setkey(tfm, tvmem[0], speed[i].klen);
 
-		for (k = 0; k < 8; k++)
+		for (k = 0; k < num_mb; k++)
 			ahash_request_set_crypt(data[k].req, data[k].sg,
 						data[k].result, speed[i].blen);
 
@@ -482,7 +483,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 
 		start = get_cycles();
 
-		for (k = 0; k < 8; k++) {
+		for (k = 0; k < num_mb; k++) {
 			ret = crypto_ahash_digest(data[k].req);
 			if (ret == -EINPROGRESS) {
 				ret = 0;
@@ -507,7 +508,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 		end = get_cycles();
 		cycles = end - start;
 		pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
-			cycles, cycles / (8 * speed[i].blen));
+			cycles, cycles / (num_mb * speed[i].blen));
 
 		if (ret) {
 			pr_err("At least one hashing failed ret=%d\n", ret);
@@ -516,10 +517,10 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 	}
 
 out:
-	for (k = 0; k < 8; ++k)
+	for (k = 0; k < num_mb; ++k)
 		ahash_request_free(data[k].req);
 
-	for (k = 0; k < 8; ++k)
+	for (k = 0; k < num_mb; ++k)
 		testmgr_free_buf(data[k].xbuf);
 
 	crypto_free_ahash(tfm);
@@ -1813,19 +1814,23 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		if (mode > 400 && mode < 500) break;
 		/* fall through */
 	case 422:
-		test_mb_ahash_speed("sha1", sec, generic_hash_speed_template);
+		test_mb_ahash_speed("sha1", sec, generic_hash_speed_template,
+				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		/* fall through */
 	case 423:
-		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template);
+		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template,
+				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		/* fall through */
 	case 424:
-		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template);
+		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template,
+				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		/* fall through */
 	case 425:
-		test_mb_ahash_speed("sm3", sec, generic_hash_speed_template);
+		test_mb_ahash_speed("sm3", sec, generic_hash_speed_template,
+				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		/* fall through */
 	case 499:
@@ -2104,6 +2109,8 @@ module_param(mode, int, 0);
 module_param(sec, uint, 0);
 MODULE_PARM_DESC(sec, "Length in seconds of speed tests "
 		      "(defaults to zero which uses CPU cycles instead)");
+module_param(num_mb, uint, 0000);
+MODULE_PARM_DESC(num_mb, "Number of concurrent requests to be used in mb speed tests (defaults to 8)");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Quick & dirty crypto testing module");
-- 
2.7.4
