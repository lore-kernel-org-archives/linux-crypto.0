From: "Frank" <frank@debian-nas.org>
Subject: RE: mv_cesa dcache problem since 2.6.37 was: Re: mv_cesa hash functions
Date: Mon, 7 May 2012 15:01:15 +0200
Message-ID: <003901cd2c51$7ca629d0$75f27d70$@org>
References: <20120223183439.GA18545@orbit.nwl.cc> <4FA5AE7A.3000201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "'Simon Baatz'" <gmbnomis@gmail.com>,
	"'Sebastian Andrzej Siewior'" <sebastian@breakpoint.cc>,
	<uri@jdland.co.il>, <linux-crypto@vger.kernel.org>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'Catalin Marinas'" <catalin.marinas@arm.com>,
	<linux-arm-kernel@lists.arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.leavis.eu ([46.182.104.51]:37450 "EHLO mail.leavis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab2EGNBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 May 2012 09:01:38 -0400
In-Reply-To: <4FA5AE7A.3000201@gmail.com>
Content-Language: en-us
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

> -----Original Message-----
> From: Simon Baatz [mailto:gmbnomis@gmail.com]
> Sent: Sunday, May 06, 2012 00:50
> To: Frank; 'Sebastian Andrzej Siewior'; uri@jdland.co.il; linux-
> crypto@vger.kernel.org; Herbert Xu; Catalin Marinas; linux-arm-
> kernel@lists.arm.linux.org.uk
> Subject: mv_cesa dcache problem since 2.6.37 was: Re: mv_cesa hash
> functions
> 
> Hi,
> 
> Am 23.02.2012 19:34, schrieb Phil Sutter:
> > But you might suffer from another problem, which is only present on
> > ARM machines with VIVT cache and linux >= 2.6.37: due to commit
> > f8b63c1, "ARM: 6382/1: Remove superfluous flush_kernel_dcache_page()"
> > which prevents pages being flushed from inside the scatterlist
> > iterator API. This patch seems to introduce problems in other places
> > (namely NFS), too but I sadly did not have time to investigate this
> > further. I will post a possible (cryptodev-internal) solution to
> > cryptodev-linux-devel@gna.org, maybe this fixes the problem with
> > openssl. Greetings, Phil
> 
> since there has been no reaction on this, I would like to bring this
> issue up again (I sadly don't have the expertise to investigate this
> further...). The issue is not limited to cryptodev, but seems to be
> either a problem with commit f8b63c1 or a problem in mv_cesa that was
> uncovered by this commit. In the past, I also had massive problems
> compiling on an NFS mounted file system when not reverting f8b63c1. I
> currently can't reproduce this anymore under 3.4-rc5.
> 
> However, the following still happens on a 3.4-rc5 preempt kernel on arm
> kirkwood (VIVT cache):
> 
> root@ww1:~# cryptsetup luksOpen /dev/sda2 c_sda2
> Enter passphrase for /dev/sda2:
> root@ww1:~# vgchange -a y ww1_1
>   Volume group "ww1_1" not found
> root@ww1:~# vgchange -a y ww1_1
> Segmentation fault
> 
> 
> Thus, the behavior of vgchange is unpredictable on a dm-crypt device
> when using mv_cesa (btw. the machine needs to have no load to show this
> behavior. I assume that the cache flushes caused by task switches make
> it work under load).
> 
> Using the generic crypto modules, it works as expected:
> 
> root@ww1:~# cryptsetup luksClose c_sda2
> root@ww1:~# rmmod mv_cesa
> root@ww1:~# cryptsetup luksOpen /dev/sda2 c_sda2
> Enter passphrase for /dev/sda2:
> root@ww1:~# vgchange -a y ww1_1
>   1 logical volume(s) in volume group "ww1_1" now active
> 
> 
> After reverting f8b63c1, it works as expected using mv_cesa as well.
> 
> 
> - Simon

I'm not sure if this is related, but I do see a kernel oops (on kernel 3.2.15) when using mv_cesa in the situation where clients connect to a L2TP/IPSEC VPN and use eap-tls authentication for the ppp link:

[  495.526702] Unable to handle kernel paging request at virtual address 03205d58
[  495.533964] pgd = c0004000
[  495.536697] [03205d58] *pgd=00000000
[  495.540298] Internal error: Oops: 5 [#1]
[  495.544236] Modules linked in: mv_cesa ppp_async crc_ccitt ppp_generic slhc authenc xfrm4_mode_transport tcm_loop tcm_fc libfc scsi_transport_fc scsi_tgt iscsi_target_mod target_core_pscsi target_core_file target_core_iblock target_core_mod configfs xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 ctr twofish_generic twofish_common camellia serpent blowfish_generic blowfish_common cast5 des_generic cbc aes_generic xcbc rmd160 sha512_generic sha256_generic sha1_generic hmac crypto_null af_key ipv6 ext3 jbd ext2 loop evdev snd_usb_audio snd_usbmidi_lib snd_hwdep snd_seq_midi snd_seq_midi_event snd_rawmidi snd_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd soundcore gpio_keys ext4 jbd2 mbcache sd_mod crc_t10dif usb_storage uas sata_mv libata ehci_hcd scsi_mod usbcore usb
 _common mv643xx_eth inet_lro libphy [last unloaded: l2tp_core]
[  495.620303] CPU: 0    Not tainted  (3.2.0-2-kirkwood #1)
[  495.625645] PC is at memcpy+0x94/0x3a4
[  495.629415] LR is at copy_src_to_buf+0x68/0x94 [mv_cesa]
[  495.634754] pc : [<c01929d4>]    lr : [<bf530c3c>]    psr: 20000013
[  495.634759] sp : de989f24  ip : 00000008  fp : de988000
[  495.646295] r10: 00000608  r9 : de5cd868  r8 : 00000000
[  495.651545] r7 : e0e6e648  r6 : 00000040  r5 : 00000040  r4 : c01929cc
[  495.658104] r3 : 00000018  r2 : 00000008  r1 : 03205d58  r0 : e0e6e648
[  495.664661] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  495.672003] Control: 0005397f  Table: 1e564000  DAC: 00000017
[  495.677775] Process mv_crypto (pid: 2484, stack limit = 0xde988270)
[  495.684071] Stack: (0xde989f24 to 0xde98a000)
[  495.688454] 9f20:          00000040 00000040 e0e6e648 00000000 e0e6e648 ded7e1ac bf530c3c
[  495.696668] 9f40: 00000080 ded7e180 00000608 ded7e180 ded7e100 bf530ca8 06080080 de5cd8e8
[  495.704882] 9f60: 00000001 bf530e3c 00000070 00000000 00000000 00000000 00000000 06080080
[  495.713097] 9f80: 00000000 00000000 00000004 de5cd8e8 bf531f38 ded7e180 ded7e1ac bf5312e0
[  495.721312] 9fa0: ded7e180 ded7e1ac de989f30 ddccbdf0 ded7e180 bf530f70 00000013 00000000
[  495.729533] 9fc0: 00000000 00000000 00000000 c003dc68 00000000 00000000 ded7e180 00000000
[  495.737748] 9fe0: de989fe0 de989fe0 ddccbdf0 c003dbec c000edf8 c000edf8 00000000 00000000
[  495.745964] Code: 108ff00c ea000012 e1a00000 e4913004 (e4914004)
[  495.752389] ---[ end trace 0054294d538730e7 ]---

Here's the patch for Debian Squeeze/Wheezy to allow ppp authentication against a RADIUS server in ppp:
http://debian-nas.org/files/ppp-2.4.5-heiart-radius-eaptls-debian.patch

Here are instructions on how to set it up:
http://debian-nas.org/files/ppp-radius-eaptls-debian-howto.txt

I haven't tested (yet) if reverting f8b63c1 fixes this issue for me.

Regards,
Frank
