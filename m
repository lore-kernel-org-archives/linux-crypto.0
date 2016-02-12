From: Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH] arm/arm64/crypto: assure that ECB modes don't require an IV
Date: Fri, 12 Feb 2016 09:47:52 -0600
Message-ID: <1455292072-5236-1-git-send-email-jeremy.linton@arm.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux@arm.linux.org.uk,
	catalin.marinas@arm.com, will.deacon@arm.com,
	Jeremy Linton <jeremy.linton@arm.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:33829 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbcBLPsB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2016 10:48:01 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ECB modes don't use an initialization vector. The kernel
/proc/crypto interface doesn't reflect this properly.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 arch/arm/crypto/aes-ce-glue.c | 4 ++--
 arch/arm64/crypto/aes-glue.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index b445a5d..89a3a3e 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -364,7 +364,7 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_blkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.setkey		= ce_aes_setkey,
 		.encrypt	= ecb_encrypt,
 		.decrypt	= ecb_decrypt,
@@ -441,7 +441,7 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.setkey		= ablk_set_key,
 		.encrypt	= ablk_encrypt,
 		.decrypt	= ablk_decrypt,
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 05d9e16..7a3d22a 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -294,7 +294,7 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_blkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.setkey		= aes_setkey,
 		.encrypt	= ecb_encrypt,
 		.decrypt	= ecb_decrypt,
@@ -371,7 +371,7 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_ablkcipher = {
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.setkey		= ablk_set_key,
 		.encrypt	= ablk_encrypt,
 		.decrypt	= ablk_decrypt,
-- 
2.4.3
