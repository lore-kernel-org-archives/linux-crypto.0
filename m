From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 10/10] staging: ccree: Fix alignment issues in ssi_sysfs.c
Date: Sun,  2 Jul 2017 01:25:55 +0200
Message-ID: <20170701232555.5538-11-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33853 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbdGAX0i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:38 -0400
Received: by mail-lf0-f41.google.com with SMTP id l13so86397910lfl.1
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:37 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_sysfs.c | 59 ++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index dbcd1634aad1..ef23ed43fe9e 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -144,8 +144,12 @@ static void display_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES]
 				avg = (u64)item[i][j].sum;
 				do_div(avg, item[i][j].count);
 				SSI_LOG_ERR("%s, %s: min=%d avg=%d max=%d sum=%lld count=%d\n",
-					stat_name_db[i].op_type_name, stat_name_db[i].stat_phase_name[j],
-					item[i][j].min, (int)avg, item[i][j].max, (long long)item[i][j].sum, item[i][j].count);
+					    stat_name_db[i].op_type_name,
+					    stat_name_db[i].stat_phase_name[j],
+					    item[i][j].min, (int)avg,
+					    item[i][j].max,
+					    (long long)item[i][j].sum,
+					    item[i][j].count);
 			}
 		}
 	}
@@ -156,21 +160,23 @@ static void display_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES]
  **************************************/
 
 static ssize_t ssi_sys_stats_host_db_clear(struct kobject *kobj,
-	struct kobj_attribute *attr, const char *buf, size_t count)
+					   struct kobj_attribute *attr,
+					   const char *buf, size_t count)
 {
 	init_db(stat_host_db);
 	return count;
 }
 
 static ssize_t ssi_sys_stats_cc_db_clear(struct kobject *kobj,
-	struct kobj_attribute *attr, const char *buf, size_t count)
+					 struct kobj_attribute *attr,
+					 const char *buf, size_t count)
 {
 	init_db(stat_cc_db);
 	return count;
 }
 
 static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+					 struct kobj_attribute *attr, char *buf)
 {
 	int i, j;
 	char line[512];
@@ -179,7 +185,7 @@ static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
 	ssize_t buf_len, tmp_len = 0;
 
 	buf_len = scnprintf(buf, PAGE_SIZE,
-		"phase\t\t\t\t\t\t\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
+			    "phase\t\t\t\t\t\t\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
 	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 		return buf_len;
 	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
@@ -193,11 +199,11 @@ static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
 				avg = min_cyc = max_cyc = 0;
 			}
 			tmp_len = scnprintf(line, 512,
-				"%s::%s\t\t\t\t\t%6u\t%6u\t%6u\t%7u\n",
-				stat_name_db[i].op_type_name,
-				stat_name_db[i].stat_phase_name[j],
-				min_cyc, (unsigned int)avg, max_cyc,
-				stat_host_db[i][j].count);
+					    "%s::%s\t\t\t\t\t%6u\t%6u\t%6u\t%7u\n",
+					    stat_name_db[i].op_type_name,
+					    stat_name_db[i].stat_phase_name[j],
+					    min_cyc, (unsigned int)avg, max_cyc,
+					    stat_host_db[i][j].count);
 			if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 				return buf_len;
 			if (buf_len + tmp_len >= PAGE_SIZE)
@@ -210,7 +216,7 @@ static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
 }
 
 static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+				       struct kobj_attribute *attr, char *buf)
 {
 	int i;
 	char line[256];
@@ -219,7 +225,7 @@ static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
 	ssize_t buf_len, tmp_len = 0;
 
 	buf_len = scnprintf(buf, PAGE_SIZE,
-		"phase\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
+			    "phase\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
 	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 		return buf_len;
 	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
@@ -231,13 +237,10 @@ static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
 		} else {
 			avg = min_cyc = max_cyc = 0;
 		}
-		tmp_len = scnprintf(line, 256,
-			"%s\t%6u\t%6u\t%6u\t%7u\n",
-			stat_name_db[i].op_type_name,
-			min_cyc,
-			(unsigned int)avg,
-			max_cyc,
-			stat_cc_db[i][STAT_PHASE_6].count);
+		tmp_len = scnprintf(line, 256, "%s\t%6u\t%6u\t%6u\t%7u\n",
+				    stat_name_db[i].op_type_name, min_cyc,
+				    (unsigned int)avg, max_cyc,
+				    stat_cc_db[i][STAT_PHASE_6].count);
 
 		if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 			return buf_len;
@@ -277,7 +280,7 @@ void display_all_stat_db(void)
 #endif /*CC_CYCLE_COUNT*/
 
 static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+				    struct kobj_attribute *attr, char *buf)
 {
 	struct ssi_drvdata *drvdata = sys_get_drvdata();
 	u32 register_value;
@@ -298,7 +301,7 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 }
 
 static ssize_t ssi_sys_help_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+				 struct kobj_attribute *attr, char *buf)
 {
 	char *help_str[] = {
 				"cat reg_dump              ", "Print several of CC register values",
@@ -357,8 +360,8 @@ static struct ssi_drvdata *sys_get_drvdata(void)
 }
 
 static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
-		 struct kobject *parent_dir_kobj, const char *dir_name,
-		 struct kobj_attribute *attrs, u32 num_of_attrs)
+			struct kobject *parent_dir_kobj, const char *dir_name,
+			struct kobj_attribute *attrs, u32 num_of_attrs)
 {
 	int i;
 
@@ -375,7 +378,7 @@ static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
 	/* allocate memory for directory's attributes list */
 	sys_dir->sys_dir_attr_list =
 		kzalloc(sizeof(struct attribute *) * (num_of_attrs + 1),
-				GFP_KERNEL);
+			GFP_KERNEL);
 
 	if (!(sys_dir->sys_dir_attr_list)) {
 		kobject_put(sys_dir->sys_dir_kobj);
@@ -421,9 +424,9 @@ int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
 	SSI_LOG_ERR("setup sysfs under %s\n", sys_dev_obj->name);
 
 	/* Initialize top directory */
-	retval = sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj,
-				"cc_info", ssi_sys_top_level_attrs,
-				ARRAY_SIZE(ssi_sys_top_level_attrs));
+	retval = sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
+			      ssi_sys_top_level_attrs,
+			      ARRAY_SIZE(ssi_sys_top_level_attrs));
 	return retval;
 }
 
-- 
2.11.0
