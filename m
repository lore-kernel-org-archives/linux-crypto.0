From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 17/18] crypto: cryptd - initialize child shash_desc on import
Date: Thu, 27 Oct 2016 17:29:50 +0300
Message-ID: <1477578591-28924-18-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0136.outbound.protection.outlook.com ([104.47.2.136]:21312
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S943175AbcJ1BIb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 21:08:31 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 0bd2223594a4dcddc1e34b15774a3a4776f7749e upstream.

When calling .import() on a cryptd ahash_request, the structure members
that describe the child transform in the shash_desc need to be initialized
like they are when calling .init()

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/cryptd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 75c415d..d85fab9 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -565,9 +565,14 @@ static int cryptd_hash_export(struct ahash_request *req, void *out)
 
 static int cryptd_hash_import(struct ahash_request *req, const void *in)
 {
-	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct shash_desc *desc = cryptd_shash_desc(req);
+
+	desc->tfm = ctx->child;
+	desc->flags = req->base.flags;
 
-	return crypto_shash_import(&rctx->desc, in);
+	return crypto_shash_import(desc, in);
 }
 
 static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
-- 
2.7.3
