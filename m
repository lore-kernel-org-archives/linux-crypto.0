From: Joy Latten <latten@austin.ibm.com>
Subject: [PATCH 1/1]: Add countersize to CTR
Date: Tue, 23 Oct 2007 15:26:29 -0500
Message-ID: <200710232026.l9NKQTkC000737@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au, mikko.herranen@cs.helsinki.fi
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36956 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbXJWUbL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 16:31:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9NKV52i020624
	for <linux-crypto@vger.kernel.org>; Tue, 23 Oct 2007 16:31:05 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9NKV5MF059726
	for <linux-crypto@vger.kernel.org>; Tue, 23 Oct 2007 16:31:05 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9NKV4GW005020
	for <linux-crypto@vger.kernel.org>; Tue, 23 Oct 2007 16:31:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds countersize to CTR mode. 
The template is now ctr(algo,noncesize,ivsize,countersize).

For example, ctr(aes,4,8,4) indicates the counterblock
will be composed of a salt/nonce that is 4 bytes, an iv
that is 8 bytes and the counter is 4 bytes.

When noncesize + ivsize + countersize == blocksize, 
CTR initializes the counter portion of the block and
begins encrypting with counter set to 1.  

If noncesize + ivsize == blocksize, then this indicates that
user is passing in entire counterblock. Thus countersize 
indicates the amount of bytes in counterblock to use as 
the counter for incrementing. CTR will increment counter 
portion by 1, and begin encryption with that value. 

Note that CTR assumes the counter portion of the block that
will be incremented is stored in big endian.

Please let me know if this looks ok.

Regards,
Joy

Signed-off-by: Joy Latten <latten@austin.ibm.com>
 
diff -urpN linux-2.6.22.aead.patch/crypto/ctr.c linux-2.6.22.aead.patch2/crypto/ctr.c
--- linux-2.6.22.aead.patch/crypto/ctr.c	2007-10-09 12:12:54.000000000 -0500
+++ linux-2.6.22.aead.patch2/crypto/ctr.c	2007-10-23 14:41:35.000000000 -0500
@@ -23,6 +23,7 @@ struct ctr_instance_ctx {
 	struct crypto_spawn alg;
 	unsigned int noncesize;
 	unsigned int ivsize; 
+	unsigned int countersize;
 };
 
 struct crypto_ctr_ctx {
@@ -186,7 +187,6 @@ static int crypto_ctr_crypt(struct blkci
 	unsigned long alignmask = crypto_cipher_alignmask(child);
 	u8 cblk[bsize + alignmask];
 	u8 *counterblk = (u8 *)ALIGN((unsigned long)cblk, alignmask + 1);
-	unsigned int countersize;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -198,18 +198,18 @@ static int crypto_ctr_crypt(struct blkci
 	memcpy(counterblk + ictx->noncesize, walk.iv, ictx->ivsize);
 
 	/* initialize counter portion of counter block */
-	countersize = bsize - ictx->noncesize - ictx->ivsize;
-	ctr_inc_quad(counterblk + (bsize - countersize), countersize);
+	ctr_inc_quad(counterblk + (bsize - ictx->countersize), 
+		     ictx->countersize);
 
 	while (walk.nbytes) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
 			nbytes = crypto_ctr_crypt_inplace(&walk, child,
 							  counterblk,
-							  countersize);
+							  ictx->countersize);
 		else
 			nbytes = crypto_ctr_crypt_segment(&walk, child,
 							  counterblk,
-							  countersize);
+							  ictx->countersize);
 
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
@@ -256,6 +256,7 @@ static struct crypto_instance *crypto_ct
 	struct ctr_instance_ctx *ictx;
 	unsigned int noncesize;
 	unsigned int ivsize;
+	unsigned int countersize;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
@@ -275,11 +276,16 @@ static struct crypto_instance *crypto_ct
 	if (err)
 		goto out_put_alg;
 
+	err = crypto_attr_u32(tb[4], &countersize);
+	if (err)
+		goto out_put_alg;
+
 	/* verify size of nonce + iv + counter */
 	err = -EINVAL;
-	if ((noncesize + ivsize) >= alg->cra_blocksize)
+	if (((noncesize + ivsize) > alg->cra_blocksize) ||
+	    (countersize > alg->cra_blocksize))
 		goto out_put_alg;
-
+	
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!inst)
@@ -287,20 +293,21 @@ static struct crypto_instance *crypto_ct
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "ctr(%s,%u,%u)", alg->cra_name, noncesize,
-		     ivsize) >= CRYPTO_MAX_ALG_NAME) {
+		     "ctr(%s,%u,%u,%u)", alg->cra_name, noncesize,
+		     ivsize, countersize) >= CRYPTO_MAX_ALG_NAME) {
 		goto err_free_inst;
 	}
 
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "ctr(%s,%u,%u)", alg->cra_driver_name, noncesize,
-		     ivsize) >= CRYPTO_MAX_ALG_NAME) {
+		     "ctr(%s,%u,%u,%u)", alg->cra_driver_name, noncesize,
+		     ivsize, countersize) >= CRYPTO_MAX_ALG_NAME) {
 		goto err_free_inst;
 	}
 
 	ictx = crypto_instance_ctx(inst);
 	ictx->noncesize = noncesize;
 	ictx->ivsize = ivsize;
+	ictx->countersize = countersize;
 
 	err = crypto_init_spawn(&ictx->alg, alg, inst,
 		CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
diff -urpN linux-2.6.22.aead.patch/crypto/tcrypt.c linux-2.6.22.aead.patch2/crypto/tcrypt.c
--- linux-2.6.22.aead.patch/crypto/tcrypt.c	2007-10-09 11:40:58.000000000 -0500
+++ linux-2.6.22.aead.patch2/crypto/tcrypt.c	2007-10-23 14:41:46.000000000 -0500
@@ -955,9 +955,9 @@ static void do_test(void)
 			    AES_LRW_ENC_TEST_VECTORS);
 		test_cipher("lrw(aes)", DECRYPT, aes_lrw_dec_tv_template,
 			    AES_LRW_DEC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8)", ENCRYPT, aes_ctr_enc_tv_template,
+		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
 			    AES_CTR_ENC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8)", DECRYPT, aes_ctr_dec_tv_template,
+		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
 			    AES_CTR_DEC_TEST_VECTORS);
 
 		//CAST5
@@ -1136,9 +1136,9 @@ static void do_test(void)
 			    AES_LRW_ENC_TEST_VECTORS);
 		test_cipher("lrw(aes)", DECRYPT, aes_lrw_dec_tv_template,
 			    AES_LRW_DEC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8)", ENCRYPT, aes_ctr_enc_tv_template,
+		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
 			    AES_CTR_ENC_TEST_VECTORS);
-		test_cipher("ctr(aes,4,8)", DECRYPT, aes_ctr_dec_tv_template,
+		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
 			    AES_CTR_DEC_TEST_VECTORS);
 		break;
 
