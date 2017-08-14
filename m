From: "Plauth, Max" <Max.Plauth@hpi.de>
Subject: scatterwalk.c: Nullpointer dereference
Date: Mon, 14 Aug 2017 12:25:49 +0000
Message-ID: <1415BA6E-28BB-4AA6-8049-1FB19FE3BBE1@hpi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3.hpi.uni-potsdam.de ([141.89.225.123]:33889 "EHLO
        mail3.hpi.uni-potsdam.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753041AbdHNMZv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 08:25:51 -0400
Received: from MX2015-DAG1.hpi.uni-potsdam.de (unknown [192.168.32.2])
        by mail3.hpi.uni-potsdam.de (Postfix) with ESMTPS id D1891804D3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2017 14:25:49 +0200 (CEST)
Content-Language: en-US
Content-ID: <E52A32CCDB21B84683D01D23E7ECDDBC@hpi.uni-potsdam.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear linux-crypto community,

I think I might have run into a bug in crypto/scatterwalk.c:
- at the end of scatterwalk_pagedone, sg_next(walk->sg) is fed as an argument to scatterwalk_start(...)
- sg_next (lib/scatterlist.c) returns NULL in the case of sg_is_last(sg)
- In this case, NULL is being fed into scatterwalk_start
- there, a NULL value of *sg leads to a NULL pointer dereference:
walk->sg = sg;
walk->offset = sg->offset;

I stumbled across this issue when I tried to extend the cryptodev-linux Kernel module with support for compression algorithms (https://github.com/plauth/cryptodev-linux).

Best regards,
Max

-----------
Test environment:
Ubuntu Linux 16.04.3 LTS
Platform: x86_64 / amd64
Kernel: 4.10.0-28-generic (also tested with a 4.12.7)
Forked version of the cryptodev-linux kernel module (https://github.com/plauth/cryptodev-linux)
Test application: examples/lzo.c

The lzo.c example will induce the following Oops stacktrace:
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234888] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234918] IP: scatterwalk_copychunks+0x137/0x1e0
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234930] PGD 1b4559067 
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234931] PUD 223766067 
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234938] PMD 0 
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234945] 
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234956] Oops: 0000 [#1] SMP
Aug 14 14:09:13 plauth-ws kernel: [ 2198.234965] Modules linked in: cryptodev(OE) input_leds dcdbas intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd intel_cstate intel_rapl_perf snd_hda_codec_realtek snd_hda_codec_generic lpc_ich snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hda_core mei_me snd_hwdep mei snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd mac_hid soundcore shpchp parport_pc ppdev lp parport autofs4 hid_generic usbhid hid amdgpu amdkfd amd_iommu_v2 radeon i915 ttm i2c_algo_bit drm_kms_helper syscopyarea ahci sysfillrect sysimgblt e1000e libahci fb_sys_fops drm ptp pps_core fjes video
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235117] CPU: 3 PID: 2860 Comm: lzo Tainted: G           OE   4.10.0-28-generic #32~16.04.2-Ubuntu
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235118] Hardware name: Dell Inc. OptiPlex 9020/06X1TJ, BIOS A09 11/20/2014
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235118] task: ffff9ceae48e2d00 task.stack: ffffb25888f28000
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235120] RIP: 0010:scatterwalk_copychunks+0x137/0x1e0
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235120] RSP: 0018:ffffb25888f2bad0 EFLAGS: 00010246
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235121] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000ccb
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235121] RDX: ffff9ceae48e2d00 RSI: 0000000000000ccb RDI: ffff9ceae2617020
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235121] RBP: ffffb25888f2bb10 R08: 000000000000002b R09: 000000000000002b
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235122] R10: 0000000000000000 R11: ffffb25881110000 R12: ffffb25888f2bb28
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235122] R13: ffffb2588119402b R14: ffff9ceae48e2d00 R15: 0000000000000001
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235123] FS:  00007f1317d13700(0000) GS:ffff9ceaeeb80000(0000) knlGS:0000000000000000
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235123] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235124] CR2: 0000000000000008 CR3: 000000021c985000 CR4: 00000000001406e0
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235124] Call Trace:
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235127]  scatterwalk_map_and_copy+0x6c/0x80
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235128]  ? lzo_scompress+0x3b/0x70
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235130]  scomp_acomp_comp_decomp+0xe2/0x230
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235132]  scomp_acomp_compress+0x13/0x20
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235135]  cryptodev_compr_compress+0x36/0xb0 [cryptodev]
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235136]  hash_n_crypt.isra.2+0xbe/0x1a0 [cryptodev]
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235137]  crypto_run+0x26c/0x640 [cryptodev]
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235138]  cryptodev_ioctl+0x290/0x620 [cryptodev]
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235141]  ? tty_insert_flip_string_fixed_flag+0x83/0xe0
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235142]  ? tty_flip_buffer_push+0x2b/0x30
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235144]  ? remove_wait_queue+0x4d/0x60
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235145]  ? __wake_up+0x44/0x50
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235146]  ? tty_ldisc_deref+0x16/0x20
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235149]  do_vfs_ioctl+0xa1/0x5f0
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235150]  ? vfs_write+0x15a/0x1b0
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235151]  SyS_ioctl+0x79/0x90
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235154]  entry_SYSCALL_64_fastpath+0x1e/0xad
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235155] RIP: 0033:0x7f131783ef07
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235156] RSP: 002b:00007ffc239a6b98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235156] RAX: ffffffffffffffda RBX: 00007f1317b06b20 RCX: 00007f131783ef07
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235157] RDX: 00007ffc239a6bd0 RSI: 00000000c0306368 RDI: 0000000000000003
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235157] RBP: 0000000000000410 R08: 5450595243434f49 R09: 75732064656e7275
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235157] R10: 0000000000000309 R11: 0000000000000246 R12: 0000000000000000
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235158] R13: 00007f1317b06b78 R14: 0000000000000000 R15: 0000000000000000
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235158] Code: 08 74 6f 49 8b 04 24 4d 01 cd 4c 29 cb 8b 70 0c 03 70 08 39 f1 0f 82 13 ff ff ff 48 89 c7 48 89 55 d0 e8 fd af 06 00 49 89 04 24 <8b> 48 08 48 8b 55 d0 41 89 4c 24 08 8b 70 0c 03 70 08 e9 ec fe 
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235169] RIP: scatterwalk_copychunks+0x137/0x1e0 RSP: ffffb25888f2bad0
Aug 14 14:09:13 plauth-ws kernel: [ 2198.235169] CR2: 0000000000000008
Aug 14 14:09:13 plauth-ws kernel: [ 2198.240683] ---[ end trace b010ee046092d64a ]---
