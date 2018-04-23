From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 2/2] hwrng: stm32-rng - fix pm_suspend issue
Date: Mon, 23 Apr 2018 17:04:26 +0200
Message-ID: <20180423150426.22198-3-lionel.debieve@st.com>
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

When suspend is called after pm_runtime_suspend,
same callback is used and access to rng register is
freezing system. By calling the pm_runtime_force_suspend,
it first checks that runtime has been already done.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/char/hw_random/stm32-rng.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 0d2328da3b76..042860d97b15 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -187,8 +187,13 @@ static int stm32_rng_runtime_resume(struct device *dev)
 }
 #endif
 
-static UNIVERSAL_DEV_PM_OPS(stm32_rng_pm_ops, stm32_rng_runtime_suspend,
-			    stm32_rng_runtime_resume, NULL);
+static const struct dev_pm_ops stm32_rng_pm_ops = {
+	SET_RUNTIME_PM_OPS(stm32_rng_runtime_suspend,
+			   stm32_rng_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+};
+
 
 static const struct of_device_id stm32_rng_match[] = {
 	{
-- 
2.15.1
