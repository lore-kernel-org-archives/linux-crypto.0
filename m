From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: crypto: mxs-dcp: do not call blocking ops when !TASK_RUNNING;
 state=1
Date: Tue, 23 Aug 2016 22:38:23 +0200 (CEST)
Message-ID: <140047983.403523.225ddbfe-fd96-4f9b-a2b9-e0173af882ba.open-xchange@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:58335 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755734AbcHWUif (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Aug 2016 16:38:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

i'm using a iMX233-OLinuXino board and i get the following warning during boot
with 4.8.0-rc2-next-20160819:

[    2.450000] ------------[ cut here ]------------
[    2.450000] WARNING: CPU: 0 PID: 42 at kernel/sched/core.c:7602
__might_sleep+0x8c/0xa0
[    2.470000] do not call blocking ops when !TASK_RUNNING; state=1 set at
[<c048f730>] dcp_chan_thread_aes+0x24/0x664
[    2.480000] Modules linked in:
[    2.480000] CPU: 0 PID: 42 Comm: mxs_dcp_chan/ae Not tainted
4.8.0-rc2-next-20160819-dirty #2
[    2.490000] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
[    2.500000] Hardware name: Freescale MXS (Device Tree)
[    2.510000] [<c00100a4>] (unwind_backtrace) from [<c000e088>]
(show_stack+0x10/0x14)
[    2.520000] [<c000e088>] (show_stack) from [<c001ce8c>] (__warn+0xd8/0x100)
[    2.530000] [<c001ce8c>] (__warn) from [<c001cf5c>]
(warn_slowpath_fmt+0x38/0x48)
[    2.540000] [<c001cf5c>] (warn_slowpath_fmt) from [<c00479dc>]
(__might_sleep+0x8c/0xa0)
[    2.540000] [<c00479dc>] (__might_sleep) from [<c05dd24c>]
(mutex_lock_nested+0x24/0x39c)
[    2.550000] [<c05dd24c>] (mutex_lock_nested) from [<c048f760>]
(dcp_chan_thread_aes+0x54/0x664)
[    2.560000] [<c048f760>] (dcp_chan_thread_aes) from [<c0040574>]
(kthread+0xd0/0xf0)
[    2.580000] [<c0040574>] (kthread) from [<c000a36c>]
(ret_from_fork+0x14/0x28)
[    2.590000] ---[ end trace e2182161e464af25 ]---

What would be the right fix for this issue?

Regards
Stefan
