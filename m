From: Catalin Vasile <catalin.vasile@freescale.com>
Subject: [PATCH] crypto: caam - add support for givencrypt cbc(des) and cbc(des3_ede)
Date: Tue, 11 Nov 2014 16:18:13 +0200
Message-ID: <1415715493-15992-1-git-send-email-catalin.vasile@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:32860
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751506AbaKKOTf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Nov 2014 09:19:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Merge DES Cipher Block Chaining mode (CBC) and Triple DES Cipher Block
Chaining mode (CBC) algorithms from ablkcipher to givencrypt.

Signed-off-by: Catalin Vasile <catalin.vasile@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 44b306b..3187400 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -4057,12 +4057,13 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "cbc(des3_ede)",
 		.driver_name = "cbc-3des-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
 		.template_ablkcipher = {
 			.setkey = ablkcipher_setkey,
 			.encrypt = ablkcipher_encrypt,
 			.decrypt = ablkcipher_decrypt,
-			.geniv = "eseqiv",
+			.givencrypt = ablkcipher_givencrypt,
+			.geniv = "<built-in>",
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -4073,12 +4074,13 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "cbc(des)",
 		.driver_name = "cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
 		.template_ablkcipher = {
 			.setkey = ablkcipher_setkey,
 			.encrypt = ablkcipher_encrypt,
 			.decrypt = ablkcipher_decrypt,
-			.geniv = "eseqiv",
+			.givencrypt = ablkcipher_givencrypt,
+			.geniv = "<built-in>",
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
-- 
1.8.3.1
