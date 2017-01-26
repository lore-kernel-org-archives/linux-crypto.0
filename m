From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 09/12] crypto: atmel-sha: add support to hmac(shaX)
Date: Thu, 26 Jan 2017 17:07:54 +0100
Message-ID: <e5616d5b82baf0dcfb1d6df1541e2bd99aa9a43a.1485443478.git.cyrille.pitchen@atmel.com>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, Cyrille Pitchen <cyrille.pitchen@atmel.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
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

This patch adds support to the hmac(shaX) algorithms.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha-regs.h |   4 +
 drivers/crypto/atmel-sha.c      | 598 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 601 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha-regs.h b/drivers/crypto/atmel-sha-regs.h
index 8d62d31eda08..1b9f3d33079e 100644
--- a/drivers/crypto/atmel-sha-regs.h
+++ b/drivers/crypto/atmel-sha-regs.h
@@ -26,6 +26,7 @@
 #define SHA_MR_ALGO_SHA384		(2 << 8)
 #define SHA_MR_ALGO_SHA512		(3 << 8)
 #define SHA_MR_ALGO_SHA224		(4 << 8)
+#define SHA_MR_HMAC			(1 << 11)
 #define	SHA_MR_DUALBUFF			(1 << 16)
 
 #define SHA_IER				0x10
@@ -42,6 +43,9 @@
 #define SHA_ISR_URAT_MR			(0x2 << 12)
 #define SHA_ISR_URAT_WO			(0x5 << 12)
 
+#define SHA_MSR				0x20
+#define SHA_BCR				0x30
+
 #define	SHA_HW_VERSION		0xFC
 
 #define SHA_TPR				0x108
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index a4fc60b67099..78c3c02e4483 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -51,13 +51,20 @@
 #define SHA_FLAGS_CPU			BIT(5)
 #define SHA_FLAGS_DMA_READY		BIT(6)
 
-/* bits[10:8] are reserved. */
+/* bits[11:8] are reserved. */
 #define SHA_FLAGS_ALGO_MASK	SHA_MR_ALGO_MASK
 #define SHA_FLAGS_SHA1		SHA_MR_ALGO_SHA1
 #define SHA_FLAGS_SHA256	SHA_MR_ALGO_SHA256
 #define SHA_FLAGS_SHA384	SHA_MR_ALGO_SHA384
 #define SHA_FLAGS_SHA512	SHA_MR_ALGO_SHA512
 #define SHA_FLAGS_SHA224	SHA_MR_ALGO_SHA224
+#define SHA_FLAGS_HMAC		SHA_MR_HMAC
+#define SHA_FLAGS_HMAC_SHA1	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA1)
+#define SHA_FLAGS_HMAC_SHA256	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA256)
+#define SHA_FLAGS_HMAC_SHA384	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA384)
+#define SHA_FLAGS_HMAC_SHA512	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA512)
+#define SHA_FLAGS_HMAC_SHA224	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA224)
+#define SHA_FLAGS_MODE_MASK	(SHA_FLAGS_HMAC | SHA_FLAGS_ALGO_MASK)
 
 #define SHA_FLAGS_FINUP		BIT(16)
 #define SHA_FLAGS_SG		BIT(17)
@@ -67,8 +74,10 @@
 #define SHA_FLAGS_IDATAR0	BIT(26)
 #define SHA_FLAGS_WAIT_DATARDY	BIT(27)
 
+#define SHA_OP_INIT	0
 #define SHA_OP_UPDATE	1
 #define SHA_OP_FINAL	2
+#define SHA_OP_DIGEST	3
 
 #define SHA_BUFFER_LEN		(PAGE_SIZE / 16)
 
@@ -80,6 +89,7 @@ struct atmel_sha_caps {
 	bool	has_sha224;
 	bool	has_sha_384_512;
 	bool	has_uihv;
+	bool	has_hmac;
 };
 
 struct atmel_sha_dev;
@@ -105,6 +115,7 @@ struct atmel_sha_reqctx {
 	unsigned int	total;	/* total request */
 
 	size_t block_size;
+	size_t hash_size;
 
 	u8 buffer[SHA_BUFFER_LEN + SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
 };
@@ -152,6 +163,8 @@ struct atmel_sha_dev {
 
 	struct atmel_sha_caps	caps;
 
+	struct scatterlist	tmp;
+
 	u32	hw_version;
 };
 
@@ -1522,11 +1535,579 @@ static int atmel_sha_cpu_start(struct atmel_sha_dev *dd,
 	return atmel_sha_cpu_transfer(dd);
 }
 
+static int atmel_sha_cpu_hash(struct atmel_sha_dev *dd,
+			      const void *data, unsigned int datalen,
+			      bool auto_padding,
+			      atmel_sha_fn_t resume)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	u32 msglen = (auto_padding) ? datalen : 0;
+	u32 mr = SHA_MR_MODE_AUTO;
+
+	if (!(IS_ALIGNED(datalen, ctx->block_size) || auto_padding))
+		return atmel_sha_complete(dd, -EINVAL);
+
+	mr |= (ctx->flags & SHA_FLAGS_ALGO_MASK);
+	atmel_sha_write(dd, SHA_MR, mr);
+	atmel_sha_write(dd, SHA_MSR, msglen);
+	atmel_sha_write(dd, SHA_BCR, msglen);
+	atmel_sha_write(dd, SHA_CR, SHA_CR_FIRST);
+
+	sg_init_one(&dd->tmp, data, datalen);
+	return atmel_sha_cpu_start(dd, &dd->tmp, datalen, false, true, resume);
+}
+
+
+/* hmac functions */
+
+struct atmel_sha_hmac_key {
+	bool			valid;
+	unsigned int		keylen;
+	u8			buffer[SHA512_BLOCK_SIZE];
+	u8			*keydup;
+};
+
+static inline void atmel_sha_hmac_key_init(struct atmel_sha_hmac_key *hkey)
+{
+	memset(hkey, 0, sizeof(*hkey));
+}
+
+static inline void atmel_sha_hmac_key_release(struct atmel_sha_hmac_key *hkey)
+{
+	kfree(hkey->keydup);
+	memset(hkey, 0, sizeof(*hkey));
+}
+
+static inline int atmel_sha_hmac_key_set(struct atmel_sha_hmac_key *hkey,
+					 const u8 *key,
+					 unsigned int keylen)
+{
+	atmel_sha_hmac_key_release(hkey);
+
+	if (keylen > sizeof(hkey->buffer)) {
+		hkey->keydup = kmemdup(key, keylen, GFP_KERNEL);
+		if (!hkey->keydup)
+			return -ENOMEM;
+
+	} else {
+		memcpy(hkey->buffer, key, keylen);
+	}
+
+	hkey->valid = true;
+	hkey->keylen = keylen;
+	return 0;
+}
+
+static inline bool atmel_sha_hmac_key_get(const struct atmel_sha_hmac_key *hkey,
+					  const u8 **key,
+					  unsigned int *keylen)
+{
+	if (!hkey->valid)
+		return false;
+
+	*keylen = hkey->keylen;
+	*key = (hkey->keydup) ? hkey->keydup : hkey->buffer;
+	return true;
+}
+
+
+struct atmel_sha_hmac_ctx {
+	struct atmel_sha_ctx	base;
+
+	struct atmel_sha_hmac_key	hkey;
+	u32			ipad[SHA512_BLOCK_SIZE / sizeof(u32)];
+	u32			opad[SHA512_BLOCK_SIZE / sizeof(u32)];
+	atmel_sha_fn_t		resume;
+};
+
+static int atmel_sha_hmac_setup(struct atmel_sha_dev *dd,
+				atmel_sha_fn_t resume);
+static int atmel_sha_hmac_prehash_key(struct atmel_sha_dev *dd,
+				      const u8 *key, unsigned int keylen);
+static int atmel_sha_hmac_prehash_key_done(struct atmel_sha_dev *dd);
+static int atmel_sha_hmac_compute_ipad_hash(struct atmel_sha_dev *dd);
+static int atmel_sha_hmac_compute_opad_hash(struct atmel_sha_dev *dd);
+static int atmel_sha_hmac_setup_done(struct atmel_sha_dev *dd);
+
+static int atmel_sha_hmac_init_done(struct atmel_sha_dev *dd);
+static int atmel_sha_hmac_final(struct atmel_sha_dev *dd);
+static int atmel_sha_hmac_final_done(struct atmel_sha_dev *dd);
+static int atmel_sha_hmac_digest2(struct atmel_sha_dev *dd);
+
+static int atmel_sha_hmac_setup(struct atmel_sha_dev *dd,
+				atmel_sha_fn_t resume)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	unsigned int keylen;
+	const u8 *key;
+	size_t bs;
+
+	hmac->resume = resume;
+	switch (ctx->flags & SHA_FLAGS_ALGO_MASK) {
+	case SHA_FLAGS_SHA1:
+		ctx->block_size = SHA1_BLOCK_SIZE;
+		ctx->hash_size = SHA1_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA224:
+		ctx->block_size = SHA224_BLOCK_SIZE;
+		ctx->hash_size = SHA256_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA256:
+		ctx->block_size = SHA256_BLOCK_SIZE;
+		ctx->hash_size = SHA256_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA384:
+		ctx->block_size = SHA384_BLOCK_SIZE;
+		ctx->hash_size = SHA512_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA512:
+		ctx->block_size = SHA512_BLOCK_SIZE;
+		ctx->hash_size = SHA512_DIGEST_SIZE;
+		break;
+
+	default:
+		return atmel_sha_complete(dd, -EINVAL);
+	}
+	bs = ctx->block_size;
+
+	if (likely(!atmel_sha_hmac_key_get(&hmac->hkey, &key, &keylen)))
+		return resume(dd);
+
+	/* Compute K' from K. */
+	if (unlikely(keylen > bs))
+		return atmel_sha_hmac_prehash_key(dd, key, keylen);
+
+	/* Prepare ipad. */
+	memcpy((u8 *)hmac->ipad, key, keylen);
+	memset((u8 *)hmac->ipad + keylen, 0, bs - keylen);
+	return atmel_sha_hmac_compute_ipad_hash(dd);
+}
+
+static int atmel_sha_hmac_prehash_key(struct atmel_sha_dev *dd,
+				      const u8 *key, unsigned int keylen)
+{
+	return atmel_sha_cpu_hash(dd, key, keylen, true,
+				  atmel_sha_hmac_prehash_key_done);
+}
+
+static int atmel_sha_hmac_prehash_key_done(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	size_t ds = crypto_ahash_digestsize(tfm);
+	size_t bs = ctx->block_size;
+	size_t i, num_words = ds / sizeof(u32);
+
+	/* Prepare ipad. */
+	for (i = 0; i < num_words; ++i)
+		hmac->ipad[i] = atmel_sha_read(dd, SHA_REG_DIGEST(i));
+	memset((u8 *)hmac->ipad + ds, 0, bs - ds);
+	return atmel_sha_hmac_compute_ipad_hash(dd);
+}
+
+static int atmel_sha_hmac_compute_ipad_hash(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	size_t bs = ctx->block_size;
+	size_t i, num_words = bs / sizeof(u32);
+
+	memcpy(hmac->opad, hmac->ipad, bs);
+	for (i = 0; i < num_words; ++i) {
+		hmac->ipad[i] ^= 0x36363636;
+		hmac->opad[i] ^= 0x5c5c5c5c;
+	}
+
+	return atmel_sha_cpu_hash(dd, hmac->ipad, bs, false,
+				  atmel_sha_hmac_compute_opad_hash);
+}
+
+static int atmel_sha_hmac_compute_opad_hash(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	size_t bs = ctx->block_size;
+	size_t hs = ctx->hash_size;
+	size_t i, num_words = hs / sizeof(u32);
+
+	for (i = 0; i < num_words; ++i)
+		hmac->ipad[i] = atmel_sha_read(dd, SHA_REG_DIGEST(i));
+	return atmel_sha_cpu_hash(dd, hmac->opad, bs, false,
+				  atmel_sha_hmac_setup_done);
+}
+
+static int atmel_sha_hmac_setup_done(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	size_t hs = ctx->hash_size;
+	size_t i, num_words = hs / sizeof(u32);
+
+	for (i = 0; i < num_words; ++i)
+		hmac->opad[i] = atmel_sha_read(dd, SHA_REG_DIGEST(i));
+	atmel_sha_hmac_key_release(&hmac->hkey);
+	return hmac->resume(dd);
+}
+
+static int atmel_sha_hmac_start(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	int err;
+
+	err = atmel_sha_hw_init(dd);
+	if (err)
+		return atmel_sha_complete(dd, err);
+
+	switch (ctx->op) {
+	case SHA_OP_INIT:
+		err = atmel_sha_hmac_setup(dd, atmel_sha_hmac_init_done);
+		break;
+
+	case SHA_OP_UPDATE:
+		dd->resume = atmel_sha_done;
+		err = atmel_sha_update_req(dd);
+		break;
+
+	case SHA_OP_FINAL:
+		dd->resume = atmel_sha_hmac_final;
+		err = atmel_sha_final_req(dd);
+		break;
+
+	case SHA_OP_DIGEST:
+		err = atmel_sha_hmac_setup(dd, atmel_sha_hmac_digest2);
+		break;
+
+	default:
+		return atmel_sha_complete(dd, -EINVAL);
+	}
+
+	return err;
+}
+
+static int atmel_sha_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+
+	if (atmel_sha_hmac_key_set(&hmac->hkey, key, keylen)) {
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int atmel_sha_hmac_init(struct ahash_request *req)
+{
+	int err;
+
+	err = atmel_sha_init(req);
+	if (err)
+		return err;
+
+	return atmel_sha_enqueue(req, SHA_OP_INIT);
+}
+
+static int atmel_sha_hmac_init_done(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	size_t bs = ctx->block_size;
+	size_t hs = ctx->hash_size;
+
+	ctx->bufcnt = 0;
+	ctx->digcnt[0] = bs;
+	ctx->digcnt[1] = 0;
+	ctx->flags |= SHA_FLAGS_RESTORE;
+	memcpy(ctx->digest, hmac->ipad, hs);
+	return atmel_sha_complete(dd, 0);
+}
+
+static int atmel_sha_hmac_final(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	u32 *digest = (u32 *)ctx->digest;
+	size_t ds = crypto_ahash_digestsize(tfm);
+	size_t bs = ctx->block_size;
+	size_t hs = ctx->hash_size;
+	size_t i, num_words;
+	u32 mr;
+
+	/* Save d = SHA((K' + ipad) | msg). */
+	num_words = ds / sizeof(u32);
+	for (i = 0; i < num_words; ++i)
+		digest[i] = atmel_sha_read(dd, SHA_REG_DIGEST(i));
+
+	/* Restore context to finish computing SHA((K' + opad) | d). */
+	atmel_sha_write(dd, SHA_CR, SHA_CR_WUIHV);
+	num_words = hs / sizeof(u32);
+	for (i = 0; i < num_words; ++i)
+		atmel_sha_write(dd, SHA_REG_DIN(i), hmac->opad[i]);
+
+	mr = SHA_MR_MODE_AUTO | SHA_MR_UIHV;
+	mr |= (ctx->flags & SHA_FLAGS_ALGO_MASK);
+	atmel_sha_write(dd, SHA_MR, mr);
+	atmel_sha_write(dd, SHA_MSR, bs + ds);
+	atmel_sha_write(dd, SHA_BCR, ds);
+	atmel_sha_write(dd, SHA_CR, SHA_CR_FIRST);
+
+	sg_init_one(&dd->tmp, digest, ds);
+	return atmel_sha_cpu_start(dd, &dd->tmp, ds, false, true,
+				   atmel_sha_hmac_final_done);
+}
+
+static int atmel_sha_hmac_final_done(struct atmel_sha_dev *dd)
+{
+	/*
+	 * req->result might not be sizeof(u32) aligned, so copy the
+	 * digest into ctx->digest[] before memcpy() the data into
+	 * req->result.
+	 */
+	atmel_sha_copy_hash(dd->req);
+	atmel_sha_copy_ready_hash(dd->req);
+	return atmel_sha_complete(dd, 0);
+}
+
+static int atmel_sha_hmac_digest(struct ahash_request *req)
+{
+	int err;
+
+	err = atmel_sha_init(req);
+	if (err)
+		return err;
+
+	return atmel_sha_enqueue(req, SHA_OP_DIGEST);
+}
+
+static int atmel_sha_hmac_digest2(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	size_t hs = ctx->hash_size;
+	size_t i, num_words = hs / sizeof(u32);
+	bool use_dma = false;
+	u32 mr;
+
+	/* Special case for empty message. */
+	if (!req->nbytes)
+		return atmel_sha_complete(dd, -EINVAL); // TODO:
+
+	/* Check DMA threshold and alignment. */
+	if (req->nbytes > ATMEL_SHA_DMA_THRESHOLD &&
+	    atmel_sha_dma_check_aligned(dd, req->src, req->nbytes))
+		use_dma = true;
+
+	/* Write both initial hash values to compute a HMAC. */
+	atmel_sha_write(dd, SHA_CR, SHA_CR_WUIHV);
+	for (i = 0; i < num_words; ++i)
+		atmel_sha_write(dd, SHA_REG_DIN(i), hmac->ipad[i]);
+
+	atmel_sha_write(dd, SHA_CR, SHA_CR_WUIEHV);
+	for (i = 0; i < num_words; ++i)
+		atmel_sha_write(dd, SHA_REG_DIN(i), hmac->opad[i]);
+
+	/* Write the Mode, Message Size, Bytes Count then Control Registers. */
+	mr = (SHA_MR_HMAC | SHA_MR_DUALBUFF);
+	mr |= ctx->flags & SHA_FLAGS_ALGO_MASK;
+	if (use_dma)
+		mr |= SHA_MR_MODE_IDATAR0;
+	else
+		mr |= SHA_MR_MODE_AUTO;
+	atmel_sha_write(dd, SHA_MR, mr);
+
+	atmel_sha_write(dd, SHA_MSR, req->nbytes);
+	atmel_sha_write(dd, SHA_BCR, req->nbytes);
+
+	atmel_sha_write(dd, SHA_CR, SHA_CR_FIRST);
+
+	/* Process data. */
+	if (use_dma)
+		return atmel_sha_dma_start(dd, req->src, req->nbytes,
+					   atmel_sha_hmac_final_done);
+
+	return atmel_sha_cpu_start(dd, req->src, req->nbytes, false, true,
+				   atmel_sha_hmac_final_done);
+}
+
+static int atmel_sha_hmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct atmel_sha_hmac_ctx *hmac = crypto_tfm_ctx(tfm);
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct atmel_sha_reqctx));
+	hmac->base.start = atmel_sha_hmac_start;
+	atmel_sha_hmac_key_init(&hmac->hkey);
+
+	return 0;
+}
+
+static void atmel_sha_hmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct atmel_sha_hmac_ctx *hmac = crypto_tfm_ctx(tfm);
+
+	atmel_sha_hmac_key_release(&hmac->hkey);
+}
+
+static struct ahash_alg sha_hmac_algs[] = {
+{
+	.init		= atmel_sha_hmac_init,
+	.update		= atmel_sha_update,
+	.final		= atmel_sha_final,
+	.digest		= atmel_sha_hmac_digest,
+	.setkey		= atmel_sha_hmac_setkey,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
+	.halg = {
+		.digestsize	= SHA1_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_reqctx),
+		.base	= {
+			.cra_name		= "hmac(sha1)",
+			.cra_driver_name	= "atmel-hmac-sha1",
+			.cra_priority		= 100,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA1_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct atmel_sha_hmac_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= atmel_sha_hmac_cra_init,
+			.cra_exit		= atmel_sha_hmac_cra_exit,
+		}
+	}
+},
+{
+	.init		= atmel_sha_hmac_init,
+	.update		= atmel_sha_update,
+	.final		= atmel_sha_final,
+	.digest		= atmel_sha_hmac_digest,
+	.setkey		= atmel_sha_hmac_setkey,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
+	.halg = {
+		.digestsize	= SHA224_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_reqctx),
+		.base	= {
+			.cra_name		= "hmac(sha224)",
+			.cra_driver_name	= "atmel-hmac-sha224",
+			.cra_priority		= 100,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA224_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct atmel_sha_hmac_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= atmel_sha_hmac_cra_init,
+			.cra_exit		= atmel_sha_hmac_cra_exit,
+		}
+	}
+},
+{
+	.init		= atmel_sha_hmac_init,
+	.update		= atmel_sha_update,
+	.final		= atmel_sha_final,
+	.digest		= atmel_sha_hmac_digest,
+	.setkey		= atmel_sha_hmac_setkey,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
+	.halg = {
+		.digestsize	= SHA256_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_reqctx),
+		.base	= {
+			.cra_name		= "hmac(sha256)",
+			.cra_driver_name	= "atmel-hmac-sha256",
+			.cra_priority		= 100,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA256_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct atmel_sha_hmac_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= atmel_sha_hmac_cra_init,
+			.cra_exit		= atmel_sha_hmac_cra_exit,
+		}
+	}
+},
+{
+	.init		= atmel_sha_hmac_init,
+	.update		= atmel_sha_update,
+	.final		= atmel_sha_final,
+	.digest		= atmel_sha_hmac_digest,
+	.setkey		= atmel_sha_hmac_setkey,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
+	.halg = {
+		.digestsize	= SHA384_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_reqctx),
+		.base	= {
+			.cra_name		= "hmac(sha384)",
+			.cra_driver_name	= "atmel-hmac-sha384",
+			.cra_priority		= 100,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA384_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct atmel_sha_hmac_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= atmel_sha_hmac_cra_init,
+			.cra_exit		= atmel_sha_hmac_cra_exit,
+		}
+	}
+},
+{
+	.init		= atmel_sha_hmac_init,
+	.update		= atmel_sha_update,
+	.final		= atmel_sha_final,
+	.digest		= atmel_sha_hmac_digest,
+	.setkey		= atmel_sha_hmac_setkey,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
+	.halg = {
+		.digestsize	= SHA512_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_reqctx),
+		.base	= {
+			.cra_name		= "hmac(sha512)",
+			.cra_driver_name	= "atmel-hmac-sha512",
+			.cra_priority		= 100,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA512_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct atmel_sha_hmac_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= atmel_sha_hmac_cra_init,
+			.cra_exit		= atmel_sha_hmac_cra_exit,
+		}
+	}
+},
+};
 
 static void atmel_sha_unregister_algs(struct atmel_sha_dev *dd)
 {
 	int i;
 
+	if (dd->caps.has_hmac)
+		for (i = 0; i < ARRAY_SIZE(sha_hmac_algs); i++)
+			crypto_unregister_ahash(&sha_hmac_algs[i]);
+
 	for (i = 0; i < ARRAY_SIZE(sha_1_256_algs); i++)
 		crypto_unregister_ahash(&sha_1_256_algs[i]);
 
@@ -1563,8 +2144,21 @@ static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 		}
 	}
 
+	if (dd->caps.has_hmac) {
+		for (i = 0; i < ARRAY_SIZE(sha_hmac_algs); i++) {
+			err = crypto_register_ahash(&sha_hmac_algs[i]);
+			if (err)
+				goto err_sha_hmac_algs;
+		}
+	}
+
 	return 0;
 
+	/*i = ARRAY_SIZE(sha_hmac_algs);*/
+err_sha_hmac_algs:
+	for (j = 0; j < i; j++)
+		crypto_unregister_ahash(&sha_hmac_algs[j]);
+	i = ARRAY_SIZE(sha_384_512_algs);
 err_sha_384_512_algs:
 	for (j = 0; j < i; j++)
 		crypto_unregister_ahash(&sha_384_512_algs[j]);
@@ -1634,6 +2228,7 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 	dd->caps.has_sha224 = 0;
 	dd->caps.has_sha_384_512 = 0;
 	dd->caps.has_uihv = 0;
+	dd->caps.has_hmac = 0;
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
@@ -1643,6 +2238,7 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 		dd->caps.has_sha224 = 1;
 		dd->caps.has_sha_384_512 = 1;
 		dd->caps.has_uihv = 1;
+		dd->caps.has_hmac = 1;
 		break;
 	case 0x420:
 		dd->caps.has_dma = 1;
-- 
2.7.4
