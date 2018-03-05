From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] crypto: x86/des3_ede: make array des3_ede_skciphers static
Date: Mon,  5 Mar 2018 14:18:00 +0100
Message-ID: <20180305131800.26647-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The array des3_ede_skciphers is local to the source and does not need
to be in global scope, so make it static.

Cleans up sparse warning:
arch/x86/crypto/des3_ede_glue.c:407:21: warning: symbol
'des3_ede_skciphers' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/crypto/des3_ede_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index f9c7bdc5be5a..5c610d4ef9fc 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -404,7 +404,7 @@ static struct crypto_alg des3_ede_cipher = {
 	}
 };
 
-struct skcipher_alg des3_ede_skciphers[] = {
+static struct skcipher_alg des3_ede_skciphers[] = {
 	{
 		.base.cra_name		= "ecb(des3_ede)",
 		.base.cra_driver_name	= "ecb-des3_ede-asm",
-- 
2.15.1
