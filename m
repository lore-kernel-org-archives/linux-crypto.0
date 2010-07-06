From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2]crypto:hifn_795x.c Fix warning: variable 'ctx' set but not used
Date: Tue,  6 Jul 2010 09:59:38 -0700
Message-ID: <1278435578-3638-1-git-send-email-justinmattock@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, jkosina@suse.cz,
	"Justin P. Mattock" <justinmattock@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55103 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0GFQ7e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jul 2010 12:59:34 -0400
Received: by pvc7 with SMTP id 7so2707675pvc.19
        for <linux-crypto@vger.kernel.org>; Tue, 06 Jul 2010 09:59:33 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is version two of fixing a warning message from GCC
  CC [M]  drivers/crypto/hifn_795x.o
drivers/crypto/hifn_795x.c: In function 'hifn_flush':
drivers/crypto/hifn_795x.c:2021:23: warning: variable 'ctx' set but not used
drivers/crypto/hifn_795x.c: In function 'hifn_process_queue':
drivers/crypto/hifn_795x.c:2142:23: warning: variable 'ctx' set but not used
just remove the line that initialises ctx.
 
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/crypto/hifn_795x.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 16fce3a..1540bb4 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2018,7 +2018,6 @@ static void hifn_flush(struct hifn_device *dev)
 {
 	unsigned long flags;
 	struct crypto_async_request *async_req;
-	struct hifn_context *ctx;
 	struct ablkcipher_request *req;
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int i;
@@ -2035,7 +2034,7 @@ static void hifn_flush(struct hifn_device *dev)
 
 	spin_lock_irqsave(&dev->lock, flags);
 	while ((async_req = crypto_dequeue_request(&dev->queue))) {
-		ctx = crypto_tfm_ctx(async_req->tfm);
+		crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
 		spin_unlock_irqrestore(&dev->lock, flags);
 
@@ -2139,7 +2138,6 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 static int hifn_process_queue(struct hifn_device *dev)
 {
 	struct crypto_async_request *async_req, *backlog;
-	struct hifn_context *ctx;
 	struct ablkcipher_request *req;
 	unsigned long flags;
 	int err = 0;
@@ -2156,7 +2154,7 @@ static int hifn_process_queue(struct hifn_device *dev)
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
 
-		ctx = crypto_tfm_ctx(async_req->tfm);
+		crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
 
 		err = hifn_handle_req(req);
-- 
1.7.1.rc1.21.gf3bd6
