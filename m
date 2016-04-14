From: Nicolas Boichat <drinkcat@chromium.org>
Subject: INFO: inconsistent lock state in ecryptfs_calculate_md5
Date: Thu, 14 Apr 2016 22:03:48 +0800
Message-ID: <CANMq1KBeZrH6Mvm=gy1BEnMthGpGb21udPrvsbxuu1D8DWkk6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org
To: ecryptfs@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <ecryptfs-owner@vger.kernel.org>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

We've run into the following lockdep warning while using a system with
ecryptfs, under heavy memory pressure.

If I understand the issue correctly,
fs/ecryptfs/crypto.c:ecryptfs_calculate_md5:
 - Locks &crypt_stat->cs_hash_tfm_mutex
 -> Calls crypto_alloc_hash
   -> Calls crypto_alloc_base
      ->  __crypto_alloc_tfm
        -> kzalloc(tfm_size, GFP_KERNEL)
           -> Which, under memory pressure, may attempt to flush
pages, which would reenter ecryptfs_calculate_md5, try to lock the
mutex again, and cause a deadlock.

This is a 3.18-based kernel, and this upstream commit:
3095e8e366b471f3bcdbf21c9c72a45718ff8756 "eCryptfs: Use skcipher and
shash" gets rid of the call to crypto_alloc_hash, and instead calls
crypto_alloc_shash, but it looks like there is a similar issue there
(another kmalloc with GFP_KERNEL).

I wonder if we should release the mutex during the alloc call, or if
there is another better way to fix this (this should be a fairly
common filesystem issue, I imagine?).

Suggestions and patches welcome.

Best,

Nicolas

[ 1291.295366] =================================
[ 1291.299679] [ INFO: inconsistent lock state ]
[ 1291.303997] 3.18.0 #234 Not tainted
[ 1291.307449] ---------------------------------
[ 1291.311764] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 1291.318234] kswapd0/62 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 1291.323238]  (&crypt_stat->cs_hash_tfm_mutex){+.+.?.}, at:
[<ffffffc00041bf90>] ecryptfs_calculate_md5+0x58/0x170
[ 1291.333437] {RECLAIM_FS-ON-W} state was registered at:
[ 1291.338526]   [<ffffffc00026da9c>] mark_lock+0x2dc/0x6a8
[ 1291.343796]   [<ffffffc00026df04>] mark_held_locks+0x9c/0xc4
[ 1291.349407]   [<ffffffc000270de4>] lockdep_trace_alloc+0xc4/0xd8
[ 1291.355366]   [<ffffffc000338bcc>] __kmalloc+0x90/0x278
[ 1291.360551]   [<ffffffc000442fc0>] __crypto_alloc_tfm+0x98/0x184
[ 1291.366507]   [<ffffffc000443108>] crypto_alloc_base+0x5c/0xa8
[ 1291.372289]   [<ffffffc00041bfbc>] ecryptfs_calculate_md5+0x84/0x170
[ 1291.378590]   [<ffffffc00041d368>] ecryptfs_compute_root_iv+0xbc/0x13c
[ 1291.385063]   [<ffffffc00041d558>] ecryptfs_new_file_context+0x170/0x1f8
[ 1291.391709]   [<ffffffc000419dac>] ecryptfs_initialize_file+0x74/0x108
[ 1291.398181]   [<ffffffc000419f58>] ecryptfs_create+0x118/0x17c
[ 1291.403964]   [<ffffffc00035082c>] vfs_create+0x98/0xe4
[ 1291.409144]   [<ffffffc000350dd4>] do_last.isra.30+0x55c/0xb04
[ 1291.414928]   [<ffffffc000351938>] path_openat+0x5bc/0x60c
[ 1291.420368]   [<ffffffc000352954>] do_filp_open+0x4c/0xb8
[ 1291.425722]   [<ffffffc0003416ec>] do_sys_open+0x180/0x2e8
[ 1291.431161]   [<ffffffc000392738>] compat_SyS_open+0x34/0x48
[ 1291.436773]   [<ffffffc000205470>] el0_svc_naked+0x20/0x28
[ 1291.442214] irq event stamp: 4500643
[ 1291.445753] hardirqs last  enabled at (4500643):
[<ffffffc0002fa398>] get_page_from_freelist+0x400/0x5f0
[ 1291.455158] hardirqs last disabled at (4500642):
[<ffffffc0002fa104>] get_page_from_freelist+0x16c/0x5f0
[ 1291.464560] softirqs last  enabled at (4498536):
[<ffffffc000228560>] __do_softirq+0x38c/0x428
[ 1291.473103] softirqs last disabled at (4498531):
[<ffffffc000228900>] irq_exit+0x7c/0xd8
[ 1291.481127]
[ 1291.481127] other info that might help us debug this:
[ 1291.487596]  Possible unsafe locking scenario:
[ 1291.487596]
[ 1291.493462]        CPU0
[ 1291.495880]        ----
[ 1291.498298]   lock(&crypt_stat->cs_hash_tfm_mutex);
[ 1291.503137]   <Interrupt>
[ 1291.505727]     lock(&crypt_stat->cs_hash_tfm_mutex);
[ 1291.510737]
[ 1291.510737]  *** DEADLOCK ***
[ 1291.510737]
[ 1291.516603] no locks held by kswapd0/62.
[ 1291.520486]
[ 1291.520486] stack backtrace:
[ 1291.524803] CPU: 2 PID: 62 Comm: kswapd0 Not tainted 3.18.0 #234
[ 1291.535932] Call trace:
[ 1291.538353] [<ffffffc000209ed8>] dump_backtrace+0x0/0x140
[ 1291.543703] [<ffffffc00020a034>] show_stack+0x1c/0x28
[ 1291.548709] [<ffffffc0008a45c8>] dump_stack+0x80/0xc4
[ 1291.553713] [<ffffffc0008a36c4>] print_usage_bug.part.35+0x270/0x28c
[ 1291.560010] [<ffffffc00026dc0c>] mark_lock+0x44c/0x6a8
[ 1291.565100] [<ffffffc00026ecf0>] __lock_acquire+0x920/0x19a8
[ 1291.570707] [<ffffffc0002705f4>] lock_acquire+0x138/0x188
[ 1291.576057] [<ffffffc0008a7df0>] mutex_lock_nested+0x8c/0x3fc
[ 1291.581751] [<ffffffc00041bf8c>] ecryptfs_calculate_md5+0x54/0x170
[ 1291.587876] [<ffffffc00041c890>] ecryptfs_derive_iv+0xec/0x184
[ 1291.593656] [<ffffffc00041c99c>] crypt_extent+0x74/0x1b0
[ 1291.598919] [<ffffffc00041cebc>] ecryptfs_encrypt_page+0xdc/0x1c8
[ 1291.604958] [<ffffffc00041b174>] ecryptfs_writepage+0x1c/0x7c
[ 1291.610653] [<ffffffc0003053cc>] shrink_page_list+0x578/0x978
[ 1291.616346] [<ffffffc000305ddc>] shrink_inactive_list+0x264/0x4e8
[ 1291.622384] [<ffffffc00030679c>] shrink_lruvec+0x3ec/0x5a4
[ 1291.627820] [<ffffffc0003069ac>] shrink_zone+0x58/0x118
[ 1291.632997] [<ffffffc000307310>] balance_pgdat+0x300/0x550
[ 1291.638432] [<ffffffc0003079d4>] kswapd+0x474/0x51c
[ 1291.643264] [<ffffffc0002437c0>] kthread+0xf0/0xfc
