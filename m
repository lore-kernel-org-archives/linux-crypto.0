From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] crypto: sahara: fix 64-bit dma_addr_t compilation
Date: Tue, 08 Dec 2015 16:23:51 +0100
Message-ID: <1707164.bU6CqSGiie@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sahara hardware uses DMA descriptors with 32-bit addresses, but
dma_addr_t is variable size depending on whether we want to support
any devices that use 64-bit DMA addresses in hardware.
This means that the definition of the DMA descriptor structure is wrong,
and we helpfully get a compiler warning about them too:

drivers/crypto/sahara.c:423:372: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]

This changes the definition of the sahara_hw_desc and sahara_hw_link
structures to only contain fixed-length members, which is required
to make the driver work on ARM LPAE mode, and avoids most of the
gcc warnings we get.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/sahara.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index cc738f3592a3..38bf12ae5589 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -130,18 +130,18 @@
 #define SAHARA_REG_IDAR		0x20
 
 struct sahara_hw_desc {
-	u32		hdr;
-	u32		len1;
-	dma_addr_t	p1;
-	u32		len2;
-	dma_addr_t	p2;
-	dma_addr_t	next;
+	u32	hdr;
+	u32	len1;
+	u32	p1;
+	u32	len2;
+	u32	p2;
+	u32	next;
 };
 
 struct sahara_hw_link {
-	u32		len;
-	dma_addr_t	p;
-	dma_addr_t	next;
+	u32	len;
+	u32	p;
+	u32	next;
 };
 
 struct sahara_ctx {
-- 
2.1.0.rc2
