From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 16/18] crypto: shash - Fix has_key setting
Date: Thu, 27 Oct 2016 17:29:49 +0300
Message-ID: <1477578591-28924-17-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0103.outbound.protection.outlook.com ([104.47.1.103]:13920
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933792AbcJ0SGP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 14:06:15 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 00420a65fa2beb3206090ead86942484df2275f3 upstream.

The has_key logic is wrong for shash algorithms as they always
have a setkey function.  So we should instead be testing against
shash_no_setkey.

Fixes: a5596d633278 ("crypto: hash - Add crypto_ahash_has_setkey")
Cc: stable@vger.kernel.org
Reported-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/shash.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 8e4256a..ac4d763 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -353,11 +353,10 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->final = shash_async_final;
 	crt->finup = shash_async_finup;
 	crt->digest = shash_async_digest;
+	crt->setkey = shash_async_setkey;
+
+	crt->has_setkey = alg->setkey != shash_no_setkey;
 
-	if (alg->setkey) {
-		crt->setkey = shash_async_setkey;
-		crt->has_setkey = true;
-	}
 	if (alg->export)
 		crt->export = shash_async_export;
 	if (alg->import)
-- 
2.7.3
