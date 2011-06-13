From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 18:06:57 -0400
Message-ID: <1308002818-27802-5-git-send-email-jarod@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab1FMWHo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:07:44 -0400
In-Reply-To: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

TSC is high enough resolution that we can use its low-order byte to
stir new data into the random number generator entropy pool.

CC: Matt Mackall <mpm@selenic.com>
CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: John Stultz <johnstul@us.ibm.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 arch/x86/kernel/tsc.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6cc6922..d206ec3 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -10,6 +10,7 @@
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
 #include <linux/timex.h>
+#include <linux/random.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
@@ -768,11 +769,28 @@ static void resume_tsc(struct clocksource *cs)
 	clocksource_tsc.cycle_last = 0;
 }
 
+static void tsc_add_entropy(void)
+{
+	static u64 last;
+	u64 counter;
+	int delta;
+
+	rdtscll(counter);
+	delta = (int)(counter - last);
+	last = counter;
+
+	if (delta == counter)
+		return;
+
+	add_clocksource_randomness(delta);
+}
+
 static struct clocksource clocksource_tsc = {
 	.name                   = "tsc",
 	.rating                 = 300,
 	.read                   = read_tsc,
 	.resume			= resume_tsc,
+	.entropy		= tsc_add_entropy,
 	.mask                   = CLOCKSOURCE_MASK(64),
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
-- 
1.7.1
