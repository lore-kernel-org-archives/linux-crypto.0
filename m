From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH] crypto: Add AES-NI accelerated CTR mode
Date: Mon, 01 Mar 2010 14:14:36 +0800
Message-ID: <1267424076.1640.82.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

To take advantage of the hardware pipeline implementation of AES-NI
instructions. CTR mode cryption is implemented in ASM to schedule
multiple AES-NI instructions one after another. This way, some latency
of AES-NI instruction can be eliminated.

Performance testing based on dm-crypt should 50% reduction of
ecryption/decryption time.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/crypto/aesni-intel_asm.S  |  115 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c |  130 +++++++++++++++++++++++++++++++++++--
 2 files changed, 238 insertions(+), 7 deletions(-)

--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -32,6 +32,9 @@
 #define IN	IN1
 #define KEY	%xmm2
 #define IV	%xmm3
+#define BSWAP_MASK %xmm10
+#define CTR	%xmm11
+#define INC	%xmm12
 
 #define KEYP	%rdi
 #define OUTP	%rsi
@@ -42,6 +45,7 @@
 #define T1	%r10
 #define TKEYP	T1
 #define T2	%r11
+#define TCTR_LOW T2
 
 _key_expansion_128:
 _key_expansion_256a:
@@ -724,3 +728,114 @@ ENTRY(aesni_cbc_dec)
 	movups IV, (IVP)
 .Lcbc_dec_just_ret:
 	ret
+
+.align 16
+.Lbswap_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
+/*
+ * _aesni_inc_init:	internal ABI
+ *	setup registers used by _aesni_inc
+ * input:
+ *	IV
+ * output:
+ *	CTR:	== IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ *	INC:	== 1, in little endian
+ *	BSWAP_MASK == endian swapping mask
+ */
+_aesni_inc_init:
+	movaps .Lbswap_mask, BSWAP_MASK
+	movaps IV, CTR
+	PSHUFB_XMM BSWAP_MASK CTR
+	mov $1, TCTR_LOW
+	movq TCTR_LOW, INC
+	movq CTR, TCTR_LOW
+	ret
+
+/*
+ * _aesni_inc:		internal ABI
+ *	Increase IV by 1, IV is in big endian
+ * input:
+ *	IV
+ *	CTR:	== IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ *	INC:	== 1, in little endian
+ *	BSWAP_MASK == endian swapping mask
+ * output:
+ *	IV:	Increase by 1
+ * changed:
+ *	CTR:	== output IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ */
+_aesni_inc:
+	paddq INC, CTR
+	add $1, TCTR_LOW
+	jnc .Linc_low
+	pslldq $8, INC
+	paddq INC, CTR
+	psrldq $8, INC
+.Linc_low:
+	movaps CTR, IV
+	PSHUFB_XMM BSWAP_MASK IV
+	ret
+
+/*
+ * void aesni_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+ENTRY(aesni_ctr_enc)
+	cmp $16, LEN
+	jb .Lctr_enc_just_ret
+	mov 480(KEYP), KLEN
+	movups (IVP), IV
+	call _aesni_inc_init
+	cmp $64, LEN
+	jb .Lctr_enc_loop1
+.align 4
+.Lctr_enc_loop4:
+	movaps IV, STATE1
+	call _aesni_inc
+	movups (INP), IN1
+	movaps IV, STATE2
+	call _aesni_inc
+	movups 0x10(INP), IN2
+	movaps IV, STATE3
+	call _aesni_inc
+	movups 0x20(INP), IN3
+	movaps IV, STATE4
+	call _aesni_inc
+	movups 0x30(INP), IN4
+	call _aesni_enc4
+	pxor IN1, STATE1
+	movups STATE1, (OUTP)
+	pxor IN2, STATE2
+	movups STATE2, 0x10(OUTP)
+	pxor IN3, STATE3
+	movups STATE3, 0x20(OUTP)
+	pxor IN4, STATE4
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lctr_enc_loop4
+	cmp $16, LEN
+	jb .Lctr_enc_ret
+.align 4
+.Lctr_enc_loop1:
+	movaps IV, STATE
+	call _aesni_inc
+	movups (INP), IN
+	call _aesni_enc1
+	pxor IN, STATE
+	movups STATE, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lctr_enc_loop1
+.Lctr_enc_ret:
+	movups IV, (IVP)
+.Lctr_enc_just_ret:
+	ret
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -18,6 +18,7 @@
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/cryptd.h>
+#include <crypto/ctr.h>
 #include <asm/i387.h>
 #include <asm/aes.h>
 
@@ -58,6 +59,8 @@ asmlinkage void aesni_cbc_enc(struct cry
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
 
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
@@ -321,6 +324,72 @@ static struct crypto_alg blk_cbc_alg = {
 	},
 };
 
+static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
+			    struct blkcipher_walk *walk)
+{
+	u8 *ctrblk = walk->iv;
+	u8 keystream[AES_BLOCK_SIZE];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	aesni_enc(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+	crypto_inc(ctrblk, AES_BLOCK_SIZE);
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc,
+		     struct scatterlist *dst, struct scatterlist *src,
+		     unsigned int nbytes)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_blkcipher_ctx(desc->tfm));
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	kernel_fpu_begin();
+	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			      nbytes & AES_BLOCK_MASK, walk.iv);
+		nbytes &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	if (walk.nbytes) {
+		ctr_crypt_final(ctx, &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+	kernel_fpu_end();
+
+	return err;
+}
+
+static struct crypto_alg blk_ctr_alg = {
+	.cra_name		= "__ctr-aes-aesni",
+	.cra_driver_name	= "__driver-ctr-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+};
+
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int key_len)
 {
@@ -467,13 +536,11 @@ static struct crypto_alg ablk_cbc_alg =
 	},
 };
 
-#ifdef HAS_CTR
 static int ablk_ctr_init(struct crypto_tfm *tfm)
 {
 	struct cryptd_ablkcipher *cryptd_tfm;
 
-	cryptd_tfm = cryptd_alloc_ablkcipher("fpu(ctr(__driver-aes-aesni))",
-					     0, 0);
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ctr-aes-aesni", 0, 0);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
 	ablk_init_common(tfm, cryptd_tfm);
@@ -500,11 +567,50 @@ static struct crypto_alg ablk_ctr_alg =
 			.ivsize		= AES_BLOCK_SIZE,
 			.setkey		= ablk_set_key,
 			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
+			.decrypt	= ablk_encrypt,
 			.geniv		= "chainiv",
 		},
 	},
 };
+
+#ifdef HAS_CTR
+static int ablk_rfc3686_ctr_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher(
+		"rfc3686(__driver-ctr-aes-aesni)", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_rfc3686_ctr_alg = {
+	.cra_name		= "rfc3686(ctr(aes))",
+	.cra_driver_name	= "rfc3686-ctr-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(ablk_rfc3686_ctr_alg.cra_list),
+	.cra_init		= ablk_rfc3686_ctr_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = AES_MIN_KEY_SIZE+CTR_RFC3686_NONCE_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE+CTR_RFC3686_NONCE_SIZE,
+			.ivsize	     = CTR_RFC3686_IV_SIZE,
+			.setkey	     = ablk_set_key,
+			.encrypt     = ablk_encrypt,
+			.decrypt     = ablk_decrypt,
+			.geniv	     = "seqiv",
+		},
+	},
+};
 #endif
 
 #ifdef HAS_LRW
@@ -640,13 +746,17 @@ static int __init aesni_init(void)
 		goto blk_ecb_err;
 	if ((err = crypto_register_alg(&blk_cbc_alg)))
 		goto blk_cbc_err;
+	if ((err = crypto_register_alg(&blk_ctr_alg)))
+		goto blk_ctr_err;
 	if ((err = crypto_register_alg(&ablk_ecb_alg)))
 		goto ablk_ecb_err;
 	if ((err = crypto_register_alg(&ablk_cbc_alg)))
 		goto ablk_cbc_err;
-#ifdef HAS_CTR
 	if ((err = crypto_register_alg(&ablk_ctr_alg)))
 		goto ablk_ctr_err;
+#ifdef HAS_CTR
+	if ((err = crypto_register_alg(&ablk_rfc3686_ctr_alg)))
+		goto ablk_rfc3686_ctr_err;
 #endif
 #ifdef HAS_LRW
 	if ((err = crypto_register_alg(&ablk_lrw_alg)))
@@ -675,13 +785,17 @@ ablk_pcbc_err:
 ablk_lrw_err:
 #endif
 #ifdef HAS_CTR
+	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
+ablk_rfc3686_ctr_err:
+#endif
 	crypto_unregister_alg(&ablk_ctr_alg);
 ablk_ctr_err:
-#endif
 	crypto_unregister_alg(&ablk_cbc_alg);
 ablk_cbc_err:
 	crypto_unregister_alg(&ablk_ecb_alg);
 ablk_ecb_err:
+	crypto_unregister_alg(&blk_ctr_alg);
+blk_ctr_err:
 	crypto_unregister_alg(&blk_cbc_alg);
 blk_cbc_err:
 	crypto_unregister_alg(&blk_ecb_alg);
@@ -705,10 +819,12 @@ static void __exit aesni_exit(void)
 	crypto_unregister_alg(&ablk_lrw_alg);
 #endif
 #ifdef HAS_CTR
-	crypto_unregister_alg(&ablk_ctr_alg);
+	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
 #endif
+	crypto_unregister_alg(&ablk_ctr_alg);
 	crypto_unregister_alg(&ablk_cbc_alg);
 	crypto_unregister_alg(&ablk_ecb_alg);
+	crypto_unregister_alg(&blk_ctr_alg);
 	crypto_unregister_alg(&blk_cbc_alg);
 	crypto_unregister_alg(&blk_ecb_alg);
 	crypto_unregister_alg(&__aesni_alg);
