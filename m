Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DC6377EC2
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 13:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780319966; cv=none; b=SEtwskVddENT/gk/k9NaU3nHV5j96XW0zUhJHPE4cqX69k9r4LyrnZ9fMW+XC4ejVORBZYDUZrQqjhrRagx4Cezvn5fMGvjFoAQx5VNv/DMwbKVLu4MK87ffcq4qSVEuVNsSWodtqpvNGypjM+Ttlyl6wAAcAA9GW830HEJLgTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780319966; c=relaxed/simple;
	bh=eEcUs/0ldlHEr/vItb8TmDNfi5kAqLZm0m/4glP6n1o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=QRZfduBHQ3rF28gyqCUg+EyM8BVcLX+SFlDFMl0g9D6P5McMx+FdYRp5on5arVLd9jbKzB8KqEcBL398kWILHxbdkJamtcKzpOyWYN02sWZ09r+uaPG3AFYrE6Nxt/5fg5dm0tfleah+o11adY/CldbUPTu+cfIWt4MvmgjyMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=S5HKiG0X; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="S5HKiG0X"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 989121A37A0
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 13:19:22 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5F6756026B;
	Mon,  1 Jun 2026 13:19:22 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 67C111088822D;
	Mon,  1 Jun 2026 15:19:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780319961; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=AhwLvc5lDAjyDZ47lqpQEFRZclNmFPWmcqbIXciM6mA=;
	b=S5HKiG0XERPJPMHE9KKlNWn6Dbsd6r3HYuKVL7XaBgTphaF41YeoLmFu6ZGLBB8oblMeEI
	Qk4uvWrz6U/aEi1hWK/NB0FtJudiWR5pzm9te4ke090UsxS+qpuFV8O2Lw97MjvLwlsi6J
	r2aIL5cxD5i+eELUUs8uyfcNS11AVKnqESsafe32XX2x223lu2oPyxycEIVCtGDYoY9gpk
	RfjTE32WdiSFd9WIslhRutVqbUWYtdC1iuOXmT1pBZpzAUUvaBjsVawSXULKxt92GiL/fp
	9RZISMveqWDFohRe6GHy/7EalhgryRDcxf0kYW/wCxjc/0XliefVd8tYVK/sNQ==
From: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Date: Mon, 01 Jun 2026 15:19:13 +0200
Subject: [PATCH v2] hwrng: core - Do not read data during PM sleep
 transition
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260601-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v2-1-667ce5da32ee@bootlin.com>
X-B4-Tracking: v=1; b=H4sIANCGHWoC/52OTQ6CMBCFr0K6dgwtKYor72FYQDulTaDFKaCGc
 HcrLty7e99L3s/KIpLDyC7ZyggXF13wCcQhY8o2vkNwOjETuShzyQuwD6DG6zCAcc9E5Luk+t5
 4UNREC3GOI3oNhHEeEERldJuXxdnIiqXWkTAF98Vb/WXC+5yGp59pXZwCvfZXC/+4/x9YOHBou
 ZCSK65OWl/bEKbe+aMKA6u3bXsDjxFLPwUBAAA=
X-Change-ID: 20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-29fdb0638f59
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 gregory.clement@bootlin.com, richard.genoud@bootlin.com, u-kumar1@ti.com, 
 a-kumar2@ti.com, "Thomas Richard (TI)" <thomas.richard@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

The hwrng_fillfn() kernel thread accesses the RNG device directly. During
suspend and resume sequences, hwrng_fillfn() may attempt to access the RNG
device while it is suspended. To address this, the hwrng_fillfn() kernel
thread checks if a PM sleep transition is in progress before to access the
RNG device.

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
This patch is related to the patch [1]. But it fixes the issue in a very
different way. Patch [1] set the hwrng_fillfn() kernel thread freezable,
but this solution was not acceptable as it could introduce an important
delay in the suspend sequence (up to 10s to freeze the freezable kernel
threads).

In this second iteration, I fixed a potential uninitialized variable use.

[1] https://lore.kernel.org/all/20260427-hw-random-set-hwrng-fillfn-kthread-freezable-v1-1-9bbe4f88b43a@bootlin.com/
---
Changes in v2:
- Initialize rc variable.
- Link to v1: https://lore.kernel.org/r/20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v1-1-b12551c1c7dd@bootlin.com
---
 drivers/char/hw_random/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aba92d777f72..7a4dddbd5b51 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -25,6 +25,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/suspend.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 
@@ -516,7 +517,7 @@ ATTRIBUTE_GROUPS(rng_dev);
 static int hwrng_fillfn(void *unused)
 {
 	size_t entropy, entropy_credit = 0; /* in 1/1024 of a bit */
-	long rc;
+	long rc = 0;
 
 	while (!kthread_should_stop()) {
 		unsigned short quality;
@@ -538,8 +539,9 @@ static int hwrng_fillfn(void *unused)
 		}
 
 		mutex_lock(&reading_mutex);
-		rc = rng_get_data(rng, rng_fillbuf,
-				  rng_buffer_size(), 1);
+		if (!pm_sleep_transition_in_progress())
+			rc = rng_get_data(rng, rng_fillbuf,
+					  rng_buffer_size(), 1);
 		if (current_quality != rng->quality)
 			rng->quality = current_quality; /* obsolete */
 		quality = rng->quality;

---
base-commit: f615e82f0b35c473499583a1432ade66060a02b2
change-id: 20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-29fdb0638f59

Best regards,
-- 
Thomas Richard (TI) <thomas.richard@bootlin.com>

