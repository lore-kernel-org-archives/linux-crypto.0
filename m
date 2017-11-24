From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2] ARM64: crypto: do not call crypto_unregister_skcipher twice on error
Date: Fri, 24 Nov 2017 08:22:07 +0000
Message-ID: <1511511727-15385-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will.deacon@arm.com,
        ard.biesheuvel@linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When a cipher fails to register in aes_init(), the error path goes thought
aes_exit() then crypto_unregister_skciphers().
Since aes_exit calls also crypto_unregister_skcipher, this triggers a
refcount_t: underflow; use-after-free.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
Changes since v1:
- Instead of duplicate code from aes_exit() minus crypto_unregister_skciphers, simply use it and return after
as suggested by Ard Biesheuvel
 arch/arm64/crypto/aes-glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 998ba519a026..2fa850e86aa8 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -665,6 +665,7 @@ static int __init aes_init(void)
 
 unregister_simds:
 	aes_exit();
+	return err;
 unregister_ciphers:
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 	return err;
-- 
2.13.6
