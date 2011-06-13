From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 3/5] hpet: wire up entropy generation function
Date: Mon, 13 Jun 2011 18:06:56 -0400
Message-ID: <1308002818-27802-4-git-send-email-jarod@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1FMWHj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:07:39 -0400
In-Reply-To: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

HPET is high enough resolution that we can use its low-order byte to
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
 arch/x86/kernel/hpet.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 6781765..cf23090 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -10,6 +10,7 @@
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
+#include <linux/random.h>
 
 #include <asm/fixmap.h>
 #include <asm/i8253.h>
@@ -63,6 +64,22 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 	writel(d, hpet_virt_address + a);
 }
 
+static void hpet_add_entropy(void)
+{
+	static unsigned long last;
+	unsigned long counter;
+	int delta;
+
+	counter = hpet_readl(HPET_COUNTER);
+	delta = (int)(counter - last);
+	last = counter;
+
+	if (delta == counter)
+		return;
+
+	add_clocksource_randomness(delta);
+}
+
 #ifdef CONFIG_X86_64
 #include <asm/pgtable.h>
 #endif
@@ -752,6 +769,7 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
+	.entropy	= hpet_add_entropy,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
-- 
1.7.1
