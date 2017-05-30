From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 25/27] Drivers: ccree: cc_regs.h - align block comments
Date: Tue, 30 May 2017 18:16:55 +1200
Message-ID: <20170530061655.14137-1-robsonde@gmail.com>
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
 drivers/staging/ccree/cc_regs.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
index 8b89f0603f16..51b01609838e 100644
--- a/drivers/staging/ccree/cc_regs.h
+++ b/drivers/staging/ccree/cc_regs.h
@@ -55,8 +55,9 @@ do {								            \
 	BITFIELD_GET(reg_val, CC_ ## reg_name ## _ ## fld_name ## _BIT_SHIFT, \
 		     CC_ ## reg_name ## _ ## fld_name ## _BIT_SIZE))
 
-/* yael TBD !!! -       				      *
-* all HW includes should start with CC_ and not DX_ !!	      */
+/* yael TBD !!!
+ * all HW includes should start with CC_ and not DX_ !!
+ */
 
 
 /*! Bit fields set */
@@ -86,10 +87,10 @@ do {                                                                     \
 } while (0)
 
 /* Usage example:
-   u32 reg_shadow = READ_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL));
-   CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY0,reg_shadow, 3);
-   CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY1,reg_shadow, 1);
-   WRITE_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL), reg_shadow);
+ * u32 reg_shadow = READ_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL));
+ * CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY0,reg_shadow, 3);
+ * CC_REG_FLD_SET(CRY_KERNEL,AES_CONTROL,NK_KEY1,reg_shadow, 1);
+ * WRITE_REGISTER(CC_REG_ADDR(CRY_KERNEL,AES_CONTROL), reg_shadow);
  */
 
 #endif /*_CC_REGS_H_*/
-- 
2.13.0
