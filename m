From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v2] Staging: ccree: Use kcalloc instead of kzalloc
Date: Thu, 14 Sep 2017 18:18:13 +0530
Message-ID: <1505393293-5941-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 outreachy-kernel@googlegroups.com, Srishti Sharma <srishtishar@gmail.com>,
 linux-crypto@vger.kernel.org
To: gilad@benyossef.com
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

Use kcalloc instead of kzalloc to check for overflow before
multiplication. Done using the following semantic patch by
coccinelle.

http://coccinelle.lip6.fr/rules/kzalloc.cocci

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Changes in v2:
 - eliminate parentheses around the first argument

 drivers/staging/ccree/ssi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 0655658..f7e0c502 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -376,7 +376,7 @@ static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
 		return -ENOMEM;
 	/* allocate memory for directory's attributes list */
 	sys_dir->sys_dir_attr_list =
-		kzalloc(sizeof(struct attribute *) * (num_of_attrs + 1),
+		kcalloc(num_of_attrs + 1, sizeof(struct attribute *),
 			GFP_KERNEL);
 
 	if (!(sys_dir->sys_dir_attr_list)) {
-- 
2.7.4
