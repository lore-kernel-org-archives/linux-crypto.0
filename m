Received: from mail-m1086.netease.com (mail-m1086.netease.com [154.81.10.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBED17BCA;
	Fri,  8 May 2026 04:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=154.81.10.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778214336; cv=none; b=jwjhgF+5Boy9qlzh9ilvGkTo0Wj3HB7QzXuiXbyf4HLw2fZxf+oMw3waSzmRgruUSvj5PlufrW86os6d1Qli7xoDMNwN63BMLz8LPqkkbNbX3WSmxCENXvL+TWO3qPzOq5vAOBhRjdAvVUPtoIiKzz3ygRYXpGAT1B4dWyLYh3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778214336; c=relaxed/simple;
	bh=imbmKA8/GIt1wbg+bEhZxp7IN9IP12IyqA4aYzLJD+o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e4dzl6XII9k9O1D6vM/gMnOZr4N4lRRzWWXREGRfkjb+jPeNO5VJLfPETe655WwKk83m0Yu4z+PnjBXw0BDRfFfnDCSTcn+k0nelQpFUIGNozLVO/+3fhb8yBsU2X9IoN7JE9VwtCkqVHHOKZocm+FvqOWf9gisF6m3dXHXjBig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=RwZmqKMW; arc=none smtp.client-ip=154.81.10.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="RwZmqKMW"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3d94c5089;
	Fri, 8 May 2026 12:25:27 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: clabbe@baylibre.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] crypto: amlogic - avoid double cleanup in meson_crypto_probe()
Date: Fri,  8 May 2026 12:24:16 +0800
Message-Id: <20260508042416.419216-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e05d5551b03a2kunm37bde91c1c4a92
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSxlOVk5MT0IZQ0JPT0NDTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktJSE
	5DQ1VKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=RwZmqKMWXSvafifpiB3lnaIkS/Ws2hOXUbtyBstRe+r09wGDe1p0qCRphGqU114LaSTlC11y6DthlTeD0cs89CFTfYy8DZ5moo0XraSfWDk3M5HSsYYKEkWFB2C6equZR6QfftJoGs4vJwMrZGNT6luBSP/LnUpsl/MFaOdMo9o=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=mHVqsCvb98Lei5CXFJf/akKsThFt9Vc2evrRIiE7DqE=;
	h=date:mime-version:subject:message-id:from;

When meson_allocate_chanlist() fails after a partial allocation, it already
unwinds the allocated chanlist state through its local error path.
meson_crypto_probe() then jump to error_flow and calls
meson_free_chanlist() again, causing the same per-flow resources to be torn
down twice. In the reproduced failure path, the second teardown
re-entered crypto_engine_exit() on an already destroyed worker and KASAN
reported a slab-use-after-free in kthread_destroy_worker().

Prevent double-free by handling partial allocation failures locally within
meson_allocate_chanlist() and skipping the outer cleanup path.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available.

The bug was reproduced in a QEMU x86_64 guest booted with KASAN on v7.1,
using the reproducer under tools/testing/meson_crypto_probe. The reproducer
forces the second dma_alloc_attrs() call in the gxl-crypto probe path to
return NULL, making meson_allocate_chanlist() fail after partial
initialization. On the unpatched kernel this reliably triggered a
slab-use-after-free. With this fix applied, the same reproducer no longer
emits any KASAN report and the probe fails cleanly with -ENOMEM.

    ==================================================================
    BUG: KASAN: slab-use-after-free in kthread_destroy_worker+0xb2/0xd0
    Read of size 8 at addr ff1100010c057a68 by task insmod/265

    CPU: 1 UID: 0 PID: 265 Comm: insmod Tainted: G           O        7.1.0-rc2-00376-g810af9adc907-dirty #10 PREEMPT(lazy)
    Tainted: [O]=OOT_MODULE
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x68/0xa0
     print_report+0xcb/0x5e0
     ? __virt_addr_valid+0x21d/0x3f0
     ? kthread_destroy_worker+0xb2/0xd0
     ? kthread_destroy_worker+0xb2/0xd0
     kasan_report+0xca/0x100
     ? kthread_destroy_worker+0xb2/0xd0
     kthread_destroy_worker+0xb2/0xd0
     meson_crypto_probe+0x4d0/0xc10 [amlogic_gxl_crypto]
     platform_probe+0x99/0x140
     really_probe+0x1c6/0x6a0
     ? __pfx___device_attach_driver+0x10/0x10
     __driver_probe_device+0x248/0x310
     ? acpi_driver_match_device+0xb0/0x100
     driver_probe_device+0x48/0x210
     ? __pfx___device_attach_driver+0x10/0x10
     __device_attach_driver+0x160/0x320
     bus_for_each_drv+0x104/0x190
     ? __pfx_bus_for_each_drv+0x10/0x10
     ? _raw_spin_unlock_irqrestore+0x2c/0x50
     __device_attach+0x19d/0x3b0
     ? __pfx___device_attach+0x10/0x10
     ? do_raw_spin_unlock+0x53/0x220
     device_initial_probe+0x78/0xa0
     bus_probe_device+0x5b/0x130
     device_add+0xcfd/0x1430
     ? __pfx_device_add+0x10/0x10
     ? insert_resource+0x34/0x50
     ? lock_release+0xc9/0x290
     platform_device_add+0x24e/0x590
     ? __pfx_meson_crypto_probe_repro_init+0x10/0x10 [meson_crypto_probe_repro]
     meson_crypto_probe_repro_init+0x330/0xff0 [meson_crypto_probe_repro]
     do_one_initcall+0xc0/0x450
     ? __pfx_do_one_initcall+0x10/0x10
     ? _raw_spin_unlock_irqrestore+0x2c/0x50
     ? __create_object+0x59/0x80
     ? kasan_unpoison+0x27/0x60
     do_init_module+0x27b/0x7d0
     ? __pfx_do_init_module+0x10/0x10
     ? kasan_quarantine_put+0x84/0x1d0
     ? kfree+0x32c/0x510
     ? load_module+0x561e/0x5ff0
     load_module+0x54fe/0x5ff0
     ? __pfx_load_module+0x10/0x10
     ? security_file_permission+0x20/0x40
     ? kernel_read_file+0x23d/0x6e0
     ? mmap_region+0x235/0x4a0
     ? __pfx_kernel_read_file+0x10/0x10
     ? __file_has_perm+0x2c0/0x3e0
     init_module_from_file+0x158/0x180
     ? __pfx_init_module_from_file+0x10/0x10
     ? __lock_acquire+0x45a/0x1ba0
     ? idempotent_init_module+0x315/0x610
     ? lock_release+0xc9/0x290
     ? lockdep_init_map_type+0x4b/0x220
     ? do_raw_spin_unlock+0x53/0x220
     idempotent_init_module+0x330/0x610
     ? __pfx_idempotent_init_module+0x10/0x10
     ? __pfx_cred_has_capability.isra.0+0x10/0x10
     ? ksys_mmap_pgoff+0x385/0x520
     __x64_sys_finit_module+0xbe/0x120
     do_syscall_64+0x115/0x690
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    RIP: 0033:0x7f7d6d31690d
    Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f3 b4 0f 00 f7 d8 >
    RSP: 002b:00007fffc027ac68 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
    RAX: ffffffffffffffda RBX: 000055f7b81967c0 RCX: 00007f7d6d31690d
    RDX: 0000000000000000 RSI: 000055f79a0d6cd2 RDI: 0000000000000003
    RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000003 R11: 0000000000000246 R12: 000055f79a0d6cd2
    R13: 000055f7b8196790 R14: 000055f79a0d5888 R15: 000055f7b81968e0
     </TASK>

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 1c18a5b8470e..6cb33949915f 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -291,8 +291,8 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	return 0;
 error_alg:
 	meson_unregister_algs(mc);
-error_flow:
 	meson_free_chanlist(mc, MAXFLOW - 1);
+error_flow:
 	clk_disable_unprepare(mc->busclk);
 	return err;
 }
-- 
2.34.1

