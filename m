From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1] crypto: ccp - Don't assume export/import areas are
 aligned
Date: Tue, 2 Feb 2016 11:38:21 -0600
Message-ID: <20160202173821.9736.99927.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, <stable@vger.kernel.org>,
	"David Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use a local variable for the exported and imported state so that
alignment is not an issue. On export, set a local variable from the
request context and then memcpy the contents of the local variable to
the export memory area. On import, memcpy the import memory area into
a local variable and then use the local variable to set the request
context.

Cc: <stable@vger.kernel.org> # 3.14.x-
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   26 +++++++++++++---------
 drivers/crypto/ccp/ccp-crypto-sha.c      |   36 ++++++++++++++++++------------
 2 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 6a2d836..d095452 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -223,12 +223,15 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
 static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
 {
 	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
-	struct ccp_aes_cmac_exp_ctx *state = out;
+	struct ccp_aes_cmac_exp_ctx state;
 
-	state->null_msg = rctx->null_msg;
-	memcpy(state->iv, rctx->iv, sizeof(state->iv));
-	state->buf_count = rctx->buf_count;
-	memcpy(state->buf, rctx->buf, sizeof(state->buf));
+	state.null_msg = rctx->null_msg;
+	memcpy(state.iv, rctx->iv, sizeof(state.iv));
+	state.buf_count = rctx->buf_count;
+	memcpy(state.buf, rctx->buf, sizeof(state.buf));
+
+	/* 'out' may not be aligned so memcpy from local variable */
+	memcpy(out, &state, sizeof(state));
 
 	return 0;
 }
@@ -236,12 +239,15 @@ static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
 static int ccp_aes_cmac_import(struct ahash_request *req, const void *in)
 {
 	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
-	const struct ccp_aes_cmac_exp_ctx *state = in;
+	struct ccp_aes_cmac_exp_ctx state;
+
+	/* 'in' may not be aligned so memcpy to local variable */
+	memcpy(&state, in, sizeof(state));
 
-	rctx->null_msg = state->null_msg;
-	memcpy(rctx->iv, state->iv, sizeof(rctx->iv));
-	rctx->buf_count = state->buf_count;
-	memcpy(rctx->buf, state->buf, sizeof(rctx->buf));
+	rctx->null_msg = state.null_msg;
+	memcpy(rctx->iv, state.iv, sizeof(rctx->iv));
+	rctx->buf_count = state.buf_count;
+	memcpy(rctx->buf, state.buf, sizeof(rctx->buf));
 
 	return 0;
 }
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index a67128a..7002c6b 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -210,14 +210,17 @@ static int ccp_sha_digest(struct ahash_request *req)
 static int ccp_sha_export(struct ahash_request *req, void *out)
 {
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct ccp_sha_exp_ctx *state = out;
+	struct ccp_sha_exp_ctx state;
 
-	state->type = rctx->type;
-	state->msg_bits = rctx->msg_bits;
-	state->first = rctx->first;
-	memcpy(state->ctx, rctx->ctx, sizeof(state->ctx));
-	state->buf_count = rctx->buf_count;
-	memcpy(state->buf, rctx->buf, sizeof(state->buf));
+	state.type = rctx->type;
+	state.msg_bits = rctx->msg_bits;
+	state.first = rctx->first;
+	memcpy(state.ctx, rctx->ctx, sizeof(state.ctx));
+	state.buf_count = rctx->buf_count;
+	memcpy(state.buf, rctx->buf, sizeof(state.buf));
+
+	/* 'out' may not be aligned so memcpy from local variable */
+	memcpy(out, &state, sizeof(state));
 
 	return 0;
 }
@@ -225,14 +228,17 @@ static int ccp_sha_export(struct ahash_request *req, void *out)
 static int ccp_sha_import(struct ahash_request *req, const void *in)
 {
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	const struct ccp_sha_exp_ctx *state = in;
-
-	rctx->type = state->type;
-	rctx->msg_bits = state->msg_bits;
-	rctx->first = state->first;
-	memcpy(rctx->ctx, state->ctx, sizeof(rctx->ctx));
-	rctx->buf_count = state->buf_count;
-	memcpy(rctx->buf, state->buf, sizeof(rctx->buf));
+	struct ccp_sha_exp_ctx state;
+
+	/* 'in' may not be aligned so memcpy to local variable */
+	memcpy(&state, in, sizeof(state));
+
+	rctx->type = state.type;
+	rctx->msg_bits = state.msg_bits;
+	rctx->first = state.first;
+	memcpy(rctx->ctx, state.ctx, sizeof(rctx->ctx));
+	rctx->buf_count = state.buf_count;
+	memcpy(rctx->buf, state.buf, sizeof(rctx->buf));
 
 	return 0;
 }
