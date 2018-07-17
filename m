From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/6] crypto: stm32_crc32 - Use existing define with polynomial
Date: Tue, 17 Jul 2018 18:05:38 +0200
Message-ID: <20180717160541.3843-4-krzk@kernel.org>
References: <20180717160541.3843-1-krzk@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kern
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717160541.3843-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Do not define again the polynomial but use header with existing define.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
Not tested

It would be nice to get some testing. Only generic lib/crc, bunzip, xz_crc32
and Freescale's Ethernet driver were tested on HW.  Rest got just different
builds.


 drivers/crypto/stm32/stm32_crc32.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
index 040bed5e7725..29d2095d9dfd 100644
--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -6,6 +6,7 @@
 
 #include <linux/bitrev.h>
 #include <linux/clk.h>
+#include <linux/crc32poly.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
@@ -30,10 +31,6 @@
 #define CRC_CR_REVERSE          (BIT(7) | BIT(6) | BIT(5))
 #define CRC_INIT_DEFAULT        0xFFFFFFFF
 
-/* Polynomial reversed */
-#define POLY_CRC32              0xEDB88320
-#define POLY_CRC32C             0x82F63B78
-
 #define CRC_AUTOSUSPEND_DELAY	50
 
 struct stm32_crc {
@@ -70,7 +67,7 @@ static int stm32_crc32_cra_init(struct crypto_tfm *tfm)
 	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
 
 	mctx->key = CRC_INIT_DEFAULT;
-	mctx->poly = POLY_CRC32;
+	mctx->poly = CRC32_POLY_LE;
 	return 0;
 }
 
@@ -79,7 +76,7 @@ static int stm32_crc32c_cra_init(struct crypto_tfm *tfm)
 	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
 
 	mctx->key = CRC_INIT_DEFAULT;
-	mctx->poly = POLY_CRC32C;
+	mctx->poly = CRC32C_POLY_LE;
 	return 0;
 }
 
@@ -188,7 +185,7 @@ static int stm32_crc_final(struct shash_desc *desc, u8 *out)
 	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
 
 	/* Send computed CRC */
-	put_unaligned_le32(mctx->poly == POLY_CRC32C ?
+	put_unaligned_le32(mctx->poly == CRC32C_POLY_LE ?
 			   ~ctx->partial : ctx->partial, out);
 
 	return 0;
-- 
2.14.1
