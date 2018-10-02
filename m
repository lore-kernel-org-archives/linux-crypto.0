From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: [PATCH 1/3] crypto: mxs-dcp - Implement sha import/export
Date: Tue, 2 Oct 2018 19:01:48 +0000
Message-ID: <8c75f5c5dab117430313e0cfd4f2af88c9ed3d57.1538505573.git.leonard.crestez@nxp.com>
References: <cover.1538505573.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Douglass <dan.douglass@freescale.com>,
        Dan Douglass <dan.douglass@nxp.com>
To: Marek Vasut <marek.vasut@gmail.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538505573.git.leonard.crestez@nxp.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dan Douglass <dan.douglass@freescale.com>

The mxs-dcp driver fails to probe if sha1/sha256 are supported:

[    2.455404] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
[    2.464042] mxs-dcp: probe of 80028000.dcp failed with error -22

This happens because since commit 8996eafdcbad ("crypto: ahash - ensure
statesize is non-zero") import/export is mandatory and ahash_prepare_alg
fails on statesize =3D=3D 0.

A set of dummy import/export functions were implemented in commit
9190b6fd5db9 ("crypto: mxs-dcp - Add empty hash export and import") but
statesize is still zero and the driver fails to probe. That change was
apparently part of some unrelated refactoring.

Fix by actually implementing import/export.

Signed-off-by: Dan Douglass <dan.douglass@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
---
 drivers/crypto/mxs-dcp.c | 41 ++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 4b2b8129cf35..b7f41a6b65a5 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -99,10 +99,15 @@ struct dcp_aes_req_ctx {
 struct dcp_sha_req_ctx {
 	unsigned int	init:1;
 	unsigned int	fini:1;
 };
=20
+struct dcp_export_state {
+	struct dcp_sha_req_ctx req_ctx;
+	struct dcp_async_ctx async_ctx;
+};
+
 /*
  * There can even be only one instance of the MXS DCP due to the
  * design of Linux Crypto API.
  */
 static struct dcp *global_sdcp;
@@ -766,18 +771,36 @@ static int dcp_sha_digest(struct ahash_request *req)
 		return ret;
=20
 	return dcp_sha_finup(req);
 }
=20
-static int dcp_sha_noimport(struct ahash_request *req, const void *in)
+static int dcp_sha_import(struct ahash_request *req, const void *in)
 {
-	return -ENOSYS;
+	struct dcp_sha_req_ctx *rctx =3D ahash_request_ctx(req);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
+	struct dcp_async_ctx *actx =3D crypto_ahash_ctx(tfm);
+	const struct dcp_export_state *export =3D in;
+
+	memset(rctx, 0, sizeof(struct dcp_sha_req_ctx));
+	memset(actx, 0, sizeof(struct dcp_async_ctx));
+	memcpy(rctx, &export->req_ctx, sizeof(struct dcp_sha_req_ctx));
+	memcpy(actx, &export->async_ctx, sizeof(struct dcp_async_ctx));
+
+	return 0;
 }
=20
-static int dcp_sha_noexport(struct ahash_request *req, void *out)
+static int dcp_sha_export(struct ahash_request *req, void *out)
 {
-	return -ENOSYS;
+	struct dcp_sha_req_ctx *rctx_state =3D ahash_request_ctx(req);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
+	struct dcp_async_ctx *actx_state =3D crypto_ahash_ctx(tfm);
+	struct dcp_export_state *export =3D out;
+
+	memcpy(&export->req_ctx, rctx_state, sizeof(struct dcp_sha_req_ctx));
+	memcpy(&export->async_ctx, actx_state, sizeof(struct dcp_async_ctx));
+
+	return 0;
 }
=20
 static int dcp_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
@@ -846,14 +869,15 @@ static struct ahash_alg dcp_sha1_alg =3D {
 	.init	=3D dcp_sha_init,
 	.update	=3D dcp_sha_update,
 	.final	=3D dcp_sha_final,
 	.finup	=3D dcp_sha_finup,
 	.digest	=3D dcp_sha_digest,
-	.import =3D dcp_sha_noimport,
-	.export =3D dcp_sha_noexport,
+	.import =3D dcp_sha_import,
+	.export =3D dcp_sha_export,
 	.halg	=3D {
 		.digestsize	=3D SHA1_DIGEST_SIZE,
+		.statesize	=3D sizeof(struct dcp_export_state),
 		.base		=3D {
 			.cra_name		=3D "sha1",
 			.cra_driver_name	=3D "sha1-dcp",
 			.cra_priority		=3D 400,
 			.cra_alignmask		=3D 63,
@@ -872,14 +896,15 @@ static struct ahash_alg dcp_sha256_alg =3D {
 	.init	=3D dcp_sha_init,
 	.update	=3D dcp_sha_update,
 	.final	=3D dcp_sha_final,
 	.finup	=3D dcp_sha_finup,
 	.digest	=3D dcp_sha_digest,
-	.import =3D dcp_sha_noimport,
-	.export =3D dcp_sha_noexport,
+	.import =3D dcp_sha_import,
+	.export =3D dcp_sha_export,
 	.halg	=3D {
 		.digestsize	=3D SHA256_DIGEST_SIZE,
+		.statesize	=3D sizeof(struct dcp_export_state),
 		.base		=3D {
 			.cra_name		=3D "sha256",
 			.cra_driver_name	=3D "sha256-dcp",
 			.cra_priority		=3D 400,
 			.cra_alignmask		=3D 63,
--=20
2.17.1
