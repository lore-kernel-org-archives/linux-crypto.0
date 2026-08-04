Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5807842AFA8
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 10:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837695; cv=none; b=kqse4T8C+QqsdBxENpaTsSPoE3hP4ut0Hx+0zztKyQgiE4Xtn4q7Y624hFzahEi/DbaKLFtqdeV0MOrQ79Qd5rkI3iTZXk+iP80GKKBcL1lq5/nA5v+TymjcO+BdwjRcV+55Flf8+4iwJIlS7TAFTWDsnHBP64L0SYIkwy7KPkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837695; c=relaxed/simple;
	bh=X03s9PCSkSi3brBeB6EdVja2JGDzhqtXLv4+zcTny/4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IJExcT7LuaK1MEMZqOMdLmVxkF6vTyUYvnpmOffR0NSBzZVF+L2XEtqPIp8hhmPOikkpOiu2R3EYPjJC7KUKZvPabMKQYwT24lS57Ea5YYoq2BnQ+DmSMhMttm/JjS0unSmerxA3BbTnUMJlJgGqivDTdULlulumANKVathp17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=LYKOvnhE; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="LYKOvnhE"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 90A951A13F8;
	Tue,  4 Aug 2026 10:01:30 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 652A86029E;
	Tue,  4 Aug 2026 10:01:30 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 851D711C32887;
	Tue,  4 Aug 2026 12:01:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1785837689; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=g6I/PFKk4nKbD1PZYafLrDLEm5gGmEAsd+yGs0eCgYg=;
	b=LYKOvnhElbikZ9iCUPn7bzyM8Rh6rI5aD14isrqHozdN2ElomvLUsh33pIRIrYg7MgEuBt
	Ol6uSnv95+FSiqFmd+cvoU7DHi5Xhq3e6eh2cbFCVyfBBDp1K4IOWp/zqm+bzKy0WuXUFo
	9pDJ6uuaTRc+kCGngYC4fR9Ae88ZlM6KSkffqR/DD7eq43AfbFlN1QTU4iQraj4p9ieBIx
	m4utbeN17F2YYTkYZVXDpwlySqHx/u5SGcJcREb5sbkjLWFW2Xm8unhnOLQZI3/vOSYg8u
	iTDPdNhMJQGoHl7kNYwb35oz73GXaF9ojKu7F63Ofv+HVlRcgx+xHRr0C5VOXg==
From: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Date: Tue, 04 Aug 2026 12:01:09 +0200
Subject: [PATCH v5] hwrng: core - Stop/start hwrng_fillfn() kthread
 before/after suspend-resume
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v5-1-c4769b3c007b@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/53QzW7DIAwH8FepOI+Jj5g0Pe09qh4CmAYpgQ6Sb
 FOVdx/pDtnU03Lz3xL8bN9JxuQxk9PhThLOPvsYSoCXAzFdG65IvS2ZCCYUAy5p90FTG2wcqPO
 fJaVwLVXfu0BNanNH85RvGCxNmKcBqWic1UzJo4OGlF9vCcvDh3i+/OSE71OBx63Z+TzG9PWYa
 uZrd/8AM6ecai4AuOGmtvZNxzj2PryaOJBVm8UmKMb/L4giKFUbBNtKgfgsyE2o2Y4d5LpDzRU
 Y3Rgnj89C9UvYc6VqFcDpyoBgmsFfYVmWb+OrfwIrAgAA
X-Change-ID: 20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-29fdb0638f59
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 gregory.clement@bootlin.com, richard.genoud@bootlin.com, u-kumar1@ti.com, 
 a-kumar2@ti.com, "Thomas Richard (TI)" <thomas.richard@bootlin.com>
X-Mailer: b4 0.15.2
X-Last-TLS-Session-Version: TLSv1.3

The hwrng_fillfn() kernel thread accesses the RNG device directly. During
suspend and resume sequences, hwrng_fillfn() may attempt to access the RNG
device while it is suspended. To address this, the hwrng_fillfn() kernel
thread is stopped before suspend, and restarted after resume. This is done
using the pm_notifier mechanism.

Issue was found while doing suspend-to-ram on J721S2 EVM board with
omap-rng driver.

echo mem > /sys/power/state
[   27.922259] PM: suspend entry (deep)
[   27.927191] Filesystems sync: 0.000 seconds
[   27.933858] Freezing user space processes
[   27.939119] Freezing user space processes completed (elapsed 0.001 seconds)
[   27.946090] OOM killer disabled.
[   27.949315] Freezing remaining freezable tasks
[   27.954887] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[   27.963337] GFP mask restricted
[   27.967069] omap_rng 4e10000.rng: PM: calling platform_pm_suspend @ 195, parent: 4e00000.crypto
[   27.967072] mmcblk mmc1:9fb0: PM: calling mmc_bus_suspend @ 122, parent: mmc1
[   27.968636] mmcblk mmc1:9fb0: PM: mmc_bus_suspend returned 0 after 1546 usecs
[   27.975778] omap_rng 4e10000.rng: PM: platform_pm_suspend returned 0 after 3 usecs
...
[   33.510667] ti-sci 44083000.system-controller: PM: ti_sci_suspend_noirq returned 0 after 0 usecs
[   33.510671] SError Interrupt on CPU0, code 0x00000000bf000000 -- SError
[   33.510681] CPU: 0 UID: 0 PID: 132 Comm: hwrng Tainted: G   M    W           7.0.0-12695-g8923b7a6e11d #19 PREEMPT
[   33.510690] Tainted: [M]=MACHINE_CHECK, [W]=WARN
[   33.510693] Hardware name: Texas Instruments J721S2 EVM (DT)
[   33.510697] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   33.510701] pc : omap_rng_do_read+0x3c/0xe0
[   33.510709] lr : omap_rng_do_read+0x58/0xe0
[   33.510712] sp : ffff80008942be00
[   33.510713] x29: ffff80008942be00 x28: 0000000000000000 x27: 0000000000000000
[   33.510719] x26: 0000000000000010 x25: 0000000000000010 x24: ffff0008065644e8
[   33.510724] x23: ffff8000878b3370 x22: ffff00080148b2c0 x21: 0000000000000000
[   33.510728] x20: ffff000806564480 x19: 0000000000000064 x18: 0000000000000000
[   33.510732] x17: 6573752031207265 x16: 7466612030206465 x15: 6e72757465722071
[   33.510737] x14: ffff0008062c8080 x13: 000031702bc0da42 x12: 0000000000000001
[   33.510741] x11: 00000000000000c0 x10: 0000000000000b30 x9 : ffff80008942bc80
[   33.510745] x8 : ffff0008062c8b90 x7 : ffff000b7dfa34c0 x6 : 0000000805ca16c1
[   33.510749] x5 : 0000000000000000 x4 : ffff800080e17bfc x3 : ffff800087389c68
[   33.510753] x2 : 0000000000000000 x1 : 0000000000000010 x0 : 000000000000a7c6
[   33.510759] Kernel panic - not syncing: Asynchronous SError Interrupt
[   33.510762] CPU: 0 UID: 0 PID: 132 Comm: hwrng Tainted: G   M    W           7.0.0-12695-g8923b7a6e11d #19 PREEMPT
[   33.510767] Tainted: [M]=MACHINE_CHECK, [W]=WARN
[   33.510768] Hardware name: Texas Instruments J721S2 EVM (DT)
[   33.510770] Call trace:
[   33.510772]  show_stack+0x18/0x24 (C)
[   33.510780]  dump_stack_lvl+0x34/0x8c
[   33.510788]  dump_stack+0x18/0x24
[   33.510792]  vpanic+0x47c/0x4dc
[   33.510799]  do_panic_on_target_cpu+0x0/0x1c
[   33.510803]  add_taint+0x0/0xbc
[   33.510807]  arm64_serror_panic+0x70/0x80
[   33.510812]  do_serror+0x3c/0x70
[   33.510815]  el1h_64_error_handler+0x34/0x50
[   33.510823]  el1h_64_error+0x6c/0x70
[   33.510827]  omap_rng_do_read+0x3c/0xe0 (P)
[   33.510831]  hwrng_fillfn+0x98/0x330
[   33.510834]  kthread+0x130/0x13c
[   33.510845]  ret_from_fork+0x10/0x20
[   33.510850] SMP: stopping secondary CPUs
[   33.519442] Kernel Offset: disabled
[   33.519444] CPU features: 0x04000000,800a0008,00040001,0400421b
[   33.519448] Memory Limit: none
[   33.732904] ---[ end Kernel panic - not syncing: Asynchronous SError Interrupt ]---

Signed-off-by: Thomas Richard (TI) <thomas.richard@bootlin.com>
---
In this fifth iteration, after the PM notifier stops the hwrng_fillfn()
kthread, release the mutex so userspace can set a RNG device or read data
before the kernel freezes all threads. Add a hwrng_fillfn_stopped flag to
prevent the hwrng_fillfn() kthread from restarting after being stopped by
the PM notifier and before threads freezing completes.
---
Changes in v5:
- release rng_mutex once hwrng_fillfn() kthread is stopped
- add hwrng_fillfn_stopped flag to prevent hwrng_fillfn() kthread restarting
- Link to v4: https://lore.kernel.org/r/20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05@bootlin.com

Changes in v4:
- use lockdep_assert_held() instead of BUG_ON()
- Link to v3: https://lore.kernel.org/r/20260703-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v3-1-b7165cb9cf38@bootlin.com

Changes in v3:
- use pm_notifier to stop/start the hwrng_fillfn() kthread before/after
  suspend-resume.
- Link to v2: https://lore.kernel.org/r/20260601-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v2-1-667ce5da32ee@bootlin.com

Changes in v2:
- Initialize rc variable.
- Link to v1: https://lore.kernel.org/r/20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v1-1-b12551c1c7dd@bootlin.com

To: Olivia Mackall <olivia@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/char/hw_random/core.c | 101 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 86 insertions(+), 15 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 6931657ad2ca..3c08fafa63a1 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -17,14 +17,17 @@
 #include <linux/hw_random.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/lockdep.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/suspend.h>
 #include <linux/sysfs.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
@@ -45,6 +48,8 @@ static DEFINE_MUTEX(rng_mutex);
 static DEFINE_MUTEX(reading_mutex);
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
+/* Set to true during suspend-resume by PM notifier, protected by rng_mutex */
+static bool hwrng_fillfn_stopped;
 static unsigned short current_quality;
 static unsigned short default_quality = 1024; /* default to maximum */
 
@@ -57,6 +62,8 @@ MODULE_PARM_DESC(default_quality,
 
 static int hwrng_init(struct hwrng *rng);
 static int hwrng_fillfn(void *unused);
+static void hwrng_start_hwrng_fillfn(void);
+static void hwrng_stop_hwrng_fillfn(void);
 
 static size_t rng_buffer_size(void)
 {
@@ -114,13 +121,7 @@ static int set_current_rng(struct hwrng *rng)
 	}
 
 	/* if necessary, start hwrng thread */
-	if (!hwrng_fill) {
-		hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
-		if (IS_ERR(hwrng_fill)) {
-			pr_err("hwrng_fill thread creation failed\n");
-			hwrng_fill = NULL;
-		}
-	}
+	hwrng_start_hwrng_fillfn();
 
 	return 0;
 }
@@ -137,10 +138,7 @@ static void drop_current_rng(void)
 	RCU_INIT_POINTER(current_rng, NULL);
 	synchronize_rcu();
 
-	if (hwrng_fill) {
-		kthread_stop(hwrng_fill);
-		hwrng_fill = NULL;
-	}
+	hwrng_stop_hwrng_fillfn();
 
 	/* decrease last reference for triggering the cleanup */
 	kref_put(&rng->ref, cleanup_rng);
@@ -506,6 +504,36 @@ static struct attribute *rng_dev_attrs[] = {
 
 ATTRIBUTE_GROUPS(rng_dev);
 
+static void hwrng_start_hwrng_fillfn(void)
+{
+	lockdep_assert_held(&rng_mutex);
+
+	/*
+	 * PM notifier stopped the hwrng_fillfn kthread, prevent userspace to
+	 * restart it until kernel freezes threads.
+	 */
+	if (hwrng_fillfn_stopped)
+		return;
+
+	if (!hwrng_fill) {
+		hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
+		if (IS_ERR(hwrng_fill)) {
+			pr_err("hwrng_fill thread creation failed\n");
+			hwrng_fill = NULL;
+		}
+	}
+}
+
+static void hwrng_stop_hwrng_fillfn(void)
+{
+	lockdep_assert_held(&rng_mutex);
+
+	if (hwrng_fill) {
+		kthread_stop(hwrng_fill);
+		hwrng_fill = NULL;
+	}
+}
+
 static int hwrng_fillfn(void *unused)
 {
 	size_t entropy, entropy_credit = 0; /* in 1/1024 of a bit */
@@ -559,6 +587,37 @@ static int hwrng_fillfn(void *unused)
 	return 0;
 }
 
+static int hwrng_pm_notifier(struct notifier_block *nb, unsigned long action,
+			     void *data)
+{
+	switch (action) {
+	case PM_SUSPEND_PREPARE:
+	case PM_HIBERNATION_PREPARE:
+	case PM_RESTORE_PREPARE:
+		mutex_lock(&rng_mutex);
+		hwrng_stop_hwrng_fillfn();
+		hwrng_fillfn_stopped = true;
+		mutex_unlock(&rng_mutex);
+		break;
+
+	case PM_POST_SUSPEND:
+	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
+		mutex_lock(&rng_mutex);
+		hwrng_fillfn_stopped = false;
+		if (rcu_access_pointer(current_rng))
+			hwrng_start_hwrng_fillfn();
+		mutex_unlock(&rng_mutex);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block hwrng_pm_nb = {
+	.notifier_call = hwrng_pm_notifier,
+};
+
 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
@@ -705,10 +764,20 @@ static int __init hwrng_modinit(void)
 	}
 
 	ret = misc_register(&rng_miscdev);
-	if (ret) {
-		kfree(rng_fillbuf);
-		kfree(rng_buffer);
-	}
+	if (ret)
+		goto misc_err;
+
+	ret = register_pm_notifier(&hwrng_pm_nb);
+	if (ret)
+		goto pm_err;
+
+	return 0;
+
+pm_err:
+	misc_deregister(&rng_miscdev);
+misc_err:
+	kfree(rng_fillbuf);
+	kfree(rng_buffer);
 
 	return ret;
 }
@@ -721,6 +790,8 @@ static void __exit hwrng_modexit(void)
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
 
+	unregister_pm_notifier(&hwrng_pm_nb);
+
 	misc_deregister(&rng_miscdev);
 }
 

---
base-commit: 1a2019c545555ad5669249997872451a0d6162df
change-id: 20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-29fdb0638f59

Best regards,
--  
Thomas Richard (TI) <thomas.richard@bootlin.com>

