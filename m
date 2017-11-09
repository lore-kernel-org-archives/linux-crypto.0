From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: chelsio: remove redundant assignments to reqctx and dst_size
Date: Thu,  9 Nov 2017 08:54:13 +0000
Message-ID: <20171109085413.4336-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49252 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753451AbdKIIyW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 03:54:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer reqctx is assigned the same value twice, once on initialization
and again a few statements later, remove the second redundant assignment.
Variable dst_size is assigned but it is never read, so the variable is
redundant and can be removed. Cleans up clang warnings:

drivers/crypto/chelsio/chcr_algo.c:156:29: warning: Value stored to
'reqctx' during its initialization is never read
drivers/crypto/chelsio/chcr_algo.c:2020:2: warning: Value stored to
'dst_size' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 4eed7171e2ae..300e66fe8a3c 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -160,7 +160,6 @@ static inline void chcr_handle_ahash_resp(struct ahash_request *req,
 
 	if (input == NULL)
 		goto out;
-	reqctx = ahash_request_ctx(req);
 	digestsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
 	if (reqctx->is_sg_map)
 		chcr_hash_dma_unmap(&u_ctx->lldi.pdev->dev, req);
@@ -2014,11 +2013,8 @@ static int chcr_aead_common_init(struct aead_request *req,
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(a_ctx(tfm));
 	struct chcr_aead_reqctx  *reqctx = aead_request_ctx(req);
 	int error = -EINVAL;
-	unsigned int dst_size;
 	unsigned int authsize = crypto_aead_authsize(tfm);
 
-	dst_size = req->assoclen + req->cryptlen + (op_type ?
-					-authsize : authsize);
 	/* validate key size */
 	if (aeadctx->enckey_len == 0)
 		goto err;
-- 
2.14.1
