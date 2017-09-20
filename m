From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: stm32: use of_device_get_match_data
Date: Wed, 20 Sep 2017 20:31:40 +0200
Message-ID: <20170920183140.17018-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The usage of of_device_get_match_data reduce the code size a bit.
Furthermore, it prevents an improbable dereference when
of_match_device() return NULL.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/stm32/stm32-hash.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index b585ce54a802..1d9285c62606 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1408,11 +1408,10 @@ MODULE_DEVICE_TABLE(of, stm32_hash_of_match);
 static int stm32_hash_get_of_match(struct stm32_hash_dev *hdev,
 				   struct device *dev)
 {
-	const struct of_device_id *match;
 	int err;
 
-	match = of_match_device(stm32_hash_of_match, dev);
-	if (!match) {
+	hdev->pdata = of_device_get_match_data(dev);
+	if (!hdev->pdata) {
 		dev_err(dev, "no compatible OF match\n");
 		return -EINVAL;
 	}
@@ -1420,8 +1419,6 @@ static int stm32_hash_get_of_match(struct stm32_hash_dev *hdev,
 	err = of_property_read_u32(dev->of_node, "dma-maxburst",
 				   &hdev->dma_maxburst);
 
-	hdev->pdata = match->data;
-
 	return err;
 }
 
-- 
2.13.5
