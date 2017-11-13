From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 16/24] staging: ccree: remove dead defs and decls
Date: Mon, 13 Nov 2017 14:45:44 +0000
Message-ID: <1510584358-29473-17-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
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

Remove no longer definitions of enums and forward declaration of functions
dealing with sysfs interface of the long removed ccree cycle counter.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_sysfs.h | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
index 44ae3d4..5124528 100644
--- a/drivers/staging/ccree/ssi_sysfs.h
+++ b/drivers/staging/ccree/ssi_sysfs.h
@@ -26,30 +26,7 @@
 /* forward declaration */
 struct ssi_drvdata;
 
-enum stat_phase {
-	STAT_PHASE_0 = 0,
-	STAT_PHASE_1,
-	STAT_PHASE_2,
-	STAT_PHASE_3,
-	STAT_PHASE_4,
-	STAT_PHASE_5,
-	STAT_PHASE_6,
-	MAX_STAT_PHASES,
-};
-
-enum stat_op {
-	STAT_OP_TYPE_NULL = 0,
-	STAT_OP_TYPE_ENCODE,
-	STAT_OP_TYPE_DECODE,
-	STAT_OP_TYPE_SETKEY,
-	STAT_OP_TYPE_GENERIC,
-	MAX_STAT_OP_TYPES,
-};
-
 int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata);
 void ssi_sysfs_fini(void);
-void update_host_stat(unsigned int op_type, unsigned int phase, cycles_t result);
-void update_cc_stat(unsigned int op_type, unsigned int phase, unsigned int elapsed_cycles);
-void display_all_stat_db(void);
 
 #endif /*__SSI_SYSFS_H__*/
-- 
2.7.4
