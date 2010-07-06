From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v3]crypto:hifn_795x.c Fix warning: variable 'ctx' set but not used
Date: Tue,  6 Jul 2010 11:36:37 -0700
Message-ID: <1278441397-10960-1-git-send-email-justinmattock@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, jkosina@suse.cz,
	kim.phillips@freescale.com,
	"Justin P. Mattock" <justinmattock@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:42120 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0GFSol (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jul 2010 14:44:41 -0400
Received: by mail-px0-f174.google.com with SMTP id 14so2299459pxi.19
        for <linux-crypto@vger.kernel.org>; Tue, 06 Jul 2010 11:44:41 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The below patch gets rid of an unused variable ctx reported by
GCC when building the kernel.
  CC [M]  drivers/crypto/hifn_795x.o
drivers/crypto/hifn_795x.c: In function 'hifn_flush':
drivers/crypto/hifn_795x.c:2021:23: warning: variable 'ctx' set but not used
drivers/crypto/hifn_795x.c: In function 'hifn_process_queue':
drivers/crypto/hifn_795x.c:2142:23: warning: variable 'ctx' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/crypto/hifn_795x.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 16fce3a..e449ac5 100644
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
@@ -2035,7 +2034,6 @@ static void hifn_flush(struct hifn_device *dev)
 
 	spin_lock_irqsave(&dev->lock, flags);
 	while ((async_req = crypto_dequeue_request(&dev->queue))) {
-		ctx = crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
 		spin_unlock_irqrestore(&dev->lock, flags);
 
@@ -2139,7 +2137,6 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 static int hifn_process_queue(struct hifn_device *dev)
 {
 	struct crypto_async_request *async_req, *backlog;
-	struct hifn_context *ctx;
 	struct ablkcipher_request *req;
 	unsigned long flags;
 	int err = 0;
@@ -2156,7 +2153,6 @@ static int hifn_process_queue(struct hifn_device *dev)
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
 
-		ctx = crypto_tfm_ctx(async_req->tfm);
 		req = container_of(async_req, struct ablkcipher_request, base);
 
 		err = hifn_handle_req(req);
-- 
1.7.1.rc1.21.gf3bd6
