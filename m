From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 03/17] crypto: talitos - talitos_ptr renamed ptr for more
 lisibility
Date: Fri, 17 Apr 2015 16:31:53 +0200 (CEST)
Message-ID: <20150417143153.420FD1A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Linux CodyingStyle recommends to use short variables for local
variables. ptr is just good enough for those 3 lines functions.
It helps keep single lines shorter than 80 characters.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 5a7e345..fca0aed 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -55,37 +55,37 @@
 
 #include "talitos.h"
 
-static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_addr_t dma_addr)
+static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
 {
-	talitos_ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	talitos_ptr->eptr = upper_32_bits(dma_addr);
+	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	ptr->eptr = upper_32_bits(dma_addr);
 }
 
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
 static void map_single_talitos_ptr(struct device *dev,
-				   struct talitos_ptr *talitos_ptr,
+				   struct talitos_ptr *ptr,
 				   unsigned short len, void *data,
 				   unsigned char extent,
 				   enum dma_data_direction dir)
 {
 	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
 
-	talitos_ptr->len = cpu_to_be16(len);
-	to_talitos_ptr(talitos_ptr, dma_addr);
-	talitos_ptr->j_extent = extent;
+	ptr->len = cpu_to_be16(len);
+	to_talitos_ptr(ptr, dma_addr);
+	ptr->j_extent = extent;
 }
 
 /*
  * unmap bus single (contiguous) h/w descriptor pointer
  */
 static void unmap_single_talitos_ptr(struct device *dev,
-				     struct talitos_ptr *talitos_ptr,
+				     struct talitos_ptr *ptr,
 				     enum dma_data_direction dir)
 {
-	dma_unmap_single(dev, be32_to_cpu(talitos_ptr->ptr),
-			 be16_to_cpu(talitos_ptr->len), dir);
+	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
+			 be16_to_cpu(ptr->len), dir);
 }
 
 static int reset_channel(struct device *dev, int ch)
-- 
2.1.0
