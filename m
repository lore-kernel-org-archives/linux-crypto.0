From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 18/27] Drivers: ccree: ssi_config.h - align block comments
Date: Tue, 30 May 2017 18:14:54 +1200
Message-ID: <20170530061454.13814-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_config.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index 431b518d893a..9feb692fff0d 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -15,7 +15,7 @@
  */
 
 /* \file ssi_config.h
-   Definitions for ARM CryptoCell Linux Crypto Driver
+ * Definitions for ARM CryptoCell Linux Crypto Driver
  */
 
 #ifndef __SSI_CONFIG_H__
@@ -49,7 +49,8 @@
 	#define SSI_CACHE_PARAMS (0x000)
 	/* CC attached to NONE-ACP such as HPP/ACE/AMBA4.
 	 * The customer is responsible to enable/disable this feature
-	 * according to his platform type. */
+	 * according to his platform type.
+	 */
 	#define DX_HAS_ACP 0
 #else
 	#define SSI_CACHE_PARAMS (0xEEE)
-- 
2.13.0
