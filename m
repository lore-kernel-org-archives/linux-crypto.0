From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 1/3] clk: meson-gxbb: expose clock CLKID_RNG0
Date: Wed, 22 Feb 2017 07:55:24 +0100
Message-ID: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-clk@vger.kernel.org, devicetree@vger.kernel.org
To: Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35408 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751349AbdBVGzf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2017 01:55:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Expose clock CLKID_RNG0 which is needed for the HW random number generator.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- added clk and DT maintainers
- split exposing the clock and using it in DT into two patches
- comment out clock definition in drivers/clk/meson/gxbb.h
- silently move CLKID_SPI to the right place
v3:
- no changes
---
 drivers/clk/meson/gxbb.h              | 2 +-
 include/dt-bindings/clock/gxbb-clkc.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/meson/gxbb.h b/drivers/clk/meson/gxbb.h
index 8ee2022c..cbd62e46 100644
--- a/drivers/clk/meson/gxbb.h
+++ b/drivers/clk/meson/gxbb.h
@@ -193,7 +193,7 @@
 /* CLKID_I2C */
 /* #define CLKID_SAR_ADC */
 #define CLKID_SMART_CARD	  24
-#define CLKID_RNG0		  25
+/* CLKID_RNG0 */
 #define CLKID_UART0		  26
 #define CLKID_SDHC		  27
 #define CLKID_STREAM		  28
diff --git a/include/dt-bindings/clock/gxbb-clkc.h b/include/dt-bindings/clock/gxbb-clkc.h
index 692846c7..63f4c2c4 100644
--- a/include/dt-bindings/clock/gxbb-clkc.h
+++ b/include/dt-bindings/clock/gxbb-clkc.h
@@ -12,9 +12,10 @@
 #define CLKID_FCLK_DIV4		6
 #define CLKID_CLK81		12
 #define CLKID_MPLL2		15
-#define CLKID_SPI		34
 #define CLKID_I2C		22
 #define CLKID_SAR_ADC		23
+#define CLKID_RNG0		25
+#define CLKID_SPI		34
 #define CLKID_ETH		36
 #define CLKID_USB0		50
 #define CLKID_USB1		51
-- 
2.11.1
