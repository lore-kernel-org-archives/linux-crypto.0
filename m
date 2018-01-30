From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 af_alg_alloc_tsgl
Date: Tue, 30 Jan 2018 13:59:04 -0800
Message-ID: <20180130215904.6v3ejn7owcrmwl3q@gmail.com>
References: <001a1143fb3ec490990560b7ca3b@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+329f1aa885c4511d1a643fde1a3c87dcbba9fba1@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a1143fb3ec490990560b7ca3b@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 19, 2017 at 01:03:00PM -0800, syzbot wrote:
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
> device gre0 entered promiscuous mode
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> IP: af_alg_alloc_tsgl+0x3f/0x140 crypto/af_alg.c:501
> PGD 1deb48067 P4D 1deb48067 PUD 20c245067 PMD 0
> Oops: 0000 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 24829 Comm: syz-executor0 Not tainted 4.15.0-rc3-next-20171214+
> #67
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:af_alg_alloc_tsgl+0x3f/0x140 crypto/af_alg.c:501
> RSP: 0018:ffffc90000dd7ca8 EFLAGS: 00010206
> RAX: 0000000000010000 RBX: ffff88021578f000 RCX: ffffffff816c6b4f
> RDX: 00000000000000b0 RSI: ffffc90001089000 RDI: ffff8802156c6000
> RBP: ffffc90000dd7cc8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802156c6000
> R13: 000000000000008b R14: 0000000000000000 R15: ffff88021578f000
> FS:  00007f9dd3068700(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000010 CR3: 00000001e26ee000 CR4: 00000000001406e0
> Call Trace:
>  af_alg_sendmsg+0x1fa/0x580 crypto/af_alg.c:911
>  skcipher_sendmsg+0x3d/0x50 crypto/algif_skcipher.c:57
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
> RIP: 0033:0x452a39
> RSP: 002b:00007f9dd3067c58 EFLAGS: 00000212 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000758020 RCX: 0000000000452a39
> RDX: 000000000000008b RSI: 0000000020f3cf75 RDI: 0000000000000015
> RBP: 000000000000001a R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006ee310
> R13: 00000000ffffffff R14: 00007f9dd30686d4 R15: 0000000000000000
> Code: 8b 9c 24 60 04 00 00 48 8b 03 4c 8b 73 08 48 39 c3 0f 84 bf 00 00 00
> e8 00 38 bf ff 49 83 fe e8 0f 84 b0 00 00 00 e8 f1 37 bf ff <41> 83 7e 10 7d
> 0f 86 8e 00 00 00 e8 e1 37 bf ff 4c 89 e7 ba c0
> RIP: af_alg_alloc_tsgl+0x3f/0x140 crypto/af_alg.c:501 RSP: ffffc90000dd7ca8
> CR2: 0000000000000010
> ---[ end trace 374ebf1f5cd68b75 ]---
> Kernel panic - not syncing: Fatal exception
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

Invalidating this bug since it hasn't been seen again, and it was reported while
KASAN was accidentally disabled in the syzbot kconfig due to a change to the
kconfig menus in linux-next (so this crash was possibly caused by slab
corruption elsewhere).

#syz invalid
