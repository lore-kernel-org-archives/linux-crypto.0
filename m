From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH 1/2] crypto: stm32/cryp - add aes gcm / ccm support
Date: Wed, 7 Feb 2018 14:08:54 +0100
Message-ID: <1518008935-30428-2-git-send-email-fabien.dessenne@st.com>
References: <1518008935-30428-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518008935-30428-1-git-send-email-fabien.dessenne@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add AEAD cipher algorithms for aes gcm and ccm.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 931 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 902 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 0f0e2ba..6a1fe98 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -17,6 +17,7 @@
 #include <crypto/des.h>
 #include <crypto/engine.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/aead.h>
 
 #define DRIVER_NAME             "stm32-cryp"
 
@@ -29,8 +30,12 @@
 #define FLG_ECB                 BIT(4)
 #define FLG_CBC                 BIT(5)
 #define FLG_CTR                 BIT(6)
+#define FLG_GCM                 BIT(7)
+#define FLG_CCM                 BIT(8)
 /* Mode mask = bits [15..0] */
 #define FLG_MODE_MASK           GENMASK(15, 0)
+/* Bit [31..16] status  */
+#define FLG_CCM_PADDED_WA       BIT(16)
 
 /* Registers */
 #define CRYP_CR                 0x00000000
@@ -53,6 +58,8 @@
 #define CRYP_IV0RR              0x00000044
 #define CRYP_IV1LR              0x00000048
 #define CRYP_IV1RR              0x0000004C
+#define CRYP_CSGCMCCM0R         0x00000050
+#define CRYP_CSGCM0R            0x00000070
 
 /* Registers values */
 #define CR_DEC_NOT_ENC          0x00000004
@@ -64,6 +71,8 @@
 #define CR_AES_CBC              0x00000028
 #define CR_AES_CTR              0x00000030
 #define CR_AES_KP               0x00000038
+#define CR_AES_GCM              0x00080000
+#define CR_AES_CCM              0x00080008
 #define CR_AES_UNKNOWN          0xFFFFFFFF
 #define CR_ALGO_MASK            0x00080038
 #define CR_DATA32               0x00000000
@@ -75,6 +84,12 @@
 #define CR_KEY256               0x00000200
 #define CR_FFLUSH               0x00004000
 #define CR_CRYPEN               0x00008000
+#define CR_PH_INIT              0x00000000
+#define CR_PH_HEADER            0x00010000
+#define CR_PH_PAYLOAD           0x00020000
+#define CR_PH_FINAL             0x00030000
+#define CR_PH_MASK              0x00030000
+#define CR_NBPBL_SHIFT          20
 
 #define SR_BUSY                 0x00000010
 #define SR_OFNE                 0x00000004
@@ -87,9 +102,15 @@
 
 /* Misc */
 #define AES_BLOCK_32            (AES_BLOCK_SIZE / sizeof(u32))
+#define GCM_CTR_INIT            2
 #define _walked_in              (cryp->in_walk.offset - cryp->in_sg->offset)
 #define _walked_out             (cryp->out_walk.offset - cryp->out_sg->offset)
 
+struct stm32_cryp_caps {
+	bool                    swap_final;
+	bool                    padding_wa;
+};
+
 struct stm32_cryp_ctx {
 	struct crypto_engine_ctx enginectx;
 	struct stm32_cryp       *cryp;
@@ -109,13 +130,16 @@ struct stm32_cryp {
 	struct clk              *clk;
 	unsigned long           flags;
 	u32                     irq_status;
+	const struct stm32_cryp_caps *caps;
 	struct stm32_cryp_ctx   *ctx;
 
 	struct crypto_engine    *engine;
 
-	struct mutex            lock; /* protects req */
+	struct mutex            lock; /* protects req / areq */
 	struct ablkcipher_request *req;
+	struct aead_request     *areq;
 
+	size_t                  authsize;
 	size_t                  hw_blocksize;
 
 	size_t                  total_in;
@@ -138,6 +162,7 @@ struct stm32_cryp {
 	struct scatter_walk     out_walk;
 
 	u32                     last_ctr[4];
+	u32                     gcm_ctr;
 };
 
 struct stm32_cryp_list {
@@ -180,6 +205,16 @@ static inline bool is_ctr(struct stm32_cryp *cryp)
 	return cryp->flags & FLG_CTR;
 }
 
+static inline bool is_gcm(struct stm32_cryp *cryp)
+{
+	return cryp->flags & FLG_GCM;
+}
+
+static inline bool is_ccm(struct stm32_cryp *cryp)
+{
+	return cryp->flags & FLG_CCM;
+}
+
 static inline bool is_encrypt(struct stm32_cryp *cryp)
 {
 	return cryp->flags & FLG_ENCRYPT;
@@ -208,6 +243,24 @@ static inline int stm32_cryp_wait_busy(struct stm32_cryp *cryp)
 			!(status & SR_BUSY), 10, 100000);
 }
 
+static inline int stm32_cryp_wait_enable(struct stm32_cryp *cryp)
+{
+	u32 status;
+
+	return readl_relaxed_poll_timeout(cryp->regs + CRYP_CR, status,
+			!(status & CR_CRYPEN), 10, 100000);
+}
+
+static inline int stm32_cryp_wait_output(struct stm32_cryp *cryp)
+{
+	u32 status;
+
+	return readl_relaxed_poll_timeout(cryp->regs + CRYP_SR, status,
+			status & SR_OFNE, 10, 100000);
+}
+
+static int stm32_cryp_read_auth_tag(struct stm32_cryp *cryp);
+
 static struct stm32_cryp *stm32_cryp_find_dev(struct stm32_cryp_ctx *ctx)
 {
 	struct stm32_cryp *tmp, *cryp = NULL;
@@ -366,6 +419,12 @@ static u32 stm32_cryp_get_hw_mode(struct stm32_cryp *cryp)
 	if (is_aes(cryp) && is_ctr(cryp))
 		return CR_AES_CTR;
 
+	if (is_aes(cryp) && is_gcm(cryp))
+		return CR_AES_GCM;
+
+	if (is_aes(cryp) && is_ccm(cryp))
+		return CR_AES_CCM;
+
 	if (is_des(cryp) && is_ecb(cryp))
 		return CR_DES_ECB;
 
@@ -382,6 +441,79 @@ static u32 stm32_cryp_get_hw_mode(struct stm32_cryp *cryp)
 	return CR_AES_UNKNOWN;
 }
 
+static unsigned int stm32_cryp_get_input_text_len(struct stm32_cryp *cryp)
+{
+	return is_encrypt(cryp) ? cryp->areq->cryptlen :
+				  cryp->areq->cryptlen - cryp->authsize;
+}
+
+static int stm32_cryp_gcm_init(struct stm32_cryp *cryp, u32 cfg)
+{
+	int ret;
+	u32 iv[4];
+
+	/* Phase 1 : init */
+	memcpy(iv, cryp->areq->iv, 12);
+	iv[3] = cpu_to_be32(GCM_CTR_INIT);
+	cryp->gcm_ctr = GCM_CTR_INIT;
+	stm32_cryp_hw_write_iv(cryp, iv);
+
+	stm32_cryp_write(cryp, CRYP_CR, cfg | CR_PH_INIT | CR_CRYPEN);
+
+	/* Wait for end of processing */
+	ret = stm32_cryp_wait_enable(cryp);
+	if (ret)
+		dev_err(cryp->dev, "Timeout (gcm init)\n");
+
+	return ret;
+}
+
+static int stm32_cryp_ccm_init(struct stm32_cryp *cryp, u32 cfg)
+{
+	int ret;
+	u8 iv[AES_BLOCK_SIZE], b0[AES_BLOCK_SIZE];
+	u32 *d;
+	unsigned int i, textlen;
+
+	/* Phase 1 : init. Firstly set the CTR value to 1 (not 0) */
+	memcpy(iv, cryp->areq->iv, AES_BLOCK_SIZE);
+	memset(iv + AES_BLOCK_SIZE - 1 - iv[0], 0, iv[0] + 1);
+	iv[AES_BLOCK_SIZE - 1] = 1;
+	stm32_cryp_hw_write_iv(cryp, (u32 *)iv);
+
+	/* Build B0 */
+	memcpy(b0, iv, AES_BLOCK_SIZE);
+
+	b0[0] |= (8 * ((cryp->authsize - 2) / 2));
+
+	if (cryp->areq->assoclen)
+		b0[0] |= 0x40;
+
+	textlen = stm32_cryp_get_input_text_len(cryp);
+
+	b0[AES_BLOCK_SIZE - 2] = textlen >> 8;
+	b0[AES_BLOCK_SIZE - 1] = textlen & 0xFF;
+
+	/* Enable HW */
+	stm32_cryp_write(cryp, CRYP_CR, cfg | CR_PH_INIT | CR_CRYPEN);
+
+	/* Write B0 */
+	d = (u32 *)b0;
+
+	for (i = 0; i < AES_BLOCK_32; i++) {
+		if (!cryp->caps->padding_wa)
+			*d = cpu_to_be32(*d);
+		stm32_cryp_write(cryp, CRYP_DIN, *d++);
+	}
+
+	/* Wait for end of processing */
+	ret = stm32_cryp_wait_enable(cryp);
+	if (ret)
+		dev_err(cryp->dev, "Timeout (ccm init)\n");
+
+	return ret;
+}
+
 static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 {
 	int ret;
@@ -437,6 +569,29 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	stm32_cryp_write(cryp, CRYP_CR, cfg);
 
 	switch (hw_mode) {
+	case CR_AES_GCM:
+	case CR_AES_CCM:
+		/* Phase 1 : init */
+		if (hw_mode == CR_AES_CCM)
+			ret = stm32_cryp_ccm_init(cryp, cfg);
+		else
+			ret = stm32_cryp_gcm_init(cryp, cfg);
+
+		if (ret)
+			return ret;
+
+		/* Phase 2 : header (authenticated data) */
+		if (cryp->areq->assoclen) {
+			cfg |= CR_PH_HEADER;
+		} else if (stm32_cryp_get_input_text_len(cryp)) {
+			cfg |= CR_PH_PAYLOAD;
+			stm32_cryp_write(cryp, CRYP_CR, cfg);
+		} else {
+			cfg |= CR_PH_INIT;
+		}
+
+		break;
+
 	case CR_DES_CBC:
 	case CR_TDES_CBC:
 	case CR_AES_CBC:
@@ -453,12 +608,16 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 
 	stm32_cryp_write(cryp, CRYP_CR, cfg);
 
+	cryp->flags &= ~FLG_CCM_PADDED_WA;
+
 	return 0;
 }
 
-static void stm32_cryp_finish_req(struct stm32_cryp *cryp)
+static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 {
-	int err = 0;
+	if (!err && (is_gcm(cryp) || is_ccm(cryp)))
+		/* Phase 4 : output tag */
+		err = stm32_cryp_read_auth_tag(cryp);
 
 	if (cryp->sgs_copied) {
 		void *buf_in, *buf_out;
@@ -479,8 +638,14 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp)
 		free_pages((unsigned long)buf_out, pages);
 	}
 
-	crypto_finalize_ablkcipher_request(cryp->engine, cryp->req, err);
-	cryp->req = NULL;
+	if (is_gcm(cryp) || is_ccm(cryp)) {
+		crypto_finalize_aead_request(cryp->engine, cryp->areq, err);
+		cryp->areq = NULL;
+	} else {
+		crypto_finalize_ablkcipher_request(cryp->engine, cryp->req,
+						   err);
+		cryp->req = NULL;
+	}
 
 	memset(cryp->ctx->key, 0, cryp->ctx->keylen);
 
@@ -511,6 +676,23 @@ static int stm32_cryp_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int stm32_cryp_aead_one_req(struct crypto_engine *engine, void *areq);
+static int stm32_cryp_prepare_aead_req(struct crypto_engine *engine,
+				       void *areq);
+
+static int stm32_cryp_aes_aead_init(struct crypto_aead *tfm)
+{
+	struct stm32_cryp_ctx *ctx = crypto_aead_ctx(tfm);
+
+	tfm->reqsize = sizeof(struct stm32_cryp_reqctx);
+
+	ctx->enginectx.op.do_one_request = stm32_cryp_aead_one_req;
+	ctx->enginectx.op.prepare_request = stm32_cryp_prepare_aead_req;
+	ctx->enginectx.op.unprepare_request = NULL;
+
+	return 0;
+}
+
 static int stm32_cryp_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
 	struct stm32_cryp_ctx *ctx = crypto_ablkcipher_ctx(
@@ -526,6 +708,20 @@ static int stm32_cryp_crypt(struct ablkcipher_request *req, unsigned long mode)
 	return crypto_transfer_ablkcipher_request_to_engine(cryp->engine, req);
 }
 
+static int stm32_cryp_aead_crypt(struct aead_request *req, unsigned long mode)
+{
+	struct stm32_cryp_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct stm32_cryp_reqctx *rctx = aead_request_ctx(req);
+	struct stm32_cryp *cryp = stm32_cryp_find_dev(ctx);
+
+	if (!cryp)
+		return -ENODEV;
+
+	rctx->mode = mode;
+
+	return crypto_transfer_aead_request_to_engine(cryp->engine, req);
+}
+
 static int stm32_cryp_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			     unsigned int keylen)
 {
@@ -565,6 +761,46 @@ static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		return stm32_cryp_setkey(tfm, key, keylen);
 }
 
+static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8 *key,
+				      unsigned int keylen)
+{
+	struct stm32_cryp_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
+	    keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	return 0;
+}
+
+static int stm32_cryp_aes_gcm_setauthsize(struct crypto_aead *tfm,
+					  unsigned int authsize)
+{
+	return authsize == AES_BLOCK_SIZE ? 0 : -EINVAL;
+}
+
+static int stm32_cryp_aes_ccm_setauthsize(struct crypto_aead *tfm,
+					  unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 6:
+	case 8:
+	case 10:
+	case 12:
+	case 14:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int stm32_cryp_aes_ecb_encrypt(struct ablkcipher_request *req)
 {
 	return stm32_cryp_crypt(req, FLG_AES | FLG_ECB | FLG_ENCRYPT);
@@ -595,6 +831,26 @@ static int stm32_cryp_aes_ctr_decrypt(struct ablkcipher_request *req)
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CTR);
 }
 
+static int stm32_cryp_aes_gcm_encrypt(struct aead_request *req)
+{
+	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_GCM | FLG_ENCRYPT);
+}
+
+static int stm32_cryp_aes_gcm_decrypt(struct aead_request *req)
+{
+	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_GCM);
+}
+
+static int stm32_cryp_aes_ccm_encrypt(struct aead_request *req)
+{
+	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_CCM | FLG_ENCRYPT);
+}
+
+static int stm32_cryp_aes_ccm_decrypt(struct aead_request *req)
+{
+	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_CCM);
+}
+
 static int stm32_cryp_des_ecb_encrypt(struct ablkcipher_request *req)
 {
 	return stm32_cryp_crypt(req, FLG_DES | FLG_ECB | FLG_ENCRYPT);
@@ -635,18 +891,19 @@ static int stm32_cryp_tdes_cbc_decrypt(struct ablkcipher_request *req)
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_CBC);
 }
 
-static int stm32_cryp_prepare_req(struct crypto_engine *engine,
-				  struct ablkcipher_request *req)
+static int stm32_cryp_prepare_req(struct ablkcipher_request *req,
+				  struct aead_request *areq)
 {
 	struct stm32_cryp_ctx *ctx;
 	struct stm32_cryp *cryp;
 	struct stm32_cryp_reqctx *rctx;
 	int ret;
 
-	if (!req)
+	if (!req && !areq)
 		return -EINVAL;
 
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	ctx = req ? crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req)) :
+		    crypto_aead_ctx(crypto_aead_reqtfm(areq));
 
 	cryp = ctx->cryp;
 
@@ -655,7 +912,7 @@ static int stm32_cryp_prepare_req(struct crypto_engine *engine,
 
 	mutex_lock(&cryp->lock);
 
-	rctx = ablkcipher_request_ctx(req);
+	rctx = req ? ablkcipher_request_ctx(req) : aead_request_ctx(areq);
 	rctx->mode &= FLG_MODE_MASK;
 
 	ctx->cryp = cryp;
@@ -664,15 +921,48 @@ static int stm32_cryp_prepare_req(struct crypto_engine *engine,
 	cryp->hw_blocksize = is_aes(cryp) ? AES_BLOCK_SIZE : DES_BLOCK_SIZE;
 	cryp->ctx = ctx;
 
-	cryp->req = req;
-	cryp->total_in = req->nbytes;
-	cryp->total_out = cryp->total_in;
+	if (req) {
+		cryp->req = req;
+		cryp->total_in = req->nbytes;
+		cryp->total_out = cryp->total_in;
+	} else {
+		/*
+		 * Length of input and output data:
+		 * Encryption case:
+		 *  INPUT  =   AssocData  ||   PlainText
+		 *          <- assoclen ->  <- cryptlen ->
+		 *          <------- total_in ----------->
+		 *
+		 *  OUTPUT =   AssocData  ||  CipherText  ||   AuthTag
+		 *          <- assoclen ->  <- cryptlen ->  <- authsize ->
+		 *          <---------------- total_out ----------------->
+		 *
+		 * Decryption case:
+		 *  INPUT  =   AssocData  ||  CipherText  ||  AuthTag
+		 *          <- assoclen ->  <--------- cryptlen --------->
+		 *                                          <- authsize ->
+		 *          <---------------- total_in ------------------>
+		 *
+		 *  OUTPUT =   AssocData  ||   PlainText
+		 *          <- assoclen ->  <- crypten - authsize ->
+		 *          <---------- total_out ----------------->
+		 */
+		cryp->areq = areq;
+		cryp->authsize = crypto_aead_authsize(crypto_aead_reqtfm(areq));
+		cryp->total_in = areq->assoclen + areq->cryptlen;
+		if (is_encrypt(cryp))
+			/* Append auth tag to output */
+			cryp->total_out = cryp->total_in + cryp->authsize;
+		else
+			/* No auth tag in output */
+			cryp->total_out = cryp->total_in - cryp->authsize;
+	}
 
 	cryp->total_in_save = cryp->total_in;
 	cryp->total_out_save = cryp->total_out;
 
-	cryp->in_sg = req->src;
-	cryp->out_sg = req->dst;
+	cryp->in_sg = req ? req->src : areq->src;
+	cryp->out_sg = req ? req->dst : areq->dst;
 	cryp->out_sg_save = cryp->out_sg;
 
 	cryp->in_sg_len = sg_nents_for_len(cryp->in_sg, cryp->total_in);
@@ -696,6 +986,12 @@ static int stm32_cryp_prepare_req(struct crypto_engine *engine,
 	scatterwalk_start(&cryp->in_walk, cryp->in_sg);
 	scatterwalk_start(&cryp->out_walk, cryp->out_sg);
 
+	if (is_gcm(cryp) || is_ccm(cryp)) {
+		/* In output, jump after assoc data */
+		scatterwalk_advance(&cryp->out_walk, cryp->areq->assoclen);
+		cryp->total_out -= cryp->areq->assoclen;
+	}
+
 	ret = stm32_cryp_hw_init(cryp);
 out:
 	if (ret)
@@ -711,7 +1007,7 @@ static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
 						      struct ablkcipher_request,
 						      base);
 
-	return stm32_cryp_prepare_req(engine, req);
+	return stm32_cryp_prepare_req(req, NULL);
 }
 
 static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq)
@@ -729,6 +1025,34 @@ static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq)
 	return stm32_cryp_cpu_start(cryp);
 }
 
+static int stm32_cryp_prepare_aead_req(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = container_of(areq, struct aead_request,
+						base);
+
+	return stm32_cryp_prepare_req(NULL, req);
+}
+
+static int stm32_cryp_aead_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = container_of(areq, struct aead_request,
+						base);
+	struct stm32_cryp_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct stm32_cryp *cryp = ctx->cryp;
+
+	if (!cryp)
+		return -ENODEV;
+
+	if (unlikely(!cryp->areq->assoclen &&
+		     !stm32_cryp_get_input_text_len(cryp))) {
+		/* No input data to process: get tag and finish */
+		stm32_cryp_finish_req(cryp, 0);
+		return 0;
+	}
+
+	return stm32_cryp_cpu_start(cryp);
+}
+
 static u32 *stm32_cryp_next_out(struct stm32_cryp *cryp, u32 *dst,
 				unsigned int n)
 {
@@ -761,6 +1085,111 @@ static u32 *stm32_cryp_next_in(struct stm32_cryp *cryp, u32 *src,
 	return (u32 *)((u8 *)src + n);
 }
 
+static int stm32_cryp_read_auth_tag(struct stm32_cryp *cryp)
+{
+	u32 cfg, size_bit, *dst, d32;
+	u8 *d8;
+	unsigned int i, j;
+	int ret = 0;
+
+	/* Update Config */
+	cfg = stm32_cryp_read(cryp, CRYP_CR);
+
+	cfg &= ~CR_PH_MASK;
+	cfg |= CR_PH_FINAL;
+	cfg &= ~CR_DEC_NOT_ENC;
+	cfg |= CR_CRYPEN;
+
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	if (is_gcm(cryp)) {
+		/* GCM: write aad and payload size (in bits) */
+		size_bit = cryp->areq->assoclen * 8;
+		if (cryp->caps->swap_final)
+			size_bit = cpu_to_be32(size_bit);
+
+		stm32_cryp_write(cryp, CRYP_DIN, 0);
+		stm32_cryp_write(cryp, CRYP_DIN, size_bit);
+
+		size_bit = is_encrypt(cryp) ? cryp->areq->cryptlen :
+				cryp->areq->cryptlen - AES_BLOCK_SIZE;
+		size_bit *= 8;
+		if (cryp->caps->swap_final)
+			size_bit = cpu_to_be32(size_bit);
+
+		stm32_cryp_write(cryp, CRYP_DIN, 0);
+		stm32_cryp_write(cryp, CRYP_DIN, size_bit);
+	} else {
+		/* CCM: write CTR0 */
+		u8 iv[AES_BLOCK_SIZE];
+		u32 *iv32 = (u32 *)iv;
+
+		memcpy(iv, cryp->areq->iv, AES_BLOCK_SIZE);
+		memset(iv + AES_BLOCK_SIZE - 1 - iv[0], 0, iv[0] + 1);
+
+		for (i = 0; i < AES_BLOCK_32; i++) {
+			if (!cryp->caps->padding_wa)
+				*iv32 = cpu_to_be32(*iv32);
+			stm32_cryp_write(cryp, CRYP_DIN, *iv32++);
+		}
+	}
+
+	/* Wait for output data */
+	ret = stm32_cryp_wait_output(cryp);
+	if (ret) {
+		dev_err(cryp->dev, "Timeout (read tag)\n");
+		return ret;
+	}
+
+	if (is_encrypt(cryp)) {
+		/* Get and write tag */
+		dst = sg_virt(cryp->out_sg) + _walked_out;
+
+		for (i = 0; i < AES_BLOCK_32; i++) {
+			if (cryp->total_out >= sizeof(u32)) {
+				/* Read a full u32 */
+				*dst = stm32_cryp_read(cryp, CRYP_DOUT);
+
+				dst = stm32_cryp_next_out(cryp, dst,
+							  sizeof(u32));
+				cryp->total_out -= sizeof(u32);
+			} else if (!cryp->total_out) {
+				/* Empty fifo out (data from input padding) */
+				stm32_cryp_read(cryp, CRYP_DOUT);
+			} else {
+				/* Read less than an u32 */
+				d32 = stm32_cryp_read(cryp, CRYP_DOUT);
+				d8 = (u8 *)&d32;
+
+				for (j = 0; j < cryp->total_out; j++) {
+					*((u8 *)dst) = *(d8++);
+					dst = stm32_cryp_next_out(cryp, dst, 1);
+				}
+				cryp->total_out = 0;
+			}
+		}
+	} else {
+		/* Get and check tag */
+		u32 in_tag[AES_BLOCK_32], out_tag[AES_BLOCK_32];
+
+		scatterwalk_map_and_copy(in_tag, cryp->in_sg,
+					 cryp->total_in_save - cryp->authsize,
+					 cryp->authsize, 0);
+
+		for (i = 0; i < AES_BLOCK_32; i++)
+			out_tag[i] = stm32_cryp_read(cryp, CRYP_DOUT);
+
+		if (crypto_memneq(in_tag, out_tag, cryp->authsize))
+			ret = -EBADMSG;
+	}
+
+	/* Disable cryp */
+	cfg &= ~CR_CRYPEN;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	return ret;
+}
+
 static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
 {
 	u32 cr;
@@ -793,17 +1222,24 @@ static bool stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
 	unsigned int i, j;
 	u32 d32, *dst;
 	u8 *d8;
+	size_t tag_size;
+
+	/* Do no read tag now (if any) */
+	if (is_encrypt(cryp) && (is_gcm(cryp) || is_ccm(cryp)))
+		tag_size = cryp->authsize;
+	else
+		tag_size = 0;
 
 	dst = sg_virt(cryp->out_sg) + _walked_out;
 
 	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++) {
-		if (likely(cryp->total_out >= sizeof(u32))) {
+		if (likely(cryp->total_out - tag_size >= sizeof(u32))) {
 			/* Read a full u32 */
 			*dst = stm32_cryp_read(cryp, CRYP_DOUT);
 
 			dst = stm32_cryp_next_out(cryp, dst, sizeof(u32));
 			cryp->total_out -= sizeof(u32);
-		} else if (!cryp->total_out) {
+		} else if (cryp->total_out == tag_size) {
 			/* Empty fifo out (data from input padding) */
 			d32 = stm32_cryp_read(cryp, CRYP_DOUT);
 		} else {
@@ -811,15 +1247,15 @@ static bool stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
 			d32 = stm32_cryp_read(cryp, CRYP_DOUT);
 			d8 = (u8 *)&d32;
 
-			for (j = 0; j < cryp->total_out; j++) {
+			for (j = 0; j < cryp->total_out - tag_size; j++) {
 				*((u8 *)dst) = *(d8++);
 				dst = stm32_cryp_next_out(cryp, dst, 1);
 			}
-			cryp->total_out = 0;
+			cryp->total_out = tag_size;
 		}
 	}
 
-	return !cryp->total_out || !cryp->total_in;
+	return !(cryp->total_out - tag_size) || !cryp->total_in;
 }
 
 static void stm32_cryp_irq_write_block(struct stm32_cryp *cryp)
@@ -827,33 +1263,219 @@ static void stm32_cryp_irq_write_block(struct stm32_cryp *cryp)
 	unsigned int i, j;
 	u32 *src;
 	u8 d8[4];
+	size_t tag_size;
+
+	/* Do no write tag (if any) */
+	if (is_decrypt(cryp) && (is_gcm(cryp) || is_ccm(cryp)))
+		tag_size = cryp->authsize;
+	else
+		tag_size = 0;
 
 	src = sg_virt(cryp->in_sg) + _walked_in;
 
 	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++) {
-		if (likely(cryp->total_in >= sizeof(u32))) {
+		if (likely(cryp->total_in - tag_size >= sizeof(u32))) {
 			/* Write a full u32 */
 			stm32_cryp_write(cryp, CRYP_DIN, *src);
 
 			src = stm32_cryp_next_in(cryp, src, sizeof(u32));
 			cryp->total_in -= sizeof(u32);
-		} else if (!cryp->total_in) {
+		} else if (cryp->total_in == tag_size) {
 			/* Write padding data */
 			stm32_cryp_write(cryp, CRYP_DIN, 0);
 		} else {
 			/* Write less than an u32 */
 			memset(d8, 0, sizeof(u32));
-			for (j = 0; j < cryp->total_in; j++) {
+			for (j = 0; j < cryp->total_in - tag_size; j++) {
 				d8[j] = *((u8 *)src);
 				src = stm32_cryp_next_in(cryp, src, 1);
 			}
 
 			stm32_cryp_write(cryp, CRYP_DIN, *(u32 *)d8);
-			cryp->total_in = 0;
+			cryp->total_in = tag_size;
 		}
 	}
 }
 
+static void stm32_cryp_irq_write_gcm_padded_data(struct stm32_cryp *cryp)
+{
+	int err;
+	u32 cfg, tmp[AES_BLOCK_32];
+	size_t total_in_ori = cryp->total_in;
+	struct scatterlist *out_sg_ori = cryp->out_sg;
+	unsigned int i;
+
+	/* 'Special workaround' procedure described in the datasheet */
+
+	/* a) disable ip */
+	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
+	cfg = stm32_cryp_read(cryp, CRYP_CR);
+	cfg &= ~CR_CRYPEN;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* b) Update IV1R */
+	stm32_cryp_write(cryp, CRYP_IV1RR, cryp->gcm_ctr - 2);
+
+	/* c) change mode to CTR */
+	cfg &= ~CR_ALGO_MASK;
+	cfg |= CR_AES_CTR;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* a) enable IP */
+	cfg |= CR_CRYPEN;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* b) pad and write the last block */
+	stm32_cryp_irq_write_block(cryp);
+	cryp->total_in = total_in_ori;
+	err = stm32_cryp_wait_output(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Timeout (write gcm header)\n");
+		return stm32_cryp_finish_req(cryp, err);
+	}
+
+	/* c) get and store encrypted data */
+	stm32_cryp_irq_read_data(cryp);
+	scatterwalk_map_and_copy(tmp, out_sg_ori,
+				 cryp->total_in_save - total_in_ori,
+				 total_in_ori, 0);
+
+	/* d) change mode back to AES GCM */
+	cfg &= ~CR_ALGO_MASK;
+	cfg |= CR_AES_GCM;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* e) change phase to Final */
+	cfg &= ~CR_PH_MASK;
+	cfg |= CR_PH_FINAL;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* f) write padded data */
+	for (i = 0; i < AES_BLOCK_32; i++) {
+		if (cryp->total_in)
+			stm32_cryp_write(cryp, CRYP_DIN, tmp[i]);
+		else
+			stm32_cryp_write(cryp, CRYP_DIN, 0);
+
+		cryp->total_in -= min_t(size_t, sizeof(u32), cryp->total_in);
+	}
+
+	/* g) Empty fifo out */
+	err = stm32_cryp_wait_output(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Timeout (write gcm header)\n");
+		return stm32_cryp_finish_req(cryp, err);
+	}
+
+	for (i = 0; i < AES_BLOCK_32; i++)
+		stm32_cryp_read(cryp, CRYP_DOUT);
+
+	/* h) run the he normal Final phase */
+	stm32_cryp_finish_req(cryp, 0);
+}
+
+static void stm32_cryp_irq_set_npblb(struct stm32_cryp *cryp)
+{
+	u32 cfg, payload_bytes;
+
+	/* disable ip, set NPBLB and reneable ip */
+	cfg = stm32_cryp_read(cryp, CRYP_CR);
+	cfg &= ~CR_CRYPEN;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	payload_bytes = is_decrypt(cryp) ? cryp->total_in - cryp->authsize :
+					   cryp->total_in;
+	cfg |= (cryp->hw_blocksize - payload_bytes) << CR_NBPBL_SHIFT;
+	cfg |= CR_CRYPEN;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+}
+
+static void stm32_cryp_irq_write_ccm_padded_data(struct stm32_cryp *cryp)
+{
+	int err = 0;
+	u32 cfg, iv1tmp;
+	u32 cstmp1[AES_BLOCK_32], cstmp2[AES_BLOCK_32], tmp[AES_BLOCK_32];
+	size_t last_total_out, total_in_ori = cryp->total_in;
+	struct scatterlist *out_sg_ori = cryp->out_sg;
+	unsigned int i;
+
+	/* 'Special workaround' procedure described in the datasheet */
+	cryp->flags |= FLG_CCM_PADDED_WA;
+
+	/* a) disable ip */
+	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
+
+	cfg = stm32_cryp_read(cryp, CRYP_CR);
+	cfg &= ~CR_CRYPEN;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* b) get IV1 from CRYP_CSGCMCCM7 */
+	iv1tmp = stm32_cryp_read(cryp, CRYP_CSGCMCCM0R + 7 * 4);
+
+	/* c) Load CRYP_CSGCMCCMxR */
+	for (i = 0; i < ARRAY_SIZE(cstmp1); i++)
+		cstmp1[i] = stm32_cryp_read(cryp, CRYP_CSGCMCCM0R + i * 4);
+
+	/* d) Write IV1R */
+	stm32_cryp_write(cryp, CRYP_IV1RR, iv1tmp);
+
+	/* e) change mode to CTR */
+	cfg &= ~CR_ALGO_MASK;
+	cfg |= CR_AES_CTR;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* a) enable IP */
+	cfg |= CR_CRYPEN;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* b) pad and write the last block */
+	stm32_cryp_irq_write_block(cryp);
+	cryp->total_in = total_in_ori;
+	err = stm32_cryp_wait_output(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Timeout (wite ccm padded data)\n");
+		return stm32_cryp_finish_req(cryp, err);
+	}
+
+	/* c) get and store decrypted data */
+	last_total_out = cryp->total_out;
+	stm32_cryp_irq_read_data(cryp);
+
+	memset(tmp, 0, sizeof(tmp));
+	scatterwalk_map_and_copy(tmp, out_sg_ori,
+				 cryp->total_out_save - last_total_out,
+				 last_total_out, 0);
+
+	/* d) Load again CRYP_CSGCMCCMxR */
+	for (i = 0; i < ARRAY_SIZE(cstmp2); i++)
+		cstmp2[i] = stm32_cryp_read(cryp, CRYP_CSGCMCCM0R + i * 4);
+
+	/* e) change mode back to AES CCM */
+	cfg &= ~CR_ALGO_MASK;
+	cfg |= CR_AES_CCM;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* f) change phase to header */
+	cfg &= ~CR_PH_MASK;
+	cfg |= CR_PH_HEADER;
+	stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+	/* g) XOR and write padded data */
+	for (i = 0; i < ARRAY_SIZE(tmp); i++) {
+		tmp[i] ^= cstmp1[i];
+		tmp[i] ^= cstmp2[i];
+		stm32_cryp_write(cryp, CRYP_DIN, tmp[i]);
+	}
+
+	/* h) wait for completion */
+	err = stm32_cryp_wait_busy(cryp);
+	if (err)
+		dev_err(cryp->dev, "Timeout (wite ccm padded data)\n");
+
+	/* i) run the he normal Final phase */
+	stm32_cryp_finish_req(cryp, err);
+}
+
 static void stm32_cryp_irq_write_data(struct stm32_cryp *cryp)
 {
 	if (unlikely(!cryp->total_in)) {
@@ -861,28 +1483,220 @@ static void stm32_cryp_irq_write_data(struct stm32_cryp *cryp)
 		return;
 	}
 
+	if (unlikely(cryp->total_in < AES_BLOCK_SIZE &&
+		     (stm32_cryp_get_hw_mode(cryp) == CR_AES_GCM) &&
+		     is_encrypt(cryp))) {
+		/* Padding for AES GCM encryption */
+		if (cryp->caps->padding_wa)
+			/* Special case 1 */
+			return stm32_cryp_irq_write_gcm_padded_data(cryp);
+
+		/* Setting padding bytes (NBBLB) */
+		stm32_cryp_irq_set_npblb(cryp);
+	}
+
+	if (unlikely((cryp->total_in - cryp->authsize < AES_BLOCK_SIZE) &&
+		     (stm32_cryp_get_hw_mode(cryp) == CR_AES_CCM) &&
+		     is_decrypt(cryp))) {
+		/* Padding for AES CCM decryption */
+		if (cryp->caps->padding_wa)
+			/* Special case 2 */
+			return stm32_cryp_irq_write_ccm_padded_data(cryp);
+
+		/* Setting padding bytes (NBBLB) */
+		stm32_cryp_irq_set_npblb(cryp);
+	}
+
 	if (is_aes(cryp) && is_ctr(cryp))
 		stm32_cryp_check_ctr_counter(cryp);
 
 	stm32_cryp_irq_write_block(cryp);
 }
 
+static void stm32_cryp_irq_write_gcm_header(struct stm32_cryp *cryp)
+{
+	int err;
+	unsigned int i, j;
+	u32 cfg, *src;
+
+	src = sg_virt(cryp->in_sg) + _walked_in;
+
+	for (i = 0; i < AES_BLOCK_32; i++) {
+		stm32_cryp_write(cryp, CRYP_DIN, *src);
+
+		src = stm32_cryp_next_in(cryp, src, sizeof(u32));
+		cryp->total_in -= min_t(size_t, sizeof(u32), cryp->total_in);
+
+		/* Check if whole header written */
+		if ((cryp->total_in_save - cryp->total_in) ==
+				cryp->areq->assoclen) {
+			/* Write padding if needed */
+			for (j = i + 1; j < AES_BLOCK_32; j++)
+				stm32_cryp_write(cryp, CRYP_DIN, 0);
+
+			/* Wait for completion */
+			err = stm32_cryp_wait_busy(cryp);
+			if (err) {
+				dev_err(cryp->dev, "Timeout (gcm header)\n");
+				return stm32_cryp_finish_req(cryp, err);
+			}
+
+			if (stm32_cryp_get_input_text_len(cryp)) {
+				/* Phase 3 : payload */
+				cfg = stm32_cryp_read(cryp, CRYP_CR);
+				cfg &= ~CR_CRYPEN;
+				stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+				cfg &= ~CR_PH_MASK;
+				cfg |= CR_PH_PAYLOAD;
+				cfg |= CR_CRYPEN;
+				stm32_cryp_write(cryp, CRYP_CR, cfg);
+			} else {
+				/* Phase 4 : tag */
+				stm32_cryp_write(cryp, CRYP_IMSCR, 0);
+				stm32_cryp_finish_req(cryp, 0);
+			}
+
+			break;
+		}
+
+		if (!cryp->total_in)
+			break;
+	}
+}
+
+static void stm32_cryp_irq_write_ccm_header(struct stm32_cryp *cryp)
+{
+	int err;
+	unsigned int i = 0, j, k;
+	u32 alen, cfg, *src;
+	u8 d8[4];
+
+	src = sg_virt(cryp->in_sg) + _walked_in;
+	alen = cryp->areq->assoclen;
+
+	if (!_walked_in) {
+		if (cryp->areq->assoclen <= 65280) {
+			/* Write first u32 of B1 */
+			d8[0] = (alen >> 8) & 0xFF;
+			d8[1] = alen & 0xFF;
+			d8[2] = *((u8 *)src);
+			src = stm32_cryp_next_in(cryp, src, 1);
+			d8[3] = *((u8 *)src);
+			src = stm32_cryp_next_in(cryp, src, 1);
+
+			stm32_cryp_write(cryp, CRYP_DIN, *(u32 *)d8);
+			i++;
+
+			cryp->total_in -= min_t(size_t, 2, cryp->total_in);
+		} else {
+			/* Build the two first u32 of B1 */
+			d8[0] = 0xFF;
+			d8[1] = 0xFE;
+			d8[2] = alen & 0xFF000000;
+			d8[3] = alen & 0x00FF0000;
+
+			stm32_cryp_write(cryp, CRYP_DIN, *(u32 *)d8);
+			i++;
+
+			d8[0] = alen & 0x0000FF00;
+			d8[1] = alen & 0x000000FF;
+			d8[2] = *((u8 *)src);
+			src = stm32_cryp_next_in(cryp, src, 1);
+			d8[3] = *((u8 *)src);
+			src = stm32_cryp_next_in(cryp, src, 1);
+
+			stm32_cryp_write(cryp, CRYP_DIN, *(u32 *)d8);
+			i++;
+
+			cryp->total_in -= min_t(size_t, 2, cryp->total_in);
+		}
+	}
+
+	/* Write next u32 */
+	for (; i < AES_BLOCK_32; i++) {
+		/* Build an u32 */
+		memset(d8, 0, sizeof(u32));
+		for (k = 0; k < sizeof(u32); k++) {
+			d8[k] = *((u8 *)src);
+			src = stm32_cryp_next_in(cryp, src, 1);
+
+			cryp->total_in -= min_t(size_t, 1, cryp->total_in);
+			if ((cryp->total_in_save - cryp->total_in) == alen)
+				break;
+		}
+
+		stm32_cryp_write(cryp, CRYP_DIN, *(u32 *)d8);
+
+		if ((cryp->total_in_save - cryp->total_in) == alen) {
+			/* Write padding if needed */
+			for (j = i + 1; j < AES_BLOCK_32; j++)
+				stm32_cryp_write(cryp, CRYP_DIN, 0);
+
+			/* Wait for completion */
+			err = stm32_cryp_wait_busy(cryp);
+			if (err) {
+				dev_err(cryp->dev, "Timeout (ccm header)\n");
+				return stm32_cryp_finish_req(cryp, err);
+			}
+
+			if (stm32_cryp_get_input_text_len(cryp)) {
+				/* Phase 3 : payload */
+				cfg = stm32_cryp_read(cryp, CRYP_CR);
+				cfg &= ~CR_CRYPEN;
+				stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+				cfg &= ~CR_PH_MASK;
+				cfg |= CR_PH_PAYLOAD;
+				cfg |= CR_CRYPEN;
+				stm32_cryp_write(cryp, CRYP_CR, cfg);
+			} else {
+				/* Phase 4 : tag */
+				stm32_cryp_write(cryp, CRYP_IMSCR, 0);
+				stm32_cryp_finish_req(cryp, 0);
+			}
+
+			break;
+		}
+	}
+}
+
 static irqreturn_t stm32_cryp_irq_thread(int irq, void *arg)
 {
 	struct stm32_cryp *cryp = arg;
+	u32 ph;
 
 	if (cryp->irq_status & MISR_OUT)
 		/* Output FIFO IRQ: read data */
 		if (unlikely(stm32_cryp_irq_read_data(cryp))) {
 			/* All bytes processed, finish */
 			stm32_cryp_write(cryp, CRYP_IMSCR, 0);
-			stm32_cryp_finish_req(cryp);
+			stm32_cryp_finish_req(cryp, 0);
 			return IRQ_HANDLED;
 		}
 
 	if (cryp->irq_status & MISR_IN) {
-		/* Input FIFO IRQ: write data */
-		stm32_cryp_irq_write_data(cryp);
+		if (is_gcm(cryp)) {
+			ph = stm32_cryp_read(cryp, CRYP_CR) & CR_PH_MASK;
+			if (unlikely(ph == CR_PH_HEADER))
+				/* Write Header */
+				stm32_cryp_irq_write_gcm_header(cryp);
+			else
+				/* Input FIFO IRQ: write data */
+				stm32_cryp_irq_write_data(cryp);
+			cryp->gcm_ctr++;
+		} else if (is_ccm(cryp)) {
+			ph = stm32_cryp_read(cryp, CRYP_CR) & CR_PH_MASK;
+			if (unlikely(ph == CR_PH_HEADER))
+				/* Write Header */
+				stm32_cryp_irq_write_ccm_header(cryp);
+			else
+				/* Input FIFO IRQ: write data */
+				stm32_cryp_irq_write_data(cryp);
+		} else {
+			/* Input FIFO IRQ: write data */
+			stm32_cryp_irq_write_data(cryp);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -1044,8 +1858,56 @@ static struct crypto_alg crypto_algs[] = {
 },
 };
 
+static struct aead_alg aead_algs[] = {
+{
+	.setkey		= stm32_cryp_aes_aead_setkey,
+	.setauthsize	= stm32_cryp_aes_gcm_setauthsize,
+	.encrypt	= stm32_cryp_aes_gcm_encrypt,
+	.decrypt	= stm32_cryp_aes_gcm_decrypt,
+	.init		= stm32_cryp_aes_aead_init,
+	.ivsize		= 12,
+	.maxauthsize	= AES_BLOCK_SIZE,
+
+	.base = {
+		.cra_name		= "gcm(aes)",
+		.cra_driver_name	= "stm32-gcm-aes",
+		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+},
+{
+	.setkey		= stm32_cryp_aes_aead_setkey,
+	.setauthsize	= stm32_cryp_aes_ccm_setauthsize,
+	.encrypt	= stm32_cryp_aes_ccm_encrypt,
+	.decrypt	= stm32_cryp_aes_ccm_decrypt,
+	.init		= stm32_cryp_aes_aead_init,
+	.ivsize		= AES_BLOCK_SIZE,
+	.maxauthsize	= AES_BLOCK_SIZE,
+
+	.base = {
+		.cra_name		= "ccm(aes)",
+		.cra_driver_name	= "stm32-ccm-aes",
+		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+},
+};
+
+static const struct stm32_cryp_caps f7_data = {
+	.swap_final = true,
+	.padding_wa = true,
+};
+
 static const struct of_device_id stm32_dt_ids[] = {
-	{ .compatible = "st,stm32f756-cryp", },
+	{ .compatible = "st,stm32f756-cryp", .data = &f7_data},
 	{},
 };
 MODULE_DEVICE_TABLE(of, stm32_dt_ids);
@@ -1062,6 +1924,10 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 	if (!cryp)
 		return -ENOMEM;
 
+	cryp->caps = of_device_get_match_data(dev);
+	if (!cryp->caps)
+		return -ENODEV;
+
 	cryp->dev = dev;
 
 	mutex_init(&cryp->lock);
@@ -1130,10 +1996,16 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 		goto err_algs;
 	}
 
+	ret = crypto_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+	if (ret)
+		goto err_aead_algs;
+
 	dev_info(dev, "Initialized\n");
 
 	return 0;
 
+err_aead_algs:
+	crypto_unregister_algs(crypto_algs, ARRAY_SIZE(crypto_algs));
 err_algs:
 err_engine2:
 	crypto_engine_exit(cryp->engine);
@@ -1154,6 +2026,7 @@ static int stm32_cryp_remove(struct platform_device *pdev)
 	if (!cryp)
 		return -ENODEV;
 
+	crypto_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
 	crypto_unregister_algs(crypto_algs, ARRAY_SIZE(crypto_algs));
 
 	crypto_engine_exit(cryp->engine);
-- 
2.7.4
