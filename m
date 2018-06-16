From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in vmac_final
Date: Sat, 16 Jun 2018 08:36:08 -0700
Message-ID: <20180616153608.GA684@sol.localdomain>
References: <000000000000f7b199056ebfc5ef@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+264bca3a6e8d645550d3@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000000000000f7b199056ebfc5ef@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jun 16, 2018 at 03:27:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    8efcf34a2639 Merge tag 'armsoc-late' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17b9503f800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3de185e943e1d12f
> dashboard link: https://syzkaller.appspot.com/bug?extid=264bca3a6e8d645550d3
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=158bc21f800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12506eaf800000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+264bca3a6e8d645550d3@syzkaller.appspotmail.com
> 
> ==================================================================
> kasan: CONFIG_KASAN_INLINE enabled
> BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:330 [inline]
> BUG: KASAN: slab-out-of-bounds in vmac_final+0x161/0x26a0 crypto/vmac.c:611
> Write of size 18446744073709551516 at addr ffff8801ac760f0c by task
> syz-executor345/4580
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> 
> CPU: 1 PID: 4580 Comm: syz-executor345 Not tainted 4.17.0+ #98
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>  print_address_description+0x6c/0x20b mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
>  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
>  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
>  memset+0x23/0x40 mm/kasan/kasan.c:285
>  memset include/linux/string.h:330 [inline]
>  vmac_final+0x161/0x26a0 crypto/vmac.c:611
>  crypto_shash_final+0x104/0x260 crypto/shash.c:152
>  shash_async_final+0x35/0x40 crypto/shash.c:252
>  crypto_ahash_op+0xcf/0x180 crypto/ahash.c:362
>  crypto_ahash_final+0x57/0x70 crypto/ahash.c:367
>  hash_sendmsg+0x750/0xac0 crypto/algif_hash.c:126
>  sock_sendmsg_nosec net/socket.c:645 [inline]
>  sock_sendmsg+0xd5/0x120 net/socket.c:655
>  ___sys_sendmsg+0x805/0x940 net/socket.c:2161

I have a fix for this almost ready to send out, but I need to do a bit more
testing.  I'll send it out soon.  (The bug is that the VMAC template doesn't
separate per-request state from per-tfm state.)

Eric
