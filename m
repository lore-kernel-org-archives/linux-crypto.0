From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 4/5] crypto: caam: only export the state we really need to
 export
Date: Sat, 17 Oct 2015 19:51:38 +0100
Message-ID: <E1ZnWZu-0001nB-SG@rmk-PC.arm.linux.org.uk>
References: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43449 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbbJQSvr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 14:51:47 -0400
In-Reply-To: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Avoid exporting lots of state by only exporting what we really require,
which is the buffer containing the set of pending bytes to be hashed,
number of pending bytes, the context buffer, and the function pointer
state.  This reduces down the exported state size to 216 bytes from
576 bytes.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 44 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index dcee360065f3..7dd80b0b3f51 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -134,6 +134,15 @@ struct caam_hash_state {
 	int current_buf;
 };
 
+struct caam_export_state {
+	u8 buf[CAAM_MAX_HASH_BLOCK_SIZE];
+	u8 caam_ctx[MAX_CTX_LEN];
+	int buflen;
+	int (*update)(struct ahash_request *req);
+	int (*final)(struct ahash_request *req);
+	int (*finup)(struct ahash_request *req);
+};
+
 /* Common job descriptor seq in/out ptr routines */
 
 /* Map state->caam_ctx, and append seq_out_ptr command that points to it */
@@ -1574,20 +1583,41 @@ static int ahash_final(struct ahash_request *req)
 
 static int ahash_export(struct ahash_request *req, void *out)
 {
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_state *state = ahash_request_ctx(req);
+	struct caam_export_state *export = out;
+	int len;
+	u8 *buf;
 
-	memcpy(out, state, sizeof(struct caam_hash_state));
+	if (state->current_buf) {
+		buf = state->buf_1;
+		len = state->buflen_1;
+	} else {
+		buf = state->buf_0;
+		len = state->buflen_1;
+	}
+
+	memcpy(export->buf, buf, len);
+	memcpy(export->caam_ctx, state->caam_ctx, sizeof(export->caam_ctx));
+	export->buflen = len;
+	export->update = state->update;
+	export->final = state->final;
+	export->finup = state->finup;
 
 	return 0;
 }
 
 static int ahash_import(struct ahash_request *req, const void *in)
 {
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_state *state = ahash_request_ctx(req);
+	const struct caam_export_state *export = in;
 
-	memcpy(state, in, sizeof(struct caam_hash_state));
+	memset(state, 0, sizeof(*state));
+	memcpy(state->buf_0, export->buf, export->buflen);
+	memcpy(state->caam_ctx, export->caam_ctx, sizeof(state->caam_ctx));
+	state->buflen_0 = export->buflen;
+	state->update = export->update;
+	state->final = export->final;
+	state->finup = export->finup;
 
 	return 0;
 }
@@ -1622,6 +1652,7 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA1_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_export_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA1,
@@ -1643,6 +1674,7 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_export_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA224,
@@ -1664,6 +1696,7 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA256_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_export_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA256,
@@ -1685,6 +1718,7 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_export_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA384,
@@ -1706,6 +1740,7 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = SHA512_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_export_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_SHA512,
@@ -1727,6 +1762,7 @@ static struct caam_hash_template driver_hash[] = {
 			.setkey = ahash_setkey,
 			.halg = {
 				.digestsize = MD5_DIGEST_SIZE,
+				.statesize = sizeof(struct caam_export_state),
 				},
 			},
 		.alg_type = OP_ALG_ALGSEL_MD5,
-- 
2.1.0
