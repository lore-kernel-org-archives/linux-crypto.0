From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm64/sm4-ce - check for the right CPU feature bit
Date: Tue,  7 Aug 2018 23:18:36 +0200
Message-ID: <20180807211836.9899-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

ARMv8.2 specifies special instructions for the SM3 cryptographic hash
and the SM4 symmetric cipher. While it is unlikely that a core would
implement one and not the other, we should only use SM4 instructions
if the SM4 CPU feature bit is set, and we currently check the SM3
feature bit instead. So fix that.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
It would be good to get this backported to -stable but there is no
need to merge this as a fix at -rc8

 arch/arm64/crypto/sm4-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index b7fb5274b250..0c4fc223f225 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -69,5 +69,5 @@ static void __exit sm4_ce_mod_fini(void)
 	crypto_unregister_alg(&sm4_ce_alg);
 }
 
-module_cpu_feature_match(SM3, sm4_ce_mod_init);
+module_cpu_feature_match(SM4, sm4_ce_mod_init);
 module_exit(sm4_ce_mod_fini);
-- 
2.18.0
