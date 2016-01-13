From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 3/3] crypto: mxs-dcp - provide statesize and import/export()
Date: Wed, 13 Jan 2016 15:52:04 -0200
Message-ID: <1452707524-7695-3-git-send-email-festevam@gmail.com>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, s.trumtrar@pengutronix.de, thomas.lendacky@amd.com,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:36002 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbcAMRw3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 12:52:29 -0500
Received: by mail-yk0-f195.google.com with SMTP id k129so37530069yke.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2016 09:52:29 -0800 (PST)
In-Reply-To: <1452707524-7695-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

Currently the mxs-dcp driver fails to probe:

mxs-dcp 80028000.dcp: Failed to register sha1 hash!
mxs-dcp: probe of 80028000.dcp failed with error -22

This happens since commit 8996eafdcbad ("crypto: ahash - ensure statesize
is non-zero"), which requires statesize to be filled.

Other than filling statesize, we also need to provide the import/export
functions.

Based on the implementation of the sahara and caam drivers.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Changes since v2:
- Newly introduced in this series

 drivers/crypto/mxs-dcp.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 59ed54e..1e2017f 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -775,6 +775,24 @@ static void dcp_sha_cra_exit(struct crypto_tfm *tfm)
 {
 }
 
+static int dcp_sha_export(struct ahash_request *req, void *out)
+{
+	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
+
+	memcpy(out, rctx, sizeof(struct dcp_sha_req_ctx));
+
+	return 0;
+}
+
+static int dcp_sha_import(struct ahash_request *req, const void *in)
+{
+	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
+
+	memcpy(rctx, in, sizeof(struct dcp_sha_req_ctx));
+
+	return 0;
+}
+
 /* AES 128 ECB and AES 128 CBC */
 static struct crypto_alg dcp_aes_algs[] = {
 	{
@@ -834,8 +852,11 @@ static struct ahash_alg dcp_sha1_alg = {
 	.final	= dcp_sha_final,
 	.finup	= dcp_sha_finup,
 	.digest	= dcp_sha_digest,
+	.import = dcp_sha_import,
+	.export = dcp_sha_export,
 	.halg	= {
 		.digestsize	= SHA1_DIGEST_SIZE,
+		.statesize	= sizeof(struct dcp_sha_req_ctx),
 		.base		= {
 			.cra_name		= "sha1",
 			.cra_driver_name	= "sha1-dcp",
@@ -858,8 +879,11 @@ static struct ahash_alg dcp_sha256_alg = {
 	.final	= dcp_sha_final,
 	.finup	= dcp_sha_finup,
 	.digest	= dcp_sha_digest,
+	.import = dcp_sha_import,
+	.export = dcp_sha_export,
 	.halg	= {
 		.digestsize	= SHA256_DIGEST_SIZE,
+		.statesize	= sizeof(struct dcp_sha_req_ctx),
 		.base		= {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "sha256-dcp",
-- 
1.9.1
