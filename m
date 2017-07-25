From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v3 2/3] crypto: ccp - Rework the unit-size check for XTS-AES
Date: Tue, 25 Jul 2017 14:21:34 -0500
Message-ID: <150101049413.39154.3667493476830799067.stgit@sosxen.amd.com>
References: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:2048
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752905AbdGYTVk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 15:21:40 -0400
In-Reply-To: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCP supports a limited set of unit-size values. Change the check
for this parameter such that acceptable values match the enumeration.
Then clarify the conditions under which we must use the fallback
implementation.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   57 +++++++++++--------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 2b5d3a62fad9..5c2df880ab48 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -39,46 +39,26 @@ struct ccp_unit_size_map {
 	u32 value;
 };
 
-static struct ccp_unit_size_map unit_size_map[] = {
+static struct ccp_unit_size_map xts_unit_sizes[] = {
 	{
-		.size	= 4096,
-		.value	= CCP_XTS_AES_UNIT_SIZE_4096,
-	},
-	{
-		.size	= 2048,
-		.value	= CCP_XTS_AES_UNIT_SIZE_2048,
-	},
-	{
-		.size	= 1024,
-		.value	= CCP_XTS_AES_UNIT_SIZE_1024,
+		.size   = 16,
+		.value	= CCP_XTS_AES_UNIT_SIZE_16,
 	},
 	{
-		.size	= 512,
+		.size   = 512,
 		.value	= CCP_XTS_AES_UNIT_SIZE_512,
 	},
 	{
-		.size	= 256,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
-	},
-	{
-		.size	= 128,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
-	},
-	{
-		.size	= 64,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
-	},
-	{
-		.size	= 32,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+		.size   = 1024,
+		.value	= CCP_XTS_AES_UNIT_SIZE_1024,
 	},
 	{
-		.size	= 16,
-		.value	= CCP_XTS_AES_UNIT_SIZE_16,
+		.size   = 2048,
+		.value	= CCP_XTS_AES_UNIT_SIZE_2048,
 	},
 	{
-		.size	= 1,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+		.size   = 4096,
+		.value	= CCP_XTS_AES_UNIT_SIZE_4096,
 	},
 };
 
@@ -138,16 +118,19 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	if (!req->info)
 		return -EINVAL;
 
+	/* Check conditions under which the CCP can fulfill a request. The
+	 * device can handle input plaintext of a length that is a multiple
+	 * of the unit_size, bug the crypto implementation only supports
+	 * the unit_size being equal to the input length. This limits the
+	 * number of scenarios we can handle.
+	 */
 	unit_size = CCP_XTS_AES_UNIT_SIZE__LAST;
-	if (req->nbytes <= unit_size_map[0].size) {
-		for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++) {
-			if (!(req->nbytes & (unit_size_map[unit].size - 1))) {
-				unit_size = unit_size_map[unit].value;
-				break;
-			}
+	for (unit = 0; unit < ARRAY_SIZE(xts_unit_sizes); unit++) {
+		if (req->nbytes == xts_unit_sizes[unit].size) {
+			unit_size = unit;
+			break;
 		}
 	}
-
 	if ((unit_size == CCP_XTS_AES_UNIT_SIZE__LAST) ||
 	    (ctx->u.aes.key_len != AES_KEYSIZE_128)) {
 		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
