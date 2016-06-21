From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/5] crypto: ablk_helper - Fix cryptd reordering
Date: Tue, 21 Jun 2016 16:55:15 +0800
Message-ID: <E1bFHSl-0005VS-L3@gondolin.me.apana.org.au>
References: <20160621085321.GA21044@gondor.apana.org.au>
To: Raj Ammanur <rammanur@arista.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33571 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbcFUIzZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 04:55:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes an old bug where requests can be reordered because
some are processed by cryptd while others are processed directly
in softirq context.

The fix is to always postpone to cryptd if there are currently
requests outstanding from the same tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablk_helper.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/ablk_helper.c b/crypto/ablk_helper.c
index e1fcf53..1441f07 100644
--- a/crypto/ablk_helper.c
+++ b/crypto/ablk_helper.c
@@ -71,7 +71,8 @@ int ablk_encrypt(struct ablkcipher_request *req)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (!may_use_simd()) {
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_ablkcipher_queued(ctx->cryptd_tfm))) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 
@@ -90,7 +91,8 @@ int ablk_decrypt(struct ablkcipher_request *req)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (!may_use_simd()) {
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_ablkcipher_queued(ctx->cryptd_tfm))) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 
