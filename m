From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/4] staging: ccree: remove sysfs if of deleted code
Date: Mon,  2 Oct 2017 10:03:22 +0100
Message-ID: <1506935008-14240-2-git-send-email-gilad@benyossef.com>
References: <1506935008-14240-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1506935008-14240-1-git-send-email-gilad@benyossef.com>
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

The ccree cycle count mechanism was removed in
commit 7f821f0c6ffa ("staging: ccree: remove cycle count debug support")
but the sysfs interface lingered on. Remove it now.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_sysfs.c | 266 --------------------------------------
 1 file changed, 266 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index f7e0c502..e0810e2 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -24,260 +24,6 @@
 
 static struct ssi_drvdata *sys_get_drvdata(void);
 
-#ifdef CC_CYCLE_COUNT
-
-#include <asm/timex.h>
-
-struct stat_item {
-	unsigned int min;
-	unsigned int max;
-	cycles_t sum;
-	unsigned int count;
-};
-
-struct stat_name {
-	const char *op_type_name;
-	const char *stat_phase_name[MAX_STAT_PHASES];
-};
-
-static struct stat_name stat_name_db[MAX_STAT_OP_TYPES] = {
-	{
-		/* STAT_OP_TYPE_NULL */
-		.op_type_name = "NULL",
-		.stat_phase_name = {NULL},
-	},
-	{
-		.op_type_name = "Encode",
-		.stat_phase_name[STAT_PHASE_0] = "Init and sanity checks",
-		.stat_phase_name[STAT_PHASE_1] = "Map buffers",
-		.stat_phase_name[STAT_PHASE_2] = "Create sequence",
-		.stat_phase_name[STAT_PHASE_3] = "Send Request",
-		.stat_phase_name[STAT_PHASE_4] = "HW-Q push",
-		.stat_phase_name[STAT_PHASE_5] = "Sequence completion",
-		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
-	},
-	{	.op_type_name = "Decode",
-		.stat_phase_name[STAT_PHASE_0] = "Init and sanity checks",
-		.stat_phase_name[STAT_PHASE_1] = "Map buffers",
-		.stat_phase_name[STAT_PHASE_2] = "Create sequence",
-		.stat_phase_name[STAT_PHASE_3] = "Send Request",
-		.stat_phase_name[STAT_PHASE_4] = "HW-Q push",
-		.stat_phase_name[STAT_PHASE_5] = "Sequence completion",
-		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
-	},
-	{	.op_type_name = "Setkey",
-		.stat_phase_name[STAT_PHASE_0] = "Init and sanity checks",
-		.stat_phase_name[STAT_PHASE_1] = "Copy key to ctx",
-		.stat_phase_name[STAT_PHASE_2] = "Create sequence",
-		.stat_phase_name[STAT_PHASE_3] = "Send Request",
-		.stat_phase_name[STAT_PHASE_4] = "HW-Q push",
-		.stat_phase_name[STAT_PHASE_5] = "Sequence completion",
-		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
-	},
-	{
-		.op_type_name = "Generic",
-		.stat_phase_name[STAT_PHASE_0] = "Interrupt",
-		.stat_phase_name[STAT_PHASE_1] = "ISR-to-Tasklet",
-		.stat_phase_name[STAT_PHASE_2] = "Tasklet start-to-end",
-		.stat_phase_name[STAT_PHASE_3] = "Tasklet:user_cb()",
-		.stat_phase_name[STAT_PHASE_4] = "Tasklet:dx_X_complete() - w/o X_complete()",
-		.stat_phase_name[STAT_PHASE_5] = "",
-		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
-	}
-};
-
-/*
- * Structure used to create a directory
- * and its attributes in sysfs.
- */
-struct sys_dir {
-	struct kobject *sys_dir_kobj;
-	struct attribute_group sys_dir_attr_group;
-	struct attribute **sys_dir_attr_list;
-	u32 num_of_attrs;
-	struct ssi_drvdata *drvdata; /* Associated driver context */
-};
-
-/* top level directory structures */
-struct sys_dir sys_top_dir;
-
-static DEFINE_SPINLOCK(stat_lock);
-
-/* List of DBs */
-static struct stat_item stat_host_db[MAX_STAT_OP_TYPES][MAX_STAT_PHASES];
-static struct stat_item stat_cc_db[MAX_STAT_OP_TYPES][MAX_STAT_PHASES];
-
-static void init_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES])
-{
-	unsigned int i, j;
-
-	/* Clear db */
-	for (i = 0; i < MAX_STAT_OP_TYPES; i++) {
-		for (j = 0; j < MAX_STAT_PHASES; j++) {
-			item[i][j].min = 0xFFFFFFFF;
-			item[i][j].max = 0;
-			item[i][j].sum = 0;
-			item[i][j].count = 0;
-		}
-	}
-}
-
-static void update_db(struct stat_item *item, unsigned int result)
-{
-	item->count++;
-	item->sum += result;
-	if (result < item->min)
-		item->min = result;
-	if (result > item->max)
-		item->max = result;
-}
-
-static void display_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES])
-{
-	unsigned int i, j;
-	u64 avg;
-
-	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
-		for (j = 0; j < MAX_STAT_PHASES; j++) {
-			if (item[i][j].count > 0) {
-				avg = (u64)item[i][j].sum;
-				do_div(avg, item[i][j].count);
-				SSI_LOG_ERR("%s, %s: min=%d avg=%d max=%d sum=%lld count=%d\n",
-					    stat_name_db[i].op_type_name,
-					    stat_name_db[i].stat_phase_name[j],
-					    item[i][j].min, (int)avg,
-					    item[i][j].max,
-					    (long long)item[i][j].sum,
-					    item[i][j].count);
-			}
-		}
-	}
-}
-
-/**************************************
- * Attributes show functions section  *
- **************************************/
-
-static ssize_t ssi_sys_stats_host_db_clear(struct kobject *kobj,
-					   struct kobj_attribute *attr,
-					   const char *buf, size_t count)
-{
-	init_db(stat_host_db);
-	return count;
-}
-
-static ssize_t ssi_sys_stats_cc_db_clear(struct kobject *kobj,
-					 struct kobj_attribute *attr,
-					 const char *buf, size_t count)
-{
-	init_db(stat_cc_db);
-	return count;
-}
-
-static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
-					 struct kobj_attribute *attr, char *buf)
-{
-	int i, j;
-	char line[512];
-	u32 min_cyc, max_cyc;
-	u64 avg;
-	ssize_t buf_len, tmp_len = 0;
-
-	buf_len = scnprintf(buf, PAGE_SIZE,
-			    "phase\t\t\t\t\t\t\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
-	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
-		return buf_len;
-	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
-		for (j = 0; j < MAX_STAT_PHASES - 1; j++) {
-			if (stat_host_db[i][j].count > 0) {
-				avg = (u64)stat_host_db[i][j].sum;
-				do_div(avg, stat_host_db[i][j].count);
-				min_cyc = stat_host_db[i][j].min;
-				max_cyc = stat_host_db[i][j].max;
-			} else {
-				avg = min_cyc = max_cyc = 0;
-			}
-			tmp_len = scnprintf(line, 512,
-					    "%s::%s\t\t\t\t\t%6u\t%6u\t%6u\t%7u\n",
-					    stat_name_db[i].op_type_name,
-					    stat_name_db[i].stat_phase_name[j],
-					    min_cyc, (unsigned int)avg, max_cyc,
-					    stat_host_db[i][j].count);
-			if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
-				return buf_len;
-			if (buf_len + tmp_len >= PAGE_SIZE)
-				return buf_len;
-			buf_len += tmp_len;
-			strncat(buf, line, 512);
-		}
-	}
-	return buf_len;
-}
-
-static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *buf)
-{
-	int i;
-	char line[256];
-	u32 min_cyc, max_cyc;
-	u64 avg;
-	ssize_t buf_len, tmp_len = 0;
-
-	buf_len = scnprintf(buf, PAGE_SIZE,
-			    "phase\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
-	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
-		return buf_len;
-	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
-		if (stat_cc_db[i][STAT_PHASE_6].count > 0) {
-			avg = (u64)stat_cc_db[i][STAT_PHASE_6].sum;
-			do_div(avg, stat_cc_db[i][STAT_PHASE_6].count);
-			min_cyc = stat_cc_db[i][STAT_PHASE_6].min;
-			max_cyc = stat_cc_db[i][STAT_PHASE_6].max;
-		} else {
-			avg = min_cyc = max_cyc = 0;
-		}
-		tmp_len = scnprintf(line, 256, "%s\t%6u\t%6u\t%6u\t%7u\n",
-				    stat_name_db[i].op_type_name, min_cyc,
-				    (unsigned int)avg, max_cyc,
-				    stat_cc_db[i][STAT_PHASE_6].count);
-
-		if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
-			return buf_len;
-
-		if (buf_len + tmp_len >= PAGE_SIZE)
-			return buf_len;
-		buf_len += tmp_len;
-		strncat(buf, line, 256);
-	}
-	return buf_len;
-}
-
-void update_host_stat(unsigned int op_type, unsigned int phase, cycles_t result)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&stat_lock, flags);
-	update_db(&stat_host_db[op_type][phase], (unsigned int)result);
-	spin_unlock_irqrestore(&stat_lock, flags);
-}
-
-void update_cc_stat(
-	unsigned int op_type,
-	unsigned int phase,
-	unsigned int elapsed_cycles)
-{
-	update_db(&stat_cc_db[op_type][phase], elapsed_cycles);
-}
-
-void display_all_stat_db(void)
-{
-	SSI_LOG_ERR("\n=======    CYCLE COUNT STATS    =======\n");
-	display_db(stat_host_db);
-	SSI_LOG_ERR("\n======= CC HW CYCLE COUNT STATS =======\n");
-	display_db(stat_cc_db);
-}
-#endif /*CC_CYCLE_COUNT*/
-
 static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *buf)
 {
@@ -304,12 +50,6 @@ static ssize_t ssi_sys_help_show(struct kobject *kobj,
 {
 	char *help_str[] = {
 				"cat reg_dump              ", "Print several of CC register values",
-		#if defined CC_CYCLE_COUNT
-				"cat stats_host            ", "Print host statistics",
-				"echo <number> > stats_host", "Clear host statistics database",
-				"cat stats_cc              ", "Print CC statistics",
-				"echo <number> > stats_cc  ", "Clear CC statistics database",
-		#endif
 				};
 	int i = 0, offset = 0;
 
@@ -414,12 +154,6 @@ int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
 {
 	int retval;
 
-#if defined CC_CYCLE_COUNT
-	/* Init. statistics */
-	init_db(stat_host_db);
-	init_db(stat_cc_db);
-#endif
-
 	SSI_LOG_ERR("setup sysfs under %s\n", sys_dev_obj->name);
 
 	/* Initialize top directory */
-- 
2.7.4
