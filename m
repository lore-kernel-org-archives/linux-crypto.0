Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50774 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbfAONnv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 08:43:51 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] crypto: ccree: don't copy zero size ciphertext
Date: Tue, 15 Jan 2019 15:43:17 +0200
Message-Id: <20190115134318.28712-8-gilad@benyossef.com>
In-Reply-To: <20190115134318.28712-1-gilad@benyossef.com>
References: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For decryption in CBC mode we need to save the last ciphertext block
for use as the next IV. However, we were trying to do this also with
zero sized ciphertext resulting in a panic.

Fix this by only doing the copy if the ciphertext length is at least
of IV size.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org
---
 drivers/crypto/ccree/cc_cipher.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 98ea53524250..e202d7c7ea00 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -800,7 +800,8 @@ static int cc_cipher_decrypt(struct skcipher_request *req)
 
 	memset(req_ctx, 0, sizeof(*req_ctx));
 
-	if (ctx_p->cipher_mode == DRV_CIPHER_CBC) {
+	if ((ctx_p->cipher_mode == DRV_CIPHER_CBC) &&
+	    (req->cryptlen >= ivsize)) {
 
 		/* Allocate and save the last IV sized bytes of the source,
 		 * which will be lost in case of in-place decryption.
-- 
2.20.1
