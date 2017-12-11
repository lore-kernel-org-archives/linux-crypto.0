From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: stm32: fix modular build
Date: Mon, 11 Dec 2017 12:47:32 +0100
Message-ID: <20171211114752.3637710-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Fabien DESSENNE <fabien.dessenne@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Building the stm32 crypto suport as a loadable module causes a build
failure from a simple typo:

drivers/crypto/stm32/stm32-cryp.c:1035:25: error: 'sti_dt_ids' undeclared here (not in a function); did you mean 'stm32_dt_ids'?

This renames the reference to point to the correct symbol.

Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 459755940632..cf1dddbeaa2c 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1032,7 +1032,7 @@ static const struct of_device_id stm32_dt_ids[] = {
 	{ .compatible = "st,stm32f756-cryp", },
 	{},
 };
-MODULE_DEVICE_TABLE(of, sti_dt_ids);
+MODULE_DEVICE_TABLE(of, stm32_dt_ids);
 
 static int stm32_cryp_probe(struct platform_device *pdev)
 {
-- 
2.9.0
