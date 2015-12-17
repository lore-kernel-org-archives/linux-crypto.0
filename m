From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 03/24] crypto: atmel-aes: change algorithm priorities
Date: Thu, 17 Dec 2015 17:48:34 +0100
Message-ID: <c6cd8f53a808c2d23651fd9c42108b914b80af4f.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Increase the algorithm priorities so the hardware acceleration is now
preferred to the software computation: the "aes-generice" driver uses 100
as priority.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 1d3997a45610..e545636a7ddc 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -43,6 +43,8 @@
 #include <dt-bindings/dma/at91.h>
 #include "atmel-aes-regs.h"
 
+#define ATMEL_AES_PRIORITY	300
+
 #define CFB8_BLOCK_SIZE		1
 #define CFB16_BLOCK_SIZE	2
 #define CFB32_BLOCK_SIZE	4
@@ -960,7 +962,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "atmel-ecb-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -980,7 +982,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "atmel-cbc-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -1001,7 +1003,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "ofb(aes)",
 	.cra_driver_name	= "atmel-ofb-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -1022,7 +1024,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "cfb(aes)",
 	.cra_driver_name	= "atmel-cfb-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -1043,7 +1045,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "cfb32(aes)",
 	.cra_driver_name	= "atmel-cfb32-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= CFB32_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -1064,7 +1066,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "cfb16(aes)",
 	.cra_driver_name	= "atmel-cfb16-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= CFB16_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -1085,7 +1087,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "cfb8(aes)",
 	.cra_driver_name	= "atmel-cfb8-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= CFB8_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -1106,7 +1108,7 @@ static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "ctr(aes)",
 	.cra_driver_name	= "atmel-ctr-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
@@ -1129,7 +1131,7 @@ static struct crypto_alg aes_algs[] = {
 static struct crypto_alg aes_cfb64_alg = {
 	.cra_name		= "cfb64(aes)",
 	.cra_driver_name	= "atmel-cfb64-aes",
-	.cra_priority		= 100,
+	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= CFB64_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
-- 
1.8.2.2
