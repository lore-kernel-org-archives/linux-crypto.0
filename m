From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2] crypto: omap-sham: kmap SG pages before appending
Date: Tue, 4 Mar 2014 12:30:54 -0600
Message-ID: <1393957854-10961-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <lokeshvutla@ti.com>, Joel Fernandes <joelf@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

HIGHMEM pages may not be mapped so we must kmap them before accessing.
This resolves a random OOPs error that was showing up during OpenSSL SHA tests.

Signed-off-by: Joel Fernandes <joelf@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
v2 changes:
	- don't check for HIGHMEM, kmap/kunmap do them anyway (Thanks Herbert).

 drivers/crypto/omap-sham.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e45aaaf..207eac1 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -636,11 +636,17 @@ static size_t omap_sham_append_buffer(struct omap_sham_reqctx *ctx,
 static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
 {
 	size_t count;
+	const u8 *vaddr;
 
 	while (ctx->sg) {
+		vaddr = kmap(sg_page(ctx->sg));
+
 		count = omap_sham_append_buffer(ctx,
-				sg_virt(ctx->sg) + ctx->offset,
+				vaddr + ctx->offset,
 				ctx->sg->length - ctx->offset);
+
+		kunmap((void *)vaddr);
+
 		if (!count)
 			break;
 		ctx->offset += count;
-- 
1.7.9.5

