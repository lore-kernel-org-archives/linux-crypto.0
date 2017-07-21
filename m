From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 3/4] crypto: ccp - Rework the unit-size check for XTS-AES
Date: Fri, 21 Jul 2017 14:05:07 -0500
Message-ID: <150066390692.49973.8816619065422606698.stgit@sosxen.amd.com>
References: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0067.outbound.protection.outlook.com ([104.47.42.67]:27395
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754141AbdGUTFN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 15:05:13 -0400
In-Reply-To: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCP supports a limited set of unit-size values. Change the check
for this parameter such that acceptable values match the enumeration.
Then clarify the conditions under which we must use the fallback
implementation.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   75 ++++++++++++++-----------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 4a313f62dbea..3c37794ffe2d 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -1,8 +1,9 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) AES XTS crypto API support
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
+ * Author: Gary R Hook <gary.hook@amd.com>
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -38,46 +39,26 @@ struct ccp_unit_size_map {
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
 
@@ -124,7 +105,9 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	unsigned int fallback = 0;
 	unsigned int unit;
+	u32 block_size;
 	u32 unit_size;
 	int ret;
 
@@ -137,18 +120,30 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	if (!req->info)
 		return -EINVAL;
 
+	/* Check conditions under which the CCP can fulfill a request. The
+	 * device can handle input plaintext of a length that is a multiple
+	 * of the unit_size, bug the crypto implementation only supports
+	 * the unit_size being equal to the input length. This limits the
+	 * number of scenarios we can handle. Also validate the key length.
+	 */
+	block_size = 0;
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
+			block_size = xts_unit_sizes[unit].size;
+			break;
 		}
 	}
-
-	if ((unit_size == CCP_XTS_AES_UNIT_SIZE__LAST) ||
-	    (ctx->u.aes.key_len != AES_KEYSIZE_128)) {
+	/* The CCP has restrictions on block sizes. Also, a version 3 device
+	 * only supports AES-128 operations; version 5 CCPs support both
+	 * AES-128 and -256 operations.
+	 */
+	if (unit_size == CCP_XTS_AES_UNIT_SIZE__LAST)
+		fallback = 1;
+	if (ctx->u.aes.key_len != AES_KEYSIZE_128)
+		fallback = 1;
+	if (fallback) {
 		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
 
 		/* Use the fallback to process the request for any
