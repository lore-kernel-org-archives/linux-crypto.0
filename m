From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: talitos - fix ahash algorithms registration
Date: Thu, 21 Apr 2016 19:24:55 +0300
Message-ID: <1461255895-13150-1-git-send-email-horia.geanta@nxp.com>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, Jonas Eymann <J.Eymann@gmx.net>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:32768
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059AbcDUQZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Apr 2016 12:25:17 -0400
In-Reply-To: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Provide hardware state import/export functionality, as mandated by
commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")

Cc: <stable@vger.kernel.org> # 4.3+
Reported-by: Jonas Eymann <J.Eymann@gmx.net>
Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 drivers/crypto/talitos.c | 64 ++++++++++++++++++++++++++++++++++++++++=
++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index aae05547b924..b7ee8d30147d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -835,6 +835,16 @@ struct talitos_ahash_req_ctx {
 	struct scatterlist *psrc;
 };
=20
+struct talitos_export_state {
+	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
+	u8 buf[HASH_MAX_BLOCK_SIZE];
+	unsigned int swinit;
+	unsigned int first;
+	unsigned int last;
+	unsigned int to_hash_later;
+	unsigned int nbuf;
+};
+
 static int aead_setkey(struct crypto_aead *authenc,
 		       const u8 *key, unsigned int keylen)
 {
@@ -1981,6 +1991,46 @@ static int ahash_digest(struct ahash_request *ar=
eq)
 	return ahash_process_req(areq, areq->nbytes);
 }
=20
+static int ahash_export(struct ahash_request *areq, void *out)
+{
+	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
+	struct talitos_export_state *export =3D out;
+
+	memcpy(export->hw_context, req_ctx->hw_context,
+	       req_ctx->hw_context_size);
+	memcpy(export->buf, req_ctx->buf, req_ctx->nbuf);
+	export->swinit =3D req_ctx->swinit;
+	export->first =3D req_ctx->first;
+	export->last =3D req_ctx->last;
+	export->to_hash_later =3D req_ctx->to_hash_later;
+	export->nbuf =3D req_ctx->nbuf;
+
+	return 0;
+}
+
+static int ahash_import(struct ahash_request *areq, const void *in)
+{
+	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
+	const struct talitos_export_state *export =3D in;
+
+	memset(req_ctx, 0, sizeof(*req_ctx));
+	req_ctx->hw_context_size =3D
+		(crypto_ahash_digestsize(tfm) <=3D SHA256_DIGEST_SIZE)
+			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
+			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+	memcpy(req_ctx->hw_context, export->hw_context,
+	       req_ctx->hw_context_size);
+	memcpy(req_ctx->buf, export->buf, export->nbuf);
+	req_ctx->swinit =3D export->swinit;
+	req_ctx->first =3D export->first;
+	req_ctx->last =3D export->last;
+	req_ctx->to_hash_later =3D export->to_hash_later;
+	req_ctx->nbuf =3D export->nbuf;
+
+	return 0;
+}
+
 struct keyhash_result {
 	struct completion completion;
 	int err;
@@ -2458,6 +2508,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D MD5_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "md5",
 				.cra_driver_name =3D "md5-talitos",
@@ -2473,6 +2524,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA1_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "sha1",
 				.cra_driver_name =3D "sha1-talitos",
@@ -2488,6 +2540,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA224_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "sha224",
 				.cra_driver_name =3D "sha224-talitos",
@@ -2503,6 +2556,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA256_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "sha256",
 				.cra_driver_name =3D "sha256-talitos",
@@ -2518,6 +2572,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA384_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "sha384",
 				.cra_driver_name =3D "sha384-talitos",
@@ -2533,6 +2588,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA512_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "sha512",
 				.cra_driver_name =3D "sha512-talitos",
@@ -2548,6 +2604,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D MD5_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "hmac(md5)",
 				.cra_driver_name =3D "hmac-md5-talitos",
@@ -2563,6 +2620,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA1_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "hmac(sha1)",
 				.cra_driver_name =3D "hmac-sha1-talitos",
@@ -2578,6 +2636,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA224_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "hmac(sha224)",
 				.cra_driver_name =3D "hmac-sha224-talitos",
@@ -2593,6 +2652,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA256_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "hmac(sha256)",
 				.cra_driver_name =3D "hmac-sha256-talitos",
@@ -2608,6 +2668,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA384_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "hmac(sha384)",
 				.cra_driver_name =3D "hmac-sha384-talitos",
@@ -2623,6 +2684,7 @@ static struct talitos_alg_template driver_algs[] =
=3D {
 	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash =3D {
 			.halg.digestsize =3D SHA512_DIGEST_SIZE,
+			.halg.statesize =3D sizeof(struct talitos_export_state),
 			.halg.base =3D {
 				.cra_name =3D "hmac(sha512)",
 				.cra_driver_name =3D "hmac-sha512-talitos",
@@ -2814,6 +2876,8 @@ static struct talitos_crypto_alg *talitos_alg_all=
oc(struct device *dev,
 		t_alg->algt.alg.hash.finup =3D ahash_finup;
 		t_alg->algt.alg.hash.digest =3D ahash_digest;
 		t_alg->algt.alg.hash.setkey =3D ahash_setkey;
+		t_alg->algt.alg.hash.import =3D ahash_import;
+		t_alg->algt.alg.hash.export =3D ahash_export;
=20
 		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
 		    !strncmp(alg->cra_name, "hmac", 4)) {
--=20
2.4.4
