From: =?ISO-8859-1?Q?Kormos_=27Morc=27_G=E1bor?= <morc@onionleaf.com>
Subject: Re: Bug?
Date: Thu, 22 Mar 2012 12:07:07 +0100
Message-ID: <4F6B07DB.2090207@onionleaf.com>
References: <4ECCBA5F.6090108@onionleaf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from budapest.baxter-it.com ([89.134.145.17]:55501 "EHLO
	budapest.baxter-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2CVLNI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Mar 2012 07:13:08 -0400
Received: from [192.168.9.8] (sysadmin.baxtersol.bit [192.168.9.8])
	by budapest.baxter-it.com (Postfix) with ESMTP id 48E8B258DD
	for <linux-crypto@vger.kernel.org>; Thu, 22 Mar 2012 12:07:11 +0100 (CET)
In-Reply-To: <4ECCBA5F.6090108@onionleaf.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

   Anyone cares to give me some feedback on this?

   Thanks,

   Morc.

Kormos 'Morc' G=E1bor wrote:
>   Hi Guys,
>
>   Sorry if I post this on the wrong list, but don't know who this=20
> belongs to and first time trying to post a kernel bug. Please direct=20
> me to the list it's appropriate on if it's not this or let me know if=
=20
> this may be an OpenSWAN bug and not a kernel.
>
>   So I run a few virtual machines on Windows 7 x64 on Intel Core=20
> i5-2500 CPU, now running with kernel 3.2.0-rc2 based on the Ubuntu=20
> 11.10 x86 kernel config file. I use OpenSWAN 2.6.28+dfsg-5ubuntu2 to=20
> build a VPN link between two nodes and those two nodes only, no=20
> subnets on either side and the moment I try to ping or connection fro=
m=20
> one server to the other kernel panics and CapsLock and ScrollLock LED=
s=20
> on keyboard start flashing and get the kernel trace below. I tried=20
> with the PCNet32 equivalent VMWare network card as well, without any=20
> difference. I'm running VMWare Workstation 8.0.1 build 528992. If you=
=20
> need more info let me know.
>
>   Please advise,
>
>   Gabor 'Morc' Kormos.
>
> [   35.219366] general protection fault: 0000 [#1] SMP
> [   35.221892] Modules linked in: authenc deflate zlib_deflate ctr=20
> camellia cast5 rmd160 crypto_null ccm serpent blowfish_generic=20
> blowfish_common twofish_generic twofish_i586 twofish_common xcbc=20
> sha512_generic des_generic aesni_intel cryptd aes_i586 xfrm_user ah6=20
> ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4 xfrm4_mode_tunnel=20
> xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_ro=20
> xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6 xfrm_ipcomp=20
> xfrm6_tunnel tunnel6 af_key xt_tcpudp xt_policy iptable_nat nf_nat=20
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_table=
s=20
> x_tables ppdev vmw_balloon psmouse serio_raw parport_pc i2c_piix4=20
> shpchp lp parport floppy e1000 mptspi mptscsih mptbase
> [   35.254720]
> [   35.255400] Pid: 0, comm: swapper Not tainted 3.2.0-rc2 #1 VMware,=
=20
> Inc. VMware Virtual Platform/440BX Desktop Reference Platform
> [   35.260348] EIP: 0060:[<e0a238c0>] EFLAGS: 00010293 CPU: 0
> [   35.262785] EIP is at aesni_cbc_dec+0x5c/0xbc [aesni_intel]
> [   35.264201] EAX: c77a3a7a EBX: 00000010 ECX: d0621950 EDX: c77a3a7=
a
> [   35.265612] ESI: 00000060 EDI: d0621920 EBP: c77a3a6a ESP: d840dc3=
c
> [   35.267010]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   35.268215] Process swapper (pid: 0, ti=3Dd840c000 task=3Dc08b1020=
=20
> task.ti=3Dc08aa000)
> [   35.269849] Stack:
> [   35.270330]  d840dcbc 00000060 00000000 d840dcb0 e0a24161 d0621830=
=20
> c77a3a7a c77a3a7a
> [   35.272475]  00000060 c77a3a6a d0621830 dfbcf460 c77a3a7a dfbcf460=
=20
> c77a3a7a d06211fc
> [   35.274645]  00000a7a 00000060 d06211fc 00000a7a 00000060 00000000=
=20
> 00000000 c77a3a6a
> [   35.276811] Call Trace:
> [   35.277454]  [<e0a24161>] ? cbc_decrypt+0xe1/0x130 [aesni_intel]
> [   35.278834]  [<c0380c60>] ? scatterwalk_done+0x40/0x50
> [   35.280381]  [<e0a23d44>] ? ablk_decrypt+0xc4/0xd0 [aesni_intel]
> [   35.281750]  [<e0aaae65>] ? crypto_authenc_decrypt+0x145/0x2fc=20
> [authenc]
> [   35.283292]  [<e09dd917>] ? esp_input+0x167/0x2d0 [esp4]
> [   35.284501]  [<c05ff445>] ? xfrm_input+0x3e5/0x430
> [   35.285599]  [<c05b05d0>] ? ip_rcv_finish+0x380/0x380
> [   35.286752]  [<c05f6255>] ? xfrm4_rcv_encap+0x25/0x30
> [   35.287905]  [<c05f6283>] ? xfrm4_rcv+0x23/0x30
> [   35.288947]  [<c05b0677>] ? ip_local_deliver_finish+0xa7/0x290
> [   35.290270]  [<c05b09ef>] ? ip_local_deliver+0x7f/0x90
> [   35.291443]  [<c05b05d0>] ? ip_rcv_finish+0x380/0x380
> [   35.292593]  [<c05b0363>] ? ip_rcv_finish+0x113/0x380
> [   35.294538]  [<c05b0c43>] ? ip_rcv+0x243/0x310
> [   35.296568]  [<c05b0250>] ? inet_del_protocol+0x30/0x30
> [   35.298762]  [<c05841aa>] ? __netif_receive_skb+0x45a/0x500
> [   35.301071]  [<c0584baf>] ? netif_receive_skb+0x6f/0x80
> [   35.303252]  [<c0584f03>] ? dev_gro_receive+0x163/0x240
> [   35.305442]  [<c0584cd7>] ? napi_skb_finish+0x37/0x50
> [   35.307668]  [<c0585141>] ? napi_gro_receive+0xa1/0xb0
> [   35.310577]  [<e085b75c>] ? e1000_clean_rx_irq+0x20c/0x3b0 [e1000]
> [   35.313119]  [<c0141898>] ? ttwu_do_wakeup+0x28/0x130
> [   35.315223]  [<e085cd84>] ? e1000_clean+0x184/0x490 [e1000]
> [   35.317596]  [<c016f9ec>] ? __queue_work+0xcc/0x390
> [   35.319625]  [<c058530d>] ? net_rx_action+0x10d/0x220
> [   35.321912]  [<c016fcb0>] ? __queue_work+0x390/0x390
> [   35.324149]  [<c015e0f0>] ? local_bh_enable_ip+0x90/0x90
> [   35.325384]  [<c015e0f0>] ? local_bh_enable_ip+0x90/0x90
> [   35.326587]  [<c015e171>] ? __do_softirq+0x81/0x1a0
> [   35.327697]  [<c015e0f0>] ? local_bh_enable_ip+0x90/0x90
> [   35.328905] <IRQ>
> [   35.329477]  [<c015e4b6>] ? irq_exit+0x76/0xa0
> [   35.330495]  [<c0677fdb>] ? do_IRQ+0x4b/0xc0
> [   35.331475]  [<c015e4a0>] ? irq_exit+0x60/0xa0
> [   35.332490]  [<c06780a9>] ? smp_apic_timer_interrupt+0x59/0x88
> [   35.333803]  [<c0677e30>] ? common_interrupt+0x30/0x38
> [   35.334974]  [<c013439a>] ? native_safe_halt+0xa/0x10
> [   35.336198]  [<c011802e>] ? default_idle+0x5e/0x110
> [   35.337336]  [<c0110358>] ? cpu_idle+0xa8/0xe0
> [   35.338396]  [<c064aa45>] ? rest_init+0x5d/0x68
> [   35.339448]  [<c091979d>] ? start_kernel+0x357/0x35d
> [   35.340581]  [<c09191d7>] ? loglevel+0x2b/0x2b
> [   35.341606]  [<c09190ba>] ? i386_start_kernel+0xa9/0xaf
> [   35.342789] Code: 83 fe 40 72 5a 66 90 0f 10 0a 0f 28 c1 0f 10 7a=20
> 10 0f 28 e7 0f 10 4a 20 0f 28 e9 0f 10 7a 30 0f 28 f7 e8 d8 fc ff ff=20
> 66 0f ef c3
> [   35.347966]  0f ef 22 66 0f ef 6a 10 66 0f ef f1 0f 28 df 0f 11 00=
=20
> 0f 11
> [   35.350719] EIP: [<e0a238c0>] aesni_cbc_dec+0x5c/0xbc [aesni_intel=
]=20
> SS:ESP 0068:d840dc3c
> [   35.353175] ---[ end trace 5b7cd1586950280a ]---
> [   35.354312] Kernel panic - not syncing: Fatal exception in interru=
pt
> [   35.355852] Pid: 0, comm: swapper Tainted: G      D      3.2.0-rc2=
 #1
> [   35.357403] Call Trace:
> [   35.358043]  [<c0668079>] ? printk+0x2d/0x2f
> [   35.359099]  [<c0667f4e>] panic+0x5c/0x15a
> [   35.360117]  [<c0671c6d>] oops_end+0xcd/0xd0
> [   35.361188]  [<c0113e14>] die+0x54/0x80
> [   35.362147]  [<c0671832>] do_general_protection+0x102/0x180
> [   35.363504]  [<c03837bd>] ? blkcipher_walk_next+0x1ad/0x3c0
> [   35.364858]  [<c0671730>] ? do_trap+0xd0/0xd0
> [   35.366014]  [<c0671487>] error_code+0x67/0x6c
> [   35.367117]  [<c038007b>] ? crypto_attr_alg2+0x2b/0x40
> [   35.368370]  [<e0a238c0>] ? aesni_cbc_dec+0x5c/0xbc [aesni_intel]
> [   35.369836]  [<e0a24161>] ? cbc_decrypt+0xe1/0x130 [aesni_intel]
> [   35.371291]  [<c0380c60>] ? scatterwalk_done+0x40/0x50
> [   35.372540]  [<e0a23d44>] ? ablk_decrypt+0xc4/0xd0 [aesni_intel]
> [   35.374004]  [<e0aaae65>] ? crypto_authenc_decrypt+0x145/0x2fc=20
> [authenc]
> [   35.375652]  [<e09dd917>] ? esp_input+0x167/0x2d0 [esp4]
> [   35.376954]  [<c05ff445>] ? xfrm_input+0x3e5/0x430
> [   35.378173]  [<c05b05d0>] ? ip_rcv_finish+0x380/0x380
> [   35.379406]  [<c05f6255>] ? xfrm4_rcv_encap+0x25/0x30
> [   35.380657]  [<c05f6283>] ? xfrm4_rcv+0x23/0x30
> [   35.381776]  [<c05b0677>] ? ip_local_deliver_finish+0xa7/0x290
> [   35.383205]  [<c05b09ef>] ? ip_local_deliver+0x7f/0x90
> [   35.384455]  [<c05b05d0>] ? ip_rcv_finish+0x380/0x380
> [   35.385722]  [<c05b0363>] ? ip_rcv_finish+0x113/0x380
> [   35.386967]  [<c05b0c43>] ? ip_rcv+0x243/0x310
> [   35.388108]  [<c05b0250>] ? inet_del_protocol+0x30/0x30
> [   35.389387]  [<c05841aa>] ? __netif_receive_skb+0x45a/0x500
> [   35.390751]  [<c0584baf>] ? netif_receive_skb+0x6f/0x80
> [   35.392033]  [<c0584f03>] ? dev_gro_receive+0x163/0x240
> [   35.393305]  [<c0584cd7>] ? napi_skb_finish+0x37/0x50
> [   35.394560]  [<c0585141>] ? napi_gro_receive+0xa1/0xb0
> [   35.395907]  [<e085b75c>] ? e1000_clean_rx_irq+0x20c/0x3b0 [e1000]
> [   35.397441]  [<c0141898>] ? ttwu_do_wakeup+0x28/0x130
> [   35.398679]  [<e085cd84>] ? e1000_clean+0x184/0x490 [e1000]
> [   35.400030]  [<c016f9ec>] ? __queue_work+0xcc/0x390
> [   35.401222]  [<c058530d>] ? net_rx_action+0x10d/0x220
> [   35.402464]  [<c016fcb0>] ? __queue_work+0x390/0x390
> [   35.403682]  [<c015e0f0>] ? local_bh_enable_ip+0x90/0x90
> [   35.404986]  [<c015e0f0>] ? local_bh_enable_ip+0x90/0x90
> [   35.406324]  [<c015e171>] ? __do_softirq+0x81/0x1a0
> [   35.407608]  [<c015e0f0>] ? local_bh_enable_ip+0x90/0x90
> [   35.408933] <IRQ>  [<c015e4b6>] ? irq_exit+0x76/0xa0
> [   35.410250]  [<c0677fdb>] ? do_IRQ+0x4b/0xc0
> [   35.411305]  [<c015e4a0>] ? irq_exit+0x60/0xa0
> [   35.412400]  [<c06780a9>] ? smp_apic_timer_interrupt+0x59/0x88
> [   35.413788]  [<c0677e30>] ? common_interrupt+0x30/0x38
> [   35.414955]  [<c013439a>] ? native_safe_halt+0xa/0x10
> [   35.416111]  [<c011802e>] ? default_idle+0x5e/0x110
> [   35.417228]  [<c0110358>] ? cpu_idle+0xa8/0xe0
> [   35.418251]  [<c064aa45>] ? rest_init+0x5d/0x68
> [   35.419559]  [<c091979d>] ? start_kernel+0x357/0x35d
> [   35.420696]  [<c09191d7>] ? loglevel+0x2b/0x2b
> [   35.421721]  [<c09190ba>] ? i386_start_kernel+0xa9/0xaf
