From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v1] crypto: mediatek - Add empty messages check in GCM mode
Date: Tue, 22 Aug 2017 15:53:39 +0800
Message-ID: <efa7d94ce1b5b63f192d05e7c0a1c74b6b48ec38.1503387350.git.ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, empty messages are not supported in GCM mode, hence add
a check to prevent producing incorrect results.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
changes since v1: 
- fix build erro: add a missing semicolon.

 drivers/crypto/mediatek/mtk-aes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 9e845e8..72e4549 100644
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
+		return -EINVAL;
+
 	rctx->mode = AES_FLAGS_GCM | mode;
 
 	return mtk_aes_handle_queue(ctx->cryp, !!(mode & AES_FLAGS_ENCRYPT),
-- 
1.9.1
