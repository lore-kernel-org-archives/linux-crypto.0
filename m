From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/6] crypto: arm/aes-neonbs - process 8 blocks in parallel if
 we can
Date: Mon,  2 Jan 2017 18:21:04 +0000
Message-ID: <1483381268-12987-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

The bit-sliced NEON implementation of AES only performs optimally if
it can process 8 blocks of input in parallel. This is due to the nature
of bit slicing, where the n-th bit of each byte of AES state of each input
block is collected into NEON register 'n', for registers q0 - q7.

This implies that the amount of work for the transform is fixed,
regardless of whether we are handling just one block or 8 in parallel.

So let's try a bit harder to iterate over the input in suitably sized
chunks, by setting the newly introduced walksize attribute to 8x the value
of AES_BLOCK_SIZE, and tweaking the loops to only process multiples of the
walk size, unless we are handling the last chunk in the input stream.

Note that the skcipher walk API guarantees that a step in the walk never
returns less than 'walksize' bytes if there are at least that many bytes
of input still available. However, it does *not* guarantee that those steps
produce an exact multiple of the walk size.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aesbs-glue.c | 67 +++++++++++---------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index d8e06de72ef3..f3019333c2eb 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -121,39 +121,26 @@ static int aesbs_cbc_encrypt(struct skcipher_request *req)
 	return crypto_cbc_encrypt_walk(req, aesbs_encrypt_one);
 }
 
-static inline void aesbs_decrypt_one(struct crypto_skcipher *tfm,
-				     const u8 *src, u8 *dst)
-{
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	AES_decrypt(src, dst, &ctx->dec.rk);
-}
-
 static int aesbs_cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
-	unsigned int nbytes;
 	int err;
 
-	for (err = skcipher_walk_virt(&walk, req, false);
-	     (nbytes = walk.nbytes); err = skcipher_walk_done(&walk, nbytes)) {
-		u32 blocks = nbytes / AES_BLOCK_SIZE;
-		u8 *dst = walk.dst.virt.addr;
-		u8 *src = walk.src.virt.addr;
-		u8 *iv = walk.iv;
-
-		if (blocks >= 8) {
-			kernel_neon_begin();
-			bsaes_cbc_encrypt(src, dst, nbytes, &ctx->dec, iv);
-			kernel_neon_end();
-			nbytes %= AES_BLOCK_SIZE;
-			continue;
-		}
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
 
-		nbytes = crypto_cbc_decrypt_blocks(&walk, tfm,
-						   aesbs_decrypt_one);
+		kernel_neon_begin();
+		bsaes_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
+				  nbytes, &ctx->dec, walk.iv);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 	return err;
 }
@@ -186,6 +173,12 @@ static int aesbs_ctr_encrypt(struct skcipher_request *req)
 		__be32 *ctr = (__be32 *)walk.iv;
 		u32 headroom = UINT_MAX - be32_to_cpu(ctr[3]);
 
+		if (walk.nbytes < walk.total) {
+			blocks = round_down(blocks,
+					    walk.stride / AES_BLOCK_SIZE);
+			tail = walk.nbytes - blocks * AES_BLOCK_SIZE;
+		}
+
 		/* avoid 32 bit counter overflow in the NEON code */
 		if (unlikely(headroom < blocks)) {
 			blocks = headroom + 1;
@@ -198,6 +191,9 @@ static int aesbs_ctr_encrypt(struct skcipher_request *req)
 		kernel_neon_end();
 		inc_be128_ctr(ctr, blocks);
 
+		if (tail > 0 && tail < AES_BLOCK_SIZE)
+			break;
+
 		err = skcipher_walk_done(&walk, tail);
 	}
 	if (walk.nbytes) {
@@ -227,11 +223,16 @@ static int aesbs_xts_encrypt(struct skcipher_request *req)
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
 
 	while (walk.nbytes) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
 		kernel_neon_begin();
 		bsaes_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
-				  walk.nbytes, &ctx->enc, walk.iv);
+				  nbytes, &ctx->enc, walk.iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 	return err;
 }
@@ -249,11 +250,16 @@ static int aesbs_xts_decrypt(struct skcipher_request *req)
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
 
 	while (walk.nbytes) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
 		kernel_neon_begin();
 		bsaes_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
-				  walk.nbytes, &ctx->dec, walk.iv);
+				  nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 	return err;
 }
@@ -272,6 +278,7 @@ static struct skcipher_alg aesbs_algs[] = { {
 	.min_keysize	= AES_MIN_KEY_SIZE,
 	.max_keysize	= AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.walksize	= 8 * AES_BLOCK_SIZE,
 	.setkey		= aesbs_cbc_set_key,
 	.encrypt	= aesbs_cbc_encrypt,
 	.decrypt	= aesbs_cbc_decrypt,
@@ -290,6 +297,7 @@ static struct skcipher_alg aesbs_algs[] = { {
 	.max_keysize	= AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
 	.chunksize	= AES_BLOCK_SIZE,
+	.walksize	= 8 * AES_BLOCK_SIZE,
 	.setkey		= aesbs_ctr_set_key,
 	.encrypt	= aesbs_ctr_encrypt,
 	.decrypt	= aesbs_ctr_encrypt,
@@ -307,6 +315,7 @@ static struct skcipher_alg aesbs_algs[] = { {
 	.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize	= 2 * AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.walksize	= 8 * AES_BLOCK_SIZE,
 	.setkey		= aesbs_xts_set_key,
 	.encrypt	= aesbs_xts_encrypt,
 	.decrypt	= aesbs_xts_decrypt,
-- 
2.7.4
