Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9105C33C8C
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 05:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D33820830
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 05:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfKPFzD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 00:55:03 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:55609 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfKPFzB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 00:55:01 -0500
Received: by mail-il1-f197.google.com with SMTP id n81so10837781ili.22
        for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2019 21:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dXuE6yVQzJvOqytcSaHG0bqqilbG2j3QAqOwagl/p+c=;
        b=iXzQxGgNbP43rXWSOO36QbKK0WaSJcuplj2cnUmQKEe9vhMpyFLGfEDyvm8NAAeuHi
         XmoTMVAJThuHJWPsSN6nsQuHRMvJNc8VU0ohCaJ0MgLIazIlWlC6AykiAPAusikCkE70
         ohhpbVqszflOaPrUX5m9W9CzNRcMLWCnCk/QxSPz75gedYwq426eks2yBUgxQaDTa3pi
         SahCVCCUrVVe8L4I3YTLZP0OYu25N1r75EaL94NIWc0pY21AZxO6EnaMHcMcchP3EDSg
         dWvFyItWL94cX53G43qx8Ls7/7NvlNEVHzh0MULFMA/0qsQrK8V0RnTmrBPep8BiEuAq
         VAXg==
X-Gm-Message-State: APjAAAVvzPbWvCkbv1VokxWbNqtzol6FKL+UVj1JdJSVyN3Mf0k7iql7
        7WQYA+s1tNakowyDJwH+aI2yk2Dc7V7cJM/c1E0r85h5xVvw
X-Google-Smtp-Source: APXvYqyEqTcdjT71yvmPMzko+ZqzB53EgTrIeU1q8kq16pRC0ZofyGrbd4WMDNRIJgW0Mfr4/fwmwWXBIy5e1AfxMGO9tgXhfdme
MIME-Version: 1.0
X-Received: by 2002:a92:c6d0:: with SMTP id v16mr4756379ilm.274.1573883700380;
 Fri, 15 Nov 2019 21:55:00 -0800 (PST)
Date:   Fri, 15 Nov 2019 21:55:00 -0800
In-Reply-To: <5dceec29.1c69fb81.4c2d0.e24d@mx.google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e10d500597705abf@google.com>
Subject: Re: KASAN: use-after-free Read in chaoskey_disconnect
From:   syzbot <syzbot+6d8505fcdf25f00ac276@syzkaller.appspotmail.com>
To:     alexandre.belloni@bootlin.com, andreyknvl@google.com,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lvivier@redhat.com, mchehab@kernel.org, mpm@selenic.com,
        swboyd@chromium.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
KASAN: use-after-free Read in chaoskey_disconnect

usb 5-1: USB disconnect, device number 2
==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x72/0x1e0  
lib/refcount.c:123
Read of size 4 at addr ffff8881d3106020 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description.constprop.0+0x36/0x50 mm/kasan/report.c:374
  __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:506
  kasan_report+0xe/0x20 mm/kasan/common.c:634
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x128/0x190 mm/kasan/generic.c:192
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  refcount_inc_not_zero_checked+0x72/0x1e0 lib/refcount.c:123
  refcount_inc_checked+0x12/0x60 lib/refcount.c:156
  get_task_struct include/linux/sched/task.h:110 [inline]
  kthread_stop+0x6c/0x610 kernel/kthread.c:554
  hwrng_unregister+0x190/0x210 drivers/char/hw_random/core.c:538
  chaoskey_disconnect+0x1b2/0x200 drivers/usb/misc/chaoskey.c:232
  usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
  __device_release_driver drivers/base/dd.c:1134 [inline]
  device_release_driver_internal+0x42f/0x500 drivers/base/dd.c:1165
  bus_remove_device+0x2dc/0x4a0 drivers/base/bus.c:532
  device_del+0x420/0xb20 drivers/base/core.c:2376
  usb_disable_device+0x211/0x690 drivers/usb/core/message.c:1237
  usb_disconnect+0x284/0x8d0 drivers/usb/core/hub.c:2200
  hub_port_connect drivers/usb/core/hub.c:5035 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5324 [inline]
  port_event drivers/usb/core/hub.c:5470 [inline]
  hub_event+0x16f2/0x3800 drivers/usb/core/hub.c:5552
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x7ab/0xe20 kernel/workqueue.c:2417
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 2:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:483
  slab_post_alloc_hook mm/slab.h:584 [inline]
  slab_alloc_node mm/slub.c:2779 [inline]
  kmem_cache_alloc_node+0xdc/0x310 mm/slub.c:2815
  alloc_task_struct_node kernel/fork.c:169 [inline]
  dup_task_struct kernel/fork.c:865 [inline]
  copy_process+0x4201/0x6470 kernel/fork.c:1851
  _do_fork+0x129/0xec0 kernel/fork.c:2366
  kernel_thread+0xaa/0xe0 kernel/fork.c:2453
  create_kthread kernel/kthread.c:278 [inline]
  kthreadd+0x4a2/0x680 kernel/kthread.c:596
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 9:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x130/0x180 mm/kasan/common.c:471
  slab_free_hook mm/slub.c:1424 [inline]
  slab_free_freelist_hook mm/slub.c:1475 [inline]
  slab_free mm/slub.c:3025 [inline]
  kmem_cache_free+0xb9/0x380 mm/slub.c:3041
  __put_task_struct+0x1e2/0x4c0 kernel/fork.c:748
  put_task_struct include/linux/sched/task.h:119 [inline]
  delayed_put_task_struct+0x1b4/0x2c0 kernel/exit.c:182
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2157 [inline]
  rcu_core+0x630/0x1ca0 kernel/rcu/tree.c:2377
  __do_softirq+0x221/0x912 kernel/softirq.c:292

The buggy address belongs to the object at ffff8881d3106000
  which belongs to the cache task_struct of size 5888
The buggy address is located 32 bytes inside of
  5888-byte region [ffff8881d3106000, ffff8881d3107700)
The buggy address belongs to the page:
page:ffffea00074c4000 refcount:1 mapcount:0 mapping:ffff8881da116000  
index:0xffff8881d3101800 compound_mapcount: 0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da116000
raw: ffff8881d3101800 0000000080050004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8881d3105f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8881d3105f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8881d3106000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                ^
  ffff8881d3106080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8881d3106100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         ff6409a6 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
console output: https://syzkaller.appspot.com/x/log.txt?x=16dd8772e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3230c37d442895b7
dashboard link: https://syzkaller.appspot.com/bug?extid=6d8505fcdf25f00ac276
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14236abae00000

