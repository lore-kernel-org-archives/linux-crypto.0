From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 08/17] crypto: inside-secure - remove unused parameter in invalidate_cache
Date: Thu, 14 Dec 2017 15:26:50 +0100
Message-ID: <20171214142659.16987-9-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Ofer Heifetz <oferh@marvell.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36784 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbdLNOaG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:06 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ofer Heifetz <oferh@marvell.com>

The SafeXcel context isn't used in the cache invalidation function. This
cosmetic patch removes it (as well as from the function prototype in the
header file and when the function is called).

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
[Antoine: commit message]
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c        | 1 -
 drivers/crypto/inside-secure/safexcel.h        | 1 -
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 drivers/crypto/inside-secure/safexcel_hash.c   | 2 +-
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4bcef78a08aa..f250c3c1ab0f 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -540,7 +540,6 @@ void safexcel_inv_complete(struct crypto_async_request *req, int error)
 }
 
 int safexcel_invalidate_cache(struct crypto_async_request *async,
-			      struct safexcel_context *ctx,
 			      struct safexcel_crypto_priv *priv,
 			      dma_addr_t ctxr_dma, int ring,
 			      struct safexcel_request *request)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 304c5838c11a..d12c2b479a5e 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -539,7 +539,6 @@ void safexcel_free_context(struct safexcel_crypto_priv *priv,
 				  struct crypto_async_request *req,
 				  int result_sz);
 int safexcel_invalidate_cache(struct crypto_async_request *async,
-			      struct safexcel_context *ctx,
 			      struct safexcel_crypto_priv *priv,
 			      dma_addr_t ctxr_dma, int ring,
 			      struct safexcel_request *request);
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 62382a7c4cbe..fe1d588d6a25 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -395,7 +395,7 @@ static int safexcel_cipher_send_inv(struct crypto_async_request *async,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ret;
 
-	ret = safexcel_invalidate_cache(async, &ctx->base, priv,
+	ret = safexcel_invalidate_cache(async, priv,
 					ctx->base.ctxr_dma, ring, request);
 	if (unlikely(ret))
 		return ret;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 4a4d95302a93..d233f4a09712 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -417,7 +417,7 @@ static int safexcel_ahash_send_inv(struct crypto_async_request *async,
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	int ret;
 
-	ret = safexcel_invalidate_cache(async, &ctx->base, ctx->priv,
+	ret = safexcel_invalidate_cache(async, ctx->priv,
 					ctx->base.ctxr_dma, ring, request);
 	if (unlikely(ret))
 		return ret;
-- 
2.14.3
