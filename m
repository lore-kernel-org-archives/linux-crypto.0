From: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Subject: [PATCH 1/2] crypto: s5p-sss - Fix minor coding style violations
Date: Mon, 11 Jan 2016 20:45:50 +0900
Message-ID: <1452512751-4084-1-git-send-email-k.kozlowski.k@gmail.com>
Cc: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33226 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbcAKLqF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2016 06:46:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Improve a little bit code readability and use dev_info/err for printing
messages.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
---
 drivers/crypto/s5p-sss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index f214a8755827..e10284744fd2 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -224,6 +224,7 @@ static inline struct samsung_aes_variant *find_s5p_sss_version
 {
 	if (IS_ENABLED(CONFIG_OF) && (pdev->dev.of_node)) {
 		const struct of_device_id *match;
+
 		match = of_match_node(s5p_sss_dt_match,
 					pdev->dev.of_node);
 		return (struct samsung_aes_variant *)match->data;
@@ -397,7 +398,6 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 {
 	struct ablkcipher_request  *req = dev->req;
-
 	uint32_t                    aes_control;
 	int                         err;
 	unsigned long               flags;
@@ -518,7 +518,7 @@ static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	struct s5p_aes_dev         *dev    = ctx->dev;
 
 	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
-		pr_err("request size is not exact amount of AES blocks\n");
+		dev_err(dev->dev, "request size is not exact amount of AES blocks\n");
 		return -EINVAL;
 	}
 
@@ -566,7 +566,7 @@ static int s5p_aes_cbc_decrypt(struct ablkcipher_request *req)
 
 static int s5p_aes_cra_init(struct crypto_tfm *tfm)
 {
-	struct s5p_aes_ctx  *ctx = crypto_tfm_ctx(tfm);
+	struct s5p_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->dev = s5p_dev;
 	tfm->crt_ablkcipher.reqsize = sizeof(struct s5p_aes_reqctx);
@@ -701,7 +701,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 			goto err_algs;
 	}
 
-	pr_info("s5p-sss driver registered\n");
+	dev_info(dev, "s5p-sss driver registered\n");
 
 	return 0;
 
-- 
2.1.4
