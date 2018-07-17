From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5/6] staging: rtl: Use existing define with polynomial
Date: Tue, 17 Jul 2018 18:05:40 +0200
Message-ID: <20180717160541.3843-6-krzk@kernel.org>
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
Not tested

It would be nice to get some testing. Only generic lib/crc, bunzip, xz_crc32
and Freescale's Ethernet driver were tested on HW.  Rest got just different
builds.

 drivers/staging/rtl8712/rtl871x_security.c    | 5 ++---
 drivers/staging/rtl8723bs/core/rtw_security.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index 7bc74d7d8a3a..1075eacdb441 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -40,6 +40,7 @@
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
 #include <linux/atomic.h>
+#include <linux/crc32poly.h>
 #include <linux/semaphore.h>
 
 #include "osdep_service.h"
@@ -49,8 +50,6 @@
 
 /* =====WEP related===== */
 
-#define CRC32_POLY 0x04c11db7
-
 struct arc4context {
 	u32 x;
 	u32 y;
@@ -135,7 +134,7 @@ static void crc32_init(void)
 	for (i = 0; i < 256; ++i) {
 		k = crc32_reverseBit((u8)i);
 		for (c = ((u32)k) << 24, j = 8; j > 0; --j)
-			c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY : (c << 1);
+			c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY_BE : (c << 1);
 		p1 = (u8 *)&crc32_table[i];
 		p1[0] = crc32_reverseBit(p[3]);
 		p1[1] = crc32_reverseBit(p[2]);
diff --git a/drivers/staging/rtl8723bs/core/rtw_security.c b/drivers/staging/rtl8723bs/core/rtw_security.c
index 612277a555d2..6c8ac9e86c9f 100644
--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -6,6 +6,7 @@
  ******************************************************************************/
 #define  _RTW_SECURITY_C_
 
+#include <linux/crc32poly.h>
 #include <drv_types.h>
 #include <rtw_debug.h>
 
@@ -87,8 +88,6 @@ const char *security_type_str(u8 value)
 
 /* WEP related ===== */
 
-#define CRC32_POLY 0x04c11db7
-
 struct arc4context {
 	u32 x;
 	u32 y;
@@ -178,7 +177,7 @@ static void crc32_init(void)
 		for (i = 0; i < 256; ++i) {
 			k = crc32_reverseBit((u8)i);
 			for (c = ((u32)k) << 24, j = 8; j > 0; --j) {
-				c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY : (c << 1);
+				c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY_BE : (c << 1);
 			}
 			p1 = (u8 *)&crc32_table[i];
 
-- 
2.14.1
