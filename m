From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 24/24] crypto: atmel-aes: add debug facilities to monitor register accesses.
Date: Thu, 17 Dec 2015 18:13:08 +0100
Message-ID: <0ab25d7062ba672f0fc3fe0e352c2bd8415f9e08.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This feature should not be enabled in release but can be usefull for
developers who need to monitor register accesses at some specific places.
Set the AES_FLAGS_DUMP_REG flag inside dd->flags to start monitoring the
I/O accesses, clear it to stop monitoring.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 115 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 0a37e5683c80..5621612ee921 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -75,6 +75,7 @@
 
 #define AES_FLAGS_INIT		BIT(2)
 #define AES_FLAGS_BUSY		BIT(3)
+#define AES_FLAGS_DUMP_REG	BIT(4)
 
 #define AES_FLAGS_PERSISTENT	(AES_FLAGS_INIT | AES_FLAGS_BUSY)
 
@@ -197,16 +198,128 @@ static struct atmel_aes_drv atmel_aes = {
 	.lock = __SPIN_LOCK_UNLOCKED(atmel_aes.lock),
 };
 
+#ifdef VERBOSE_DEBUG
+static const char *atmel_aes_reg_name(u32 offset, char *tmp, size_t sz)
+{
+	switch (offset) {
+	case AES_CR:
+		return "CR";
+
+	case AES_MR:
+		return "MR";
+
+	case AES_ISR:
+		return "ISR";
+
+	case AES_IMR:
+		return "IMR";
+
+	case AES_IER:
+		return "IER";
+
+	case AES_IDR:
+		return "IDR";
+
+	case AES_KEYWR(0):
+	case AES_KEYWR(1):
+	case AES_KEYWR(2):
+	case AES_KEYWR(3):
+	case AES_KEYWR(4):
+	case AES_KEYWR(5):
+	case AES_KEYWR(6):
+	case AES_KEYWR(7):
+		snprintf(tmp, sz, "KEYWR[%u]", (offset - AES_KEYWR(0)) >> 2);
+		break;
+
+	case AES_IDATAR(0):
+	case AES_IDATAR(1):
+	case AES_IDATAR(2):
+	case AES_IDATAR(3):
+		snprintf(tmp, sz, "IDATAR[%u]", (offset - AES_IDATAR(0)) >> 2);
+		break;
+
+	case AES_ODATAR(0):
+	case AES_ODATAR(1):
+	case AES_ODATAR(2):
+	case AES_ODATAR(3):
+		snprintf(tmp, sz, "ODATAR[%u]", (offset - AES_ODATAR(0)) >> 2);
+		break;
+
+	case AES_IVR(0):
+	case AES_IVR(1):
+	case AES_IVR(2):
+	case AES_IVR(3):
+		snprintf(tmp, sz, "IVR[%u]", (offset - AES_IVR(0)) >> 2);
+		break;
+
+	case AES_AADLENR:
+		return "AADLENR";
+
+	case AES_CLENR:
+		return "CLENR";
+
+	case AES_GHASHR(0):
+	case AES_GHASHR(1):
+	case AES_GHASHR(2):
+	case AES_GHASHR(3):
+		snprintf(tmp, sz, "GHASHR[%u]", (offset - AES_GHASHR(0)) >> 2);
+		break;
+
+	case AES_TAGR(0):
+	case AES_TAGR(1):
+	case AES_TAGR(2):
+	case AES_TAGR(3):
+		snprintf(tmp, sz, "TAGR[%u]", (offset - AES_TAGR(0)) >> 2);
+		break;
+
+	case AES_CTRR:
+		return "CTRR";
+
+	case AES_GCMHR(0):
+	case AES_GCMHR(1):
+	case AES_GCMHR(2):
+	case AES_GCMHR(3):
+		snprintf(tmp, sz, "GCMHR[%u]", (offset - AES_GCMHR(0)) >> 2);
+
+	default:
+		snprintf(tmp, sz, "0x%02x", offset);
+		break;
+	}
+
+	return tmp;
+}
+#endif /* VERBOSE_DEBUG */
+
 /* Shared functions */
 
 static inline u32 atmel_aes_read(struct atmel_aes_dev *dd, u32 offset)
 {
-	return readl_relaxed(dd->io_base + offset);
+	u32 value = readl_relaxed(dd->io_base + offset);
+
+#ifdef VERBOSE_DEBUG
+	if (dd->flags & AES_FLAGS_DUMP_REG) {
+		char tmp[16];
+
+		dev_vdbg(dd->dev, "read 0x%08x from %s\n", value,
+			 atmel_aes_reg_name(offset, tmp, sizeof(tmp)));
+	}
+#endif /* VERBOSE_DEBUG */
+
+	return value;
 }
 
 static inline void atmel_aes_write(struct atmel_aes_dev *dd,
 					u32 offset, u32 value)
 {
+#ifdef VERBOSE_DEBUG
+	if (dd->flags & AES_FLAGS_DUMP_REG) {
+		char tmp[16];
+
+		dev_vdbg(dd->dev, "write 0x%08x into %s\n", value,
+			 atmel_aes_reg_name(offset, tmp));
+	}
+#endif /* VERBOSE_DEBUG */
+
 	writel_relaxed(value, dd->io_base + offset);
 }
 
-- 
1.8.2.2
