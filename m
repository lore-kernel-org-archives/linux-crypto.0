From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/7] crypto: aes/x86 - eliminate set_key() handling for IRQ context
Date: Sun, 26 Mar 2017 19:49:04 +0100
Message-ID: <1490554148-10953-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33206 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbdCZS4A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 14:56:00 -0400
Received: by mail-wr0-f182.google.com with SMTP id w43so16016566wrb.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 11:55:59 -0700 (PDT)
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto API does not allow setkey() to be used in interrupt context,
and so the fallback to crypto_aes_expand_key() is dead code which can
be eliminated. This removes a dependency on crypto_aes_expand_key()
which will be fulfilled by another driver after a subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 93de8ea51548..f6bdd0ec96da 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -300,13 +300,13 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
 		return -EINVAL;
 	}
 
-	if (!irq_fpu_usable())
-		err = crypto_aes_expand_key(ctx, in_key, key_len);
-	else {
-		kernel_fpu_begin();
-		err = aesni_set_key(ctx, in_key, key_len);
-		kernel_fpu_end();
-	}
+	/* crypto API forbids setkey() in interrupt context */
+	if (WARN_ON(!irq_fpu_usable()))
+		return -EBUSY;
+
+	kernel_fpu_begin();
+	err = aesni_set_key(ctx, in_key, key_len);
+	kernel_fpu_end();
 
 	return err;
 }
-- 
2.7.4
