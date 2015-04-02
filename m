From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH v2] crypto: omap-sham: Add the offset of sg page to vaddr
Date: Thu, 2 Apr 2015 15:32:45 +0530
Message-ID: <1427968965-4944-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nsekhar@ti.com>, <t-kristo@ti.com>,
	Lokesh Vutla <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51151 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbDBKCz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Apr 2015 06:02:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

kmap_atomic() gives only the page address of the input page.
Driver should take care of adding the offset of the scatterlist
within the page to the returned page address.
omap-sham driver is not adding the offset to page and directly operates
on the return vale of kmap_atomic(), because of which the following
error comes when running crypto tests:

00000000: d9 a1 1b 7c aa 90 3b aa 11 ab cb 25 00 b8 ac bf
[    2.338169] 00000010: c1 39 cd ff 48 d0 a8 e2 2b fa 33 a1
[    2.344008] alg: hash: Chunking test 1 failed for omap-sha256

So adding the scatterlist offset to vaddr.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
- Tested on BBB. Logs below.
	Without this patch: http://pastebin.ubuntu.com/10722994/
	With this patch: http://pastebin.ubuntu.com/10722992/
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 21fd515..4d63e0d 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -640,6 +640,7 @@ static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
 
 	while (ctx->sg) {
 		vaddr = kmap_atomic(sg_page(ctx->sg));
+		vaddr += ctx->sg->offset;
 
 		count = omap_sham_append_buffer(ctx,
 				vaddr + ctx->offset,
-- 
1.9.1
