From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 3/6] crypto: ccp - Check for caller result area before using it
Date: Mon, 6 Jan 2014 13:34:11 -0600
Message-ID: <20140106193411.26918.88765.stgit@tlendack-t1.amdoffice.net>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

For a hash operation, the caller doesn't have to supply a result
area on every call so don't use it / update it if it hasn't
been supplied.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    4 +++-
 drivers/crypto/ccp/ccp-crypto-sha.c      |    7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 646c8d1..c6b8f9e 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -43,7 +43,9 @@ static int ccp_aes_cmac_complete(struct crypto_async_request *async_req,
 	} else
 		rctx->buf_count = 0;
 
-	memcpy(req->result, rctx->iv, digest_size);
+	/* Update result area if supplied */
+	if (req->result)
+		memcpy(req->result, rctx->iv, digest_size);
 
 e_free:
 	sg_free_table(&rctx->data_sg);
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index bf913cb..183d16e 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -74,6 +74,7 @@ static int ccp_sha_finish_hmac(struct crypto_async_request *async_req)
 	struct ahash_request *req = ahash_request_cast(async_req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ccp_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct scatterlist sg[2];
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
@@ -81,7 +82,7 @@ static int ccp_sha_finish_hmac(struct crypto_async_request *async_req)
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	sg_set_buf(&sg[0], ctx->u.sha.opad, block_size);
-	sg_set_buf(&sg[1], req->result, digest_size);
+	sg_set_buf(&sg[1], rctx->ctx, digest_size);
 
 	return ccp_sync_hash(ctx->u.sha.hmac_tfm, req->result, sg,
 			     block_size + digest_size);
@@ -106,7 +107,9 @@ static int ccp_sha_complete(struct crypto_async_request *async_req, int ret)
 	} else
 		rctx->buf_count = 0;
 
-	memcpy(req->result, rctx->ctx, digest_size);
+	/* Update result area if supplied */
+	if (req->result)
+		memcpy(req->result, rctx->ctx, digest_size);
 
 	/* If we're doing an HMAC, we need to perform that on the final op */
 	if (rctx->final && ctx->u.sha.key_len)
