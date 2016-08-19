From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Git bisected regression for ipsec/aead
Date: Fri, 19 Aug 2016 15:21:24 -0400
Message-ID: <20160819192124.GF25320@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: joshua.a.hay@intel.com, steffen.klassert@secunet.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37856 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754432AbcHSTVh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 15:21:37 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi Herbert,

In the process of testing ipsec I ran into panics (details below)
with  the algorithm
"aead rfc4106(gcm(aes)) 0x1234567890123456789012345678901234567890 64"

git-bisect analyzed this down to

   7271b33cb87e80f3a416fb031ad3ca87f0bea80a is the first bad commit
   commit 7271b33cb87e80f3a416fb031ad3ca87f0bea80a
   Author: Herbert Xu <herbert@gondor.apana.org.au>
   Date:   Tue Jun 21 16:55:16 2016 +0800

    crypto: ghash-clmulni - Fix cryptd reordering
     :

Could you please take a look? here are additional details:

To reproduce the panic, I set up ipsec as follows, on 2 test machines

  # #set up laddr to be local interface address, faddr as peer's addres.
  # ip x p add dir out src $laddr dst $faddr proto tcp \
       tmpl proto esp src $laddr dst $faddr spi 0x00000001 \
       mode transport reqid 1
  # ip x p add dir in src $laddr dst $faddr proto tcp \
       tmpl proto esp dst $laddr src $faddr spi 0x00000001 \
       mode transport reqid 1
  # ip x s add proto esp src $laddr dst $faddr spi 0x00000001 \
       mode transport reqid 1 replay-window 32 \
       aead 'rfc4106(gcm(aes))' 0x1234567890123456789012345678901234567890 64 \
       sel src $laddr dst $faddr proto tcp
  # ip x s add proto esp dst $laddr src $faddr spi 0x00000001 \
       mode transport reqid 1 replay-window 32 \
       aead 'rfc4106(gcm(aes))' 0x1234567890123456789012345678901234567890 64 \
       sel src $laddr dst $faddr proto tcp

Then run iperf i.e., start "iperf -s" on one node (server), and 
"iperf -c $faddr -P 1" on the on the other (client). The client will
panic with something like this in the dmesg:

[  124.627594] BUG: unable to handle kernel paging request at 00000001000000c5
[  124.627612] ------------[ cut here ]------------
[  124.627620] WARNING: CPU: 3 PID: 0 at lib/list_debug.c:62 __list_del_entry+0x
86/0xd0
[  124.627621] list_del corruption. next->prev should be ffff88085cebd168, but w
as 00000000ffffff8d
[  124.627622] Modules linked in:
   :
   :
[  124.627650] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G            E   4.7.0-rc1-ipsec-offload-api2+ #15
[  124.627651] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0046.R00.1502111331 02/11/2015
[  124.627666]  [<ffffffff812df929>] dump_stack+0x51/0x78
[  124.627667]  [<ffffffff812fd1c6>] ? __list_del_entry+0x86/0xd0
[  124.627673]  [<ffffffff8106711d>] __warn+0xfd/0x120
[  124.627676]  [<ffffffff810671f9>] warn_slowpath_fmt+0x49/0x50
[  124.627677]  [<ffffffff812fd1c6>] __list_del_entry+0x86/0xd0
[  124.627683]  [<ffffffff8109906b>] detach_tasks+0x1ab/0x280
[  124.627685]  [<ffffffff8109d58b>] load_balance+0x32b/0x860
[  124.627691]  [<ffffffff810cf219>] ? enqueue_hrtimer+0x49/0xa0
[  124.627693]  [<ffffffff810cddbc>] ? run_timer_softirq+0x4c/0x300
[  124.627695]  [<ffffffff8109e064>] rebalance_domains+0x144/0x290
[  124.627696]  [<ffffffff8109e3e9>] run_rebalance_domains+0x49/0x60
[  124.627701]  [<ffffffff816234bb>] __do_softirq+0xeb/0x2d8
[  124.627703]  [<ffffffff810cfa38>] ? hrtimer_interrupt+0xb8/0x170
[  124.627706]  [<ffffffff8106c755>] irq_exit+0xa5/0xb0
[  124.627708]  [<ffffffff816232b6>] smp_apic_timer_interrupt+0x46/0x60
[  124.627709]  [<ffffffff8162198f>] apic_timer_interrupt+0x7f/0x90
[  124.627709]  <EOI> 
[  124.627716]  [<ffffffff814fe369>] ? cpuidle_enter_state+0xc9/0x2d0
[  124.627718]  [<ffffffff814fe35b>] ? cpuidle_enter_state+0xbb/0x2d0
[  124.627719]  [<ffffffff814ff833>] ? menu_select+0x103/0x3a0
[  124.627721]  [<ffffffff814fe587>] cpuidle_enter+0x17/0x20
[  124.627723]  [<ffffffff810a600e>] call_cpuidle+0x2e/0x40
[  124.627724]  [<ffffffff810a6088>] cpuidle_idle_call+0x68/0x100
[  124.627725]  [<ffffffff810a6275>] cpu_idle_loop+0x155/0x240
[  124.627726]  [<ffffffff810a6381>] cpu_startup_entry+0x21/0x30
[  124.627732]  [<ffffffff810441c3>] start_secondary+0x73/0x80
[  124.627733] ---[ end trace d9352c1808e65391 ]---
[  124.640240] paging request
[  124.640557]  at 00000001000000c5
 :
[  124.640809] IP: [<ffffffff810975a6>] account_system_time+0x66/0x130
[  124.641146] PGD 85a8c3067 PUD 0 
[  124.641533] Thread overran stack, or stack corrupted
[  124.641795] Oops: 0000 [#1] SMP
[  124.642049] Modules linked in: seqiv esp4 xfrm4_mode_transport sha256_generic drbg ansi_cprng ctr ghash_generic gf128mul ghash_clmulni_intel cryptd gcm autofs4 8021q garp stp llc sunrpc cpufreq_ondemand ipv6 iTCO_wdt iTCO_vendor_support pcspkr i40e i2c_i801 i2c_core sg lpc_ich mfd_core xhci_pci xhci_hcd ixgbe dca hwmon mdio hed wmi ipmi_si ipmi_msghandler acpi_cpufreq acpi_pad ext4(E) mbcache(E) jbd2(E) sd_mod(E) sr_mod(E) cdrom(E) ahci(E) libahci(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
[  124.647568] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1
.86B.0046.R00.1502111331 02/11/2015
[  124.648027] task: ffff88085f344100 ti: ffff88085f348000 task.ti: ffff880855cb
b2e0
[  124.648293] RIP: 0010:[<ffffffff810975a6>]  [<ffffffff810975a6>] account_system_time+0x66/0x130
[  124.648814] RSP: 0018:ffff88087ec03d68  EFLAGS: 00010086
[  124.649075] RAX: 0000000000010000 RBX: ffff88085f344100 RCX: 00000000ffffff8d
[  124.649342] RDX: 0000000000000001 RSI: 0000000000000002 RDI: 0000000000000000
[  124.649609] RBP: ffff88087ec03d88 R08: 0000000000010000 R09: ffff880855cbb2a8
[  124.649877] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[  124.650143] R13: ffff88085f32edd8 R14: ffff88087ec0fc80 R15: 0000001cdb6654dd
[  124.650409] FS:  0000000000000000(0000) GS:ffff88087ec00000(0000) knlGS:0000000000000000
[  124.650676] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  124.650939] CR2: 00000001000000c5 CR3: 00000008564c3000 CR4: 00000000001406f0
[  124.651204] Stack:
[  124.651452]  0000000000000000 ffff88087ec03d70 ffff88087ec03d70 ffff88085f344100
[  124.651983]  ffff88087ec03da8 ffffffff81097730 ffff88087ec03dc8 ffff88087ec03e48
[  124.653046] Call Trace:
[  124.653296]  <IRQ> 
[  124.653368]  [<ffffffff81097730>] account_process_tick+0x40/0xa0
[  124.653878]  [<ffffffff810cc84c>] update_process_times+0x2c/0x70
[  124.654143]  [<ffffffff810de2d7>] tick_sched_handle+0x37/0x70
[  124.654405]  [<ffffffff810ded52>] tick_sched_timer+0x52/0xa0
[  124.654666]  [<ffffffff810cf685>] __run_hrtimer+0x85/0x210
[  124.654926]  [<ffffffff810ded00>] ? tick_nohz_handler+0xc0/0xc0
[  124.655193]  [<ffffffff810bbff8>] ? handle_irq_event_percpu+0xb8/0x1f0
[  124.655459]  [<ffffffff810cf877>] __hrtimer_run_queues+0x67/0x90
[  124.655724]  [<ffffffff810cfa1b>] hrtimer_interrupt+0x9b/0x170
[  124.655987]  [<ffffffff810451e9>] local_apic_timer_interrupt+0x39/0x60
[  124.656252]  [<ffffffff816232b1>] smp_apic_timer_interrupt+0x41/0x60
[  124.656516]  [<ffffffff8162198f>] apic_timer_interrupt+0x7f/0x90
[  124.656777]  <EOI> 
    :
