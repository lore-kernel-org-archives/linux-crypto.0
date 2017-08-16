From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH] crypto: mediatek - Add empty messages check in GCM mode
Date: Wed, 16 Aug 2017 19:19:48 +0800
Message-ID: <018d5b804a22b0aa2e4d759749884b0e15c25de4.1502861307.git.ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, empty messages are not supported in GCM mode, hence add
a check to prevent producing incorrect results.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 9e845e8..efe4e63 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -928,8 +928,13 @@ static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
 {
 	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
 	struct mtk_aes_reqctx *rctx = aead_request_ctx(req);
 
+	/* Empty messages are not supported yet */
+	if (!gctx->textlen && !req->assoclen)
+		return -EINVAL
+
 	rctx->mode = AES_FLAGS_GCM | mode;
 
 	return mtk_aes_handle_queue(ctx->cryp, !!(mode & AES_FLAGS_ENCRYPT),
-- 
1.9.1
