From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: drbg - use MODULE_ALIAS_CRYPTO
Date: Tue, 25 Nov 2014 09:28:43 +0100
Message-ID: <1959971.EZA1ZTEOoi@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54818 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaKYI2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2014 03:28:48 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S8F46> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 25 Nov 2014 09:28:44 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the crypto- prefix for the DRBG implementations.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9fb38a5..c90e3cf 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -291,12 +291,12 @@ static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 #define CRYPTO_DRBG_CTR_STRING "CTR "
-MODULE_ALIAS("drbg_pr_ctr_aes256");
-MODULE_ALIAS("drbg_nopr_ctr_aes256");
-MODULE_ALIAS("drbg_pr_ctr_aes192");
-MODULE_ALIAS("drbg_nopr_ctr_aes192");
-MODULE_ALIAS("drbg_pr_ctr_aes128");
-MODULE_ALIAS("drbg_nopr_ctr_aes128");
+MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes256");
+MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes256");
+MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes192");
+MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes192");
+MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes128");
+MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes128");
 
 static int drbg_kcapi_sym(struct drbg_state *drbg, const unsigned char *key,
 			  unsigned char *outval, const struct drbg_string *in);
@@ -658,14 +658,14 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg);
 
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
 #define CRYPTO_DRBG_HMAC_STRING "HMAC "
-MODULE_ALIAS("drbg_pr_hmac_sha512");
-MODULE_ALIAS("drbg_nopr_hmac_sha512");
-MODULE_ALIAS("drbg_pr_hmac_sha384");
-MODULE_ALIAS("drbg_nopr_hmac_sha384");
-MODULE_ALIAS("drbg_pr_hmac_sha256");
-MODULE_ALIAS("drbg_nopr_hmac_sha256");
-MODULE_ALIAS("drbg_pr_hmac_sha1");
-MODULE_ALIAS("drbg_nopr_hmac_sha1");
+MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha512");
+MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
+MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha384");
+MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha384");
+MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha256");
+MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha256");
+MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha1");
+MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha1");
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
 static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
@@ -778,14 +778,14 @@ static struct drbg_state_ops drbg_hmac_ops = {
 
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 #define CRYPTO_DRBG_HASH_STRING "HASH "
-MODULE_ALIAS("drbg_pr_sha512");
-MODULE_ALIAS("drbg_nopr_sha512");
-MODULE_ALIAS("drbg_pr_sha384");
-MODULE_ALIAS("drbg_nopr_sha384");
-MODULE_ALIAS("drbg_pr_sha256");
-MODULE_ALIAS("drbg_nopr_sha256");
-MODULE_ALIAS("drbg_pr_sha1");
-MODULE_ALIAS("drbg_nopr_sha1");
+MODULE_ALIAS_CRYPTO("drbg_pr_sha512");
+MODULE_ALIAS_CRYPTO("drbg_nopr_sha512");
+MODULE_ALIAS_CRYPTO("drbg_pr_sha384");
+MODULE_ALIAS_CRYPTO("drbg_nopr_sha384");
+MODULE_ALIAS_CRYPTO("drbg_pr_sha256");
+MODULE_ALIAS_CRYPTO("drbg_nopr_sha256");
+MODULE_ALIAS_CRYPTO("drbg_pr_sha1");
+MODULE_ALIAS_CRYPTO("drbg_nopr_sha1");
 
 /*
  * Increment buffer
-- 
2.1.0
