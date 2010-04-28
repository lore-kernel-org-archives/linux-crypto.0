From: lee.nipper@gmail.com
Subject: [PATCH 1/3] crypto: talitos - prepare for adding ahash algorithms
Date: Wed, 28 Apr 2010 05:33:52 -0700 (PDT)
Message-ID: <4bd82b30.161a640a.6b45.4e9c@mx.google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59615 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab0D1Mdy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Apr 2010 08:33:54 -0400
Received: by gwj19 with SMTP id 19so4752758gwj.19
        for <linux-crypto@vger.kernel.org>; Wed, 28 Apr 2010 05:33:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

No functional changes.
Use a union in talitos_alg_template for the crypto_alg
so that we can add a member later for ahash_alg.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
 drivers/crypto/talitos.c |   39 +++++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index fd529d6..602387d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1478,14 +1478,17 @@ static int ablkcipher_decrypt(struct ablkcipher_request *areq)
 }
 
 struct talitos_alg_template {
-	struct crypto_alg alg;
+	u32 type;
+	union {
+		struct crypto_alg crypto;
+	} alg;
 	__be32 desc_hdr_template;
 };
 
 static struct talitos_alg_template driver_algs[] = {
 	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1510,8 +1513,8 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1537,8 +1540,8 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1563,8 +1566,8 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1590,8 +1593,8 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1616,8 +1619,8 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.crypto = {
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1644,8 +1647,8 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	/* ABLKCIPHER algorithms. */
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1666,8 +1669,8 @@ static struct talitos_alg_template driver_algs[] = {
 				     DESC_HDR_SEL0_AESU |
 				     DESC_HDR_MODE0_AESU_CBC,
 	},
-	{
-		.alg = {
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1788,7 +1791,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	alg = &t_alg->crypto_alg;
-	*alg = template->alg;
+	*alg = template->alg.crypto;
 
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = talitos_cra_init;
-- 
1.6.0.4

