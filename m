From: Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH crypto] crypto: aesni - fix typo in generic_gcmaes_decrypt
Date: Wed, 13 Dec 2017 14:53:43 +0100
Message-ID: <750b6e05579d7c186557be03acb1b6937a3f4498.1513172423.git.sd@queasysnail.net>
Cc: linux-kernel@vger.kernel.org, sbrivio@redhat.com,
        herbert@gondor.apana.org.au, Sabrina Dubroca <sd@queasysnail.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

generic_gcmaes_decrypt needs to use generic_gcmaes_ctx, not
aesni_rfc4106_gcm_ctx. This is actually harmless because the fields in
struct generic_gcmaes_ctx share the layout of the same fields in
aesni_rfc4106_gcm_ctx.

Fixes: cce2ea8d90fe ("crypto: aesni - add generic gcm(aes)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 3bf3dcf29825..8981ed1eb7ad 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1117,7 +1117,7 @@ static int generic_gcmaes_decrypt(struct aead_request *req)
 {
 	__be32 counter = cpu_to_be32(1);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+	struct generic_gcmaes_ctx *ctx = generic_gcmaes_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
 	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
 
-- 
2.15.1
