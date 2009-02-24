From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Tue, 24 Feb 2009 14:19:54 +0100
Message-ID: <49A3F3FA.1000801@hiramoto.org>
References: <49A2E421.5050806@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: chohnstaedt@innominate.com, LKML <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-green-bigip-207.dreamhost.com ([208.97.132.207]:46351 "EHLO
	spunkymail-a13.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754499AbZBXNT6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2009 08:19:58 -0500
In-Reply-To: <49A2E421.5050806@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The latest thing i found is  kernel BUG at lib/scatterlist.c:26!

ping -s 1800  host in a IPSec tunnel.  Setup is   802.1Q VLAN  --> 
ixp4xx_eth  --> IPSec Tunnel

trace with   some   debug printk's  i added.    printk("%s:%d  
values",__func__, __LINE__);


[42949542.170000] esp_output:142 skb->len=1828 data_len=328 clen=1832 alen=0 blksize=8  skb=c7a5cb40 data=c79ba054
[42949542.180000] esp_output:168 skb=c7a5cb40 data=c79ba054 clone=0
[42949542.180000] __skb_to_sgvec:2430 skb=c7a5cb40 data=c79ba030 sg=c78a0324 off=36 len=1832
[42949542.190000] __skb_to_sgvec:2477 list=c795a0c0 start=1536  end=1868 list->len=332 offset=1536
[42949542.200000] __skb_to_sgvec:2430 skb=c795a0c0 data=c6d8f048 sg=c78a0338 off=0 len=332
[42949542.210000] __skb_to_sgvec:2484 len==0 elt=2
[42949542.210000] esp_output:218 skb=c7a5cb40 data=c79ba030
[42949542.220000] esp_output:228 skb=c7a5cb40 data=c79ba030
[42949542.230000] ablk_perform:897 ivsize=8 nbytes=1840
[42949542.230000] ablk_perform:919 dst=NULL src=c78a0278
[42949542.240000] count_sg:757 i=0 nbytes=1840 sg=c78a0278  sg_next(sg)=c78a028c
[42949542.240000] count_sg:758 len=1508 sg_is_last(sg)=0
[42949542.250000] count_sg:757 i=1 nbytes=332 sg=c78a028c  sg_next(sg)=c78a02a0
[42949542.250000] count_sg:758 len=0 sg_is_last(sg)=0
[42949542.260000] kernel BUG at lib/scatterlist.c:26!
[42949542.260000] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[42949542.270000] pgd = c0004000
[42949542.280000] [00000000] *pgd=00000000
[42949542.280000] Internal error: Oops: 817 [#1]
[42949542.280000] Modules linked in: xt_MARK crc_ccitt nf_conntrack_pptp nf_conntrack_proto_gre ixp4xx_crypto ipt_MASQUERADE ipt_REDIRECT nG
[42949542.280000] CPU: 0    Not tainted  (2.6.28.7 #20)
[42949542.280000] PC is at __bug+0x20/0x2c
[42949542.280000] LR is at release_console_sem+0x1b0/0x1ec
[42949542.280000] pc : [<c00271dc>]    lr : [<c0035d4c>]    psr: 60000013
[42949542.280000] sp : c031fbac  ip : c031fae4  fp : c031fbb8
[42949542.280000] r10: 00000730  r9 : 00000000  r8 : c78a02f8
[42949542.280000] r7 : ffc0b180  r6 : 00000002  r5 : 0000014c  r4 : c78a02a0
[42949542.280000] r3 : 00000000  r2 : c03238c8  r1 : 000040e5  r0 : 00000039
[42949542.280000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[42949542.280000] Control: 000039ff  Table: 07a1c000  DAC: 00000017
[42949542.280000] Process swapper (pid: 0, stack limit = 0xc031e260)
[42949542.280000] Stack: (0xc031fbac to 0xc0320000)
[42949542.280000] fba0:                            c031fbc8 c031fbbc c013cf60 c00271c8 c031fbf0
[42949542.280000] fbc0: c031fbcc bf0c7300 c013cf44 00000000 c78a028c c78a02a0 c7a5c62c 00000008
[42949542.280000] fbe0: c78a02d0 c031fc28 c031fbf4 bf0c7938 bf0c72e8 00000730 00000000 00000020
[42949542.280000] fc00: 00000005 c78a0244 c78a0278 00000008 0000004c c78a0324 c78a02d0 c031fc38
[42949542.280000] fc20: c031fc2c bf0c7b64 bf0c777c c031fc90 c031fc3c c0116a80 bf0c7b5c c79ba000
[42949542.280000] fc40: 87654321 c78a02c8 c7b286ec c78a0324 c79ba054 c79ba054 000f3740 c79ba054
[42949542.280000] fc60: 00000000 00000005 00000005 c7b286c0 c79ba04c c78a0214 c79ba044 00000002
[42949542.280000] fc80: c78a0208 c031fcb0 c031fc94 c0122d88 c0116790 00000005 c7a5cb60 c79ba04c
[42949542.280000] fca0: c7a5cb40 c031fd1c c031fcb4 c0226658 c0122d1c c79ba030 00000000 00000000
[42949542.280000] fcc0: 00000008 c7a5cb40 c79ba054 00000000 c7aa8a00 c7b28880 c78a0324 c78a0310
[42949542.280000] fce0: c78a0200 c78a0200 00000728 00000000 c795a0c0 00000005 c7aa8a00 c7a5cb40
[42949542.280000] fd00: c031e000 c6d87000 00000000 c035f544 c031fd5c c031fd20 c0232b8c c0226284
[42949542.280000] fd20: c031fd5c c031fd30 c01ee0e4 00000000 00000004 c7a5cb40 c7a5cb40 c6d87000
[42949542.280000] fd40: c7a5cb60 c7a5cb40 c035d6b4 00000000 c031fd6c c031fd60 c0232ca0 c02328a4
[42949542.280000] fd60: c031fd8c c031fd70 c0232d94 c0232c98 c7a5cb40 c79ba054 c6d87000 c7a5cb60
[42949542.280000] fd80: c031fd9c c031fd90 c0229c70 c0232cb0 c031fdbc c031fda0 c0229cd0 c0229c28
[42949542.280000] fda0: c7878800 c0229c1c 80000000 c7a5cb40 c031fdd0 c031fdc0 c01f6fc4 c0229c80
[42949542.280000] fdc0: c7a5cb40 c031fdfc c031fdd4 c01f7290 c01f6f8c c7878800 c01f6f80 80000000
[42949542.280000] fde0: c035d6ec c7957034 c035d4a4 c7b37800 c031fe3c c031fe00 c01f5b94 c01f6fd8
[42949542.280000] fe00: c7b37800 c031fe10 c01f585c 80000000 c035db38 c035d6ec c035d6ec c7a5cb40
[42949542.280000] fe20: c035d4a4 c7b37800 c035d704 00000000 c031fe68 c031fe40 c01f60dc c01f5868
[42949542.280000] fe40: 00000000 c01f585c 80000000 c035d6ec c7a5cb40 c7b37800 00000800 c031fe98
[42949542.280000] fe60: c031fe6c c01d968c c01f5eac c0173344 c002ccbc c035d6cc 00000002 ffffcce9
[42949542.280000] fe80: 00000040 00000000 c035d6b0 c031fec4 c031fe9c c01dbc84 c01d9318 c035d6cc
[42949542.280000] fea0: 00000040 00000002 0000012a c035d6b0 c035d6c0 ffffcce9 c031fef0 c031fec8
[42949542.280000] fec0: c01db688 c01dbc04 00000100 0000000c c031e000 00000001 0000000a c0348dc0
[42949542.280000] fee0: c0348e34 c031ff20 c031fef4 c003a140 c01db634 c002c4e4 00000003 00000000
[42949542.280000] ff00: 00000008 c033f708 0001dd18 69054041 0001dc48 c031ff30 c031ff24 c003a4bc
[42949542.280000] ff20: c003a0e4 c031ff48 c031ff34 c0023068 c003a484 ffffffff 0000001f c031ffa0
[42949542.280000] ff40: c031ff4c c0023a04 c002300c c0340094 c7aa0000 c031e000 c033f710 c0024e18
[42949542.280000] ff60: c031e000 c0024e18 c033f708 0001dd18 69054041 0001dc48 c031ffa0 c031ffa4
[42949542.280000] ff80: c031ff94 c0024ce0 c0024e28 60000013 ffffffff c031ffc0 c031ffa4 c0024ce0
[42949542.280000] ffa0: c0024e24 c034b854 c033f284 c001fdb8 c0322374 c031ffd0 c031ffc4 c0263534
[42949542.280000] ffc0: c0024cb0 c031fff4 c031ffd4 c00089d8 c02634ec c0008374 c001fdb8 000039fd
[42949542.280000] ffe0: c033f76c c00201bc 00000000 c031fff8 00008034 c00087a0 00000000 00000000
[42949542.280000] Backtrace:
[42949542.280000] [<c00271bc>] (__bug+0x0/0x2c) from [<c013cf60>] (sg_next+0x28/0x58)
[42949542.280000] [<c013cf38>] (sg_next+0x0/0x58) from [<bf0c7300>] (count_sg+0x24/0xac [ixp4xx_crypto])
[42949542.280000] [<bf0c72dc>] (count_sg+0x0/0xac [ixp4xx_crypto]) from [<bf0c7938>] (ablk_perform+0x1c8/0x36c [ixp4xx_crypto])
[42949542.280000]  r6:c78a02d0 r5:00000008 r4:c7a5c62c
[42949542.280000] [<bf0c7770>] (ablk_perform+0x0/0x36c [ixp4xx_crypto]) from [<bf0c7b64>] (ablk_encrypt+0x14/0x18 [ixp4xx_crypto])
[42949542.280000] [<bf0c7b50>] (ablk_encrypt+0x0/0x18 [ixp4xx_crypto]) from [<c0116a80>] (eseqiv_givencrypt+0x2fc/0x328)
[42949542.280000] [<c0116784>] (eseqiv_givencrypt+0x0/0x328) from [<c0122d88>] (crypto_authenc_givencrypt+0x78/0x98)
[42949542.280000] [<c0122d10>] (crypto_authenc_givencrypt+0x0/0x98) from [<c0226658>] (esp_output+0x3e0/0x434)
[42949542.280000]  r7:c7a5cb40 r6:c79ba04c r5:c7a5cb60 r4:00000005
[42949542.280000] [<c0226278>] (esp_output+0x0/0x434) from [<c0232b8c>] (xfrm_output_resume+0x2f4/0x3f4)
[42949542.280000] [<c0232898>] (xfrm_output_resume+0x0/0x3f4) from [<c0232ca0>] (xfrm_output2+0x14/0x18)
[42949542.280000] [<c0232c8c>] (xfrm_output2+0x0/0x18) from [<c0232d94>] (xfrm_output+0xf0/0x100)
[42949542.280000] [<c0232ca4>] (xfrm_output+0x0/0x100) from [<c0229c70>] (xfrm4_output_finish+0x54/0x58)
[42949542.280000]  r7:c7a5cb60 r6:c6d87000 r5:c79ba054 r4:c7a5cb40
[42949542.280000] [<c0229c1c>] (xfrm4_output_finish+0x0/0x58) from [<c0229cd0>] (xfrm4_output+0x5c/0x68)
[42949542.280000] [<c0229c74>] (xfrm4_output+0x0/0x68) from [<c01f6fc4>] (ip_forward_finish+0x44/0x4c)
[42949542.280000]  r4:c7a5cb40
[42949542.280000] [<c01f6f80>] (ip_forward_finish+0x0/0x4c) from [<c01f7290>] (ip_forward+0x2c4/0x340)
[42949542.280000]  r4:c7a5cb40
[42949542.280000] [<c01f6fcc>] (ip_forward+0x0/0x340) from [<c01f5b94>] (ip_rcv_finish+0x338/0x35c)
[42949542.280000]  r7:c7b37800 r6:c035d4a4 r5:c7957034 r4:c035d6ec
[42949542.280000] [<c01f585c>] (ip_rcv_finish+0x0/0x35c) from [<c01f60dc>] (ip_rcv+0x23c/0x270)
[42949542.280000] [<c01f5ea0>] (ip_rcv+0x0/0x270) from [<c01d968c>] (netif_receive_skb+0x380/0x3c0)
[42949542.280000]  r7:00000800 r6:c7b37800 r5:c7a5cb40 r4:c035d6ec
[42949542.280000] [<c01d930c>] (netif_receive_skb+0x0/0x3c0) from [<c01dbc84>] (process_backlog+0x8c/0x114)
[42949542.280000] [<c01dbbf8>] (process_backlog+0x0/0x114) from [<c01db688>] (net_rx_action+0x60/0x1a4)
[42949542.280000] [<c01db628>] (net_rx_action+0x0/0x1a4) from [<c003a140>] (__do_softirq+0x68/0x104)
[42949542.280000] [<c003a0d8>] (__do_softirq+0x0/0x104) from [<c003a4bc>] (irq_exit+0x44/0x4c)
[42949542.280000] [<c003a478>] (irq_exit+0x0/0x4c) from [<c0023068>] (__exception_text_start+0x68/0x84)
[42949542.280000] [<c0023000>] (__exception_text_start+0x0/0x84) from [<c0023a04>] (__irq_svc+0x24/0x80)
[42949542.280000] Exception stack(0xc031ff4c to 0xc031ff94)
[42949542.280000] ff40:                            c0340094 c7aa0000 c031e000 c033f710 c0024e18
[42949542.280000] ff60: c031e000 c0024e18 c033f708 0001dd18 69054041 0001dc48 c031ffa0 c031ffa4
[42949542.280000] ff80: c031ff94 c0024ce0 c0024e28 60000013 ffffffff
[42949542.280000]  r5:0000001f r4:ffffffff
[42949542.280000] [<c0024e18>] (default_idle+0x0/0x4c) from [<c0024ce0>] (cpu_idle+0x3c/0x58)
[42949542.280000] [<c0024ca4>] (cpu_idle+0x0/0x58) from [<c0263534>] (rest_init+0x54/0x68)
[42949542.280000]  r7:c0322374 r6:c001fdb8 r5:c033f284 r4:c034b854
[42949542.280000] [<c02634e0>] (rest_init+0x0/0x68) from [<c00089d8>] (start_kernel+0x244/0x2a4)
[42949542.280000] [<c0008794>] (start_kernel+0x0/0x2a4) from [<00008034>] (0x8034)
[42949542.280000]  r6:c00201bc r5:c033f76c r4:000039fd
[42949542.280000] Code: e1a01000 e59f000c eb003c6b e3a03000 (e5833000)
[42949542.290000] Kernel panic - not syncing: Fatal exception in interrupt
[42949542.300000] Rebooting in 10 seconds..+oxtias1








