From: "Frank" <frank@debian-nas.org>
Subject: Kernel Oops when using af_alg for SHA1
Date: Fri, 2 Mar 2012 21:36:58 +0100
Message-ID: <013601ccf8b4$38951d80$a9bf5880$@org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "'Markus'" <nepenthesdev@gmail.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.leavis.eu ([46.182.104.51]:42679 "EHLO mail.leavis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab2CBUgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Mar 2012 15:36:44 -0500
Content-Language: en-us
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

In the process of evaluating userspace crypto APIs, I've run into a kernel Oops when performing a TLS handshake to openssl which offloads to AF_ALG (with SHA1 digests offloading to AF_ALG enabled).

This happens in Debian Wheezy (kernel 3.2.6, openssl 1.0.0g) on two different platforms:
- Marvell Kirkwood (ARMv5)
- VirtualBox x86

OpenSSL af_alg engine support for openssl has been compiled from git
 git://git.carnivore.it/users/common/af_alg.git

4096 bit key, openssl s_server with tls1 handshake:
 openssl s_server -cert default_blank.crt -key default_blank.key -accept 8888 -WWW -tls1 -engine af_alg

The Oops occurs when client (webbrowser) tries to initiate https handshake to openssl server

Oops on ARMv5 box: http://p.carnivore.it/Cz1B0k
Oops on x86 box: http://p.carnivore.it/JwlTq3

And in full below here too

ARMv5 Oops:
[207816.919919] Unable to handle kernel paging request at virtual address ffffffe8
[207816.927310] pgd = c8eb4000
[207816.930114] [ffffffe8] *pgd=1fffe831, *pte=00000000, *ppte=00000000
[207816.936587] Internal error: Oops: 17 [#2]
[207816.940699] Modules linked in: aes_generic algif_skcipher xfrm_user ah6 ah4 esp6 xfrm4_mode_beet xfrm4_tunnel xfrm4_mo
de_tunnel xfrm6_mode_transport xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6 xfrm_ipcomp xfrm6_tunnel tunnel6 af_key authenc algif_hash l2tp
_ppp pppox ppp_generic slhc l2tp_netlink l2tp_core crypto_null camellia cast6 cast5 cts ctr gcm ccm serpent twofish_generic twofish_common ecb xcbc sha256_ge
neric sha512_generic esp4 tunnel4 xfrm4_mode_transport iscsi_target_mod target_core_pscsi target_core_file target_core_iblock target_core_mod configfs af_alg
 crc32c rmd160 sha1_generic hmac blowfish_generic blowfish_common des_generic cbc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 ext2 loop vfat
fat ext3 jbd dm_crypt dm_mod evdev sata_mv libata mv643xx_eth libphy inet_lro gpio_keys ext4 mbcache jbd2 sd_mod crc_t10dif uas usb_storage scsi_mod ehci_hcd
 usbcore usb_common [last unloaded: cryptodev]
[207817.024833] CPU: 0    Tainted: G      D    O  (3.2.0-1-kirkwood #1)
[207817.031223] PC is at shash_async_export+0xc/0x18
[207817.035959] LR is at hash_accept+0x3c/0xe8 [algif_hash]
[207817.041297] pc : [<c01758e0>]    lr : [<bf5d2378>]    psr: 60000013
[207817.041302] sp : c1bede60  ip : 00000000  fp : c1bedee4
[207817.053014] r10: 00000000  r9 : 00000000  r8 : bf448ce8
[207817.058351] r7 : 0000011d  r6 : d93ce200  r5 : df5ab1c0  r4 : df5ab1c0
[207817.064995] r3 : 00000000  r2 : 00000068  r1 : c1bede68  r0 : c1ebf1a0
[207817.071641] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[207817.078896] Control: 0005397f  Table: 08eb4000  DAC: 00000015
[207817.084755] Process openssl (pid: 27070, stack limit = 0xc1bec270)
[207817.091050] Stack: (0xc1bede60 to 0xc1bee000)
[207817.095522] de60: c01758d4 bf5d2378 d9119240 c04129f8 c03fcff8 00000000 00000013 c00be818
[207817.103831] de80: 000000b9 c1bedec8 df5ab1c0 00000003 c02ddf80 c03fcff8 00000000 c00be8bc
[207817.112140] dea0: 000000b9 00000016 df5ab1c0 c1bedf70 00000000 c0223718 0000011d 00000000
[207817.120442] dec0: 00000000 c037a389 df80f4e0 d0457718 df7cfce0 df5ab1c0 00000016 0000011d
[207817.128744] dee0: c0224860 c022492c 00000000 00000000 df19f440 00020000 00000000 00000000
[207817.137044] df00: 00000000 00000000 c1bede60 00000000 00000030 c0156cac 00000030 00000000
[207817.145346] df20: c18bd1a0 00000030 00000000 00000000 00000000 00000000 d0457898 00000030
[207817.153648] df40: c18bd1a8 00000001 d84cc340 00000000 00000000 c1bedf68 00000001 00000000
[207817.161949] df60: 00000000 00008000 01f0eab8 00000010 c18bd5a0 00000000 00000030 00000000
[207817.170251] df80: 01f09c80 01f09af0 01f0a098 00000000 0000011d c000e028 c1bec000 00000000
[207817.178552] dfa0: 00000000 c000de80 01f09af0 01f0a098 00000010 00000000 00000000 b6f1e380
[207817.186853] dfc0: 01f09af0 01f0a098 00000000 0000011d bee61814 bee61898 00000014 00000000
[207817.195156] dfe0: b6eb33f4 bee61700 b6f1e3dc b6ce715c 40000010 00000010 9cb523f3 bf1324b8
[207817.203476] [<c01758e0>] (shash_async_export+0xc/0x18) from [<bf5d2378>] (hash_accept+0x3c/0xe8 [algif_hash])
[207817.213541] [<bf5d2378>] (hash_accept+0x3c/0xe8 [algif_hash]) from [<c022492c>] (sys_accept4+0x138/0x1e8)
[207817.223251] [<c022492c>] (sys_accept4+0x138/0x1e8) from [<c000de80>] (ret_fast_syscall+0x0/0x2c)
[207817.232163] Code: e8bd8008 e92d4008 e5b03040 e593304c (e5133018)
[207817.238718] ---[ end trace 23dab6c896437ffb ]---

X86 Oops:
[  301.693116] BUG: unable to handle kernel paging request at ffffffe8
[  301.693116] IP: [<c1144f6c>] shash_async_export+0x9/0xd
[  301.693116] *pdpt = 000000000147a001 *pde = 00000000019fc067 *pte = 0000000000000000
[  301.693116] Oops: 0000 [#1] SMP
[  301.693116] Modules linked in: cryptd aes_i586 aes_generic cbc algif_skcipher sha1_generic algif_hash af_alg ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_seq snd_timer snd_seq_device snd evdev psmouse i2c_piix4 serio_raw i2c_core soundcore pcspkr snd_page_alloc parport_pc parport ac power_supply button ext3 jbd mbcache sr_mod sd_mod cdrom crc_t10dif ata_generic ohci_hcd ata_piix ehci_hcd floppy libata usbcore e1000 scsi_mod usb_common [last unloaded: scsi_wait_scan]
[  301.693116]
[  301.693116] Pid: 1470, comm: openssl Tainted: G        W    3.2.0-1-686-pae #1 innotek GmbH VirtualBox
[  301.693116] EIP: 0060:[<c1144f6c>] EFLAGS: 00210282 CPU: 0
[  301.693116] EIP is at shash_async_export+0x9/0xd
[  301.693116] EAX: dcd3f208 EBX: dcd50200 ECX: 00000000 EDX: dccebe50
[  301.693116] ESI: de4fcc80 EDI: de4fcc80 EBP: dccebec8 ESP: dccebe44
[  301.693116]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0069
[  301.693116] Process openssl (pid: 1470, ti=dccea000 task=dce40ca0 task.ti=dccea000)
[  301.693116] Stack:
[  301.693116]  e0a2e38f 00200246 ff0219e1 c10c0b56 00071a04 ff0219f4 00000020 00000000
[  301.693116]  dccebeb4 dcce5880 df4ca600 c111fc47 c10cc9b2 00000020 dccebeb4 de4fcc80
[  301.693116]  00000003 c12eca34 c10cca27 00000014 de4fcc80 dccebeb4 00000000 c1209f7e
[  301.693116] Call Trace:
[  301.693116]  [<e0a2e38f>] ? hash_accept+0x46/0xdc [algif_hash]
[  301.693116]  [<c10c0b56>] ? kmem_cache_alloc+0x32/0x89
[  301.693116]  [<c111fc47>] ? security_file_alloc+0xc/0xd
[  301.693116]  [<c10cc9b2>] ? get_empty_filp+0x9a/0x100
[  301.693116]  [<c10cca27>] ? alloc_file+0xf/0x85
[  301.693116]  [<c1209f7e>] ? sock_alloc_file+0x95/0xeb
[  301.693116]  [<c120ada8>] ? sys_accept4+0xd1/0x171
[  301.693116]  [<c11409d3>] ? crypto_exit_ops+0x15/0x35
[  301.693116]  [<c10cb18b>] ? fsnotify_access+0x48/0x4f
[  301.693116]  [<c120b98d>] ? sys_socketcall+0x1d2/0x1da
[  301.693116]  [<c12b969c>] ? syscall_call+0x7/0xb
[  301.693116] Code: c3 90 90 b8 da ff ff ff c3 8b 50 10 8b 48 14 8b 52 30 89 48 2c 89 50 28 8b 52 34 83 c0 28 ff 52 d4 c3 8b 48 28 83 c0 28 8b 49 34 <ff> 51 e8 c3 53 8b 48 10 8b 58 14 8b 49 30 89 58 2c 89 48 28 8b
[  301.693116] EIP: [<c1144f6c>] shash_async_export+0x9/0xd SS:ESP 0069:dccebe44
[  301.693116] CR2: 00000000ffffffe8
[  301.693116] ---[ end trace a7919e7f17c0a727 ]---

Regards,
Frank
