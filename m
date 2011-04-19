From: jang@linux.vnet.ibm.com
Subject: [PATCH 4/8] s390: add System z hardware support for CTR mode
Date: Tue, 19 Apr 2011 21:29:17 +0200
Message-ID: <20110419193248.399099652@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:48603 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1DSTeF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:05 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate4.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJXxTn010659
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:33:59 GMT
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYtmh1761518
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:55 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJXwJm028584
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:33:59 -0600
Content-Disposition: inline; filename=crypto-ctr.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
From: Jan Glauber <jang@linux.vnet.ibm.com>

This patch adds System z hardware acceleration support for AES, DES
and 3DES in CTR mode. The hardware support is available starting with
System z196.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/aes_s390.c   |  151 +++++++++++++++++++++++++++++++++++--
 arch/s390/crypto/crypt_s390.h |   66 ++++++++++++++++
 arch/s390/crypto/des_s390.c   |  169 +++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/Kconfig        |    8 +
 4 files changed, 383 insertions(+), 11 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -31,7 +31,8 @@
 #define AES_KEYLEN_192		2
 #define AES_KEYLEN_256		4
 
-static char keylen_flag = 0;
+static u8 *ctrblk;
+static char keylen_flag;
 
 struct s390_aes_ctx {
 	u8 iv[AES_BLOCK_SIZE];
@@ -632,9 +633,128 @@ static struct crypto_alg xts_aes_alg = {
 	}
 };
 
+static int ctr_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+			   unsigned int key_len)
+{
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+
+	switch (key_len) {
+	case 16:
+		sctx->enc = KMCTR_AES_128_ENCRYPT;
+		sctx->dec = KMCTR_AES_128_DECRYPT;
+		break;
+	case 24:
+		sctx->enc = KMCTR_AES_192_ENCRYPT;
+		sctx->dec = KMCTR_AES_192_DECRYPT;
+		break;
+	case 32:
+		sctx->enc = KMCTR_AES_256_ENCRYPT;
+		sctx->dec = KMCTR_AES_256_DECRYPT;
+		break;
+	}
+
+	return aes_set_key(tfm, in_key, key_len);
+}
+
+static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
+			 struct s390_aes_ctx *sctx, struct blkcipher_walk *walk)
+{
+	int ret = blkcipher_walk_virt_block(desc, walk, AES_BLOCK_SIZE);
+	unsigned int i, n, nbytes;
+	u8 buf[AES_BLOCK_SIZE];
+	u8 *out, *in;
+
+	if (!walk->nbytes)
+		return ret;
+
+	memcpy(ctrblk, walk->iv, AES_BLOCK_SIZE);
+	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+		out = walk->dst.virt.addr;
+		in = walk->src.virt.addr;
+		while (nbytes >= AES_BLOCK_SIZE) {
+			/* only use complete blocks, max. PAGE_SIZE */
+			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
+						 nbytes & ~(AES_BLOCK_SIZE - 1);
+			for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
+				memcpy(ctrblk + i, ctrblk + i - AES_BLOCK_SIZE,
+				       AES_BLOCK_SIZE);
+				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
+			}
+			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
+			BUG_ON(ret < 0 || ret != n);
+			if (n > AES_BLOCK_SIZE)
+				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
+				       AES_BLOCK_SIZE);
+			crypto_inc(ctrblk, AES_BLOCK_SIZE);
+			out += n;
+			in += n;
+			nbytes -= n;
+		}
+		ret = blkcipher_walk_done(desc, walk, nbytes);
+	}
+	/*
+	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
+	 */
+	if (nbytes) {
+		out = walk->dst.virt.addr;
+		in = walk->src.virt.addr;
+		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
+				       AES_BLOCK_SIZE, ctrblk);
+		BUG_ON(ret < 0 || ret != AES_BLOCK_SIZE);
+		memcpy(out, buf, nbytes);
+		crypto_inc(ctrblk, AES_BLOCK_SIZE);
+		ret = blkcipher_walk_done(desc, walk, 0);
+	}
+	memcpy(walk->iv, ctrblk, AES_BLOCK_SIZE);
+	return ret;
+}
+
+static int ctr_aes_encrypt(struct blkcipher_desc *desc,
+			   struct scatterlist *dst, struct scatterlist *src,
+			   unsigned int nbytes)
+{
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ctr_aes_crypt(desc, sctx->enc, sctx, &walk);
+}
+
+static int ctr_aes_decrypt(struct blkcipher_desc *desc,
+			   struct scatterlist *dst, struct scatterlist *src,
+			   unsigned int nbytes)
+{
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ctr_aes_crypt(desc, sctx->dec, sctx, &walk);
+}
+
+static struct crypto_alg ctr_aes_alg = {
+	.cra_name		=	"ctr(aes)",
+	.cra_driver_name	=	"ctr-aes-s390",
+	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	1,
+	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(ctr_aes_alg.cra_list),
+	.cra_u			=	{
+		.blkcipher = {
+			.min_keysize		=	AES_MIN_KEY_SIZE,
+			.max_keysize		=	AES_MAX_KEY_SIZE,
+			.ivsize			=	AES_BLOCK_SIZE,
+			.setkey			=	ctr_aes_set_key,
+			.encrypt		=	ctr_aes_encrypt,
+			.decrypt		=	ctr_aes_decrypt,
+		}
+	}
+};
+
 static int __init aes_s390_init(void)
 {
-	unsigned long long facility_bits[2];
 	int ret;
 
 	if (crypt_s390_func_available(KM_AES_128_ENCRYPT, CRYPT_S390_MSA))
@@ -664,11 +784,6 @@ static int __init aes_s390_init(void)
 	if (ret)
 		goto cbc_aes_err;
 
-	/* skip XTS if MSA-4 is not available */
-	if ((stfle(facility_bits, 2) <= 0) ||
-	    !(facility_bits[1] & (1ULL << (63 - (77 - 64)))))
-		goto out;
-
 	/* check for one key size is enough */
 	if (crypt_s390_func_available(KM_XTS_128_ENCRYPT,
 			CRYPT_S390_MSA | CRYPT_S390_MSA4) &&
@@ -679,9 +794,29 @@ static int __init aes_s390_init(void)
 			goto xts_aes_err;
 	}
 
+	if (crypt_s390_func_available(KMCTR_AES_128_ENCRYPT,
+				CRYPT_S390_MSA | CRYPT_S390_MSA4) &&
+	    crypt_s390_func_available(KMCTR_AES_192_ENCRYPT,
+				CRYPT_S390_MSA | CRYPT_S390_MSA4) &&
+	    crypt_s390_func_available(KMCTR_AES_256_ENCRYPT,
+				CRYPT_S390_MSA | CRYPT_S390_MSA4)) {
+		ctrblk = (u8 *) __get_free_page(GFP_KERNEL);
+		if (!ctrblk) {
+			ret = -ENOMEM;
+			goto ctr_aes_err;
+		}
+		ret = crypto_register_alg(&ctr_aes_alg);
+		if (ret) {
+			free_page((unsigned long) ctrblk);
+			goto ctr_aes_err;
+		}
+	}
+
 out:
 	return ret;
 
+ctr_aes_err:
+	crypto_unregister_alg(&xts_aes_alg);
 xts_aes_err:
 	crypto_unregister_alg(&cbc_aes_alg);
 cbc_aes_err:
@@ -694,6 +829,8 @@ aes_err:
 
 static void __exit aes_s390_fini(void)
 {
+	crypto_unregister_alg(&ctr_aes_alg);
+	free_page((unsigned long) ctrblk);
 	crypto_unregister_alg(&xts_aes_alg);
 	crypto_unregister_alg(&cbc_aes_alg);
 	crypto_unregister_alg(&ecb_aes_alg);
--- a/arch/s390/crypto/crypt_s390.h
+++ b/arch/s390/crypto/crypt_s390.h
@@ -34,7 +34,8 @@ enum crypt_s390_operations {
 	CRYPT_S390_KMC  = 0x0200,
 	CRYPT_S390_KIMD = 0x0300,
 	CRYPT_S390_KLMD = 0x0400,
-	CRYPT_S390_KMAC = 0x0500
+	CRYPT_S390_KMAC = 0x0500,
+	CRYPT_S390_KMCTR = 0x0600
 };
 
 /*
@@ -83,6 +84,26 @@ enum crypt_s390_kmc_func {
 };
 
 /*
+ * function codes for KMCTR (CIPHER MESSAGE WITH COUNTER)
+ * instruction
+ */
+enum crypt_s390_kmctr_func {
+	KMCTR_QUERY            = CRYPT_S390_KMCTR | 0x0,
+	KMCTR_DEA_ENCRYPT      = CRYPT_S390_KMCTR | 0x1,
+	KMCTR_DEA_DECRYPT      = CRYPT_S390_KMCTR | 0x1 | 0x80,
+	KMCTR_TDEA_128_ENCRYPT = CRYPT_S390_KMCTR | 0x2,
+	KMCTR_TDEA_128_DECRYPT = CRYPT_S390_KMCTR | 0x2 | 0x80,
+	KMCTR_TDEA_192_ENCRYPT = CRYPT_S390_KMCTR | 0x3,
+	KMCTR_TDEA_192_DECRYPT = CRYPT_S390_KMCTR | 0x3 | 0x80,
+	KMCTR_AES_128_ENCRYPT  = CRYPT_S390_KMCTR | 0x12,
+	KMCTR_AES_128_DECRYPT  = CRYPT_S390_KMCTR | 0x12 | 0x80,
+	KMCTR_AES_192_ENCRYPT  = CRYPT_S390_KMCTR | 0x13,
+	KMCTR_AES_192_DECRYPT  = CRYPT_S390_KMCTR | 0x13 | 0x80,
+	KMCTR_AES_256_ENCRYPT  = CRYPT_S390_KMCTR | 0x14,
+	KMCTR_AES_256_DECRYPT  = CRYPT_S390_KMCTR | 0x14 | 0x80,
+};
+
+/*
  * function codes for KIMD (COMPUTE INTERMEDIATE MESSAGE DIGEST)
  * instruction
  */
@@ -292,6 +313,45 @@ static inline int crypt_s390_kmac(long f
 }
 
 /**
+ * crypt_s390_kmctr:
+ * @func: the function code passed to KMCTR; see crypt_s390_kmctr_func
+ * @param: address of parameter block; see POP for details on each func
+ * @dest: address of destination memory area
+ * @src: address of source memory area
+ * @src_len: length of src operand in bytes
+ * @counter: address of counter value
+ *
+ * Executes the KMCTR (CIPHER MESSAGE WITH COUNTER) operation of the CPU.
+ *
+ * Returns -1 for failure, 0 for the query func, number of processed
+ * bytes for encryption/decryption funcs
+ */
+static inline int crypt_s390_kmctr(long func, void *param, u8 *dest,
+				 const u8 *src, long src_len, u8 *counter)
+{
+	register long __func asm("0") = func & CRYPT_S390_FUNC_MASK;
+	register void *__param asm("1") = param;
+	register const u8 *__src asm("2") = src;
+	register long __src_len asm("3") = src_len;
+	register u8 *__dest asm("4") = dest;
+	register u8 *__ctr asm("6") = counter;
+	int ret = -1;
+
+	asm volatile(
+		"0:	.insn	rrf,0xb92d0000,%3,%1,%4,0 \n" /* KMCTR opcode */
+		"1:	brc	1,0b \n" /* handle partial completion */
+		"	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
+		: "+d" (ret), "+a" (__src), "+d" (__src_len), "+a" (__dest),
+		  "+a" (__ctr)
+		: "d" (__func), "a" (__param) : "cc", "memory");
+	if (ret < 0)
+		return ret;
+	return (func & CRYPT_S390_FUNC_MASK) ? src_len - __src_len : __src_len;
+}
+
+/**
  * crypt_s390_func_available:
  * @func: the function code of the specific function; 0 if op in general
  *
@@ -328,6 +388,10 @@ static inline int crypt_s390_func_availa
 	case CRYPT_S390_KMAC:
 		ret = crypt_s390_kmac(KMAC_QUERY, &status, NULL, 0);
 		break;
+	case CRYPT_S390_KMCTR:
+		ret = crypt_s390_kmctr(KMCTR_QUERY, &status, NULL, NULL, 0,
+				       NULL);
+		break;
 	default:
 		return 0;
 	}
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -3,7 +3,7 @@
  *
  * s390 implementation of the DES Cipher Algorithm.
  *
- * Copyright IBM Corp. 2003,2007
+ * Copyright IBM Corp. 2003,2011
  * Author(s): Thomas Spatzier
  *	      Jan Glauber (jan.glauber@de.ibm.com)
  *
@@ -24,6 +24,8 @@
 
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
 
+static u8 *ctrblk;
+
 struct s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
 	u8 key[DES3_KEY_SIZE];
@@ -370,6 +372,143 @@ static struct crypto_alg cbc_des3_alg =
 	}
 };
 
+static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
+			    struct s390_des_ctx *ctx, struct blkcipher_walk *walk)
+{
+	int ret = blkcipher_walk_virt_block(desc, walk, DES_BLOCK_SIZE);
+	unsigned int i, n, nbytes;
+	u8 buf[DES_BLOCK_SIZE];
+	u8 *out, *in;
+
+	memcpy(ctrblk, walk->iv, DES_BLOCK_SIZE);
+	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
+		out = walk->dst.virt.addr;
+		in = walk->src.virt.addr;
+		while (nbytes >= DES_BLOCK_SIZE) {
+			/* align to block size, max. PAGE_SIZE */
+			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
+				nbytes & ~(DES_BLOCK_SIZE - 1);
+			for (i = DES_BLOCK_SIZE; i < n; i += DES_BLOCK_SIZE) {
+				memcpy(ctrblk + i, ctrblk + i - DES_BLOCK_SIZE,
+				       DES_BLOCK_SIZE);
+				crypto_inc(ctrblk + i, DES_BLOCK_SIZE);
+			}
+			ret = crypt_s390_kmctr(func, ctx->key, out, in, n, ctrblk);
+			BUG_ON((ret < 0) || (ret != n));
+			if (n > DES_BLOCK_SIZE)
+				memcpy(ctrblk, ctrblk + n - DES_BLOCK_SIZE,
+				       DES_BLOCK_SIZE);
+			crypto_inc(ctrblk, DES_BLOCK_SIZE);
+			out += n;
+			in += n;
+			nbytes -= n;
+		}
+		ret = blkcipher_walk_done(desc, walk, nbytes);
+	}
+
+	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
+	if (nbytes) {
+		out = walk->dst.virt.addr;
+		in = walk->src.virt.addr;
+		ret = crypt_s390_kmctr(func, ctx->key, buf, in,
+				       DES_BLOCK_SIZE, ctrblk);
+		BUG_ON(ret < 0 || ret != DES_BLOCK_SIZE);
+		memcpy(out, buf, nbytes);
+		crypto_inc(ctrblk, DES_BLOCK_SIZE);
+		ret = blkcipher_walk_done(desc, walk, 0);
+	}
+	memcpy(walk->iv, ctrblk, DES_BLOCK_SIZE);
+	return ret;
+}
+
+static int ctr_des_encrypt(struct blkcipher_desc *desc,
+			   struct scatterlist *dst, struct scatterlist *src,
+			   unsigned int nbytes)
+{
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ctr_desall_crypt(desc, KMCTR_DEA_ENCRYPT, ctx, &walk);
+}
+
+static int ctr_des_decrypt(struct blkcipher_desc *desc,
+			   struct scatterlist *dst, struct scatterlist *src,
+			   unsigned int nbytes)
+{
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ctr_desall_crypt(desc, KMCTR_DEA_DECRYPT, ctx, &walk);
+}
+
+static struct crypto_alg ctr_des_alg = {
+	.cra_name		=	"ctr(des)",
+	.cra_driver_name	=	"ctr-des-s390",
+	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	1,
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(ctr_des_alg.cra_list),
+	.cra_u			=	{
+		.blkcipher = {
+			.min_keysize		=	DES_KEY_SIZE,
+			.max_keysize		=	DES_KEY_SIZE,
+			.ivsize			=	DES_BLOCK_SIZE,
+			.setkey			=	des_setkey,
+			.encrypt		=	ctr_des_encrypt,
+			.decrypt		=	ctr_des_decrypt,
+		}
+	}
+};
+
+static int ctr_des3_encrypt(struct blkcipher_desc *desc,
+			    struct scatterlist *dst, struct scatterlist *src,
+			    unsigned int nbytes)
+{
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ctr_desall_crypt(desc, KMCTR_TDEA_192_ENCRYPT, ctx, &walk);
+}
+
+static int ctr_des3_decrypt(struct blkcipher_desc *desc,
+			    struct scatterlist *dst, struct scatterlist *src,
+			    unsigned int nbytes)
+{
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ctr_desall_crypt(desc, KMCTR_TDEA_192_DECRYPT, ctx, &walk);
+}
+
+static struct crypto_alg ctr_des3_alg = {
+	.cra_name		=	"ctr(des3_ede)",
+	.cra_driver_name	=	"ctr-des3_ede-s390",
+	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	1,
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(ctr_des3_alg.cra_list),
+	.cra_u			=	{
+		.blkcipher = {
+			.min_keysize		=	DES3_KEY_SIZE,
+			.max_keysize		=	DES3_KEY_SIZE,
+			.ivsize			=	DES_BLOCK_SIZE,
+			.setkey			=	des3_setkey,
+			.encrypt		=	ctr_des3_encrypt,
+			.decrypt		=	ctr_des3_decrypt,
+		}
+	}
+};
+
 static int __init des_s390_init(void)
 {
 	int ret;
@@ -396,9 +535,32 @@ static int __init des_s390_init(void)
 	ret = crypto_register_alg(&cbc_des3_alg);
 	if (ret)
 		goto cbc_des3_err;
+
+	if (crypt_s390_func_available(KMCTR_DEA_ENCRYPT,
+			CRYPT_S390_MSA | CRYPT_S390_MSA4) &&
+	    crypt_s390_func_available(KMCTR_TDEA_192_ENCRYPT,
+			CRYPT_S390_MSA | CRYPT_S390_MSA4)) {
+		ret = crypto_register_alg(&ctr_des_alg);
+		if (ret)
+			goto ctr_des_err;
+		ret = crypto_register_alg(&ctr_des3_alg);
+		if (ret)
+			goto ctr_des3_err;
+		ctrblk = (u8 *) __get_free_page(GFP_KERNEL);
+		if (!ctrblk) {
+			ret = -ENOMEM;
+			goto ctr_mem_err;
+		}
+	}
 out:
 	return ret;
 
+ctr_mem_err:
+	crypto_unregister_alg(&ctr_des3_alg);
+ctr_des3_err:
+	crypto_unregister_alg(&ctr_des_alg);
+ctr_des_err:
+	crypto_unregister_alg(&cbc_des3_alg);
 cbc_des3_err:
 	crypto_unregister_alg(&ecb_des3_alg);
 ecb_des3_err:
@@ -415,6 +577,11 @@ des_err:
 
 static void __exit des_s390_exit(void)
 {
+	if (ctrblk) {
+		crypto_unregister_alg(&ctr_des_alg);
+		crypto_unregister_alg(&ctr_des3_alg);
+		free_page((unsigned long) ctrblk);
+	}
 	crypto_unregister_alg(&cbc_des3_alg);
 	crypto_unregister_alg(&ecb_des3_alg);
 	crypto_unregister_alg(&des3_alg);
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -121,9 +121,12 @@ config CRYPTO_DES_S390
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
-	  This us the s390 hardware accelerated implementation of the
+	  This is the s390 hardware accelerated implementation of the
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
 
+	  As of z990 the ECB and CBC mode are hardware accelerated.
+	  As of z196 the CTR mode is hardware accelerated.
+
 config CRYPTO_AES_S390
 	tristate "AES cipher algorithms"
 	depends on S390
@@ -137,7 +140,8 @@ config CRYPTO_AES_S390
 	  for 128 bit keys.
 	  As of z10 the ECB and CBC modes are hardware accelerated
 	  for all AES key sizes.
-	  As of z196 the XTS mode is hardware accelerated.
+	  As of z196 the XTS and CTR modes are hardware accelerated.
+
 
 config S390_PRNG
 	tristate "Pseudo random number generator device driver"

-- 
