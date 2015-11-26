From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] crypto: mxs-dcp - Initialize .statesize fields
Date: Thu, 26 Nov 2015 13:47:41 -0200
Message-ID: <1448552861-17410-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <marex@denx.de>, <smueller@chronox.de>,
	<linux-crypto@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	<stable@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:53203
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368AbbKZQCB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 11:02:01 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initialize .statesize fields in order to avoid the following error
on probe:

mxs-dcp 80028000.dcp: Failed to register sha1 hash!
mxs-dcp: probe of 80028000.dcp failed with error -22

Cc: <stable@vger.kernel.org> # 4.1+
Suggested-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/mxs-dcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 59ed54e..e65d379 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -836,6 +836,7 @@ static struct ahash_alg dcp_sha1_alg = {
 	.digest	= dcp_sha_digest,
 	.halg	= {
 		.digestsize	= SHA1_DIGEST_SIZE,
+		.statesize	= sizeof(struct sha1_state),
 		.base		= {
 			.cra_name		= "sha1",
 			.cra_driver_name	= "sha1-dcp",
@@ -860,6 +861,7 @@ static struct ahash_alg dcp_sha256_alg = {
 	.digest	= dcp_sha_digest,
 	.halg	= {
 		.digestsize	= SHA256_DIGEST_SIZE,
+		.statesize	= sizeof(struct sha256_state),
 		.base		= {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "sha256-dcp",
-- 
1.9.1
