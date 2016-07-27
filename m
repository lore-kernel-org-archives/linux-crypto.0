From: Nicolai Stange <nicstange@gmail.com>
Subject: lib/mpi: BUG: sleeping function called from invalid context on next-20160726
Date: Wed, 27 Jul 2016 23:05:05 +0200
Message-ID: <87d1lyiygu.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: Nicolai Stange <nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

with linux-next-20160726, I get this:

 BUG: sleeping function called from invalid context at /mnt/scratch/nic/linux-next/mm/slab.h:388
 in_atomic(): 1, irqs_disabled(): 0, pid: 369, name: systemd-udevd
 no locks held by systemd-udevd/369.
 CPU: 2 PID: 369 Comm: systemd-udevd Not tainted 4.7.0-rc1+ #248
 Hardware name: Dell Inc. Latitude E6540/0725FP, BIOS A10 06/26/2014
  0000000000000286 00000000899a9b52 ffff88003f53b8f8 ffffffff814472d5
  ffff8800c0752680 ffffffff81c557d8 ffff88003f53b920 ffffffff810dfba9
  ffffffff81c557d8 0000000000000184 0000000000000000 ffff88003f53b948
 Call Trace:
  [<ffffffff814472d5>] dump_stack+0x86/0xc1
  [<ffffffff810dfba9>] ___might_sleep+0x179/0x230
  [<ffffffff810dfca9>] __might_sleep+0x49/0x80
  [<ffffffff8125f1f1>] kmem_cache_alloc_trace+0x1d1/0x2e0
  [<ffffffff81479b20>] ? mpi_alloc+0x20/0x80
  [<ffffffff81479b20>] mpi_alloc+0x20/0x80
  [<ffffffff81477475>] mpi_read_raw_from_sgl+0xd5/0x1e0
  [<ffffffff813e99f6>] rsa_verify+0x66/0x100
  [<ffffffff813ea1be>] pkcs1pad_verify+0xae/0xf0
  [<ffffffff81404889>] public_key_verify_signature+0x1f9/0x290
  [<ffffffff81404935>] public_key_verify_signature_2+0x15/0x20
  [<ffffffff8140458c>] verify_signature+0x3c/0x50
  [<ffffffff8140680d>] pkcs7_validate_trust+0x11d/0x230
  [<ffffffff811eb132>] verify_pkcs7_signature+0xa2/0x150
  [<ffffffff8115747d>] mod_verify_sig+0xdd/0x130
  [<ffffffff811541cc>] load_module+0x16c/0x2970
  [<ffffffff8128b95b>] ? vfs_read+0x11b/0x130
  [<ffffffff81292342>] ? kernel_read_file+0x152/0x170
  [<ffffffff81156c66>] SYSC_finit_module+0xe6/0x120
  [<ffffffff81156cbe>] SyS_finit_module+0xe/0x10
  [<ffffffff81003fe7>] do_syscall_64+0x67/0x190
  [<ffffffff8189ab3f>] entry_SYSCALL64_slow_path+0x25/0x25



Reason is 127827b9c295 ("lib/mpi: Do not do sg_virt") which makes
mpi_read_raw_from_sgl() calling mpi_alloc() while having a sg entry
mapped via kmap_atomic() and thus, preemption disabled.

I would have sent a patch, but there is another point which puzzles me
in mpi_read_raw_from_sgl():

  [...]
  const u8 *buff;
  [...]
  sg_miter_start(&miter, sgl, ents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);

  lzeros = 0;
  len = 0;
  while (nbytes > 0) {
  	while (len && !*buff) {
  		lzeros++;
  		len--;
  		buff++;
  	}


Thus, buff isn't initialized before its first use? Or am I misreading
something here?

Thanks,

Nicolai
