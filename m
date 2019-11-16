Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FE7C43215
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 06:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41C0E2073B
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 06:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfKPGLB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 01:11:01 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:39158 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfKPGLB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 01:11:01 -0500
Received: by mail-io1-f72.google.com with SMTP id e17so8924841ioc.6
        for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2019 22:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vNPB7awq6ab0Up/MfCLVQK9zRNR3FRtQ5ICJDKhkv64=;
        b=MPOy4YwX/+0AOOAta5CaleK5XckqQiCxeyeGgVhK9WoPXvEvoyGciMPevsUY5W5SRe
         tjrkZ5uqBZTvJ2OBkhtWyqSbruQ5w5wpwnGLzRVjwMb0TiPqHfSEKcoGJbA55muR2ygk
         kVTfhB7e13A3XtIaYWCv83dEH9Y8vqVCn34qntmCSDydfoTD3WjEqm/ghjduXu93CJbn
         h3cEsoGhjNutd0xy2daEVvYqu7fvJDIVLXmjxS8SJHHjlGbly/3mPIxVJzxx6rNiMeGW
         gQFAsCrpDpxZF8Err+2kRhKrKvP4efBSrNzPQtp3pE9M1QXfcFgZL8vBO5vxYKSCKyP6
         QmGQ==
X-Gm-Message-State: APjAAAUSHTOxM/Tz1LowE2BSEmUcmksbOyfMjlcl7OiJIUy/Kqm372yD
        kxc+Yhnkb6oY6zB5kx42lbCX8BMcBOpeA0vCP+X64R06JnaC
X-Google-Smtp-Source: APXvYqx8A2MWVMDBL74b9BMW4xCZu2wmDEJD7i4EdqQpKtpfGxhX0ZlXbM1mSOVsehp8Ffr4iaQwKxmXhHX2Bs3zN3rXzZupwcFu
MIME-Version: 1.0
X-Received: by 2002:a5e:c241:: with SMTP id w1mr4140885iop.274.1573884660392;
 Fri, 15 Nov 2019 22:11:00 -0800 (PST)
Date:   Fri, 15 Nov 2019 22:11:00 -0800
In-Reply-To: <5dcef2d1.1c69fb81.803c0.0872@mx.google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019acd8059770942b@google.com>
Subject: Re: INFO: task hung in chaoskey_disconnect
From:   syzbot <syzbot+f41c4f7c6d8b0b778780@syzkaller.appspotmail.com>
To:     alexandre.belloni@bootlin.com, andreyknvl@google.com,
        arnd@arndb.de, b.zolnierkie@samsung.com,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, lvivier@redhat.com, mchehab@kernel.org,
        mpm@selenic.com, swboyd@chromium.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
KASAN: use-after-free Read in chaoskey_disconnect

usb 3-1: New USB device found, idVendor=1d50, idProduct=60c6,  
bcdDevice=1a.d7
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 3-1: config 0 descriptor??
usb 3-1: string descriptor 0 read error: -71
usb 3-1: USB disconnect, device number 14
==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x72/0x1e0  
lib/refcount.c:123
Read of size 4 at addr ffff8881d91ec820 by task kworker/1:2/100

CPU: 1 PID: 100 Comm: kworker/1:2 Not tainted 5.4.0-rc6+ #0
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

Freed by task 0:
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

The buggy address belongs to the object at ffff8881d91ec800
  which belongs to the cache task_struct of size 5888
The buggy address is located 32 bytes inside of
  5888-byte region [ffff8881d91ec800, ffff8881d91edf00)
The buggy address belongs to the page:
page:ffffea0007647a00 refcount:1 mapcount:0 mapping:ffff8881da116000  
index:0xffff8881d91e9800 compound_mapcount: 0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 0000000000000000 0000000100000001 ffff8881da116000
raw: ffff8881d91e9800 0000000080050003 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8881d91ec700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8881d91ec780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8881d91ec800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                ^
  ffff8881d91ec880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8881d91ec900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         b1aa9d83 usb: raw: add raw-gadget interface
git tree:       https://github.com/google/kasan.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1498da1ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79de80330003b5f7
dashboard link: https://syzkaller.appspot.com/bug?extid=f41c4f7c6d8b0b778780
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=114dbc8ce00000

