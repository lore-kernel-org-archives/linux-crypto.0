From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH] crypto: omap-sham - Only release DMA channel if successfully
 requested
Date: Tue, 12 Nov 2013 13:12:27 -0700
Message-ID: <1384287147-19656-1-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Joel Fernandes <joelf@ti.com>,
 "Mark A. Greer" <mgreer@animalcreek.com>, linux-arm-kernel@lists.infradead.org,
 linux-omap@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Dan Carpenter <dan.carpenter@oracle.com>
To: linux-crypto@vger.kernel.org
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

In omap_sham_probe() and omap_sham_remove(), 'dd->dma_lch'
is released without checking to see if it was successfully
requested or not.  This is a bug and was identified and
reported by Dan Carpenter here:

	http://www.spinics.net/lists/devicetree/msg11023.html

Add code to only release 'dd->dma_lch' when its not NULL
(that is, when it was successfully requested).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
CC: Joel Fernandes <joelf@ti.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-sham.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e28104b..c6ad7d6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1970,7 +1970,8 @@ err_algs:
 			crypto_unregister_ahash(
 					&dd->pdata->algs_info[i].algs_list[j]);
 	pm_runtime_disable(dev);
-	dma_release_channel(dd->dma_lch);
+	if (dd->dma_lch)
+		dma_release_channel(dd->dma_lch);
 data_err:
 	dev_err(dev, "initialization failed.\n");
 
@@ -1994,7 +1995,9 @@ static int omap_sham_remove(struct platform_device *pdev)
 					&dd->pdata->algs_info[i].algs_list[j]);
 	tasklet_kill(&dd->done_task);
 	pm_runtime_disable(&pdev->dev);
-	dma_release_channel(dd->dma_lch);
+
+	if (dd->dma_lch)
+		dma_release_channel(dd->dma_lch);
 
 	return 0;
 }
-- 
1.8.3.4
