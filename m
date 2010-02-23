From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 1/2] crypto: authenc - Use correct ahash complete functions
Date: Tue, 23 Feb 2010 07:21:09 +0100
Message-ID: <20100223062109.GD29013@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:55043 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab0BWGX6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2010 01:23:58 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We accidentally assigned the ahash update complete function to
the wrong function pointer in crypto_authenc_verify.
This patch fixes this.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/authenc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 1887090..6287cfd 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -454,7 +454,7 @@ static int crypto_authenc_verify(struct aead_request *req,
 	unsigned int authsize;
 
 	areq_ctx->complete = authenc_verify_ahash_done;
-	areq_ctx->complete = authenc_verify_ahash_update_done;
+	areq_ctx->update_complete = authenc_verify_ahash_update_done;
 
 	ohash = authenc_ahash_fn(req, CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (IS_ERR(ohash))
-- 
1.5.6.5

