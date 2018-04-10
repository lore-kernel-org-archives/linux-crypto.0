From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] crypto: DRBG - guard uninstantion by lock
Date: Tue, 10 Apr 2018 17:23:46 +0200
Message-ID: <CACT4Y+Y+ydyBAL=j2QOWaBnpY8+Bsr_80d80RXth0SwuY0wMuQ@mail.gmail.com>
References: <001a114467482dbc4b05692df8f9@google.com> <6541596.TtyMCBNA0Q@positron.chronox.de>
 <20180408224603.GA32004@thunk.org> <58589900.TM7ux0T285@tauon.chronox.de> <CACT4Y+aKnKT3AwvbEw_khsYUySLDz4mW7dZ6n7O6McbfPTjd8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+aKnKT3AwvbEw_khsYUySLDz4mW7dZ6n7O6McbfPTjd8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 9, 2018 at 9:57 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Mon, Apr 9, 2018 at 7:40 AM, Stephan Mueller <smueller@chronox.de> wrote:
>> Am Montag, 9. April 2018, 00:46:03 CEST schrieb Theodore Y. Ts'o:
>>
>> Hi Theodore,
>>>
>>> So the syzbot will run while the patch goes through the normal e-mail
>>> review process, which is kind of neat.  :-)
>>
>> Thank you very much for the hint. That is a neat feature indeed.
>>
>> As I came late to the party and I missed the original mails, I am wondering
>> about which GIT repo was used and which branch of it. With that, I would be
>> happy to resubmit with the test line.
>
> All syzbot reported bugs are available here:
> https://groups.google.com/forum/#!searchin/syzkaller-bugs/"WARNING$20in$20kmem_cache_free"
> and here:
> https://syzkaller.appspot.com/
>
> But unfortunately testing won't work in this case, because I manually
> extracted a reproducer and syzbot does not know about it. This bug
> seems to lead to assorted silent heap corruptions and different
> manifestations each time, so it's difficult for syzbot to attribute a
> reproducer to the bug. When we debug it, it would be nice to
> understand why the heap corruption is silent and is not detected by
> KASAN and anything else, to prevent such unpleasant cases in future.
>
> I've tested it manually, but unfortunately kernel still crashed within a minute:

Stephan,

Do you have any hypothesis as to why this is not detected by KASAN and
causes silent corruptions?
We generally try to understand such cases and improve KASAN so that it
catches such cases more reliably and they do not cause splashes of
random crashes on syzbot.

Thanks



> $ git status
> HEAD detached at f2d285669aae
> Changes not staged for commit:
>   (use "git add <file>..." to update what will be committed)
>   (use "git checkout -- <file>..." to discard changes in working directory)
>
> modified:   crypto/drbg.c
>
> $ git diff
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 4faa2781c964..68c1949a253f 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1510,8 +1510,8 @@ static int drbg_instantiate(struct drbg_state
> *drbg, struct drbg_string *pers,
>         return ret;
>
>  free_everything:
> -       mutex_unlock(&drbg->drbg_mutex);
>         drbg_uninstantiate(drbg);
> +       mutex_unlock(&drbg->drbg_mutex);
>         return ret;
>  }
>
> # ./a.out
> ...
> [  183.647874] FAULT_INJECTION: forcing a failure.
> [  183.647874] name failslab, interval 1, probability 0, space 0, times 0
> [  183.648287] Call Trace:
> [  183.648297]  dump_stack+0x1b9/0x29f
> [  183.648306]  ? arch_local_irq_restore+0x52/0x52
> [  183.648318]  ? __save_stack_trace+0x7e/0xd0
> [  183.651848]  should_fail.cold.4+0xa/0x1a
> [  183.652411]  ? fault_create_debugfs_attr+0x1f0/0x1f0
> [  183.653138]  ? kasan_kmalloc+0xc4/0xe0
> [  183.653694]  ? __kmalloc+0x14e/0x760
> [  183.654206]  ? drbg_kcapi_seed+0x776/0x12e0
> [  183.654798]  ? crypto_rng_reset+0x7c/0x130
> [  183.655379]  ? rng_setkey+0x25/0x30
> [  183.655882]  ? alg_setsockopt+0x306/0x3b0
> [  183.656450]  ? graph_lock+0x170/0x170
> [  183.656975]  ? entry_SYSENTER_compat+0x70/0x7f
> [  183.657606]  ? find_held_lock+0x36/0x1c0
> [  183.658164]  ? __lock_is_held+0xb5/0x140
> [  183.658728]  ? check_same_owner+0x320/0x320
> [  183.659321]  ? rcu_note_context_switch+0x710/0x710
> [  183.660000]  should_failslab+0x124/0x180
> [  183.660561]  __kmalloc+0x2c8/0x760
> [  183.661046]  ? graph_lock+0x170/0x170
> [  183.661569]  ? drbg_kcapi_seed+0x882/0x12e0
> [  183.662161]  drbg_kcapi_seed+0x882/0x12e0
> [  183.662731]  ? drbg_seed+0x10a0/0x10a0
> [  183.663267]  ? lock_downgrade+0x8e0/0x8e0
> [  183.663833]  ? lock_acquire+0x1dc/0x520
> [  183.664385]  ? lock_release+0xa10/0xa10
> [  183.664934]  ? check_same_owner+0x320/0x320
> [  183.665530]  ? __sanitizer_cov_trace_const_cmp8+0x18/0x20
> [  183.666292]  ? __check_object_size+0x95/0x5d9
> [  183.666904]  ? sock_kmalloc+0x14e/0x1d0
> [  183.667444]  ? mark_held_locks+0xc9/0x160
> [  183.668020]  ? __might_sleep+0x95/0x190
> [  183.668567]  crypto_rng_reset+0x7c/0x130
> [  183.669124]  rng_setkey+0x25/0x30
> [  183.669598]  ? rng_sock_destruct+0x90/0x90
> [  183.670176]  alg_setsockopt+0x306/0x3b0
> [  183.670724]  __compat_sys_setsockopt+0x315/0x7c0
> [  183.671375]  ? __compat_sys_getsockopt+0x7f0/0x7f0
> [  183.672057]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.672813]  ? ksys_write+0x1a6/0x250
> [  183.673333]  ? SyS_read+0x30/0x30
> [  183.673811]  compat_SyS_setsockopt+0x34/0x50
> [  183.674416]  ? scm_detach_fds_compat+0x440/0x440
> [  183.675079]  do_fast_syscall_32+0x41f/0x10dc
> [  183.675725]  ? do_page_fault+0xee/0x8a7
> [  183.676284]  ? do_int80_syscall_32+0xa70/0xa70
> [  183.676925]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  183.677590]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.678348]  ? syscall_return_slowpath+0x30f/0x5c0
> [  183.679026]  ? sysret32_from_system_call+0x5/0x3c
> [  183.679694]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [  183.680380]  entry_SYSENTER_compat+0x70/0x7f
> [  183.681000] RIP: 0023:0xf7f0ecb9
> [  183.681488] RSP: 002b:00000000ffeb1e9c EFLAGS: 00000296 ORIG_RAX:
> 000000000000016e
> [  183.682606] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000117
> [  183.683620] RDX: 0000000000000001 RSI: 00000000205b1fd0 RDI: 0000000000000000
> [  183.684602] RBP: 0000000020000040 R08: 0000000000000000 R09: 0000000000000000
> [  183.685622] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  183.686642] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  183.687712] CPU: 0 PID: 5506 Comm: a.out Not tainted 4.16.0+ #4
> [  183.688602] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1 04/01/2014
> [  183.689764] BUG: unable to handle kernel
> [  183.689776] Call Trace:
> [  183.689782] NULL pointer dereference
> [  183.690367]  dump_stack+0x1b9/0x29f
> [  183.690709]  at 0000000000000106
> [  183.691237]  ? arch_local_irq_restore+0x52/0x52
> [  183.691721] PGD 64a50067
> [  183.692164]  should_fail.cold.4+0xa/0x1a
> [  183.692747] P4D 64a50067
> [  183.693110]  ? fault_create_debugfs_attr+0x1f0/0x1f0
> [  183.693620] PUD 61a17067
> [  183.693981]  ? graph_lock+0x170/0x170
> [  183.694622] PMD 0
> [  183.694980]  ? find_held_lock+0x36/0x1c0
> [  183.695766]  ? __lock_is_held+0xb5/0x140
> [  183.696285] Oops: 0000 [#1] SMP KASAN
> [  183.696852]  ? check_same_owner+0x320/0x320
> [  183.697337] Modules linked in:
> [  183.697962]  ? rcu_note_context_switch+0x710/0x710
> [  183.697973] CPU: 2 PID: 4054 Comm: a.out Not tainted 4.16.0+ #4
> [  183.698436]  ? drbg_init_hash_kernel+0x300/0x300
> [  183.699060] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1 04/01/2014
> [  183.699942]  should_failslab+0x124/0x180
> [  183.700559] RIP: 0010:qlist_free_all+0x37/0x160
> [  183.701763]  __kmalloc+0x2c8/0x760
> [  183.702292] RSP: 0018:ffff880062de7050 EFLAGS: 00010246
> [  183.702976]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  183.703437] RAX: ffff88000040008c RBX: 0000000000000282 RCX: 0000000000000000
> [  183.704205]  ? drbg_kcapi_seed+0x776/0x12e0
> [  183.704804] RDX: ffffea0000010000 RSI: ffff88007ffdc39f RDI: 0000000000000282
> [  183.704812] RBP: ffff880062de7088 R08: ffff88006bb1ce78 R09: 0000000000000006
> [  183.705824]  drbg_kcapi_seed+0x776/0x12e0
> [  183.706369] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  183.706377] R13: 000000000000000a R14: ffff88000040008c R15: ffffffff88b172a0
> [  183.707382]  ? drbg_seed+0x10a0/0x10a0
> [  183.708311] FS:  0000000000000000(0000) GS:ffff88006c900000(0063)
> knlGS:0000000009fbd840
> [  183.708839]  ? lock_downgrade+0x8e0/0x8e0
> [  183.709760] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [  183.710760]  ? lock_acquire+0x1dc/0x520
> [  183.711252] CR2: 0000000000000106 CR3: 00000000651d8002 CR4: 00000000001606e0
> [  183.711257] Call Trace:
> [  183.712390]  ? lock_release+0xa10/0xa10
> [  183.712922]  quarantine_reduce+0x141/0x170
> [  183.713733]  ? check_same_owner+0x320/0x320
> [  183.714246]  kasan_kmalloc+0x99/0xe0
> [  183.715244]  ? __sanitizer_cov_trace_const_cmp8+0x18/0x20
> [  183.715586]  kasan_slab_alloc+0x12/0x20
> [  183.716143]  ? __check_object_size+0x95/0x5d9
> [  183.716683]  kmem_cache_alloc_node+0x131/0x780
> [  183.717282]  ? sock_kmalloc+0x14e/0x1d0
> [  183.717760]  ? do_raw_spin_unlock+0x1f9/0x2e0
> [  183.718520]  ? mark_held_locks+0xc9/0x160
> [  183.719029]  ? do_raw_spin_trylock+0x1b0/0x1b0
> [  183.719654]  ? __might_sleep+0x95/0x190
> [  183.720280]  copy_process.part.39+0x16c4/0x6ee0
> [  183.720828]  crypto_rng_reset+0x7c/0x130
> [  183.721434]  ? trace_hardirqs_on+0xd/0x10
> [  183.722007]  rng_setkey+0x25/0x30
> [  183.722596]  ? debug_object_active_state+0x2e7/0x4e0
> [  183.723145]  ? rng_sock_destruct+0x90/0x90
> [  183.723745]  ? kasan_check_read+0x11/0x20
> [  183.724308]  alg_setsockopt+0x306/0x3b0
> [  183.724845]  ? rcu_is_watching+0x85/0x140
> [  183.725324]  __compat_sys_setsockopt+0x315/0x7c0
> [  183.725972]  ? rcu_bh_force_quiescent_state+0x20/0x20
> [  183.726560]  ? __compat_sys_getsockopt+0x7f0/0x7f0
> [  183.727091]  ? __call_rcu.constprop.68+0x396/0xbb0
> [  183.727643]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.728173]  ? __cleanup_sighand+0x70/0x70
> [  183.728827]  ? ksys_write+0x1a6/0x250
> [  183.729485]  ? note_gp_changes+0x540/0x540
> [  183.730161]  ? SyS_read+0x30/0x30
> [  183.730797]  ? lock_downgrade+0x8e0/0x8e0
> [  183.731558]  compat_SyS_setsockopt+0x34/0x50
> [  183.732109]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
> [  183.732636]  ? scm_detach_fds_compat+0x440/0x440
> [  183.733180]  ? tty_kref_put.part.14+0x81/0x250
> [  183.733657]  do_fast_syscall_32+0x41f/0x10dc
> [  183.734190]  ? __cleanup_sighand+0x58/0x70
> [  183.734798]  ? do_page_fault+0xee/0x8a7
> [  183.735505]  ? do_raw_write_trylock+0x1b0/0x1b0
> [  183.736162]  ? do_int80_syscall_32+0xa70/0xa70
> [  183.736745]  ? print_usage_bug+0xc0/0xc0
> [  183.737367]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  183.737907]  ? trace_hardirqs_on_caller+0x421/0x5c0
> [  183.738459]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.739057]  ? call_rcu_sched+0x12/0x20
> [  183.739700]  ? syscall_return_slowpath+0x30f/0x5c0
> [  183.740220]  ? release_task.part.15+0xf70/0x1b90
> [  183.740882]  ? sysret32_from_system_call+0x5/0x3c
> [  183.741522]  ? __lock_acquire+0x7f5/0x5130
> [  183.742290]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [  183.742798]  ? rcu_is_watching+0x85/0x140
> [  183.743480]  entry_SYSENTER_compat+0x70/0x7f
> [  183.744099]  ? find_held_lock+0x36/0x1c0
> [  183.744769] RIP: 0023:0xf7f0ecb9
> [  183.745327]  ? debug_check_no_locks_freed+0x310/0x310
> [  183.745990] RSP: 002b:00000000ffeb1e9c EFLAGS: 00000296
> [  183.746525]  ? lock_downgrade+0x8e0/0x8e0
> [  183.747126]  ORIG_RAX: 000000000000016e
> [  183.747653]  ? find_held_lock+0x36/0x1c0
> [  183.748117] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000117
> [  183.748800]  ? print_usage_bug+0xc0/0xc0
> [  183.749530] RDX: 0000000000000001 RSI: 00000000205b1fd0 RDI: 0000000000000000
> [  183.749538] RBP: 0000000020000040 R08: 0000000000000000 R09: 0000000000000000
> [  183.750087]  ? lock_downgrade+0x8e0/0x8e0
> [  183.750632] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  183.751152]  ? lock_downgrade+0x8e0/0x8e0
> [  183.752156] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  183.752170] CPU: 3 PID: 5504 Comm: a.out Not tainted 4.16.0+ #4
> [  183.752693]  ? __lock_acquire+0x7f5/0x5130
> [  183.753653] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1 04/01/2014
> [  183.754595]  ? graph_lock+0x170/0x170
> [  183.755167] Call Trace:
> [  183.756102]  ? trace_hardirqs_on_caller+0x421/0x5c0
> [  183.756639]  dump_stack+0x1b9/0x29f
> [  183.757562]  ? debug_check_no_locks_freed+0x310/0x310
> [  183.758333]  ? arch_local_irq_restore+0x52/0x52
> [  183.758872]  ? find_held_lock+0x36/0x1c0
> [  183.759218] FAULT_INJECTION: forcing a failure.
> [  183.759218] name failslab, interval 1, probability 0, space 0, times 0
> [  183.759966]  ? __save_stack_trace+0x7e/0xd0
> [  183.760453]  ? lock_downgrade+0x8e0/0x8e0
> [  183.760788]  should_fail.cold.4+0xa/0x1a
> [  183.761427]  ? do_raw_spin_unlock+0x1f9/0x2e0
> [  183.761933]  ? fault_create_debugfs_attr+0x1f0/0x1f0
> [  183.762593]  ? do_raw_spin_trylock+0x1b0/0x1b0
> [  183.763216]  ? kasan_kmalloc+0xc4/0xe0
> [  183.763742]  ? _raw_spin_unlock_irqrestore+0x74/0xc0
> [  183.765288]  ? __kmalloc+0x14e/0x760
> [  183.765844]  ? trace_hardirqs_on_caller+0x421/0x5c0
> [  183.766423]  ? drbg_kcapi_seed+0x776/0x12e0
> [  183.766945]  ? trace_hardirqs_on+0xd/0x10
> [  183.767556]  ? crypto_rng_reset+0x7c/0x130
> [  183.768227]  ? graph_lock+0x170/0x170
> [  183.768845]  ? rng_setkey+0x25/0x30
> [  183.769368]  ? add_wait_queue+0x2a0/0x2a0
> [  183.770026]  ? alg_setsockopt+0x306/0x3b0
> [  183.770501]  ? kasan_check_write+0x14/0x20
> [  183.771198]  ? graph_lock+0x170/0x170
> [  183.771758]  ? do_raw_read_lock+0x3f/0x80
> [  183.772336]  ? entry_SYSENTER_compat+0x70/0x7f
> [  183.772887]  _do_fork+0x291/0x12a0
> [  183.773416]  ? find_held_lock+0x36/0x1c0
> [  183.773881]  ? fork_idle+0x1a0/0x1a0
> [  183.774458]  ? __lock_is_held+0xb5/0x140
> [  183.774989]  ? lock_release+0xa10/0xa10
> [  183.775581]  ? check_same_owner+0x320/0x320
> [  183.776070]  ? check_same_owner+0x320/0x320
> [  183.776650]  ? rcu_note_context_switch+0x710/0x710
> [  183.777234]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
> [  183.777725]  should_failslab+0x124/0x180
> [  183.778246]  ? put_pid.part.2+0x1bc/0x230
> [  183.778792]  __kmalloc+0x2c8/0x760
> [  183.779311]  ? __might_sleep+0x95/0x190
> [  183.779871]  ? graph_lock+0x170/0x170
> [  183.780426]  ? __might_fault+0x1a3/0x1e0
> [  183.781007]  ? drbg_kcapi_seed+0x882/0x12e0
> [  183.781643]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.782423]  drbg_kcapi_seed+0x882/0x12e0
> [  183.782942]  ? kernel_wait4+0x2d8/0x3d0
> [  183.783520]  ? drbg_seed+0x10a0/0x10a0
> [  183.783980]  ? SyS_waitid+0x40/0x40
> [  183.784539]  ? lock_downgrade+0x8e0/0x8e0
> [  183.785026]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.785596]  ? lock_acquire+0x1dc/0x520
> [  183.786146]  ? task_stopped_code+0x190/0x190
> [  183.786922]  ? lock_release+0xa10/0xa10
> [  183.787451]  compat_SyS_x86_clone+0x37/0x50
> [  183.788020]  ? check_same_owner+0x320/0x320
> [  183.788517]  ? compat_SyS_x86_fallocate+0x60/0x60
> [  183.789028]  ? __sanitizer_cov_trace_const_cmp8+0x18/0x20
> [  183.789556]  do_fast_syscall_32+0x41f/0x10dc
> [  183.790334]  ? __check_object_size+0x95/0x5d9
> [  183.790841]  ? do_page_fault+0xee/0x8a7
> [  183.791460]  ? sock_kmalloc+0x14e/0x1d0
> [  183.791971]  ? do_int80_syscall_32+0xa70/0xa70
> [  183.792583]  ? mark_held_locks+0xc9/0x160
> [  183.793137]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  183.793820]  ? __might_sleep+0x95/0x190
> [  183.794528]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.795147]  crypto_rng_reset+0x7c/0x130
> [  183.795737]  ? syscall_return_slowpath+0x30f/0x5c0
> [  183.796291]  rng_setkey+0x25/0x30
> [  183.796803]  ? sysret32_from_system_call+0x5/0x3c
> [  183.797442]  ? rng_sock_destruct+0x90/0x90
> [  183.797997]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [  183.798658]  alg_setsockopt+0x306/0x3b0
> [  183.799166]  entry_SYSENTER_compat+0x70/0x7f
> [  183.799971]  __compat_sys_setsockopt+0x315/0x7c0
> [  183.800486] RIP: 0023:0xf7f0ecb9
> [  183.801190]  ? __compat_sys_getsockopt+0x7f0/0x7f0
> [  183.801631] RSP: 002b:00000000ffeb1ec0 EFLAGS: 00000246
> [  183.802312]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.802850]  ORIG_RAX: 0000000000000078
> [  183.803534]  ? ksys_write+0x1a6/0x250
> [  183.804067] RAX: ffffffffffffffda RBX: 0000000001200011 RCX: 0000000000000000
> [  183.804693]  ? SyS_read+0x30/0x30
> [  183.805295] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000009fbd8a8
> [  183.805768]  compat_SyS_setsockopt+0x34/0x50
> [  183.806404] RBP: 00000000ffeb1ef8 R08: 0000000000000000 R09: 0000000000000000
> [  183.807154]  ? scm_detach_fds_compat+0x440/0x440
> [  183.807861] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  183.808421]  do_fast_syscall_32+0x41f/0x10dc
> [  183.808900] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  183.808905] Code:
> [  183.809928]  ? do_page_fault+0xee/0x8a7
> [  183.810365] 55
> [  183.811385]  ? do_int80_syscall_32+0xa70/0xa70
> [  183.811949] 48
> [  183.812992]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  183.813590] 89
> [  183.814630]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.815191] e5
> [  183.816214]  ? syscall_return_slowpath+0x30f/0x5c0
> [  183.816487] 41
> [  183.817066]  ? sysret32_from_system_call+0x5/0x3c
> [  183.817313] 57
> [  183.817958]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [  183.818200] 49
> [  183.818869]  entry_SYSENTER_compat+0x70/0x7f
> [  183.819109] c7
> [  183.819894] RIP: 0023:0xf7f0ecb9
> [  183.820135] c7
> [  183.820821] RSP: 002b:00000000ffeb1e9c EFLAGS: 00000296
> [  183.821065] a0
> [  183.821738]  ORIG_RAX: 000000000000016e
> [  183.821984] 72
> [  183.822657] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000117
> [  183.822900] b1
> [  183.823513] RDX: 0000000000000001 RSI: 00000000205b1fd0 RDI: 0000000000000000
> [  183.823760] 88
> [  183.824230] RBP: 0000000020000040 R08: 0000000000000000 R09: 0000000000000000
> [  183.824238] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  183.824492] 41
> [  183.825238] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  183.825250] CPU: 0 PID: 5512 Comm: a.out Not tainted 4.16.0+ #4
> [  183.825490] 56
> [  183.826073] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1 04/01/2014
> [  183.826204] FAULT_INJECTION: forcing a failure.
> [  183.826204] name failslab, interval 1, probability 0, space 0, times 0
> [  183.826315] 41
> [  183.827333] Call Trace:
> [  183.827583] 55
> [  183.828608]  dump_stack+0x1b9/0x29f
> [  183.828844] 41
> [  183.829864]  ? arch_local_irq_restore+0x52/0x52
> [  183.830780] 54
> [  183.831054]  ? __save_stack_trace+0x7e/0xd0
> [  183.831979] 49
> [  183.832860]  should_fail.cold.4+0xa/0x1a
> [  183.833097] 89
> [  183.834277]  ? fault_create_debugfs_attr+0x1f0/0x1f0
> [  183.835690] f4
> [  183.835964]  ? kasan_kmalloc+0xc4/0xe0
> [  183.836300] 53
> [  183.836568]  ? __kmalloc+0x14e/0x760
> [  183.836577]  ? drbg_kcapi_seed+0x776/0x12e0
> [  183.837061] 48
> [  183.837329]  ? crypto_rng_reset+0x7c/0x130
> [  183.837338]  ? rng_setkey+0x25/0x30
> [  183.837931] 83
> [  183.838200]  ? alg_setsockopt+0x306/0x3b0
> [  183.838748] ec
> [  183.839015]  ? __compat_sys_setsockopt+0x315/0x7c0
> [  183.839026]  ? do_fast_syscall_32+0x41f/0x10dc
> [  183.839536] 10
> [  183.839814]  ? entry_SYSENTER_compat+0x70/0x7f
> [  183.840457] 48
> [  183.840728]  ? check_same_owner+0x320/0x320
> [  183.841224] 89
> [  183.841495]  ? kasan_check_write+0x14/0x20
> [  183.841969] 7d
> [  183.842572]  ? kasan_unpoison_shadow+0x35/0x50
> [  183.842811] c8
> [  183.843405]  ? lock_acquire+0x1dc/0x520
> [  183.843867] 4d
> [  183.844142]  ? fs_reclaim_acquire+0x20/0x20
> [  183.844665] 89
> [  183.844935]  ? lock_downgrade+0x8e0/0x8e0
> [  183.845555] e5
> [  183.846234]  ? lock_release+0xa10/0xa10
> [  183.846474] 4d
> [  183.847130]  ? drbg_init_sym_kernel+0x516/0x74a
> [  183.847139]  ? check_same_owner+0x320/0x320
> [  183.847380] 85
> [  183.847991]  ? rcu_note_context_switch+0x710/0x710
> [  183.848229] e4
> [  183.848824]  should_failslab+0x124/0x180
> [  183.849063] 0f
> [  183.849707]  __kmalloc+0x2c8/0x760
> [  183.849946] 84
> [  183.850505]  ? lock_acquire+0x1dc/0x520
> [  183.850744] c8
> [  183.851350]  ? __fget+0x3e3/0x650
> [  183.851593] 00
> [  183.852177]  ? drbg_kcapi_seed+0x882/0x12e0
> [  183.852416] 00
> [  183.852972]  drbg_kcapi_seed+0x882/0x12e0
> [  183.853213] 00
> [  183.853867]  ? drbg_seed+0x10a0/0x10a0
> [  183.854414] <49>
> [  183.854688]  ? lock_acquire+0x1dc/0x520
> [  183.855313] 63
> [  183.855591]  ? __might_fault+0x12b/0x1e0
> [  183.856105] 95
> [  183.856375]  ? lock_downgrade+0x8e0/0x8e0
> [  183.856821] fc
> [  183.857090]  ? lock_acquire+0x1dc/0x520
> [  183.857590] 00
> [  183.857858]  ? lock_release+0xa10/0xa10
> [  183.858319] 00
> [  183.858589]  ? check_same_owner+0x320/0x320
> [  183.859131] 00
> [  183.859401]  ? __sanitizer_cov_trace_const_cmp8+0x18/0x20
> [  183.859928] 4c
> [  183.860200]  ? __check_object_size+0x95/0x5d9
> [  183.860689] 8b
> [  183.860983]  ? sock_kmalloc+0x14e/0x1d0
> [  183.861482] 30
> [  183.861748]  ? do_raw_spin_unlock+0x1f9/0x2e0
> [  183.861758]  ? __might_sleep+0x95/0x190
> [  183.862269] 48
> [  183.862539]  crypto_rng_reset+0x7c/0x130
> [  183.863079] 29
> [  183.863348]  rng_setkey+0x25/0x30
> [  183.863878] d0
> [  183.864150]  ? rng_sock_destruct+0x90/0x90
> [  183.864654] 49
> [  183.864924]  alg_setsockopt+0x306/0x3b0
> [  183.865488] 83
> [  183.865758]  __compat_sys_setsockopt+0x315/0x7c0
> [  183.866488] 3f
> [  183.866758]  ? __compat_sys_getsockopt+0x7f0/0x7f0
> [  183.867324] 00
> [  183.867598]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.868098] 48
> [  183.868369]  ? ksys_write+0x1a6/0x250
> [  183.868941] 89
> [  183.869500]  ? SyS_read+0x30/0x30
> [  183.869740] c6
> [  183.870312]  compat_SyS_setsockopt+0x34/0x50
> [  183.870551] 0f
> [  183.871043]  ? scm_detach_fds_compat+0x440/0x440
> [  183.871289] RIP: qlist_free_all+0x37/0x160 RSP: ffff880062de7050
> [  183.871893]  do_fast_syscall_32+0x41f/0x10dc
> [  183.872134] CR2: 0000000000000106
> [  183.872695]  ? do_page_fault+0xee/0x8a7
> [  183.872988] ---[ end trace 0fa4e77a7b3c174f ]---
> [  183.873604]  ? do_int80_syscall_32+0xa70/0xa70
> [  183.873611]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  183.873622]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  183.873871] Kernel panic - not syncing: Fatal exception
> [  183.874560]  ? syscall_return_slowpath+0x30f/0x5c0
> [  183.885552]  ? prepare_exit_to_usermode+0x390/0x390
> [  183.886255]  ? prepare_exit_to_usermode+0x285/0x390
> [  183.886953]  ? perf_trace_sys_enter+0xaf0/0xaf0
> [  183.887609]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [  183.888289]  entry_SYSENTER_compat+0x70/0x7f
> [  183.888906] RIP: 0023:0xf7f0ecb9
> [  183.889376] RSP: 002b:00000000ffeb1e9c EFLAGS: 00000296 ORIG_RAX:
> 000000000000016e
> [  183.890447] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000117
> [  183.891452] RDX: 0000000000000001 RSI: 00000000205b1fd0 RDI: 0000000000000000
> [  183.892463] RBP: 0000000020000040 R08: 0000000000000000 R09: 0000000000000000
> [  183.893471] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  183.894481] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  183.895514] Kernel Offset: disabled
> [  183.896034] Rebooting in 86400 seconds..
