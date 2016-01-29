From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v2] crypto: atmel-sha: fix algorihtm registration
Date: Fri, 29 Jan 2016 17:04:02 +0100
Message-ID: <da09591cf85a1882817bbf7cb527bb228d3f8f87.1454082992.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implements the missing .import() and .export() mandatory
hooks for asynchronous hash algorithms. It also sets the relevant, non
zero, value for the .statesize field when declaring the supported SHA
algorithms. Indeed a zero value of .statesize prevents the algorithm from
being registered.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
ChangeLog

v2: deal with unaligned in/out pointers in atmel_sha_import/atmel_sha_export

 drivers/crypto/atmel-sha.c | 61 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index da4c3055784f..63b09e01075c 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -66,7 +66,7 @@
 #define SHA_OP_UPDATE	1
 #define SHA_OP_FINAL	2
 
-#define SHA_BUFFER_LEN		PAGE_SIZE
+#define SHA_BUFFER_LEN		(PAGE_SIZE / 16)
 
 #define ATMEL_SHA_DMA_THRESHOLD		56
 
@@ -80,6 +80,17 @@ struct atmel_sha_caps {
 
 struct atmel_sha_dev;
 
+/*
+ * .statesize = sizeof(struct atmel_sha_state) must be <= PAGE_SIZE / 8 as
+ * tested by the ahash_prepare_alg() function.
+ */
+struct atmel_sha_state {
+	u8	digest[SHA512_DIGEST_SIZE];
+	u8	buffer[SHA_BUFFER_LEN];
+	u64	digcnt[2];
+	size_t	bufcnt;
+};
+
 struct atmel_sha_reqctx {
 	struct atmel_sha_dev	*dd;
 	unsigned long	flags;
@@ -1033,6 +1044,39 @@ static int atmel_sha_digest(struct ahash_request *req)
 	return atmel_sha_init(req) ?: atmel_sha_finup(req);
 }
 
+
+static int atmel_sha_export(struct ahash_request *req, void *out)
+{
+	const struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct atmel_sha_state state;
+
+	memcpy(state.digest, ctx->digest, SHA512_DIGEST_SIZE);
+	memcpy(state.buffer, ctx->buffer, ctx->bufcnt);
+	state.bufcnt = ctx->bufcnt;
+	state.digcnt[0] = ctx->digcnt[0];
+	state.digcnt[1] = ctx->digcnt[1];
+
+	/* out might be unaligned. */
+	memcpy(out, &state, sizeof(state));
+	return 0;
+}
+
+static int atmel_sha_import(struct ahash_request *req, const void *in)
+{
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct atmel_sha_state state;
+
+	/* in might be unaligned. */
+	memcpy(&state, in, sizeof(state));
+
+	memcpy(ctx->digest, state.digest, SHA512_DIGEST_SIZE);
+	memcpy(ctx->buffer, state.buffer, state.bufcnt);
+	ctx->bufcnt = state.bufcnt;
+	ctx->digcnt[0] = state.digcnt[0];
+	ctx->digcnt[1] = state.digcnt[1];
+	return 0;
+}
+
 static int atmel_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
@@ -1049,8 +1093,11 @@ static struct ahash_alg sha_1_256_algs[] = {
 	.final		= atmel_sha_final,
 	.finup		= atmel_sha_finup,
 	.digest		= atmel_sha_digest,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA1_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_state),
 		.base	= {
 			.cra_name		= "sha1",
 			.cra_driver_name	= "atmel-sha1",
@@ -1070,8 +1117,11 @@ static struct ahash_alg sha_1_256_algs[] = {
 	.final		= atmel_sha_final,
 	.finup		= atmel_sha_finup,
 	.digest		= atmel_sha_digest,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA256_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_state),
 		.base	= {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "atmel-sha256",
@@ -1093,8 +1143,11 @@ static struct ahash_alg sha_224_alg = {
 	.final		= atmel_sha_final,
 	.finup		= atmel_sha_finup,
 	.digest		= atmel_sha_digest,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA224_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_state),
 		.base	= {
 			.cra_name		= "sha224",
 			.cra_driver_name	= "atmel-sha224",
@@ -1116,8 +1169,11 @@ static struct ahash_alg sha_384_512_algs[] = {
 	.final		= atmel_sha_final,
 	.finup		= atmel_sha_finup,
 	.digest		= atmel_sha_digest,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA384_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_state),
 		.base	= {
 			.cra_name		= "sha384",
 			.cra_driver_name	= "atmel-sha384",
@@ -1137,8 +1193,11 @@ static struct ahash_alg sha_384_512_algs[] = {
 	.final		= atmel_sha_final,
 	.finup		= atmel_sha_finup,
 	.digest		= atmel_sha_digest,
+	.export		= atmel_sha_export,
+	.import		= atmel_sha_import,
 	.halg = {
 		.digestsize	= SHA512_DIGEST_SIZE,
+		.statesize	= sizeof(struct atmel_sha_state),
 		.base	= {
 			.cra_name		= "sha512",
 			.cra_driver_name	= "atmel-sha512",
-- 
1.8.2.2
