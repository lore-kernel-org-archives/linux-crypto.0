From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 03/20] staging: ccree: fix longer than 80 chars lines
Date: Thu,  1 Jun 2017 14:02:53 +0300
Message-ID: <1496314993-30229-4-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
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

Clip longer than 80 chars lines in header files worked
on in the patch set.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 3 ++-
 drivers/staging/ccree/cc_regs.h       | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 18c15fc..15b4ef9 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -84,7 +84,8 @@
 
 #define CC_MULTI2_SYSTEM_KEY_SIZE		32
 #define CC_MULTI2_DATA_KEY_SIZE		8
-#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE	(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)
+#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE \
+		(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)
 #define	CC_MULTI2_BLOCK_SIZE					8
 #define	CC_MULTI2_IV_SIZE					8
 #define	CC_MULTI2_MIN_NUM_ROUNDS				8
diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
index 8b89f06..e272da4 100644
--- a/drivers/staging/ccree/cc_regs.h
+++ b/drivers/staging/ccree/cc_regs.h
@@ -17,7 +17,8 @@
 
 /*!
  * @file
- * @brief This file contains macro definitions for accessing ARM TrustZone CryptoCell register space.
+ * @brief This file contains macro definitions for accessing ARM TrustZone
+ *        CryptoCell register space.
  */
 
 #ifndef _CC_REGS_H_
-- 
2.1.4
