From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] crypto: aesni-intel - fix wrong kfree pointer
Date: Thu, 28 Jun 2012 17:26:02 +0200
Message-ID: <1340897162-5046-1-git-send-email-mbroz@redhat.com>
Cc: herbert@gondor.hengli.com.au, Milan Broz <mbroz@redhat.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab2F1P0M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jun 2012 11:26:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

kfree(new_key_mem) in rfc4106_set_key() should be called on malloced pointer,
not on aligned one, otherwise it can cause invalid pointer on free.

(Seen at least once when running tcrypt tests with debug kernel.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ac7f5cd..c9bac53 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -613,7 +613,7 @@ static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
 	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
 	struct aesni_rfc4106_gcm_ctx *child_ctx =
                                  aesni_rfc4106_gcm_ctx_get(cryptd_child);
-	u8 *new_key_mem = NULL;
+	u8 *new_key_align, *new_key_mem = NULL;
 
 	if (key_len < 4) {
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -637,9 +637,9 @@ static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
 		if (!new_key_mem)
 			return -ENOMEM;
 
-		new_key_mem = PTR_ALIGN(new_key_mem, AESNI_ALIGN);
-		memcpy(new_key_mem, key, key_len);
-		key = new_key_mem;
+		new_key_align = PTR_ALIGN(new_key_mem, AESNI_ALIGN);
+		memcpy(new_key_align, key, key_len);
+		key = new_key_align;
 	}
 
 	if (!irq_fpu_usable())
-- 
1.7.10
