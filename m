From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v4 3/4] crypto: lrw - Optimize tweak computation
Date: Thu, 13 Sep 2018 10:51:33 +0200
Message-ID: <20180913085134.11694-4-omosnace@redhat.com>
References: <20180913085134.11694-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180913085134.11694-1-omosnace@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

This patch rewrites the tweak computation to a slightly simpler method
that performs less bswaps. Based on performance measurements the new
code seems to provide slightly better performance than the old one.

PERFORMANCE MEASUREMENTS (x86_64)
Performed using: https://gitlab.com/omos/linux-crypto-bench
Crypto driver used: lrw(ecb-aes-aesni)

Before:
       ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
        lrw(aes)     256              64             204             286
        lrw(aes)     320              64             227             203
        lrw(aes)     384              64             208             204
        lrw(aes)     256             512             441             439
        lrw(aes)     320             512             456             455
        lrw(aes)     384             512             469             483
        lrw(aes)     256            4096            2136            2190
        lrw(aes)     320            4096            2161            2213
        lrw(aes)     384            4096            2295            2369
        lrw(aes)     256           16384            7692            7868
        lrw(aes)     320           16384            8230            8691
        lrw(aes)     384           16384            8971            8813
        lrw(aes)     256           32768           15336           15560
        lrw(aes)     320           32768           16410           16346
        lrw(aes)     384           32768           18023           17465

After:
       ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
        lrw(aes)     256              64             200             203
        lrw(aes)     320              64             202             204
        lrw(aes)     384              64             204             205
        lrw(aes)     256             512             415             415
        lrw(aes)     320             512             432             440
        lrw(aes)     384             512             449             451
        lrw(aes)     256            4096            1838            1995
        lrw(aes)     320            4096            2123            1980
        lrw(aes)     384            4096            2100            2119
        lrw(aes)     256           16384            7183            6954
        lrw(aes)     320           16384            7844            7631
        lrw(aes)     384           16384            8256            8126
        lrw(aes)     256           32768           14772           14484
        lrw(aes)     320           32768           15281           15431
        lrw(aes)     384           32768           16469           16293

Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/lrw.c | 61 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 5504d1325a56..7377b5b486fd 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -120,27 +120,28 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	return 0;
 }
 
-static inline void inc(be128 *iv)
-{
-	be64_add_cpu(&iv->b, 1);
-	if (!iv->b)
-		be64_add_cpu(&iv->a, 1);
-}
-
-/* this returns the number of consequative 1 bits starting
- * from the right, get_index128(00 00 00 00 00 00 ... 00 00 10 FB) = 2 */
-static inline int get_index128(be128 *block)
+/*
+ * Returns the number of trailing '1' bits in the words of the counter, which is
+ * represented by 4 32-bit words, arranged from least to most significant.
+ * At the same time, increments the counter by one.
+ *
+ * For example:
+ *
+ * u32 counter[4] = { 0xFFFFFFFF, 0x1, 0x0, 0x0 };
+ * int i = next_index(&counter);
+ * // i == 33, counter == { 0x0, 0x2, 0x0, 0x0 }
+ */
+static int next_index(u32 *counter)
 {
-	int x;
-	__be32 *p = (__be32 *) block;
+	int i, res = 0;
 
-	for (p += 3, x = 0; x < 128; p--, x += 32) {
-		u32 val = be32_to_cpup(p);
-
-		if (!~val)
-			continue;
-
-		return x + ffz(val);
+	for (i = 0; i < 4; i++) {
+		if (counter[i] + 1 != 0) {
+			res += ffz(counter[i]++);
+			break;
+		}
+		counter[i] = 0;
+		res += 32;
 	}
 
 	/*
@@ -214,8 +215,9 @@ static int pre_crypt(struct skcipher_request *req)
 	struct scatterlist *sg;
 	unsigned cryptlen;
 	unsigned offset;
-	be128 *iv;
 	bool more;
+	__be32 *iv;
+	u32 counter[4];
 	int err;
 
 	subreq = &rctx->subreq;
@@ -230,7 +232,12 @@ static int pre_crypt(struct skcipher_request *req)
 				   cryptlen, req->iv);
 
 	err = skcipher_walk_virt(&w, subreq, false);
-	iv = w.iv;
+	iv = (__be32 *)w.iv;
+
+	counter[0] = be32_to_cpu(iv[3]);
+	counter[1] = be32_to_cpu(iv[2]);
+	counter[2] = be32_to_cpu(iv[1]);
+	counter[3] = be32_to_cpu(iv[0]);
 
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
@@ -247,10 +254,16 @@ static int pre_crypt(struct skcipher_request *req)
 			/* T <- I*Key2, using the optimization
 			 * discussed in the specification */
 			be128_xor(&rctx->t, &rctx->t,
-				  &ctx->mulinc[get_index128(iv)]);
-			inc(iv);
+				  &ctx->mulinc[next_index(counter)]);
 		} while ((avail -= bs) >= bs);
 
+		if (w.nbytes == w.total) {
+			iv[0] = cpu_to_be32(counter[3]);
+			iv[1] = cpu_to_be32(counter[2]);
+			iv[2] = cpu_to_be32(counter[1]);
+			iv[3] = cpu_to_be32(counter[0]);
+		}
+
 		err = skcipher_walk_done(&w, avail);
 	}
 
@@ -548,7 +561,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = LRW_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
-				       (__alignof__(u64) - 1);
+				       (__alignof__(__be32) - 1);
 
 	inst->alg.ivsize = LRW_BLOCK_SIZE;
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
-- 
2.17.1
