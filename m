From: Stephan Mueller <smueller@chronox.de>
Subject: BUG in recvmsg using io_submit
Date: Thu, 08 Sep 2016 04:52:08 +0200
Message-ID: <2637498.CLV37KecV5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37422 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756420AbcIHCwR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 22:52:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

another one, different than the first report



[71972.773115] page:ffffea0001fabf40 count:0 mapcount:0 mapping:          (null) index:0x0
[71972.773118] flags: 0x1ffffc00000000()
[71972.773119] page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
[71972.773140] ------------[ cut here ]------------
[71972.774961] kernel BUG at include/linux/mm.h:420!
[71972.776738] invalid opcode: 0000 [#4] SMP
[71972.778521] Modules linked in: serpent_avx2 serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic loop crypto_user vhost_net vhost macvtap macvlan rfcomm xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_security ip6table_mangle ip6table_raw ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 iptable_security iptable_mangle iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables bnep nls_utf8 hfsplus intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel brcmfmac kvm joydev iTCO_wdt iTCO_vendor_support applesmc irqbypass input_polldev brcmutil intel_cstate inte
 l_uncore cfg80211
[71972.782836]  btusb intel_rapl_perf snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic btrtl btbcm snd_hda_intel snd_hda_codec btintel bluetooth snd_hda_core snd_hwdep mmc_core snd_seq i2c_i801 intel_pch_thermal snd_seq_device thunderbolt snd_pcm rfkill bcm5974 snd_timer mei_me snd lpc_ich mei shpchp dw_dmac_pci soundcore spi_pxa2xx_pci acpi_als kfifo_buf industrialio spi_pxa2xx_platform sbs apple_bl tpm_tis sbshc tpm nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc dm_crypt hid_apple i915 crct10dif_pclmul crc32_pclmul crc32c_intel i2c_algo_bit drm_kms_helper uas usb_storage ghash_clmulni_intel drm fjes video
[71972.789497] CPU: 3 PID: 26006 Comm: kcapi Tainted: G      D         4.7.2-201.fc24.x86_64 #1
[71972.792255] Hardware name: Apple Inc. MacBookPro12,1/Mac-E43C1C25D4880AD6, BIOS MBP121.88Z.0167.B17.1606231721 06/23/2016
[71972.794492] task: ffff8803fe6e1e80 ti: ffff880046c40000 task.ti: ffff880046c40000
[71972.796679] RIP: 0010:[<ffffffff8139957e>]  [<ffffffff8139957e>] skcipher_free_async_sgls+0xde/0x120
[71972.798884] RSP: 0018:ffff880046c43bd8  EFLAGS: 00010246
[71972.801085] RAX: 000000000000003e RBX: ffffea0001fabf40 RCX: 0000000000000006
[71972.803300] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88046ecce060
[71972.805478] RBP: ffff880046c43c00 R08: 000000000000097d R09: 0000000000000005
[71972.807592] R10: ffff88041fcbccc0 R11: ffffffff81f3edad R12: 0000000000000000
[71972.809670] R13: ffff88041fcba000 R14: 0000000000000001 R15: ffff88041128cf40
[71972.811749] FS:  00007fd2fc61e700(0000) GS:ffff88046ecc0000(0000) knlGS:0000000000000000
[71972.813839] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[71972.815931] CR2: 00007fd2fc649000 CR3: 000000007ead7000 CR4: 00000000003406e0
[71972.817978] Stack:
[71972.819968]  ffff88022e035da8 0000000000000010 ffff88041fcba000 0000000000000000
[71972.822444]  0000000000000001 ffff880046c43ca0 ffffffff81399b07 ffff88041fcba3d8
[71972.825780]  ffff88041fcba2b0 ffff88041fcba008 0000000000000000 0000000000000000
[71972.828995] Call Trace:
[71972.832162]  [<ffffffff81399b07>] skcipher_recvmsg+0x547/0x720
[71972.834912]  [<ffffffff816ae640>] ? sock_recvmsg+0x50/0x50
[71972.837625]  [<ffffffff816ae62d>] sock_recvmsg+0x3d/0x50
[71972.840318]  [<ffffffff816ae6d0>] sock_read_iter+0x90/0xe0
[71972.842997]  [<ffffffff8129677b>] aio_run_iocb+0x12b/0x2d0
[71972.845696]  [<ffffffff812976c6>] ? do_io_submit+0x196/0x550
[71972.845698]  [<ffffffff81264b53>] ? __fdget+0x13/0x20
[71972.845699]  [<ffffffff812977c1>] do_io_submit+0x291/0x550
[71972.845701]  [<ffffffff81297a90>] SyS_io_submit+0x10/0x20
[71972.845703]  [<ffffffff817eb872>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[71972.845721] Code: 49 8b 1f 48 83 e3 fc 48 8b 43 20 48 8d 50 ff a8 01 48 0f 45 da 8b 43 1c 85 c0 75 bb 48 c7 c6 68 46 a1 81 48 89 df e8 b2 d9 e4 ff <0f> 0b 48 89 df e8 58 e4 e2 ff 48 8b 03 48 c1 e8 34 83 e0 07 83 
[71972.845724] RIP  [<ffffffff8139957e>] skcipher_free_async_sgls+0xde/0x120
[71972.845724]  RSP <ffff880046c43bd8>
[71972.845762] ---[ end trace e16e0f71a7a79254 ]---

Ciao
Stephan
