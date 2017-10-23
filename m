From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 2/3] crypto: atmel-aes/tdes - remove empty function
Date: Mon, 23 Oct 2017 18:34:40 +0300
Message-ID: <20171023153441.28825-2-tudor.ambarus@microchip.com>
References: <20171023153441.28825-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53762 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932102AbdJWPes (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 11:34:48 -0400
In-Reply-To: <20171023153441.28825-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This empty function was used to initialize a member of a static structure.
Pointer members of an object with static storage duration, if not
explicitly initialized, will be initialized to a NULL pointer. The crypto
API checks if this pointer is not NULL before using it, so we are safe to
remove this empty function along with all the references to it.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 14 --------------
 drivers/crypto/atmel-tdes.c | 18 ------------------
 2 files changed, 32 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9659759..bc859ab 100644
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
@@ -1956,7 +1943,6 @@ static struct crypto_alg aes_xts_alg = {
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
