Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2977168A9
	for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2024 12:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714479356; cv=none; b=HPsas/Fk0ozdZ5e7u+FXOrDCSGTf2vRQ5dEcHyhO0W0nhlawviYO/vIcx7uNeeLS55f0Hy+qSUcbAiGoKd9bfAHY7eD9ZkzEdQq75rYQDoPvKNRH8FSLsyX9e8bRtKsKlwg1ktQXCSH76FJ2LqTC2KI9U46rl7cIwdqgHUdzpUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714479356; c=relaxed/simple;
	bh=RTWlSeC2wglCCVDNY+KaeZe9mfpvE+kZS++gDfsg0T4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OUeCZpErFzCW6yg0hNmiolvbuy+ZheiNEP2yrjFEBLQJ3zaPVSVcGWd/BEckmflE+01477UobUjPyoHBdmrOvhh/7yrkEw69rG2yTNv001Dw5EnK4Ot3OS3jVO/KmpQuI4h+5ynEr9ZNWHC0fQx6pYEnlqAOSglzp34AwV7mbko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=U+Z92GQr; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="U+Z92GQr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=from:to:cc:subject:date:message-id
	:mime-version:content-transfer-encoding; s=k1; bh=1Mcipb9dUpVy//
	WMw2ZuImhnom+VYm7qLXmOugjjkZI=; b=U+Z92GQrw+8jDcECjpUIhr9VbGu5b8
	p130XbruMec0cGbAwPA11Tdd/cABkv7slyzGM59t8iB7MdW/Wtv1ENGQzBhl7Ahn
	Fk9YFXVoipbig0XCo+C8k5tb1Kme7wb/VjcY32aCuDJfLEzYOjvsp705oxB1EnvS
	p7s6iw6dsnZWZ6leEuwn0nLM571XaAbNr6r42XDwTYfe4YYUPRFdPrt4DdplC8uG
	XjoGgqVQBaQPRvrFhnuBFBq8TTgsWjRT/cZuQHOXitq4SH+IYLg+HSJQ4GwDmog9
	OGoNCnTCR9/KPhvJS8YWsNYijtxw4ntMP2ZoZmGL17L4B8z5GtvEof5w==
Received: (qmail 2628262 invoked from network); 30 Apr 2024 14:15:51 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 30 Apr 2024 14:15:51 +0200
X-UD-Smtp-Session: l3s3148p1@IOO3VE8XHolehhrb
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-crypto@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/1] crypto: sahara: use 'time_left' variable with wait_for_completion_timeout()
Date: Tue, 30 Apr 2024 14:15:51 +0200
Message-ID: <20240430121551.30790-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a confusing pattern in the kernel to use a variable named 'timeout' to
store the result of wait_for_completion_timeout() causing patterns like:

	timeout = wait_for_completion_timeout(...)
	if (!timeout) return -ETIMEDOUT;

with all kinds of permutations. Use 'time_left' as a variable to make the code
self explaining.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/crypto/sahara.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 3423b5cde1c7..96d4af5d48a6 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -559,7 +559,7 @@ static int sahara_aes_process(struct skcipher_request *req)
 	struct sahara_ctx *ctx;
 	struct sahara_aes_reqctx *rctx;
 	int ret;
-	unsigned long timeout;
+	unsigned long time_left;
 
 	/* Request is ready to be dispatched by the device */
 	dev_dbg(dev->device,
@@ -597,15 +597,15 @@ static int sahara_aes_process(struct skcipher_request *req)
 	if (ret)
 		return -EINVAL;
 
-	timeout = wait_for_completion_timeout(&dev->dma_completion,
-				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
+	time_left = wait_for_completion_timeout(&dev->dma_completion,
+						msecs_to_jiffies(SAHARA_TIMEOUT_MS));
 
 	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
 		DMA_FROM_DEVICE);
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
 
-	if (!timeout) {
+	if (!time_left) {
 		dev_err(dev->device, "AES timeout\n");
 		return -ETIMEDOUT;
 	}
@@ -931,7 +931,7 @@ static int sahara_sha_process(struct ahash_request *req)
 	struct sahara_dev *dev = dev_ptr;
 	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
 	int ret;
-	unsigned long timeout;
+	unsigned long time_left;
 
 	ret = sahara_sha_prepare_request(req);
 	if (!ret)
@@ -963,14 +963,14 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	sahara_write(dev, dev->hw_phys_desc[0], SAHARA_REG_DAR);
 
-	timeout = wait_for_completion_timeout(&dev->dma_completion,
-				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
+	time_left = wait_for_completion_timeout(&dev->dma_completion,
+						msecs_to_jiffies(SAHARA_TIMEOUT_MS));
 
 	if (rctx->sg_in_idx)
 		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 			     DMA_TO_DEVICE);
 
-	if (!timeout) {
+	if (!time_left) {
 		dev_err(dev->device, "SHA timeout\n");
 		return -ETIMEDOUT;
 	}
-- 
2.43.0

