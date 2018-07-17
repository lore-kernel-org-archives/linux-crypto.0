From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4/6] net: ethernet: Use existing define with polynomial
Date: Tue, 17 Jul 2018 18:05:39 +0200
Message-ID: <20180717160541.3843-5-krzk@kernel.org>
References: <20180717160541.3843-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Siva Reddy Kallam <siva.kallam@broadcom.com>,
 Prashant Sreedharan <prashant@broadcom.com>,
 Michael Chan <mchan@broadcom.com>, Fugang Duan <fugang.duan@nxp.com>,
 Pantelis Antoniou <pantelis.antoniou@gmail.com>,
 Vitaly Bordug <vbordug@ru.mvista.com>,
 Jose Abreu <Jose.Abreu@synopsys.com>,
 Larry Finger <Larry.Finger@lwfinger.net>,
 Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 devel@driverdev.osuosl.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180717160541.3843-1-krzk@kernel.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Do not define again the polynomial but use header with existing define.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
Only Freescale FEC was tested

It would be nice to get some testing. Only generic lib/crc, bunzip, xz_crc32
and Freescale's Ethernet driver were tested on HW.  Rest got just different
builds.

 drivers/net/ethernet/amd/xgbe/xgbe-dev.c         | 4 ++--
 drivers/net/ethernet/apple/bmac.c                | 8 ++------
 drivers/net/ethernet/broadcom/tg3.c              | 3 ++-
 drivers/net/ethernet/freescale/fec_main.c        | 4 ++--
 drivers/net/ethernet/freescale/fs_enet/fec.h     | 3 ---
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c | 3 ++-
 drivers/net/ethernet/micrel/ks8851_mll.c         | 3 ++-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c    | 4 ++--
 8 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index e107e180e2c8..1e929a1e4ca7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -119,6 +119,7 @@
 #include <linux/clk.h>
 #include <linux/bitrev.h>
 #include <linux/crc32.h>
+#include <linux/crc32poly.h>
 
 #include "xgbe.h"
 #include "xgbe-common.h"
@@ -887,7 +888,6 @@ static int xgbe_disable_rx_vlan_filtering(struct xgbe_prv_data *pdata)
 
 static u32 xgbe_vid_crc32_le(__le16 vid_le)
 {
-	u32 poly = 0xedb88320;	/* CRCPOLY_LE */
 	u32 crc = ~0;
 	u32 temp = 0;
 	unsigned char *data = (unsigned char *)&vid_le;
@@ -904,7 +904,7 @@ static u32 xgbe_vid_crc32_le(__le16 vid_le)
 		data_byte >>= 1;
 
 		if (temp)
-			crc ^= poly;
+			crc ^= CRC32_POLY_LE;
 	}
 
 	return crc;
diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index 5a655d289dd5..024998d6d8c6 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/crc32.h>
+#include <linux/crc32poly.h>
 #include <linux/bitrev.h>
 #include <linux/ethtool.h>
 #include <linux/slab.h>
@@ -37,11 +38,6 @@
 #define trunc_page(x)	((void *)(((unsigned long)(x)) & ~((unsigned long)(PAGE_SIZE - 1))))
 #define round_page(x)	trunc_page(((unsigned long)(x)) + ((unsigned long)(PAGE_SIZE - 1)))
 
-/*
- * CRC polynomial - used in working out multicast filter bits.
- */
-#define ENET_CRCPOLY 0x04c11db7
-
 /* switch to use multicast code lifted from sunhme driver */
 #define SUNHME_MULTICAST
 
@@ -838,7 +834,7 @@ crc416(unsigned int curval, unsigned short nxtval)
 		next = next >> 1;
 
 		/* do the XOR */
-		if (high_crc_set ^ low_data_set) cur = cur ^ ENET_CRCPOLY;
+		if (high_crc_set ^ low_data_set) cur = cur ^ CRC32_POLY_BE;
 	}
 	return cur;
 }
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 0a796d5ec893..3d526d99ac59 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -50,6 +50,7 @@
 #include <linux/ssb/ssb_driver_gige.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/crc32poly.h>
 
 #include <net/checksum.h>
 #include <net/ip.h>
@@ -9709,7 +9710,7 @@ static inline u32 calc_crc(unsigned char *buf, int len)
 			reg >>= 1;
 
 			if (tmp)
-				reg ^= 0xedb88320;
+				reg ^= CRC32_POLY_LE;
 		}
 	}
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c729665107f5..a7cb378ef881 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -48,6 +48,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/clk.h>
+#include <linux/crc32poly.h>
 #include <linux/platform_device.h>
 #include <linux/mdio.h>
 #include <linux/phy.h>
@@ -2949,7 +2950,6 @@ fec_enet_close(struct net_device *ndev)
  */
 
 #define FEC_HASH_BITS	6		/* #bits in hash */
-#define CRC32_POLY	0xEDB88320
 
 static void set_multicast_list(struct net_device *ndev)
 {
@@ -2989,7 +2989,7 @@ static void set_multicast_list(struct net_device *ndev)
 			data = ha->addr[i];
 			for (bit = 0; bit < 8; bit++, data >>= 1) {
 				crc = (crc >> 1) ^
-				(((crc ^ data) & 1) ? CRC32_POLY : 0);
+				(((crc ^ data) & 1) ? CRC32_POLY_LE : 0);
 			}
 		}
 
diff --git a/drivers/net/ethernet/freescale/fs_enet/fec.h b/drivers/net/ethernet/freescale/fs_enet/fec.h
index 7832db71dcb9..1dbee5d898b3 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fec.h
+++ b/drivers/net/ethernet/freescale/fs_enet/fec.h
@@ -2,9 +2,6 @@
 #ifndef FS_ENET_FEC_H
 #define FS_ENET_FEC_H
 
-/* CRC polynomium used by the FEC for the multicast group filtering */
-#define FEC_CRC_POLY   0x04C11DB7
-
 #define FEC_MAX_MULTICAST_ADDRS	64
 
 /* Interrupt events/masks.
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
index 1fc27c97e3b2..05093e5fc9dd 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
+#include <linux/crc32poly.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -187,7 +188,7 @@ static void set_multicast_one(struct net_device *dev, const u8 *mac)
 			msb = crc >> 31;
 			crc <<= 1;
 			if (msb ^ (byte & 0x1))
-				crc ^= FEC_CRC_POLY;
+				crc ^= CRC32_POLY_BE;
 			byte >>= 1;
 		}
 	}
diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index f3e9dd47b56f..0e9719fbc624 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -30,6 +30,7 @@
 #include <linux/ethtool.h>
 #include <linux/cache.h>
 #include <linux/crc32.h>
+#include <linux/crc32poly.h>
 #include <linux/mii.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
@@ -1078,7 +1079,7 @@ static void ks_stop_rx(struct ks_net *ks)
 
 }  /* ks_stop_rx */
 
-static unsigned long const ethernet_polynomial = 0x04c11db7U;
+static unsigned long const ethernet_polynomial = CRC32_POLY_BE;
 
 static unsigned long ether_gen_crc(int length, u8 *data)
 {
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
index 458a7844260a..99d86e39ff54 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
@@ -20,6 +20,7 @@
 #include <linux/clk.h>
 #include <linux/bitrev.h>
 #include <linux/crc32.h>
+#include <linux/crc32poly.h>
 #include <linux/dcbnl.h>
 
 #include "dwc-xlgmac.h"
@@ -193,7 +194,6 @@ static u32 xlgmac_vid_crc32_le(__le16 vid_le)
 {
 	unsigned char *data = (unsigned char *)&vid_le;
 	unsigned char data_byte = 0;
-	u32 poly = 0xedb88320;
 	u32 crc = ~0;
 	u32 temp = 0;
 	int i, bits;
@@ -208,7 +208,7 @@ static u32 xlgmac_vid_crc32_le(__le16 vid_le)
 		data_byte >>= 1;
 
 		if (temp)
-			crc ^= poly;
+			crc ^= CRC32_POLY_LE;
 	}
 
 	return crc;
-- 
2.14.1
