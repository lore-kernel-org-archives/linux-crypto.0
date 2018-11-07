Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:37533 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbeKGQzn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 11:55:43 -0500
Received: by mail-it1-f195.google.com with SMTP id j79-v6so9497074itb.2
        for <linux-crypto@vger.kernel.org>; Tue, 06 Nov 2018 23:26:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <00000000000060e0ae057a092be8@google.com>
References: <00000000000060e0ae057a092be8@google.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 7 Nov 2018 08:26:35 +0100
Message-ID: <CAKv+Gu_RoM_iR72eSY7G-BpCE-QjytKg7rcDHd=y0-Jj3jmiEA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in crypto_gcm_init_common
To: syzbot <syzbot+e736399a2c4054612307@syzkaller.appspotmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(+ TLS maintainers and netdev)

On 7 November 2018 at 02:38, syzbot
<syzbot+e736399a2c4054612307@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    4710e78940d8 Merge tag 'nfs-for-4.20-2' of git://git.linux..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17a68093400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9384ecb1c973baed
> dashboard link: https://syzkaller.appspot.com/bug?extid=e736399a2c4054612307
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17902f5b400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111377e5400000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e736399a2c4054612307@syzkaller.appspotmail.com
>
> startpar (5496) used greatest stack depth: 15744 bytes left
> ==================================================================
> BUG: KASAN: use-after-free in memcpy include/linux/string.h:352 [inline]
> BUG: KASAN: use-after-free in crypto_gcm_init_common+0xe2/0x710
> crypto/gcm.c:181
> Read of size 12 at addr ffff8801d7b91b00 by task kworker/1:2/3205
>
> CPU: 1 PID: 3205 Comm: kworker/1:2 Not tainted 4.19.0+ #320
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: pencrypt padata_parallel_worker
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x244/0x39d lib/dump_stack.c:113
>  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
>  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
>  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
>  memcpy+0x23/0x50 mm/kasan/kasan.c:302
>  memcpy include/linux/string.h:352 [inline]
>  crypto_gcm_init_common+0xe2/0x710 crypto/gcm.c:181
>  crypto_gcm_encrypt+0xe2/0x6b0 crypto/gcm.c:479
>  crypto_aead_encrypt include/crypto/aead.h:364 [inline]
>  pcrypt_aead_enc+0xd6/0x340 crypto/pcrypt.c:143
>  padata_parallel_worker+0x49d/0x760 kernel/padata.c:86
>  process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
>  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
>  kthread+0x35a/0x440 kernel/kthread.c:246
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
>
> Allocated by task 5668:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
>  kmem_cache_alloc_trace+0x152/0x750 mm/slab.c:3620
>  kmalloc include/linux/slab.h:546 [inline]
>  tls_set_sw_offload+0xcb3/0x1390 net/tls/tls_sw.c:1945
>  do_tls_setsockopt_conf net/tls/tls_main.c:467 [inline]
>  do_tls_setsockopt net/tls/tls_main.c:514 [inline]
>  tls_setsockopt+0x689/0x770 net/tls/tls_main.c:533
>  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:2978
>  __sys_setsockopt+0x1ba/0x3c0 net/socket.c:1902
>  __do_sys_setsockopt net/socket.c:1913 [inline]
>  __se_sys_setsockopt net/socket.c:1910 [inline]
>  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1910
>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 5668:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
>  __cache_free mm/slab.c:3498 [inline]
>  kfree+0xcf/0x230 mm/slab.c:3817
>  tls_sk_proto_close+0x5fa/0x750 net/tls/tls_main.c:277
>  inet_release+0x104/0x1f0 net/ipv4/af_inet.c:428
>  inet6_release+0x50/0x70 net/ipv6/af_inet6.c:458
>  __sock_release+0xd7/0x250 net/socket.c:579
>  sock_close+0x19/0x20 net/socket.c:1141
>  __fput+0x385/0xa30 fs/file_table.c:278
>  ____fput+0x15/0x20 fs/file_table.c:309
>  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
>  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
>  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8801d7b91b00
>  which belongs to the cache kmalloc-32 of size 32
> The buggy address is located 0 bytes inside of
>  32-byte region [ffff8801d7b91b00, ffff8801d7b91b20)
> The buggy address belongs to the page:
> page:ffffea00075ee440 count:1 mapcount:0 mapping:ffff8801da8001c0
> index:0xffff8801d7b91fc1
> flags: 0x2fffc0000000200(slab)
> raw: 02fffc0000000200 ffffea00075effc8 ffff8801da801248 ffff8801da8001c0
> raw: ffff8801d7b91fc1 ffff8801d7b91000 000000010000003f 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8801d7b91a00: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
>  ffff8801d7b91a80: 00 00 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>>
>> ffff8801d7b91b00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>
>                    ^
>  ffff8801d7b91b80: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
>  ffff8801d7b91c00: 00 00 00 00 fc fc fc fc fb fb fb fb fc fc fc fc
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
