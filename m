From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/3] crypto: mv_cesa - Staticize local symbols
Date: Fri, 13 Sep 2013 17:06:45 +0530
Message-ID: <1379072207-11179-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, sachin.kamat@linaro.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53681 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3IMLy4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 07:54:56 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so1137381pde.23
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2013 04:54:55 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Local symbols used only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/mv_cesa.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 3374a3e..f9b9560 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -907,7 +907,7 @@ static int mv_cra_hash_hmac_sha1_init(struct crypto_tfm *tfm)
 	return mv_cra_hash_init(tfm, "sha1", COP_HMAC_SHA1, SHA1_BLOCK_SIZE);
 }
 
-irqreturn_t crypto_int(int irq, void *priv)
+static irqreturn_t crypto_int(int irq, void *priv)
 {
 	u32 val;
 
@@ -928,7 +928,7 @@ irqreturn_t crypto_int(int irq, void *priv)
 	return IRQ_HANDLED;
 }
 
-struct crypto_alg mv_aes_alg_ecb = {
+static struct crypto_alg mv_aes_alg_ecb = {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "mv-ecb-aes",
 	.cra_priority	= 300,
@@ -951,7 +951,7 @@ struct crypto_alg mv_aes_alg_ecb = {
 	},
 };
 
-struct crypto_alg mv_aes_alg_cbc = {
+static struct crypto_alg mv_aes_alg_cbc = {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "mv-cbc-aes",
 	.cra_priority	= 300,
@@ -975,7 +975,7 @@ struct crypto_alg mv_aes_alg_cbc = {
 	},
 };
 
-struct ahash_alg mv_sha1_alg = {
+static struct ahash_alg mv_sha1_alg = {
 	.init = mv_hash_init,
 	.update = mv_hash_update,
 	.final = mv_hash_final,
@@ -999,7 +999,7 @@ struct ahash_alg mv_sha1_alg = {
 		 }
 };
 
-struct ahash_alg mv_hmac_sha1_alg = {
+static struct ahash_alg mv_hmac_sha1_alg = {
 	.init = mv_hash_init,
 	.update = mv_hash_update,
 	.final = mv_hash_final,
-- 
1.7.9.5
