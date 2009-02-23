From: Karl Hiramoto <karl@hiramoto.org>
Subject: ixp4xx_crypto panic
Date: Mon, 23 Feb 2009 19:00:01 +0100
Message-ID: <49A2E421.5050806@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: chohnstaedt@innominate.com, LKML <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755481AbZBWSAX@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Using ixp4xx_crypto hardware acceleration  i have the panic below,  only
when doing a ping > MTU  or any other packet > MTU.


The basic setup is   802.1Q VLAN  -->  ixp4xx_eth  --> IPSec Tunnel

a ping -s   1800   to a host on the other side of the tunnel  will
produce the kernel panic..


Doing the same test with software only, no hardware acceleration, 
everything works fine.


Tomorrow i'll have more time to debug this, but my best guess now, is a
problem with ixp4xx_crypto,   the ablkcipher_request scatterlist src,  
or the cryto asyncd, or something else.


The same occurs on 2.6.28.7  and  2.6.28.4



[42949526.020000] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[42949526.020000] pgd =
c0004000                                                             
[42949526.030000] [00000000]
*pgd=00000000                                                   
[42949526.030000] Internal error: Oops: 817
[#1]                                             
[42949526.030000] Modules linked in: xt_MARK crc_ccitt nf_conntrack_pptp
nf_conntrack_proto_gre ixp4xx_crypto ipt_MASQUERADE ipt_REDIRECT nf
_nat_sip nf_conntrack_sip nf_nat_h323 nf_conntrack_h323 nf_nat_tftp
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat_irc nf_conntrack_ir
c ipt_addrtype iptable_nat nf_nat xt_TCPMSS xt_pkttype nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack xt_mark iptable_mangle iptable
_filter ip_tables
ipt_ULOG                                                                                                                 

[42949526.030000] CPU: 0    Not tainted  (2.6.28.7
#12)                                                                                    

[42949526.030000] PC is at
dma_cache_maint+0x40/0x8c                                                                                       

[42949526.030000] LR is at
dma_map_page+0x220/0x274                                                                                        

[42949526.030000] pc : [<c00285dc>]    lr : [<c002bb08>]    psr:
80000013                                                                  
[42949526.030000] sp : c031fb98  ip : c031fba8  fp :
c031fba4                                                                              

[42949526.030000] r10: bf0ca6ac  r9 : 9b249000  r8 :
00000000                                                                              

[42949526.030000] r7 : 00000000  r6 : 00000000  r5 : 00000005  r4 :
db249000                                                               
[42949526.030000] r3 : 00000000  r2 : 00000000  r1 : 9b249000  r0 :
9b249000                                                               
[42949526.030000] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment kernel                                                      
[42949526.030000] Control: 000039ff  Table: 07a00000  DAC:
00000017                                                                        

[42949526.030000] Process swapper (pid: 0, stack limit =
0xc031e260)                                                                       

[42949526.030000] Stack: (0xc031fb98 to
0xc0320000)                                                                                        

[42949526.030000]
fb80:                                                       c031fbd8
c031fba8                                            
[42949526.030000] fba0: c002bb08 c00285a8 00000008 00000020 c7b64888
00000005 00000001 c7b64878                                            
[42949526.030000] fbc0: 00000000 00000020 bf0ca6ac c031fc04 c031fbdc
c0028e9c c002b8f4 00000000                                            
[42949526.030000] fbe0: 00000000 c7b648c0 ffc0b180 c7b648e8 00000008
00000608 c031fc34 c031fc08                                            
[42949526.030000] fc00: bf0c7920 c0028e64 00000608 00000005 c7b64844
c7b64878 0000004c 00000008                                            
[42949526.030000] fc20: c7b64910 c7b648c0 c031fc44 c031fc38 bf0c7ad4
bf0c7750 c031fc94 c031fc48                                            
[42949526.030000] fc40: c0116d34 bf0c7acc 00000000 c7b228ec c7b64910
c7b27054 c7b27054 000f64e0                                            
[42949526.030000] fc60: c7b27054 00000000 00000005 00000005 c7b228c0
c7b2704c c7b64814 c787ba80                                            
[42949526.030000] fc80: 00000002 c7b64808 c031fcb4 c031fc98 c0122d84
c0116ad4 00000005 c787baa0                                            
[42949526.030000] fca0: c7b2704c c7b27044 c031fd1c c031fcb8 c022704c
c0122d18 c7b27030 00000600                                            
[42949526.030000] fcc0: 00000000 00000008 c787ba80 c7b27054 c7a6ee00
c7b22900 c7b64910 c7b64900                                            
[42949526.030000] fce0: c7b64800 c7b64800 00000600 00000000 c7a32900
00000005 c7a6ee00 c787ba80                                            
[42949526.030000] fd00: c031e000 c697c000 00000000 c035f544 c031fd5c
c031fd20 c0233648 c0226cd0                                            
[42949526.030000] fd20: c031fd5c c031fd30 c01eeb9c 00000000 00000004
c787ba80 c787ba80 c697c000                                            
[42949526.030000] fd40: c787baa0 c787ba80 c035d6b4 00000000 c031fd6c
c031fd60 c0233758 c023335c                                            
[42949526.030000] fd60: c031fd8c c031fd70 c023384c c0233750 c787ba80
c7b27054 c697c000 c787baa0                                            
[42949526.030000] fd80: c031fd9c c031fd90 c022a634 c0233768 c031fdbc
c031fda0 c022a694 c022a5ec                                            
[42949526.030000] fda0: c79b1000 c022a5e0 80000000 c787ba80 c031fdd0
c031fdc0 c01f7b10 c022a644                                            
[42949526.030000] fdc0: c787ba80 c031fdfc c031fdd4 c01f7ddc c01f7ad8
c79b1000 c01f7acc 80000000                                            
[42949526.030000] fde0: c035d6ec c792c834 c035d4a4 c7a17000 c031fe3c
c031fe00 c01f66d8 c01f7b24                                            
[42949526.030000] fe00: c7a17000 c031fe10 c01f63a0 80000000 c035db38
c035d6ec c035d6ec c787ba80                                            
[42949526.030000] fe20: c035d4a4 c7a17000 c035d704 00000000 c031fe68
c031fe40 c01f6c18 c01f63ac                                            
[42949526.030000] fe40: 00000000 c01f63a0 80000000 c035d6ec c787ba80
c7a17000 00000800 c031fe98                                            
[42949526.030000] fe60: c031fe6c c01da0d8 c01f69e8 c01731f0 c002cb00
c035d6cc 00000002 ffffc692                                            
[42949526.030000] fe80: 00000040 00000000 c035d6b0 c031fec4 c031fe9c
c01dc6ec c01d9d64 c035d6cc                                            
[42949526.030000] fea0: 00000040 00000002 0000012a c035d6b0 c035d6c0
ffffc692 c031fef0 c031fec8                                            
[42949526.030000] fec0: c01dc0dc c01dc66c 00000100 0000000c c031e000
00000001 0000000a c0348dc0                                            
[42949526.030000] fee0: c0348e34 c031ff20 c031fef4 c0039f60 c01dc088
c002c328 00000003 00000000                                            
[42949526.030000] ff00: 00000008 c033f708 0001ddc4 69054041 0001dcf4
c031ff30 c031ff24 c003a2d0                                            
[42949526.030000] ff20: c0039f04 c031ff48 c031ff34 c0023068 c003a298
ffffffff 0000001f c031ffa0                                            
[42949526.030000] ff40: c031ff4c c00239c4 c002300c c0340094 c79a1500
c031e000 60000093 c0024dd8                                            
[42949526.030000] ff60: c031e000 c0024dd8 c033f708 0001ddc4 69054041
0001dcf4 c031ffa0 c031ffa4                                            
[42949526.030000] ff80: c031ff94 c0024ca0 c0024e00 60000013 ffffffff
c031ffc0 c031ffa4 c0024ca0                                            
[42949526.030000] ffa0: c0024de4 c034b854 c033f284 c001fdb8 c0322374
c031ffd0 c031ffc4 c026422c                                            
[42949526.030000] ffc0: c0024c70 c031fff4 c031ffd4 c00089d0 c02641e4
c0008374 c001fdb8 000039fd                                            
[42949526.030000] ffe0: c033f76c c00201bc 00000000 c031fff8 00008034
c0008798 00000000 00000000                                            
[42949526.030000]
Backtrace:                                                                                                               

[42949526.030000] [<c002859c>] (dma_cache_maint+0x0/0x8c) from
[<c002bb08>]
(dma_map_page+0x220/0x274)                                     
[42949526.030000] [<c002b8e8>] (dma_map_page+0x0/0x274) from
[<c0028e9c>]
(dma_map_sg+0x44/0xb4)                                           
[42949526.030000] [<c0028e58>] (dma_map_sg+0x0/0xb4) from [<bf0c7920>]
(ablk_perform+0x1dc/0x308 [ixp4xx_crypto])                          
[42949526.030000] [<bf0c7744>] (ablk_perform+0x0/0x308 [ixp4xx_crypto])
from [<bf0c7ad4>] (ablk_encrypt+0x14/0x18 [ixp4xx_crypto])         
[42949526.030000] [<bf0c7ac0>] (ablk_encrypt+0x0/0x18 [ixp4xx_crypto])
from [<c0116d34>] (eseqiv_givencrypt+0x26c/0x290)                   
[42949526.030000] [<c0116ac8>] (eseqiv_givencrypt+0x0/0x290) from
[<c0122d84>] (crypto_authenc_givencrypt+0x78/0x98)                       
[42949526.030000] [<c0122d0c>] (crypto_authenc_givencrypt+0x0/0x98) from
[<c022704c>] (esp_output+0x388/0x3c0)                             
[42949526.030000]  r7:c7b27044 r6:c7b2704c r5:c787baa0
r4:00000005                                                                         

[42949526.030000] [<c0226cc4>] (esp_output+0x0/0x3c0) from [<c0233648>]
(xfrm_output_resume+0x2f8/0x3f4)                                   
[42949526.030000] [<c0233350>] (xfrm_output_resume+0x0/0x3f4) from
[<c0233758>] (xfrm_output2+0x14/0x18)                                   
[42949526.030000] [<c0233744>] (xfrm_output2+0x0/0x18) from [<c023384c>]
(xfrm_output+0xf0/0x100)
[42949526.030000] [<c023375c>] (xfrm_output+0x0/0x100) from [<c022a634>]
(xfrm4_output_finish+0x54/0x58)
[42949526.030000]  r7:c787baa0 r6:c697c000 r5:c7b27054 r4:c787ba80
[42949526.030000] [<c022a5e0>] (xfrm4_output_finish+0x0/0x58) from
[<c022a694>] (xfrm4_output+0x5c/0x68)
[42949526.030000] [<c022a638>] (xfrm4_output+0x0/0x68) from [<c01f7b10>]
(ip_forward_finish+0x44/0x4c)
[42949526.030000]  r4:c787ba80
[42949526.030000] [<c01f7acc>] (ip_forward_finish+0x0/0x4c) from
[<c01f7ddc>] (ip_forward+0x2c4/0x340)
[42949526.030000]  r4:c787ba80
[42949526.030000] [<c01f7b18>] (ip_forward+0x0/0x340) from [<c01f66d8>]
(ip_rcv_finish+0x338/0x35c)
[42949526.030000]  r7:c7a17000 r6:c035d4a4 r5:c792c834 r4:c035d6ec
[42949526.030000] [<c01f63a0>] (ip_rcv_finish+0x0/0x35c) from
[<c01f6c18>] (ip_rcv+0x23c/0x270)
[42949526.030000] [<c01f69dc>] (ip_rcv+0x0/0x270) from [<c01da0d8>]
(netif_receive_skb+0x380/0x3c0)
[42949526.030000]  r7:00000800 r6:c7a17000 r5:c787ba80 r4:c035d6ec
[42949526.030000] [<c01d9d58>] (netif_receive_skb+0x0/0x3c0) from
[<c01dc6ec>] (process_backlog+0x8c/0x128)
[42949526.030000] [<c01dc660>] (process_backlog+0x0/0x128) from
[<c01dc0dc>] (net_rx_action+0x60/0x1b8)
[42949526.030000] [<c01dc07c>] (net_rx_action+0x0/0x1b8) from
[<c0039f60>] (__do_softirq+0x68/0x104)
[42949526.030000] [<c0039ef8>] (__do_softirq+0x0/0x104) from
[<c003a2d0>] (irq_exit+0x44/0x4c)
[42949526.030000] [<c003a28c>] (irq_exit+0x0/0x4c) from [<c0023068>]
(__exception_text_start+0x68/0x84)
[42949526.030000] [<c0023000>] (__exception_text_start+0x0/0x84) from
[<c00239c4>] (__irq_svc+0x24/0x80)
[42949526.030000] Exception stack(0xc031ff4c to 0xc031ff94)
[42949526.030000] ff40:                            c0340094 c79a1500
c031e000 60000093 c0024dd8
[42949526.030000] ff60: c031e000 c0024dd8 c033f708 0001ddc4 69054041
0001dcf4 c031ffa0 c031ffa4
[42949526.030000] ff80: c031ff94 c0024ca0 c0024e00 60000013 ffffffff
[42949526.030000]  r5:0000001f r4:ffffffff
[42949526.030000] [<c0024dd8>] (default_idle+0x0/0x4c) from [<c0024ca0>]
(cpu_idle+0x3c/0x58)
[42949526.030000] [<c0024c64>] (cpu_idle+0x0/0x58) from [<c026422c>]
(rest_init+0x54/0x68)
[42949526.030000]  r7:c0322374 r6:c001fdb8 r5:c033f284 r4:c034b854
[42949526.030000] [<c02641d8>] (rest_init+0x0/0x68) from [<c00089d0>]
(start_kernel+0x244/0x2a4)
[42949526.030000] [<c000878c>] (start_kernel+0x0/0x2a4) from
[<00008034>] (0x8034)
[42949526.030000]  r6:c00201bc r5:c033f76c r4:000039fd
[42949526.030000] Code: 9a000001 e15c0003 3a00000a e3a03000 (e5833000)
[42949526.040000] Kernel panic - not syncing: Fatal exception in interrupt


Thanks,

karl
