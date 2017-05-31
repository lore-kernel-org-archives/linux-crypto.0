From: <sean.wang@mediatek.com>
Subject: [PATCH 2/4] hwrng: mtk - add support for MT7622 SoC
Date: Thu, 1 Jun 2017 02:44:14 +0800
Message-ID: <2e2280eb36dbb00d3a7f56062889252f3e25a63d.1496255334.git.sean.wang@mediatek.com>
References: <cover.1496255334.git.sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, keyhaede@gmail.com,
 Sean Wang <sean.wang@mediatek.com>, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org,
 weiyongjun1@huawei.com, linux-arm-kernel@lists.infradead.org
To: <herbert@gondor.apana.org.au>, <mpm@selenic.com>, <robh+dt@kernel.org>,
 <mark.rutland@arm.com>, <clabbe.montjoie@gmail.com>,
 <prasannatsmkumar@gmail.com>, <romain.perier@free-electrons.com>,
 <shannon.nelson@oracle.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1496255334.git.sean.wang@mediatek.com>
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

From: Sean Wang <sean.wang@mediatek.com>

Add "mediatek,generic-rng" allowing most of RNG on MediaTek SoCs to be
compatible with the driver including MT7622 SoC.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/char/hw_random/mtk-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index df8eb54..3a1e1f1 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -148,6 +148,7 @@ static int mtk_rng_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id mtk_rng_match[] = {
+	{ .compatible = "mediatek,generic-rng" },
 	{ .compatible = "mediatek,mt7623-rng" },
 	{},
 };
-- 
1.9.1
