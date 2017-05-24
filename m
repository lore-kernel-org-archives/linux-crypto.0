From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [bug] sha1-avx2 and read beyond
Date: Wed, 24 May 2017 08:46:57 -0400 (EDT)
Message-ID: <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, ilya.albrekht@intel.com,
        maxim.locktyukhin@intel.com, ronen.zohar@intel.com,
        mouli@linux.intel.com, minipli@googlemail.com, hpa@linux.intel.com,
        marex@denx.de
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S940052AbdEXMrA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 08:47:00 -0400
In-Reply-To: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



----- Original Message -----
> Hi,
> 
> I'm seeing rare crashes during NFS cthon with krb5 auth. After
> some digging I arrived at potential problem with sha1-avx2.

Adding more sha1_avx2 experts to CC.

> 
> Problem appears to be that sha1_transform_avx2() reads beyond
> number of blocks you pass, if it is an odd number. It appears
> to try read one block more. This creates a problem if it falls
> beyond a page and there's nothing there.

As noted in my reply, worst case appears to be read ahead
of up to 3 SHA1 blocks beyond end of data:
  http://marc.info/?l=linux-crypto-vger&m=149373371023377

 +----------+---------+---------+---------+
 | 2*SHA1_BLOCK_SIZE  | 2*SHA1_BLOCK_SIZE |
 +----------+---------+---------+---------+
            ^ page boundary
    ^ data end

It is still reproducible with 4.12-rc2.

Regards,
Jan

> 
> To demonstrate this, I made a module which computes some hashes
> on module load. It allocates 3 pages, passes first two into
> crypto_shash_update() and marks 3rd one as not present.
> 
> When it runs for sha1-avx2, it runs into an Oops, trying to
> access 3rd page:
> 
> # git clone https://github.com/jstancek/sha1-avx2-crash.git
> # cd sha1-avx2-crash/
> # make
> # insmod sha1_test.ko
> 
> [  195.512669] sha1_test: loading out-of-tree module taints kernel.
> [  195.518716] sha1_test: module verification failed: signature and/or
> required key missing - tainting kernel
> [  195.529754] sha_test module loaded
> [  195.533732] data is at 0xffff97e232ea8000, datalen: 12288, start_offset:
> 3948, last_byte: 0xffff97e232ea9fff
> [  195.543529] page_after_data is at 0xffff97e232eaa000
> [  195.548603] starting test for sha1-generic
> [  195.552703] count: 148
> [  195.555073] starting test for sha1-ni
> [  195.561282] failed to alloc sha1-ni
> [  195.564776] starting test for sha1-avx
> [  195.568544] count: 148
> [  195.570908] starting test for sha1-avx2
> [  195.574751] count: 148
> [  195.577135] BUG: unable to handle kernel paging request at
> ffff97e232eaa000
> [  195.584081] IP: _begin+0x173/0x187
> [  195.587478] PGD 213e83067
> [  195.587478] PUD 1033622063
> [  195.590183] PMD 1033181063
> [  195.592974] PTE 8000001032eaa062
> [  195.595769]
> [  195.600487] Oops: 0000 [#1] SMP
> [  195.603627] Modules linked in: sha1_test(OE+) binfmt_misc intel_rapl
> skx_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp
> kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> vfat pcbc fat aesni_intel crypto_simd glue_helper cryptd ipmi_ss
> if ipmi_si iTCO_wdt ioatdma mei_me ipmi_devintf iTCO_vendor_support pcspkr
> joydev nfsd sg mei shpchp i2c_i801 dca lpc_ich wmi ipmi_msghand
> ler nfs_acl lockd tpm_crb nfit auth_rpcgss libnvdimm grace acpi_pad
> acpi_power_meter sunrpc ip_tables xfs libcrc32c sd_mod sr_mod cdrom as
> t i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
> ttm drm i40e ahci ptp libahci crc32c_intel libata pps_core i2c
> _core dm_mirror dm_region_hash dm_log dm_mod
> [  195.667322] CPU: 3 PID: 4725 Comm: insmod Tainted: G           OE
> 4.11.0-rc8 #1
> [  195.674782] Hardware name: Intel Corporation S2600WFD/S2600WFD, BIOS
> SE5C620.86B.01.00.0412.020920172159 02/09/2017
> [  195.685185] task: ffff97e22a7b3b00 task.stack: ffffa6f9a57e8000
> [  195.691092] RIP: 0010:_begin+0x173/0x187
> [  195.695005] RSP: 0018:ffffa6f9a57eb5d8 EFLAGS: 00010202
> [  195.700219] RAX: 0000000024a63b1a RBX: 00000000de142126 RCX:
> 00000000455ad007
> [  195.707336] RDX: 00000000325cbadf RSI: 000000002c3b9293 RDI:
> 000000009298ec68
> [  195.714451] RBP: 0000000045421007 R08: ffffffff9640a100 R09:
> ffff97d3771be9d0
> [  195.721567] R10: ffff97e232ea9f2c R11: ffff97e232eaa02c R12:
> 00000000531d8d12
> [  195.728683] R13: ffff97e232ea9f6c R14: ffffa6f9a57eb878 R15:
> ffffa6f9a57eb5d8
> [  195.735799] FS:  00007f675ac0c740(0000) GS:ffff97e23dac0000(0000)
> knlGS:0000000000000000
> [  195.743864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  195.749596] CR2: ffff97e232eaa000 CR3: 00000010394ec000 CR4:
> 00000000007406e0
> [  195.756713] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  195.763828] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [  195.770944] PKRU: 55555554
> [  195.773651] Call Trace:
> [  195.776105]  ? dequeue_entity+0xed/0x400
> [  195.780027]  ? console_unlock+0x475/0x4a0
> [  195.784027]  ? sha1_base_init+0x40/0x40
> [  195.787858]  ? sha1_apply_transform_avx2+0x1a/0x30
> [  195.792638]  ? sha1_update+0xd3/0x130
> [  195.796295]  ? sha1_avx2_update+0x15/0x20
> [  195.800301]  ? crypto_shash_update+0x47/0x120
> [  195.804650]  ? calc_hash.constprop.0+0xdc/0xff [sha1_test]
> [  195.810122]  ? sha1test_init+0x113/0x1000 [sha1_test]
> [  195.815163]  ? 0xffffffffc02b7000
> [  195.818473]  ? do_one_initcall+0x51/0x1b0
> [  195.822481]  ? __vunmap+0x85/0xd0
> [  195.825799]  ? kmem_cache_alloc_trace+0x14b/0x1b0
> [  195.830489]  ? kfree+0x133/0x180
> [  195.833716]  ? do_init_module+0x60/0x1fa
> [  195.837638]  ? load_module+0x162b/0x1b20
> [  195.841557]  ? __symbol_put+0x60/0x60
> [  195.845217]  ? ima_post_read_file+0x3d/0x80
> [  195.849397]  ? security_kernel_post_read_file+0x6b/0x80
> [  195.854616]  ? SYSC_finit_module+0xa6/0xf0
> [  195.858704]  ? SyS_finit_module+0xe/0x10
> [  195.862622]  ? do_syscall_64+0x67/0x180
> [  195.866450]  ? entry_SYSCALL64_slow_path+0x25/0x25
> [  195.871230] Code: d0 02 c4 c1 7a 6f 82 90 00 00 00 21 c8 31 e8 42 8d 3c 27
> 41 03 77 44 c4 e2 40 f2 e9 8d 34 06 c4 63 7b f0 e7 1b c4 e3
> 7b f0 c7 02 <c4> c3 7d 18 85 90 00 00 00 01 21 d7 31 ef 42 8d 34 26 eb 00 41
> [  195.890035] RIP: _begin+0x173/0x187 RSP: ffffa6f9a57eb5d8
> [  195.895423] CR2: ffff97e232eaa000
> [  195.898841] ---[ end trace ae28f02b9d28fb26 ]---
> [  195.905994] Kernel panic - not syncing: Fatal exception
> [  195.911412] Kernel Offset: 0x14c00000 from 0xffffffff81000000 (relocation
> range: 0xffffffff80000000-0xffffffffbfffffff)
> [  195.924685] Rebooting in 10 seconds..
> 
> Regards,
> Jan
> 
