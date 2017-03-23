From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] crypto: ixp4xx - Use sg_virt()
Date: Thu, 23 Mar 2017 21:16:30 +0800
Message-ID: <a41fae798473b657f09859ae113403655b1717f9.1490258141.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35378 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752843AbdCWNQk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 09:16:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use sg_virt() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/crypto/ixp4xx_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 7868765..771dd26 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -806,7 +806,7 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 		void *ptr;
 
 		nbytes -= len;
-		ptr = page_address(sg_page(sg)) + sg->offset;
+		ptr = sg_virt(sg);
 		next_buf = dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
 		if (!next_buf) {
 			buf = NULL;
-- 
2.9.3
