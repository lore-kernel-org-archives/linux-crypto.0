From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 07/n]: Use unique driver names for different algos
Date: Wed, 07 May 2008 14:32:45 +0200
Message-ID: <4821A16D.7060905@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060808010607090604080705"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYEGMdZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:33:25 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060808010607090604080705
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------060808010607090604080705
Content-Type: text/x-diff;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07.diff"

commit 02cabb7369102c475dfa33dbb6787db1855a7062
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:54:30 2008 +0200

    [HIFN]: Use unique driver names for different algos
    
    When the CryptoAPI instantiates a new algorithm, it performs a lookup
    by driver name. Since hifn uses the same name for all modes of one
    algorithm, the lookup may return an incorrect algorithm.
    
    Change the name to use <mode>-<algo>-<devicename> to provide unique
    names for the different combinations and devices.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 650523c..4027fa1 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2355,7 +2355,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 	 * 3DES ECB, CBC, CFB and OFB modes.
 	 */
 	{
-		.name = "cfb(des3_ede)", .drv_name = "hifn-3des", .bsize = 8,
+		.name = "cfb(des3_ede)", .drv_name = "cfb-3des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
@@ -2365,7 +2365,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "ofb(des3_ede)", .drv_name = "hifn-3des", .bsize = 8,
+		.name = "ofb(des3_ede)", .drv_name = "ofb-3des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
@@ -2375,7 +2375,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "cbc(des3_ede)", .drv_name = "hifn-3des", .bsize = 8,
+		.name = "cbc(des3_ede)", .drv_name = "cbc-3des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
@@ -2385,7 +2385,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "ecb(des3_ede)", .drv_name = "hifn-3des", .bsize = 8,
+		.name = "ecb(des3_ede)", .drv_name = "ecb-3des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
@@ -2399,7 +2399,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 	 * DES ECB, CBC, CFB and OFB modes.
 	 */
 	{
-		.name = "cfb(des)", .drv_name = "hifn-des", .bsize = 8,
+		.name = "cfb(des)", .drv_name = "cfb-des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_DES_KEY_LENGTH,
@@ -2409,7 +2409,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "ofb(des)", .drv_name = "hifn-des", .bsize = 8,
+		.name = "ofb(des)", .drv_name = "ofb-des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_DES_KEY_LENGTH,
@@ -2419,7 +2419,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "cbc(des)", .drv_name = "hifn-des", .bsize = 8,
+		.name = "cbc(des)", .drv_name = "cbc-des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_DES_KEY_LENGTH,
@@ -2429,7 +2429,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "ecb(des)", .drv_name = "hifn-des", .bsize = 8,
+		.name = "ecb(des)", .drv_name = "ecb-des", .bsize = 8,
 		.ablkcipher = {
 			.min_keysize	=	HIFN_DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_DES_KEY_LENGTH,
@@ -2443,7 +2443,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 	 * AES ECB, CBC, CFB and OFB modes.
 	 */
 	{
-		.name = "ecb(aes)", .drv_name = "hifn-aes", .bsize = 16,
+		.name = "ecb(aes)", .drv_name = "ecb-aes", .bsize = 16,
 		.ablkcipher = {
 			.min_keysize	=	AES_MIN_KEY_SIZE,
 			.max_keysize	=	AES_MAX_KEY_SIZE,
@@ -2453,7 +2453,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "cbc(aes)", .drv_name = "hifn-aes", .bsize = 16,
+		.name = "cbc(aes)", .drv_name = "cbc-aes", .bsize = 16,
 		.ablkcipher = {
 			.min_keysize	=	AES_MIN_KEY_SIZE,
 			.max_keysize	=	AES_MAX_KEY_SIZE,
@@ -2463,7 +2463,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "cfb(aes)", .drv_name = "hifn-aes", .bsize = 16,
+		.name = "cfb(aes)", .drv_name = "cfb-aes", .bsize = 16,
 		.ablkcipher = {
 			.min_keysize	=	AES_MIN_KEY_SIZE,
 			.max_keysize	=	AES_MAX_KEY_SIZE,
@@ -2473,7 +2473,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		},
 	},
 	{
-		.name = "ofb(aes)", .drv_name = "hifn-aes", .bsize = 16,
+		.name = "ofb(aes)", .drv_name = "ofb-aes", .bsize = 16,
 		.ablkcipher = {
 			.min_keysize	=	AES_MIN_KEY_SIZE,
 			.max_keysize	=	AES_MAX_KEY_SIZE,
@@ -2505,7 +2505,8 @@ static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
 		return -ENOMEM;
 
 	snprintf(alg->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s", t->name);
-	snprintf(alg->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s", t->drv_name);
+	snprintf(alg->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-%s",
+		 t->drv_name, dev->name);
 
 	alg->alg.cra_priority = 300;
 	alg->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;

--------------060808010607090604080705--
