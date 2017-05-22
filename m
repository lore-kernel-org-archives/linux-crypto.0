From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] crypto: rng: Remove unused function __crypto_rng_cast()
Date: Mon, 22 May 2017 15:49:43 -0700
Message-ID: <20170522224943.176039-1-mka@chromium.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
To: Neil Horman <nhorman@tuxdriver.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:32916 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757976AbdEVWuO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 18:50:14 -0400
Received: by mail-pf0-f175.google.com with SMTP id e193so95397705pfh.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 May 2017 15:50:14 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This fixes the following warning when building with clang:

crypto/rng.c:35:34: error: unused function '__crypto_rng_cast'
    [-Werror,-Wunused-function]

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 crypto/rng.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index f46dac5288b9..5e8469244960 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -33,11 +33,6 @@ struct crypto_rng *crypto_default_rng;
 EXPORT_SYMBOL_GPL(crypto_default_rng);
 static int crypto_default_rng_refcnt;
 
-static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
-{
-	return container_of(tfm, struct crypto_rng, base);
-}
-
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
-- 
2.13.0.303.g4ebf302169-goog
