From: <puneets@nvidia.com>
Subject: [PATCH 3/3] arm: tegra: governor: change governor using cpufreq interface
Date: Fri, 11 May 2012 18:02:36 +0530
Message-ID: <1336739556-579-4-git-send-email-puneets@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-tegra@vger.kernel.org>,
	Puneet Saxena <puneets@nvidia.com>
To: <cpufreq@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Return-path: <cpufreq-owner@vger.kernel.org>
Sender: cpufreq-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Puneet Saxena <puneets@nvidia.com>

Older code sets "conservative" governor in early-suspend
using sysfs entries.This implementation changes governor
in early-suspend using cpufreq interfaces.

bug 871958

Change-Id: I721afb6184982a063dc5f330da31f8fb88481cfd
Signed-off-by: Puneet Saxena <puneets@nvidia.com>
---
 arch/arm/mach-tegra/board-enterprise-panel.c |   18 ++--
 arch/arm/mach-tegra/board-kai-panel.c        |   19 +---
 arch/arm/mach-tegra/board-ventana-panel.c    |   17 +--
 arch/arm/mach-tegra/board-whistler-panel.c   |   19 ++--
 arch/arm/mach-tegra/board.h                  |   17 ++--
 arch/arm/mach-tegra/common.c                 |  134 +++++++-------------------
 6 files changed, 71 insertions(+), 153 deletions(-)

diff --git a/arch/arm/mach-tegra/board-enterprise-panel.c b/arch/arm/mach-tegra/board-enterprise-panel.c
index 8ac2e66..368d8c6 100644
--- a/arch/arm/mach-tegra/board-enterprise-panel.c
+++ b/arch/arm/mach-tegra/board-enterprise-panel.c
@@ -816,17 +816,12 @@ static void enterprise_panel_early_suspend(struct early_suspend *h)
 		fb_blank(registered_fb[0], FB_BLANK_POWERDOWN);
 	if (num_registered_fb > 1)
 		fb_blank(registered_fb[1], FB_BLANK_NORMAL);
-#ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_save_default_governor();
-	cpufreq_set_conservative_governor();
-	cpufreq_set_conservative_governor_param("up_threshold",
-			SET_CONSERVATIVE_GOVERNOR_UP_THRESHOLD);
-
-	cpufreq_set_conservative_governor_param("down_threshold",
-			SET_CONSERVATIVE_GOVERNOR_DOWN_THRESHOLD);
 
-	cpufreq_set_conservative_governor_param("freq_step",
-			SET_CONSERVATIVE_GOVERNOR_FREQ_STEP);
+#ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
+	cpufreq_store_default_gov();
+	if (cpufreq_change_gov(cpufreq_conservative_gov))
+		pr_err("Early_suspend: Error changing governor to %s\n",
+				cpufreq_conservative_gov);
 #endif
 }
 
@@ -835,7 +830,8 @@ static void enterprise_panel_late_resume(struct early_suspend *h)
 	unsigned i;
 
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_restore_default_governor();
+	if (cpufreq_restore_default_gov())
+		pr_err("Early_suspend: Unable to restore governor\n");
 #endif
 	for (i = 0; i < num_registered_fb; i++)
 		fb_blank(registered_fb[i], FB_BLANK_UNBLANK);
diff --git a/arch/arm/mach-tegra/board-kai-panel.c b/arch/arm/mach-tegra/board-kai-panel.c
index 53661ce..0a68387 100644
--- a/arch/arm/mach-tegra/board-kai-panel.c
+++ b/arch/arm/mach-tegra/board-kai-panel.c
@@ -620,27 +620,20 @@ static void kai_panel_early_suspend(struct early_suspend *h)
 		fb_blank(registered_fb[0], FB_BLANK_POWERDOWN);
 	if (num_registered_fb > 1)
 		fb_blank(registered_fb[1], FB_BLANK_NORMAL);
-
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_save_default_governor();
-	cpufreq_set_conservative_governor();
-	cpufreq_set_conservative_governor_param("up_threshold",
-			SET_CONSERVATIVE_GOVERNOR_UP_THRESHOLD);
-
-	cpufreq_set_conservative_governor_param("down_threshold",
-			SET_CONSERVATIVE_GOVERNOR_DOWN_THRESHOLD);
-
-	cpufreq_set_conservative_governor_param("freq_step",
-		SET_CONSERVATIVE_GOVERNOR_FREQ_STEP);
+	cpufreq_store_default_gov();
+	if (cpufreq_change_gov(cpufreq_conservative_gov))
+		pr_err("Early_suspend: Error changing governor to %s\n",
+				cpufreq_conservative_gov);
 #endif
-
 }
 
 static void kai_panel_late_resume(struct early_suspend *h)
 {
 	unsigned i;
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_restore_default_governor();
+	if (cpufreq_restore_default_gov())
+		pr_err("Early_suspend: Unable to restore governor\n");
 #endif
 	for (i = 0; i < num_registered_fb; i++)
 		fb_blank(registered_fb[i], FB_BLANK_UNBLANK);
diff --git a/arch/arm/mach-tegra/board-ventana-panel.c b/arch/arm/mach-tegra/board-ventana-panel.c
index 4cacd3d..84e75a4 100644
--- a/arch/arm/mach-tegra/board-ventana-panel.c
+++ b/arch/arm/mach-tegra/board-ventana-panel.c
@@ -366,16 +366,10 @@ static void ventana_panel_early_suspend(struct early_suspend *h)
 	if (num_registered_fb > 1)
 		fb_blank(registered_fb[1], FB_BLANK_NORMAL);
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_save_default_governor();
-	cpufreq_set_conservative_governor();
-        cpufreq_set_conservative_governor_param("up_threshold",
-			SET_CONSERVATIVE_GOVERNOR_UP_THRESHOLD);
-
-	cpufreq_set_conservative_governor_param("down_threshold",
-			SET_CONSERVATIVE_GOVERNOR_DOWN_THRESHOLD);
-
-	cpufreq_set_conservative_governor_param("freq_step",
-		SET_CONSERVATIVE_GOVERNOR_FREQ_STEP);
+	cpufreq_store_default_gov();
+	if (cpufreq_change_gov(cpufreq_conservative_gov))
+		pr_err("Early_suspend: Error changing governor to %s\n",
+				cpufreq_conservative_gov);
 #endif
 }
 
@@ -383,7 +377,8 @@ static void ventana_panel_late_resume(struct early_suspend *h)
 {
 	unsigned i;
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_restore_default_governor();
+	if (cpufreq_restore_default_gov())
+		pr_err("Early_suspend: Unable to restore governor\n");
 #endif
 	for (i = 0; i < num_registered_fb; i++)
 		fb_blank(registered_fb[i], FB_BLANK_UNBLANK);
diff --git a/arch/arm/mach-tegra/board-whistler-panel.c b/arch/arm/mach-tegra/board-whistler-panel.c
index 74075d4..7582c77 100644
--- a/arch/arm/mach-tegra/board-whistler-panel.c
+++ b/arch/arm/mach-tegra/board-whistler-panel.c
@@ -318,25 +318,22 @@ static void whistler_panel_early_suspend(struct early_suspend *h)
 		fb_blank(registered_fb[1], FB_BLANK_NORMAL);
 
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_save_default_governor();
-	cpufreq_set_conservative_governor();
-        cpufreq_set_conservative_governor_param("up_threshold",
-			SET_CONSERVATIVE_GOVERNOR_UP_THRESHOLD);
-
-	cpufreq_set_conservative_governor_param("down_threshold",
-			SET_CONSERVATIVE_GOVERNOR_DOWN_THRESHOLD);
-
-	cpufreq_set_conservative_governor_param("freq_step",
-		SET_CONSERVATIVE_GOVERNOR_FREQ_STEP);
+	cpufreq_store_default_gov();
+	if (cpufreq_change_gov(cpufreq_conservative_gov))
+		pr_err("Early_suspend: Error changing governor to %s\n",
+				cpufreq_conservative_gov);
 #endif
 }
 
 static void whistler_panel_late_resume(struct early_suspend *h)
 {
 	unsigned i;
+
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-	cpufreq_restore_default_governor();
+	if (cpufreq_restore_default_gov())
+		pr_err("Early_suspend: Unable to restore governor\n");
 #endif
+
 	for (i = 0; i < num_registered_fb; i++)
 		fb_blank(registered_fb[i], FB_BLANK_UNBLANK);
 }
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index c7ab065..63095ce 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -157,16 +157,17 @@ void tegra_get_board_info(struct board_info *);
 void tegra_get_pmu_board_info(struct board_info *bi);
 void tegra_get_display_board_info(struct board_info *bi);
 void tegra_get_camera_board_info(struct board_info *bi);
+
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-#define SET_CONSERVATIVE_GOVERNOR_UP_THRESHOLD 		95
-#define SET_CONSERVATIVE_GOVERNOR_DOWN_THRESHOLD 	50
-#define SET_CONSERVATIVE_GOVERNOR_FREQ_STEP 		3
-
-void cpufreq_save_default_governor(void);
-void cpufreq_restore_default_governor(void);
-void cpufreq_set_conservative_governor(void);
-void cpufreq_set_conservative_governor_param(char *name, int value);
+#define MAX_GOV_NAME_LEN 16
+extern char cpufreq_default_gov[][MAX_GOV_NAME_LEN];
+extern char *cpufreq_conservative_gov;
+
+void cpufreq_store_default_gov(void);
+int cpufreq_restore_default_gov(void);
+int cpufreq_change_gov(char *target_gov);
 #endif
+
 int get_core_edp(void);
 enum panel_type get_panel_type(void);
 int tegra_get_modem_id(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index aef4201..78bd77d 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -28,6 +28,7 @@
 #include <linux/memblock.h>
 #include <linux/bitops.h>
 #include <linux/sched.h>
+#include <linux/cpufreq.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/system.h>
@@ -953,118 +954,53 @@ void __init tegra_release_bootloader_fb(void)
 }
 
 #ifdef CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND
-static char cpufreq_gov_default[32];
-static char *cpufreq_gov_conservative = "conservative";
-static char *cpufreq_sysfs_place_holder="/sys/devices/system/cpu/cpu%i/cpufreq/scaling_governor";
-static char *cpufreq_gov_conservative_param="/sys/devices/system/cpu/cpufreq/conservative/%s";
+char cpufreq_default_gov[CONFIG_NR_CPUS][MAX_GOV_NAME_LEN];
+char *cpufreq_conservative_gov = "conservative";
 
-static void cpufreq_set_governor(char *governor)
+void cpufreq_store_default_gov(void)
 {
-	struct file *scaling_gov = NULL;
-	mm_segment_t old_fs;
-	char    buf[128];
-	int i = 0;
-	loff_t offset = 0;
+	unsigned int cpu;
+	struct cpufreq_policy *policy;
 
-	if (governor == NULL)
-		return;
-
-	/* change to KERNEL_DS address limit */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-#ifndef CONFIG_TEGRA_AUTO_HOTPLUG
-	for_each_online_cpu(i)
-#endif
-	{
-		sprintf(buf, cpufreq_sysfs_place_holder, i);
-		scaling_gov = filp_open(buf, O_RDWR, 0);
-		if (scaling_gov != NULL) {
-			if (scaling_gov->f_op != NULL &&
-				scaling_gov->f_op->write != NULL)
-				scaling_gov->f_op->write(scaling_gov,
-						governor,
-						strlen(governor),
-						&offset);
-			else
-				pr_err("f_op might be null\n");
-
-			filp_close(scaling_gov, NULL);
-		} else {
-			pr_err("%s. Can't open %s\n", __func__, buf);
+	for (cpu = 0; cpu < CONFIG_NR_CPUS; cpu++) {
+		policy = cpufreq_cpu_get(cpu);
+		if (policy) {
+			sprintf(cpufreq_default_gov[cpu], "%s",
+					policy->governor->name);
+			cpufreq_cpu_put(policy);
 		}
 	}
-	set_fs(old_fs);
 }
 
-void cpufreq_save_default_governor(void)
+int cpufreq_change_gov(char *target_gov)
 {
-	struct file *scaling_gov = NULL;
-	mm_segment_t old_fs;
-	char    buf[128];
-	loff_t offset = 0;
-
-	/* change to KERNEL_DS address limit */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	buf[127] = 0;
-	sprintf(buf, cpufreq_sysfs_place_holder,0);
-	scaling_gov = filp_open(buf, O_RDONLY, 0);
-	if (scaling_gov != NULL) {
-		if (scaling_gov->f_op != NULL &&
-			scaling_gov->f_op->read != NULL)
-			scaling_gov->f_op->read(scaling_gov,
-					cpufreq_gov_default,
-					32,
-					&offset);
-		else
-			pr_err("f_op might be null\n");
-
-		filp_close(scaling_gov, NULL);
-	} else {
-		pr_err("%s. Can't open %s\n", __func__, buf);
-	}
-	set_fs(old_fs);
-}
+	unsigned int cpu = 0;
 
-void cpufreq_restore_default_governor(void)
-{
-	cpufreq_set_governor(cpufreq_gov_default);
+#ifndef CONFIG_TEGRA_AUTO_HOTPLUG
+	for_each_online_cpu(cpu)
+#endif
+	return cpufreq_set_gov(target_gov, cpu);
 }
 
-void cpufreq_set_conservative_governor_param(char *name, int value)
+int cpufreq_restore_default_gov(void)
 {
-	struct file *gov_param = NULL;
-	mm_segment_t old_fs;
-	static char buf[128], param_value[8];
-	loff_t offset = 0;
-
-	/* change to KERNEL_DS address limit */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	sprintf(param_value, "%d", value);
-	sprintf(buf, cpufreq_gov_conservative_param, name);
-	gov_param = filp_open(buf, O_RDWR, 0);
-	if (gov_param != NULL) {
-		if (gov_param->f_op != NULL &&
-			gov_param->f_op->write != NULL)
-			gov_param->f_op->write(gov_param,
-					param_value,
-					strlen(param_value),
-					&offset);
-		else
-			pr_err("f_op might be null\n");
+	int ret = 0;
+	unsigned int cpu;
 
-		filp_close(gov_param, NULL);
-	} else {
-		pr_err("%s. Can't open %s\n", __func__, buf);
+	for (cpu = 0; cpu < CONFIG_NR_CPUS; cpu++) {
+		if (strlen((const char *)&cpufreq_default_gov[cpu])) {
+			ret = cpufreq_set_gov(cpufreq_default_gov[cpu], cpu);
+			if (ret < 0)
+				/* Unable to restore gov for the cpu as
+				 * It was online on suspend and becomes
+				 * offline on resume.
+				 */
+				pr_info("Unable to restore gov:%s for cpu:%d,"
+						, cpufreq_default_gov[cpu]
+							, cpu);
+		}
+		cpufreq_default_gov[cpu][0] = '\0';
 	}
-	set_fs(old_fs);
-}
-
-void cpufreq_set_conservative_governor(void)
-{
-	cpufreq_set_governor(cpufreq_gov_conservative);
+	return ret;
 }
 #endif /* CONFIG_TEGRA_CONVSERVATIVE_GOV_ON_EARLYSUPSEND */
-- 
1.7.1

