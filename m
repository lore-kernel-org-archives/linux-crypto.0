From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 1/4] crypto: add CRYPTO_TFM_REQ_DMA flag
Date: Fri, 13 Mar 2015 19:14:42 +0200
Message-ID: <1426266882-31626-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0115.outbound.protection.outlook.com ([207.46.100.115]:35586
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751210AbbCMRPG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 13:15:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CRYPTO_TFM_REQ_DMA flag can be used by backend implementations to
indicate to crypto API the need to allocate GFP_DMA memory
for private contexts of the crypto requests.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 include/linux/crypto.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fb5ef16d6a12..64258c9198d5 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -103,6 +103,7 @@
 #define CRYPTO_TFM_REQ_WEAK_KEY		0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
+#define CRYPTO_TFM_REQ_DMA		0x00000800
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
 #define CRYPTO_TFM_RES_BAD_KEY_LEN   	0x00200000
 #define CRYPTO_TFM_RES_BAD_KEY_SCHED 	0x00400000
@@ -1108,6 +1109,10 @@ static inline struct ablkcipher_request *ablkcipher_request_alloc(
 {
 	struct ablkcipher_request *req;
 
+	if (crypto_ablkcipher_reqsize(tfm) &&
+	    (crypto_ablkcipher_get_flags(tfm) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
 	req = kmalloc(sizeof(struct ablkcipher_request) +
 		      crypto_ablkcipher_reqsize(tfm), gfp);
 
@@ -1471,6 +1476,10 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 {
 	struct aead_request *req;
 
+	if (crypto_aead_reqsize(tfm) &&
+	    (crypto_aead_get_flags(tfm) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
 	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
 
 	if (likely(req))
-- 
1.8.3.1
