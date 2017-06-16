From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: vmx: remove unnecessary check
Date: Fri, 16 Jun 2017 11:39:48 +0300
Message-ID: <1497602388-6886-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <leosilva@linux.vnet.ibm.com>, <pfsmorigo@linux.vnet.ibm.com>,
        <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:57994 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753140AbdFPIkG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 04:40:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

You can't reach init() if parent alg_name is invalid. Moreover,
cypto_alloc_base() will return ENOENT if alg_name is NULL.
Found while grasping the fallback mechanism.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/vmx/aes.c     | 7 +------
 drivers/crypto/vmx/aes_cbc.c | 7 +------
 drivers/crypto/vmx/aes_ctr.c | 7 +------
 drivers/crypto/vmx/aes_xts.c | 7 +------
 4 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index 022c7ab..96072b9 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -37,15 +37,10 @@ struct p8_aes_ctx {
 
 static int p8_aes_init(struct crypto_tfm *tfm)
 {
-	const char *alg;
+	const char *alg = crypto_tfm_alg_name(tfm);
 	struct crypto_cipher *fallback;
 	struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!(alg = crypto_tfm_alg_name(tfm))) {
-		printk(KERN_ERR "Failed to get algorithm name.\n");
-		return -ENOENT;
-	}
-
 	fallback = crypto_alloc_cipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index 72a26eb..7394d35 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -39,15 +39,10 @@ struct p8_aes_cbc_ctx {
 
 static int p8_aes_cbc_init(struct crypto_tfm *tfm)
 {
-	const char *alg;
+	const char *alg = crypto_tfm_alg_name(tfm);
 	struct crypto_skcipher *fallback;
 	struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!(alg = crypto_tfm_alg_name(tfm))) {
-		printk(KERN_ERR "Failed to get algorithm name.\n");
-		return -ENOENT;
-	}
-
 	fallback = crypto_alloc_skcipher(alg, 0,
 			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 7cf6d31..9c26d9e 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -36,15 +36,10 @@ struct p8_aes_ctr_ctx {
 
 static int p8_aes_ctr_init(struct crypto_tfm *tfm)
 {
-	const char *alg;
+	const char *alg = crypto_tfm_alg_name(tfm);
 	struct crypto_blkcipher *fallback;
 	struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!(alg = crypto_tfm_alg_name(tfm))) {
-		printk(KERN_ERR "Failed to get algorithm name.\n");
-		return -ENOENT;
-	}
-
 	fallback =
 	    crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index 6adc929..8cd6e62 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -41,15 +41,10 @@ struct p8_aes_xts_ctx {
 
 static int p8_aes_xts_init(struct crypto_tfm *tfm)
 {
-	const char *alg;
+	const char *alg = crypto_tfm_alg_name(tfm);
 	struct crypto_skcipher *fallback;
 	struct p8_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!(alg = crypto_tfm_alg_name(tfm))) {
-		printk(KERN_ERR "Failed to get algorithm name.\n");
-		return -ENOENT;
-	}
-
 	fallback = crypto_alloc_skcipher(alg, 0,
 			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
-- 
2.7.4
