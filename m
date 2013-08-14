From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 02/10] crypto: omap-aes: Add useful debug macros
Date: Wed, 14 Aug 2013 18:12:41 -0500
Message-ID: <1376521969-16807-3-git-send-email-joelf@ti.com>
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Joel Fernandes <joelf@ti.com>, Linux OMAP List <linux-omap@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>, "David S. Miller"
 <davem@davemloft.net>, Mark Greer <mgreer@animalcreek.com>, Tony Lindgren
 <tony@atomide.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Rajendra
 Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1376521969-16807-1-git-send-email-joelf@ti.com>
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

When DEBUG is enabled, these macros can be used to print variables
in integer and hex format, and clearly display which registers,
offsets and values are being read/written , including printing the
names of the offsets and their values.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ee15b0f..3838e0a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -15,6 +15,14 @@
 
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
+#ifdef DEBUG
+#define prn(num) printk(#num "=%d\n", num)
+#define prx(num) printk(#num "=%x\n", num)
+#else
+#define prn(num) do { } while (0)
+#define prx(num)  do { } while (0)
+#endif
+
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -172,13 +180,35 @@ struct omap_aes_dev {
 static LIST_HEAD(dev_list);
 static DEFINE_SPINLOCK(list_lock);
 
+#ifdef DEBUG
+#define omap_aes_read(dd, offset)					\
+	do {								\
+		omap_aes_read_1(dd, offset);				\
+		pr_debug("omap_aes_read(" #offset ")\n");		\
+	} while (0)
+
+static inline u32 omap_aes_read_1(struct omap_aes_dev *dd, u32 offset)
+#else
 static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
+#endif
 {
 	return __raw_readl(dd->io_base + offset);
 }
 
+#ifdef DEBUG
+#define omap_aes_write(dd, offset, value)				\
+	do {								\
+		pr_debug("omap_aes_write(" #offset "=%x) value=%d\n",	\
+			 offset, value);				\
+		omap_aes_write_1(dd, offset, value);			\
+	} while (0)
+
+static inline void omap_aes_write_1(struct omap_aes_dev *dd, u32 offset,
+				  u32 value)
+#else
 static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
 				  u32 value)
+#endif
 {
 	__raw_writel(value, dd->io_base + offset);
 }
-- 
1.7.9.5
