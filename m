Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30FFC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B965D27739
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540707;
	bh=CUXvcJAEwQL16djW8U7Y89SxxwgNQNaOLNGmNMx3Ho0=;
	h=From:To:Subject:Date:List-ID:From;
	b=XevU42QAo83HM3rQmPWlJJvPS9fak51DZZKZxTrGA2u01IafUijahgCmXOvaqzcfx
	 qJPCj7oEjDS+GoEnmwCjPWGXo3m97+li5IRfwaN1JKmNGfVCAWvznNIVWgS72Gb/KF
	 +PTNNANZl7E32ur6wgTgmy7cc8QdQIafnGk2UkN4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFCFpH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfFCFpH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:45:07 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 352C627739
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540706;
        bh=CUXvcJAEwQL16djW8U7Y89SxxwgNQNaOLNGmNMx3Ho0=;
        h=From:To:Subject:Date:From;
        b=XfASZjfCa1NIzLy68yMzd0g0xOZz2eS4wOChQw1nBoNVQVuVtCA/TkVuyY4wz+oG5
         VighxaypALJrEQuClFzZzOXRSWyLV+kkY31MbOhg+fpz7gg95ymdJ2V/z4LT2T72vB
         ImE2N1X2ylgxTKneSz87HRxDiIsoGNSn+i6Ju/F8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: x86/aesni - remove unused internal cipher algorithm
Date:   Sun,  2 Jun 2019 22:44:50 -0700
Message-Id: <20190603054450.5993-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since commit 944585a64f5e ("crypto: x86/aes-ni - remove special handling
of AES in PCBC mode"), the "__aes-aesni" internal cipher algorithm is no
longer used.  So remove it too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 45 +++++-------------------------
 1 file changed, 7 insertions(+), 38 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 21c246799aa58..c95bd397dc076 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -375,20 +375,6 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	}
 }
 
-static void __aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
-
-	aesni_enc(ctx, dst, src);
-}
-
-static void __aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
-
-	aesni_dec(ctx, dst, src);
-}
-
 static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			         unsigned int len)
 {
@@ -924,7 +910,7 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 }
 #endif
 
-static struct crypto_alg aesni_algs[] = { {
+static struct crypto_alg aesni_cipher_alg = {
 	.cra_name		= "aes",
 	.cra_driver_name	= "aes-aesni",
 	.cra_priority		= 300,
@@ -941,24 +927,7 @@ static struct crypto_alg aesni_algs[] = { {
 			.cia_decrypt		= aes_decrypt
 		}
 	}
-}, {
-	.cra_name		= "__aes",
-	.cra_driver_name	= "__aes-aesni",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER | CRYPTO_ALG_INTERNAL,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
-	.cra_module		= THIS_MODULE,
-	.cra_u	= {
-		.cipher	= {
-			.cia_min_keysize	= AES_MIN_KEY_SIZE,
-			.cia_max_keysize	= AES_MAX_KEY_SIZE,
-			.cia_setkey		= aes_set_key,
-			.cia_encrypt		= __aes_encrypt,
-			.cia_decrypt		= __aes_decrypt
-		}
-	}
-} };
+};
 
 static struct skcipher_alg aesni_skciphers[] = {
 	{
@@ -1154,7 +1123,7 @@ static int __init aesni_init(void)
 #endif
 #endif
 
-	err = crypto_register_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
+	err = crypto_register_alg(&aesni_cipher_alg);
 	if (err)
 		return err;
 
@@ -1162,7 +1131,7 @@ static int __init aesni_init(void)
 					     ARRAY_SIZE(aesni_skciphers),
 					     aesni_simd_skciphers);
 	if (err)
-		goto unregister_algs;
+		goto unregister_cipher;
 
 	err = simd_register_aeads_compat(aesni_aeads, ARRAY_SIZE(aesni_aeads),
 					 aesni_simd_aeads);
@@ -1174,8 +1143,8 @@ static int __init aesni_init(void)
 unregister_skciphers:
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
-unregister_algs:
-	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
+unregister_cipher:
+	crypto_unregister_alg(&aesni_cipher_alg);
 	return err;
 }
 
@@ -1185,7 +1154,7 @@ static void __exit aesni_exit(void)
 			      aesni_simd_aeads);
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
-	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
+	crypto_unregister_alg(&aesni_cipher_alg);
 }
 
 late_initcall(aesni_init);
-- 
2.21.0

