From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: workqueue list corruption
Date: Sun, 4 Jun 2017 12:30:03 -0700
Message-ID: <CAM_iQpXw5ogr3zPOuvupWDjApSeOXWmuSSZzpnK4UApUZC5VVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Tejun Heo <tj@kernel.org>, jiangshanlai@gmail.com, jason@zx2c4.com,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
To: Samuel Holland <samuel@sholland.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36764 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbdFDTaY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 15:30:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

On Tue, Apr 18, 2017 at 8:08 PM, Samuel Holland <samuel@sholland.org> wrote:
> Representative backtraces follow (the warnings come in sets). I have
> kernel .configs and extended netconsole output from several occurrences
> available upon request.
>
> WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0x89/0xb0
> list_add corruption. prev->next should be next (ffff99f135016a90), but
> was ffffd34affc03b10. (prev=ffffd34affc03b10).
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           O    4.9.20+ #1
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x92
>  __warn+0xc6/0xe0
>  warn_slowpath_fmt+0x5a/0x80
>  __list_add+0x89/0xb0
>  insert_work+0x3c/0xc0
>  __queue_work+0x18a/0x600
>  queue_work_on+0x33/0x70

We triggered a similar list corruption on 4.1.35 stable kernel,
and without padata:

[9021262.823059] ------------[ cut here ]------------
[9021262.827957] WARNING: CPU: 8 PID: 1366 at lib/list_debug.c:62
__list_del_entry+0x5a/0x98()
[9021262.836275] list_del corruption. next->prev should be
ffff8802f4644ca0, but was ffff88080c337ca0
[9021262.845285] Modules linked in: fuse sch_htb cls_basic act_mirred
cls_u32 veth sch_ingress cpufreq_ondemand in
tel_rapl iosf_mbi x86_pkg_temp_thermal coretemp kvm_intel kvm iTCO_wdt
iTCO_vendor_support microcode wmi lpc_ich shpchp dcdbas acpi_pad hed
mfd_core i2c_i801 sb_edac edac_core ioatd
ma acpi_cpufreq lp parport tcp_diag inet_diag sch_fq_codel ipmi_si
ipmi_devintf ipmi_msghandler ipv6 xfs libcrc32c crc32c_intel igb ptp
pps_core i2c_algo_bit dca i2c_core
[9021262.885919] CPU: 8 PID: 1366 Comm: kworker/8:0 Not tainted
4.1.35.el7.twitter.x86_64 #1
[9021262.894284] Hardware name: Dell Inc. PowerEdge C6220/04GD66, BIOS
2.2.3 11/07/2013
[9021262.902126]  0000000000000000 ffff8802c01f7cd8 ffffffff81544a67
ffff8802c01f7d28
[9021262.909644]  0000000000000009 ffff8802c01f7d18 ffffffff81069285
ffff8802c01f7cf8
[9021262.917232]  ffffffff812b247f ffff8802f4644c98 ffff88080c337c98
ffff8802f4644ca0
[9021262.924741] Call Trace:
[9021262.927326]  [<ffffffff81544a67>] dump_stack+0x4d/0x63
[9021262.932749]  [<ffffffff81069285>] warn_slowpath_common+0xa1/0xbb
[9021262.938889]  [<ffffffff812b247f>] ? __list_del_entry+0x5a/0x98
[9021262.944990]  [<ffffffff810692e5>] warn_slowpath_fmt+0x46/0x48
[9021262.950802]  [<ffffffff812b247f>] __list_del_entry+0x5a/0x98
[9021262.956638]  [<ffffffff8107b804>] move_linked_works+0x35/0x65
[9021262.962632]  [<ffffffff8107b865>] pwq_activate_delayed_work+0x31/0x3f
[9021262.969234]  [<ffffffff8107c09e>] pwq_dec_nr_in_flight+0x45/0x8c
[9021262.975411]  [<ffffffff8107c4d1>] process_one_work+0x284/0x2d1
[9021262.981408]  [<ffffffff8107cad5>] worker_thread+0x1dd/0x2bb
[9021262.987079]  [<ffffffff8107c8f8>] ? cancel_delayed_work+0x72/0x72
[9021262.993394]  [<ffffffff8107c8f8>] ? cancel_delayed_work+0x72/0x72
[9021262.999685]  [<ffffffff81080dab>] kthread+0xa5/0xad
[9021263.004678]  [<ffffffff81080d06>] ? __kthread_parkme+0x61/0x61
[9021263.010655]  [<ffffffff8154a492>] ret_from_fork+0x42/0x70
[9021263.016305]  [<ffffffff81080d06>] ? __kthread_parkme+0x61/0x61
[9021263.022236] ---[ end trace 62dde64b253c2f87 ]---


Unfortunately I have no idea how this was triggered since it happened
on one of thousands in the cluster.

Is there anything I can help to debug this?

Thanks!
