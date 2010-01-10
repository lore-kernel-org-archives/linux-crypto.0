From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: IXP4xx: Fix whitespace problems in ixp4xx_crypto.
Date: Sun, 10 Jan 2010 18:33:37 +0100
Message-ID: <m3iqb93lvy.fsf@intrepid.localdomain>
References: <m34omu3rf7.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:53321 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab0AJRdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2010 12:33:41 -0500
In-Reply-To: <m34omu3rf7.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Sun, 10 Jan 2010 16:35:38 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index 0c7e4f5..f8f6515 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -64,7 +64,7 @@
=20
 #define MOD_DES     0x0000
 #define MOD_TDEA2   0x0100
-#define MOD_3DES   0x0200
+#define MOD_3DES    0x0200
 #define MOD_AES     0x0800
 #define MOD_AES128  (0x0800 | KEYLEN_128)
 #define MOD_AES192  (0x0900 | KEYLEN_192)
@@ -137,7 +137,7 @@ struct crypt_ctl {
 	u32 aadAddr;		/* Additional Auth Data Addr for CCM mode */
 	u32 crypto_ctx;		/* NPE Crypto Param structure address */
=20
-	/* Used by Host: 4*4 bytes*/
+	/* Used only by host: 4 * 4 bytes */
 	unsigned ctl_flags;
 	union {
 		struct ablkcipher_request *ablk_req;
@@ -208,10 +208,10 @@ static const struct ix_hash_algo hash_alg_sha1 =3D=
 {
 };
=20
 static struct npe *npe_c;
-static struct dma_pool *buffer_pool =3D NULL;
-static struct dma_pool *ctx_pool =3D NULL;
+static struct dma_pool *buffer_pool;
+static struct dma_pool *ctx_pool;
=20
-static struct crypt_ctl *crypt_virt =3D NULL;
+static struct crypt_ctl *crypt_virt;
 static dma_addr_t crypt_phys;
=20
 static int support_aes =3D 1;
@@ -246,12 +246,12 @@ static inline struct crypt_ctl *crypt_phys2virt(d=
ma_addr_t phys)
=20
 static inline u32 cipher_cfg_enc(struct crypto_tfm *tfm)
 {
-	return container_of(tfm->__crt_alg, struct ixp_alg,crypto)->cfg_enc;
+	return container_of(tfm->__crt_alg, struct ixp_alg, crypto)->cfg_enc;
 }
=20
 static inline u32 cipher_cfg_dec(struct crypto_tfm *tfm)
 {
-	return container_of(tfm->__crt_alg, struct ixp_alg,crypto)->cfg_dec;
+	return container_of(tfm->__crt_alg, struct ixp_alg, crypto)->cfg_dec;
 }
=20
 static inline const struct ix_hash_algo *ix_hash(struct crypto_tfm *tf=
m)
@@ -275,7 +275,7 @@ static spinlock_t desc_lock;
 static struct crypt_ctl *get_crypt_desc(void)
 {
 	int i;
-	static int idx =3D 0;
+	static int idx;
 	unsigned long flags;
 	struct crypt_ctl *desc =3D NULL;
=20
@@ -318,13 +318,13 @@ static struct crypt_ctl *get_crypt_desc_emerg(voi=
d)
 		if (++idx >=3D NPE_QLEN_TOTAL)
 			idx =3D NPE_QLEN;
 		crypt_virt[i].ctl_flags =3D CTL_FLAG_USED;
-		desc =3D crypt_virt +i;
+		desc =3D crypt_virt + i;
 	}
 	spin_unlock_irqrestore(&emerg_lock, flags);
 	return desc;
 }
=20
-static void free_buf_chain(struct device *dev, struct buffer_desc *buf=
,u32 phys)
+static void free_buf_chain(struct device *dev, struct buffer_desc *buf=
, u32 phys)
 {
 	while (buf) {
 		struct buffer_desc *buf1;
@@ -349,10 +349,9 @@ static void finish_scattered_hmac(struct crypt_ctl=
 *crypt)
 	int authsize =3D crypto_aead_authsize(tfm);
 	int decryptlen =3D req->cryptlen - authsize;
=20
-	if (req_ctx->encrypt) {
+	if (req_ctx->encrypt)
 		scatterwalk_map_and_copy(req_ctx->hmac_virt,
 			req->src, decryptlen, authsize, 1);
-	}
 	dma_pool_free(buffer_pool, req_ctx->hmac_virt, crypt->icv_rev_aes);
 }
=20
@@ -372,9 +371,8 @@ static void one_packet(dma_addr_t phys)
 		struct aead_ctx *req_ctx =3D aead_request_ctx(req);
=20
 		free_buf_chain(dev, req_ctx->buffer, crypt->src_buf);
-		if (req_ctx->hmac_virt) {
+		if (req_ctx->hmac_virt)
 			finish_scattered_hmac(crypt);
-		}
 		req->base.complete(&req->base, failed);
 		break;
 	}
@@ -382,9 +380,8 @@ static void one_packet(dma_addr_t phys)
 		struct ablkcipher_request *req =3D crypt->data.ablk_req;
 		struct ablk_ctx *req_ctx =3D ablkcipher_request_ctx(req);
=20
-		if (req_ctx->dst) {
+		if (req_ctx->dst)
 			free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
-		}
 		free_buf_chain(dev, req_ctx->src, crypt->src_buf);
 		req->base.complete(&req->base, failed);
 		break;
@@ -418,7 +415,7 @@ static void crypto_done_action(unsigned long arg)
 {
 	int i;
=20
-	for(i=3D0; i<4; i++) {
+	for (i =3D 0; i < 4; i++) {
 		dma_addr_t phys =3D qmgr_get_entry(RECV_QID);
 		if (!phys)
 			return;
@@ -443,9 +440,8 @@ static int init_ixp_crypto(void)
=20
 	if (!npe_running(npe_c)) {
 		ret =3D npe_load_firmware(npe_c, npe_name(npe_c), dev);
-		if (ret) {
+		if (ret)
 			return ret;
-		}
 		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
 			goto npe_error;
 	} else {
@@ -478,14 +474,12 @@ static int init_ixp_crypto(void)
 	buffer_pool =3D dma_pool_create("buffer", dev,
 			sizeof(struct buffer_desc), 32, 0);
 	ret =3D -ENOMEM;
-	if (!buffer_pool) {
+	if (!buffer_pool)
 		goto err;
-	}
 	ctx_pool =3D dma_pool_create("context", dev,
 			NPE_CTX_LEN, 16, 0);
-	if (!ctx_pool) {
+	if (!ctx_pool)
 		goto err;
-	}
 	ret =3D qmgr_request_queue(SEND_QID, NPE_QLEN_TOTAL, 0, 0,
 				 "ixp_crypto:out", NULL);
 	if (ret)
@@ -527,11 +521,10 @@ static void release_ixp_crypto(void)
=20
 	npe_release(npe_c);
=20
-	if (crypt_virt) {
+	if (crypt_virt)
 		dma_free_coherent(dev,
-			NPE_QLEN_TOTAL * sizeof( struct crypt_ctl),
+			NPE_QLEN_TOTAL * sizeof(struct crypt_ctl),
 			crypt_virt, crypt_phys);
-	}
 	return;
 }
=20
@@ -545,9 +538,8 @@ static void reset_sa_dir(struct ix_sa_dir *dir)
 static int init_sa_dir(struct ix_sa_dir *dir)
 {
 	dir->npe_ctx =3D dma_pool_alloc(ctx_pool, GFP_KERNEL, &dir->npe_ctx_p=
hys);
-	if (!dir->npe_ctx) {
+	if (!dir->npe_ctx)
 		return -ENOMEM;
-	}
 	reset_sa_dir(dir);
 	return 0;
 }
@@ -568,9 +560,8 @@ static int init_tfm(struct crypto_tfm *tfm)
 	if (ret)
 		return ret;
 	ret =3D init_sa_dir(&ctx->decrypt);
-	if (ret) {
+	if (ret)
 		free_sa_dir(&ctx->encrypt);
-	}
 	return ret;
 }
=20
@@ -621,9 +612,8 @@ static int register_chain_var(struct crypto_tfm *tf=
m, u8 xpad, u32 target,
=20
 	memcpy(pad, key, key_len);
 	memset(pad + key_len, 0, HMAC_PAD_BLOCKLEN - key_len);
-	for (i =3D 0; i < HMAC_PAD_BLOCKLEN; i++) {
+	for (i =3D 0; i < HMAC_PAD_BLOCKLEN; i++)
 		pad[i] ^=3D xpad;
-	}
=20
 	crypt->data.tfm =3D tfm;
 	crypt->regist_ptr =3D pad;
@@ -665,7 +655,7 @@ static int setup_auth(struct crypto_tfm *tfm, int e=
ncrypt, unsigned authsize,
 	algo =3D ix_hash(tfm);
=20
 	/* write cfg word to cryptinfo */
-	cfgword =3D algo->cfgword | ( authsize << 6); /* (authsize/4) << 8 */
+	cfgword =3D algo->cfgword | (authsize << 6); /* (authsize/4) << 8 */
 #ifndef __ARMEB__
 	cfgword ^=3D 0xAA000000; /* change the "byte swap" flags */
 #endif
@@ -703,9 +693,8 @@ static int gen_rev_aes_key(struct crypto_tfm *tfm)
 	struct ix_sa_dir *dir =3D &ctx->decrypt;
=20
 	crypt =3D get_crypt_desc_emerg();
-	if (!crypt) {
+	if (!crypt)
 		return -EAGAIN;
-	}
 	*(__be32 *)dir->npe_ctx |=3D cpu_to_be32(CIPH_ENCR);
=20
 	crypt->data.tfm =3D tfm;
@@ -740,32 +729,30 @@ static int setup_cipher(struct crypto_tfm *tfm, i=
nt encrypt,
 	if (encrypt) {
 		cipher_cfg =3D cipher_cfg_enc(tfm);
 		dir->npe_mode |=3D NPE_OP_CRYPT_ENCRYPT;
-	} else {
+	} else
 		cipher_cfg =3D cipher_cfg_dec(tfm);
-	}
+
 	if (cipher_cfg & MOD_AES) {
 		switch (key_len) {
-			case 16: keylen_cfg =3D MOD_AES128 | KEYLEN_128; break;
-			case 24: keylen_cfg =3D MOD_AES192 | KEYLEN_192; break;
-			case 32: keylen_cfg =3D MOD_AES256 | KEYLEN_256; break;
-			default:
-				*flags |=3D CRYPTO_TFM_RES_BAD_KEY_LEN;
-				return -EINVAL;
+		case 16: keylen_cfg =3D MOD_AES128 | KEYLEN_128; break;
+		case 24: keylen_cfg =3D MOD_AES192 | KEYLEN_192; break;
+		case 32: keylen_cfg =3D MOD_AES256 | KEYLEN_256; break;
+		default:
+			*flags |=3D CRYPTO_TFM_RES_BAD_KEY_LEN;
+			return -EINVAL;
 		}
 		cipher_cfg |=3D keylen_cfg;
 	} else if (cipher_cfg & MOD_3DES) {
 		const u32 *K =3D (const u32 *)key;
 		if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-			     !((K[2] ^ K[4]) | (K[3] ^ K[5]))))
-		{
+			     !((K[2] ^ K[4]) | (K[3] ^ K[5])))) {
 			*flags |=3D CRYPTO_TFM_RES_BAD_KEY_SCHED;
 			return -EINVAL;
 		}
 	} else {
 		u32 tmp[DES_EXPKEY_WORDS];
-		if (des_ekey(tmp, key) =3D=3D 0) {
+		if (des_ekey(tmp, key) =3D=3D 0)
 			*flags |=3D CRYPTO_TFM_RES_WEAK_KEY;
-		}
 	}
 	/* write cfg word to cryptinfo */
 	*(__be32 *)cinfo =3D cpu_to_be32(cipher_cfg);
@@ -775,14 +762,13 @@ static int setup_cipher(struct crypto_tfm *tfm, i=
nt encrypt,
 	memcpy(cinfo, key, key_len);
 	/* NPE wants keylen set to DES3_EDE_KEY_SIZE even for single DES */
 	if (key_len < DES3_EDE_KEY_SIZE && !(cipher_cfg & MOD_AES)) {
-		memset(cinfo + key_len, 0, DES3_EDE_KEY_SIZE -key_len);
+		memset(cinfo + key_len, 0, DES3_EDE_KEY_SIZE - key_len);
 		key_len =3D DES3_EDE_KEY_SIZE;
 	}
 	dir->npe_ctx_idx =3D sizeof(cipher_cfg) + key_len;
 	dir->npe_mode |=3D NPE_OP_CRYPT_ENABLE;
-	if ((cipher_cfg & MOD_AES) && !encrypt) {
+	if ((cipher_cfg & MOD_AES) && !encrypt)
 		return gen_rev_aes_key(tfm);
-	}
 	return 0;
 }
=20
@@ -791,7 +777,7 @@ static struct buffer_desc *chainup_buffers(struct d=
evice *dev,
 		struct buffer_desc *buf, gfp_t flags,
 		enum dma_data_direction dir)
 {
-	for (;nbytes > 0; sg =3D scatterwalk_sg_next(sg)) {
+	for (; nbytes > 0; sg =3D scatterwalk_sg_next(sg)) {
 		unsigned len =3D min(nbytes, sg->length);
 		struct buffer_desc *next_buf;
 		u32 next_buf_phys;
@@ -842,11 +828,10 @@ static int ablk_setkey(struct crypto_ablkcipher *=
tfm, const u8 *key,
 		goto out;
=20
 	if (*flags & CRYPTO_TFM_RES_WEAK_KEY) {
-		if (*flags & CRYPTO_TFM_REQ_WEAK_KEY) {
+		if (*flags & CRYPTO_TFM_REQ_WEAK_KEY)
 			ret =3D -EINVAL;
-		} else {
+		else
 			*flags &=3D ~CRYPTO_TFM_RES_WEAK_KEY;
-		}
 	}
 out:
 	if (!atomic_dec_and_test(&ctx->configuring))
@@ -918,9 +903,8 @@ static int ablk_perform(struct ablkcipher_request *=
req, int encrypt)
 		src_direction =3D DMA_TO_DEVICE;
 		req_ctx->dst =3D dst_hook.next;
 		crypt->dst_buf =3D dst_hook.phys_next;
-	} else {
+	} else
 		req_ctx->dst =3D NULL;
-	}
 	req_ctx->src =3D NULL;
 	if (!chainup_buffers(dev, req->src, nbytes, &src_hook,
 				flags, src_direction))
@@ -936,9 +920,8 @@ static int ablk_perform(struct ablkcipher_request *=
req, int encrypt)
 free_buf_src:
 	free_buf_chain(dev, req_ctx->src, crypt->src_buf);
 free_buf_dest:
-	if (req->src !=3D req->dst) {
+	if (req->src !=3D req->dst)
 		free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
-	}
 	crypt->ctl_flags =3D CTL_FLAG_UNUSED;
 	return -ENOMEM;
 }
@@ -962,7 +945,7 @@ static int ablk_rfc3686_crypt(struct ablkcipher_req=
uest *req)
 	int ret;
=20
 	/* set up counter block */
-        memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
+	memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
 	memcpy(iv + CTR_RFC3686_NONCE_SIZE, info, CTR_RFC3686_IV_SIZE);
=20
 	/* initialize counter portion of counter block */
@@ -1019,7 +1002,7 @@ static int aead_perform(struct aead_request *req,=
 int encrypt,
 	} else {
 		dir =3D &ctx->decrypt;
 		/* req->cryptlen includes the authsize when decrypting */
-		cryptlen =3D req->cryptlen -authsize;
+		cryptlen =3D req->cryptlen - authsize;
 		eff_cryptlen -=3D authsize;
 	}
 	crypt =3D get_crypt_desc();
@@ -1039,9 +1022,8 @@ static int aead_perform(struct aead_request *req,=
 int encrypt,
 	BUG_ON(ivsize && !req->iv);
 	memcpy(crypt->iv, req->iv, ivsize);
=20
-	if (req->src !=3D req->dst) {
+	if (req->src !=3D req->dst)
 		BUG(); /* -ENOTSUP because of my lazyness */
-	}
=20
 	/* ASSOC data */
 	buf =3D chainup_buffers(dev, req->assoc, req->assoclen, &src_hook,
@@ -1064,32 +1046,28 @@ static int aead_perform(struct aead_request *re=
q, int encrypt,
 				&crypt->icv_rev_aes);
 		if (unlikely(!req_ctx->hmac_virt))
 			goto free_chain;
-		if (!encrypt) {
+		if (!encrypt)
 			scatterwalk_map_and_copy(req_ctx->hmac_virt,
 				req->src, cryptlen, authsize, 0);
-		}
 		req_ctx->encrypt =3D encrypt;
-	} else {
+	} else
 		req_ctx->hmac_virt =3D NULL;
-	}
 	/* Crypt */
 	buf =3D chainup_buffers(dev, req->src, cryptlen + authsize, buf, flag=
s,
 			DMA_BIDIRECTIONAL);
 	if (!buf)
 		goto free_hmac_virt;
-	if (!req_ctx->hmac_virt) {
+	if (!req_ctx->hmac_virt)
 		crypt->icv_rev_aes =3D buf->phys_addr + buf->buf_len - authsize;
-	}
=20
 	crypt->ctl_flags |=3D CTL_FLAG_PERFORM_AEAD;
 	qmgr_put_entry(SEND_QID, crypt_virt2phys(crypt));
 	BUG_ON(qmgr_stat_overflow(SEND_QID));
 	return -EINPROGRESS;
 free_hmac_virt:
-	if (req_ctx->hmac_virt) {
+	if (req_ctx->hmac_virt)
 		dma_pool_free(buffer_pool, req_ctx->hmac_virt,
 				crypt->icv_rev_aes);
-	}
 free_chain:
 	free_buf_chain(dev, req_ctx->buffer, crypt->src_buf);
 out:
@@ -1131,9 +1109,8 @@ static int aead_setup(struct crypto_aead *tfm, un=
signed int authsize)
 		if (*flags & CRYPTO_TFM_REQ_WEAK_KEY) {
 			ret =3D -EINVAL;
 			goto out;
-		} else {
+		} else
 			*flags &=3D ~CRYPTO_TFM_RES_WEAK_KEY;
-		}
 	}
 out:
 	if (!atomic_dec_and_test(&ctx->configuring))
@@ -1219,7 +1196,7 @@ static int aead_givencrypt(struct aead_givcrypt_r=
equest *req)
 	seq =3D cpu_to_be64(req->seq);
 	memcpy(req->giv + ivsize - len, &seq, len);
 	return aead_perform(&req->areq, 1, req->areq.assoclen,
-			req->areq.cryptlen +ivsize, req->giv);
+			req->areq.cryptlen + ivsize, req->giv);
 }
=20
 static struct ixp_alg ixp4xx_algos[] =3D {
@@ -1416,7 +1393,7 @@ static struct ixp_alg ixp4xx_algos[] =3D {
 static int __init ixp_module_init(void)
 {
 	int num =3D ARRAY_SIZE(ixp4xx_algos);
-	int i,err ;
+	int i, err ;
=20
 	if (platform_device_register(&pseudo_dev))
 		return -ENODEV;
@@ -1429,18 +1406,14 @@ static int __init ixp_module_init(void)
 		platform_device_unregister(&pseudo_dev);
 		return err;
 	}
-	for (i=3D0; i< num; i++) {
+	for (i =3D 0; i < num; i++) {
 		struct crypto_alg *cra =3D &ixp4xx_algos[i].crypto;
=20
 		if (snprintf(cra->cra_driver_name, CRYPTO_MAX_ALG_NAME,
-			"%s"IXP_POSTFIX, cra->cra_name) >=3D
-			CRYPTO_MAX_ALG_NAME)
-		{
+			"%s"IXP_POSTFIX, cra->cra_name) >=3D CRYPTO_MAX_ALG_NAME)
 			continue;
-		}
-		if (!support_aes && (ixp4xx_algos[i].cfg_enc & MOD_AES)) {
+		if (!support_aes && (ixp4xx_algos[i].cfg_enc & MOD_AES))
 			continue;
-		}
 		if (!ixp4xx_algos[i].hash) {
 			/* block ciphers */
 			cra->cra_type =3D &crypto_ablkcipher_type;
@@ -1484,7 +1457,7 @@ static void __exit ixp_module_exit(void)
 	int num =3D ARRAY_SIZE(ixp4xx_algos);
 	int i;
=20
-	for (i=3D0; i< num; i++) {
+	for (i =3D 0; i < num; i++) {
 		if (ixp4xx_algos[i].registered)
 			crypto_unregister_alg(&ixp4xx_algos[i].crypto);
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
