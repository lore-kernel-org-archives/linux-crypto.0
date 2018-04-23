From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 1/2] hwrng: stm32 - define default state for rng driver
Date: Mon, 23 Apr 2018 17:04:25 +0200
Message-ID: <20180423150426.22198-2-lionel.debieve@st.com>
References: <20180423150426.22198-1-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <rob.herring@linaro.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180423150426.22198-1-lionel.debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Define default state for stm32_rng driver. It will
be default selected with multi_v7_defconfig

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/char/hw_random/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index d53541e96bee..c34b257d852d 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -347,6 +347,7 @@ config HW_RANDOM_STM32
 	tristate "STMicroelectronics STM32 random number generator"
 	depends on HW_RANDOM && (ARCH_STM32 || COMPILE_TEST)
 	depends on HAS_IOMEM
+	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on STM32 microcontrollers.
-- 
2.15.1
