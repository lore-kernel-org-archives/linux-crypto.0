From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] crypto: aesni-intel: move more common code to
 ablk_init_common
Date: Fri, 11 May 2012 16:00:54 +0300
Message-ID: <20120511130054.26495.76435.stgit@localhost6.localdomain6>
References: <20120511130048.26495.55851.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Huang Ying <ying.huang@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51872 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab2EKNLN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 May 2012 09:11:13 -0400
In-Reply-To: <20120511130048.26495.55851.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ablk_*_init functions share more common code than what is currently in
ablk_init_common. Move all of the common code to ablk_init_common.

Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aesni-intel_glue.c |   70 ++++++++----------------------------
 1 file changed, 15 insertions(+), 55 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 20c6220..ac7f5cd 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -442,61 +442,42 @@ static void ablk_exit(struct crypto_tfm *tfm)
 	cryptd_free_ablkcipher(ctx->cryptd_tfm);
 }
 
-static void ablk_init_common(struct crypto_tfm *tfm,
-			     struct cryptd_ablkcipher *cryptd_tfm)
+static int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name)
 {
 	struct async_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
 
 	ctx->cryptd_tfm = cryptd_tfm;
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
 		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
+
+	return 0;
 }
 
 static int ablk_ecb_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ecb-aes-aesni", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
+	return ablk_init_common(tfm, "__driver-ecb-aes-aesni");
 }
 
 static int ablk_cbc_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-cbc-aes-aesni", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
+	return ablk_init_common(tfm, "__driver-cbc-aes-aesni");
 }
 
 #ifdef CONFIG_X86_64
 static int ablk_ctr_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ctr-aes-aesni", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
+	return ablk_init_common(tfm, "__driver-ctr-aes-aesni");
 }
 
 #ifdef HAS_CTR
 static int ablk_rfc3686_ctr_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher(
-		"rfc3686(__driver-ctr-aes-aesni)", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
+	return ablk_init_common(tfm, "rfc3686(__driver-ctr-aes-aesni)");
 }
 #endif
 #endif
@@ -504,42 +485,21 @@ static int ablk_rfc3686_ctr_init(struct crypto_tfm *tfm)
 #ifdef HAS_LRW
 static int ablk_lrw_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("fpu(lrw(__driver-aes-aesni))",
-					     0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
+	return ablk_init_common(tfm, "fpu(lrw(__driver-aes-aesni))");
 }
 #endif
 
 #ifdef HAS_PCBC
 static int ablk_pcbc_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("fpu(pcbc(__driver-aes-aesni))",
-					     0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
+	return ablk_init_common(tfm, "fpu(pcbc(__driver-aes-aesni))");
 }
 #endif
 
 #ifdef HAS_XTS
 static int ablk_xts_init(struct crypto_tfm *tfm)
 {
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("fpu(xts(__driver-aes-aesni))",
-					     0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
+	return ablk_init_common(tfm, "fpu(xts(__driver-aes-aesni))");
 }
 #endif
 
