From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/2] crypto: atmel-sha - fix .import()/.export() implementation
Date: Mon, 8 Feb 2016 16:26:48 +0100
Message-ID: <f5ccc62efa50b810996632b2a584e9f8a192d3b1.1454944687.git.cyrille.pitchen@atmel.com>
References: <cover.1454944687.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454944687.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Using only the digest, digcnt[], bufcnt and buffer[] fields of the
struct atmel_sha_reqctx was not enough to import/export the request state,
so now we use the whole structure.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 44 ++++++++++----------------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index f8407dc7dd38..7d27f96cdf02 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -81,16 +81,9 @@ struct atmel_sha_caps {
 struct atmel_sha_dev;
 
 /*
- * .statesize = sizeof(struct atmel_sha_state) must be <= PAGE_SIZE / 8 as
+ * .statesize = sizeof(struct atmel_sha_reqctx) must be <= PAGE_SIZE / 8 as
  * tested by the ahash_prepare_alg() function.
  */
-struct atmel_sha_state {
-	u8	digest[SHA512_DIGEST_SIZE];
-	u8	buffer[SHA_BUFFER_LEN];
-	u64	digcnt[2];
-	size_t	bufcnt;
-};
-
 struct atmel_sha_reqctx {
 	struct atmel_sha_dev	*dd;
 	unsigned long	flags;
@@ -109,7 +102,7 @@ struct atmel_sha_reqctx {
 
 	size_t block_size;
 
-	u8	buffer[0] __aligned(sizeof(u32));
+	u8 buffer[SHA_BUFFER_LEN + SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
 };
 
 struct atmel_sha_ctx {
@@ -1048,40 +1041,23 @@ static int atmel_sha_digest(struct ahash_request *req)
 static int atmel_sha_export(struct ahash_request *req, void *out)
 {
 	const struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
-	struct atmel_sha_state state;
-
-	memcpy(state.digest, ctx->digest, SHA512_DIGEST_SIZE);
-	memcpy(state.buffer, ctx->buffer, ctx->bufcnt);
-	state.bufcnt = ctx->bufcnt;
-	state.digcnt[0] = ctx->digcnt[0];
-	state.digcnt[1] = ctx->digcnt[1];
 
-	/* out might be unaligned. */
-	memcpy(out, &state, sizeof(state));
+	memcpy(out, ctx, sizeof(*ctx));
 	return 0;
 }
 
 static int atmel_sha_import(struct ahash_request *req, const void *in)
 {
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
-	struct atmel_sha_state state;
-
-	/* in might be unaligned. */
-	memcpy(&state, in, sizeof(state));
 
-	memcpy(ctx->digest, state.digest, SHA512_DIGEST_SIZE);
-	memcpy(ctx->buffer, state.buffer, state.bufcnt);
-	ctx->bufcnt = state.bufcnt;
-	ctx->digcnt[0] = state.digcnt[0];
-	ctx->digcnt[1] = state.digcnt[1];
+	memcpy(ctx, in, sizeof(*ctx));
 	return 0;
 }
 
 static int atmel_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct atmel_sha_reqctx) +
-				 SHA_BUFFER_LEN + SHA512_BLOCK_SIZE);
+				 sizeof(struct atmel_sha_reqctx));
 
 	return 0;
 }
@@ -1097,7 +1073,7 @@ static struct ahash_alg sha_1_256_algs[] = {
 	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA1_DIGEST_SIZE,
-		.statesize	= sizeof(struct atmel_sha_state),
+		.statesize	= sizeof(struct atmel_sha_reqctx),
 		.base	= {
 			.cra_name		= "sha1",
 			.cra_driver_name	= "atmel-sha1",
@@ -1121,7 +1097,7 @@ static struct ahash_alg sha_1_256_algs[] = {
 	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA256_DIGEST_SIZE,
-		.statesize	= sizeof(struct atmel_sha_state),
+		.statesize	= sizeof(struct atmel_sha_reqctx),
 		.base	= {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "atmel-sha256",
@@ -1147,7 +1123,7 @@ static struct ahash_alg sha_224_alg = {
 	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA224_DIGEST_SIZE,
-		.statesize	= sizeof(struct atmel_sha_state),
+		.statesize	= sizeof(struct atmel_sha_reqctx),
 		.base	= {
 			.cra_name		= "sha224",
 			.cra_driver_name	= "atmel-sha224",
@@ -1173,7 +1149,7 @@ static struct ahash_alg sha_384_512_algs[] = {
 	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA384_DIGEST_SIZE,
-		.statesize	= sizeof(struct atmel_sha_state),
+		.statesize	= sizeof(struct atmel_sha_reqctx),
 		.base	= {
 			.cra_name		= "sha384",
 			.cra_driver_name	= "atmel-sha384",
@@ -1197,7 +1173,7 @@ static struct ahash_alg sha_384_512_algs[] = {
 	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA512_DIGEST_SIZE,
-		.statesize	= sizeof(struct atmel_sha_state),
+		.statesize	= sizeof(struct atmel_sha_reqctx),
 		.base	= {
 			.cra_name		= "sha512",
 			.cra_driver_name	= "atmel-sha512",
-- 
1.8.2.2
