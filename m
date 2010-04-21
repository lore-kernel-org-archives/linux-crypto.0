From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Bug#552270: Marvell CESA driver and Kirkwood
Date: Wed, 21 Apr 2010 10:13:02 +0200
Message-ID: <20100421081302.GB31506@Chamillionaire.breakpoint.cc>
References: <4B12F9E7.1020207@gmail.com>
 <20091130211531.GK18101@deprecation.cyrius.com>
 <4B144627.7060901@gmail.com>
 <20091204212847.GC28480@deprecation.cyrius.com>
 <4BCB4009.70707@gmail.com>
 <20100418191719.GA2508@Chamillionaire.breakpoint.cc>
 <4BCE125F.30200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>,
	Uri Simchoni <uri@jdland.co.il>, linux-crypto@vger.kernel.org
To: "L.C." <lucorsel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34816 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317Ab0DUINH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Apr 2010 04:13:07 -0400
Content-Disposition: inline
In-Reply-To: <4BCE125F.30200@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* L.C. | 2010-04-20 22:45:19 [+0200]:

>Sebastian, here is the OOPS from the latest cryptodev git tree
>(2.6.33), more clue than I thought, it looks?:

No I don't. I look at it this weekend. I need just to setup IPsec in
order to reproduce this, right?

>------------------------------------cut
>flip> ping 10.10.10.230
>PING 10.10.10.23[51252.081262] Unable to handle kernel NULL pointer
>dereference at virtual address 00000034
>0 (10.10.10.230)[51252.090530] pgd = c0004000
> 56(84) bytes of[51252.094632] [00000034] *pgd=00000000 data.
>
>[51252.100326] Internal error: Oops: 17 [#1]
>[51252.104351] last sysfs file: /sys/module/ccm/initstate
>[51252.109514] Modules linked in: xfrm_user ah6 ah4 esp6 esp4
>xfrm4_mode_beet xfrm4_tunnel xfrm4_mode_tunnel xfrm4_mode_transport
>xfrm6_mode_transport xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel
>ipcomp ipcomp6 xfrm6_tunnel af_key mv_cesa authenc ctr camellia cast5
>rmd160 crypto_null ccm serpent blowfish twofish twofish_common ecb
>xcbc cbc sha256_generic sha512_generic des_generic tunnel4
>xfrm_ipcomp tunnel6 autofs4 8021q garp stp ipv6 ext2 loop hmac
>sha1_generic aes_generic ext3 jbd mbcache mmc_block ehci_hcd mvsdio
>usbcore mv643xx_eth mmc_core nls_base libphy [last unloaded: af_key]
>[51252.162037] CPU: 0    Not tainted  (2.6.33 #1)
>[51252.166509] PC is at xfrm_output_resume+0x140/0x35c
>[51252.171419] LR is at authenc_geniv_ahash_done+0x4c/0x50 [authenc]
>[51252.177541] pc : [<c02a207c>]    lr : [<bf2872e8>]    psr: 60000013
>[51252.177547] sp : c086bf48  ip : 00000014  fp : 00000178
>[51252.189084] r10: 00000170  r9 : df4a7618  r8 : 00000000
>[51252.194334] r7 : 00000000  r6 : 00000000  r5 : 00000000  r4 : df4a7600
>[51252.200891] r3 : 00000000  r2 : df621800  r1 : 00000000  r0 : df4a7600
>[51252.207449] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
>Segment kernel
>[51252.214791] Control: 0005397f  Table: 0097c000  DAC: 00000017
>[51252.220564] Process mv_crypto (pid: 4702, stack limit = 0xc086a270)
>[51252.226860] Stack: (0xc086bf48 to 0xc086c000)
>[51252.231242] bf40:                   0000000c c017f364 c086bf60
>df6218a8 000008ac c017f548
>[51252.239465] bf60: df621800 df621840 00000000 bf2a8d90 def796c0
>df6218f8 c086a000 00000000
>[51252.247688] bf80: def796ec bf2872e8 00000001 00000000 00000100
>00000000 00000078 bf2a814c
>[51252.255912] bfa0: def796c0 def796ec a0000013 dfeede58 c086bfd4
>bf2a7fe4 def796c0 00000000
>[51252.264134] bfc0: 00000000 00000000 00000000 c005a848 00000000
>00000000 c086bfd8 c086bfd8
>[51252.272356] bfe0: 00000000 00000000 00000000 00000000 00000000
>c0026dec 00000000 00000000
>[51252.280591] [<c02a207c>] (xfrm_output_resume+0x140/0x35c) from
>[<bf2872e8>] (authenc_geniv_ahash_done+0x4c/0x50 [authenc])
>[51252.291709] [<bf2872e8>] (authenc_geniv_ahash_done+0x4c/0x50
>[authenc]) from [<bf2a814c>] (queue_manag+0x168/0x4f0 [mv_cesa])
>[51252.303082] [<bf2a814c>] (queue_manag+0x168/0x4f0 [mv_cesa]) from
>[<c005a848>] (kthread+0x78/0x80)
>[51252.312091] [<c005a848>] (kthread+0x78/0x80) from [<c0026dec>]
>(kernel_thread_exit+0x0/0x8)
>[51252.320483] Code: e1a06000 ea00007f e5947048 e3560000 (e5975034)
>[51252.326631] ---[ end trace 0fd0f54982ede5bf ]---
>[51252.331284] Kernel panic - not syncing: Fatal exception in interrupt
>[51252.337690] [<c002be44>] (unwind_backtrace+0x0/0xd8) from
>[<c02b2be0>] (panic+0x40/0x120)
>[51252.345914] [<c02b2be0>] (panic+0x40/0x120) from [<c0029b24>]
>(die+0x2d4/0x32c)
>[51252.353277] [<c0029b24>] (die+0x2d4/0x32c) from [<c002cc98>]
>(__do_kernel_fault+0x64/0x88)
>[51252.361603] [<c002cc98>] (__do_kernel_fault+0x64/0x88) from
>[<c002cee8>] (do_page_fault+0x22c/0x248)
>[51252.370792] [<c002cee8>] (do_page_fault+0x22c/0x248) from
>[<c002527c>] (do_DataAbort+0x34/0x94)
>[51252.379545] [<c002527c>] (do_DataAbort+0x34/0x94) from
>[<c00259ec>] (__dabt_svc+0x4c/0x60)
>[51252.387857] Exception stack(0xc086bf00 to 0xc086bf48)
>[51252.392949] bf00: df4a7600 00000000 df621800 00000000 df4a7600
>00000000 00000000 00000000
>[51252.401180] bf20: 00000000 df4a7618 00000170 00000178 00000014
>c086bf48 bf2872e8 c02a207c
>[51252.409404] bf40: 60000013 ffffffff
>[51252.412920] [<c00259ec>] (__dabt_svc+0x4c/0x60) from [<c02a207c>]
>(xfrm_output_resume+0x140/0x35c)
>[51252.421941] [<c02a207c>] (xfrm_output_resume+0x140/0x35c) from
>[<bf2872e8>] (authenc_geniv_ahash_done+0x4c/0x50 [authenc])
>[51252.433064] [<bf2872e8>] (authenc_geniv_ahash_done+0x4c/0x50
>[authenc]) from [<bf2a814c>] (queue_manag+0x168/0x4f0 [mv_cesa])
>[51252.444450] [<bf2a814c>] (queue_manag+0x168/0x4f0 [mv_cesa]) from
>[<c005a848>] (kthread+0x78/0x80)
>[51252.453468] [<c005a848>] (kthread+0x78/0x80) from [<c0026dec>]
>(kernel_thread_exit+0x0/0x8)
>--------------------------------------------cut

Sebastian
