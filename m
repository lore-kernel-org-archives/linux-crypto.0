From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: arm64/aes - do not call crypto_unregister_skcipher twice on error
Date: Wed, 22 Nov 2017 08:08:34 +0000
Message-ID: <1511338114-39583-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When a cipher fail to register in aes_init(), the error path go thought
aes_exit() then crypto_unregister_skciphers().
Since aes_exit calls also crypto_unregister_skcipher, this trigger a
refcount_t: underflow; use-after-free.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/crypto/aes-glue.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 998ba519a026..9e42ec96243e 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -664,7 +664,10 @@ static int __init aes_init(void)
 	return 0;
 
 unregister_simds:
-	aes_exit();
+	for (i = 0; i < ARRAY_SIZE(aes_simd_algs); i++)
+		if (aes_simd_algs[i])
+			simd_skcipher_free(aes_simd_algs[i]);
+	crypto_unregister_shashes(mac_algs, ARRAY_SIZE(mac_algs));
 unregister_ciphers:
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 	return err;
-- 
2.13.6
