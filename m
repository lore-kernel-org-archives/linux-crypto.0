From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH Resend 5/5] hwrng: stm32 - rework read timeout calculation
Date: Thu, 15 Feb 2018 14:03:12 +0100
Message-ID: <20180215130312.23612-6-lionel.debieve@st.com>
References: <20180215130312.23612-1-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
 Ludovic Barre <ludovic.barre@st.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>, Rob Herring
 <rob.herring@linaro.org>, <linux-crypto@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180215130312.23612-1-lionel.debieve@st.com>
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

Increase timeout delay to support longer timing linked
to rng initialization. Measurement is based on timer instead
of instructions per iteration which is not powerful on all
targets.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/char/hw_random/stm32-rng.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 709a8d061be3..0d2328da3b76 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
@@ -35,15 +36,6 @@
 
 #define RNG_DR 0x08
 
-/*
- * It takes 40 cycles @ 48MHz to generate each random number (e.g. <1us).
- * At the time of writing STM32 parts max out at ~200MHz meaning a timeout
- * of 500 leaves us a very comfortable margin for error. The loop to which
- * the timeout applies takes at least 4 instructions per iteration so the
- * timeout is enough to take us up to multi-GHz parts!
- */
-#define RNG_TIMEOUT 500
-
 struct stm32_rng_private {
 	struct hwrng rng;
 	void __iomem *base;
@@ -63,13 +55,16 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 	while (max > sizeof(u32)) {
 		sr = readl_relaxed(priv->base + RNG_SR);
+		/* Manage timeout which is based on timer and take */
+		/* care of initial delay time when enabling rng	*/
 		if (!sr && wait) {
-			unsigned int timeout = RNG_TIMEOUT;
-
-			do {
-				cpu_relax();
-				sr = readl_relaxed(priv->base + RNG_SR);
-			} while (!sr && --timeout);
+			retval = readl_relaxed_poll_timeout_atomic(priv->base
+								   + RNG_SR,
+								   sr, sr,
+								   10, 50000);
+			if (retval)
+				dev_err((struct device *)priv->rng.priv,
+					"%s: timeout %x!\n", __func__, sr);
 		}
 
 		/* If error detected or data not ready... */
-- 
2.15.1
