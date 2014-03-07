From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v3] crypto: omap-sham: Map SG pages if they are HIGHMEM before accessing
Date: Fri, 7 Mar 2014 10:28:46 -0600
Message-ID: <1394209726-6746-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
	Joel Fernandes <joelf@ti.com>
To: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

HIGHMEM pages may not be mapped so we must kmap them before accessing.
This resolves a random OOPs error that was showing up during OpenSSL SHA tests.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
v2: Don't check for HIGHMEM, already done by kmap/unmap
v3: Use atomic as call can happen in irq context.

 drivers/crypto/omap-sham.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8bdde57..54b3ed1 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -636,11 +636,17 @@ static size_t omap_sham_append_buffer(struct omap_sham_reqctx *ctx,
 static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
 {
 	size_t count;
+	const u8 *vaddr;
 
 	while (ctx->sg) {
+		vaddr = kmap_atomic(sg_page(ctx->sg));
+
 		count = omap_sham_append_buffer(ctx,
-				sg_virt(ctx->sg) + ctx->offset,
+				vaddr + ctx->offset,
 				ctx->sg->length - ctx->offset);
+
+		kunmap_atomic((void *)vaddr);
+
 		if (!count)
 			break;
 		ctx->offset += count;
-- 
1.7.9.5

