From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in socket_file_ops
Date: Wed, 20 Dec 2017 14:39:31 -0800
Message-ID: <20171220223931.GE38504@gmail.com>
References: <089e08263e58bb3c0d0560cbbd87@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+cd76df3adeb2edd4836f7b3ef94d32d710c28421@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:44056 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755711AbdLTWjf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 17:39:35 -0500
Content-Disposition: inline
In-Reply-To: <089e08263e58bb3c0d0560cbbd87@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 12:51:01PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 6084b576dca2e898f5c101baef151f7bfdbb606d
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> alloc_fd: slot 80 not NULL!
> BUG: unable to handle kernel paging request at ffffffffffffffff
> alloc_fd: slot 81 not NULL!
> alloc_fd: slot 82 not NULL!
> alloc_fd: slot 83 not NULL!
> alloc_fd: slot 84 not NULL!
> alloc_fd: slot 86 not NULL!
> alloc_fd: slot 87 not NULL!
> IP: socket_file_ops+0x22/0x4d0
> PGD 3021067 P4D 3021067 PUD 3023067 PMD 0
> Oops: 0002 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 3358 Comm: cryptomgr_test Not tainted
> 4.15.0-rc3-next-20171214+ #67
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> RIP: 0010:socket_file_ops+0x22/0x4d0
> RSP: 0018:ffffc900017fbdf0 EFLAGS: 00010246
> RAX: ffff880214e4ca00 RBX: ffff8802156c74a0 RCX: ffffffff81678ac3
> RDX: 0000000000000000 RSI: ffff8802156c74a0 RDI: ffff8802156c74a0
> RBP: ffffc900017fbe18 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc900017fbeb0 R14: ffffc900017fbeb0 R15: ffffc900017fbeb0
> FS:  0000000000000000(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffff CR3: 000000000301e002 CR4: 00000000001606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  crypto_free_instance+0x2a/0x50 crypto/algapi.c:77
>  crypto_destroy_instance+0x1e/0x30 crypto/algapi.c:85
>  crypto_alg_put crypto/internal.h:116 [inline]
>  crypto_remove_final+0x73/0xa0 crypto/algapi.c:331
>  crypto_alg_tested+0x194/0x260 crypto/algapi.c:320
>  cryptomgr_test+0x17/0x30 crypto/algboss.c:226
>  kthread+0x149/0x170 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:524
> Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 50 51 40 81
> ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f8
> <09> 82 ff ff ff ff 00 26 0a 82 ff ff ff ff 00 00 00 00 00 00 00
> RIP: socket_file_ops+0x22/0x4d0 RSP: ffffc900017fbdf0
> CR2: ffffffffffffffff
> ---[ end trace 52c47d77c1a058d5 ]---
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
> IP: __neigh_event_send+0xa8/0x400 net/core/neighbour.c:1006
> PGD 0 P4D 0
> Oops: 0000 [#2] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 3122 Comm: sshd Tainted: G      D
> 4.15.0-rc3-next-20171214+ #67
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> RIP: 0010:__neigh_event_send+0xa8/0x400 net/core/neighbour.c:1006
> RSP: 0018:ffffc90000efb8b8 EFLAGS: 00010293
> RAX: ffff880214dba640 RBX: ffff8802156c4c00 RCX: ffffffff820e6fa4
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8802156c4c28
> RBP: ffffc90000efb8f8 R08: 0000000000000001 R09: ffffffff820e6f28
> R10: ffffc90000efb828 R11: 0000000000000000 R12: ffff8802156c4c28
> R13: ffff8802115896e0 R14: 0000000000000000 R15: ffffffff82e2eaf8
> FS:  00007f838bacb7c0(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000064 CR3: 0000000213530006 CR4: 00000000001606f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  neigh_event_send include/net/neighbour.h:435 [inline]
>  neigh_resolve_output+0x24a/0x340 net/core/neighbour.c:1334
>  neigh_output include/net/neighbour.h:482 [inline]
>  ip_finish_output2+0x2cf/0x7b0 net/ipv4/ip_output.c:229
>  ip_finish_output+0x2e6/0x490 net/ipv4/ip_output.c:317
>  NF_HOOK_COND include/linux/netfilter.h:270 [inline]
>  ip_output+0x73/0x2b0 net/ipv4/ip_output.c:405
>  dst_output include/net/dst.h:443 [inline]
>  ip_local_out+0x54/0xb0 net/ipv4/ip_output.c:124
>  ip_queue_xmit+0x27d/0x740 net/ipv4/ip_output.c:504
>  tcp_transmit_skb+0x66a/0xd70 net/ipv4/tcp_output.c:1176
>  tcp_write_xmit+0x262/0x13a0 net/ipv4/tcp_output.c:2367
>  __tcp_push_pending_frames+0x49/0xe0 net/ipv4/tcp_output.c:2540
>  tcp_push+0x14e/0x190 net/ipv4/tcp.c:730
>  tcp_sendmsg_locked+0x899/0x11a0 net/ipv4/tcp.c:1424
>  tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1461
>  inet_sendmsg+0x54/0x250 net/ipv4/af_inet.c:763
>  sock_sendmsg_nosec net/socket.c:636 [inline]
>  sock_sendmsg+0x51/0x70 net/socket.c:646
>  sock_write_iter+0xa4/0x100 net/socket.c:915
>  call_write_iter include/linux/fs.h:1776 [inline]
>  new_sync_write fs/read_write.c:469 [inline]
>  __vfs_write+0x15b/0x1e0 fs/read_write.c:482
>  vfs_write+0xf0/0x230 fs/read_write.c:544
>  SYSC_write fs/read_write.c:589 [inline]
>  SyS_write+0x57/0xd0 fs/read_write.c:581
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x7f8389e66370
> RSP: 002b:00007ffe535b0318 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8389e66370
> RDX: 0000000000000038 RSI: 0000562088cb2460 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0101010101010101
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000562088cbe590
> R13: 0000562088167fb4 R14: 0000000000000028 R15: 0000562088169ca0
> Code: ff 48 83 c4 18 44 89 e8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 ab
> 33 1d ff 41 f6 c6 05 0f 85 68 01 00 00 e8 9c 33 1d ff 4c 8b 73 10
> <41> 8b 46 64 41 03 46 5c 0f 84 a8 01 00 00 e8 85 33 1d ff 48 8b
> RIP: __neigh_event_send+0xa8/0x400 net/core/neighbour.c:1006 RSP:
> ffffc90000efb8b8
> CR2: 0000000000000064
> ---[ end trace 52c47d77c1a058d6 ]---

Probably the pcrypt_free() bug again; the repro is binding to
"pcrypt(gcm_base(ctr(aes-aesni),ghash-generic))" over and over.

#syz dup: KASAN: use-after-free Read in __list_del_entry_valid (2)
