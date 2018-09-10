From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/4] crypto: arm64/aes-blk - add support for CTS-CBC mode
Date: Mon, 10 Sep 2018 16:41:14 +0200
Message-ID: <20180910144115.25727-4-ard.biesheuvel@linaro.org>
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

Currently, we rely on the generic CTS chaining mode wrapper to
instantiate the cts(cbc(aes)) skcipher. Due to the high performance
of the ARMv8 Crypto Extensions AES instructions (~1 cycles per byte),
any overhead in the chaining mode layers is amplified, and so it pays
off considerably to fold the CTS handling into the SIMD routines.

On Cortex-A53, this results in a ~50% speedup for smaller input sizes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
This patch supersedes '[RFC/RFT PATCH] crypto: arm64/aes-ce - add support
for CTS-CBC mode' sent out last Saturday.

Changes:
- keep subreq and scatterlist in request ctx structure
- optimize away second scatterwalk_ffwd() invocation when encrypting in-place
- keep permute table in .rodata section
- polish asm code (drop literal + offset reference, reorder insns)

Raw performance numbers after the patch.

 arch/arm64/crypto/aes-glue.c  | 165 ++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S |  79 +++++++++-
 2 files changed, 243 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 1c6934544c1f..26d2b0263ba6 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -15,6 +15,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <crypto/xts.h>
@@ -31,6 +32,8 @@
 #define aes_ecb_decrypt		ce_aes_ecb_decrypt
 #define aes_cbc_encrypt		ce_aes_cbc_encrypt
 #define aes_cbc_decrypt		ce_aes_cbc_decrypt
+#define aes_cbc_cts_encrypt	ce_aes_cbc_cts_encrypt
+#define aes_cbc_cts_decrypt	ce_aes_cbc_cts_decrypt
 #define aes_ctr_encrypt		ce_aes_ctr_encrypt
 #define aes_xts_encrypt		ce_aes_xts_encrypt
 #define aes_xts_decrypt		ce_aes_xts_decrypt
@@ -45,6 +48,8 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_ecb_decrypt		neon_aes_ecb_decrypt
 #define aes_cbc_encrypt		neon_aes_cbc_encrypt
 #define aes_cbc_decrypt		neon_aes_cbc_decrypt
+#define aes_cbc_cts_encrypt	neon_aes_cbc_cts_encrypt
+#define aes_cbc_cts_decrypt	neon_aes_cbc_cts_decrypt
 #define aes_ctr_encrypt		neon_aes_ctr_encrypt
 #define aes_xts_encrypt		neon_aes_xts_encrypt
 #define aes_xts_decrypt		neon_aes_xts_decrypt
@@ -73,6 +78,11 @@ asmlinkage void aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
 asmlinkage void aes_cbc_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks, u8 iv[]);
 
+asmlinkage void aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				int rounds, int bytes, u8 const iv[]);
+asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
+				int rounds, int bytes, u8 const iv[]);
+
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks, u8 ctr[]);
 
@@ -87,6 +97,12 @@ asmlinkage void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
 			       int blocks, u8 dg[], int enc_before,
 			       int enc_after);
 
+struct cts_cbc_req_ctx {
+	struct scatterlist sg_src[2];
+	struct scatterlist sg_dst[2];
+	struct skcipher_request subreq;
+};
+
 struct crypto_aes_xts_ctx {
 	struct crypto_aes_ctx key1;
 	struct crypto_aes_ctx __aligned(8) key2;
@@ -209,6 +225,136 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int cts_cbc_init_tfm(struct crypto_skcipher *tfm)
+{
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct cts_cbc_req_ctx));
+	return 0;
+}
+
+static int cts_cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct cts_cbc_req_ctx *rctx = skcipher_request_ctx(req);
+	int err, rounds = 6 + ctx->key_length / 4;
+	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
+	struct scatterlist *src = req->src, *dst = req->dst;
+	struct skcipher_walk walk;
+
+	skcipher_request_set_tfm(&rctx->subreq, tfm);
+
+	if (req->cryptlen == AES_BLOCK_SIZE)
+		cbc_blocks = 1;
+
+	if (cbc_blocks > 0) {
+		unsigned int blocks;
+
+		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
+					   cbc_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+
+		err = skcipher_walk_virt(&walk, &rctx->subreq, false);
+
+		while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+			kernel_neon_begin();
+			aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+					ctx->key_enc, rounds, blocks, walk.iv);
+			kernel_neon_end();
+			err = skcipher_walk_done(&walk,
+						 walk.nbytes % AES_BLOCK_SIZE);
+		}
+		if (err)
+			return err;
+
+		if (req->cryptlen == AES_BLOCK_SIZE)
+			return 0;
+
+		dst = src = scatterwalk_ffwd(rctx->sg_src, req->src,
+					     rctx->subreq.cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(rctx->sg_dst, req->dst,
+					       rctx->subreq.cryptlen);
+	}
+
+	/* handle ciphertext stealing */
+	skcipher_request_set_crypt(&rctx->subreq, src, dst,
+				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, &rctx->subreq, false);
+	if (err)
+		return err;
+
+	kernel_neon_begin();
+	aes_cbc_cts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			    ctx->key_enc, rounds, walk.nbytes, walk.iv);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
+}
+
+static int cts_cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct cts_cbc_req_ctx *rctx = skcipher_request_ctx(req);
+	int err, rounds = 6 + ctx->key_length / 4;
+	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
+	struct scatterlist *src = req->src, *dst = req->dst;
+	struct skcipher_walk walk;
+
+	skcipher_request_set_tfm(&rctx->subreq, tfm);
+
+	if (req->cryptlen == AES_BLOCK_SIZE)
+		cbc_blocks = 1;
+
+	if (cbc_blocks > 0) {
+		unsigned int blocks;
+
+		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
+					   cbc_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+
+		err = skcipher_walk_virt(&walk, &rctx->subreq, false);
+
+		while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+			kernel_neon_begin();
+			aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+					ctx->key_dec, rounds, blocks, walk.iv);
+			kernel_neon_end();
+			err = skcipher_walk_done(&walk,
+						 walk.nbytes % AES_BLOCK_SIZE);
+		}
+		if (err)
+			return err;
+
+		if (req->cryptlen == AES_BLOCK_SIZE)
+			return 0;
+
+		dst = src = scatterwalk_ffwd(rctx->sg_src, req->src,
+					     rctx->subreq.cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(rctx->sg_dst, req->dst,
+					       rctx->subreq.cryptlen);
+	}
+
+	/* handle ciphertext stealing */
+	skcipher_request_set_crypt(&rctx->subreq, src, dst,
+				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, &rctx->subreq, false);
+	if (err)
+		return err;
+
+	kernel_neon_begin();
+	aes_cbc_cts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			    ctx->key_dec, rounds, walk.nbytes, walk.iv);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -334,6 +480,25 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey		= skcipher_aes_setkey,
 	.encrypt	= cbc_encrypt,
 	.decrypt	= cbc_decrypt,
+}, {
+	.base = {
+		.cra_name		= "__cts(cbc(aes))",
+		.cra_driver_name	= "__cts-cbc-aes-" MODE,
+		.cra_priority		= PRIO,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.walksize	= 2 * AES_BLOCK_SIZE,
+	.setkey		= skcipher_aes_setkey,
+	.encrypt	= cts_cbc_encrypt,
+	.decrypt	= cts_cbc_decrypt,
+	.init		= cts_cbc_init_tfm,
 }, {
 	.base = {
 		.cra_name		= "__ctr(aes)",
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 35632d11200f..82931fba53d2 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -170,6 +170,84 @@ AES_ENTRY(aes_cbc_decrypt)
 AES_ENDPROC(aes_cbc_decrypt)
 
 
+	/*
+	 * aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
+	 *		       int rounds, int bytes, u8 const iv[])
+	 * aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
+	 *		       int rounds, int bytes, u8 const iv[])
+	 */
+
+AES_ENTRY(aes_cbc_cts_encrypt)
+	adr_l		x8, .Lcts_permute_table
+	sub		x4, x4, #16
+	add		x9, x8, #32
+	add		x8, x8, x4
+	sub		x9, x9, x4
+	ld1		{v3.16b}, [x8]
+	ld1		{v4.16b}, [x9]
+
+	ld1		{v0.16b}, [x1], x4		/* overlapping loads */
+	ld1		{v1.16b}, [x1]
+
+	ld1		{v5.16b}, [x5]			/* get iv */
+	enc_prepare	w3, x2, x6
+
+	eor		v0.16b, v0.16b, v5.16b		/* xor with iv */
+	tbl		v1.16b, {v1.16b}, v4.16b
+	encrypt_block	v0, w3, x2, x6, w7
+
+	eor		v1.16b, v1.16b, v0.16b
+	tbl		v0.16b, {v0.16b}, v3.16b
+	encrypt_block	v1, w3, x2, x6, w7
+
+	add		x4, x0, x4
+	st1		{v0.16b}, [x4]			/* overlapping stores */
+	st1		{v1.16b}, [x0]
+	ret
+AES_ENDPROC(aes_cbc_cts_encrypt)
+
+AES_ENTRY(aes_cbc_cts_decrypt)
+	adr_l		x8, .Lcts_permute_table
+	sub		x4, x4, #16
+	add		x9, x8, #32
+	add		x8, x8, x4
+	sub		x9, x9, x4
+	ld1		{v3.16b}, [x8]
+	ld1		{v4.16b}, [x9]
+
+	ld1		{v0.16b}, [x1], x4		/* overlapping loads */
+	ld1		{v1.16b}, [x1]
+
+	ld1		{v5.16b}, [x5]			/* get iv */
+	dec_prepare	w3, x2, x6
+
+	tbl		v2.16b, {v1.16b}, v4.16b
+	decrypt_block	v0, w3, x2, x6, w7
+	eor		v2.16b, v2.16b, v0.16b
+
+	tbx		v0.16b, {v1.16b}, v4.16b
+	tbl		v2.16b, {v2.16b}, v3.16b
+	decrypt_block	v0, w3, x2, x6, w7
+	eor		v0.16b, v0.16b, v5.16b		/* xor with iv */
+
+	add		x4, x0, x4
+	st1		{v2.16b}, [x4]			/* overlapping stores */
+	st1		{v0.16b}, [x0]
+	ret
+AES_ENDPROC(aes_cbc_cts_decrypt)
+
+	.section	".rodata", "a"
+	.align		6
+.Lcts_permute_table:
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		 0x0,  0x1,  0x2,  0x3,  0x4,  0x5,  0x6,  0x7
+	.byte		 0x8,  0x9,  0xa,  0xb,  0xc,  0xd,  0xe,  0xf
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.previous
+
+
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int blocks, u8 ctr[])
@@ -253,7 +331,6 @@ AES_ENTRY(aes_ctr_encrypt)
 	ins		v4.d[0], x7
 	b		.Lctrcarrydone
 AES_ENDPROC(aes_ctr_encrypt)
-	.ltorg
 
 
 	/*
-- 
2.18.0

Cortex-A53 @ 1 GHz

BEFORE:

testing speed of async cts(cbc(aes)) (cts(cbc-aes-ce)) encryption
 0 (128 bit key,   16 byte blocks): 1407866 ops in 1 secs ( 22525856 bytes)
 1 (128 bit key,   64 byte blocks):  466814 ops in 1 secs ( 29876096 bytes)
 2 (128 bit key,  256 byte blocks):  401023 ops in 1 secs (102661888 bytes)
 3 (128 bit key, 1024 byte blocks):  258238 ops in 1 secs (264435712 bytes)
 4 (128 bit key, 8192 byte blocks):   57905 ops in 1 secs (474357760 bytes)
 5 (192 bit key,   16 byte blocks): 1388333 ops in 1 secs ( 22213328 bytes)
 6 (192 bit key,   64 byte blocks):  448595 ops in 1 secs ( 28710080 bytes)
 7 (192 bit key,  256 byte blocks):  376951 ops in 1 secs ( 96499456 bytes)
 8 (192 bit key, 1024 byte blocks):  231635 ops in 1 secs (237194240 bytes)
 9 (192 bit key, 8192 byte blocks):   43345 ops in 1 secs (355082240 bytes)
10 (256 bit key,   16 byte blocks): 1370820 ops in 1 secs ( 21933120 bytes)
11 (256 bit key,   64 byte blocks):  452352 ops in 1 secs ( 28950528 bytes)
12 (256 bit key,  256 byte blocks):  376506 ops in 1 secs ( 96385536 bytes)
13 (256 bit key, 1024 byte blocks):  223219 ops in 1 secs (228576256 bytes)
14 (256 bit key, 8192 byte blocks):   44874 ops in 1 secs (367607808 bytes)

testing speed of async cts(cbc(aes)) (cts(cbc-aes-ce)) decryption
 0 (128 bit key,   16 byte blocks): 1402795 ops in 1 secs ( 22444720 bytes)
 1 (128 bit key,   64 byte blocks):  403300 ops in 1 secs ( 25811200 bytes)
 2 (128 bit key,  256 byte blocks):  367710 ops in 1 secs ( 94133760 bytes)
 3 (128 bit key, 1024 byte blocks):  269118 ops in 1 secs (275576832 bytes)
 4 (128 bit key, 8192 byte blocks):   74706 ops in 1 secs (611991552 bytes)
 5 (192 bit key,   16 byte blocks): 1381390 ops in 1 secs ( 22102240 bytes)
 6 (192 bit key,   64 byte blocks):  388555 ops in 1 secs ( 24867520 bytes)
 7 (192 bit key,  256 byte blocks):  350282 ops in 1 secs ( 89672192 bytes)
 8 (192 bit key, 1024 byte blocks):  251268 ops in 1 secs (257298432 bytes)
 9 (192 bit key, 8192 byte blocks):   56535 ops in 1 secs (463134720 bytes)
10 (256 bit key,   16 byte blocks): 1364334 ops in 1 secs ( 21829344 bytes)
11 (256 bit key,   64 byte blocks):  392610 ops in 1 secs ( 25127040 bytes)
12 (256 bit key,  256 byte blocks):  351150 ops in 1 secs ( 89894400 bytes)
13 (256 bit key, 1024 byte blocks):  247455 ops in 1 secs (253393920 bytes)
14 (256 bit key, 8192 byte blocks):   62530 ops in 1 secs (512245760 bytes)

AFTER:

testing speed of async cts(cbc(aes)) (cts-cbc-aes-ce) encryption
 0 (128 bit key,   16 byte blocks): 1380568 ops in 1 secs ( 22089088 bytes)
 1 (128 bit key,   64 byte blocks):  692731 ops in 1 secs ( 44334784 bytes)
 2 (128 bit key,  256 byte blocks):  556393 ops in 1 secs (142436608 bytes)
 3 (128 bit key, 1024 byte blocks):  314635 ops in 1 secs (322186240 bytes)
 4 (128 bit key, 8192 byte blocks):   57550 ops in 1 secs (471449600 bytes)
 5 (192 bit key,   16 byte blocks): 1367027 ops in 1 secs ( 21872432 bytes)
 6 (192 bit key,   64 byte blocks):  675058 ops in 1 secs ( 43203712 bytes)
 7 (192 bit key,  256 byte blocks):  523177 ops in 1 secs (133933312 bytes)
 8 (192 bit key, 1024 byte blocks):  279235 ops in 1 secs (285936640 bytes)
 9 (192 bit key, 8192 byte blocks):   46316 ops in 1 secs (379420672 bytes)
10 (256 bit key,   16 byte blocks): 1353576 ops in 1 secs ( 21657216 bytes)
11 (256 bit key,   64 byte blocks):  664523 ops in 1 secs ( 42529472 bytes)
12 (256 bit key,  256 byte blocks):  508141 ops in 1 secs (130084096 bytes)
13 (256 bit key, 1024 byte blocks):  264386 ops in 1 secs (270731264 bytes)
14 (256 bit key, 8192 byte blocks):   47224 ops in 1 secs (386859008 bytes)

testing speed of async cts(cbc(aes)) (cts-cbc-aes-ce) decryption
 0 (128 bit key,   16 byte blocks): 1388553 ops in 1 secs ( 22216848 bytes)
 1 (128 bit key,   64 byte blocks):  688402 ops in 1 secs ( 44057728 bytes)
 2 (128 bit key,  256 byte blocks):  589268 ops in 1 secs (150852608 bytes)
 3 (128 bit key, 1024 byte blocks):  372238 ops in 1 secs (381171712 bytes)
 4 (128 bit key, 8192 byte blocks):   75691 ops in 1 secs (620060672 bytes)
 5 (192 bit key,   16 byte blocks): 1366220 ops in 1 secs ( 21859520 bytes)
 6 (192 bit key,   64 byte blocks):  666889 ops in 1 secs ( 42680896 bytes)
 7 (192 bit key,  256 byte blocks):  561809 ops in 1 secs (143823104 bytes)
 8 (192 bit key, 1024 byte blocks):  344117 ops in 1 secs (352375808 bytes)
 9 (192 bit key, 8192 byte blocks):   63150 ops in 1 secs (517324800 bytes)
10 (256 bit key,   16 byte blocks): 1349266 ops in 1 secs ( 21588256 bytes)
11 (256 bit key,   64 byte blocks):  661056 ops in 1 secs ( 42307584 bytes)
12 (256 bit key,  256 byte blocks):  550261 ops in 1 secs (140866816 bytes)
13 (256 bit key, 1024 byte blocks):  332947 ops in 1 secs (340937728 bytes)
14 (256 bit key, 8192 byte blocks):   68759 ops in 1 secs (563273728 bytes)
