From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 05/17] crypto: inside-secure - refrain from unneeded invalidations
Date: Thu, 14 Dec 2017 15:26:47 +0100
Message-ID: <20171214142659.16987-6-antoine.tenart@free-electrons.com>
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
        with ESMTP id S1753168AbdLNOaI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:08 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ofer Heifetz <oferh@marvell.com>

The check to know if an invalidation is needed (i.e. when the context
changes) is done even if the context does not exist yet. This happens
when first setting a key for ciphers and/or hmac operations.

This commits adds a check in the _setkey functions to only check if an
invalidation is needed when a context exists, as there is no need to
perform this check otherwise.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
[Antoine: commit message and added a comment and reworked one of the
checks]
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 10 ++++++----
 drivers/crypto/inside-secure/safexcel_hash.c   | 24 ++++++++++++++++--------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index fcc0a606d748..794849b859a7 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -78,10 +78,12 @@ static int safexcel_aes_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 		return ret;
 	}
 
-	for (i = 0; i < len / sizeof(u32); i++) {
-		if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
-			ctx->base.needs_inv = true;
-			break;
+	if (ctx->base.ctxr_dma) {
+		for (i = 0; i < len / sizeof(u32); i++) {
+			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+				ctx->base.needs_inv = true;
+				break;
+			}
 		}
 	}
 
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index e53e6b2331db..d156637d6144 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -527,10 +527,16 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 
 	req->needs_inv = false;
 
-	if (req->processed && ctx->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED)
-		ctx->base.needs_inv = safexcel_ahash_needs_inv_get(areq);
-
 	if (ctx->base.ctxr) {
+		if (!ctx->base.needs_inv && req->processed &&
+		    ctx->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED)
+			/* We're still setting needs_inv here, even though it is
+			 * cleared right away, because the needs_inv flag can be
+			 * set in other functions and we want to keep the same
+			 * logic.
+			 */
+			ctx->base.needs_inv = safexcel_ahash_needs_inv_get(areq);
+
 		if (ctx->base.needs_inv) {
 			ctx->base.needs_inv = false;
 			req->needs_inv = true;
@@ -928,11 +934,13 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (ret)
 		return ret;
 
-	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++) {
-		if (ctx->ipad[i] != le32_to_cpu(istate.state[i]) ||
-		    ctx->opad[i] != le32_to_cpu(ostate.state[i])) {
-			ctx->base.needs_inv = true;
-			break;
+	if (ctx->base.ctxr) {
+		for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++) {
+			if (ctx->ipad[i] != le32_to_cpu(istate.state[i]) ||
+			    ctx->opad[i] != le32_to_cpu(ostate.state[i])) {
+				ctx->base.needs_inv = true;
+				break;
+			}
 		}
 	}
 
-- 
2.14.3
