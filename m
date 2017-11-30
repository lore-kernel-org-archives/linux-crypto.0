From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 4/6] crypto: tcrypt: add multi buf ahash jiffies test
Date: Thu, 30 Nov 2017 10:09:30 +0000
Message-ID: <1512036574-26665-5-git-send-email-gilad@benyossef.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The multi buffer concurrent requests ahash speed test only
supported the cycles mode. Add support for the so called
jiffies mode that test performance of bytes/sec.

We only add support for digest mode at the moment.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c | 112 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 30 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 447b18c..cf9b44f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -411,13 +411,87 @@ struct test_mb_ahash_data {
 	char *xbuf[XBUFSIZE];
 };
 
-static void test_mb_ahash_speed(const char *algo, unsigned int sec,
+static inline int do_mult_ahash_op(struct test_mb_ahash_data *data, u32 num_mb)
+{
+	int i, rc[num_mb], err = 0;
+
+	/* Fire up a bunch of concurrent requests */
+	for (i = 0; i < num_mb; i++)
+		rc[i] = crypto_ahash_digest(data[i].req);
+
+	/* Wait for all requests to finish */
+	for (i = 0; i < num_mb; i++) {
+		rc[i] = crypto_wait_req(rc[i], &data[i].wait);
+
+		if (rc[i]) {
+			pr_info("concurrent request %d error %d\n", i, rc[i]);
+			err = rc[i];
+		}
+	}
+
+	return err;
+}
+
+static int test_mb_ahash_jiffies(struct test_mb_ahash_data *data, int blen,
+				 int secs, u32 num_mb)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	for (start = jiffies, end = start + secs * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		ret = do_mult_ahash_op(data, num_mb);
+		if (ret)
+			return ret;
+	}
+
+	pr_cont("%d operations in %d seconds (%ld bytes)\n",
+		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	return 0;
+}
+
+static int test_mb_ahash_cycles(struct test_mb_ahash_data *data, int blen,
+				u32 num_mb)
+{
+	unsigned long cycles = 0;
+	int ret = 0;
+	int i;
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		ret = do_mult_ahash_op(data, num_mb);
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		ret = do_mult_ahash_op(data, num_mb);
+		end = get_cycles();
+
+		if (ret)
+			goto out;
+
+		cycles += end - start;
+	}
+
+out:
+	if (ret == 0)
+		pr_cont("1 operation in %lu cycles (%d bytes)\n",
+			(cycles + 4) / (8 * num_mb), blen);
+
+	return ret;
+}
+
+static void test_mb_ahash_speed(const char *algo, unsigned int secs,
 				struct hash_speed *speed, u32 num_mb)
 {
 	struct test_mb_ahash_data *data;
 	struct crypto_ahash *tfm;
-	unsigned long start, end;
-	unsigned long cycles;
 	unsigned int i, j, k;
 	int ret;
 
@@ -481,34 +555,12 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 			i, speed[i].blen, speed[i].plen,
 			speed[i].blen / speed[i].plen);
 
-		start = get_cycles();
-
-		for (k = 0; k < num_mb; k++) {
-			ret = crypto_ahash_digest(data[k].req);
-			if (ret == -EINPROGRESS) {
-				ret = 0;
-				continue;
-			}
-
-			if (ret)
-				break;
-
-			crypto_req_done(&data[k].req->base, 0);
-		}
-
-		for (j = 0; j < k; j++) {
-			struct crypto_wait *wait = &data[j].wait;
-			int wait_ret;
-
-			wait_ret = crypto_wait_req(-EINPROGRESS, wait);
-			if (wait_ret)
-				ret = wait_ret;
-		}
+		if (secs)
+			ret = test_mb_ahash_jiffies(data, speed[i].blen, secs,
+						    num_mb);
+		else
+			ret = test_mb_ahash_cycles(data, speed[i].blen, num_mb);
 
-		end = get_cycles();
-		cycles = end - start;
-		pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
-			cycles, cycles / (num_mb * speed[i].blen));
 
 		if (ret) {
 			pr_err("At least one hashing failed ret=%d\n", ret);
-- 
2.7.4
