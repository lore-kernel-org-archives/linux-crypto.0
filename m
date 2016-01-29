From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1] crypto: ccp - Limit the amount of information exported
Date: Fri, 29 Jan 2016 12:45:14 -0600
Message-ID: <20160129184514.10863.45404.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, <stable@vger.kernel.org>,
	"David Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:42240
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932552AbcA2SpV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 13:45:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the exported information can be exposed to user-space, instead of
exporting the entire request context only export the minimum information
needed.

Cc: <stable@vger.kernel.org> # 3.14.x-
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   16 +++++++++++-----
 drivers/crypto/ccp/ccp-crypto-sha.c      |   20 +++++++++++++++-----
 drivers/crypto/ccp/ccp-crypto.h          |   22 ++++++++++++++++++++++
 3 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 00207cf..6a2d836 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -223,9 +223,12 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
 static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
 {
 	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
-	struct ccp_aes_cmac_req_ctx *state = out;
+	struct ccp_aes_cmac_exp_ctx *state = out;
 
-	*state = *rctx;
+	state->null_msg = rctx->null_msg;
+	memcpy(state->iv, rctx->iv, sizeof(state->iv));
+	state->buf_count = rctx->buf_count;
+	memcpy(state->buf, rctx->buf, sizeof(state->buf));
 
 	return 0;
 }
@@ -233,9 +236,12 @@ static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
 static int ccp_aes_cmac_import(struct ahash_request *req, const void *in)
 {
 	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
-	const struct ccp_aes_cmac_req_ctx *state = in;
+	const struct ccp_aes_cmac_exp_ctx *state = in;
 
-	*rctx = *state;
+	rctx->null_msg = state->null_msg;
+	memcpy(rctx->iv, state->iv, sizeof(rctx->iv));
+	rctx->buf_count = state->buf_count;
+	memcpy(rctx->buf, state->buf, sizeof(rctx->buf));
 
 	return 0;
 }
@@ -378,7 +384,7 @@ int ccp_register_aes_cmac_algs(struct list_head *head)
 
 	halg = &alg->halg;
 	halg->digestsize = AES_BLOCK_SIZE;
-	halg->statesize = sizeof(struct ccp_aes_cmac_req_ctx);
+	halg->statesize = sizeof(struct ccp_aes_cmac_exp_ctx);
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "cmac(aes)");
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 3aae58d..a67128a 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -210,9 +210,14 @@ static int ccp_sha_digest(struct ahash_request *req)
 static int ccp_sha_export(struct ahash_request *req, void *out)
 {
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct ccp_sha_req_ctx *state = out;
+	struct ccp_sha_exp_ctx *state = out;
 
-	*state = *rctx;
+	state->type = rctx->type;
+	state->msg_bits = rctx->msg_bits;
+	state->first = rctx->first;
+	memcpy(state->ctx, rctx->ctx, sizeof(state->ctx));
+	state->buf_count = rctx->buf_count;
+	memcpy(state->buf, rctx->buf, sizeof(state->buf));
 
 	return 0;
 }
@@ -220,9 +225,14 @@ static int ccp_sha_export(struct ahash_request *req, void *out)
 static int ccp_sha_import(struct ahash_request *req, const void *in)
 {
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	const struct ccp_sha_req_ctx *state = in;
+	const struct ccp_sha_exp_ctx *state = in;
 
-	*rctx = *state;
+	rctx->type = state->type;
+	rctx->msg_bits = state->msg_bits;
+	rctx->first = state->first;
+	memcpy(rctx->ctx, state->ctx, sizeof(rctx->ctx));
+	rctx->buf_count = state->buf_count;
+	memcpy(rctx->buf, state->buf, sizeof(rctx->buf));
 
 	return 0;
 }
@@ -428,7 +438,7 @@ static int ccp_register_sha_alg(struct list_head *head,
 
 	halg = &alg->halg;
 	halg->digestsize = def->digest_size;
-	halg->statesize = sizeof(struct ccp_sha_req_ctx);
+	halg->statesize = sizeof(struct ccp_sha_exp_ctx);
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 76a96f0..a326ec2 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -129,6 +129,15 @@ struct ccp_aes_cmac_req_ctx {
 	struct ccp_cmd cmd;
 };
 
+struct ccp_aes_cmac_exp_ctx {
+	unsigned int null_msg;
+
+	u8 iv[AES_BLOCK_SIZE];
+
+	unsigned int buf_count;
+	u8 buf[AES_BLOCK_SIZE];
+};
+
 /***** SHA related defines *****/
 #define MAX_SHA_CONTEXT_SIZE	SHA256_DIGEST_SIZE
 #define MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
@@ -171,6 +180,19 @@ struct ccp_sha_req_ctx {
 	struct ccp_cmd cmd;
 };
 
+struct ccp_sha_exp_ctx {
+	enum ccp_sha_type type;
+
+	u64 msg_bits;
+
+	unsigned int first;
+
+	u8 ctx[MAX_SHA_CONTEXT_SIZE];
+
+	unsigned int buf_count;
+	u8 buf[MAX_SHA_BLOCK_SIZE];
+};
+
 /***** Common Context Structure *****/
 struct ccp_ctx {
 	int (*complete)(struct crypto_async_request *req, int ret);
