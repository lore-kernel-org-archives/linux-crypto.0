From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v3] crypto: xts - Drop use of auxiliary buffer
Date: Wed,  5 Sep 2018 13:30:39 +0200
Message-ID: <20180905113039.3324-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
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

Since commit acb9b159c784 ("crypto: gf128mul - define gf128mul_x_* in
gf128mul.h"), the gf128mul_x_*() functions are very fast and therefore
caching the computed XTS tweaks has only negligible advantage over
computing them twice.

In fact, since the current caching implementation limits the size of
the calls to the child ecb(...) algorithm to PAGE_SIZE (usually 4096 B),
it is often actually slower than the simple recomputing implementation.

This patch simplifies the XTS template to recompute the XTS tweaks from
scratch in the second pass and thus also removes the need to allocate a
dynamic buffer using kmalloc().

As discussed at [1], the use of kmalloc causes deadlocks with dm-crypt.

PERFORMANCE RESULTS
I measured time to encrypt/decrypt a memory buffer of varying sizes with
xts(ecb-aes-aesni) using a tool I wrote ([2]) and the results suggest
that after this patch the performance is either better or comparable for
both small and large buffers. Note that there is a lot of noise in the
measurements, but the overall difference is easy to see.

Old code:
       ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
        xts(aes)     256              64             331             328
        xts(aes)     384              64             332             333
        xts(aes)     512              64             338             348
        xts(aes)     256             512             889             920
        xts(aes)     384             512            1019             993
        xts(aes)     512             512            1032             990
        xts(aes)     256            4096            2152            2292
        xts(aes)     384            4096            2453            2597
        xts(aes)     512            4096            3041            2641
        xts(aes)     256           16384            9443            8027
        xts(aes)     384           16384            8536            8925
        xts(aes)     512           16384            9232            9417
        xts(aes)     256           32768           16383           14897
        xts(aes)     384           32768           17527           16102
        xts(aes)     512           32768           18483           17322

New code:
       ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
        xts(aes)     256              64             328             324
        xts(aes)     384              64             324             319
        xts(aes)     512              64             320             322
        xts(aes)     256             512             476             473
        xts(aes)     384             512             509             492
        xts(aes)     512             512             531             514
        xts(aes)     256            4096            2132            1829
        xts(aes)     384            4096            2357            2055
        xts(aes)     512            4096            2178            2027
        xts(aes)     256           16384            6920            6983
        xts(aes)     384           16384            8597            7505
        xts(aes)     512           16384            7841            8164
        xts(aes)     256           32768           13468           12307
        xts(aes)     384           32768           14808           13402
        xts(aes)     512           32768           15753           14636

[1] https://lkml.org/lkml/2018/8/23/1315
[2] https://gitlab.com/omos/linux-crypto-bench

Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/xts.c | 265 ++++++++-------------------------------------------
 1 file changed, 39 insertions(+), 226 deletions(-)

Changes in v3:
  - add comment explaining the new approach as suggested by Eric
  - ensure correct alignment in second xor_tweak() pass
  - align performance results table header to the right

v2: https://www.spinics.net/lists/linux-crypto/msg34799.html
Changes in v2:
  - rebase to latest cryptodev tree

v1: https://www.spinics.net/lists/linux-crypto/msg34776.html

diff --git a/crypto/xts.c b/crypto/xts.c
index ccf55fbb8bc2..24cfecdec565 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -26,8 +26,6 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
-#define XTS_BUFFER_SIZE 128u
-
 struct priv {
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
@@ -39,19 +37,7 @@ struct xts_instance_ctx {
 };
 
 struct rctx {
-	le128 buf[XTS_BUFFER_SIZE / sizeof(le128)];
-
 	le128 t;
-
-	le128 *ext;
-
-	struct scatterlist srcbuf[2];
-	struct scatterlist dstbuf[2];
-	struct scatterlist *src;
-	struct scatterlist *dst;
-
-	unsigned int left;
-
 	struct skcipher_request subreq;
 };
 
@@ -96,265 +82,92 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
 	return err;
 }
 
-static int post_crypt(struct skcipher_request *req)
+/*
+ * We compute the tweak masks twice (both before and after the ECB encryption or
+ * decryption) to avoid having to allocate a temporary buffer and/or make
+ * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
+ * just doing the gf128mul_x_ble() calls again.
+ */
+static int xor_tweak(struct skcipher_request *req, struct skcipher_request *subreq)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
-	le128 *buf = rctx->ext ?: rctx->buf;
-	struct skcipher_request *subreq;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const int bs = XTS_BLOCK_SIZE;
 	struct skcipher_walk w;
-	struct scatterlist *sg;
-	unsigned offset;
+	le128 t = rctx->t;
 	int err;
 
-	subreq = &rctx->subreq;
+	/* set to our TFM to enforce correct alignment: */
+	skcipher_request_set_tfm(subreq, tfm);
+
 	err = skcipher_walk_virt(&w, subreq, false);
 
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
+		le128 *wsrc;
 		le128 *wdst;
 
+		wsrc = w.src.virt.addr;
 		wdst = w.dst.virt.addr;
 
 		do {
-			le128_xor(wdst, buf++, wdst);
-			wdst++;
+			le128_xor(wdst++, &t, wsrc++);
+			gf128mul_x_ble(&t, &t);
 		} while ((avail -= bs) >= bs);
 
 		err = skcipher_walk_done(&w, avail);
 	}
 
-	rctx->left -= subreq->cryptlen;
-
-	if (err || !rctx->left)
-		goto out;
-
-	rctx->dst = rctx->dstbuf;
-
-	scatterwalk_done(&w.out, 0, 1);
-	sg = w.out.sg;
-	offset = w.out.offset;
-
-	if (rctx->dst != sg) {
-		rctx->dst[0] = *sg;
-		sg_unmark_end(rctx->dst);
-		scatterwalk_crypto_chain(rctx->dst, sg_next(sg), 2);
-	}
-	rctx->dst[0].length -= offset - sg->offset;
-	rctx->dst[0].offset = offset;
-
-out:
 	return err;
 }
 
-static int pre_crypt(struct skcipher_request *req)
+static void crypt_done(struct crypto_async_request *areq, int err)
 {
+	struct skcipher_request *req = areq->data;
 	struct rctx *rctx = skcipher_request_ctx(req);
-	le128 *buf = rctx->ext ?: rctx->buf;
-	struct skcipher_request *subreq;
-	const int bs = XTS_BLOCK_SIZE;
-	struct skcipher_walk w;
-	struct scatterlist *sg;
-	unsigned cryptlen;
-	unsigned offset;
-	bool more;
-	int err;
+	struct skcipher_request *subreq = &rctx->subreq;
 
-	subreq = &rctx->subreq;
-	cryptlen = subreq->cryptlen;
+	if (!err)
+		err = xor_tweak(req, subreq);
 
-	more = rctx->left > cryptlen;
-	if (!more)
-		cryptlen = rctx->left;
-
-	skcipher_request_set_crypt(subreq, rctx->src, rctx->dst,
-				   cryptlen, NULL);
-
-	err = skcipher_walk_virt(&w, subreq, false);
-
-	while (w.nbytes) {
-		unsigned int avail = w.nbytes;
-		le128 *wsrc;
-		le128 *wdst;
-
-		wsrc = w.src.virt.addr;
-		wdst = w.dst.virt.addr;
-
-		do {
-			*buf++ = rctx->t;
-			le128_xor(wdst++, &rctx->t, wsrc++);
-			gf128mul_x_ble(&rctx->t, &rctx->t);
-		} while ((avail -= bs) >= bs);
-
-		err = skcipher_walk_done(&w, avail);
-	}
-
-	skcipher_request_set_crypt(subreq, rctx->dst, rctx->dst,
-				   cryptlen, NULL);
-
-	if (err || !more)
-		goto out;
-
-	rctx->src = rctx->srcbuf;
-
-	scatterwalk_done(&w.in, 0, 1);
-	sg = w.in.sg;
-	offset = w.in.offset;
-
-	if (rctx->src != sg) {
-		rctx->src[0] = *sg;
-		sg_unmark_end(rctx->src);
-		scatterwalk_crypto_chain(rctx->src, sg_next(sg), 2);
-	}
-	rctx->src[0].length -= offset - sg->offset;
-	rctx->src[0].offset = offset;
-
-out:
-	return err;
+	skcipher_request_complete(req, err);
 }
 
-static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
+static void init_crypt(struct skcipher_request *req)
 {
 	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	struct rctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq;
-	gfp_t gfp;
+	struct skcipher_request *subreq = &rctx->subreq;
 
-	subreq = &rctx->subreq;
 	skcipher_request_set_tfm(subreq, ctx->child);
-	skcipher_request_set_callback(subreq, req->base.flags, done, req);
-
-	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
-							   GFP_ATOMIC;
-	rctx->ext = NULL;
-
-	subreq->cryptlen = XTS_BUFFER_SIZE;
-	if (req->cryptlen > XTS_BUFFER_SIZE) {
-		unsigned int n = min(req->cryptlen, (unsigned int)PAGE_SIZE);
-
-		rctx->ext = kmalloc(n, gfp);
-		if (rctx->ext)
-			subreq->cryptlen = n;
-	}
-
-	rctx->src = req->src;
-	rctx->dst = req->dst;
-	rctx->left = req->cryptlen;
+	skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req);
+	skcipher_request_set_crypt(subreq, req->dst, req->dst,
+				   req->cryptlen, NULL);
 
 	/* calculate first value of T */
 	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
-
-	return 0;
-}
-
-static void exit_crypt(struct skcipher_request *req)
-{
-	struct rctx *rctx = skcipher_request_ctx(req);
-
-	rctx->left = 0;
-
-	if (rctx->ext)
-		kzfree(rctx->ext);
-}
-
-static int do_encrypt(struct skcipher_request *req, int err)
-{
-	struct rctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq;
-
-	subreq = &rctx->subreq;
-
-	while (!err && rctx->left) {
-		err = pre_crypt(req) ?:
-		      crypto_skcipher_encrypt(subreq) ?:
-		      post_crypt(req);
-
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return err;
-	}
-
-	exit_crypt(req);
-	return err;
-}
-
-static void encrypt_done(struct crypto_async_request *areq, int err)
-{
-	struct skcipher_request *req = areq->data;
-	struct skcipher_request *subreq;
-	struct rctx *rctx;
-
-	rctx = skcipher_request_ctx(req);
-
-	if (err == -EINPROGRESS) {
-		if (rctx->left != req->cryptlen)
-			return;
-		goto out;
-	}
-
-	subreq = &rctx->subreq;
-	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
-
-	err = do_encrypt(req, err ?: post_crypt(req));
-	if (rctx->left)
-		return;
-
-out:
-	skcipher_request_complete(req, err);
 }
 
 static int encrypt(struct skcipher_request *req)
-{
-	return do_encrypt(req, init_crypt(req, encrypt_done));
-}
-
-static int do_decrypt(struct skcipher_request *req, int err)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq;
-
-	subreq = &rctx->subreq;
-
-	while (!err && rctx->left) {
-		err = pre_crypt(req) ?:
-		      crypto_skcipher_decrypt(subreq) ?:
-		      post_crypt(req);
-
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return err;
-	}
-
-	exit_crypt(req);
-	return err;
-}
-
-static void decrypt_done(struct crypto_async_request *areq, int err)
-{
-	struct skcipher_request *req = areq->data;
-	struct skcipher_request *subreq;
-	struct rctx *rctx;
-
-	rctx = skcipher_request_ctx(req);
-
-	if (err == -EINPROGRESS) {
-		if (rctx->left != req->cryptlen)
-			return;
-		goto out;
-	}
+	struct skcipher_request *subreq = &rctx->subreq;
 
-	subreq = &rctx->subreq;
-	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
-
-	err = do_decrypt(req, err ?: post_crypt(req));
-	if (rctx->left)
-		return;
-
-out:
-	skcipher_request_complete(req, err);
+	init_crypt(req);
+	return xor_tweak(req, req) ?:
+		crypto_skcipher_encrypt(subreq) ?:
+		xor_tweak(req, subreq);
 }
 
 static int decrypt(struct skcipher_request *req)
 {
-	return do_decrypt(req, init_crypt(req, decrypt_done));
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &rctx->subreq;
+
+	init_crypt(req);
+	return xor_tweak(req, req) ?:
+		crypto_skcipher_decrypt(subreq) ?:
+		xor_tweak(req, subreq);
 }
 
 static int init_tfm(struct crypto_skcipher *tfm)
-- 
2.17.1
