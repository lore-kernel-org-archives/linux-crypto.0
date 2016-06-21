From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/5] crypto: ghash-clmulni - Fix cryptd reordering
Date: Tue, 21 Jun 2016 16:55:16 +0800
Message-ID: <E1bFHSm-0005Vj-Qm@gondolin.me.apana.org.au>
References: <20160621085321.GA21044@gondor.apana.org.au>
To: Raj Ammanur <rammanur@arista.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46965 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbcFUIzX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 04:55:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes an old bug where requests can be reordered because
some are processed by cryptd while others are processed directly
in softirq context.

The fix is to always postpone to cryptd if there are currently
requests outstanding from the same tfm.

This patch also removes the redundant use of cryptd in the async
init function as init never touches the FPU.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/ghash-clmulni-intel_glue.c |   40 ++++++++++++-----------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index a69321a..0420bab 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -168,30 +168,23 @@ static int ghash_async_init(struct ahash_request *req)
 	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
 	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
 
-	if (!irq_fpu_usable()) {
-		memcpy(cryptd_req, req, sizeof(*req));
-		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
-		return crypto_ahash_init(cryptd_req);
-	} else {
-		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-		struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
-
-		desc->tfm = child;
-		desc->flags = req->base.flags;
-		return crypto_shash_init(desc);
-	}
+	desc->tfm = child;
+	desc->flags = req->base.flags;
+	return crypto_shash_init(desc);
 }
 
 static int ghash_async_update(struct ahash_request *req)
 {
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (!irq_fpu_usable()) {
-		struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-		struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-		struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
+	if (!irq_fpu_usable() ||
+	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
 		return crypto_ahash_update(cryptd_req);
@@ -204,12 +197,12 @@ static int ghash_async_update(struct ahash_request *req)
 static int ghash_async_final(struct ahash_request *req)
 {
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (!irq_fpu_usable()) {
-		struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-		struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-		struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
+	if (!irq_fpu_usable() ||
+	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
 		return crypto_ahash_final(cryptd_req);
@@ -249,7 +242,8 @@ static int ghash_async_digest(struct ahash_request *req)
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
 	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (!irq_fpu_usable()) {
+	if (!irq_fpu_usable() ||
+	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
 		return crypto_ahash_digest(cryptd_req);
