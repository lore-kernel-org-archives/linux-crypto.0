From: Joy Latten <latten@austin.ibm.com>
Subject: PATCH[1/2]: CCM Mode
Date: Tue, 11 Dec 2007 04:24:26 -0600
Message-ID: <200712111024.lBBAOQbp023295@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:49141 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXLKKZa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Dec 2007 05:25:30 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lBBAPTIU031663
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 05:25:29 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBBAPTdE167554
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 03:25:29 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBBAPTmV003222
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 03:25:29 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds Counter with CBC-MAC (CCM) support.
RFC 3610 and NIST Special Publication 800-38C were referenced.

Note:
	1. CCM is specified with a cipher and a noncesize, 
	   i.e. ccm(aes,7).
	   Currently CCM is defined to only work with 128-bit
	   block ciphers such as aes. 
		
	   NIST allows nonce to be between 7 and 13 bytes.
	   
	2. The nonce is used to format data and in counterblock to CTR.
	   CTR is called as "ctr(cipher,0,16,16). 
	   I suspect this will change in regards to Herbert Xu's
	   recent set of patches.

	   Mostly all the test vectors in RFC 3610 use a 13 byte
	   nonce. Thus leaving 2 bytes for counter portion of block.
	   (1 byte is reserved for formating.) Linux CTR requires
	   counter portion of block to be at least 4 bytes. Thus
	   I pass in entire counter size of 16 to use entire counter
	   bypassing any limitations. 


Please let me know if all looks ok or not.
I may need to rebase this patch or change something in
light of Herbert's recent patchsets. I will take a look
at them later today.

regards,
Joy

Signed-off-by: Joy Latten <latten@austin.ibm.com>


diff -urpN cryptodev-2.6.2/crypto/ccm.c cryptodev-2.6.2.sb/crypto/ccm.c
--- cryptodev-2.6.2/crypto/ccm.c	1969-12-31 18:00:00.000000000 -0600
+++ cryptodev-2.6.2.sb/crypto/ccm.c	2007-12-11 03:46:21.000000000 -0600
@@ -0,0 +1,558 @@
+/*
+ * CCM: Counter with CBC-MAC
+ *
+ * (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/scatterwalk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "internal.h"
+
+struct ccm_instance_ctx {
+	struct crypto_spawn ctr;
+	struct crypto_spawn cipher;
+	u32 noncesize;
+};
+
+struct crypto_ccm_ctx {
+	struct crypto_cipher *cipher;
+	struct crypto_ablkcipher *ctr;
+	u8 *nonce;
+};
+
+struct crypto_ccm_req_priv_ctx {
+	u8 odata[16];
+	u8 idata[16];
+	u8 auth_tag[16];
+	u32 ilen;
+	u32 flags;
+};
+
+static void set_msg_len(u8 *block, int msglen, int csize)
+{
+	__be32 *b = (__be32 *)(block + csize);
+	*--b = cpu_to_be32(msglen);
+}
+
+static int crypto_ccm_setkey(struct crypto_aead *aead, const u8 *key,
+			     unsigned int keylen)
+{
+	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_ablkcipher *ctr = ctx->ctr;
+	struct crypto_cipher *tfm = ctx->cipher;
+	struct ccm_instance_ctx *ictx =
+		crypto_instance_ctx(crypto_aead_alg_instance(aead));
+	unsigned int noncesize = ictx->noncesize;
+	int err = 0;
+
+	if (keylen < noncesize)
+		return -EINVAL;
+
+	memcpy(ctx->nonce, key + (keylen - noncesize), noncesize);
+	keylen -= noncesize;
+
+	crypto_ablkcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
+	crypto_ablkcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
+				    CRYPTO_TFM_REQ_MASK);
+	err = crypto_ablkcipher_setkey(ctr, key, keylen);
+	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctr) &
+			      CRYPTO_TFM_RES_MASK);
+	if (err)
+		goto out;
+
+	crypto_cipher_clear_flags(tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(tfm, crypto_aead_get_flags(aead) &
+				    CRYPTO_TFM_REQ_MASK);
+	err = crypto_cipher_setkey(tfm, key, keylen);
+	crypto_aead_set_flags(aead, crypto_cipher_get_flags(tfm) &
+			      CRYPTO_TFM_RES_MASK);
+
+out:
+	return err;
+}
+
+static void format_input(u8 *info, struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
+	struct ccm_instance_ctx *ictx =
+		crypto_instance_ctx(crypto_aead_alg_instance(aead));
+	unsigned int noncesize = ictx->noncesize;
+	unsigned int m;
+	u8 flags;
+
+	memset(info, 0, 16);
+	m = crypto_aead_authsize(aead);
+
+	/* format control info per RFC 3610 and
+	 * NIST Special Publication 800-38C
+	 */
+	if (!req->assoclen)
+		flags = (8*((m-2)/2)) + ((15-noncesize)-1);
+	else
+		flags = 64 + (8*((m-2)/2)) + ((15-noncesize)-1);
+	*info = flags;
+
+	/* set msglen first, then nonce */
+	set_msg_len(info + 1 + noncesize, req->cryptlen, 15-noncesize);
+	memcpy(info + 1, ctx->nonce, noncesize);
+}
+
+static int format_adata(u8 *adata, unsigned int a)
+{
+	int len = 0;
+
+	memset(adata, 0, 16);
+	/* add control info for associated data
+	 * RFC 3610 and NIST Special Publication 800-38C
+	 */
+	if ((0 < a) && (a < 65280)) {
+		*(u16 *)adata = (u16)a;
+		len = 2;
+	} else  {
+		*(u16 *)adata = 0xfffe;
+		*(u32 *)&adata[2] = a;
+		len = 6;
+	}
+
+	return len;
+}
+
+static void compute_mac(struct crypto_cipher *tfm, u8 *data, int n,
+		       struct crypto_ccm_req_priv_ctx *pctx)
+{
+	unsigned int bs = crypto_cipher_blocksize(tfm);
+	u8 *odata = pctx->odata;
+	u8 *idata = pctx->idata;
+	int datalen, getlen;
+
+	datalen = n;
+
+	/* first time in here, block may be partially filled. */
+	getlen = bs - pctx->ilen;
+	if (datalen >= getlen) {
+		memcpy(idata + pctx->ilen, data, getlen);
+		crypto_xor(odata, idata, bs);
+		crypto_cipher_encrypt_one(tfm, odata, odata);
+		datalen -= getlen;
+		data += getlen;
+		pctx->ilen = 0;
+	}
+
+	/* now encrypt rest of data */
+	while (datalen >= bs) {
+		crypto_xor(odata, data, bs);
+		crypto_cipher_encrypt_one(tfm, odata, odata);
+
+		datalen -= bs;
+		data += bs;
+	}
+
+	/* check and see if there's leftover data that wasn't
+	 * enough to fill a block.
+	 */
+	if (datalen) {
+		memcpy(idata + pctx->ilen, data, datalen);
+		pctx->ilen += datalen;
+	}
+}
+
+static void get_data_to_compute(struct crypto_cipher *tfm,
+			       struct crypto_ccm_req_priv_ctx *pctx,
+			       struct scatterlist *sg, unsigned int len)
+{
+	struct scatter_walk walk;
+	u8 *data_src;
+	int n;
+
+	scatterwalk_start(&walk, sg);
+
+	while (len) {
+		n = scatterwalk_clamp(&walk, len);
+		if (!n) {
+			scatterwalk_start(&walk, sg_next(walk.sg));
+			n = scatterwalk_clamp(&walk, len);
+		}
+		data_src = scatterwalk_map(&walk, 0);
+
+		compute_mac(tfm, data_src, n, pctx);
+		len -= n;
+
+		scatterwalk_unmap(data_src, 0);
+		scatterwalk_advance(&walk, n);
+		scatterwalk_done(&walk, 0, len);
+		if (len)
+			crypto_yield(pctx->flags);
+	}
+
+	/* any leftover needs padding and then encrypted */
+	if (pctx->ilen) {
+		int padlen;
+		u8 *odata = pctx->odata;
+		u8 *idata = pctx->idata;
+
+		padlen = 16 - pctx->ilen;
+		memset(idata + pctx->ilen, 0, padlen);
+		crypto_xor(odata, idata, 16);
+		crypto_cipher_encrypt_one(tfm, odata, odata);
+		pctx->ilen = 0;
+	}
+}
+
+static int crypto_ccm_auth(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_ccm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_cipher *cipher = ctx->cipher;
+	unsigned int assoclen = req->assoclen;
+	u8 *odata = pctx->odata;
+	u8 *idata = pctx->idata;
+
+	pctx->flags = req->base.tfm->crt_flags;
+
+	/* format control data for input */
+	format_input(odata, req);
+
+	/* encrypt first block to use as start in computing mac  */
+	crypto_cipher_encrypt_one(cipher, odata, odata);
+
+	/* format associated data and compute into mac */
+	if (assoclen) {
+		pctx->ilen = format_adata(idata, assoclen);
+		get_data_to_compute(cipher, pctx, req->assoc, req->assoclen);
+	}
+
+	/* compute plaintext into mac */
+	get_data_to_compute(cipher, pctx, req->src, req->cryptlen);
+
+	return 0;
+}
+
+static void crypto_ccm_encrypt_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_ccm_req_priv_ctx *pctx = aead_request_ctx(req);
+	u8 *odata = pctx->odata;
+
+	if (!err)
+		scatterwalk_map_and_copy(odata, req->dst, req->cryptlen,
+					 crypto_aead_authsize(aead), 1);
+	aead_request_complete(req, err);
+}
+
+static inline void set_ctrblk(u8 *ctrblk, u8 *nonce, unsigned int noncesize)
+{
+	memset(ctrblk, 0, 16);
+	ctrblk[0] = 15 - noncesize - 1;
+	memcpy(&ctrblk[1], nonce, noncesize);
+}
+
+static int crypto_ccm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
+	struct ccm_instance_ctx *ictx =
+		crypto_instance_ctx(crypto_aead_alg_instance(aead));
+	struct ablkcipher_request abreq;
+	struct crypto_ccm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_cipher *cipher = ctx->cipher;
+	unsigned int authsize = crypto_aead_authsize(aead);
+	unsigned int noncesize = ictx->noncesize;
+	u8 counterblock[16];
+	u8 *authtag = pctx->auth_tag;
+	u8 *odata = pctx->odata;
+	int err = 0;
+
+	err = crypto_ccm_auth(req);
+	if (err)
+		return err;
+
+	 /* Note: rfc 3610 and NIST 800-38C require counter of
+	 * zero to encrypt auth tag. ctr will never have counter
+	 * of 0 since it always increments before encrypting.
+	 * So do it directly, here.
+	 */
+	set_ctrblk(counterblock, ctx->nonce, noncesize);
+	crypto_cipher_encrypt_one(cipher, authtag, counterblock);
+	crypto_xor(authtag, odata, authsize);
+
+	/* reset counterblock and encrypt plaintext */
+	set_ctrblk(counterblock, ctx->nonce, noncesize);
+	ablkcipher_request_set_tfm(&abreq, ctx->ctr);
+	ablkcipher_request_set_callback(&abreq, aead_request_flags(req),
+					crypto_ccm_encrypt_done, req);
+	ablkcipher_request_set_crypt(&abreq, req->src, req->dst,
+				     req->cryptlen, counterblock);
+	err = crypto_ablkcipher_encrypt(&abreq);
+	if (err)
+		return err;
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(authtag, req->dst, req->cryptlen, authsize, 1);
+	return err;
+}
+
+static void crypto_ccm_decrypt_done(struct crypto_async_request *areq,
+				   int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_ccm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+
+	if (!err) {
+		err = crypto_ccm_auth(req);
+		if (!err &&  memcmp(pctx->auth_tag, pctx->odata,
+				crypto_aead_authsize(aead)))
+			err = -EBADMSG;
+	}
+	aead_request_complete(req, err);
+}
+
+static int crypto_ccm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_ccm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct ccm_instance_ctx *ictx =
+		crypto_instance_ctx(crypto_aead_alg_instance(aead));
+	struct ablkcipher_request abreq;
+	struct crypto_cipher *cipher = ctx->cipher;
+	unsigned int authsize = crypto_aead_authsize(aead);
+	unsigned int noncesize = ictx->noncesize;
+	u8 counterblock[16];
+	u8 *authtag = pctx->auth_tag;
+	u8 *odata = pctx->odata;
+	int err;
+
+	if (req->cryptlen < authsize)
+		return -EINVAL;
+
+	req->cryptlen -= authsize;
+	scatterwalk_map_and_copy(odata, req->src, req->cryptlen, authsize, 0);
+
+	/* decrypt authtag */
+	memset(authtag, 0, 16);
+	set_ctrblk(counterblock, ctx->nonce, noncesize);
+	crypto_cipher_encrypt_one(cipher, authtag, counterblock);
+	crypto_xor(authtag, odata, authsize);
+
+	/* decrypt rest of ciphertext */
+	set_ctrblk(counterblock, ctx->nonce, noncesize);
+	ablkcipher_request_set_tfm(&abreq, ctx->ctr);
+	ablkcipher_request_set_callback(&abreq, aead_request_flags(req),
+					crypto_ccm_decrypt_done, req);
+	ablkcipher_request_set_crypt(&abreq, req->src, req->dst,
+				     req->cryptlen, counterblock);
+	err = crypto_ablkcipher_decrypt(&abreq);
+	if (err)
+		return err;
+
+	err = crypto_ccm_auth(req);
+	if (err)
+		return err;
+
+	/* verify */
+	if (memcmp(authtag, odata, authsize))
+		return -EBADMSG;
+
+	return err;
+}
+
+static int crypto_ccm_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct ccm_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct crypto_ccm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_cipher *cipher;
+	struct crypto_ablkcipher *ctr;
+	unsigned long align;
+	int err;
+
+	ctx->nonce = kzalloc(ictx->noncesize, GFP_KERNEL);
+	if (!ctx->nonce)
+		return -ENOMEM;
+
+	cipher = crypto_spawn_cipher(&ictx->cipher);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctr = crypto_spawn_ablkcipher(&ictx->ctr);
+	err = PTR_ERR(ctr);
+	if (IS_ERR(ctr))
+		goto err_free_cipher;
+
+	ctx->cipher = cipher;
+	ctx->ctr = ctr;
+
+	align = max_t(unsigned long, crypto_ablkcipher_alignmask(ctr),
+		      __alignof__(u32) - 1);
+	align &= ~(crypto_tfm_ctx_alignment() - 1);
+	tfm->crt_aead.reqsize = align + sizeof(struct crypto_ccm_req_priv_ctx);
+
+	return 0;
+
+err_free_cipher:
+	crypto_free_cipher(cipher);
+	return err;
+}
+
+static void crypto_ccm_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_ccm_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kfree(ctx->nonce);
+	crypto_free_cipher(ctx->cipher);
+	crypto_free_ablkcipher(ctx->ctr);
+}
+
+static struct crypto_instance *crypto_ccm_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *ctr;
+	struct crypto_alg *cipher;
+	struct ccm_instance_ctx *ictx;
+	char ctr_name[CRYPTO_MAX_ALG_NAME];
+	u32 noncesize;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD);
+	if (err)
+		return ERR_PTR(err);
+
+	cipher = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER,
+				 CRYPTO_ALG_TYPE_MASK);
+
+	inst = ERR_PTR(PTR_ERR(cipher));
+	if (IS_ERR(cipher))
+		return inst;
+
+	err = crypto_attr_u32(tb[2], &noncesize);
+	if (err)
+		goto out;
+
+	/* verify inputs
+	 * noncesize can be 7 - 11 bytes.
+	 * NIST Special Publication 800-38C
+	 */
+
+	err = -EINVAL;
+	if (noncesize > 13 || noncesize < 7)
+		goto out;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s,0,16,16)",
+		     cipher->cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto out;
+
+	err = 0;
+	ctr = crypto_alg_mod_lookup(ctr_name, CRYPTO_ALG_TYPE_BLKCIPHER,
+				    CRYPTO_ALG_TYPE_MASK);
+	inst = ERR_PTR(PTR_ERR(ctr));
+	if (IS_ERR(ctr))
+		goto out;
+
+	err = -EINVAL;
+	if (cipher->cra_blocksize != 16)
+		goto out_ctr;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	err = -ENOMEM;
+	if (!inst)
+		goto out_ctr;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "ccm(%s,%u)", cipher->cra_name, noncesize) >=
+		     CRYPTO_MAX_ALG_NAME)
+		goto out_ctr;
+
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "ccm(%s,%u)", cipher->cra_name, noncesize) >=
+		     CRYPTO_MAX_ALG_NAME)
+		goto out_ctr;
+
+	ictx = crypto_instance_ctx(inst);
+	ictx->noncesize = noncesize;
+
+	err = crypto_init_spawn(&ictx->cipher, cipher, inst,
+				CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto err_free_inst;
+
+	err = crypto_init_spawn(&ictx->ctr, ctr, inst, CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto err_drop_cipher;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_priority = cipher->cra_priority + ctr->cra_priority;
+	inst->alg.cra_blocksize = 16;
+	inst->alg.cra_alignmask = ctr->cra_alignmask;
+	inst->alg.cra_type = &crypto_aead_type;
+	inst->alg.cra_aead.ivsize = 0;
+	inst->alg.cra_aead.maxauthsize = 16;
+	inst->alg.cra_ctxsize = sizeof(struct crypto_ccm_ctx);
+	inst->alg.cra_init = crypto_ccm_init_tfm;
+	inst->alg.cra_exit = crypto_ccm_exit_tfm;
+	inst->alg.cra_aead.setkey = crypto_ccm_setkey;
+	inst->alg.cra_aead.encrypt = crypto_ccm_encrypt;
+	inst->alg.cra_aead.decrypt = crypto_ccm_decrypt;
+
+out_ctr:
+	crypto_mod_put(ctr);
+out:
+	crypto_mod_put(cipher);
+	if (err)
+		inst = ERR_PTR(err);
+	return inst;
+err_drop_cipher:
+	crypto_drop_spawn(&ictx->cipher);
+err_free_inst:
+	kfree(inst);
+	goto out_ctr;
+}
+
+static void crypto_ccm_free(struct crypto_instance *inst)
+{
+	struct ccm_instance_ctx *ctx = crypto_instance_ctx(inst);
+
+	crypto_drop_spawn(&ctx->cipher);
+	crypto_drop_spawn(&ctx->ctr);
+	kfree(inst);
+}
+
+static struct crypto_template crypto_ccm_tmpl = {
+	.name = "ccm",
+	.alloc = crypto_ccm_alloc,
+	.free = crypto_ccm_free,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_ccm_module_init(void)
+{
+	return crypto_register_template(&crypto_ccm_tmpl);
+}
+
+static void __exit crypto_ccm_module_exit(void)
+{
+	crypto_unregister_template(&crypto_ccm_tmpl);
+}
+
+module_init(crypto_ccm_module_init);
+module_exit(crypto_ccm_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Counter with CBC MAC");
diff -urpN cryptodev-2.6.2/crypto/Kconfig cryptodev-2.6.2.sb/crypto/Kconfig
--- cryptodev-2.6.2/crypto/Kconfig	2007-12-07 23:24:46.000000000 -0600
+++ cryptodev-2.6.2.sb/crypto/Kconfig	2007-12-11 02:08:26.000000000 -0600
@@ -215,6 +215,13 @@ config CRYPTO_GCM
 	  Support for Galois/Counter Mode (GCM) and Galois Message
 	  Authentication Code (GMAC). Required for IPSec.
 
+config CRYPTO_CCM
+	tristate "CCM support"
+	select CRYPTO_CTR
+	select CRYPTO_AEAD
+	help
+	  Support for Counter with CBC MAC. Required for IPsec.
+
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
 	select CRYPTO_ABLKCIPHER
diff -urpN cryptodev-2.6.2/crypto/Makefile cryptodev-2.6.2.sb/crypto/Makefile
--- cryptodev-2.6.2/crypto/Makefile	2007-12-07 23:24:46.000000000 -0600
+++ cryptodev-2.6.2.sb/crypto/Makefile	2007-12-11 02:08:38.000000000 -0600
@@ -34,6 +34,7 @@ obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
+obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
