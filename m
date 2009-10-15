From: Vishnu Suresh <Vishnu@freescale.com>
Subject: [PATCH v0 1/2] DMA: fsldma: Disable DMA_INTERRUPT when Async_tx
	enabled
Date: Thu, 15 Oct 2009 12:11:05 +0530
Message-ID: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Vishnu Suresh <Vishnu@freescale.com>
To: linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	herbert@gondor.apana.org.au, dan.j.williams@intel.com
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

This patch disables the use of DMA_INTERRUPT capability with Async_tx

The fsldma produces a null transfer with DMA_INTERRUPT
capability when used with Async_tx. When RAID devices queue
a transaction via Async_tx, this  results in a hang.

Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
---
 drivers/dma/fsldma.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 296f9e7..66d9b39 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1200,7 +1200,13 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 						- fdev->reg.start + 1);
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
+#ifndef CONFIG_ASYNC_CORE
+	/*
+	 * The DMA_INTERRUPT async_tx is a NULL transfer, which will
+	 * triger a PE interrupt.
+	 */
 	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
+#endif
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
-- 
1.6.4.2
