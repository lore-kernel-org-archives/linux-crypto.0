From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH] crypto: talitos - add support for sha256 and md5 variants
Date: Wed, 09 Jul 2008 13:19:03 -0500
Message-ID: <1215627543.18037.3.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:63326 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYGISL5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jul 2008 14:11:57 -0400
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by de01egw02.freescale.net (8.12.11/de01egw02) with ESMTP id m69IBrqp026792
	for <linux-crypto@vger.kernel.org>; Wed, 9 Jul 2008 11:11:53 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id m69IBpkj021936
	for <linux-crypto@vger.kernel.org>; Wed, 9 Jul 2008 13:11:52 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support for:
authenc(hmac(sha256),cbc(aes)),
authenc(hmac(sha256),cbc(des3_ede)),
authenc(hmac(md5),cbc(aes)),
authenc(hmac(md5),cbc(des3_ede)).
Some constant usage was changed to use aes, des, and sha include files.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
---
This patch applies against the kernel.org crypto tree at
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.

 drivers/crypto/talitos.c |  111 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8c270cd..b11943d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -40,6 +40,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/des.h>
 #include <crypto/sha.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
@@ -640,13 +641,9 @@ static void talitos_unregister_rng(struct device *dev)
  */
 #define TALITOS_CRA_PRIORITY		3000
 #define TALITOS_MAX_KEY_SIZE		64
-#define TALITOS_MAX_AUTH_SIZE		20
-#define TALITOS_AES_MIN_BLOCK_SIZE	16
-#define TALITOS_3DES_MIN_BLOCK_SIZE	24
+#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
-#define TALITOS_AES_IV_LENGTH		16
-#define TALITOS_3DES_IV_LENGTH		8
-#define TALITOS_MAX_IV_LENGTH		16
+#define MD5_DIGEST_SIZE   16
 
 struct talitos_ctx {
 	struct device *dev;
@@ -1145,7 +1142,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{
 		.name = "authenc(hmac(sha1),cbc(aes))",
 		.driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
-		.blocksize = TALITOS_AES_MIN_BLOCK_SIZE,
+		.blocksize = AES_BLOCK_SIZE,
 		.aead = {
 			.setkey = aead_authenc_setkey,
 			.setauthsize = aead_authenc_setauthsize,
@@ -1153,8 +1150,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.decrypt = aead_authenc_decrypt,
 			.givencrypt = aead_authenc_givencrypt,
 			.geniv = "<built-in>",
-			.ivsize = TALITOS_AES_IV_LENGTH,
-			.maxauthsize = TALITOS_MAX_AUTH_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
 			},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
@@ -1167,7 +1164,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
-		.blocksize = TALITOS_3DES_MIN_BLOCK_SIZE,
+		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.aead = {
 			.setkey = aead_authenc_setkey,
 			.setauthsize = aead_authenc_setauthsize,
@@ -1175,8 +1172,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.decrypt = aead_authenc_decrypt,
 			.givencrypt = aead_authenc_givencrypt,
 			.geniv = "<built-in>",
-			.ivsize = TALITOS_3DES_IV_LENGTH,
-			.maxauthsize = TALITOS_MAX_AUTH_SIZE,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
 			},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
@@ -1186,6 +1183,96 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_INIT |
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha256),cbc(aes))",
+		.driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
+		.blocksize = AES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_AESU |
+		                     DESC_HDR_MODE0_AESU_CBC |
+		                     DESC_HDR_SEL1_MDEUA |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha256),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_DEU |
+		                     DESC_HDR_MODE0_DEU_CBC |
+		                     DESC_HDR_MODE0_DEU_3DES |
+		                     DESC_HDR_SEL1_MDEUA |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{
+		.name = "authenc(hmac(md5),cbc(aes))",
+		.driver_name = "authenc-hmac-md5-cbc-aes-talitos",
+		.blocksize = AES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_AESU |
+		                     DESC_HDR_MODE0_AESU_CBC |
+		                     DESC_HDR_SEL1_MDEUA |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+	{
+		.name = "authenc(hmac(md5),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-md5-cbc-3des-talitos",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_DEU |
+		                     DESC_HDR_MODE0_DEU_CBC |
+		                     DESC_HDR_MODE0_DEU_3DES |
+		                     DESC_HDR_SEL1_MDEUA |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	}
 };
 
-- 
1.5.6.1


