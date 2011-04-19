From: jang@linux.vnet.ibm.com
Subject: [PATCH 3/8] s390: add System z hardware support for XTS mode
Date: Tue, 19 Apr 2011 21:29:16 +0200
Message-ID: <20110419193247.828957845@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:48597 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1DSTeF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:05 -0400
Received: from d06nrmr1307.portsmouth.uk.ibm.com (d06nrmr1307.portsmouth.uk.ibm.com [9.149.38.129])
	by mtagate4.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJXwr8010650
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:33:58 GMT
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1307.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYsTb1888362
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:54 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJXv4Z028562
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:33:58 -0600
Content-Disposition: inline; filename=crypto-xts.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

This patch adds System z hardware acceleration support for the AES XTS mode.
The hardware support is available beginning with System z196.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/crypto/aes_s390.c   |  147 ++++++++++++++++++++++++++++++++++++++++++
 arch/s390/crypto/crypt_s390.h |   31 ++++++++
 drivers/crypto/Kconfig        |   19 +----
 3 files changed, 184 insertions(+), 13 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -45,6 +45,23 @@ struct s390_aes_ctx {
 	} fallback;
 };
 
+struct pcc_param {
+	u8 key[32];
+	u8 tweak[16];
+	u8 block[16];
+	u8 bit[16];
+	u8 xts[16];
+};
+
+struct s390_xts_ctx {
+	u8 key[32];
+	u8 xts_param[16];
+	struct pcc_param pcc;
+	long enc;
+	long dec;
+	int key_len;
+};
+
 /*
  * Check if the key_len is supported by the HW.
  * Returns 0 if it is, a positive number if it is not and software fallback is
@@ -504,8 +521,120 @@ static struct crypto_alg cbc_aes_alg = {
 	}
 };
 
+static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+			   unsigned int key_len)
+{
+	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+
+	switch (key_len) {
+	case 32:
+		xts_ctx->enc = KM_XTS_128_ENCRYPT;
+		xts_ctx->dec = KM_XTS_128_DECRYPT;
+		memcpy(xts_ctx->key + 16, in_key, 16);
+		memcpy(xts_ctx->pcc.key + 16, in_key + 16, 16);
+		break;
+	case 64:
+		xts_ctx->enc = KM_XTS_256_ENCRYPT;
+		xts_ctx->dec = KM_XTS_256_DECRYPT;
+		memcpy(xts_ctx->key, in_key, 32);
+		memcpy(xts_ctx->pcc.key, in_key + 32, 32);
+		break;
+	default:
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+	xts_ctx->key_len = key_len;
+	return 0;
+}
+
+static int xts_aes_crypt(struct blkcipher_desc *desc, long func,
+			 struct s390_xts_ctx *xts_ctx,
+			 struct blkcipher_walk *walk)
+{
+	unsigned int offset = (xts_ctx->key_len >> 1) & 0x10;
+	int ret = blkcipher_walk_virt(desc, walk);
+	unsigned int nbytes = walk->nbytes;
+	unsigned int n;
+	u8 *in, *out;
+	void *param;
+
+	if (!nbytes)
+		goto out;
+
+	memset(xts_ctx->pcc.block, 0, sizeof(xts_ctx->pcc.block));
+	memset(xts_ctx->pcc.bit, 0, sizeof(xts_ctx->pcc.bit));
+	memset(xts_ctx->pcc.xts, 0, sizeof(xts_ctx->pcc.xts));
+	memcpy(xts_ctx->pcc.tweak, walk->iv, sizeof(xts_ctx->pcc.tweak));
+	param = xts_ctx->pcc.key + offset;
+	ret = crypt_s390_pcc(func, param);
+	BUG_ON(ret < 0);
+
+	memcpy(xts_ctx->xts_param, xts_ctx->pcc.xts, 16);
+	param = xts_ctx->key + offset;
+	do {
+		/* only use complete blocks */
+		n = nbytes & ~(AES_BLOCK_SIZE - 1);
+		out = walk->dst.virt.addr;
+		in = walk->src.virt.addr;
+
+		ret = crypt_s390_km(func, param, out, in, n);
+		BUG_ON(ret < 0 || ret != n);
+
+		nbytes &= AES_BLOCK_SIZE - 1;
+		ret = blkcipher_walk_done(desc, walk, nbytes);
+	} while ((nbytes = walk->nbytes));
+out:
+	return ret;
+}
+
+static int xts_aes_encrypt(struct blkcipher_desc *desc,
+			   struct scatterlist *dst, struct scatterlist *src,
+			   unsigned int nbytes)
+{
+	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return xts_aes_crypt(desc, xts_ctx->enc, xts_ctx, &walk);
+}
+
+static int xts_aes_decrypt(struct blkcipher_desc *desc,
+			   struct scatterlist *dst, struct scatterlist *src,
+			   unsigned int nbytes)
+{
+	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return xts_aes_crypt(desc, xts_ctx->dec, xts_ctx, &walk);
+}
+
+static struct crypto_alg xts_aes_alg = {
+	.cra_name		=	"xts(aes)",
+	.cra_driver_name	=	"xts-aes-s390",
+	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct s390_xts_ctx),
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(xts_aes_alg.cra_list),
+	.cra_u			=	{
+		.blkcipher = {
+			.min_keysize		=	2 * AES_MIN_KEY_SIZE,
+			.max_keysize		=	2 * AES_MAX_KEY_SIZE,
+			.ivsize			=	AES_BLOCK_SIZE,
+			.setkey			=	xts_aes_set_key,
+			.encrypt		=	xts_aes_encrypt,
+			.decrypt		=	xts_aes_decrypt,
+		}
+	}
+};
+
 static int __init aes_s390_init(void)
 {
+	unsigned long long facility_bits[2];
 	int ret;
 
 	if (crypt_s390_func_available(KM_AES_128_ENCRYPT, CRYPT_S390_MSA))
@@ -535,9 +664,26 @@ static int __init aes_s390_init(void)
 	if (ret)
 		goto cbc_aes_err;
 
+	/* skip XTS if MSA-4 is not available */
+	if ((stfle(facility_bits, 2) <= 0) ||
+	    !(facility_bits[1] & (1ULL << (63 - (77 - 64)))))
+		goto out;
+
+	/* check for one key size is enough */
+	if (crypt_s390_func_available(KM_XTS_128_ENCRYPT,
+			CRYPT_S390_MSA | CRYPT_S390_MSA4) &&
+	    crypt_s390_func_available(KM_XTS_256_ENCRYPT,
+			CRYPT_S390_MSA | CRYPT_S390_MSA4)) {
+		ret = crypto_register_alg(&xts_aes_alg);
+		if (ret)
+			goto xts_aes_err;
+	}
+
 out:
 	return ret;
 
+xts_aes_err:
+	crypto_unregister_alg(&cbc_aes_alg);
 cbc_aes_err:
 	crypto_unregister_alg(&ecb_aes_alg);
 ecb_aes_err:
@@ -548,6 +694,7 @@ aes_err:
 
 static void __exit aes_s390_fini(void)
 {
+	crypto_unregister_alg(&xts_aes_alg);
 	crypto_unregister_alg(&cbc_aes_alg);
 	crypto_unregister_alg(&ecb_aes_alg);
 	crypto_unregister_alg(&aes_alg);
--- a/arch/s390/crypto/crypt_s390.h
+++ b/arch/s390/crypto/crypt_s390.h
@@ -55,6 +55,10 @@ enum crypt_s390_km_func {
 	KM_AES_192_DECRYPT  = CRYPT_S390_KM | 0x13 | 0x80,
 	KM_AES_256_ENCRYPT  = CRYPT_S390_KM | 0x14,
 	KM_AES_256_DECRYPT  = CRYPT_S390_KM | 0x14 | 0x80,
+	KM_XTS_128_ENCRYPT  = CRYPT_S390_KM | 0x32,
+	KM_XTS_128_DECRYPT  = CRYPT_S390_KM | 0x32 | 0x80,
+	KM_XTS_256_ENCRYPT  = CRYPT_S390_KM | 0x34,
+	KM_XTS_256_DECRYPT  = CRYPT_S390_KM | 0x34 | 0x80,
 };
 
 /*
@@ -334,4 +338,31 @@ static inline int crypt_s390_func_availa
 	return (status[func >> 3] & (0x80 >> (func & 7))) != 0;
 }
 
+/**
+ * crypt_s390_pcc:
+ * @func: the function code passed to KM; see crypt_s390_km_func
+ * @param: address of parameter block; see POP for details on each func
+ *
+ * Executes the PCC (PERFORM CRYPTOGRAPHIC COMPUTATION) operation of the CPU.
+ *
+ * Returns -1 for failure, 0 for success.
+ */
+static inline int crypt_s390_pcc(long func, void *param)
+{
+	register long __func asm("0") = func & 0x7f; /* encrypt or decrypt */
+	register void *__param asm("1") = param;
+	int ret = -1;
+
+	asm volatile(
+		"0:	.insn	rre,0xb92c0000,0,0 \n" /* PCC opcode */
+		"1:	brc	1,0b \n" /* handle partial completion */
+		"	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
+		: "+d" (ret)
+		: "d" (__func), "a" (__param) : "cc", "memory");
+	return ret;
+}
+
+
 #endif	/* _CRYPTO_ARCH_S390_CRYPT_S390_H */
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -131,20 +131,13 @@ config CRYPTO_AES_S390
 	select CRYPTO_BLKCIPHER
 	help
 	  This is the s390 hardware accelerated implementation of the
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
-	  algorithm.
+	  AES cipher algorithms (FIPS-197).
 
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing
-	  environments regardless of its use in feedback or non-feedback
-	  modes. Its key setup time is excellent, and its key agility is
-	  good. Rijndael's very low memory requirements make it very well
-	  suited for restricted-space environments, in which it also
-	  demonstrates excellent performance. Rijndael's operations are
-	  among the easiest to defend against power and timing attacks.
-
-	  On s390 the System z9-109 currently only supports the key size
-	  of 128 bit.
+	  As of z9 the ECB and CBC modes are hardware accelerated
+	  for 128 bit keys.
+	  As of z10 the ECB and CBC modes are hardware accelerated
+	  for all AES key sizes.
+	  As of z196 the XTS mode is hardware accelerated.
 
 config S390_PRNG
 	tristate "Pseudo random number generator device driver"

-- 
