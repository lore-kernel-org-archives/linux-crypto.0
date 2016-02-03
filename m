From: Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH v3 2/3] crypto: sahara - avoid needlessly saving and restoring sahara_ctx
Date: Wed, 3 Feb 2016 10:46:51 -0200
Message-ID: <1454503612-21344-2-git-send-email-fabio.estevam@nxp.com>
References: <1454503612-21344-1-git-send-email-fabio.estevam@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <s.trumtrar@pengutronix.de>, <marex@denx.de>,
	<linux@arm.linux.org.uk>, <linux-crypto@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0057.outbound.protection.outlook.com ([207.46.100.57]:22592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751237AbcBCNUJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 08:20:09 -0500
In-Reply-To: <1454503612-21344-1-git-send-email-fabio.estevam@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Based on commit 434b421241f2d0 ("crypto: caam - avoid needlessly saving and
restoring caam_hash_ctx") from Russell King.

When exporting and importing the hash state, we will only export and
import into hashes which share the same struct crypto_ahash pointer.
(See hash_accept->af_alg_accept->hash_accept_parent.)

This means that saving the sahara_ctx structure on export, and
restoring it on import is a waste of resources.  So, remove this code.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/crypto/sahara.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 7e8147d..9db09b6 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1162,26 +1162,18 @@ static int sahara_sha_digest(struct ahash_request *req)
 
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
