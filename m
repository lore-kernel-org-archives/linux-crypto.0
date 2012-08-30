From: David Miller <davem@davemloft.net>
Subject: [PATCH 2/5] sparc64: Add ctr mode support to AES driver.
Date: Thu, 30 Aug 2012 11:46:26 -0400 (EDT)
Message-ID: <20120830.114626.150800464951430349.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/crypto/aes_asm.S  |   95 ++++++++++++++++++++++++++++++++++++++++++
 arch/sparc/crypto/aes_glue.c |   62 +++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)

diff --git a/arch/sparc/crypto/aes_asm.S b/arch/sparc/crypto/aes_asm.S
index 50faae0..7a975d6 100644
--- a/arch/sparc/crypto/aes_asm.S
+++ b/arch/sparc/crypto/aes_asm.S
@@ -44,6 +44,8 @@
 	.word	0x85b02307;
 #define MOVXTOD_O0_F0		\
 	.word	0x81b02308;
+#define MOVXTOD_O5_F0		\
+	.word	0x81b0230d;
 #define MOVXTOD_O5_F2		\
 	.word	0x85b0230d;
 
@@ -1137,3 +1139,96 @@ ENTRY(aes_sparc64_cbc_decrypt_256)
 	retl
 	 nop
 ENDPROC(aes_sparc64_cbc_decrypt_256)
+
+	.align		32
+ENTRY(aes_sparc64_ctr_crypt_128)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldx		[%o4 + 0x00], %g3
+	ldx		[%o4 + 0x08], %g7
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+1:	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F0
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F2
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
+	ENCRYPT_128(8, 0, 2, 4, 6)
+	ldd		[%o1 + 0x00], %f4
+	ldd		[%o1 + 0x08], %f6
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o3, 0x10, %o3
+	add		%o1, 0x10, %o1
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+	stx		%g3, [%o4 + 0x00]
+	stx		%g7, [%o4 + 0x08]
+	retl
+	 nop
+ENDPROC(aes_sparc64_ctr_crypt_128)
+
+	.align		32
+ENTRY(aes_sparc64_ctr_crypt_192)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldx		[%o4 + 0x00], %g3
+	ldx		[%o4 + 0x08], %g7
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+1:	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F0
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F2
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
+	ENCRYPT_192(8, 0, 2, 4, 6)
+	ldd		[%o1 + 0x00], %f4
+	ldd		[%o1 + 0x08], %f6
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o3, 0x10, %o3
+	add		%o1, 0x10, %o1
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+	stx		%g3, [%o4 + 0x00]
+	stx		%g7, [%o4 + 0x08]
+	retl
+	 nop
+ENDPROC(aes_sparc64_ctr_crypt_192)
+
+	.align		32
+ENTRY(aes_sparc64_ctr_crypt_256)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldx		[%o4 + 0x00], %g3
+	ldx		[%o4 + 0x08], %g7
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+1:	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F0
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F2
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
+	ENCRYPT_256(8, 0, 2, 4, 6)
+	ldd		[%o1 + 0x00], %f4
+	ldd		[%o1 + 0x08], %f6
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o3, 0x10, %o3
+	add		%o1, 0x10, %o1
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+	stx		%g3, [%o4 + 0x00]
+	stx		%g7, [%o4 + 0x08]
+	retl
+	 nop
+ENDPROC(aes_sparc64_ctr_crypt_256)
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 0b1de0b..f457fc6 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -39,6 +39,8 @@ struct aes_ops {
 			    unsigned int len, u64 *iv);
 	void (*cbc_decrypt)(const u64 *key, const u64 *input, u64 *output,
 			    unsigned int len, u64 *iv);
+	void (*ctr_crypt)(const u64 *key, const u64 *input, u64 *output,
+			  unsigned int len, u64 *iv);
 };
 
 struct crypto_sparc64_aes_ctx {
@@ -108,6 +110,16 @@ extern void aes_sparc64_cbc_decrypt_256(const u64 *key, const u64 *input,
 					u64 *output, unsigned int len,
 					u64 *iv);
 
+extern void aes_sparc64_ctr_crypt_128(const u64 *key, const u64 *input,
+				      u64 *output, unsigned int len,
+				      u64 *iv);
+extern void aes_sparc64_ctr_crypt_192(const u64 *key, const u64 *input,
+				      u64 *output, unsigned int len,
+				      u64 *iv);
+extern void aes_sparc64_ctr_crypt_256(const u64 *key, const u64 *input,
+				      u64 *output, unsigned int len,
+				      u64 *iv);
+
 struct aes_ops aes128_ops = {
 	.encrypt		= aes_sparc64_encrypt_128,
 	.decrypt		= aes_sparc64_decrypt_128,
@@ -117,6 +129,7 @@ struct aes_ops aes128_ops = {
 	.ecb_decrypt		= aes_sparc64_ecb_decrypt_128,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_128,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_128,
+	.ctr_crypt		= aes_sparc64_ctr_crypt_128,
 };
 
 struct aes_ops aes192_ops = {
@@ -128,6 +141,7 @@ struct aes_ops aes192_ops = {
 	.ecb_decrypt		= aes_sparc64_ecb_decrypt_192,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_192,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_192,
+	.ctr_crypt		= aes_sparc64_ctr_crypt_192,
 };
 
 struct aes_ops aes256_ops = {
@@ -139,6 +153,7 @@ struct aes_ops aes256_ops = {
 	.ecb_decrypt		= aes_sparc64_ecb_decrypt_256,
 	.cbc_encrypt		= aes_sparc64_cbc_encrypt_256,
 	.cbc_decrypt		= aes_sparc64_cbc_decrypt_256,
+	.ctr_crypt		= aes_sparc64_ctr_crypt_256,
 };
 
 extern void aes_sparc64_key_expand(const u32 *in_key, u64 *output_key,
@@ -310,6 +325,34 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
+static int ctr_crypt(struct blkcipher_desc *desc,
+		     struct scatterlist *dst, struct scatterlist *src,
+		     unsigned int nbytes)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	ctx->ops->load_encrypt_keys(&ctx->key[0]);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & AES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			ctx->ops->ctr_crypt(&ctx->key[0],
+					    (const u64 *)walk.src.virt.addr,
+					    (u64 *) walk.dst.virt.addr,
+					    block_len, (u64 *) walk.iv);
+		}
+		nbytes &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
 static struct crypto_alg algs[] = { {
 	.cra_name		= "aes",
 	.cra_driver_name	= "aes-sparc64",
@@ -366,6 +409,25 @@ static struct crypto_alg algs[] = { {
 			.decrypt	= cbc_decrypt,
 		},
 	},
+}, {
+	.cra_name		= "ctr(aes)",
+	.cra_driver_name	= "ctr-aes-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
 } };
 
 static bool __init sparc64_has_aes_opcode(void)
-- 
1.7.10.4

