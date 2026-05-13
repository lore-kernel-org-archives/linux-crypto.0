Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ED026FDBF;
	Wed, 13 May 2026 09:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778664474; cv=none; b=utl38L25iCKG28ACpNAnh5I2Z/JgNuzEHdIpwaYYKHQ7QMRzkDkMYGAJo6mMBN4naSYPyMmSo3TgiSzArS30Yeb1pktV27l01wPse4T1edMBJtFZGE/JqMfOz/8fzblK7zJEnYT/zanJSU/0Azo6/kjWJySInyF9kqLrPkfKvHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778664474; c=relaxed/simple;
	bh=2Uh0T20PWK8tYzeY8NL2darvoifBT/kbsZ5QsaE/n/Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=PV7WHsdMoVAfWzLScc7aBK27fEEvqjUyL2+c0fdXKEArBdmzulEFiF5/INNR3BC3LaRkgrEr3fnUmLXy4+c8ltQ79P7Kx9Yroq4OJk69xz/AV9xCHVu+/E6gxdJcF+3AASAroQGh1O+L/e83c69TB/T44ZQmGeq9x1WXY4KXFfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=w3JIe2pB; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="w3JIe2pB"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id B7DB54E42C8C;
	Wed, 13 May 2026 09:27:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8954B606CE;
	Wed, 13 May 2026 09:27:48 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0E20311AF88C6;
	Wed, 13 May 2026 11:27:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778664467; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=HivRlQUOmEX/kO9xOylHi3i91TKLRUf+G5/spN7sj70=;
	b=w3JIe2pBgKxAV4SDpfkQLqiDjK4rer2FIgMD6C+s5UcpLKNl4U0bFwDjSmdMaNaPOlw0JB
	5weYJ1eZ+Whrl5eq4dEt25T4plFsYhhYW0/ZBkThyj/juZ1+JIpK4bBfEh5m0vBNWYIxFP
	9MpMSta9CYC1qA8AmDNAMNiwKBFlEkjncua5CSaEYUc57ZxLnIHx8Wl315twcNIr4/6zeX
	Cnth0OlikRUX/0Etz2sRm3wkz3FPT+gbqZ+DwApUJxt8or7SODpC4nvotrSUui37keRfeD
	KbjHI6jAy4ijheaEhb1lDdFuCKzOqq0NClv6ayjkRCFhiTtbJZtkMDq5ZE1daw==
From: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Date: Wed, 13 May 2026 11:27:37 +0200
Subject: [PATCH] hwrng: core - Do not read data during PM sleep transition
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v1-1-b12551c1c7dd@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAhEBGoC/y2NwQ6CMBBEf4X07CalBCL+ivFQ6ZY2gQV3qZoQ/
 t2Neps3yczbjSBnFHOpdsP4zJIXUqhPlRmSpxEhB2XjrOtsWzeQXsCewjJDzG8lplHTNEWCgb0
 kkCIrUgBGKTOC62O42645x7Y3+roy6vBrvN5+zPgoKt7+5XF8AKsiOj2WAAAA
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

Issue was found while doing suspend-to-ram on J72S2 EVM board with omap-rng
driver.

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

[1] https://lore.kernel.org/all/20260427-hw-random-set-hwrng-fillfn-kthread-freezable-v1-1-9bbe4f88b43a@bootlin.com/
---
 drivers/char/hw_random/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aba92d777f72..98178f903335 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -25,6 +25,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/suspend.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 
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

