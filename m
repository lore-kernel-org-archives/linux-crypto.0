From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 4/5] staging: ccree: make stub function static inline
Date: Tue,  9 Jan 2018 10:24:32 +0000
Message-ID: <1515493478-30454-5-git-send-email-gilad@benyossef.com>
References: <1515493478-30454-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515493478-30454-1-git-send-email-gilad@benyossef.com>
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

The debugfs interface defines stub function if debugfs is not
enabled, which were missing the 'static inline' qualifiers causing
sparse warnings.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_debugfs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/cc_debugfs.h b/drivers/staging/ccree/cc_debugfs.h
index 354ec17..5b5320e 100644
--- a/drivers/staging/ccree/cc_debugfs.h
+++ b/drivers/staging/ccree/cc_debugfs.h
@@ -13,19 +13,19 @@ void cc_debugfs_fini(struct cc_drvdata *drvdata);
 
 #else
 
-int cc_debugfs_global_init(void)
+static inline int cc_debugfs_global_init(void)
 {
 	return 0;
 }
 
-void cc_debugfs_global_fini(void) {}
+static inline void cc_debugfs_global_fini(void) {}
 
-int cc_debugfs_init(struct cc_drvdata *drvdata)
+static inline int cc_debugfs_init(struct cc_drvdata *drvdata)
 {
 	return 0;
 }
 
-void cc_debugfs_fini(struct cc_drvdata *drvdata) {}
+static inline void cc_debugfs_fini(struct cc_drvdata *drvdata) {}
 
 #endif
 
-- 
2.7.4
