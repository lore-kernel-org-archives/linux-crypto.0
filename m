From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: KASAN: use-after-free Read in sha512_ctx_mgr_resubmit
Date: Mon, 20 Aug 2018 00:31:20 -0700
Message-ID: <20180820073119.GA14931@sol.localdomain>
References: <00000000000072d64d05737b6b8c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        syzbot <syzbot+d5455bac3ba1ee9114e5@syzkaller.appspotmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, x86@kernel.org
To: Megha Dey <megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00000000000072d64d05737b6b8c@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[+sha512-mb maintainers...]

On Wed, Aug 15, 2018 at 09:00:04AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7796916146b8 Merge branch 'x86-cpu-for-linus' of git://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=164b1922400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=265bef9882cce8d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=d5455bac3ba1ee9114e5
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=1013478c400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1349c8aa400000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+d5455bac3ba1ee9114e5@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in sha512_ctx_mgr_resubmit.part.3+0x3b1/0x4a0
> arch/x86/crypto/sha512-mb/sha512_mb.c:136
> Read of size 4 at addr ffff8801b0b9e838 by task kworker/0:1/13
> 
> CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 4.18.0+ #187
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: crypto mcryptd_flusher
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
>  print_address_description+0x6c/0x20b mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
>  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
>  sha512_ctx_mgr_resubmit.part.3+0x3b1/0x4a0
> arch/x86/crypto/sha512-mb/sha512_mb.c:136
>  sha512_ctx_mgr_resubmit arch/x86/crypto/sha512-mb/sha512_mb.c:135 [inline]
>  sha512_ctx_mgr_flush+0x5c/0xb0 arch/x86/crypto/sha512-mb/sha512_mb.c:367
>  sha512_mb_flusher+0x27b/0x610 arch/x86/crypto/sha512-mb/sha512_mb.c:939
>  mcryptd_flusher+0x342/0x4b0 crypto/mcryptd.c:208
>  process_one_work+0xc73/0x1ba0 kernel/workqueue.c:2153
>  worker_thread+0x189/0x13c0 kernel/workqueue.c:2296
>  kthread+0x35a/0x420 kernel/kthread.c:246
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413
> 
> Allocated by task 23902:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
>  __do_kmalloc mm/slab.c:3718 [inline]
>  __kmalloc+0x14e/0x760 mm/slab.c:3727
>  kmalloc include/linux/slab.h:518 [inline]
>  sock_kmalloc+0x156/0x1f0 net/core/sock.c:1996
>  hash_accept_parent_nokey+0x58/0x2e0 crypto/algif_hash.c:438
>  hash_accept_parent+0x5b/0x80 crypto/algif_hash.c:465
>  af_alg_accept+0x127/0x7d0 crypto/af_alg.c:296
>  alg_accept+0x46/0x60 crypto/af_alg.c:332
>  __sys_accept4+0x3b2/0x8a0 net/socket.c:1600
>  __do_sys_accept4 net/socket.c:1635 [inline]
>  __se_sys_accept4 net/socket.c:1632 [inline]
>  __x64_sys_accept4+0x97/0xf0 net/socket.c:1632
>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 23902:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
>  __cache_free mm/slab.c:3498 [inline]
>  kfree+0xd9/0x260 mm/slab.c:3813
>  __sock_kfree_s net/core/sock.c:2017 [inline]
>  sock_kfree_s+0x29/0x60 net/core/sock.c:2023
>  hash_sock_destruct+0x157/0x1c0 crypto/algif_hash.c:427
>  __sk_destruct+0x107/0xa60 net/core/sock.c:1573
>  sk_destruct+0x78/0x90 net/core/sock.c:1608
>  __sk_free+0xcf/0x300 net/core/sock.c:1619
>  sk_free+0x42/0x50 net/core/sock.c:1630
>  sock_put include/net/sock.h:1667 [inline]
>  af_alg_release+0x6e/0x90 crypto/af_alg.c:126
>  __sock_release+0xd7/0x260 net/socket.c:600
>  sock_close+0x19/0x20 net/socket.c:1151
>  __fput+0x355/0x8b0 fs/file_table.c:209
>  ____fput+0x15/0x20 fs/file_table.c:243
>  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:192 [inline]
>  exit_to_usermode_loop+0x313/0x370 arch/x86/entry/common.c:166
>  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
>  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> The buggy address belongs to the object at ffff8801b0b9e340
>  which belongs to the cache kmalloc-2048 of size 2048
> The buggy address is located 1272 bytes inside of
>  2048-byte region [ffff8801b0b9e340, ffff8801b0b9eb40)
> The buggy address belongs to the page:
> page:ffffea0006c2e780 count:1 mapcount:0 mapping:ffff8801dac00c40 index:0x0
> compound_mapcount: 0
> flags: 0x2fffc0000008100(slab|head)
> raw: 02fffc0000008100 ffffea0007543a88 ffffea000760b188 ffff8801dac00c40
> raw: 0000000000000000 ffff8801b0b9e340 0000000100000003 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8801b0b9e700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b0b9e780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff8801b0b9e800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                         ^
>  ffff8801b0b9e880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b0b9e900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================

Apparently, the SHA multibuffer algorithms sometimes return success while the
hash request is still being asynchronously processed, which allows an in-use
request to be freed or reused.  It also allows the wrong digest value to be
computed.  The following patch fixes the crash for sha512_mb (the same fix is
also needed for sha1_mb and sha256_mb...), but I haven't properly reviewed yet
it as the multibuffer code is very difficult to understand...

diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
index 26b85678012d0..7708842447518 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb.c
+++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
@@ -584,7 +584,7 @@ static int sha512_mb_update(struct ahash_request *areq)
 		return -EINPROGRESS;
 done:
 	sha_complete_job(rctx, cstate, ret);
-	return ret;
+	return -EINPROGRESS;
 }
 
 static int sha512_mb_finup(struct ahash_request *areq)
@@ -645,7 +645,7 @@ static int sha512_mb_finup(struct ahash_request *areq)
 		return -EINPROGRESS;
 done:
 	sha_complete_job(rctx, cstate, ret);
-	return ret;
+	return -EINPROGRESS;
 }
 
 static int sha512_mb_final(struct ahash_request *areq)
@@ -694,7 +694,7 @@ static int sha512_mb_final(struct ahash_request *areq)
 		return -EINPROGRESS;
 done:
 	sha_complete_job(rctx, cstate, ret);
-	return ret;
+	return -EINPROGRESS;
 }
 
 static int sha512_mb_export(struct ahash_request *areq, void *out)


And here's a simplified reproducer.  It also works with sha1_mb and sha256_mb if
you change the .salg_name.  Note: it actually causes a list corruption rather
than a use-after-free, but it seems to be the same bug...

	#include <fcntl.h>
	#include <linux/if_alg.h>
	#include <sys/sendfile.h>
	#include <sys/socket.h>
	#include <unistd.h>

	int main()
	{
		struct sockaddr_alg addr = {
			.salg_type = "hash",
			.salg_name = "sha512_mb",
		};
		int algfd, reqfd, filefd;
		int nprocs = 8 * sysconf(_SC_NPROCESSORS_ONLN);

		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
		bind(algfd, (void *)&addr, sizeof(addr));

		if (fork()) {
			while (nprocs-- > 0 && fork())
				;
			reqfd = accept(algfd, NULL, 0);
			for (;;)
				write(reqfd, "X", 1);
		} else {
			reqfd = accept(algfd, NULL, 0);
			filefd = open("/bin/ls", O_RDONLY);
			for (;;) {
				loff_t offset = 0;

				sendfile(reqfd, filefd, &offset, 256);
			}
		}
	}

Personally, I'm wondering why the SHA multibuffer code is in the kernel at all
given all the severe issues it has that its authors/maintainers don't seem to be
working very hard to fix.  The code is very difficult to understand due to the
weird 3-layer design with "mcryptd" and other issues, making debugging it very
time consuming; most of the code is duplicated in 3 places (sha1-mb, sha256-mb,
and sha512-mb), making maintenance even more difficult; and most importantly
there are severe bugs, including edge cases where it computes the wrong hash, as
shown not only by this bug but also the sha256_mb bug I recently ran into.  It
seems the algorithms were never tested under load to cover these edge cases.

That's *not* acceptable for crypto code.  Security and correctness come first.

Also as I've shown previously, in most cases the multibuffer SHA algorithms are
~1000x slower than the regular ones due to the flush delay.  So the performance
argument for them actually seems pretty tenuous...  And, isn't AVX2 multibuffer
useless on new processors, which have SHA instructions?

I'd also be very interested to hear an explanation for why systemwide sharing of
hash jobs doesn't enable side-channel attacks and isn't just the latest example
of prioritizing "performance" over security?

We need to have higher standards for crypto and not accept buggy spaghetti code
just because it's slightly faster in some artificial microbenchmark.

So unless major improvements are made, I personally think we'd be much better
off without the SHA multibuffer algorithms in the kernel.

Just my two cents...

- Eric
