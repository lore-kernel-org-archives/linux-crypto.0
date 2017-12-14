From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 07/17] crypto: inside-secure - move cipher crypto mode to request context
Date: Thu, 14 Dec 2017 15:26:49 +0100
Message-ID: <20171214142659.16987-8-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Ofer Heifetz <oferh@marvell.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36767 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753149AbdLNOaF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:05 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ofer Heifetz <oferh@marvell.com>

The cipher direction can be different for requests within the same
transformation context. This patch moves the direction flag from the
context to the request scope.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
[Antoine: commit message]
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 794849b859a7..62382a7c4cbe 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -27,7 +27,6 @@ struct safexcel_cipher_ctx {
 	struct safexcel_context base;
 	struct safexcel_crypto_priv *priv;
 
-	enum safexcel_cipher_direction direction;
 	u32 mode;
 
 	__le32 key[8];
@@ -35,6 +34,7 @@ struct safexcel_cipher_ctx {
 };
 
 struct safexcel_cipher_req {
+	enum safexcel_cipher_direction direction;
 	bool needs_inv;
 };
 
@@ -97,12 +97,15 @@ static int safexcel_aes_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 }
 
 static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
+				    struct crypto_async_request *async,
 				    struct safexcel_command_desc *cdesc)
 {
 	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct skcipher_request *req = skcipher_request_cast(async);
+	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
 	int ctrl_size;
 
-	if (ctx->direction == SAFEXCEL_ENCRYPT)
+	if (sreq->direction == SAFEXCEL_ENCRYPT)
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_OUT;
 	else
 		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_IN;
@@ -245,7 +248,7 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 		n_cdesc++;
 
 		if (n_cdesc == 1) {
-			safexcel_context_control(ctx, cdesc);
+			safexcel_context_control(ctx, async, cdesc);
 			safexcel_cipher_token(ctx, async, cdesc, req->cryptlen);
 		}
 
@@ -469,7 +472,7 @@ static int safexcel_aes(struct skcipher_request *req,
 	int ret, ring;
 
 	sreq->needs_inv = false;
-	ctx->direction = dir;
+	sreq->direction = dir;
 	ctx->mode = mode;
 
 	if (ctx->base.ctxr) {
-- 
2.14.3
