From: Stephan Mueller <smueller@chronox.de>
Subject: BUG while working on algif_skcipher AIO support
Date: Thu, 08 Sep 2016 04:23:07 +0200
Message-ID: <8008966.Q0OrxOpoA1@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37416 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752176AbcIHCXS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 22:23:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

here is a reliably producable bug that I triggered while educating my libkcapi 
about AIO support.



[70129.671557] page:ffffea0001361d80 count:0 mapcount:0 mapping:          
(null) index:0x0
[70129.671560] flags: 0x1ffffc00000000()
[70129.671562] page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
[70129.671581] ------------[ cut here ]------------
[70129.671599] kernel BUG at include/linux/mm.h:420!
[70129.671612] invalid opcode: 0000 [#2] SMP
[70129.671623] Modules linked in: serpent_avx2 serpent_avx_x86_64 
serpent_sse2_x86_64 serpent_generic loop crypto_user vhost_net vhost macvtap 
macvlan rfcomm xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun 
ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter xt_conntrack ip_set nfnetlink 
ebtable_nat ebtable_broute bridge stp llc ip6table_security ip6table_mangle 
ip6table_raw ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 
iptable_security iptable_mangle iptable_raw iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ebtable_filter ebtables 
ip6table_filter ip6_tables bnep nls_utf8 hfsplus intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel brcmfmac kvm joydev 
iTCO_wdt iTCO_vendor_support applesmc irqbypass input_polldev brcmutil 
intel_cstate intel_uncore cfg80211
[70129.671875]  btusb intel_rapl_perf snd_hda_codec_hdmi snd_hda_codec_cirrus 
snd_hda_codec_generic btrtl btbcm snd_hda_intel snd_hda_codec btintel 
bluetooth snd_hda_core snd_hwdep mmc_core snd_seq i2c_i801 intel_pch_thermal 
snd_seq_device thunderbolt snd_pcm rfkill bcm5974 snd_timer mei_me snd lpc_ich 
mei shpchp dw_dmac_pci soundcore spi_pxa2xx_pci acpi_als kfifo_buf 
industrialio spi_pxa2xx_platform sbs apple_bl tpm_tis sbshc tpm nfsd 
auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc dm_crypt hid_apple i915 
crct10dif_pclmul crc32_pclmul crc32c_intel i2c_algo_bit drm_kms_helper uas 
usb_storage ghash_clmulni_intel drm fjes video
[70129.672075] CPU: 2 PID: 24751 Comm: kcapi Tainted: G      D         
4.7.2-201.fc24.x86_64 #1
[70129.672095] Hardware name: Apple Inc. MacBookPro12,1/Mac-E43C1C25D4880AD6, 
BIOS MBP121.88Z.0167.B17.1606231721 06/23/2016
[70129.672120] task: ffff8801f2f53d00 ti: ffff88004f5c4000 task.ti: 
ffff88004f5c4000
[70129.672138] RIP: 0010:[<ffffffff81398811>]  [<ffffffff81398811>] 
skcipher_pull_sgl+0x171/0x180
[70129.672163] RSP: 0018:ffff88004f5c7d38  EFLAGS: 00010246
[70129.672176] RAX: 000000000000003e RBX: ffff880228ae1018 RCX: 
0000000000000006
[70129.672193] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff88046ec8e060
[70129.672210] RBP: ffff88004f5c7d80 R08: 0000000000000922 R09: 
0000000000000005
[70129.672227] R10: ffff8803fc90efb0 R11: ffffffff81f3edad R12: 
0000000000000001
[70129.672244] R13: 0000000000000000 R14: 0000000000000000 R15: 
ffff88044a671800
[70129.672262] FS:  00007f99962aa700(0000) GS:ffff88046ec80000(0000) knlGS:
0000000000000000
[70129.672281] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[70129.672296] CR2: 000000000170e1d8 CR3: 00000000250b0000 CR4: 
00000000003406e0
[70129.672313] Stack:
[70129.672318]  ffff88044a677800 ffff8803fc90e1d0 ffff8803fc90e0b0 
ffff8803fc90e1d0
[70129.672340]  ffff88044a677ac8 ffff88044a671800 ffff88044a677800 
ffff88044a4a6ba8
[70129.672361]  ffff88020f5ae900 ffff88004f5c7db0 ffffffff8139889a 
ffff88044a677ac8
[70129.672382] Call Trace:
[70129.672390]  [<ffffffff8139889a>] skcipher_sock_destruct+0x7a/0xc0
[70129.672406]  [<ffffffff816b2746>] __sk_destruct+0x26/0x140
[70129.672420]  [<ffffffff816b42a0>] sk_destruct+0x20/0x30
[70129.672434]  [<ffffffff816b42f3>] __sk_free+0x43/0xa0
[70129.672447]  [<ffffffff816b4368>] sk_free+0x18/0x20
[70129.672460]  [<ffffffff81397963>] af_alg_release+0x23/0x30
[70129.672474]  [<ffffffff816ad79f>] sock_release+0x1f/0x80
[70129.672488]  [<ffffffff816ad812>] sock_close+0x12/0x20
[70129.672502]  [<ffffffff812481df>] __fput+0xdf/0x1f0
[70129.672514]  [<ffffffff8124832e>] ____fput+0xe/0x10
[70129.672527]  [<ffffffff810bd923>] task_work_run+0x83/0xb0
[70129.672542]  [<ffffffff81003342>] exit_to_usermode_loop+0xc2/0xd0
[70129.672557]  [<ffffffff81003ce1>] syscall_return_slowpath+0xa1/0xb0
[70129.672574]  [<ffffffff817eb8fa>] entry_SYSCALL_64_fastpath+0xa2/0xa4
[70129.672589] Code: 00 00 00 75 08 41 c6 87 fd 02 00 00 00 48 83 c4 20 5b 41 
5c 41 5d 41 5e 41 5f 5d c3 48 c7 c6 68 46 a1 81 48 89 c7 e8 1f e7 e4 ff <0f> 
0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[70129.672692] RIP  [<ffffffff81398811>] skcipher_pull_sgl+0x171/0x180
[70129.672709]  RSP <ffff88004f5c7d38>
[70129.672726] ---[ end trace e16e0f71a7a79252 ]---

Ciao
Stephan
