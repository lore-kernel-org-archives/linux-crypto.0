From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 3/3] crypto: cryptd - initialize child shash_desc on import
Date: Thu,  1 Sep 2016 14:25:43 +0100
Message-ID: <1472736343-15305-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35843 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754953AbcIAN1V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 09:27:21 -0400
Received: by mail-wm0-f45.google.com with SMTP id c133so78461736wmd.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2016 06:27:20 -0700 (PDT)
In-Reply-To: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When calling .import() on a cryptd ahash_request, the structure members
that describe the child transform in the shash_desc need to be initialized
like they are when calling .init()

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/cryptd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index cf8037a87b2d..510a25f6ee37 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -631,9 +631,14 @@ static int cryptd_hash_export(struct ahash_request *req, void *out)
 
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
2.7.4
