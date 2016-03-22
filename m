From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 3/3] crypto: s5p-sss - Sort the headers to improve
 readability
Date: Tue, 22 Mar 2016 10:58:25 +0900
Message-ID: <1458611905-30157-3-git-send-email-k.kozlowski@samsung.com>
References: <1458611905-30157-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vladimir Zapolskiy <vz@mleia.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1458611905-30157-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sort the headers alphabetically to improve readability and to spot
duplications easier.

Suggested-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>

---

Changes since v2:
1. Add Vladimir's acked-by.

Changes since v1:
1. New patch.

My email differs from one used in previous patches because this time I
am sending this from work.
---
 drivers/crypto/s5p-sss.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 3730fb0af4d8..4f6d5b3ec418 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -11,23 +11,23 @@
  *
  */
 
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-mapping.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/crypto.h>
-#include <linux/interrupt.h>
 
-#include <crypto/algapi.h>
-#include <crypto/aes.h>
 #include <crypto/ctr.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 
 #define _SBF(s, v)                      ((v) << (s))
-- 
2.5.0
