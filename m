From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/6] crypto: tcrypt: use multi buf for ahash mb test
Date: Thu, 30 Nov 2017 10:09:27 +0000
Message-ID: <1512036574-26665-2-git-send-email-gilad@benyossef.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The multi buffer ahash speed test was allocating multiple
buffers for use with the multiple outstanding requests
it was starting but never actually using them (except
to free them), instead using a different single statically
allocated buffer for all requests.

Fix this by actually using the allocated buffers for the test.

It is noted that it may seem tempting to instead remove the
allocation and free of the multiple buffers and leave things as
they are since this is a hash test where the input is read
only. However, after consideration I believe that multiple
buffers better reflect real life scenario with regard
to data cache and TLB behaviours etc.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 3ced1ba..d1fd033 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -383,7 +383,7 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 }
 
 struct test_mb_ahash_data {
-	struct scatterlist sg[TVMEMSIZE];
+	struct scatterlist sg[XBUFSIZE];
 	char result[64];
 	struct ahash_request *req;
 	struct crypto_wait wait;
@@ -426,7 +426,12 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 
 		ahash_request_set_callback(data[i].req, 0, crypto_req_done,
 					   &data[i].wait);
-		test_hash_sg_init(data[i].sg);
+
+		sg_init_table(data[i].sg, XBUFSIZE);
+		for (j = 0; j < XBUFSIZE; j++) {
+			sg_set_buf(data[i].sg + j, data[i].xbuf[j], PAGE_SIZE);
+			memset(data[i].xbuf[j], 0xff, PAGE_SIZE);
+		}
 	}
 
 	pr_info("\ntesting speed of multibuffer %s (%s)\n", algo,
@@ -437,9 +442,9 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 		if (speed[i].blen != speed[i].plen)
 			continue;
 
-		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
+		if (speed[i].blen > XBUFSIZE * PAGE_SIZE) {
 			pr_err("template (%u) too big for tvmem (%lu)\n",
-			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
+			       speed[i].blen, XBUFSIZE * PAGE_SIZE);
 			goto out;
 		}
 
-- 
2.7.4
