From: garkein@mailueberfall.de
Subject: General Protection Fault in aesni_cbc_dec in kernel 3.3
Date: Tue, 08 May 2012 21:08:14 +0200
Message-ID: <1336504094.4142.4.camel@thinkpad>
Reply-To: garkein@mailueberfall.de
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: garkein@mailueberfall.de
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:54781 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755354Ab2EHTIR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 May 2012 15:08:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

when using a VPN connection, my 3.3.4 and 3.3.5 kernel oopses in the
aesni_intel module. 


[  157.571310] general protection fault: 0000 [#1] SMP 
[  157.571411] Modules linked in: authenc esp4 xfrm4_mode_tunnel tun
deflate zlib_deflate ctr acpi_cpufreq mperf twofish_generic twofish_i586
twofish_common camellia cpufreq_conservative serpent_generic
cpufreq_stats blowfish_generic blowfish_common cpufreq_userspace cast5
cpufreq_powersave des_generic xcbc rmd160 sha512_generic sha1_generic
hmac crypto_null af_key parport_pc ppdev lp parport rfcomm bnep
binfmt_misc uinput fuse ip6t_LOG ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables ipt_LOG xt_recent ipt_REJECT
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
iptable_filter ip_tables x_tables nfsd exportfs nfs nfs_acl auth_rpcgss
fscache lockd sunrpc ext2 loop btusb snd_hda_codec_hdmi arc4 bluetooth
snd_hda_codec_conexant iwlwifi i915 snd_hda_intel mac80211 joydev
drm_kms_helper snd_hda_codec snd_hwdep drm snd_pcm snd_page_alloc
thinkpad_acpi ehci_hcd i2c_i801 nvram e1000e xhci_hcd snd_seq
snd_seq_device snd_timer cfg80211 sdhci_pci sdhci mmc_core i2c_algo_bit
i2c_core iTCO_wdt iTCO_vendor_support snd usbcore battery ac soundcore
wmi evdev rfkill usb_common psmouse power_supply serio_raw pcspkr
tpm_tis tpm tpm_bios processor button video ext4 crc16 jbd2 mbcache
sha256_generic aesni_intel cryptd aes_i586 aes_generic cbc dm_crypt
dm_mod sd_mod crc_t10dif ahci libahci libata scsi_mod thermal
thermal_sys
[  157.573825] 
[  157.573855] Pid: 0, comm: swapper/0 Not tainted 3.3.4 #21 LENOVO
4287CTO/4287CTO
[  157.573985] EIP: 0060:[<f83768c0>] EFLAGS: 00010286 CPU: 0
[  157.574083] EIP is at aesni_cbc_dec+0x5c/0xbc [aesni_intel]
[  157.574172] EAX: f023409e EBX: 00000020 ECX: f403bd90 EDX: f023409e
[  157.574269] ESI: 00000040 EDI: f403bd20 EBP: f023408e ESP: f400fbec
[  157.574367]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  157.574454] Process swapper/0 (pid: 0, ti=f400e000 task=c13d0fe0
task.ti=c13ca000)
[  157.574570] Stack:
[  157.574604]  f400fc6c f400fc18 f403bc30 00000040 f8376e12 f403bc30
f023409e f023409e
[  157.574761]  00000040 f023408e 00000000 f4d14680 f023409e f4d14680
f023409e f026edfc
[  157.574917]  0000009e 00000040 f026edfc 0000009e 00000040 00000000
00000000 f023408e
[  157.575074] Call Trace:
[  157.575133]  [<f8376e12>] ? cbc_decrypt+0x5a/0x86 [aesni_intel]
[  157.575240]  [<f8376b1f>] ? ablk_decrypt+0x5d/0x66 [aesni_intel]
[  157.575337]  [<f93da1ff>] ? esp_input_done2+0x152/0x152 [esp4]
[  157.575432]  [<f94548f7>] ? crypto_authenc_decrypt+0x1c5/0x1e4
[authenc]
[  157.575539]  [<f93daba9>] ? esp_input+0x1f7/0x21a [esp4]
[  157.575632]  [<c126fa4d>] ? xfrm_input+0x1b4/0x391
[  157.575711]  [<c12549d7>] ? __udp4_lib_lookup+0x174/0x193
[  157.575802]  [<c12688f3>] ? xfrm4_udp_encap_rcv+0x12a/0x143
[  157.575892]  [<c1254beb>] ? udp_queue_rcv_skb+0x42/0x1bd
[  157.575978]  [<c12551f3>] ? __udp4_lib_rcv+0x299/0x40e
[  157.576063]  [<c1237ac8>] ? xfrm4_policy_check.constprop.11+0x45/0x45
[  157.576166]  [<c1237bc5>] ? ip_local_deliver_finish+0xfd/0x199
[  157.576260]  [<c1237ac8>] ? xfrm4_policy_check.constprop.11+0x45/0x45
[  157.576363]  [<c1237a80>] ? NF_HOOK.constprop.10+0x36/0x39
[  157.576451]  [<c1237d5a>] ? ip_local_deliver+0x39/0x3c
[  157.576534]  [<c1237ac8>] ? xfrm4_policy_check.constprop.11+0x45/0x45
[  157.576637]  [<c1237a2c>] ? ip_rcv_finish+0x2c4/0x2e2
[  157.576718]  [<c1237768>] ? inet_del_protocol+0x24/0x24
[  157.576802]  [<c1237a80>] ? NF_HOOK.constprop.10+0x36/0x39
[  157.576891]  [<c121654d>] ? __netif_receive_skb+0x331/0x36d
[  157.576980]  [<c1237768>] ? inet_del_protocol+0x24/0x24
[  157.577066]  [<c121733d>] ? netif_receive_skb+0x66/0x6b
[  157.577181]  [<f8874c90>] ? ieee80211_deliver_skb+0xa6/0xd9
[mac80211]
[  157.577307]  [<f8875e8e>] ? ieee80211_rx_handlers+0xf21/0x183c
[mac80211]
[  157.577418]  [<c1030d45>] ? _local_bh_enable_ip.isra.9+0x15/0x6d
[  157.581963]  [<c1064449>] ? arch_local_irq_save+0xf/0x14
[  157.586407]  [<c12b9a8b>] ? _raw_spin_lock_irqsave+0x8/0x21
[  157.590692]  [<f8876f0b>] ? ieee80211_prepare_and_rx_handle
+0x762/0x7ad [mac80211]
[  157.594887]  [<f88775cf>] ? ieee80211_rx+0x679/0x697 [mac80211]
[  157.598906]  [<f890e169>] ? iwlagn_rx_reply_rx+0x678/0x68d [iwlwifi]
[  157.602776]  [<c10c51ba>] ? kfree+0x9c/0xa3
[  157.606477]  [<c10c51ba>] ? kfree+0x9c/0xa3
[  157.610004]  [<f890e4b5>] ? iwl_rx_dispatch+0x12c/0x193 [iwlwifi]
[  157.613407]  [<f8919c20>] ? iwl_irq_tasklet+0x625/0x8d5 [iwlwifi]
[  157.616645]  [<c1064449>] ? arch_local_irq_save+0xf/0x14
[  157.619913]  [<c103080b>] ? tasklet_action+0x62/0xa5
[  157.623464]  [<c1030da1>] ? local_bh_enable+0x2/0x2
[  157.626658]  [<c1030e35>] ? __do_softirq+0x94/0x12f
[  157.629806]  [<c1030da1>] ? local_bh_enable+0x2/0x2
[  157.632933]  <IRQ> 
[  157.636025]  [<c1031026>] ? irq_exit+0x32/0x7d
[  157.639134]  [<c100cfd8>] ? do_IRQ+0x65/0x76
[  157.642204]  [<c12bf570>] ? common_interrupt+0x30/0x38
[  157.645226]  [<c105007b>] ? load_balance+0x487/0x504
[  157.648221]  [<f86b422c>] ? arch_local_irq_enable+0x2/0x7 [processor]
[  157.651240]  [<f86b4caa>] ? acpi_idle_enter_bm+0x23a/0x27a
[processor]
[  157.654235]  [<c1204734>] ? menu_select+0x1ae/0x356
[  157.657195]  [<c1203abd>] ? cpuidle_idle_call+0xcc/0x142
[  157.660131]  [<c100b255>] ? cpu_idle+0x8b/0xb4
[  157.663062]  [<c140a6e5>] ? start_kernel+0x316/0x31b
[  157.665956] Code: 83 fe 40 72 5a 66 90 0f 10 0a 0f 28 c1 0f 10 7a 10
0f 28 e7 0f 10 4a 20 0f 28 e9 0f 10 7a 30 0f 28 f7 e8 d8 fc ff ff 66 0f
ef c3 <66> 0f ef 22 66 0f ef 6a 10 66 0f ef f1 0f 28 df 0f 11 00 0f 11 
[  157.672635] EIP: [<f83768c0>] aesni_cbc_dec+0x5c/0xbc [aesni_intel]
SS:ESP 0068:f400fbec


Is this a known issue? Apart from this bug in Ubuntu
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/980155
I found no other reference.


Best regards,
Daniel
