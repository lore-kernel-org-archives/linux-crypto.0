From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/4] crypto: skcipher - Remove unused argument to SKCIPHER_REQUEST_ON_STACK()
Date: Thu,  6 Sep 2018 15:58:54 -0700
Message-ID: <20180906225854.40989-5-keescook@chromium.org>
References: <20180906225854.40989-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906225854.40989-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since the size is now fixed, there is no need to include the tfm
argument. This removes it from the definition and callers.

Suggested-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/s390/crypto/aes_s390.c                        |  8 ++++----
 arch/x86/crypto/fpu.c                              |  4 ++--
 crypto/algif_aead.c                                |  2 +-
 crypto/authenc.c                                   |  2 +-
 crypto/authencesn.c                                |  2 +-
 crypto/cryptd.c                                    |  4 ++--
 crypto/echainiv.c                                  |  2 +-
 crypto/gcm.c                                       |  2 +-
 crypto/seqiv.c                                     |  2 +-
 drivers/block/cryptoloop.c                         |  2 +-
 drivers/crypto/axis/artpec6_crypto.c               |  2 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |  2 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  2 +-
 drivers/crypto/mxs-dcp.c                           |  2 +-
 drivers/crypto/omap-aes.c                          |  2 +-
 drivers/crypto/picoxcell_crypto.c                  |  2 +-
 drivers/crypto/qce/ablkcipher.c                    |  2 +-
 drivers/crypto/sahara.c                            |  8 ++++----
 drivers/crypto/vmx/aes_cbc.c                       |  4 ++--
 drivers/crypto/vmx/aes_ctr.c                       |  2 +-
 drivers/crypto/vmx/aes_xts.c                       |  2 +-
 drivers/net/ppp/ppp_mppe.c                         |  6 +++---
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |  4 ++--
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |  4 ++--
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |  4 ++--
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |  4 ++--
 drivers/usb/wusbcore/crypto.c                      |  2 +-
 include/crypto/skcipher.h                          |  2 +-
 net/ceph/crypto.c                                  |  2 +-
 net/mac802154/llsec.c                              |  4 ++--
 net/rxrpc/rxkad.c                                  | 10 +++++-----
 net/sunrpc/auth_gss/gss_krb5_crypto.c              | 14 +++++++-------
 net/wireless/lib80211_crypt_tkip.c                 |  4 ++--
 net/wireless/lib80211_crypt_wep.c                  |  4 ++--
 34 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index c54cb26eb7f5..212c076d36a7 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -204,7 +204,7 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 	unsigned int ret;
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
+	SKCIPHER_REQUEST_ON_STACK(req);
 
 	skcipher_request_set_tfm(req, sctx->fallback.blk);
 	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
@@ -223,7 +223,7 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 	unsigned int ret;
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
+	SKCIPHER_REQUEST_ON_STACK(req);
 
 	skcipher_request_set_tfm(req, sctx->fallback.blk);
 	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
@@ -472,7 +472,7 @@ static int xts_fallback_decrypt(struct blkcipher_desc *desc,
 {
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	unsigned int ret;
 
 	skcipher_request_set_tfm(req, xts_ctx->fallback);
@@ -491,7 +491,7 @@ static int xts_fallback_encrypt(struct blkcipher_desc *desc,
 {
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	unsigned int ret;
 
 	skcipher_request_set_tfm(req, xts_ctx->fallback);
diff --git a/arch/x86/crypto/fpu.c b/arch/x86/crypto/fpu.c
index 406680476c52..746cea05c07e 100644
--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -44,7 +44,7 @@ static int crypto_fpu_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	SKCIPHER_REQUEST_ON_STACK(subreq);
 	int err;
 
 	skcipher_request_set_tfm(subreq, child);
@@ -65,7 +65,7 @@ static int crypto_fpu_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_fpu_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	SKCIPHER_REQUEST_ON_STACK(subreq);
 	int err;
 
 	skcipher_request_set_tfm(subreq, child);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index c40a8c7ee8ae..2f7d95d63fa9 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -79,7 +79,7 @@ static int crypto_aead_copy_sgl(struct crypto_skcipher *null_tfm,
 				struct scatterlist *src,
 				struct scatterlist *dst, unsigned int len)
 {
-	SKCIPHER_REQUEST_ON_STACK(skreq, null_tfm);
+	SKCIPHER_REQUEST_ON_STACK(skreq);
 
 	skcipher_request_set_tfm(skreq, null_tfm);
 	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 4fa8d40d947b..17116e8c60b7 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -185,7 +185,7 @@ static int crypto_authenc_copy_assoc(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
+	SKCIPHER_REQUEST_ON_STACK(skreq);
 
 	skcipher_request_set_tfm(skreq, ctx->null);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 50b804747e20..70ee4e55ae21 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -183,7 +183,7 @@ static int crypto_authenc_esn_copy(struct aead_request *req, unsigned int len)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
+	SKCIPHER_REQUEST_ON_STACK(skreq);
 
 	skcipher_request_set_tfm(skreq, ctx->null);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index addca7bae33f..4c51fff4263e 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -484,7 +484,7 @@ static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	SKCIPHER_REQUEST_ON_STACK(subreq);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
@@ -512,7 +512,7 @@ static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child = ctx->child;
-	SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	SKCIPHER_REQUEST_ON_STACK(subreq);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 45819e6015bf..0289873f3b08 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -47,7 +47,7 @@ static int echainiv_encrypt(struct aead_request *req)
 	info = req->iv;
 
 	if (req->src != req->dst) {
-		SKCIPHER_REQUEST_ON_STACK(nreq, ctx->sknull);
+		SKCIPHER_REQUEST_ON_STACK(nreq);
 
 		skcipher_request_set_tfm(nreq, ctx->sknull);
 		skcipher_request_set_callback(nreq, req->base.flags,
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 0ad879e1f9b2..4aae4e30d74b 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1067,7 +1067,7 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int nbytes = req->assoclen + req->cryptlen -
 			      (enc ? 0 : authsize);
-	SKCIPHER_REQUEST_ON_STACK(nreq, ctx->null);
+	SKCIPHER_REQUEST_ON_STACK(nreq);
 
 	skcipher_request_set_tfm(nreq, ctx->null);
 	skcipher_request_set_callback(nreq, req->base.flags, NULL, NULL);
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 39dbf2f7e5f5..920161e65dd9 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -73,7 +73,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	info = req->iv;
 
 	if (req->src != req->dst) {
-		SKCIPHER_REQUEST_ON_STACK(nreq, ctx->sknull);
+		SKCIPHER_REQUEST_ON_STACK(nreq);
 
 		skcipher_request_set_tfm(nreq, ctx->sknull);
 		skcipher_request_set_callback(nreq, req->base.flags,
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 7033a4beda66..1c58b5a1d875 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -110,7 +110,7 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
 		    int size, sector_t IV)
 {
 	struct crypto_skcipher *tfm = lo->key_data;
-	SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct scatterlist sg_out;
 	struct scatterlist sg_in;
 
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 7f07a5085e9b..ac422c455e12 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1205,7 +1205,7 @@ artpec6_crypto_ctr_crypt(struct skcipher_request *req, bool encrypt)
 			return ret;
 
 		{
-			SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+			SKCIPHER_REQUEST_ON_STACK(subreq);
 
 			skcipher_request_set_tfm(subreq, ctx->fallback);
 			skcipher_request_set_callback(subreq, req->base.flags,
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 94b5bcf5b628..b5bc6ad74768 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -151,7 +151,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	    (ctx->u.aes.key_len != AES_KEYSIZE_256))
 		fallback = 1;
 	if (fallback) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
+		SKCIPHER_REQUEST_ON_STACK(subreq);
 
 		/* Use the fallback to process the request for any
 		 * unsupported unit sizes or key sizes
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 5c539af8ed60..eb1101e6a7bd 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -681,7 +681,7 @@ static int chcr_cipher_fallback(struct crypto_skcipher *cipher,
 {
 	int err;
 
-	SKCIPHER_REQUEST_ON_STACK(subreq, cipher);
+	SKCIPHER_REQUEST_ON_STACK(subreq);
 
 	skcipher_request_set_tfm(subreq, cipher);
 	skcipher_request_set_callback(subreq, flags, NULL, NULL);
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index a10c418d4e5c..c81b11d34903 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -376,7 +376,7 @@ static int mxs_dcp_block_fallback(struct ablkcipher_request *req, int enc)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct dcp_async_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+	SKCIPHER_REQUEST_ON_STACK(subreq);
 	int ret;
 
 	skcipher_request_set_tfm(subreq, ctx->fallback);
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9019f6b67986..67626c523160 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -522,7 +522,7 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 		  !!(mode & FLAGS_CBC));
 
 	if (req->nbytes < aes_fallback_sz) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(subreq);
 
 		skcipher_request_set_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags, NULL,
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 321d5e2ac833..1ba6a3ab9421 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -914,7 +914,7 @@ static int spacc_ablk_do_fallback(struct ablkcipher_request *req,
 	struct crypto_tfm *old_tfm =
 	    crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(old_tfm);
-	SKCIPHER_REQUEST_ON_STACK(subreq, ctx->sw_cipher);
+	SKCIPHER_REQUEST_ON_STACK(subreq);
 	int err;
 
 	/*
diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index ea4d96bf47e8..cde3dad00ddf 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -212,7 +212,7 @@ static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
 
 	if (IS_AES(rctx->flags) && ctx->enc_keylen != AES_KEYSIZE_128 &&
 	    ctx->enc_keylen != AES_KEYSIZE_256) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(subreq);
 
 		skcipher_request_set_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index e7540a5b8197..f9a29d8bbf1a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -666,7 +666,7 @@ static int sahara_aes_ecb_encrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(subreq);
 
 		skcipher_request_set_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
@@ -688,7 +688,7 @@ static int sahara_aes_ecb_decrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(subreq);
 
 		skcipher_request_set_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
@@ -710,7 +710,7 @@ static int sahara_aes_cbc_encrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(subreq);
 
 		skcipher_request_set_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
@@ -732,7 +732,7 @@ static int sahara_aes_cbc_decrypt(struct ablkcipher_request *req)
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(subreq);
 
 		skcipher_request_set_tfm(subreq, ctx->fallback);
 		skcipher_request_set_callback(subreq, req->base.flags,
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index b71895871be3..c4a02092e798 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -100,7 +100,7 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(req);
 		skcipher_request_set_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
@@ -139,7 +139,7 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(req);
 		skcipher_request_set_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index cd777c75291d..936d21fcd094 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -119,7 +119,7 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(req);
 		skcipher_request_set_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index e9954a7d4694..1004f7a08d72 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -109,7 +109,7 @@ static int p8_aes_xts_crypt(struct blkcipher_desc *desc,
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
 
 	if (in_interrupt()) {
-		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		SKCIPHER_REQUEST_ON_STACK(req);
 		skcipher_request_set_tfm(req, ctx->fallback);
 		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
 		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index a205750b431b..ec598650b92f 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -155,7 +155,7 @@ static void get_new_key_from_sha(struct ppp_mppe_state * state)
 static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 {
 	struct scatterlist sg_in[1], sg_out[1];
-	SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
+	SKCIPHER_REQUEST_ON_STACK(req);
 
 	skcipher_request_set_tfm(req, state->arc4);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
@@ -366,7 +366,7 @@ mppe_compress(void *arg, unsigned char *ibuf, unsigned char *obuf,
 	      int isize, int osize)
 {
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
-	SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	int proto;
 	int err;
 	struct scatterlist sg_in[1], sg_out[1];
@@ -480,7 +480,7 @@ mppe_decompress(void *arg, unsigned char *ibuf, int isize, unsigned char *obuf,
 		int osize)
 {
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
-	SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	unsigned ccount;
 	int flushed = MPPE_BITS(ibuf) & MPPE_BIT_FLUSHED;
 	struct scatterlist sg_in[1], sg_out[1];
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
index 9f18be14dda6..b53ea12a43f7 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
@@ -337,7 +337,7 @@ static int rtllib_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	*pos++ = (tkey->tx_iv32 >> 24) & 0xff;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		icv = skb_put(skb, 4);
 		crc = ~crc32_le(~0, pos, len);
@@ -420,7 +420,7 @@ static int rtllib_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (!tcb_desc->bHwSec || (skb->cb[0] == 1)) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		if ((iv32 < tkey->rx_iv32 ||
 		    (iv32 == tkey->rx_iv32 && iv16 <= tkey->rx_iv16)) &&
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_wep.c b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
index b3343a5d0fd6..4d53ad9d44bf 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_wep.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
@@ -135,7 +135,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	memcpy(key + 3, wep->key, wep->key_len);
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		/* Append little-endian CRC32 and encrypt it to produce ICV */
 		crc = ~crc32_le(~0, pos, len);
@@ -199,7 +199,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		sg_init_one(&sg, pos, plen+4);
 		crypto_skcipher_setkey(wep->rx_tfm, key, klen);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index 1088fa0aee0e..0f67b0da45b7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -340,7 +340,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	*pos++ = (tkey->tx_iv32 >> 24) & 0xff;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		icv = skb_put(skb, 4);
 		crc = ~crc32_le(~0, pos, len);
@@ -418,7 +418,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		if (iv32 < tkey->rx_iv32 ||
 		(iv32 == tkey->rx_iv32 && iv16 <= tkey->rx_iv16)) {
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
index b9f86be9e52b..4dffbd55db7c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
@@ -128,7 +128,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	memcpy(key + 3, wep->key, wep->key_len);
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		/* Append little-endian CRC32 and encrypt it to produce ICV */
 		crc = ~crc32_le(~0, pos, len);
@@ -193,7 +193,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		crypto_skcipher_setkey(wep->rx_tfm, key, klen);
 		sg_init_one(&sg, pos, plen+4);
diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index aff50eb09ca9..4f151cf5992e 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -198,7 +198,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
 			size_t blen)
 {
 	int result = 0;
-	SKCIPHER_REQUEST_ON_STACK(req, tfm_cbc);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct scatterlist sg[4], sg_dst;
 	void *dst_buf;
 	size_t dst_size;
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index cca216999bf1..09270f12b90b 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -145,7 +145,7 @@ struct skcipher_alg {
  * This must only ever be used with synchronous algorithms.
  */
 #define MAX_SYNC_SKCIPHER_REQSIZE	384
-#define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
+#define SKCIPHER_REQUEST_ON_STACK(name) \
 	char __##name##_desc[sizeof(struct skcipher_request) + \
 		MAX_SYNC_SKCIPHER_REQSIZE] CRYPTO_MINALIGN_ATTR = { 1 }; \
 	struct skcipher_request *name = (void *)__##name##_desc
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 02172c408ff2..f4ceab8fa0e4 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -216,7 +216,7 @@ static void teardown_sgtable(struct sg_table *sgt)
 static int ceph_aes_crypt(const struct ceph_crypto_key *key, bool encrypt,
 			  void *buf, int buf_len, int in_len, int *pout_len)
 {
-	SKCIPHER_REQUEST_ON_STACK(req, key->tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct sg_table sgt;
 	struct scatterlist prealloc_sg;
 	char iv[AES_BLOCK_SIZE] __aligned(8);
diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index 2fb703d70803..b957a04329d0 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -622,7 +622,7 @@ llsec_do_encrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 {
 	u8 iv[16];
 	struct scatterlist src;
-	SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	int err, datalen;
 	unsigned char *data;
 
@@ -840,7 +840,7 @@ llsec_do_decrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 	unsigned char *data;
 	int datalen;
 	struct scatterlist src;
-	SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	int err;
 
 	llsec_geniv(iv, dev_addr, &hdr->sec);
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index cea16838d588..49d7480ea514 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -104,7 +104,7 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn)
 static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
 {
 	struct rxrpc_key_token *token;
-	SKCIPHER_REQUEST_ON_STACK(req, conn->cipher);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct scatterlist sg;
 	struct rxrpc_crypt iv;
 	__be32 *tmpbuf;
@@ -250,7 +250,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 			       void *sechdr)
 {
 	struct rxrpc_skb_priv *sp;
-	SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
 	u32 x, y;
@@ -506,7 +506,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 			       unsigned int offset, unsigned int len,
 			       rxrpc_seq_t seq, u16 expected_cksum)
 {
-	SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
 	bool aborted;
@@ -755,7 +755,7 @@ static void rxkad_encrypt_response(struct rxrpc_connection *conn,
 				   struct rxkad_response *resp,
 				   const struct rxkad_key *s2)
 {
-	SKCIPHER_REQUEST_ON_STACK(req, conn->cipher);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[1];
 
@@ -1021,7 +1021,7 @@ static void rxkad_decrypt_response(struct rxrpc_connection *conn,
 				   struct rxkad_response *resp,
 				   const struct rxrpc_crypt *session_key)
 {
-	SKCIPHER_REQUEST_ON_STACK(req, rxkad_ci);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	struct scatterlist sg[1];
 	struct rxrpc_crypt iv;
 
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index 0220e1ca5280..cd910960e734 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -62,7 +62,7 @@ krb5_encrypt(
 	u32 ret = -EINVAL;
 	struct scatterlist sg[1];
 	u8 local_iv[GSS_KRB5_MAX_BLOCKSIZE] = {0};
-	SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 
 	if (length % crypto_skcipher_blocksize(tfm) != 0)
 		goto out;
@@ -101,7 +101,7 @@ krb5_decrypt(
 	u32 ret = -EINVAL;
 	struct scatterlist sg[1];
 	u8 local_iv[GSS_KRB5_MAX_BLOCKSIZE] = {0};
-	SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 
 	if (length % crypto_skcipher_blocksize(tfm) != 0)
 		goto out;
@@ -531,7 +531,7 @@ gss_encrypt_xdr_buf(struct crypto_skcipher *tfm, struct xdr_buf *buf,
 {
 	int ret;
 	struct encryptor_desc desc;
-	SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 
 	BUG_ON((buf->len - offset) % crypto_skcipher_blocksize(tfm) != 0);
 
@@ -613,7 +613,7 @@ gss_decrypt_xdr_buf(struct crypto_skcipher *tfm, struct xdr_buf *buf,
 {
 	int ret;
 	struct decryptor_desc desc;
-	SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 
 	/* XXXJBF: */
 	BUG_ON((buf->len - offset) % crypto_skcipher_blocksize(tfm) != 0);
@@ -677,7 +677,7 @@ gss_krb5_cts_crypt(struct crypto_skcipher *cipher, struct xdr_buf *buf,
 {
 	u32 ret;
 	struct scatterlist sg[1];
-	SKCIPHER_REQUEST_ON_STACK(req, cipher);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	u8 *data;
 	struct page **save_pages;
 	u32 len = buf->len - offset;
@@ -807,7 +807,7 @@ gss_krb5_aes_encrypt(struct krb5_ctx *kctx, u32 offset,
 	memset(desc.iv, 0, sizeof(desc.iv));
 
 	if (cbcbytes) {
-		SKCIPHER_REQUEST_ON_STACK(req, aux_cipher);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		desc.pos = offset + GSS_KRB5_TOK_HDR_LEN;
 		desc.fragno = 0;
@@ -891,7 +891,7 @@ gss_krb5_aes_decrypt(struct krb5_ctx *kctx, u32 offset, struct xdr_buf *buf,
 	memset(desc.iv, 0, sizeof(desc.iv));
 
 	if (cbcbytes) {
-		SKCIPHER_REQUEST_ON_STACK(req, aux_cipher);
+		SKCIPHER_REQUEST_ON_STACK(req);
 
 		desc.fragno = 0;
 		desc.fraglen = 0;
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index e6bce1f130c9..f181ed4e8c22 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -344,7 +344,7 @@ static int lib80211_tkip_hdr(struct sk_buff *skb, int hdr_len,
 static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	int len;
 	u8 rc4key[16], *pos, *icv;
 	u32 crc;
@@ -400,7 +400,7 @@ static inline int tkip_replay_check(u32 iv32_n, u16 iv16_n,
 static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	u8 rc4key[16];
 	u8 keyidx, *pos;
 	u32 iv32;
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index d05f58b0fd04..f642f45ae9ff 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -129,7 +129,7 @@ static int lib80211_wep_build_iv(struct sk_buff *skb, int hdr_len,
 static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	u32 crc, klen, len;
 	u8 *pos, *icv;
 	struct scatterlist sg;
@@ -182,7 +182,7 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
+	SKCIPHER_REQUEST_ON_STACK(req);
 	u32 crc, klen, plen;
 	u8 key[WEP_KEY_LEN + 3];
 	u8 keyidx, *pos, icv[4];
-- 
2.17.1
