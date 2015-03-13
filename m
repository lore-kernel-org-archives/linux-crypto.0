From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 1/4] crypto: add CRYPTO_TFM_REQ_DMA flag
Date: Fri, 13 Mar 2015 19:37:40 +0200
Message-ID: <1426268260-20824-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>,
	Horia Geanta <horia.geanta@freescale.com>
To: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:37856
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752656AbbCMRhw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 13:37:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CRYPTO_TFM_REQ_DMA flag can be used by backend implementations to
indicate to crypto API the need to allocate GFP_DMA memory
for private contexts of the crypto requests.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 include/crypto/hash.h  | 4 ++++
 include/linux/crypto.h | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 98abda9ed3aa..6e23b27862cd 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -507,6 +507,10 @@ static inline struct ahash_request *ahash_request_alloc(
 {
 	struct ahash_request *req;
 
+	if (crypto_ahash_reqsize(tfm) &&
+	    (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
 	req = kmalloc(sizeof(struct ahash_request) +
 		      crypto_ahash_reqsize(tfm), gfp);
 
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
