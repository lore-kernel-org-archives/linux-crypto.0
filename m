From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Fix AES XTS error for request sizes above 4096
Date: Fri, 20 May 2016 17:33:03 -0500
Message-ID: <20160520223303.7738.5391.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Gary Hook <gary.hook@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0055.outbound.protection.outlook.com ([65.55.169.55]:41181
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750836AbcETXHg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 May 2016 19:07:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ccp-crypto module for AES XTS support has a bug that can allow requests
greater than 4096 bytes in size to be passed to the CCP hardware. The CCP
hardware does not support request sizes larger than 4096, resulting in
incorrect output. The request should actually be handled by the fallback
mechanism instantiated by the ccp-crypto module.

Add a check to insure the request size is less than or equal to the maximum
supported size and use the fallback mechanism if it is not.

Cc: <stable@vger.kernel.org> # 3.14.x-
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 52c7395..0d0d452 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -122,6 +122,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
 	unsigned int unit;
+	u32 unit_size;
 	int ret;
 
 	if (!ctx->u.aes.key_len)
@@ -133,11 +134,17 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	if (!req->info)
 		return -EINVAL;
 
-	for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++)
-		if (!(req->nbytes & (unit_size_map[unit].size - 1)))
-			break;
+	unit_size = CCP_XTS_AES_UNIT_SIZE__LAST;
+	if (req->nbytes <= unit_size_map[0].size) {
+		for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++) {
+			if (!(req->nbytes & (unit_size_map[unit].size - 1))) {
+				unit_size = unit_size_map[unit].value;
+				break;
+			}
+		}
+	}
 
-	if ((unit_size_map[unit].value == CCP_XTS_AES_UNIT_SIZE__LAST) ||
+	if ((unit_size == CCP_XTS_AES_UNIT_SIZE__LAST) ||
 	    (ctx->u.aes.key_len != AES_KEYSIZE_128)) {
 		/* Use the fallback to process the request for any
 		 * unsupported unit sizes or key sizes
@@ -158,7 +165,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	rctx->cmd.engine = CCP_ENGINE_XTS_AES_128;
 	rctx->cmd.u.xts.action = (encrypt) ? CCP_AES_ACTION_ENCRYPT
 					   : CCP_AES_ACTION_DECRYPT;
-	rctx->cmd.u.xts.unit_size = unit_size_map[unit].value;
+	rctx->cmd.u.xts.unit_size = unit_size;
 	rctx->cmd.u.xts.key = &ctx->u.aes.key_sg;
 	rctx->cmd.u.xts.key_len = ctx->u.aes.key_len;
 	rctx->cmd.u.xts.iv = &rctx->iv_sg;
