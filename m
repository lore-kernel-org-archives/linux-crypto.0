From: Luca Clementi <luca.clementi@gmail.com>
Subject: [PATCH] crypto: print cra driver name in tcrypt tests output
Date: Wed, 25 Jun 2014 22:57:42 -0700
Message-ID: <1403762262-14417-1-git-send-email-luca.clementi@gmail.com>
Cc: Luca Clementi <luca.clementi@gmail.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61944 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaFZF6G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jun 2014 01:58:06 -0400
Received: by mail-pd0-f174.google.com with SMTP id y10so2587652pdj.5
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2014 22:58:05 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Print the driver name that is being tested. The driver name can be
inferred parsing /proc/crypto but having it in the output is
clearer

Signed-off-by: Luca Clementi <luca.clementi@gmail.com>
---
 crypto/tcrypt.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ba247cf..749cec9 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -48,6 +48,11 @@
 #define DECRYPT 0
 
 /*
+ * return a string with the driver name
+ */
+#define get_driver_name(tfm_type, tfm) crypto_tfm_alg_driver_name(tfm_type ## _tfm(tfm))
+
+/*
  * Used by test_cipher_speed()
  */
 static unsigned int sec;
@@ -305,9 +310,6 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
 	asg = &sg[8];
 	sgout = &asg[8];
 
-
-	printk(KERN_INFO "\ntesting speed of %s %s\n", algo, e);
-
 	tfm = crypto_alloc_aead(algo, 0, 0);
 
 	if (IS_ERR(tfm)) {
@@ -316,6 +318,9 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
 		goto out_notfm;
 	}
 
+	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
+			get_driver_name(crypto_aead, tfm), e);
+
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		pr_err("alg: aead: Failed to allocate request for %s\n",
@@ -422,8 +427,6 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 	else
 		e = "decryption";
 
-	printk("\ntesting speed of %s %s\n", algo, e);
-
 	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
@@ -434,6 +437,9 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 	desc.tfm = tfm;
 	desc.flags = 0;
 
+	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
+			get_driver_name(crypto_blkcipher, tfm), e);
+
 	i = 0;
 	do {
 
@@ -683,8 +689,6 @@ static void test_hash_speed(const char *algo, unsigned int sec,
 	int i;
 	int ret;
 
-	printk(KERN_INFO "\ntesting speed of %s\n", algo);
-
 	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
@@ -693,6 +697,9 @@ static void test_hash_speed(const char *algo, unsigned int sec,
 		return;
 	}
 
+	printk(KERN_INFO "\ntesting speed of %s (%s)\n", algo,
+			get_driver_name(crypto_hash, tfm));
+
 	desc.tfm = tfm;
 	desc.flags = 0;
 
@@ -921,8 +928,6 @@ static void test_ahash_speed(const char *algo, unsigned int sec,
 	static char output[1024];
 	int i, ret;
 
-	printk(KERN_INFO "\ntesting speed of async %s\n", algo);
-
 	tfm = crypto_alloc_ahash(algo, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_err("failed to load transform for %s: %ld\n",
@@ -930,6 +935,9 @@ static void test_ahash_speed(const char *algo, unsigned int sec,
 		return;
 	}
 
+	printk(KERN_INFO "\ntesting speed of async %s (%s)\n", algo,
+			get_driver_name(crypto_ahash, tfm));
+
 	if (crypto_ahash_digestsize(tfm) > sizeof(output)) {
 		pr_err("digestsize(%u) > outputbuffer(%zu)\n",
 		       crypto_ahash_digestsize(tfm), sizeof(output));
@@ -1083,8 +1091,6 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int sec,
 	else
 		e = "decryption";
 
-	pr_info("\ntesting speed of async %s %s\n", algo, e);
-
 	init_completion(&tresult.completion);
 
 	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
@@ -1095,6 +1101,9 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int sec,
 		return;
 	}
 
+	pr_info("\ntesting speed of async %s (%s) %s\n", algo,
+			get_driver_name(crypto_ablkcipher, tfm), e);
+
 	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		pr_err("tcrypt: skcipher: Failed to allocate request for %s\n",
-- 
1.7.9.5
