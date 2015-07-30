From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] crypto: ixp4xx - Convert to new AEAD interface
Date: Thu, 30 Jul 2015 17:53:18 +0800
Message-ID: <E1ZKkWc-0004BY-Ce@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44177 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbbG3JxW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts ixp4xx to the new AEAD interface.  IV generation
has been removed since it's a purely software implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ixp4xx_crypto.c |  313 ++++++++++++++++++++---------------------
 1 file changed, 158 insertions(+), 155 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 402631a..411de261 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -156,7 +156,8 @@ struct ablk_ctx {
 };
 
 struct aead_ctx {
-	struct buffer_desc *buffer;
+	struct buffer_desc *src;
+	struct buffer_desc *dst;
 	struct scatterlist ivlist;
 	/* used when the hmac is not on one sg entry */
 	u8 *hmac_virt;
@@ -198,6 +199,15 @@ struct ixp_alg {
 	int registered;
 };
 
+struct ixp_aead_alg {
+	struct aead_alg crypto;
+	const struct ix_hash_algo *hash;
+	u32 cfg_enc;
+	u32 cfg_dec;
+
+	int registered;
+};
+
 static const struct ix_hash_algo hash_alg_md5 = {
 	.cfgword	= 0xAA010004,
 	.icv		= "\x01\x23\x45\x67\x89\xAB\xCD\xEF"
@@ -339,11 +349,11 @@ static void finish_scattered_hmac(struct crypt_ctl *crypt)
 	struct aead_ctx *req_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	int authsize = crypto_aead_authsize(tfm);
-	int decryptlen = req->cryptlen - authsize;
+	int decryptlen = req->assoclen + req->cryptlen - authsize;
 
 	if (req_ctx->encrypt) {
 		scatterwalk_map_and_copy(req_ctx->hmac_virt,
-			req->src, decryptlen, authsize, 1);
+			req->dst, decryptlen, authsize, 1);
 	}
 	dma_pool_free(buffer_pool, req_ctx->hmac_virt, crypt->icv_rev_aes);
 }
@@ -364,7 +374,8 @@ static void one_packet(dma_addr_t phys)
 		struct aead_request *req = crypt->data.aead_req;
 		struct aead_ctx *req_ctx = aead_request_ctx(req);
 
-		free_buf_chain(dev, req_ctx->buffer, crypt->src_buf);
+		free_buf_chain(dev, req_ctx->src, crypt->src_buf);
+		free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
 		if (req_ctx->hmac_virt) {
 			finish_scattered_hmac(crypt);
 		}
@@ -573,11 +584,10 @@ static int init_tfm_ablk(struct crypto_tfm *tfm)
 	return init_tfm(tfm);
 }
 
-static int init_tfm_aead(struct crypto_tfm *tfm)
+static int init_tfm_aead(struct crypto_aead *tfm)
 {
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-				sizeof(struct aead_ctx));
-	return init_tfm(tfm);
+	crypto_aead_set_reqsize(tfm, sizeof(struct aead_ctx));
+	return init_tfm(crypto_aead_tfm(tfm));
 }
 
 static void exit_tfm(struct crypto_tfm *tfm)
@@ -587,6 +597,11 @@ static void exit_tfm(struct crypto_tfm *tfm)
 	free_sa_dir(&ctx->decrypt);
 }
 
+static void exit_tfm_aead(struct crypto_aead *tfm)
+{
+	exit_tfm(crypto_aead_tfm(tfm));
+}
+
 static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
 		int init_len, u32 ctx_addr, const u8 *key, int key_len)
 {
@@ -969,24 +984,6 @@ static int ablk_rfc3686_crypt(struct ablkcipher_request *req)
 	return ret;
 }
 
-static int hmac_inconsistent(struct scatterlist *sg, unsigned start,
-		unsigned int nbytes)
-{
-	int offset = 0;
-
-	if (!nbytes)
-		return 0;
-
-	for (;;) {
-		if (start < offset + sg->length)
-			break;
-
-		offset += sg->length;
-		sg = sg_next(sg);
-	}
-	return (start + nbytes > offset + sg->length);
-}
-
 static int aead_perform(struct aead_request *req, int encrypt,
 		int cryptoffset, int eff_cryptlen, u8 *iv)
 {
@@ -1002,6 +999,8 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	struct device *dev = &pdev->dev;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 				GFP_KERNEL : GFP_ATOMIC;
+	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
+	unsigned int lastlen;
 
 	if (qmgr_stat_full(SEND_QID))
 		return -EAGAIN;
@@ -1030,35 +1029,55 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	crypt->crypt_len = eff_cryptlen;
 
 	crypt->auth_offs = 0;
-	crypt->auth_len = req->assoclen + ivsize + cryptlen;
+	crypt->auth_len = req->assoclen + cryptlen;
 	BUG_ON(ivsize && !req->iv);
 	memcpy(crypt->iv, req->iv, ivsize);
 
+	req_ctx->dst = NULL;
+
 	if (req->src != req->dst) {
-		BUG(); /* -ENOTSUP because of my laziness */
+		struct buffer_desc dst_hook;
+
+		crypt->mode |= NPE_OP_NOT_IN_PLACE;
+		src_direction = DMA_TO_DEVICE;
+
+		buf = chainup_buffers(dev, req->dst, crypt->auth_len,
+				      &dst_hook, flags, DMA_FROM_DEVICE);
+		req_ctx->dst = dst_hook.next;
+		crypt->dst_buf = dst_hook.phys_next;
+
+		if (!buf)
+			goto free_buf_dst;
+
+		if (encrypt) {
+			lastlen = buf->buf_len;
+			if (lastlen >= authsize)
+				crypt->icv_rev_aes = buf->phys_addr +
+						     buf->buf_len - authsize;
+		}
 	}
 
-	/* ASSOC data */
-	buf = chainup_buffers(dev, req->assoc, req->assoclen, &src_hook,
-		flags, DMA_TO_DEVICE);
-	req_ctx->buffer = src_hook.next;
+	buf = chainup_buffers(dev, req->src, crypt->auth_len,
+			      &src_hook, flags, src_direction);
+	req_ctx->src = src_hook.next;
 	crypt->src_buf = src_hook.phys_next;
 	if (!buf)
-		goto out;
-	/* IV */
-	sg_init_table(&req_ctx->ivlist, 1);
-	sg_set_buf(&req_ctx->ivlist, iv, ivsize);
-	buf = chainup_buffers(dev, &req_ctx->ivlist, ivsize, buf, flags,
-			DMA_BIDIRECTIONAL);
-	if (!buf)
-		goto free_chain;
-	if (unlikely(hmac_inconsistent(req->src, cryptlen, authsize))) {
+		goto free_buf_src;
+
+	if (!encrypt || !req_ctx->dst) {
+		lastlen = buf->buf_len;
+		if (lastlen >= authsize)
+			crypt->icv_rev_aes = buf->phys_addr +
+					     buf->buf_len - authsize;
+	}
+
+	if (unlikely(lastlen < authsize)) {
 		/* The 12 hmac bytes are scattered,
 		 * we need to copy them into a safe buffer */
 		req_ctx->hmac_virt = dma_pool_alloc(buffer_pool, flags,
 				&crypt->icv_rev_aes);
 		if (unlikely(!req_ctx->hmac_virt))
-			goto free_chain;
+			goto free_buf_src;
 		if (!encrypt) {
 			scatterwalk_map_and_copy(req_ctx->hmac_virt,
 				req->src, cryptlen, authsize, 0);
@@ -1067,27 +1086,16 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	} else {
 		req_ctx->hmac_virt = NULL;
 	}
-	/* Crypt */
-	buf = chainup_buffers(dev, req->src, cryptlen + authsize, buf, flags,
-			DMA_BIDIRECTIONAL);
-	if (!buf)
-		goto free_hmac_virt;
-	if (!req_ctx->hmac_virt) {
-		crypt->icv_rev_aes = buf->phys_addr + buf->buf_len - authsize;
-	}
 
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_AEAD;
 	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
 	BUG_ON(qmgr_stat_overflow(SEND_QID));
 	return -EINPROGRESS;
-free_hmac_virt:
-	if (req_ctx->hmac_virt) {
-		dma_pool_free(buffer_pool, req_ctx->hmac_virt,
-				crypt->icv_rev_aes);
-	}
-free_chain:
-	free_buf_chain(dev, req_ctx->buffer, crypt->src_buf);
-out:
+
+free_buf_src:
+	free_buf_chain(dev, req_ctx->src, crypt->src_buf);
+free_buf_dst:
+	free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
 	crypt->ctl_flags = CTL_FLAG_UNUSED;
 	return -ENOMEM;
 }
@@ -1173,40 +1181,12 @@ badkey:
 
 static int aead_encrypt(struct aead_request *req)
 {
-	unsigned ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(req));
-	return aead_perform(req, 1, req->assoclen + ivsize,
-			req->cryptlen, req->iv);
+	return aead_perform(req, 1, req->assoclen, req->cryptlen, req->iv);
 }
 
 static int aead_decrypt(struct aead_request *req)
 {
-	unsigned ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(req));
-	return aead_perform(req, 0, req->assoclen + ivsize,
-			req->cryptlen, req->iv);
-}
-
-static int aead_givencrypt(struct aead_givcrypt_request *req)
-{
-	struct crypto_aead *tfm = aead_givcrypt_reqtfm(req);
-	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
-	unsigned len, ivsize = crypto_aead_ivsize(tfm);
-	__be64 seq;
-
-	/* copied from eseqiv.c */
-	if (!ctx->salted) {
-		get_random_bytes(ctx->salt, ivsize);
-		ctx->salted = 1;
-	}
-	memcpy(req->areq.iv, ctx->salt, ivsize);
-	len = ivsize;
-	if (ivsize > sizeof(u64)) {
-		memset(req->giv, 0, ivsize - sizeof(u64));
-		len = sizeof(u64);
-	}
-	seq = cpu_to_be64(req->seq);
-	memcpy(req->giv + ivsize - len, &seq, len);
-	return aead_perform(&req->areq, 1, req->areq.assoclen,
-			req->areq.cryptlen +ivsize, req->giv);
+	return aead_perform(req, 0, req->assoclen, req->cryptlen, req->iv);
 }
 
 static struct ixp_alg ixp4xx_algos[] = {
@@ -1319,80 +1299,77 @@ static struct ixp_alg ixp4xx_algos[] = {
 	},
 	.cfg_enc = CIPH_ENCR | MOD_AES | MOD_CTR,
 	.cfg_dec = CIPH_ENCR | MOD_AES | MOD_CTR,
-}, {
+} };
+
+static struct ixp_aead_alg ixp4xx_aeads[] = {
+{
 	.crypto	= {
-		.cra_name	= "authenc(hmac(md5),cbc(des))",
-		.cra_blocksize	= DES_BLOCK_SIZE,
-		.cra_u		= { .aead = {
-			.ivsize		= DES_BLOCK_SIZE,
-			.maxauthsize	= MD5_DIGEST_SIZE,
-			}
-		}
+		.base = {
+			.cra_name	= "authenc(hmac(md5),cbc(des))",
+			.cra_blocksize	= DES_BLOCK_SIZE,
+		},
+		.ivsize		= DES_BLOCK_SIZE,
+		.maxauthsize	= MD5_DIGEST_SIZE,
 	},
 	.hash = &hash_alg_md5,
 	.cfg_enc = CIPH_ENCR | MOD_DES | MOD_CBC_ENC | KEYLEN_192,
 	.cfg_dec = CIPH_DECR | MOD_DES | MOD_CBC_DEC | KEYLEN_192,
 }, {
 	.crypto	= {
-		.cra_name	= "authenc(hmac(md5),cbc(des3_ede))",
-		.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
-		.cra_u		= { .aead = {
-			.ivsize		= DES3_EDE_BLOCK_SIZE,
-			.maxauthsize	= MD5_DIGEST_SIZE,
-			}
-		}
+		.base = {
+			.cra_name	= "authenc(hmac(md5),cbc(des3_ede))",
+			.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+		},
+		.ivsize		= DES3_EDE_BLOCK_SIZE,
+		.maxauthsize	= MD5_DIGEST_SIZE,
 	},
 	.hash = &hash_alg_md5,
 	.cfg_enc = CIPH_ENCR | MOD_3DES | MOD_CBC_ENC | KEYLEN_192,
 	.cfg_dec = CIPH_DECR | MOD_3DES | MOD_CBC_DEC | KEYLEN_192,
 }, {
 	.crypto	= {
-		.cra_name	= "authenc(hmac(sha1),cbc(des))",
-		.cra_blocksize	= DES_BLOCK_SIZE,
-		.cra_u		= { .aead = {
+		.base = {
+			.cra_name	= "authenc(hmac(sha1),cbc(des))",
+			.cra_blocksize	= DES_BLOCK_SIZE,
+		},
 			.ivsize		= DES_BLOCK_SIZE,
 			.maxauthsize	= SHA1_DIGEST_SIZE,
-			}
-		}
 	},
 	.hash = &hash_alg_sha1,
 	.cfg_enc = CIPH_ENCR | MOD_DES | MOD_CBC_ENC | KEYLEN_192,
 	.cfg_dec = CIPH_DECR | MOD_DES | MOD_CBC_DEC | KEYLEN_192,
 }, {
 	.crypto	= {
-		.cra_name	= "authenc(hmac(sha1),cbc(des3_ede))",
-		.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
-		.cra_u		= { .aead = {
-			.ivsize		= DES3_EDE_BLOCK_SIZE,
-			.maxauthsize	= SHA1_DIGEST_SIZE,
-			}
-		}
+		.base = {
+			.cra_name	= "authenc(hmac(sha1),cbc(des3_ede))",
+			.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+		},
+		.ivsize		= DES3_EDE_BLOCK_SIZE,
+		.maxauthsize	= SHA1_DIGEST_SIZE,
 	},
 	.hash = &hash_alg_sha1,
 	.cfg_enc = CIPH_ENCR | MOD_3DES | MOD_CBC_ENC | KEYLEN_192,
 	.cfg_dec = CIPH_DECR | MOD_3DES | MOD_CBC_DEC | KEYLEN_192,
 }, {
 	.crypto	= {
-		.cra_name	= "authenc(hmac(md5),cbc(aes))",
-		.cra_blocksize	= AES_BLOCK_SIZE,
-		.cra_u		= { .aead = {
-			.ivsize		= AES_BLOCK_SIZE,
-			.maxauthsize	= MD5_DIGEST_SIZE,
-			}
-		}
+		.base = {
+			.cra_name	= "authenc(hmac(md5),cbc(aes))",
+			.cra_blocksize	= AES_BLOCK_SIZE,
+		},
+		.ivsize		= AES_BLOCK_SIZE,
+		.maxauthsize	= MD5_DIGEST_SIZE,
 	},
 	.hash = &hash_alg_md5,
 	.cfg_enc = CIPH_ENCR | MOD_AES | MOD_CBC_ENC,
 	.cfg_dec = CIPH_DECR | MOD_AES | MOD_CBC_DEC,
 }, {
 	.crypto	= {
-		.cra_name	= "authenc(hmac(sha1),cbc(aes))",
-		.cra_blocksize	= AES_BLOCK_SIZE,
-		.cra_u		= { .aead = {
-			.ivsize		= AES_BLOCK_SIZE,
-			.maxauthsize	= SHA1_DIGEST_SIZE,
-			}
-		}
+		.base = {
+			.cra_name	= "authenc(hmac(sha1),cbc(aes))",
+			.cra_blocksize	= AES_BLOCK_SIZE,
+		},
+		.ivsize		= AES_BLOCK_SIZE,
+		.maxauthsize	= SHA1_DIGEST_SIZE,
 	},
 	.hash = &hash_alg_sha1,
 	.cfg_enc = CIPH_ENCR | MOD_AES | MOD_CBC_ENC,
@@ -1436,32 +1413,20 @@ static int __init ixp_module_init(void)
 		if (!support_aes && (ixp4xx_algos[i].cfg_enc & MOD_AES)) {
 			continue;
 		}
-		if (!ixp4xx_algos[i].hash) {
-			/* block ciphers */
-			cra->cra_type = &crypto_ablkcipher_type;
-			cra->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					 CRYPTO_ALG_KERN_DRIVER_ONLY |
-					 CRYPTO_ALG_ASYNC;
-			if (!cra->cra_ablkcipher.setkey)
-				cra->cra_ablkcipher.setkey = ablk_setkey;
-			if (!cra->cra_ablkcipher.encrypt)
-				cra->cra_ablkcipher.encrypt = ablk_encrypt;
-			if (!cra->cra_ablkcipher.decrypt)
-				cra->cra_ablkcipher.decrypt = ablk_decrypt;
-			cra->cra_init = init_tfm_ablk;
-		} else {
-			/* authenc */
-			cra->cra_type = &crypto_aead_type;
-			cra->cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					 CRYPTO_ALG_KERN_DRIVER_ONLY |
-					 CRYPTO_ALG_ASYNC;
-			cra->cra_aead.setkey = aead_setkey;
-			cra->cra_aead.setauthsize = aead_setauthsize;
-			cra->cra_aead.encrypt = aead_encrypt;
-			cra->cra_aead.decrypt = aead_decrypt;
-			cra->cra_aead.givencrypt = aead_givencrypt;
-			cra->cra_init = init_tfm_aead;
-		}
+
+		/* block ciphers */
+		cra->cra_type = &crypto_ablkcipher_type;
+		cra->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				 CRYPTO_ALG_KERN_DRIVER_ONLY |
+				 CRYPTO_ALG_ASYNC;
+		if (!cra->cra_ablkcipher.setkey)
+			cra->cra_ablkcipher.setkey = ablk_setkey;
+		if (!cra->cra_ablkcipher.encrypt)
+			cra->cra_ablkcipher.encrypt = ablk_encrypt;
+		if (!cra->cra_ablkcipher.decrypt)
+			cra->cra_ablkcipher.decrypt = ablk_decrypt;
+		cra->cra_init = init_tfm_ablk;
+
 		cra->cra_ctxsize = sizeof(struct ixp_ctx);
 		cra->cra_module = THIS_MODULE;
 		cra->cra_alignmask = 3;
@@ -1473,6 +1438,39 @@ static int __init ixp_module_init(void)
 		else
 			ixp4xx_algos[i].registered = 1;
 	}
+
+	for (i = 0; i < ARRAY_SIZE(ixp4xx_aeads); i++) {
+		struct aead_alg *cra = &ixp4xx_aeads[i].crypto;
+
+		if (snprintf(cra->base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+			     "%s"IXP_POSTFIX, cra->base.cra_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			continue;
+		if (!support_aes && (ixp4xx_algos[i].cfg_enc & MOD_AES))
+			continue;
+
+		/* authenc */
+		cra->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+				      CRYPTO_ALG_AEAD_NEW |
+				      CRYPTO_ALG_ASYNC;
+		cra->setkey = aead_setkey;
+		cra->setauthsize = aead_setauthsize;
+		cra->encrypt = aead_encrypt;
+		cra->decrypt = aead_decrypt;
+		cra->init = init_tfm_aead;
+		cra->exit = exit_tfm_aead;
+
+		cra->base.cra_ctxsize = sizeof(struct ixp_ctx);
+		cra->base.cra_module = THIS_MODULE;
+		cra->base.cra_alignmask = 3;
+		cra->base.cra_priority = 300;
+
+		if (crypto_register_aead(cra))
+			printk(KERN_ERR "Failed to register '%s'\n",
+				cra->base.cra_driver_name);
+		else
+			ixp4xx_aeads[i].registered = 1;
+	}
 	return 0;
 }
 
@@ -1481,6 +1479,11 @@ static void __exit ixp_module_exit(void)
 	int num = ARRAY_SIZE(ixp4xx_algos);
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(ixp4xx_aeads); i++) {
+		if (ixp4xx_aeads[i].registered)
+			crypto_unregister_aead(&ixp4xx_aeads[i].crypto);
+	}
+
 	for (i=0; i< num; i++) {
 		if (ixp4xx_algos[i].registered)
 			crypto_unregister_alg(&ixp4xx_algos[i].crypto);
