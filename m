From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 05/22] hw_random: Fix dependencies for !HAS_IOMEM archs
Date: Mon, 25 Jan 2016 23:24:04 +0100
Message-ID: <1453760661-1444-6-git-send-email-richard@nod.at>
References: <1453760661-1444-1-git-send-email-richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
	Richard Weinberger <richard@nod.at>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lee Jones <lee.jones@linaro.org>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Pankaj Dev <pankaj.dev@st.com>, Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453760661-1444-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Not every arch has io memory.
So, unbreak the build by fixing the dependencies.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/char/hw_random/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index dbf2271..ff00331 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -372,6 +372,7 @@ config HW_RANDOM_XGENE
 config HW_RANDOM_STM32
 	tristate "STMicroelectronics STM32 random number generator"
 	depends on HW_RANDOM && (ARCH_STM32 || COMPILE_TEST)
+	depends on HAS_IOMEM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on STM32 microcontrollers.
-- 
1.8.4.5
