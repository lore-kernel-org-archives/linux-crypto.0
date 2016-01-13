From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 1/3] crypto: sahara - avoid needlessly saving and restoring sahara_ctx
Date: Wed, 13 Jan 2016 15:52:02 -0200
Message-ID: <1452707524-7695-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, s.trumtrar@pengutronix.de, thomas.lendacky@amd.com,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f194.google.com ([209.85.160.194]:33201 "EHLO
	mail-yk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbcAMRwZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 12:52:25 -0500
Received: by mail-yk0-f194.google.com with SMTP id y10so29254972ykf.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2016 09:52:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

Based on commit 434b421241f2d0 ("crypto: caam - avoid needlessly saving and
restoring caam_hash_ctx") from Russell King.

When exporting and importing the hash state, we will only export and
import into hashes which share the same struct crypto_ahash pointer.
(See hash_accept->af_alg_accept->hash_accept_parent.)
    
This means that saving the sahara_ctx structure on export, and
restoring it on import is a waste of resources.  So, remove this code.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Changes since v1:
- Newly introduced in this series

 drivers/crypto/sahara.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index f68c24a..53c7a9a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1155,26 +1155,18 @@ static int sahara_sha_digest(struct ahash_request *req)
 
 static int sahara_sha_export(struct ahash_request *req, void *out)
 {
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct sahara_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
 
-	memcpy(out, ctx, sizeof(struct sahara_ctx));
-	memcpy(out + sizeof(struct sahara_sha_reqctx), rctx,
-	       sizeof(struct sahara_sha_reqctx));
+	memcpy(out, rctx, sizeof(struct sahara_sha_reqctx));
 
 	return 0;
 }
 
 static int sahara_sha_import(struct ahash_request *req, const void *in)
 {
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct sahara_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
 
-	memcpy(ctx, in, sizeof(struct sahara_ctx));
-	memcpy(rctx, in + sizeof(struct sahara_sha_reqctx),
-	       sizeof(struct sahara_sha_reqctx));
+	memcpy(rctx, in, sizeof(struct sahara_sha_reqctx));
 
 	return 0;
 }
-- 
1.9.1
