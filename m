From: Brandon Philips <brandon@ifup.org>
Subject: Fixing gave up waiting for init of module libcrc32c.
Date: Fri, 19 Mar 2010 16:40:45 -0700
Message-ID: <20100319234044.GA5127@jenkins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:59059 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0CSXmZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Mar 2010 19:42:25 -0400
Received: by gxk9 with SMTP id 9so2114072gxk.8
        for <linux-crypto@vger.kernel.org>; Fri, 19 Mar 2010 16:42:24 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert, Dave-

I have a little "lockup" in libcrc32c on boot and I don't know how to
solve it correctly but there are a few ideas.

First, note this bug is happening with bnx2x. But, since I didn't have
the hardware I added usage of crc32c to bnx2 to reproduce.

Here are backtraces of the two processes and the relevant dmesg
output:

[   61.816131] ehci_hcd 0000:00:1d.7: suspend root hub
[   91.512113] bnx2: gave up waiting for init of module libcrc32c.
[   91.524105] bnx2: Unknown symbol crc32c
[   92.215003] bp: lib/libcrc32c.c:66 libcrc32c_mod_init crypto_alloc_shash SUCCESS
[   92.401131] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.0.4 (Mar 03, 2010)
[   92.401262]   alloc irq_desc for 16 on node 0
[   92.401266]   alloc kstat_irqs on node 0
[   92.401282] bnx2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16

The issue is that bnx2 is waiting for crc32c on use_module while
libcrc32c is trying to insert crc32-generic to resolve the symbol. You
can see it here via the process stacks for modprobe:

[0]kdb> btp 1661  # modprobe for bnx2
Stack traceback for pid 1661
0xffff88051209ddc0     1661     1657  0   13   S  0xffff88051209e300  modprobe
[   75.797063]  ffff8805131e7c78 0000000000000046 0000000000000000 0000000000000000
[   75.797063]  000000000000e480 ffff8805131e7fd8 ffff88051209ddc0 ffff88051209e1c0
[   75.797063]  00000000ffff1edb ffffffff8109517d ffff8800283ae480 ffff8800283b3e18
[   75.797063] Call Trace:
[   75.797063]  [<ffffffff81437785>] schedule_timeout+0x1e5/0x2f0
[   75.797063]  [<ffffffff810a5e7b>] use_module+0x2eb/0x330
[   75.797063]  [<ffffffff810a7605>] load_module+0x1545/0x1e10
[   75.797063]  [<ffffffff810a7f51>] sys_init_module+0x81/0x2b0
[   75.797063]  [<ffffffff810031ab>] system_call_fastpath+0x16/0x1b
[   75.797063]  [<00007f4bf994dfba>] 0x7f4bf994dfba
[0]kdb> 
[0]kdb> 
[0]kdb> 
[0]kdb> btp 1662 #modprobe for libcrc32c
Stack traceback for pid 1662  # modprobe for libcrc32c blocking on 
0xffff880513278980     1662     1658  0   13   D  0xffff880513278ec0  modprobe
[   75.797063]  ffff88051254bb28 0000000000000046 ffff88051254baf8 ffff88051254baf4
[   75.797063]  000000000000e480 ffff88051254bfd8 ffff880513278980 ffff880513278d80
[   75.797063]  00000000ffff1e51 ffff8800282d3e00 ffff8800283ae480 ffff8800283b3e18
[   75.797063] Call Trace:
[   75.797063]  [<ffffffff814377fd>] schedule_timeout+0x25d/0x2f0
[   75.797063]  [<ffffffff8143652b>] wait_for_common+0xdb/0x190
[   75.797063]  [<ffffffff8143669d>] wait_for_completion+0x1d/0x20
[   75.797063]  [<ffffffff810787d2>] call_usermodehelper_exec+0xd2/0xe0
[   75.797063]  [<ffffffff81078a7c>] __request_module+0x19c/0x1f0
[   75.797063]  [<ffffffff8122184f>] crypto_larval_lookup+0x10f/0x210
[   75.797063]  [<ffffffff812219b3>] crypto_alg_mod_lookup+0x63/0xf0
[   75.797063]  [<ffffffff81220cae>] crypto_find_alg+0xae/0xd0
[   75.797063]  [<ffffffff812215a4>] crypto_alloc_tfm+0x84/0x100
[   75.797063]  [<ffffffff81227fb9>] crypto_alloc_shash+0x19/0x20
[   75.797063]  [<ffffffffa0131035>] libcrc32c_mod_init+0x35/0x72 [libcrc32c]
[   75.797063]  [<ffffffff810001ed>] do_one_initcall+0x3d/0x1c0
[   75.797063]  [<ffffffff810a7fbd>] sys_init_module+0xed/0x2b0
[   75.797063]  [<ffffffff810031ab>] system_call_fastpath+0x16/0x1b
[   75.797063]  [<00007f4aeefaffba>] 0x7f4aeefaffba

Possible solutions:

1) Figure out the right place to drop the module_lock while waiting on
other modules to load. This boots and seems to work but who knows what
it will break. :) This might be the right fix after investigating
possible issues.

Index: linux-2.6.32/kernel/module.c
===================================================================
--- linux-2.6.32.orig/kernel/module.c
+++ linux-2.6.32/kernel/module.c
@@ -678,6 +678,8 @@ int use_module(struct module *a, struct
 
 	if (b == NULL || already_uses(a, b)) return 1;
 
+	mutex_unlock(&module_mutex);
+
 	/* If we're interrupted or time out, we fail. */
 	if (wait_event_interruptible_timeout(
 		    module_wq, (err = strong_try_module_get(b)) != -EBUSY,
@@ -687,6 +689,8 @@ int use_module(struct module *a, struct
 		return 0;
 	}
 
+	mutex_lock(&module_mutex);
+
 	/* If strong_try_module_get() returned a different error, we fail. */
 	if (err)
 		return 0;

2) Force libcrc32c to be built in?

3) Tell everyone to load it first thing in initrd? This seems hacky.

What are you thoughts on the right way to fix this?

Cheers,

	Brandon
