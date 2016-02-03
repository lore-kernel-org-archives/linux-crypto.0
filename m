From: Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH v3 3/3] crypto: sahara - fill the statesize field
Date: Wed, 3 Feb 2016 10:46:52 -0200
Message-ID: <1454503612-21344-3-git-send-email-fabio.estevam@nxp.com>
References: <1454503612-21344-1-git-send-email-fabio.estevam@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <s.trumtrar@pengutronix.de>, <marex@denx.de>,
	<linux@arm.linux.org.uk>, <linux-crypto@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0088.outbound.protection.outlook.com ([65.55.169.88]:55376
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751407AbcBCNU3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 08:20:29 -0500
In-Reply-To: <1454503612-21344-1-git-send-email-fabio.estevam@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently the sahara driver fails to probe:

sahara: probe of 63ff8000.crypto failed with error -22

This happens since commit 8996eafdcbad ("crypto: ahash - ensure statesize
is non-zero"), which requires statesize to be filled.

Pass the statesize members for sha1 and sha256, so we can probe
the driver successfully again.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/crypto/sahara.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 9db09b6..c3f3d89 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1259,6 +1259,7 @@ static struct ahash_alg sha_v3_algs[] = {
 	.export		= sahara_sha_export,
 	.import		= sahara_sha_import,
 	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.statesize         = sizeof(struct sahara_sha_reqctx),
 	.halg.base	= {
 		.cra_name		= "sha1",
 		.cra_driver_name	= "sahara-sha1",
@@ -1286,6 +1287,7 @@ static struct ahash_alg sha_v4_algs[] = {
 	.export		= sahara_sha_export,
 	.import		= sahara_sha_import,
 	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.statesize         = sizeof(struct sahara_sha_reqctx),
 	.halg.base	= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "sahara-sha256",
-- 
1.9.1
