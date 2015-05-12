From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/8] dmaengine: mv_xor: Enlarge descriptor pool size
Date: Tue, 12 May 2015 17:37:38 +0200
Message-ID: <1431445063-20226-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lior Amsalem <alior@marvell.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Thomas Petazzoni <thomas@free-electrons.com>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 Maxime Ripard <maxime.ripard@free-electrons.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Gregory Clement <gregory.clement@free-electrons.com>,
 Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
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

From: Lior Amsalem <alior@marvell.com>

Now that we have 2 channels assigned to 2 CPUs and all requests are chained
on same channels, we need much more descriptors available to satisfy
async_tx workload.

3072 descriptors was found in our lab as the number of descriptors which
allow the async_tx stack to work without waiting for free descriptors on
submission of new requests.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Reviewed-by: Nadav Haklai <nadavh@marvell.com>
Tested-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mv_xor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index 89a8c85539a1..145ba2f895f7 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -19,7 +19,7 @@
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
 
-#define MV_XOR_POOL_SIZE		PAGE_SIZE
+#define MV_XOR_POOL_SIZE		(MV_XOR_SLOT_SIZE * 3072)
 #define MV_XOR_SLOT_SIZE		64
 #define MV_XOR_THRESHOLD		1
 #define MV_XOR_MAX_CHANNELS             2
-- 
2.4.0
