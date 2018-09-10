From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2 2/2] crypto: lrw - Do not use auxiliary buffer
Date: Mon, 10 Sep 2018 13:31:34 +0200
Message-ID: <20180910113134.24103-3-omosnace@redhat.com>
References: <20180910113134.24103-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180910113134.24103-1-omosnace@redhat.com>
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

This patch simplifies the LRW template to recompute the LRW tweaks from
scratch in the second pass and thus also removes the need to allocate a
dynamic buffer using kmalloc().

As discussed at [1], the use of kmalloc causes deadlocks with dm-crypt.

PERFORMANCE MEASUREMENTS (x86_64)
Performed using: https://gitlab.com/omos/linux-crypto-bench
Crypto driver used: lrw(ecb-aes-aesni)

The results show that the new code has about the same performance as the
old code. For 512-byte message it seems to be even slightly faster, but
that might be just noise.

Before:
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

After:
       ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
        lrw(aes)     256              64             197             196
        lrw(aes)     320              64             200             197
        lrw(aes)     384              64             203             199
        lrw(aes)     256             512             385             380
        lrw(aes)     320             512             401             395
        lrw(aes)     384             512             415             415
        lrw(aes)     256            4096            1869            1846
        lrw(aes)     320            4096            2080            1981
        lrw(aes)     384            4096            2160            2109
        lrw(aes)     256           16384            7077            7127
        lrw(aes)     320           16384            7807            7766
        lrw(aes)     384           16384            8108            8357
        lrw(aes)     256           32768           14111           14454
        lrw(aes)     320           32768           15268           15082
        lrw(aes)     384           32768           16581           16250

[1] https://lkml.org/lkml/2018/8/23/1315

Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/lrw.c | 280 ++++++++++-----------------------------------------
 1 file changed, 51 insertions(+), 229 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index b4f30b6f16d6..6315a6a59589 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -29,8 +29,6 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
-#define LRW_BUFFER_SIZE 128u
-
 #define LRW_BLOCK_SIZE 16
 
 struct priv {
@@ -56,19 +54,7 @@ struct priv {
 };
 
 struct rctx {
-	be128 buf[LRW_BUFFER_SIZE / sizeof(be128)];
-
-	be128 t;
-
-	be128 *ext;
-
-	struct scatterlist srcbuf[2];
-	struct scatterlist dstbuf[2];
-	struct scatterlist *src;
-	struct scatterlist *dst;
-
-	unsigned int left;
-
+	be128 t, orig_iv;
 	struct skcipher_request subreq;
 };
 
@@ -135,86 +121,31 @@ static int next_index(u32 *counter)
 	return res;
 }
 
-static int post_crypt(struct skcipher_request *req)
+/*
+ * We compute the tweak masks twice (both before and after the ECB encryption or
+ * decryption) to avoid having to allocate a temporary buffer and/or make
+ * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
+ * just doing the gf128mul_x_ble() calls again.
+ */
+static int xor_tweak(struct skcipher_request *req, bool second_pass)
 {
-	struct rctx *rctx = skcipher_request_ctx(req);
-	be128 *buf = rctx->ext ?: rctx->buf;
-	struct skcipher_request *subreq;
 	const int bs = LRW_BLOCK_SIZE;
-	struct skcipher_walk w;
-	struct scatterlist *sg;
-	unsigned offset;
-	int err;
-
-	subreq = &rctx->subreq;
-	err = skcipher_walk_virt(&w, subreq, false);
-
-	while (w.nbytes) {
-		unsigned int avail = w.nbytes;
-		be128 *wdst;
-
-		wdst = w.dst.virt.addr;
-
-		do {
-			be128_xor(wdst, buf++, wdst);
-			wdst++;
-		} while ((avail -= bs) >= bs);
-
-		err = skcipher_walk_done(&w, avail);
-	}
-
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
-	return err;
-}
-
-static int pre_crypt(struct skcipher_request *req)
-{
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct rctx *rctx = skcipher_request_ctx(req);
 	struct priv *ctx = crypto_skcipher_ctx(tfm);
-	be128 *buf = rctx->ext ?: rctx->buf;
-	struct skcipher_request *subreq;
-	const int bs = LRW_BLOCK_SIZE;
+	struct rctx *rctx = skcipher_request_ctx(req);
+	be128 t = rctx->t;
 	struct skcipher_walk w;
-	struct scatterlist *sg;
-	unsigned cryptlen;
-	unsigned offset;
-	bool more;
 	__u32 *iv;
 	u32 counter[4];
 	int err;
 
-	subreq = &rctx->subreq;
-	skcipher_request_set_tfm(subreq, tfm);
-
-	cryptlen = subreq->cryptlen;
-	more = rctx->left > cryptlen;
-	if (!more)
-		cryptlen = rctx->left;
-
-	skcipher_request_set_crypt(subreq, rctx->src, rctx->dst,
-				   cryptlen, req->iv);
+	if (second_pass) {
+		req = &rctx->subreq;
+		/* set to our TFM to enforce correct alignment: */
+		skcipher_request_set_tfm(req, tfm);
+	}
 
-	err = skcipher_walk_virt(&w, subreq, false);
+	err = skcipher_walk_virt(&w, req, false);
 	iv = w.iv;
 
 	counter[0] = be32_to_cpu(iv[3]);
@@ -231,13 +162,11 @@ static int pre_crypt(struct skcipher_request *req)
 		wdst = w.dst.virt.addr;
 
 		do {
-			*buf++ = rctx->t;
-			be128_xor(wdst++, &rctx->t, wsrc++);
+			be128_xor(wdst++, &t, wsrc++);
 
 			/* T <- I*Key2, using the optimization
 			 * discussed in the specification */
-			be128_xor(&rctx->t, &rctx->t,
-				  &ctx->mulinc[next_index(counter)]);
+			be128_xor(&t, &t, &ctx->mulinc[next_index(counter)]);
 		} while ((avail -= bs) >= bs);
 
 		if (w.nbytes == w.total) {
@@ -250,175 +179,68 @@ static int pre_crypt(struct skcipher_request *req)
 		err = skcipher_walk_done(&w, avail);
 	}
 
-	skcipher_request_set_tfm(subreq, ctx->child);
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
 	return err;
 }
 
-static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
-{
-	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct rctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq;
-	gfp_t gfp;
-
-	subreq = &rctx->subreq;
-	skcipher_request_set_callback(subreq, req->base.flags, done, req);
-
-	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
-							   GFP_ATOMIC;
-	rctx->ext = NULL;
-
-	subreq->cryptlen = LRW_BUFFER_SIZE;
-	if (req->cryptlen > LRW_BUFFER_SIZE) {
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
-
-	/* calculate first value of T */
-	memcpy(&rctx->t, req->iv, sizeof(rctx->t));
-
-	/* T <- I*Key2 */
-	gf128mul_64k_bbe(&rctx->t, ctx->table);
-
-	return 0;
-}
-
-static void exit_crypt(struct skcipher_request *req)
+static int xor_tweak_pre(struct skcipher_request *req)
 {
-	struct rctx *rctx = skcipher_request_ctx(req);
-
-	rctx->left = 0;
-
-	if (rctx->ext)
-		kzfree(rctx->ext);
+	return xor_tweak(req, false);
 }
 
-static int do_encrypt(struct skcipher_request *req, int err)
+static int xor_tweak_post(struct skcipher_request *req)
 {
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
+	return xor_tweak(req, false);
 }
 
-static void encrypt_done(struct crypto_async_request *areq, int err)
+static void crypt_done(struct crypto_async_request *areq, int err)
 {
 	struct skcipher_request *req = areq->data;
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
 
-	subreq = &rctx->subreq;
-	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
+	if (!err)
+		err = xor_tweak_post(req);
 
-	err = do_encrypt(req, err ?: post_crypt(req));
-	if (rctx->left)
-		return;
-
-out:
 	skcipher_request_complete(req, err);
 }
 
-static int encrypt(struct skcipher_request *req)
-{
-	return do_encrypt(req, init_crypt(req, encrypt_done));
-}
-
-static int do_decrypt(struct skcipher_request *req, int err)
+static void init_crypt(struct skcipher_request *req)
 {
+	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	struct rctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq;
+	struct skcipher_request *subreq = &rctx->subreq;
 
-	subreq = &rctx->subreq;
-
-	while (!err && rctx->left) {
-		err = pre_crypt(req) ?:
-		      crypto_skcipher_decrypt(subreq) ?:
-		      post_crypt(req);
+	skcipher_request_set_tfm(subreq, ctx->child);
+	skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req);
+	skcipher_request_set_crypt(subreq, req->dst, req->dst,
+				   req->cryptlen, &rctx->orig_iv);
 
-		if (err == -EINPROGRESS || err == -EBUSY)
-			return err;
-	}
+	/* calculate first value of T */
+	memcpy(&rctx->orig_iv, req->iv, sizeof(rctx->t));
+	rctx->t = rctx->orig_iv;
 
-	exit_crypt(req);
-	return err;
+	/* T <- I*Key2 */
+	gf128mul_64k_bbe(&rctx->t, ctx->table);
 }
 
-static void decrypt_done(struct crypto_async_request *areq, int err)
+static int encrypt(struct skcipher_request *req)
 {
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
-	err = do_decrypt(req, err ?: post_crypt(req));
-	if (rctx->left)
-		return;
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &rctx->subreq;
 
-out:
-	skcipher_request_complete(req, err);
+	init_crypt(req);
+	return xor_tweak_pre(req) ?:
+		crypto_skcipher_encrypt(subreq) ?:
+		xor_tweak_post(req);
 }
 
 static int decrypt(struct skcipher_request *req)
 {
-	return do_decrypt(req, init_crypt(req, decrypt_done));
+	struct rctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &rctx->subreq;
+
+	init_crypt(req);
+	return xor_tweak_pre(req) ?:
+		crypto_skcipher_decrypt(subreq) ?:
+		xor_tweak_post(req);
 }
 
 static int init_tfm(struct crypto_skcipher *tfm)
-- 
2.17.1
