From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in hmac_init_tfm
Date: Wed, 20 Dec 2017 15:42:29 -0800
Message-ID: <20171220234229.GG38504@gmail.com>
References: <94eb2c0d010ad8f1660560a275fd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+428944d1a848e9d7464aa96da32ba353cc812457@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94eb2c0d010ad8f1660560a275fd@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 18, 2017 at 11:36:01AM -0800, syzbot wrote:
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
> BUG: unable to handle kernel paging request at ffff8802dca4f748
> IP: hmac_init_tfm+0x5d/0x90 crypto/hmac.c:169
> PGD 404e067 P4D 404e067 PUD 0
> Oops: 0002 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 6418 Comm: syz-executor5 Not tainted
> 4.15.0-rc3-next-20171214+ #67
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> RIP: 0010:hmac_init_tfm+0x5d/0x90 crypto/hmac.c:169
> RSP: 0018:ffffc90000f77df8 EFLAGS: 00010202
> RAX: 0000000000000068 RBX: ffff8801dca52308 RCX: ffffffff816847d3
> RDX: 00000000000005d6 RSI: ffffc90004d7e000 RDI: ffff8802143cc708
> RBP: ffffc90000f77e10 R08: 000000000002bcf8 R09: ffff8802143cc700
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802143cc700
> R13: ffff8802dca4f748 R14: ffff8801e0a96c50 R15: ffffc90000f77ed0
> FS:  00007fecf7c1a700(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff8802dca4f748 CR3: 00000001e47f4000 CR4: 00000000001406e0
> DR0: 0000000020000008 DR1: 0000000020000008 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  crypto_create_tfm+0xb4/0x120 crypto/api.c:466
>  crypto_alloc_tfm+0x82/0x180 crypto/api.c:540
>  crypto_alloc_shash+0x2c/0x40 crypto/shash.c:436
>  sctp_listen_start net/sctp/socket.c:7496 [inline]
>  sctp_inet_listen+0x1c1/0x240 net/sctp/socket.c:7584
>  SYSC_listen net/socket.c:1483 [inline]
>  SyS_listen+0x71/0xb0 net/socket.c:1469
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x452a39
> RSP: 002b:00007fecf7c19c58 EFLAGS: 00000212 ORIG_RAX: 0000000000000032
> RAX: ffffffffffffffda RBX: 0000000000758020 RCX: 0000000000452a39
> RDX: 0000000000000000 RSI: 0000000000000ae0 RDI: 000000000000001b
> RBP: 00000000000000e8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006ef660
> R13: 00000000ffffffff R14: 00007fecf7c1a6d4 R15: 0000000000000000
> Code: ff 01 c0 4c 8d 6c 02 07 e8 a1 22 ff ff 49 83 e5 f8 48 3d 00 f0
> ff ff 49 89 c4 77 25 e8 6d 5b c3 ff 41 8b 04 24 83 c0 10 89 43 f8
> <4d> 89 65 00 45 31 e4 e8 57 5b c3 ff 44 89 e0 5b 41 5c 41 5d 5d
> RIP: hmac_init_tfm+0x5d/0x90 crypto/hmac.c:169 RSP: ffffc90000f77df8
> CR2: ffff8802dca4f748
> ---[ end trace ec6d3df7509d0a3b ]---
> Kernel panic - not syncing: Fatal exception
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

The crash was actually on the line 'ctx->hash = hash;' in hmac_init_tfm():

	static int hmac_init_tfm(struct crypto_tfm *tfm)
	{
		struct crypto_shash *parent = __crypto_shash_cast(tfm);
		struct crypto_shash *hash;
		struct crypto_instance *inst = (void *)tfm->__crt_alg;
		struct crypto_shash_spawn *spawn = crypto_instance_ctx(inst);
		struct hmac_ctx *ctx = hmac_ctx(parent);

		hash = crypto_spawn_shash(spawn);
		if (IS_ERR(hash))
			return PTR_ERR(hash);

		parent->descsize = sizeof(struct shash_desc) +
				   crypto_shash_descsize(hash);

		ctx->hash = hash;
		return 0;
	}

'parent' was ffff8801dca52308 in RBX while 'ctx' was ffff8802dca4f748 in R13.
They are supposed to be almost the same but were actually quite different, so I
think the ->statesize and/or the ->cra_alignmask in the shash_alg got corrupted,
causing hmac_ctx() to return the wrong value.  I am guessing use-after-free, so
the report would have been more useful with KASAN enabled.

Eric
