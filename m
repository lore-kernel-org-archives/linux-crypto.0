From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 2/3] crypto: sahara - fill the statesize field
Date: Wed, 13 Jan 2016 15:52:03 -0200
Message-ID: <1452707524-7695-2-git-send-email-festevam@gmail.com>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, s.trumtrar@pengutronix.de, thomas.lendacky@amd.com,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:35759 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbcAMRw1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 12:52:27 -0500
Received: by mail-yk0-f195.google.com with SMTP id a85so31655506ykb.2
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2016 09:52:27 -0800 (PST)
In-Reply-To: <1452707524-7695-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

Currently the sahara driver fails to probe:

sahara: probe of 63ff8000.crypto failed with error -22

This happens since commit 8996eafdcbad ("crypto: ahash - ensure statesize
is non-zero"), which requires statesize to be filled.

Pass the statesize members for sha1 and sha256, so we can probe
the driver successfully again.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Changes since v1:
- Fix the statesize field to match the size used in import/export (Tom Lendacky)

 drivers/crypto/sahara.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 53c7a9a..239f31a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1252,6 +1252,7 @@ static struct ahash_alg sha_v3_algs[] = {
 	.export		= sahara_sha_export,
 	.import		= sahara_sha_import,
 	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.statesize         = sizeof(struct sahara_sha_reqctx),
 	.halg.base	= {
 		.cra_name		= "sha1",
 		.cra_driver_name	= "sahara-sha1",
@@ -1279,6 +1280,7 @@ static struct ahash_alg sha_v4_algs[] = {
 	.export		= sahara_sha_export,
 	.import		= sahara_sha_import,
 	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.statesize         = sizeof(struct sahara_sha_reqctx),
 	.halg.base	= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "sahara-sha256",
-- 
1.9.1
