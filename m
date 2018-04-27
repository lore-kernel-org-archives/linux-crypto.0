From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: ghash-clmulni: fix spelling mistake: "acclerated" -> "accelerated"
Date: Fri, 27 Apr 2018 19:08:05 +0100
Message-ID: <20180427180805.15536-1-colin.king@canonical.com>
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

Trivial fix to spelling mistake in module description text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 0420bab19efb..2ddbe3a1868b 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -364,5 +364,5 @@ module_exit(ghash_pclmulqdqni_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("GHASH Message Digest Algorithm, "
-		   "acclerated by PCLMULQDQ-NI");
+		   "accelerated by PCLMULQDQ-NI");
 MODULE_ALIAS_CRYPTO("ghash");
-- 
2.17.0
