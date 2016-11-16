From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: BUG: algif_hash crash with extra recv() in 4.9-rc5
Date: Wed, 16 Nov 2016 11:17:33 -0800 (PST)
Message-ID: <alpine.OSX.2.20.1611161027010.67352@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39670 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932382AbcKPTRf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 14:17:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Herbert -

Following commit 493b2ed3f7603a15ff738553384d5a4510ffeb95, there is a NULL 
dereference crash in algif_hash when recv() is called twice like this:

send(sk, data, len, MSG_MORE);
recv(sk, hash1, len, 0);
recv(sk, hash2, len, 0);

In 4.8 and earlier, the two recvs return identical data. In 4.9-rc5, the 
second recv triggers this:

[   53.041287] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[   53.042048] IP: [<ffffffffa73fdfb3>] shash_ahash_digest+0x23/0x130

(shash_ahash_digest+0x23 corresponds to the second line of the function, 
which accesses sg->offset)

[   53.042572] PGD 131f74067 [   53.042796] PUD 13140f067
PMD 0 [   53.043093] 
[   53.043236] Oops: 0000 [#1] SMP
[   53.043511] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_raw ip6table_security ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle iptable_raw iptable_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_generic snd_hda_intel snd_hda_codec crct10dif_pclmul crc32_pclmul snd_hda_core ghash_clmulni_intel snd_hwdep snd_seq ppdev snd_seq_device snd_pcm joydev snd_timer virtio_balloon snd pcspkr acpi_cpufreq tpm_tis parport_pc parport tpm_tis_core tpm i2c_piix4 soundcore qemu_fw_cfg nfsd auth_rpcgss nfs_acl lockd grace sunrpc virtio_net virtio_blk virtio_console qxl
  drm_kms_helper ttm ata_generic crc32c_intel drm virtio_pci serio_raw floppy virtio_ring pata_acpi virtio
[   53.050799] CPU: 0 PID: 1069 Comm: test-checksum Not tainted 4.9.0-rc5+ #75
[   53.051393] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[   53.052131] task: ffff8d2d72430000 task.stack: ffff95b280fe4000
[   53.052622] RIP: 0010:[<ffffffffa73fdfb3>]  [<ffffffffa73fdfb3>] shash_ahash_digest+0x23/0x130
[   53.053363] RSP: 0018:ffff95b280fe7d40  EFLAGS: 00010246
[   53.053827] RAX: 0000000000001000 RBX: ffff8d2d71c8bbf8 RCX: 0000000000000000
[   53.054424] RDX: 0000000000000000 RSI: ffff8d2d71c8bbf8 RDI: ffff8d2d71c8bba8
[   53.055014] RBP: ffff95b280fe7d60 R08: 00000000001ddb00 R09: ffff8d2d71f03810
[   53.055603] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa73fe0c0
[   53.056210] R13: ffff8d2d71c8bba8 R14: ffff95b280fe7e30 R15: 0000000000000000
[   53.056822] FS:  00007f91f1138700(0000) GS:ffff8d2d7b200000(0000) knlGS:0000000000000000
[   53.057502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.058004] CR2: 0000000000000010 CR3: 000000013149e000 CR4: 00000000003406f0
[   53.058616] Stack:
[   53.058796]  ffff8d2d71c8bba8 ffffffffa73fe0c0 ffff8d2d71c8d000 ffff95b280fe7e30
[   53.059473]  ffff95b280fe7d70 ffffffffa73fe0e4 ffff95b280fe7d98 ffffffffa73fd4c9
[   53.060153]  ffff8d2d71c8b800 ffff8d2d71c8b800 0000000000000010 ffff95b280fe7da8
[   53.060831] Call Trace:
[   53.061051]  [<ffffffffa73fe0c0>] ? shash_ahash_digest+0x130/0x130
[   53.061601]  [<ffffffffa73fe0e4>] shash_async_digest+0x24/0x30
[   53.062119]  [<ffffffffa73fd4c9>] crypto_ahash_op+0x29/0x70
[   53.062621]  [<ffffffffa73fd566>] crypto_ahash_digest+0x16/0x20
[   53.063149]  [<ffffffffa7415519>] hash_recvmsg+0x1a9/0x1d0
[   53.063655]  [<ffffffffa777180d>] sock_recvmsg+0x3d/0x50
[   53.064129]  [<ffffffffa7771a4d>] SYSC_recvfrom+0xdd/0x160
[   53.064786]  [<ffffffffa70d3339>] ? task_work_run+0x99/0xc0
[   53.065501]  [<ffffffffa710db55>] ? trace_hardirqs_on_caller+0xf5/0x1b0
[   53.066313]  [<ffffffffa700301a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
[   53.067069]  [<ffffffffa777318e>] SyS_recvfrom+0xe/0x10
[   53.067706]  [<ffffffffa78f1101>] entry_SYSCALL_64_fastpath+0x1f/0xc2
[   53.068476] Code: 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 b8 00 10 00 00 48 89 e5 41 56 41 55 41 54 53 49 89 fd 48 8b 4f 38 41 8b 55 30 48 89 f3 <8b> 79 10 29 f8 39 41 14 0f 46 41 14 39 c2 72 3a 48 8b 06 48 89 
[   53.071995] RIP  [<ffffffffa73fdfb3>] shash_ahash_digest+0x23/0x130
[   53.072800]  RSP <ffff95b280fe7d40>
[   53.073259] CR2: 0000000000000010
[   53.073700] ---[ end trace 6249058719c9daea ]---

If I revert 493b2ed3f7603a15ff738553384d5a4510ffeb95, there is no crash.


Regards,

--
Mat Martineau
Intel OTC
