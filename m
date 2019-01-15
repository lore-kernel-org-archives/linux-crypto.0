Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50760 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729901AbfAONnq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 08:43:46 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] crypto: ccree: unmap buffer before copying IV
Date: Tue, 15 Jan 2019 15:43:15 +0200
Message-Id: <20190115134318.28712-6-gilad@benyossef.com>
In-Reply-To: <20190115134318.28712-1-gilad@benyossef.com>
References: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We were copying the last ciphertext block into the IV field
for CBC before removing the DMA mapping of the output buffer
with the result of the buffer sometime being out-of-sync cache
wise and were getting intermittent cases of bad output IV.

Fix it by moving the DMA buffer unmapping before the copy.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: 00904aa0cd59 ("crypto: ccree - fix iv handling")
Cc: <stable@vger.kernel.org>
---
 drivers/crypto/ccree/cc_cipher.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index cc92b031fad1..98ea53524250 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -652,6 +652,8 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 	unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
 	unsigned int len;
 
+	cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
+
 	switch (ctx_p->cipher_mode) {
 	case DRV_CIPHER_CBC:
 		/*
@@ -681,7 +683,6 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 		break;
 	}
 
-	cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
 	kzfree(req_ctx->iv);
 
 	skcipher_request_complete(req, err);
-- 
2.20.1
