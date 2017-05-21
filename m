From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: DEADLOCK: bisected to d215aab82d81974f438bfbc80aa437132f3c37c3
 ("cpu/hotplug: Convert hotplug locking to percpu rwsem")
Date: Sun, 21 May 2017 17:44:16 +0200
Message-ID: <20170521154416.GA25687@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: tglx@linutronix.de, steffen.klassert@secunet.com,
        peterz@infradead.org, bigeasy@linutronix.de, rostedt@goodmis.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37255 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752722AbdEUPoW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 11:44:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

Since linux-next-20170517 at least I got the following DEADLOCK warning:
[    4.311614] ============================================
[    4.316919] WARNING: possible recursive locking detected
[    4.322227] 4.12.0-rc1-next-20170517+ #273 Not tainted
[    4.327360] --------------------------------------------
[    4.332665] swapper/0/1 is trying to acquire lock:
[    4.337451]  (cpu_hotplug_lock.rw_sem){++++++}, at: [<c01cc998>] stop_machine+0x1c/0x3c
[    4.345468] 
               but task is already holding lock:
[    4.351294]  (cpu_hotplug_lock.rw_sem){++++++}, at: [<c01f4534>] static_key_slow_inc+0x14/0x24
[    4.359911] 
               other info that might help us debug this:
[    4.366431]  Possible unsafe locking scenario:

[    4.372344]        CPU0
[    4.374789]        ----
[    4.377233]   lock(cpu_hotplug_lock.rw_sem);
[    4.381504]   lock(cpu_hotplug_lock.rw_sem);
[    4.385775] 
                *** DEADLOCK ***

[    4.391691]  May be due to missing lock nesting notation

[    4.398472] 5 locks held by swapper/0/1:
[    4.402390]  #0:  (net_mutex){+.+.+.}, at: [<c05d4800>] register_pernet_subsys+0x28/0x48
[    4.410491]  #1:  (register_ipv4_hooks){+.+.+.}, at: [<c06a409c>] ipv4_hooks_register+0xdc/0x1e0
[    4.419285]  #2:  (defrag4_mutex){+.+.+.}, at: [<c06a4d90>] nf_defrag_ipv4_enable+0x48/0x8c
[    4.427643]  #3:  (cpu_hotplug_lock.rw_sem){++++++}, at: [<c01f4534>] static_key_slow_inc+0x14/0x24
[    4.436694]  #4:  (jump_label_mutex){+.+...}, at: [<c01f44ac>] __static_key_slow_inc+0x78/0xec
[    4.445312] 
               stack backtrace:
[    4.449669] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.12.0-rc1-next-20170517+ #273
[    4.457402] Hardware name: Allwinner sun8i Family
[    4.462100] Backtrace: 
[    4.464557] [<c010c6d8>] (dump_backtrace) from [<c010c9b0>] (show_stack+0x18/0x1c)
[    4.472121]  r7:c0c2dbd0 r6:00000000 r5:20000093 r4:c0c2dbd0
[    4.477780] [<c010c998>] (show_stack) from [<c03e863c>] (dump_stack+0xac/0xd8)
[    4.485002] [<c03e8590>] (dump_stack) from [<c017640c>] (__lock_acquire+0xbc0/0x19f0)
[    4.492829]  r10:ef05b200 r9:c0d8779c r8:00000000 r7:c0c2dcc0 r6:00000000 r5:c1480500
[    4.500649]  r4:c0d8779c r3:60000093
[    4.504228] [<c017584c>] (__lock_acquire) from [<c0177a00>] (lock_acquire+0x74/0x90)
[    4.511967]  r10:c0b37858 r9:c0c55348 r8:00000001 r7:00000001 r6:60000013 r5:00000000
[    4.519786]  r4:ffffe000
[    4.522324] [<c017798c>] (lock_acquire) from [<c0125500>] (get_online_cpus+0x58/0xe0)
[    4.530140]  r8:c0959570 r7:c01cc998 r6:c0c18ff4 r5:00000000 r4:c0c19644
[    4.536838] [<c01254a8>] (get_online_cpus) from [<c01cc998>] (stop_machine+0x1c/0x3c)
[    4.544662]  r7:c09bd668 r6:00000000 r5:ef04dce8 r4:c010f964
[    4.550320] [<c01cc97c>] (stop_machine) from [<c010f9b0>] (patch_text+0x2c/0x34)
[    4.557709]  r7:c09bd668 r6:c1498a14 r5:c0c58b64 r4:c06ad878
[    4.563367] [<c010f984>] (patch_text) from [<c010f79c>] (arch_jump_label_transform+0x28/0x44)
[    4.571886] [<c010f774>] (arch_jump_label_transform) from [<c01f3a68>] (__jump_label_update+0x94/0x9c)
[    4.581181]  r5:c0c58b64 r4:c0c58a68
[    4.584758] [<c01f39d4>] (__jump_label_update) from [<c01f415c>] (jump_label_update+0x94/0x130)
[    4.593448]  r7:c09bd668 r6:eea252c0 r5:c1498a14 r4:c0c58b64
[    4.599105] [<c01f40c8>] (jump_label_update) from [<c01f450c>] (__static_key_slow_inc+0xd8/0xec)
[    4.607881]  r7:c09bd668 r6:eea252c0 r5:c0c57964 r4:c1498a14
[    4.613538] [<c01f4434>] (__static_key_slow_inc) from [<c01f453c>] (static_key_slow_inc+0x1c/0x24)
[    4.622486]  r5:c0c57964 r4:c1498a14
[    4.626067] [<c01f4520>] (static_key_slow_inc) from [<c0617284>] (nf_register_net_hook+0x148/0x1a8)
[    4.635102]  r5:c0c57964 r4:c0c501c0
[    4.638682] [<c061713c>] (nf_register_net_hook) from [<c0617bd8>] (nf_register_net_hooks+0x40/0x78)
[    4.647721]  r9:c0c55348 r8:00000002 r7:c0c4fd00 r6:c0c57b15 r5:00000000 r4:c0c55348
[    4.655461] [<c0617b98>] (nf_register_net_hooks) from [<c06a4dbc>] (nf_defrag_ipv4_enable+0x74/0x8c)
[    4.664587]  r9:c0c578ae r8:00000009 r7:00000009 r6:c0c57b15 r5:c0c4fd00 r4:00000000
[    4.672319] [<c06a4d48>] (nf_defrag_ipv4_enable) from [<c06a4164>] (ipv4_hooks_register+0x1a4/0x1e0)
[    4.681441]  r5:c0c4fd00 r4:eea25180
[    4.685022] [<c06a3fc0>] (ipv4_hooks_register) from [<c0623e10>] (nf_ct_l3proto_pernet_register+0x30/0x3c)
[    4.694666]  r7:ef0dc800 r6:c0c4fd00 r5:c0c4fd00 r4:00000000
[    4.700325] [<c0623de0>] (nf_ct_l3proto_pernet_register) from [<c06a45f0>] (ipv4_net_init+0x30/0x68)
[    4.709452] [<c06a45c0>] (ipv4_net_init) from [<c05d3e04>] (ops_init+0x104/0x16c)
[    4.716926]  r5:eea25180 r4:c0c552a0
[    4.720506] [<c05d3d00>] (ops_init) from [<c05d4734>] (register_pernet_operations+0x108/0x1ac)
[    4.729111]  r9:c0c43cb4 r8:ef04de70 r7:c0c4fcd0 r6:c0c552a0 r5:00000000 r4:c0c4fd00
[    4.736852] [<c05d462c>] (register_pernet_operations) from [<c05d480c>] (register_pernet_subsys+0x34/0x48)
[    4.746497]  r9:00000000 r8:c0c607c0 r7:c0b37850 r6:c0c552a0 r5:c0c4fc44 r4:c0c4fc40
[    4.754241] [<c05d47d8>] (register_pernet_subsys) from [<c0b2cf5c>] (nf_conntrack_l3proto_ipv4_init+0x38/0xb4)
[    4.764232]  r7:c0b37850 r6:ffffe000 r5:c0b2cf24 r4:00000000
[    4.769893] [<c0b2cf24>] (nf_conntrack_l3proto_ipv4_init) from [<c0101954>] (do_one_initcall+0x5c/0x198)
[    4.779361]  r5:c0b2cf24 r4:c0c0f4cc
[    4.782942] [<c01018f8>] (do_one_initcall) from [<c0b00ff0>] (kernel_init_freeable+0x254/0x2e8)
[    4.791635]  r9:00000007 r8:c0c607c0 r7:c0b37850 r6:c0c607c0 r5:c0b48060 r4:c09ff118
[    4.799377] [<c0b00d9c>] (kernel_init_freeable) from [<c070c1d8>] (kernel_init+0x10/0x118)
[    4.807635]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c070c1c8
[    4.815454]  r4:00000000
[    4.817995] [<c070c1c8>] (kernel_init) from [<c0107f70>] (ret_from_fork+0x14/0x24)
[    4.825555]  r5:c070c1c8 r4:00000000

I bisected the issue to commit d215aab82d81974f438bfbc80aa437132f3c37c3 "cpu/hotplug: Convert hotplug locking to percpu rwsem"

i try to revert the patch but get:
  CC      kernel/jump_label.o
/linux-next/kernel/jump_label.c:124:6: warning: no previous prototype for '__static_key_slow_inc' [-Wmissing-prototypes]
 void __static_key_slow_inc(struct static_key *key)
      ^~~~~~~~~~~~~~~~~~~~~
/linux-next/kernel/jump_label.c: In function '__static_key_slow_dec':
/linux-next/kernel/jump_label.c:194:2: error: implicit declaration of function 'lockdep_assert_hotplug_held' [-Werror=implicit-function-declaration]
didnt try to go further.

Regards
Corentin Labbe
