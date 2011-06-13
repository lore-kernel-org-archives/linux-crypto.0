From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 5/5] misc: add clocksource-based entropy generation driver
Date: Mon, 13 Jun 2011 18:06:58 -0400
Message-ID: <1308002818-27802-6-git-send-email-jarod@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1FMWHg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:07:36 -0400
In-Reply-To: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a fairly simple driver that just starts up a kernel thread that
periodically calls the active clocksource's entropy-gathering function,
if it has one. The default interval of 100us between polls doesn't show
any measurable impact to cpu usage on a core 2 duo test rig here, and
ensures the entropy pool is constantly being fed, even on a system with
no input device, no network traffic and no disk activity.

CC: Matt Mackall <mpm@selenic.com>
CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: John Stultz <johnstul@us.ibm.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/misc/Kconfig         |   14 +++++
 drivers/misc/Makefile        |    1 +
 drivers/misc/clock-entropy.c |  122 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/clock-entropy.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4e349cd..b997f6a 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -490,6 +490,20 @@ config PCH_PHUB
 	  To compile this driver as a module, choose M here: the module will
 	  be called pch_phub.
 
+config CLOCK_ENTROPY
+	tristate "Clocksource-based Entropy Generator"
+	help
+	  This is a driver that simply starts up a kernel thread that calls
+	  clocksource helper functions to periodically poll the clocksource,
+	  calculate a delta from the prior poll, and then feed the delta
+	  value along to the random number generator entropy pool. This can
+	  be useful for server systems that are otherwise starved for entropy,
+	  as there are very few sources of entropy generation, particularly
+	  on a non-busy server system.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called clock-entropy.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 5f03172..a659ad2 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -46,3 +46,4 @@ obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-y				+= lis3lv02d/
 obj-y				+= carma/
+obj-$(CONFIG_CLOCK_ENTROPY)	+= clock-entropy.o
diff --git a/drivers/misc/clock-entropy.c b/drivers/misc/clock-entropy.c
new file mode 100644
index 0000000..56d65ac
--- /dev/null
+++ b/drivers/misc/clock-entropy.c
@@ -0,0 +1,122 @@
+/*
+ * Clocksource-based entropy generator
+ *   Copyright (c) 2011 Jarod Wilson <jarod@redhat.com>
+ *
+ * Many server systems are seriously lacking in sources of entropy,
+ * as we typically only feed the entropy pool by way of input layer
+ * events, a few NIC driver interrupts and disk activity. A non-busy
+ * server can easily become entropy-starved. We can mitigate this
+ * somewhat by periodically mixing in entropy data based on the
+ * delta between multiple high-resolution clocksource reads, per:
+ *
+ *   https://www.osadl.org/Analysis-of-inherent-randomness-of-the-L.rtlws11-developers-okech.0.html
+ *
+ * Additionally, NIST already approves of similar implementations, so
+ * this should be usable in high-securtiy deployments requiring a
+ * fair chunk of available entropy data for frequent use of /dev/random.
+ * ---
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/kthread.h>
+#include <linux/clocksource.h>
+
+/* module parameters */
+static int ce_debug;
+static int interval = 100; /* microseconds */
+
+#define ce_dbg(fmt, args...)						\
+	do {								\
+		if (ce_debug)						\
+			printk(KERN_DEBUG KBUILD_MODNAME ": " fmt,	\
+				 ## args);				\
+	} while (0)
+
+/* Periodic clocksource polling thread data */
+static struct task_struct *ceg_task;
+
+/**
+ * If the current clocksource doesn't have an entropy-generation function
+ * wired up, this thread will do absolutely nothing productive, but we
+ * leave it running, in the event clocksources are changed to one of the
+ * ones that can provide entropy. We've already verified there's one that
+ * can by way of clocksource_entropy_available at init time.
+ */
+static int ceg_thread(void *arg)
+{
+	signed long timeout = usecs_to_jiffies(interval);
+
+	ce_dbg("polling thread started\n");
+
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		schedule_timeout(timeout);
+		if (kthread_should_stop())
+			break;
+
+		clocksource_add_entropy();
+	}
+
+	ce_dbg("polling thread ended\n");
+
+	return 0;
+}
+
+static int __init ceg_init(void)
+{
+	if (!clocksource_entropy_available()) {
+		pr_err(KBUILD_MODNAME ": no clocksource entropy available\n");
+		return -EINVAL;
+	}
+
+	ceg_task = kthread_run(ceg_thread, NULL, "kclock-entropy-gen");
+	if (IS_ERR(ceg_task)) {
+		pr_err(KBUILD_MODNAME ": failed to initialize kthread\n");
+		return PTR_ERR(ceg_task);
+	}
+
+	ce_dbg("Clocksource Entropy Generator initialized\n");
+
+	return 0;
+}
+
+static void __exit ceg_exit(void)
+{
+	if (!IS_ERR_OR_NULL(ceg_task)) {
+		kthread_stop(ceg_task);
+		ceg_task = NULL;
+	}
+
+	ce_dbg("Clocksource Entropy Generator unloaded\n");
+}
+
+module_init(ceg_init);
+module_exit(ceg_exit);
+
+MODULE_DESCRIPTION("Clocksource-based entropy generator");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
+MODULE_LICENSE("GPL");
+
+module_param(ce_debug, bool, 0644);
+MODULE_PARM_DESC(ce_debug, "Enable debugging messages");
+
+module_param(interval, int, 0644);
+MODULE_PARM_DESC(interval, "Clocksource sampling interval, in microseconds (default: 100us)");
-- 
1.7.1
