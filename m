From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [v3 PATCH 2/3] crypto: atmel-aes/tdes - remove empty functions
Date: Thu, 2 Nov 2017 17:12:25 +0200
Message-ID: <20171102151225.12949-1-tudor.ambarus@microchip.com>
References: <20171026133549.20654-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21884 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933567AbdKBPMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2017 11:12:38 -0400
In-Reply-To: <20171026133549.20654-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pointer members of an object with static storage duration, if not
explicitly initialized, will be initialized to a NULL pointer.
The crypto API checks if these pointers are not NULL before using them,
therefore we can safely remove these empty functions.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
changes in v3:
- update the commit message
changes in v2:
- remove empty atmel_aes_gcm_exit()

 drivers/crypto/atmel-aes.c  | 20 --------------------
 drivers/crypto/atmel-tdes.c | 18 ------------------
 2 files changed, 38 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9659759..c2f0a12 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1237,10 +1237,6 @@ static int atmel_aes_ctr_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static void atmel_aes_cra_exit(struct crypto_tfm *tfm)
-{
-}
-
 static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "ecb(aes)",
@@ -1253,7 +1249,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1273,7 +1268,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1294,7 +1288,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1315,7 +1308,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1336,7 +1328,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1357,7 +1348,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1378,7 +1368,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1399,7 +1388,6 @@ static struct crypto_alg aes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_ctr_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1422,7 +1410,6 @@ static struct crypto_alg aes_cfb64_alg = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1809,18 +1796,12 @@ static int atmel_aes_gcm_init(struct crypto_aead *tfm)
 	return 0;
 }
 
-static void atmel_aes_gcm_exit(struct crypto_aead *tfm)
-{
-
-}
-
 static struct aead_alg aes_gcm_alg = {
 	.setkey		= atmel_aes_gcm_setkey,
 	.setauthsize	= atmel_aes_gcm_setauthsize,
 	.encrypt	= atmel_aes_gcm_encrypt,
 	.decrypt	= atmel_aes_gcm_decrypt,
 	.init		= atmel_aes_gcm_init,
-	.exit		= atmel_aes_gcm_exit,
 	.ivsize		= GCM_AES_IV_SIZE,
 	.maxauthsize	= AES_BLOCK_SIZE,
 
@@ -1956,7 +1937,6 @@ static struct crypto_alg aes_xts_alg = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_aes_xts_cra_init,
-	.cra_exit		= atmel_aes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 0ece4b8..48e8653 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -911,10 +911,6 @@ static int atmel_tdes_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static void atmel_tdes_cra_exit(struct crypto_tfm *tfm)
-{
-}
-
 static struct crypto_alg tdes_algs[] = {
 {
 	.cra_name		= "ecb(des)",
@@ -927,7 +923,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
@@ -947,7 +942,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
@@ -968,7 +962,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
@@ -989,7 +982,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
@@ -1010,7 +1002,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
@@ -1031,7 +1022,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
@@ -1052,7 +1042,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
@@ -1073,7 +1062,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2 * DES_KEY_SIZE,
 		.max_keysize	= 3 * DES_KEY_SIZE,
@@ -1093,7 +1081,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2*DES_KEY_SIZE,
 		.max_keysize	= 3*DES_KEY_SIZE,
@@ -1114,7 +1101,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2*DES_KEY_SIZE,
 		.max_keysize	= 2*DES_KEY_SIZE,
@@ -1135,7 +1121,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2*DES_KEY_SIZE,
 		.max_keysize	= 2*DES_KEY_SIZE,
@@ -1156,7 +1141,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2*DES_KEY_SIZE,
 		.max_keysize	= 2*DES_KEY_SIZE,
@@ -1177,7 +1161,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2*DES_KEY_SIZE,
 		.max_keysize	= 2*DES_KEY_SIZE,
@@ -1198,7 +1181,6 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
-	.cra_exit		= atmel_tdes_cra_exit,
 	.cra_u.ablkcipher = {
 		.min_keysize	= 2*DES_KEY_SIZE,
 		.max_keysize	= 3*DES_KEY_SIZE,
-- 
2.9.4
