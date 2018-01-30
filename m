From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 crypto_destroy_tfm
Date: Tue, 30 Jan 2018 15:06:59 -0800
Message-ID: <20180130230659.nnmcdbma4yewr3cs@gmail.com>
References: <001a1143d742f280a50560fef72a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+257773a84d5b2bfc2dfad2f945e773bd96d66aa9@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38680 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753620AbeA3XHC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 18:07:02 -0500
Content-Disposition: inline
In-Reply-To: <001a1143d742f280a50560fef72a@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 23, 2017 at 01:58:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 6084b576dca2e898f5c101baef151f7bfdbb606d
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000188
> IP: crypto_destroy_tfm+0x9f/0xf0 crypto/api.c:577
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 21787 Comm: syz-executor4 Not tainted 4.15.0-rc3-next-20171214+
> #67
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:crypto_destroy_tfm+0x9f/0xf0 crypto/api.c:577
> RSP: 0018:ffffc90000df7c40 EFLAGS: 00010293
> RAX: ffff8801f8518040 RBX: 0000000000000000 RCX: ffffffff8167415f
> RDX: 0000000000000000 RSI: ffff8801f8586c08 RDI: ffff8801f8586c00
> RBP: ffffc90000df7c60 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffc90000df7d20 R11: 0000000000000002 R12: ffff8801f8586c08
> R13: ffff8801f8586c00 R14: 0000000000000000 R15: ffff880213fc0030
> FS:  0000000002991940(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000188 CR3: 000000000301e002 CR4: 00000000001626f0
> Call Trace:
>  crypto_free_aead include/crypto/aead.h:193 [inline]
>  crypto_rfc4106_exit_tfm+0x1a/0x20 crypto/gcm.c:895
>  crypto_aead_exit_tfm+0x18/0x20 crypto/aead.c:88
>  crypto_exit_ops crypto/api.c:315 [inline]
>  crypto_destroy_tfm+0x49/0xf0 crypto/api.c:579
>  crypto_free_aead include/crypto/aead.h:193 [inline]
>  aead_release+0x19/0x30 crypto/algif_aead.c:511
>  alg_do_release crypto/af_alg.c:119 [inline]
>  alg_sock_destruct+0x2d/0x40 crypto/af_alg.c:360
>  __sk_destruct+0x2e/0x250 net/core/sock.c:1558
>  sk_destruct+0x2f/0x60 net/core/sock.c:1593
>  __sk_free+0xbe/0xf0 net/core/sock.c:1601
>  sk_free+0x2a/0x40 net/core/sock.c:1612
>  sock_put include/net/sock.h:1653 [inline]
>  af_alg_release+0x42/0x50 crypto/af_alg.c:126
>  sock_release+0x2c/0xc0 net/socket.c:600
>  sock_close+0x16/0x20 net/socket.c:1129
>  __fput+0x120/0x270 fs/file_table.c:209
>  ____fput+0x15/0x20 fs/file_table.c:243
>  task_work_run+0xa3/0xe0 kernel/task_work.c:113
>  exit_task_work include/linux/task_work.h:22 [inline]
>  do_exit+0x3e6/0x1050 kernel/exit.c:869
>  do_group_exit+0x60/0x100 kernel/exit.c:972
>  SYSC_exit_group kernel/exit.c:983 [inline]
>  SyS_exit_group+0x18/0x20 kernel/exit.c:981
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x452a09
> RSP: 002b:0000000000a2fa08 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000071bec8 RCX: 0000000000452a09
> RDX: 0000000000000000 RSI: 0000000000722750 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000852
> R10: 000000000000000c R11: 0000000000000202 R12: 0000000000a2f9b0
> R13: 000000000071bea0 R14: 0000000000000519 R15: 000000000000000c
> Code: 41 ff d6 e8 04 62 c4 ff 4c 89 e7 e8 4c 8d c0 ff 4c 89 ef e8 54 fa d0
> ff e8 ef 61 c4 ff 5b 41 5c 41 5d 41 5e 5d c3 e8 e1 61 c4 ff <4c> 8b b3 88 01
> 00 00 4d 85 f6 74 32 e8 d0 61 c4 ff 4c 89 e7 41
> RIP: crypto_destroy_tfm+0x9f/0xf0 crypto/api.c:577 RSP: ffffc90000df7c40
> CR2: 0000000000000188
> ---[ end trace 51087c3b0b04438f ]---

Invalidating this bug since it hasn't been seen again, and it was reported while
KASAN was accidentally disabled in the syzbot kconfig due to a change to the
kconfig menus in linux-next (so this crash was possibly caused by slab
corruption elsewhere).

#syz invalid
