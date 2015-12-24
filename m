From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: GPF in lrw_crypt
Date: Thu, 24 Dec 2015 12:03:50 +0100
Message-ID: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
References: <CACT4Y+aE-pNUnCLbDQkFQ9Y7QivN_g6hEuS7t1RpknPHFmHg+g@mail.gmail.com>
 <20151224093902.GA8235@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: syzkaller <syzkaller@googlegroups.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151224093902.GA8235@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 24, 2015 at 10:39 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Thu, Dec 17, 2015 at 01:59:11PM +0100, Dmitry Vyukov wrote:
>>
>> The following program causes GPF in lrw_crypt:
>
> OK, this is a result of certain implementations (such as lrw)
> not coping with there being no key gracefully.
>
> I think the easiest way is probably to check this in algif_skcipher.
>
> ---8<---
> Subject: crypto: algif_skcipher - Require setkey before accept(2)
>
> Some cipher implementations will crash if you try to use them
> without calling setkey first.  This patch adds a check so that
> the accept(2) call will fail with -ENOKEY if setkey hasn't been
> done on the socket yet.
>
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 5c756b3..b62c973 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -31,6 +31,11 @@ struct skcipher_sg_list {
>         struct scatterlist sg[0];
>  };
>
> +struct skcipher_tfm {
> +       struct crypto_skcipher *skcipher;
> +       bool has_key;
> +};
> +
>  struct skcipher_ctx {
>         struct list_head tsgl;
>         struct af_alg_sgl rsgl;
> @@ -750,17 +755,38 @@ static struct proto_ops algif_skcipher_ops = {
>
>  static void *skcipher_bind(const char *name, u32 type, u32 mask)
>  {
> -       return crypto_alloc_skcipher(name, type, mask);
> +       struct skcipher_tfm *tfm;
> +
> +       tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
> +       if (!tfm)
> +               return ERR_PTR(-ENOMEM);
> +
> +       tfm->skcipher = crypto_alloc_skcipher(name, type, mask);
> +       if (IS_ERR(tfm->skcipher)) {
> +               kfree(tfm);
> +               return ERR_CAST(tfm->skcipher);
> +       }
> +
> +       return tfm;
>  }
>
>  static void skcipher_release(void *private)
>  {
> -       crypto_free_skcipher(private);
> +       struct skcipher_tfm *tfm = private;
> +
> +       crypto_free_skcipher(tfm->skcipher);
> +       kfree(tfm);
>  }
>
>  static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
>  {
> -       return crypto_skcipher_setkey(private, key, keylen);
> +       struct skcipher_tfm *tfm = private;
> +       int err;
> +
> +       err = crypto_skcipher_setkey(tfm->skcipher, key, keylen);
> +       tfm->has_key = !err;
> +
> +       return err;
>  }
>
>  static void skcipher_wait(struct sock *sk)
> @@ -792,20 +818,25 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
>  {
>         struct skcipher_ctx *ctx;
>         struct alg_sock *ask = alg_sk(sk);
> -       unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(private);
> +       struct skcipher_tfm *tfm = private;
> +       struct crypto_skcipher *skcipher = tfm->skcipher;
> +       unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(skcipher);
> +
> +       if (!tfm->has_key)
> +               return -ENOKEY;
>
>         ctx = sock_kmalloc(sk, len, GFP_KERNEL);
>         if (!ctx)
>                 return -ENOMEM;
>
> -       ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(private),
> +       ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(skcipher),
>                                GFP_KERNEL);
>         if (!ctx->iv) {
>                 sock_kfree_s(sk, ctx, len);
>                 return -ENOMEM;
>         }
>
> -       memset(ctx->iv, 0, crypto_skcipher_ivsize(private));
> +       memset(ctx->iv, 0, crypto_skcipher_ivsize(skcipher));
>
>         INIT_LIST_HEAD(&ctx->tsgl);
>         ctx->len = len;
> @@ -818,7 +849,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
>
>         ask->private = ctx;
>
> -       skcipher_request_set_tfm(&ctx->req, private);
> +       skcipher_request_set_tfm(&ctx->req, skcipher);
>         skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>                                       af_alg_complete, &ctx->completion);
>


Hi Herbert,

I am testing with your two patches:
crypto: algif_skcipher - Use new skcipher interface
crypto: algif_skcipher - Require setkey before accept(2)
on top of a88164345b81292b55a8d4829fdd35c8d611cd7d (Dec 23).

Now the following program causes a bunch of use-after-frees and them
kills kernel:

// autogenerated by syzkaller (http://github.com/google/syzkaller)
#include <unistd.h>
#include <sys/syscall.h>
#include <string.h>
#include <stdint.h>
#include <pthread.h>

long r[10];

int main()
{
        memset(r, -1, sizeof(r));
        r[0] = syscall(SYS_mmap, 0x20000000ul, 0xca7000ul, 0x3ul,
0x32ul, 0xfffffffffffffffful, 0x0ul);
        memcpy((void*)0x20ca6bc1,
"\x2e\x2f\x63\x6f\x6e\x74\x72\x6f\x6c\x00", 10);
        r[2] = syscall(SYS_creat, 0x20ca6bc1ul, 0x28ul, 0, 0, 0, 0);
        r[3] = syscall(SYS_socket, 0x26ul, 0x5ul, 0x0ul, 0, 0, 0);
        *(uint16_t*)0x20000986 = (uint16_t)0x26;
        memcpy((void*)0x20000988,
"\x73\x6b\x63\x69\x70\x68\x65\x72\x00\x00\x00\x00\x00\x00", 14);
        *(uint32_t*)0x20000996 = (uint32_t)0x1;
        *(uint32_t*)0x2000099a = (uint32_t)0xf;
        memcpy((void*)0x2000099e,
"\x5f\x5f\x65\x63\x62\x2d\x73\x65\x72\x70\x65\x6e\x74\x2d\x73\x73\x65\x32\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
64);
        r[9] = syscall(SYS_bind, r[3], 0x20000986ul, 0x58ul, 0, 0, 0);
        return 0;
}

==================================================================
BUG: KASAN: use-after-free in skcipher_bind+0xe1/0x100 at addr ffff88003398bab0
Read of size 8 by task syz-executor/15123
=============================================================================
BUG kmalloc-16 (Not tainted): kasan: bad access detected
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: Allocated in skcipher_bind+0x55/0x100 age=36 cpu=1 pid=15123
[<      none      >] ___slab_alloc+0x489/0x4e0 mm/slub.c:2468
[<      none      >] __slab_alloc+0x4c/0x90 mm/slub.c:2497
[<     inline     >] slab_alloc_node mm/slub.c:2560
[<     inline     >] slab_alloc mm/slub.c:2602
[<      none      >] kmem_cache_alloc_trace+0x264/0x2f0 mm/slub.c:2619
[<     inline     >] kmalloc include/linux/slab.h:458
[<     inline     >] kzalloc include/linux/slab.h:602
[<      none      >] skcipher_bind+0x55/0x100 crypto/algif_skcipher.c:760
[<      none      >] alg_bind+0x18e/0x3a0 crypto/af_alg.c:155
[<      none      >] SYSC_bind+0x1ea/0x250 net/socket.c:1376
[<      none      >] SyS_bind+0x24/0x30 net/socket.c:1362
[<      none      >] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185

INFO: Freed in skcipher_bind+0xbd/0x100 age=7 cpu=2 pid=15123
[<      none      >] __slab_free+0x1fc/0x320 mm/slub.c:2678
[<     inline     >] slab_free mm/slub.c:2833
[<      none      >] kfree+0x26a/0x290 mm/slub.c:3662
[<      none      >] skcipher_bind+0xbd/0x100 crypto/algif_skcipher.c:766
[<      none      >] alg_bind+0x18e/0x3a0 crypto/af_alg.c:155
[<      none      >] SYSC_bind+0x1ea/0x250 net/socket.c:1376
[<      none      >] SyS_bind+0x24/0x30 net/socket.c:1362
[<      none      >] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185

Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff8289a21d>] dump_stack+0x6f/0xa2 lib/dump_stack.c:50
 [<ffffffff816c56f4>] print_trailer+0xf4/0x150 mm/slub.c:659
 [<ffffffff816cbeaf>] object_err+0x2f/0x40 mm/slub.c:689
 [<     inline     >] print_address_description mm/kasan/report.c:138
 [<ffffffff816ce86d>] kasan_report_error+0x25d/0x560 mm/kasan/report.c:251
 [<     inline     >] kasan_report mm/kasan/report.c:274
 [<ffffffff816cec6e>] __asan_report_load8_noabort+0x3e/0x40
mm/kasan/report.c:295
 [<ffffffff827ddb41>] skcipher_bind+0xe1/0x100 crypto/algif_skcipher.c:767
 [<ffffffff827da38e>] alg_bind+0x18e/0x3a0 crypto/af_alg.c:155
 [<ffffffff84b5a0ba>] SYSC_bind+0x1ea/0x250 net/socket.c:1376
 [<ffffffff84b5c7e4>] SyS_bind+0x24/0x30 net/socket.c:1362
 [<ffffffff85c8b376>] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185
==================================================================
==================================================================
BUG: KASAN: use-after-free in skcipher_release+0x43/0x50 at addr
ffff88003398b4f8
Read of size 8 by task syz-executor/15123
=============================================================================
BUG kmalloc-16 (Tainted: G    B          ): kasan: bad access detected
-----------------------------------------------------------------------------
INFO: Allocated in kstrdup_const+0x46/0x60 age=28033 cpu=0 pid=14775
[<      none      >] ___slab_alloc+0x489/0x4e0 mm/slub.c:2468
[<      none      >] __slab_alloc+0x4c/0x90 mm/slub.c:2497
[<     inline     >] slab_alloc mm/slub.c:2560
[<      none      >] __kmalloc_track_caller+0x278/0x310 mm/slub.c:4066
[<      none      >] kstrdup+0x39/0x70 mm/util.c:53
[<      none      >] kstrdup_const+0x46/0x60 mm/util.c:74
[<      none      >] alloc_vfsmnt+0xe7/0x760 fs/namespace.c:212
[<      none      >] clone_mnt+0x74/0xa20 fs/namespace.c:973
[<      none      >] copy_tree+0x3c0/0x940 fs/namespace.c:1713
[<      none      >] copy_mnt_ns+0x110/0x8b0 fs/namespace.c:2800
[<      none      >] create_new_namespaces+0xd0/0x610 kernel/nsproxy.c:70
[<      none      >] unshare_nsproxy_namespaces+0xa9/0x1d0 kernel/nsproxy.c:190
[<     inline     >] SYSC_unshare kernel/fork.c:2008
[<      none      >] SyS_unshare+0x3b0/0x800 kernel/fork.c:1958
[<      none      >] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185

INFO: Freed in kfree_const+0x39/0x50 age=28020 cpu=1 pid=7161
[<      none      >] __slab_free+0x1fc/0x320 mm/slub.c:2678
[<     inline     >] slab_free mm/slub.c:2833
[<      none      >] kfree+0x26a/0x290 mm/slub.c:3662
[<      none      >] kfree_const+0x39/0x50 mm/util.c:35
[<      none      >] free_vfsmnt+0x37/0x80 fs/namespace.c:580
[<      none      >] delayed_free_vfsmnt+0x16/0x20 fs/namespace.c:589
[<     inline     >] __rcu_reclaim kernel/rcu/rcu.h:118
[<     inline     >] rcu_do_batch kernel/rcu/tree.c:2694
[<     inline     >] invoke_rcu_callbacks kernel/rcu/tree.c:2962
[<     inline     >] __rcu_process_callbacks kernel/rcu/tree.c:2929
[<      none      >] rcu_process_callbacks+0xc71/0x1380 kernel/rcu/tree.c:2946
[<      none      >] __do_softirq+0x23b/0x8a0 kernel/softirq.c:273
[<     inline     >] invoke_softirq kernel/softirq.c:350
[<      none      >] irq_exit+0x15d/0x190 kernel/softirq.c:391
[<     inline     >] exiting_irq ./arch/x86/include/asm/apic.h:653
[<      none      >] smp_apic_timer_interrupt+0x83/0xa0
arch/x86/kernel/apic/apic.c:926
[<      none      >] apic_timer_interrupt+0x8c/0xa0
arch/x86/entry/entry_64.S:520
[<      none      >] percpu_down_read_trylock+0x22/0xc0
kernel/locking/percpu-rwsem.c:87
[<      none      >] __sb_start_write+0x116/0x130 fs/super.c:1200
[<     inline     >] sb_start_write_trylock include/linux/fs.h:1454
[<      none      >] touch_atime+0x130/0x280 fs/inode.c:1643
[<     inline     >] file_accessed include/linux/fs.h:1916
[<      none      >] pipe_read+0x70d/0xb20 fs/pipe.c:328
[<     inline     >] new_sync_read fs/read_write.c:422
[<      none      >] __vfs_read+0x2fd/0x460 fs/read_write.c:434
[<      none      >] vfs_read+0x106/0x310 fs/read_write.c:454

Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff8289a21d>] dump_stack+0x6f/0xa2 lib/dump_stack.c:50
 [<ffffffff816c56f4>] print_trailer+0xf4/0x150 mm/slub.c:659
 [<ffffffff816cbeaf>] object_err+0x2f/0x40 mm/slub.c:689
 [<     inline     >] print_address_description mm/kasan/report.c:138
 [<ffffffff816ce86d>] kasan_report_error+0x25d/0x560 mm/kasan/report.c:251
 [<     inline     >] kasan_report mm/kasan/report.c:274
 [<ffffffff816cec6e>] __asan_report_load8_noabort+0x3e/0x40
mm/kasan/report.c:295
 [<ffffffff827dda53>] skcipher_release+0x43/0x50 crypto/algif_skcipher.c:777
 [<     inline     >] alg_do_release crypto/af_alg.c:116
 [<ffffffff827d9d8c>] alg_sock_destruct+0x8c/0xe0 crypto/af_alg.c:315
 [<ffffffff84b6bb0a>] sk_destruct+0x4a/0x490 net/core/sock.c:1447
 [<ffffffff84b6bfa7>] __sk_free+0x57/0x200 net/core/sock.c:1475
 [<ffffffff84b6c180>] sk_free+0x30/0x40 net/core/sock.c:1486
 [<     inline     >] sock_put include/net/sock.h:1627
 [<ffffffff827d95db>] af_alg_release+0x5b/0x70 crypto/af_alg.c:123
 [<ffffffff84b55aed>] sock_release+0x8d/0x1d0 net/socket.c:571
 [<ffffffff84b55c46>] sock_close+0x16/0x20 net/socket.c:1022
 [<ffffffff81716103>] __fput+0x233/0x780 fs/file_table.c:208
 [<ffffffff817166d5>] ____fput+0x15/0x20 fs/file_table.c:244
 [<ffffffff8134679b>] task_work_run+0x16b/0x200 kernel/task_work.c:115
 [<     inline     >] exit_task_work include/linux/task_work.h:21
 [<ffffffff812f4d3b>] do_exit+0x8bb/0x2b20 kernel/exit.c:750
 [<ffffffff812f7118>] do_group_exit+0x108/0x320 kernel/exit.c:880
 [<     inline     >] SYSC_exit_group kernel/exit.c:891
 [<ffffffff812f734d>] SyS_exit_group+0x1d/0x20 kernel/exit.c:889
 [<ffffffff85c8b376>] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185
==================================================================

... a bunch of reports skipped ...

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
Fixing recursive fault but reboot is needed!
