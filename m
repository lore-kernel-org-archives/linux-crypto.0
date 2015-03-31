From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH] crypto: omap-sham: Check for HIGHMEM before mapping SG pages
Date: Tue, 31 Mar 2015 09:52:23 +0530
Message-ID: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nsekhar@ti.com>, <t-kristo@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Commit 26a05489ee0e ("crypto: omap-sham - Map SG pages if they are HIGHMEM before accessing")
says that HIGHMEM pages may not be mapped so we must
kmap them before accessing, but it doesn't check whether the
corresponding page is in highmem or not. Because of this all
the crypto tests are failing.

00000000: d9 a1 1b 7c aa 90 3b aa 11 ab cb 25 00 b8 ac bf
[    2.338169] 00000010: c1 39 cd ff 48 d0 a8 e2 2b fa 33 a1
[    2.344008] alg: hash: Chunking test 1 failed for omap-sha256

So Checking for HIGHMEM before mapping SG pages.

Fixes: 26a05489ee0 ("crypto: omap-sham - Map SG pages if they are HIGHMEM before accessing")
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 3c76696..ace5852 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -639,13 +639,17 @@ static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
 	const u8 *vaddr;
 
 	while (ctx->sg) {
-		vaddr = kmap_atomic(sg_page(ctx->sg));
+		if (PageHighMem(sg_page(ctx->sg)))
+			vaddr = kmap_atomic(sg_page(ctx->sg));
+		else
+			vaddr = sg_virt(ctx->sg);
 
 		count = omap_sham_append_buffer(ctx,
 				vaddr + ctx->offset,
 				ctx->sg->length - ctx->offset);
 
-		kunmap_atomic((void *)vaddr);
+		if (PageHighMem(sg_page(ctx->sg)))
+			kunmap_atomic((void *)vaddr);
 
 		if (!count)
 			break;
-- 
1.9.1
