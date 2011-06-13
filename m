From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/5] clocksource: add support for entropy-generation function
Date: Mon, 13 Jun 2011 18:06:55 -0400
Message-ID: <1308002818-27802-3-git-send-email-jarod@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1FMWHq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:07:46 -0400
In-Reply-To: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a new function pointer to struct clocksource that can optionally be
filled in by clocksources deemed to be high enough resolution to feed
the random number generator entropy pool.

CC: Matt Mackall <mpm@selenic.com>
CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: John Stultz <johnstul@us.ibm.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 include/linux/clocksource.h |    6 ++++++
 kernel/time/clocksource.c   |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index d4646b4..c74bcf2 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -156,6 +156,8 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @vread:		vsyscall based read
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
+ * @entropy:		random entropy pool addition function (optional, and
+ *			requires a fairly high-resolution clocksource)
  */
 struct clocksource {
 	/*
@@ -184,6 +186,7 @@ struct clocksource {
 	unsigned long flags;
 	void (*suspend)(struct clocksource *cs);
 	void (*resume)(struct clocksource *cs);
+	void (*entropy)(struct clocksource *cs);
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
@@ -279,6 +282,9 @@ extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
+extern bool clocksource_entropy_available(void);
+extern void clocksource_add_entropy(void);
+
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1c95fd6..71006ef 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -745,6 +745,39 @@ void clocksource_unregister(struct clocksource *cs)
 }
 EXPORT_SYMBOL(clocksource_unregister);
 
+/**
+ * Do we have at least one clocksource that can generate entropy?
+ */
+bool clocksource_entropy_available(void)
+{
+	struct clocksource *src;
+	bool entropy_possible = false;
+
+	mutex_lock(&clocksource_mutex);
+	list_for_each_entry(src, &clocksource_list, list) {
+		if (src->entropy) {
+			entropy_possible = true;
+			break;
+		}
+	}
+	mutex_unlock(&clocksource_mutex);
+
+	return entropy_possible;
+}
+EXPORT_SYMBOL(clocksource_entropy_available);
+
+/**
+ * Call the clocksource's entropy-generation function, if set
+ */
+void clocksource_add_entropy(void)
+{
+	if (!curr_clocksource->entropy)
+		return;
+
+	curr_clocksource->entropy(curr_clocksource);
+}
+EXPORT_SYMBOL(clocksource_add_entropy);
+
 #ifdef CONFIG_SYSFS
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
-- 
1.7.1
