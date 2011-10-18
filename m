From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 12/18] crypto: xts: add interface for parallelized cipher
	implementations
Date: Tue, 18 Oct 2011 13:33:12 +0300
Message-ID: <20111018103312.3074.3979.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:39432 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKda (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:33:30 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add xts_crypt() function that can be used by cipher implementations that can
benefit from parallelized cipher operations.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/xts.c         |   74 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/xts.h |   27 ++++++++++++++++++
 2 files changed, 99 insertions(+), 2 deletions(-)
 create mode 100644 include/crypto/xts.h

diff --git a/crypto/xts.c b/crypto/xts.c
index 96f3f88..5681d66 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -21,11 +21,10 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 
+#include <crypto/xts.h>
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
-#define XTS_BLOCK_SIZE 16
-
 struct priv {
 	struct crypto_cipher *child;
 	struct crypto_cipher *tweak;
@@ -167,6 +166,77 @@ static int decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		     crypto_cipher_alg(ctx->child)->cia_decrypt);
 }
 
+int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
+	      struct scatterlist *ssrc, unsigned int nbytes,
+	      struct xts_crypt_req *req)
+{
+	const unsigned int bsize = XTS_BLOCK_SIZE;
+	const unsigned int max_blks = req->tbuflen / bsize;
+	struct blkcipher_walk walk;
+	unsigned int nblocks;
+	be128 *src, *dst, *t;
+	be128 *t_buf = req->tbuf;
+	int err, i;
+
+	BUG_ON(max_blks < 1);
+
+	blkcipher_walk_init(&walk, sdst, ssrc, nbytes);
+
+	err = blkcipher_walk_virt(desc, &walk);
+	nbytes = walk.nbytes;
+	if (!nbytes)
+		return err;
+
+	nblocks = min(nbytes / bsize, max_blks);
+	src = (be128 *)walk.src.virt.addr;
+	dst = (be128 *)walk.dst.virt.addr;
+
+	/* calculate first value of T */
+	req->tweak_fn(req->tweak_ctx, (u8 *)&t_buf[0], walk.iv);
+
+	i = 0;
+	goto first;
+
+	for (;;) {
+		do {
+			for (i = 0; i < nblocks; i++) {
+				gf128mul_x_ble(&t_buf[i], t);
+first:
+				t = &t_buf[i];
+
+				/* PP <- T xor P */
+				be128_xor(dst + i, t, src + i);
+			}
+
+			/* CC <- E(Key2,PP) */
+			req->crypt_fn(req->crypt_ctx, (u8 *)dst,
+				      nblocks * bsize);
+
+			/* C <- T xor CC */
+			for (i = 0; i < nblocks; i++)
+				be128_xor(dst + i, dst + i, &t_buf[i]);
+
+			src += nblocks;
+			dst += nblocks;
+			nbytes -= nblocks * bsize;
+			nblocks = min(nbytes / bsize, max_blks);
+		} while (nblocks > 0);
+
+		*(be128 *)walk.iv = *t;
+
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+		nbytes = walk.nbytes;
+		if (!nbytes)
+			break;
+
+		src = (be128 *)walk.src.virt.addr;
+		dst = (be128 *)walk.dst.virt.addr;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xts_crypt);
+
 static int init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
new file mode 100644
index 0000000..72c09eb
--- /dev/null
+++ b/include/crypto/xts.h
@@ -0,0 +1,27 @@
+#ifndef _CRYPTO_XTS_H
+#define _CRYPTO_XTS_H
+
+#include <crypto/b128ops.h>
+
+struct scatterlist;
+struct blkcipher_desc;
+
+#define XTS_BLOCK_SIZE 16
+
+struct xts_crypt_req {
+	be128 *tbuf;
+	unsigned int tbuflen;
+
+	void *tweak_ctx;
+	void (*tweak_fn)(void *ctx, u8* dst, const u8* src);
+	void *crypt_ctx;
+	void (*crypt_fn)(void *ctx, u8 *blks, unsigned int nbytes);
+};
+
+#define XTS_TWEAK_CAST(x) ((void (*)(void *, u8*, const u8*))(x))
+
+int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+	      struct scatterlist *src, unsigned int nbytes,
+	      struct xts_crypt_req *req);
+
+#endif  /* _CRYPTO_XTS_H */
