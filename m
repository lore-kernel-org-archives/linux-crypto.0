From: Lionel Debieve <lionel.Debieve@st.com>
Subject: [PATCH 1/3] crypto: stm32/hash: avoid error if maxburst not defined
Date: Mon, 29 Jan 2018 15:28:09 +0100
Message-ID: <20180129142811.13273-2-lionel.Debieve@st.com>
References: <20180129142811.13273-1-lionel.Debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ludovic Barre <ludovic.barre@st.com>,
 Lionel Debieve <lionel.debieve@st.com>,
 Benjamin Gaignard <benjamin.gaignard@st.com>,
 Fabien Dessenne <fabien.dessenne@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
 <davem@davemloft.net>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>,
 <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180129142811.13273-1-lionel.Debieve@st.com>
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

From: Lionel Debieve <lionel.debieve@st.com>

dma-maxburst is an optional value and must not return
error in case of dma not used (or max-burst not defined).

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 4ca4a264a833..73cdc3b4dca8 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1404,18 +1404,19 @@ MODULE_DEVICE_TABLE(of, stm32_hash_of_match);
 static int stm32_hash_get_of_match(struct stm32_hash_dev *hdev,
 				   struct device *dev)
 {
-	int err;
-
 	hdev->pdata = of_device_get_match_data(dev);
 	if (!hdev->pdata) {
 		dev_err(dev, "no compatible OF match\n");
 		return -EINVAL;
 	}
 
-	err = of_property_read_u32(dev->of_node, "dma-maxburst",
-				   &hdev->dma_maxburst);
+	if (of_property_read_u32(dev->of_node, "dma-maxburst",
+				 &hdev->dma_maxburst)) {
+		dev_info(dev, "dma-maxburst not specified, using 0\n");
+		hdev->dma_maxburst = 0;
+	}
 
-	return err;
+	return 0;
 }
 
 static int stm32_hash_probe(struct platform_device *pdev)
-- 
2.15.1
