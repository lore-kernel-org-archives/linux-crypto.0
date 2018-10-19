Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:38136 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbeJSJDV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 05:03:21 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 31236C73
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 00:50:56 +0000 (UTC)
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K8DcYuke1xvN for <linux-crypto@vger.kernel.org>;
        Thu, 18 Oct 2018 19:50:56 -0500 (CDT)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id F1A7D92C
        for <linux-crypto@vger.kernel.org>; Thu, 18 Oct 2018 19:50:55 -0500 (CDT)
Received: by mail-it1-f197.google.com with SMTP id 207-v6so2116237itj.6
        for <linux-crypto@vger.kernel.org>; Thu, 18 Oct 2018 17:50:55 -0700 (PDT)
From: Wenwen Wang <wang6495@umn.edu>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        Gadam Sreerama <sgadam@cavium.com>,
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: cavium/nitrox - fix a DMA pool free failure
Date: Thu, 18 Oct 2018 19:50:43 -0500
Message-Id: <1539910247-9250-1-git-send-email-wang6495@umn.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In crypto_alloc_context(), a DMA pool is allocated through dma_pool_alloc()
to hold the crypto context. The meta data of the DMA pool, including the
pool used for the allocation 'ndev->ctx_pool' and the base address of the
DMA pool used by the device 'dma', are then stored to the beginning of the
pool. These meta data are eventually used in crypto_free_context() to free
the DMA pool through dma_pool_free(). However, given that the DMA pool can
also be accessed by the device, a malicious device can modify these meta
data, especially when the device is controlled to deploy an attack. This
can cause an unexpected DMA pool free failure.

To avoid the above issue, this patch introduces a new structure
crypto_ctx_hdr and a new field chdr in the structure nitrox_crypto_ctx hold
the meta data information of the DMA pool after the allocation. Note that
the original structure ctx_hdr is not changed to ensure the compatibility.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/crypto/cavium/nitrox/nitrox_algs.c | 12 +++++++-----
 drivers/crypto/cavium/nitrox/nitrox_lib.c  | 22 +++++++++++++++++-----
 drivers/crypto/cavium/nitrox/nitrox_req.h  |  7 +++++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_algs.c b/drivers/crypto/cavium/nitrox/nitrox_algs.c
index 2ae6124..5d54ebc 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_algs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_algs.c
@@ -73,7 +73,7 @@ static int flexi_aes_keylen(int keylen)
 static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
 {
 	struct nitrox_crypto_ctx *nctx = crypto_skcipher_ctx(tfm);
-	void *fctx;
+	struct crypto_ctx_hdr *chdr;
 
 	/* get the first device */
 	nctx->ndev = nitrox_get_first_device();
@@ -81,12 +81,14 @@ static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
 		return -ENODEV;
 
 	/* allocate nitrox crypto context */
-	fctx = crypto_alloc_context(nctx->ndev);
-	if (!fctx) {
+	chdr = crypto_alloc_context(nctx->ndev);
+	if (!chdr) {
 		nitrox_put_device(nctx->ndev);
 		return -ENOMEM;
 	}
-	nctx->u.ctx_handle = (uintptr_t)fctx;
+	nctx->chdr = chdr;
+	nctx->u.ctx_handle = (uintptr_t)((u8 *)chdr->vaddr +
+					 sizeof(struct ctx_hdr));
 	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(tfm) +
 				    sizeof(struct nitrox_kcrypt_request));
 	return 0;
@@ -102,7 +104,7 @@ static void nitrox_skcipher_exit(struct crypto_skcipher *tfm)
 
 		memset(&fctx->crypto, 0, sizeof(struct crypto_keys));
 		memset(&fctx->auth, 0, sizeof(struct auth_keys));
-		crypto_free_context((void *)fctx);
+		crypto_free_context((void *)nctx->chdr);
 	}
 	nitrox_put_device(nctx->ndev);
 
diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
index 4d31df0..28baf1a 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -146,12 +146,19 @@ static void destroy_crypto_dma_pool(struct nitrox_device *ndev)
 void *crypto_alloc_context(struct nitrox_device *ndev)
 {
 	struct ctx_hdr *ctx;
+	struct crypto_ctx_hdr *chdr;
 	void *vaddr;
 	dma_addr_t dma;
 
+	chdr = kmalloc(sizeof(*chdr), GFP_KERNEL);
+	if (!chdr)
+		return NULL;
+
 	vaddr = dma_pool_alloc(ndev->ctx_pool, (GFP_KERNEL | __GFP_ZERO), &dma);
-	if (!vaddr)
+	if (!vaddr) {
+		kfree(chdr);
 		return NULL;
+	}
 
 	/* fill meta data */
 	ctx = vaddr;
@@ -159,7 +166,11 @@ void *crypto_alloc_context(struct nitrox_device *ndev)
 	ctx->dma = dma;
 	ctx->ctx_dma = dma + sizeof(struct ctx_hdr);
 
-	return ((u8 *)vaddr + sizeof(struct ctx_hdr));
+	chdr->pool = ndev->ctx_pool;
+	chdr->dma = dma;
+	chdr->vaddr = vaddr;
+
+	return chdr;
 }
 
 /**
@@ -168,13 +179,14 @@ void *crypto_alloc_context(struct nitrox_device *ndev)
  */
 void crypto_free_context(void *ctx)
 {
-	struct ctx_hdr *ctxp;
+	struct crypto_ctx_hdr *ctxp;
 
 	if (!ctx)
 		return;
 
-	ctxp = (struct ctx_hdr *)((u8 *)ctx - sizeof(struct ctx_hdr));
-	dma_pool_free(ctxp->pool, ctxp, ctxp->dma);
+	ctxp = ctx;
+	dma_pool_free(ctxp->pool, ctxp->vaddr, ctxp->dma);
+	kfree(ctxp);
 }
 
 /**
diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cavium/nitrox/nitrox_req.h
index d091b6f..19f0a20 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -181,12 +181,19 @@ struct flexi_crypto_context {
 	struct auth_keys auth;
 };
 
+struct crypto_ctx_hdr {
+	struct dma_pool *pool;
+	dma_addr_t dma;
+	void *vaddr;
+};
+
 struct nitrox_crypto_ctx {
 	struct nitrox_device *ndev;
 	union {
 		u64 ctx_handle;
 		struct flexi_crypto_context *fctx;
 	} u;
+	struct crypto_ctx_hdr *chdr;
 };
 
 struct nitrox_kcrypt_request {
-- 
2.7.4
