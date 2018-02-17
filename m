From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] crypto: ixp4xxx: Use dma_pool_zalloc()
Date: Sat, 17 Feb 2018 15:41:13 +0530
Message-ID: <20180217101113.GA13514@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:42662 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbeBQKJz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Feb 2018 05:09:55 -0500
Received: by mail-pf0-f193.google.com with SMTP id b25so299324pfd.9
        for <linux-crypto@vger.kernel.org>; Sat, 17 Feb 2018 02:09:54 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use dma_pool_zalloc() instead of dma_pool_alloc + memset

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/crypto/ixp4xx_crypto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 717a266..42e1403 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -537,14 +537,13 @@ static void release_ixp_crypto(struct device *dev)

 static void reset_sa_dir(struct ix_sa_dir *dir)
 {
-	memset(dir->npe_ctx, 0, NPE_CTX_LEN);
 	dir->npe_ctx_idx = 0;
 	dir->npe_mode = 0;
 }

 static int init_sa_dir(struct ix_sa_dir *dir)
 {
-	dir->npe_ctx = dma_pool_alloc(ctx_pool, GFP_KERNEL, &dir->npe_ctx_phys);
+	dir->npe_ctx = dma_pool_zalloc(ctx_pool, GFP_KERNEL, &dir->npe_ctx_phys);
 	if (!dir->npe_ctx) {
 		return -ENOMEM;
 	}
