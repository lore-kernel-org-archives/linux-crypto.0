From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 12/12] crypto: atmel-sha: add verbose debug facilities to print hw register names
Date: Thu, 22 Dec 2016 17:15:17 +0100
Message-ID: <27680e803a56bba3e5e458e769d0b9e7cca66de6.1482422983.git.cyrille.pitchen@atmel.com>
References: <cover.1482422983.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1482422983.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When VERBOSE_DEBUG is defined and SHA_FLAGS_DUMP_REG flag is set in
dd->flags, this patch prints the register names and values when performing
IO accesses.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 110 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 108 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index cc5294dbead4..22d0c0c118da 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -51,6 +51,7 @@
 #define SHA_FLAGS_INIT			BIT(4)
 #define SHA_FLAGS_CPU			BIT(5)
 #define SHA_FLAGS_DMA_READY		BIT(6)
+#define SHA_FLAGS_DUMP_REG	BIT(7)
 
 /* bits[11:8] are reserved. */
 
@@ -167,14 +168,118 @@ static struct atmel_sha_drv atmel_sha = {
 	.lock = __SPIN_LOCK_UNLOCKED(atmel_sha.lock),
 };
 
+#ifdef VERBOSE_DEBUG
+static const char *atmel_sha_reg_name(u32 offset, char *tmp, size_t sz, bool wr)
+{
+	switch (offset) {
+	case SHA_CR:
+		return "CR";
+
+	case SHA_MR:
+		return "MR";
+
+	case SHA_IER:
+		return "IER";
+
+	case SHA_IDR:
+		return "IDR";
+
+	case SHA_IMR:
+		return "IMR";
+
+	case SHA_ISR:
+		return "ISR";
+
+	case SHA_MSR:
+		return "MSR";
+
+	case SHA_BCR:
+		return "BCR";
+
+	case SHA_REG_DIN(0):
+	case SHA_REG_DIN(1):
+	case SHA_REG_DIN(2):
+	case SHA_REG_DIN(3):
+	case SHA_REG_DIN(4):
+	case SHA_REG_DIN(5):
+	case SHA_REG_DIN(6):
+	case SHA_REG_DIN(7):
+	case SHA_REG_DIN(8):
+	case SHA_REG_DIN(9):
+	case SHA_REG_DIN(10):
+	case SHA_REG_DIN(11):
+	case SHA_REG_DIN(12):
+	case SHA_REG_DIN(13):
+	case SHA_REG_DIN(14):
+	case SHA_REG_DIN(15):
+		snprintf(tmp, sz, "IDATAR[%u]", (offset - SHA_REG_DIN(0)) >> 2);
+		break;
+
+	case SHA_REG_DIGEST(0):
+	case SHA_REG_DIGEST(1):
+	case SHA_REG_DIGEST(2):
+	case SHA_REG_DIGEST(3):
+	case SHA_REG_DIGEST(4):
+	case SHA_REG_DIGEST(5):
+	case SHA_REG_DIGEST(6):
+	case SHA_REG_DIGEST(7):
+	case SHA_REG_DIGEST(8):
+	case SHA_REG_DIGEST(9):
+	case SHA_REG_DIGEST(10):
+	case SHA_REG_DIGEST(11):
+	case SHA_REG_DIGEST(12):
+	case SHA_REG_DIGEST(13):
+	case SHA_REG_DIGEST(14):
+	case SHA_REG_DIGEST(15):
+		if (wr)
+			snprintf(tmp, sz, "IDATAR[%u]",
+				 16u + ((offset - SHA_REG_DIGEST(0)) >> 2));
+		else
+			snprintf(tmp, sz, "ODATAR[%u]",
+				 (offset - SHA_REG_DIGEST(0)) >> 2);
+		break;
+
+	case SHA_HW_VERSION:
+		return "HWVER";
+
+	default:
+		snprintf(tmp, sz, "0x%02x", offset);
+		break;
+	}
+
+	return tmp;
+}
+
+#endif /* VERBOSE_DEBUG */
+
 static inline u32 atmel_sha_read(struct atmel_sha_dev *dd, u32 offset)
 {
-	return readl_relaxed(dd->io_base + offset);
+	u32 value = readl_relaxed(dd->io_base + offset);
+
+#ifdef VERBOSE_DEBUG
+	if (dd->flags & SHA_FLAGS_DUMP_REG) {
+		char tmp[16];
+
+		dev_vdbg(dd->dev, "read 0x%08x from %s\n", value,
+			 atmel_sha_reg_name(offset, tmp, sizeof(tmp), false));
+	}
+#endif /* VERBOSE_DEBUG */
+
+	return value;
 }
 
 static inline void atmel_sha_write(struct atmel_sha_dev *dd,
 					u32 offset, u32 value)
 {
+#ifdef VERBOSE_DEBUG
+	if (dd->flags & SHA_FLAGS_DUMP_REG) {
+		char tmp[16];
+
+		dev_vdbg(dd->dev, "write 0x%08x into %s\n", value,
+			 atmel_sha_reg_name(offset, tmp, sizeof(tmp), true));
+	}
+#endif /* VERBOSE_DEBUG */
+
 	writel_relaxed(value, dd->io_base + offset);
 }
 
@@ -183,7 +288,8 @@ static inline int atmel_sha_complete(struct atmel_sha_dev *dd, int err)
 	struct ahash_request *req = dd->req;
 
 	dd->flags &= ~(SHA_FLAGS_BUSY | SHA_FLAGS_FINAL | SHA_FLAGS_CPU |
-		       SHA_FLAGS_DMA_READY | SHA_FLAGS_OUTPUT_READY);
+		       SHA_FLAGS_DMA_READY | SHA_FLAGS_OUTPUT_READY |
+		       SHA_FLAGS_DUMP_REG);
 
 	clk_disable(dd->iclk);
 
-- 
2.7.4
