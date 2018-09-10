From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/4] crypto: arm64/aes-blk - remove pointless (u8 *) casts
Date: Mon, 10 Sep 2018 16:41:12 +0200
Message-ID: <20180910144115.25727-2-ard.biesheuvel@linaro.org>
References: <20180910144115.25727-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Theodore Ts'o <tytso@mit.edu>,
 herbert@gondor.apana.org.au, Steve Capper <steve.capper@arm.com>,
 Eric Biggers <ebiggers@google.com>, linux-arm-kernel@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180910144115.25727-1-ard.biesheuvel@linaro.org>
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

For some reason, the asmlinkage prototypes of the NEON routines take
u8[] arguments for the round key arrays, while the actual round keys
are arrays of u32, and so passing them into those routines requires
u8* casts at each occurrence. Fix that.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 47 ++++++++++----------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index adcb83eb683c..1c6934544c1f 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -63,24 +63,24 @@ MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 /* defined in aes-modes.S */
-asmlinkage void aes_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void aes_ecb_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks);
-asmlinkage void aes_ecb_decrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void aes_ecb_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks);
 
-asmlinkage void aes_cbc_encrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks, u8 iv[]);
-asmlinkage void aes_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void aes_cbc_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks, u8 iv[]);
 
-asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks, u8 ctr[]);
 
-asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[],
-				int rounds, int blocks, u8 const rk2[], u8 iv[],
+asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
+				int rounds, int blocks, u32 const rk2[], u8 iv[],
 				int first);
-asmlinkage void aes_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[],
-				int rounds, int blocks, u8 const rk2[], u8 iv[],
+asmlinkage void aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[],
+				int rounds, int blocks, u32 const rk2[], u8 iv[],
 				int first);
 
 asmlinkage void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
@@ -142,7 +142,7 @@ static int ecb_encrypt(struct skcipher_request *req)
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
 		aes_ecb_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_enc, rounds, blocks);
+				ctx->key_enc, rounds, blocks);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -162,7 +162,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
 		aes_ecb_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_dec, rounds, blocks);
+				ctx->key_dec, rounds, blocks);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -182,7 +182,7 @@ static int cbc_encrypt(struct skcipher_request *req)
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
 		aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_enc, rounds, blocks, walk.iv);
+				ctx->key_enc, rounds, blocks, walk.iv);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -202,7 +202,7 @@ static int cbc_decrypt(struct skcipher_request *req)
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
 		aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_dec, rounds, blocks, walk.iv);
+				ctx->key_dec, rounds, blocks, walk.iv);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -222,7 +222,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
 		aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key_enc, rounds, blocks, walk.iv);
+				ctx->key_enc, rounds, blocks, walk.iv);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -238,7 +238,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 		blocks = -1;
 
 		kernel_neon_begin();
-		aes_ctr_encrypt(tail, NULL, (u8 *)ctx->key_enc, rounds,
+		aes_ctr_encrypt(tail, NULL, ctx->key_enc, rounds,
 				blocks, walk.iv);
 		kernel_neon_end();
 		crypto_xor_cpy(tdst, tsrc, tail, nbytes);
@@ -272,8 +272,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
 		kernel_neon_begin();
 		aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key1.key_enc, rounds, blocks,
-				(u8 *)ctx->key2.key_enc, walk.iv, first);
+				ctx->key1.key_enc, rounds, blocks,
+				ctx->key2.key_enc, walk.iv, first);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -294,8 +294,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
 		kernel_neon_begin();
 		aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				(u8 *)ctx->key1.key_dec, rounds, blocks,
-				(u8 *)ctx->key2.key_enc, walk.iv, first);
+				ctx->key1.key_dec, rounds, blocks,
+				ctx->key2.key_enc, walk.iv, first);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -412,7 +412,6 @@ static int cmac_setkey(struct crypto_shash *tfm, const u8 *in_key,
 {
 	struct mac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
 	be128 *consts = (be128 *)ctx->consts;
-	u8 *rk = (u8 *)ctx->key.key_enc;
 	int rounds = 6 + key_len / 4;
 	int err;
 
@@ -422,7 +421,8 @@ static int cmac_setkey(struct crypto_shash *tfm, const u8 *in_key,
 
 	/* encrypt the zero vector */
 	kernel_neon_begin();
-	aes_ecb_encrypt(ctx->consts, (u8[AES_BLOCK_SIZE]){}, rk, rounds, 1);
+	aes_ecb_encrypt(ctx->consts, (u8[AES_BLOCK_SIZE]){}, ctx->key.key_enc,
+			rounds, 1);
 	kernel_neon_end();
 
 	cmac_gf128_mul_by_x(consts, consts);
@@ -441,7 +441,6 @@ static int xcbc_setkey(struct crypto_shash *tfm, const u8 *in_key,
 	};
 
 	struct mac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
-	u8 *rk = (u8 *)ctx->key.key_enc;
 	int rounds = 6 + key_len / 4;
 	u8 key[AES_BLOCK_SIZE];
 	int err;
@@ -451,8 +450,8 @@ static int xcbc_setkey(struct crypto_shash *tfm, const u8 *in_key,
 		return err;
 
 	kernel_neon_begin();
-	aes_ecb_encrypt(key, ks[0], rk, rounds, 1);
-	aes_ecb_encrypt(ctx->consts, ks[1], rk, rounds, 2);
+	aes_ecb_encrypt(key, ks[0], ctx->key.key_enc, rounds, 1);
+	aes_ecb_encrypt(ctx->consts, ks[1], ctx->key.key_enc, rounds, 2);
 	kernel_neon_end();
 
 	return cbcmac_setkey(tfm, key, sizeof(key));
-- 
2.18.0
