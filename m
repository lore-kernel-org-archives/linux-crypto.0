From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Fri, 26 Oct 2007 14:22:28 -0500
Message-ID: <200710261922.l9QJMSK0022034@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org, mikko.herranen@cs.helsinki.fi
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:57242 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763604AbXJZT1I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 15:27:08 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9QJR7Wn016654
	for <linux-crypto@vger.kernel.org>; Fri, 26 Oct 2007 15:27:07 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9QJR3CA107248
	for <linux-crypto@vger.kernel.org>; Fri, 26 Oct 2007 13:27:05 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9QJR3bi010572
	for <linux-crypto@vger.kernel.org>; Fri, 26 Oct 2007 13:27:03 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2007-10-26 at 14:59 +0800, Herbert Xu wrote:
>On Tue, Oct 23, 2007 at 03:26:29PM -0500, Joy Latten wrote:
> >
> > +	err = crypto_attr_u32(tb[4], &countersize);
> > +	if (err)
> > +		goto out_put_alg;
> > +
> >  	/* verify size of nonce + iv + counter */
> >  	err = -EINVAL;
> > -	if ((noncesize + ivsize) >= alg->cra_blocksize)
> > +	if (((noncesize + ivsize) > alg->cra_blocksize) ||
> > +	    (countersize > alg->cra_blocksize))
> >  		goto out_put_alg;
> 
> Probably should check whether
> 
> 	noncesize + ivsize + countersize == blocksize
> 
> if
> 
> 	noncesize + ivsize < blocksize
> 
> Actually let's also require that countersize >= 4 as otherwise
> wrapping will be a problem.  This would also weed out stream
> algorithms but we wouldn't want to apply CTR to them anyway.
> 

Ok, I added 2 additional checks; one check
that countersize >= 4 and the other that 
noncesize+ivsize+countersize >= blocksize.
 
I think the addition of these two checks help
to cover instances where we will want to fail
because of our inputs. 

The below patch covers the additional checks as
well as the changes for GCM.

Regards,
Joy

Signed-off-by: Joy Latten <latten@austin.ibm.com>

diff -urpN linux-2.6.22.aead.patch/crypto/ctr.c linux-2.6.22.aead.patch2/crypto/ctr.c
--- linux-2.6.22.aead.patch/crypto/ctr.c	2007-10-09 12:12:54.000000000 -0500
+++ linux-2.6.22.aead.patch2/crypto/ctr.c	2007-10-26 14:11:46.000000000 -0500
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
@@ -275,9 +276,17 @@ static struct crypto_instance *crypto_ct
 	if (err)
 		goto out_put_alg;
 
-	/* verify size of nonce + iv + counter */
+	err = crypto_attr_u32(tb[4], &countersize);
+	if (err)
+		goto out_put_alg;
+
+	/* verify size of nonce + iv + counter 
+	 * counter must be >= 4 bytes. 
+	 */
 	err = -EINVAL;
-	if ((noncesize + ivsize) >= alg->cra_blocksize)
+	if (((noncesize + ivsize + countersize) < alg->cra_blocksize) ||
+	    ((noncesize + ivsize) > alg->cra_blocksize) ||
+	    (countersize > alg->cra_blocksize) || (countersize < 4))
 		goto out_put_alg;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
@@ -287,20 +296,21 @@ static struct crypto_instance *crypto_ct
 
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
 
