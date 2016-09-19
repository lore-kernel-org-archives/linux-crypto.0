From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 8/8] crypto: omap-sham: shrink the internal buffer size
Date: Mon, 19 Sep 2016 18:22:19 +0300
Message-ID: <1474298539-23897-9-git-send-email-t-kristo@ti.com>
References: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53496 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbcISPXe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 11:23:34 -0400
In-Reply-To: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current internal buffer size is way too large for crypto core, so
shrink it to be smaller. This makes the buffer to fit into the space
reserved for the export/import buffers also.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8eefd79..d0b16e5 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -135,7 +135,7 @@
 #define OMAP_ALIGN_MASK		(sizeof(u32)-1)
 #define OMAP_ALIGNED		__attribute__((aligned(sizeof(u32))))
 
-#define BUFLEN			PAGE_SIZE
+#define BUFLEN			SHA512_BLOCK_SIZE
 #define OMAP_SHA_DMA_THRESHOLD	256
 
 struct omap_sham_dev;
-- 
1.9.1
