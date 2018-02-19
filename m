From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH] crypto: marvell/cesa - Clean up redundant #include
Date: Mon, 19 Feb 2018 13:55:36 +0000
Message-ID: <99d8deb60039adf572aec26b091f2b0c61edf397.1519048413.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: boris.brezillon@free-electrons.com, arno@natisbad.org,
 herbert@gondor.apana.org.au, davem@davemloft.net
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

The inclusion of dma-direct.h was only needed temporarily to prevent
breakage from the DMA API rework, since the actual CESA fix making it
redundant was merged in parallel. Now that both have landed, it can go.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 drivers/crypto/marvell/cesa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index aca2373fa1de..f81fa4a3e66b 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -25,7 +25,6 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/dma-direct.h> /* XXX: drivers shall never use this directly! */
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
-- 
2.16.1.dirty
