Return-Path: <SRS0=a5OM=NO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbeKDHrp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Nov 2018 02:47:45 -0500
Date: Sat, 3 Nov 2018 15:35:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in skcipher_recvmsg
Message-ID: <20181103223504.GC808@sol.localdomain>
References: <000000000000d8053d05799b4b86@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d8053d05799b4b86@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[+clabbe@baylibre.com]

Hi Corentin, I think this is a bug in the new crypto statistics feature.  In the
skcipher_decrypt case the code is (but this applies elsewhere too!):

static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
						int ret, struct crypto_alg *alg)
{
#ifdef CONFIG_CRYPTO_STATS
	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
		atomic_inc(&alg->cipher_err_cnt);
	} else {
		atomic_inc(&alg->decrypt_cnt);
		atomic64_add(req->cryptlen, &alg->decrypt_tlen);
	}
#endif
}

static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
{
	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
	int ret;

	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
		ret = -ENOKEY;
	else
		ret = tfm->decrypt(req);
	crypto_stat_skcipher_decrypt(req, ret, tfm->base.__crt_alg);
	return ret;
}

The bug is the request may be issued asynchronously (as indicated by EINPROGRESS
or EBUSY) being returned, and the stats are updated afterwards.  But by that
time, the request's completion function may have already run, and the request
structure may have already been freed.

In theory, I think the algorithm could have even been unregistered as well.
Therefore, it's only safe to update the stats either *before* calling
tfm->decrypt(), or afterwards if the error code was not EINPROGRESS or EBUSY.

On Thu, Nov 01, 2018 at 07:33:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    59fc453b21f7 Merge branch 'akpm' (patches from Andrew)
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14bc682b400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ea045471e4c756e8
> dashboard link: https://syzkaller.appspot.com/bug?extid=6939a606a5305e9e9799
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in crypto_stat_skcipher_decrypt
> include/crypto/skcipher.h:510 [inline]
> BUG: KASAN: use-after-free in crypto_skcipher_decrypt
> include/crypto/skcipher.h:559 [inline]
> BUG: KASAN: use-after-free in _skcipher_recvmsg crypto/algif_skcipher.c:131
> [inline]
> BUG: KASAN: use-after-free in skcipher_recvmsg+0x160f/0x1780
> crypto/algif_skcipher.c:165
> Read of size 4 at addr ffff8801b69239c0 by task syz-executor3/23539
> 
> CPU: 0 PID: 23539 Comm: syz-executor3 Not tainted 4.19.0+ #313
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x244/0x39d lib/dump_stack.c:113
>  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
>  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
>  crypto_stat_skcipher_decrypt include/crypto/skcipher.h:510 [inline]
>  crypto_skcipher_decrypt include/crypto/skcipher.h:559 [inline]
>  _skcipher_recvmsg crypto/algif_skcipher.c:131 [inline]
>  skcipher_recvmsg+0x160f/0x1780 crypto/algif_skcipher.c:165
>  sock_recvmsg_nosec net/socket.c:794 [inline]
>  sock_recvmsg+0xd0/0x110 net/socket.c:801
>  sock_read_iter+0x39b/0x570 net/socket.c:878
> kvm [23531]: vcpu0, guest rIP: 0xfff0 unimplemented HWCR wrmsr: 0x80000280
>  call_read_iter include/linux/fs.h:1833 [inline]
>  aio_read+0x297/0x490 fs/aio.c:1516
>  io_submit_one+0xac2/0xf80 fs/aio.c:1832
>  __do_sys_io_submit fs/aio.c:1916 [inline]
>  __se_sys_io_submit fs/aio.c:1887 [inline]
>  __x64_sys_io_submit+0x1b7/0x580 fs/aio.c:1887
>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> binder: 23534:23545 ioctl c018620b 20000340 returned -14
> RIP: 0033:0x457569
> Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f351c0cdc78 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
> RDX: 0000000020bd9fe0 RSI: 0000000000000001 RDI: 00007f351c0ad000
> RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f351c0ce6d4
> R13: 00000000004be72d R14: 00000000004ce600 R15: 00000000ffffffff
> 
> Allocated by task 23539:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
>  __do_kmalloc mm/slab.c:3722 [inline]
>  __kmalloc+0x15b/0x760 mm/slab.c:3731
>  kmalloc include/linux/slab.h:551 [inline]
>  sock_kmalloc+0x15a/0x1f0 net/core/sock.c:1984
>  af_alg_alloc_areq+0x83/0x280 crypto/af_alg.c:1097
>  _skcipher_recvmsg crypto/algif_skcipher.c:75 [inline]
>  skcipher_recvmsg+0x354/0x1780 crypto/algif_skcipher.c:165
>  sock_recvmsg_nosec net/socket.c:794 [inline]
>  sock_recvmsg+0xd0/0x110 net/socket.c:801
>  sock_read_iter+0x39b/0x570 net/socket.c:878
>  call_read_iter include/linux/fs.h:1833 [inline]
>  aio_read+0x297/0x490 fs/aio.c:1516
>  io_submit_one+0xac2/0xf80 fs/aio.c:1832
>  __do_sys_io_submit fs/aio.c:1916 [inline]
>  __se_sys_io_submit fs/aio.c:1887 [inline]
>  __x64_sys_io_submit+0x1b7/0x580 fs/aio.c:1887
>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 19019:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
>  __cache_free mm/slab.c:3498 [inline]
>  kfree+0xcf/0x230 mm/slab.c:3817
>  __sock_kfree_s net/core/sock.c:2005 [inline]
>  sock_kfree_s+0x29/0x60 net/core/sock.c:2011
>  af_alg_free_resources+0x6b/0x80 crypto/af_alg.c:1033
>  af_alg_async_cb+0xbc/0x180 crypto/af_alg.c:1056
>  cryptd_skcipher_complete+0x14c/0x250 crypto/cryptd.c:474
>  cryptd_skcipher_decrypt+0x4e2/0x750 crypto/cryptd.c:534
>  cryptd_queue_worker+0x12d/0x200 crypto/cryptd.c:193
>  process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
>  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
>  kthread+0x35a/0x440 kernel/kthread.c:246
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:350
> 
> The buggy address belongs to the object at ffff8801b69236c0
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 768 bytes inside of
>  1024-byte region [ffff8801b69236c0, ffff8801b6923ac0)
> The buggy address belongs to the page:
> page:ffffea0006da4880 count:1 mapcount:0 mapping:ffff8801da800ac0
> index:0xffff8801b6922940 compound_mapcount: 0
> flags: 0x2fffc0000010200(slab|head)
> raw: 02fffc0000010200 ffffea00070a7b08 ffffea00063a1608 ffff8801da800ac0
> kvm [23547]: vcpu0, guest rIP: 0xfff0 unimplemented HWCR wrmsr: 0x80000280
> raw: ffff8801b6922940 ffff8801b6922040 0000000100000006 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8801b6923880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b6923900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff8801b6923980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                            ^
>  ffff8801b6923a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b6923a80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000d8053d05799b4b86%40google.com.
> For more options, visit https://groups.google.com/d/optout.
