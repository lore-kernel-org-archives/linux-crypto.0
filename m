From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 07/10] crypto: omap-aes: Add IRQ info and helper macros
Date: Wed, 14 Aug 2013 18:12:46 -0500
Message-ID: <1376521969-16807-8-git-send-email-joelf@ti.com>
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

Add IRQ information to pdata and helper macros. These are
required for PIO-mode support.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 71da52b..c057eac 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -82,6 +82,10 @@
 
 #define AES_REG_LENGTH_N(x)		(0x54 + ((x) * 0x04))
 
+#define AES_REG_IRQ_STATUS(dd)         ((dd)->pdata->irq_status_ofs)
+#define AES_REG_IRQ_ENABLE(dd)         ((dd)->pdata->irq_enable_ofs)
+#define AES_REG_IRQ_DATA_IN            BIT(1)
+#define AES_REG_IRQ_DATA_OUT           BIT(2)
 #define DEFAULT_TIMEOUT		(5*HZ)
 
 #define FLAGS_MODE_MASK		0x000f
@@ -127,6 +131,8 @@ struct omap_aes_pdata {
 	u32		data_ofs;
 	u32		rev_ofs;
 	u32		mask_ofs;
+	u32             irq_enable_ofs;
+	u32             irq_status_ofs;
 
 	u32		dma_enable_in;
 	u32		dma_enable_out;
@@ -846,6 +852,8 @@ static const struct omap_aes_pdata omap_aes_pdata_omap4 = {
 	.data_ofs	= 0x60,
 	.rev_ofs	= 0x80,
 	.mask_ofs	= 0x84,
+	.irq_status_ofs = 0x8c,
+	.irq_enable_ofs = 0x90,
 	.dma_enable_in	= BIT(5),
 	.dma_enable_out	= BIT(6),
 	.major_mask	= 0x0700,
-- 
1.7.9.5
