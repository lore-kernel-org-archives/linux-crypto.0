From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: sahara: Fill the statesize field
Date: Wed, 13 Jan 2016 10:10:05 -0200
Message-ID: <1452687005-16444-1-git-send-email-festevam@gmail.com>
Cc: s.trumtrar@pengutronix.de, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:36537 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511AbcAMMK0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 07:10:26 -0500
Received: by mail-yk0-f175.google.com with SMTP id v14so392220091ykd.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2016 04:10:26 -0800 (PST)
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
Hi Steffen,

Only 'probe' tested. Haven't run any crypto operations yet.

 drivers/crypto/sahara.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index f68c24a..d05d849 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1260,6 +1260,7 @@ static struct ahash_alg sha_v3_algs[] = {
 	.export		= sahara_sha_export,
 	.import		= sahara_sha_import,
 	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.statesize		= sizeof(struct sahara_ctx),
 	.halg.base	= {
 		.cra_name		= "sha1",
 		.cra_driver_name	= "sahara-sha1",
@@ -1287,6 +1288,7 @@ static struct ahash_alg sha_v4_algs[] = {
 	.export		= sahara_sha_export,
 	.import		= sahara_sha_import,
 	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.statesize		= sizeof(struct sahara_ctx),
 	.halg.base	= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "sahara-sha256",
-- 
1.9.1
