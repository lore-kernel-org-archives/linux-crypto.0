From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 6/7] crypto: tcrypt - Add speed tests for SHA multibuffer algorithms
Date: Thu, 23 Jun 2016 18:40:47 -0700
Message-ID: <1466732448-27856-7-git-send-email-megha.dey@intel.com>
References: <1466732448-27856-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466732448-27856-1-git-send-email-megha.dey@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

The existing test suite to calculate the speed of the SHA algorithms
assumes serial (single buffer)) computation of data. With the SHA
multibuffer algorithms, we work on 8 lanes of data in parallel. Hence,
the need to introduce a new test suite to calculate the speed for these
algorithms.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 crypto/tcrypt.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 4675459..6ef7815 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -578,6 +578,117 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 	return ret;
 }
 
+char ptext[4096];
+struct scatterlist sg[8][8];
+char result[8][64];
+struct ahash_request *req[8];
+struct tcrypt_result tresult[8];
+char *xbuf[8][XBUFSIZE];
+cycles_t start[8], end[8], mid;
+
+static void test_mb_ahash_speed(const char *algo, unsigned int sec,
+					struct hash_speed *speed)
+{
+	unsigned int i, j, k;
+	void *hash_buff;
+	int ret = -ENOMEM;
+	struct crypto_ahash *tfm;
+
+	tfm = crypto_alloc_ahash(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n",
+			algo, PTR_ERR(tfm));
+		return;
+	}
+	for (i = 0; i < 8; ++i) {
+		if (testmgr_alloc_buf(xbuf[i]))
+			goto out_nobuf;
+
+		init_completion(&tresult[i].completion);
+
+		req[i] = ahash_request_alloc(tfm, GFP_KERNEL);
+		if (!req[i]) {
+			printk(KERN_ERR "alg: hash: Failed to allocate "
+				"request for %s\n", algo);
+			goto out_noreq;
+		}
+		ahash_request_set_callback(req[i], CRYPTO_TFM_REQ_MAY_BACKLOG,
+				tcrypt_complete, &tresult[i]);
+
+		hash_buff = xbuf[i][0];
+		memcpy(hash_buff, ptext, 4096);
+	}
+
+	j = 0;
+
+	printk(KERN_INFO "\ntesting speed of %s (%s)\n", algo,
+				get_driver_name(crypto_ahash, tfm));
+
+	for (i = 0; speed[i].blen != 0; i++) {
+		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
+			printk(KERN_ERR
+				"template (%u) too big for tvmem (%lu)\n",
+					speed[i].blen, TVMEMSIZE * PAGE_SIZE);
+		goto out;
+		}
+
+		if (speed[i].klen)
+			crypto_ahash_setkey(tfm, tvmem[0], speed[i].klen);
+
+		for (k = 0; k < 8; ++k) {
+			sg_init_one(&sg[k][0], (void *) xbuf[k][0],
+						speed[i].blen);
+			ahash_request_set_crypt(req[k], sg[k],
+						result[k], speed[i].blen);
+		}
+
+		printk(KERN_INFO "test%3u "
+			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
+			i, speed[i].blen, speed[i].plen,
+			speed[i].blen / speed[i].plen);
+
+		for (k = 0; k < 8; ++k) {
+			start[k] = get_cycles();
+			ret = crypto_ahash_digest(req[k]);
+			if (ret == -EBUSY || ret == -EINPROGRESS)
+				continue;
+			if (ret) {
+				printk(KERN_ERR
+				"alg (%s) something wrong, ret = %d ...\n",
+								algo, ret);
+				goto out;
+			}
+		}
+		mid = get_cycles();
+
+		for (k = 0; k < 8; ++k) {
+			struct tcrypt_result *tr = &tresult[k];
+
+			ret = wait_for_completion_interruptible
+						(&tr->completion);
+			if (ret)
+				printk(KERN_ERR
+				"alg(%s): hash: digest failed\n", algo);
+			end[k] = get_cycles();
+		}
+
+		printk("\nBlock: %lld cycles (%lld cycles/byte), %d bytes\n",
+			(s64) (end[7]-start[0])/1,
+			(s64) (end[7]-start[0])/(8*speed[i].blen),
+			8*speed[i].blen);
+	}
+	ret = 0;
+
+out:
+	for (k = 0; k < 8; ++k)
+		ahash_request_free(req[k]);
+out_noreq:
+	for (k = 0; k < 8; ++k)
+		testmgr_free_buf(xbuf[k]);
+out_nobuf:
+	return;
+}
+
 static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 				     char *out, int secs)
 {
@@ -1820,6 +1931,13 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_ahash_speed("sha3-512", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 
+	case 422:
+		test_mb_ahash_speed("sha1", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 423:
+		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
 
 	case 499:
 		break;
-- 
1.9.1
