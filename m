From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] crypto: sahara: fix debug output for 64-bit dma_addr_t
Date: Tue, 08 Dec 2015 16:24:22 +0100
Message-ID: <2836331.cLKdbzEk5h@wuerfel>
References: <1707164.bU6CqSGiie@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1707164.bU6CqSGiie@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sahara_dump_descriptors and sahara_dump_links functions attempt
to print a dma_addr_t value with a 0x%08x format string, which
produces a warning when dma_addr_t is 64-bit wide:

drivers/crypto/sahara.c:419:120: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]

This changes the code to use the %pad format string that is meant
for dma_addr_t, which avoids the warning and gives us the correct
output in all configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/sahara.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 38bf12ae5589..6c4f91c5e6b3 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -416,8 +416,8 @@ static void sahara_dump_descriptors(struct sahara_dev *dev)
 		return;
 
 	for (i = 0; i < SAHARA_MAX_HW_DESC; i++) {
-		dev_dbg(dev->device, "Descriptor (%d) (0x%08x):\n",
-			i, dev->hw_phys_desc[i]);
+		dev_dbg(dev->device, "Descriptor (%d) (%pad):\n",
+			i, &dev->hw_phys_desc[i]);
 		dev_dbg(dev->device, "\thdr = 0x%08x\n", dev->hw_desc[i]->hdr);
 		dev_dbg(dev->device, "\tlen1 = %u\n", dev->hw_desc[i]->len1);
 		dev_dbg(dev->device, "\tp1 = 0x%08x\n", dev->hw_desc[i]->p1);
@@ -437,8 +437,8 @@ static void sahara_dump_links(struct sahara_dev *dev)
 		return;
 
 	for (i = 0; i < SAHARA_MAX_HW_LINK; i++) {
-		dev_dbg(dev->device, "Link (%d) (0x%08x):\n",
-			i, dev->hw_phys_link[i]);
+		dev_dbg(dev->device, "Link (%d) (%pad):\n",
+			i, &dev->hw_phys_link[i]);
 		dev_dbg(dev->device, "\tlen = %u\n", dev->hw_link[i]->len);
 		dev_dbg(dev->device, "\tp = 0x%08x\n", dev->hw_link[i]->p);
 		dev_dbg(dev->device, "\tnext = 0x%08x\n",
-- 
2.1.0.rc2
