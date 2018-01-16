From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH] crypto: testmgr.c: test misuse of result in ahash
Date: Tue, 16 Jan 2018 15:26:13 +0100
Message-ID: <9d678a28-8cb3-1ab8-cefe-1bafff2a18d9@partner.samsung.com>
References: <CGME20180116142614eucas1p1c171b69192a4b8f7871075ff712bb7ba@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Async hash operations can use result pointer in final/finup/digest,
but not in init/update/export/import, so test it for misuse.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
Tested with crypto run-time self test on Odroid-U3 with Exynos 4412 CPU
with insmod s5p-sss.ko

 crypto/testmgr.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 44a85d4b3561..d5e23a142a04 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -177,6 +177,18 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 		free_page((unsigned long)buf[i]);
 }
 
+static int ahash_guard_result(char *result, char c, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (result[i] != c)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ahash_partial_update(struct ahash_request **preq,
 	struct crypto_ahash *tfm, const struct hash_testvec *template,
 	void *hash_buff, int k, int temp, struct scatterlist *sg,
@@ -186,6 +198,7 @@ static int ahash_partial_update(struct ahash_request **preq,
 	struct ahash_request *req;
 	int statesize, ret = -EINVAL;
 	static const unsigned char guard[] = { 0x00, 0xba, 0xad, 0x00 };
+	int digestsize = crypto_ahash_digestsize(tfm);
 
 	req = *preq;
 	statesize = crypto_ahash_statesize(
@@ -196,12 +209,19 @@ static int ahash_partial_update(struct ahash_request **preq,
 		goto out_nostate;
 	}
 	memcpy(state + statesize, guard, sizeof(guard));
+	memset(result, 1, digestsize);
 	ret = crypto_ahash_export(req, state);
 	WARN_ON(memcmp(state + statesize, guard, sizeof(guard)));
 	if (ret) {
 		pr_err("alg: hash: Failed to export() for %s\n", algo);
 		goto out;
 	}
+	ret = ahash_guard_result(result, 1, digestsize);
+	if (ret) {
+		pr_err("alg: hash: Failed, export used req->result for %s\n",
+		       algo);
+		goto out;
+	}
 	ahash_request_free(req);
 	req = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -221,6 +241,12 @@ static int ahash_partial_update(struct ahash_request **preq,
 		pr_err("alg: hash: Failed to import() for %s\n", algo);
 		goto out;
 	}
+	ret = ahash_guard_result(result, 1, digestsize);
+	if (ret) {
+		pr_err("alg: hash: Failed, import used req->result for %s\n",
+		       algo);
+		goto out;
+	}
 	ret = crypto_wait_req(crypto_ahash_update(req), wait);
 	if (ret)
 		goto out;
@@ -316,18 +342,31 @@ static int __test_hash(struct crypto_ahash *tfm,
 				goto out;
 			}
 		} else {
+			memset(result, 1, digest_size);
 			ret = crypto_wait_req(crypto_ahash_init(req), &wait);
 			if (ret) {
 				pr_err("alg: hash: init failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
+			ret = ahash_guard_result(result, 1, digest_size);
+			if (ret) {
+				pr_err("alg: hash: init failed on test %d "
+				       "for %s: used req->result\n", j, algo);
+				goto out;
+			}
 			ret = crypto_wait_req(crypto_ahash_update(req), &wait);
 			if (ret) {
 				pr_err("alg: hash: update failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
+			ret = ahash_guard_result(result, 1, digest_size);
+			if (ret) {
+				pr_err("alg: hash: update failed on test %d "
+				       "for %s: used req->result\n", j, algo);
+				goto out;
+			}
 			ret = crypto_wait_req(crypto_ahash_final(req), &wait);
 			if (ret) {
 				pr_err("alg: hash: final failed on test %d "
-- 
2.15.0
