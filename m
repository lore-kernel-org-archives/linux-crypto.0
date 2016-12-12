From: "Zhang Zhuoyu" <zhangzhuoyu@cmss.chinamobile.com>
Subject: kernel crash when using sha1 as csums-alg for drbd
Date: Mon, 12 Dec 2016 11:31:23 +0800
Message-ID: <011e01d25428$36df6200$a49e2600$@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <marex@denx.de>, <hpa@linux.intel.com>,
        <herbert@gondor.apana.org.au>,
        "'lixiubo'" <lixiubo@cmss.chinamobile.com>,
        <linux-crypto@vger.kernel.org>
To: <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:19746 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbcLLDb1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Dec 2016 22:31:27 -0500
Content-Language: en-us
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, Chandramouli

Sorry for last email. 

These days we experienced 5 times kernel crash issue when using sha1 as
csums-alg for drbd on our CentOS7.2  3.10.0-327.el7.x86_64:

Kernel log as below:
[19839335.792807] BUG: unable to handle kernel paging request at
ffff88007bd4f000
[19839335.793145] IP: [<ffffffff8106a908>] _begin+0x28/0x187
[19839335.793326] PGD 1f32067 PUD 607ffff067 PMD 1f35067 PTE 0 
[19839335.793510] Oops: 0000 [#1] SMP 
[19839335.793683] Modules linked in: dm_service_time iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi nf_conntrack_netlink nf_conntrack_ipv6
nf_defrag_ipv6 xt_mac xt_set xt_physdev xt_CT ip_set_hash_net ip_set
nfnetlink vhost_net vhost macvtap macvlan veth iptable_raw iptable_filter
iptable_nat nf_nat_ipv4 iptable_mangle ip_tables dm_multipath ip6table_raw
vport_vxlan vxlan ip6_udp_tunnel udp_tunnel openvswitch xt_multiport
ipmi_devintf xt_comment ext4 mbcache jbd2 xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack ipt_REJECT tun bridge ebtable_filter ebtables ip6table_filter
ip6_tables drbd(OE) 8021q garp stp mrp llc bonding dm_mirror dm_region_hash
dm_log iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp intel_rapl
kvm_intel kvm
[19839335.795640]  crc32_pclmul dm_mod ghash_clmulni_intel aesni_intel lrw
gf128mul glue_helper ablk_helper cryptd pcspkr ses ipmi_ssif enclosure sg
sb_edac edac_core lpc_ich mei_me i2c_i801 mfd_core mei ioatdma shpchp wmi
ipmi_si ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl
lockd grace sunrpc xfs libcrc32c sd_mod crc_t10dif crct10dif_generic
syscopyarea sysfillrect sysimgblt crct10dif_pclmul crct10dif_common
crc32c_intel drm_kms_helper ttm ixgbe drm igb mdio ptp mpt3sas pps_core
i2c_algo_bit raid_class dca i2c_core scsi_transport_sas [last unloaded:
ip_tables][19839335.797216] CPU: 1 PID: 2912 Comm: drbd_w_drbd1 Tainted: G
OE  ------------   3.10.0-327.el7.x86_64 #1                              
[19839335.797550] Hardware name: Inspur NF5280M4/YZMB-00326-101, BIOS 4.0.18
11/09/2015
[19839335.797877] task: ffff885f749b9700 ti: ffff882f62fc4000 task.ti:
ffff882f62fc4000
[19839335.798203] RIP: 0010:[<ffffffff8106a908>]  [<ffffffff8106a908>]
_begin+0x28/0x187
[19839335.798532] RSP: 0018:ffff882f62fc75f8  EFLAGS: 00010202
[19839335.798702] RAX: 000000002fced277 RBX: 00000000e9cee1cc RCX:
00000000a73b8733
[19839335.799030] RDX: 00000000b573ac7c RSI: 00000000bb6b5097 RDI:
00000000da4f4b14
[19839335.799356] RBP: 0000000058444804 R08: ffffffff81656100 R09:
ffff882f33147998
[19839335.799680] R10: ffff88007bd4ef80 R11: ffff88007bd4f040 R12:
00000000e770e674
[19839335.800010] R13: ffff88007bd4efc0 R14: ffff882f62fc75f8 R15:
ffff882f62fc7898
[19839335.800336] FS:  0000000000000000(0000) GS:ffff882fbf840000(0000)
knlGS:0000000000000000
[19839335.800664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19839335.800835] CR2: ffff88007bd4f000 CR3: 000000000194a000 CR4:
00000000001427e0
[19839335.801160] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[19839335.801486] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[19839335.801812] Stack:
[19839335.801974]  5a8279995a827999 5a8279995a827999 5a8279995a827999
5a8279995a827999
[19839335.802317]  5a8279995a827999 5a8279995a827999 5a8279995a827999
5a8279995a827999
[19839335.802663]  5a8279995a827999 5a8279995a827999 5a8279995a827999
5a8279995a827999
[19839335.803005] Call Trace:
[19839335.803180]  [<ffffffff81569a41>] ? ip_local_out_sk+0x31/0x40
[19839335.803355]  [<ffffffff8106a31d>] ?
sha1_apply_transform_avx2+0x1d/0x30
[19839335.803530]  [<ffffffff8106a063>] ? __sha1_ssse3_update+0x53/0xd0
[19839335.803704]  [<ffffffff8106a388>] ? sha1_ssse3_update+0x58/0xf0
[19839335.803881]  [<ffffffff812b1878>] ? crypto_shash_update+0x38/0x100
[19839335.804056]  [<ffffffff812b1d6e>] ? shash_compat_update+0x4e/0x80
[19839335.804242]  [<ffffffffa05245ab>] ? drbd_csum_bio+0x9b/0xe0 [drbd]
[19839335.804427]  [<ffffffffa0546701>] ? drbd_send_dblock+0x3b1/0x480
[drbd]
[19839335.804608]  [<ffffffffa0522a80>] ? dequeue_work_batch+0x20/0x90
[drbd]
[19839335.804788]  [<ffffffffa0522d37>] ? wait_for_work+0x67/0x370 [drbd]
[19839335.804969]  [<ffffffffa052726f>] ? w_send_dblock+0xaf/0x1d0 [drbd]
[19839335.805168]  [<ffffffffa052867b>] ? drbd_worker+0xfb/0x390 [drbd]
[19839335.805349]  [<ffffffffa0542430>] ?
drbd_destroy_connection+0x160/0x160 [drbd]
[19839335.805684]  [<ffffffffa054244d>] ? drbd_thread_setup+0x1d/0x110
[drbd]
[19839335.805864]  [<ffffffffa0542430>] ?
drbd_destroy_connection+0x160/0x160 [drbd]
[19839335.806195]  [<ffffffff810a5aef>] ? kthread+0xcf/0xe0
[19839335.806367]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[19839335.806545]  [<ffffffff81645858>] ? ret_from_fork+0x58/0x90
[19839335.806717]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[19839335.806889] Code: 00 00 00 89 f3 c4 e3 7b f0 f6 02 c4 e2 60 f2 e8 21
fb 31 eb 41 03 17 c4 e2 70 f2 ef 8d 14 1a c4 63 7b f0 e1 1b c4 e3 7b f0 d9
02 <c4> c1 7a 6f 82 80 00 00 00 21 f1 31 e9 42 8d 14 22 41 03 47 04 
[19839335.807640] RIP  [<ffffffff8106a908>] _begin+0x28/0x187
[19839335.807814]  RSP <ffff882f62fc75f8>
[19839335.807979] CR2: ffff88007bd4f000     

We debug it by using crash:

crash> bt
PID: 2912   TASK: ffff885f749b9700  CPU: 1   COMMAND: "drbd_w_drbd1"
#0 [ffff882f62fc72c0] machine_kexec at ffffffff81051beb
#1 [ffff882f62fc7320] crash_kexec at ffffffff810f2542
#2 [ffff882f62fc73f0] oops_end at ffffffff8163e1a8
#3 [ffff882f62fc7418] no_context at ffffffff8162e2b8
#4 [ffff882f62fc7468] __bad_area_nosemaphore at ffffffff8162e34e
#5 [ffff882f62fc74b0] bad_area_nosemaphore at ffffffff8162e4b8
#6 [ffff882f62fc74c0] __do_page_fault at ffffffff81640fce
#7 [ffff882f62fc7518] do_page_fault at ffffffff81641113
#8 [ffff882f62fc7540] page_fault at ffffffff8163d408
    [exception RIP: _begin+40]
    RIP: ffffffff8106a908  RSP: ffff882f62fc75f8  RFLAGS: 00010202
    RAX: 000000002fced277  RBX: 00000000e9cee1cc  RCX: 00000000a73b8733
    RDX: 00000000b573ac7c  RSI: 00000000bb6b5097  RDI: 00000000da4f4b14
    RBP: 0000000058444804   R8: ffffffff81656100   R9: ffff882f33147998
    R10: ffff88007bd4ef80  R11: ffff88007bd4f040  R12: 00000000e770e674
    R13: ffff88007bd4efc0  R14: ffff882f62fc75f8  R15: ffff882f62fc7898
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
#9 [ffff882f62fc7878] ip_local_out_sk at ffffffff81569a41
#10 [ffff882f62fc7ba8] sha1_apply_transform_avx2 at ffffffff8106a31d
#11 [ffff882f62fc7bb8] __sha1_ssse3_update at ffffffff8106a063
#12 [ffff882f62fc7bf8] sha1_ssse3_update at ffffffff8106a388
#13 [ffff882f62fc7c28] crypto_shash_update at ffffffff812b1878
#14 [ffff882f62fc7c78] shash_compat_update at ffffffff812b1d6e
#15 [ffff882f62fc7cc8] drbd_csum_bio at ffffffffa05245ab [drbd]
#16 [ffff882f62fc7d28] drbd_send_dblock at ffffffffa0546701 [drbd]
#17 [ffff882f62fc7de0] w_send_dblock at ffffffffa052726f [drbd]
#18 [ffff882f62fc7e28] drbd_worker at ffffffffa052867b [drbd]
#19 [ffff882f62fc7e98] drbd_thread_setup at ffffffffa054244d [drbd]
#20 [ffff882f62fc7ec8] kthread at ffffffff810a5aef
#21 [ffff882f62fc7f50] ret_from_fork at ffffffff81645858

crash> dis -l ffffffff8106a908
/usr/src/debug/kernel-3.10.0-327.el7/linux-3.10.0-327.el7.x86_64/arch/x86/cr
ypto/sha1_avx2_x86_64_asm.S: 677
0xffffffff8106a908 <_begin+40>: vmovdqu 0x80(%r10),%xmm0

crash> dis -l _begin
/usr/src/debug/kernel-3.10.0-327.el7/linux-3.10.0-327.el7.x86_64/arch/x86/cr
ypto/sha1_avx2_x86_64_asm.S: 677
0xffffffff8106a8e0 <_begin>:    mov    %esi,%ebx
0xffffffff8106a8e2 <_begin+2>:  rorx   $0x2,%esi,%esi
0xffffffff8106a8e8 <_begin+8>:  andn   %eax,%ebx,%ebp
0xffffffff8106a8ed <_begin+13>: and    %edi,%ebx
0xffffffff8106a8ef <_begin+15>: xor    %ebp,%ebx
0xffffffff8106a8f1 <_begin+17>: add    (%r15),%edx
0xffffffff8106a8f4 <_begin+20>: andn   %edi,%ecx,%ebp
0xffffffff8106a8f9 <_begin+25>: lea    (%rdx,%rbx,1),%edx
0xffffffff8106a8fc <_begin+28>: rorx   $0x1b,%ecx,%r12d
0xffffffff8106a902 <_begin+34>: rorx   $0x2,%ecx,%ebx
0xffffffff8106a908 <_begin+40>: vmovdqu 0x80(%r10),%xmm0
<--------------- crash here
0xffffffff8106a911 <_begin+49>: and    %esi,%ecx
0xffffffff8106a913 <_begin+51>: xor    %ebp,%ecx
0xffffffff8106a915 <_begin+53>: lea    (%rdx,%r12,1),%edx
0xffffffff8106a919 <_begin+57>: add    0x4(%r15),%eax
0xffffffff8106a91d <_begin+61>: andn   %esi,%edx,%ebp
0xffffffff8106a922 <_begin+66>: lea    (%rax,%rcx,1),%eax
0xffffffff8106a925 <_begin+69>: rorx   $0x1b,%edx,%r12d
0xffffffff8106a92b <_begin+75>: rorx   $0x2,%edx,%ecx
0xffffffff8106a931 <_begin+81>: vinsertf128 $0x1,0x80(%r13),%ymm0,%ymm0
0xffffffff8106a93b <_begin+91>: and    %ebx,%edx
0xffffffff8106a93d <_begin+93>: xor    %ebp,%edx
0xffffffff8106a93f <_begin+95>: lea    (%rax,%r12,1),%eax
0xffffffff8106a943 <_begin+99>: add    0x8(%r15),%edi

It crashed at arch/x86/crypto/sha1_avx2_x86_64_asm.S, and according to the
stack trace, I deduced some useful information:

crash> struct -x sha1_state 0xffff882f33147990
struct sha1_state {
  count = 0x4e000, 
  state = {0xa73b8733, 0xedad425e, 0xda4f4b14, 0x2fced277, 0x90a160ae}, 
  buffer =
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00
0\000\000\000\000\000\000"
}


crash> rd ffff882f62fc7c78 24
ffff882f62fc7c78:  ffffffff812b1d6e ffff88007bd4e000   n.+........{....
ffff882f62fc7c88:  0000000000000000 ffffea0001ef5380   .........S......
ffff882f62fc7c98:  0000000000000000 ffff882f62fc7ce0   .........|.b/...
ffff882f62fc7ca8:  ffffffff00000000 00000000f6275b17   .........['.....
ffff882f62fc7cb8:  000000000000004e ffff882f62fc7d20   N....... }.b/...
ffff882f62fc7cc8:  ffffffffa05245ab ffff885f66044120   .ER..... A.f_...
ffff882f62fc7cd8:  ffff882f00000000 ffffea0001ef5382   ..../....S......
ffff882f62fc7ce8:  0000100000000000 0000000000000000   ................
ffff882f62fc7cf8:  0000000000000000 00000000f6275b17   .........['.....
ffff882f62fc7d08:  ffff882f73c0a000 ffff880111b94540   ...s/...@E......
ffff882f62fc7d18:  ffff882f6aff0010 ffff882f62fc7dd8   ...j/....}.b/...
ffff882f62fc7d28:  ffffffffa0546701 0000000000000000   .gT.............
crash> 
crash> struct hash_desc ffff882f62fc7cd0
struct hash_desc {
  tfm = 0xffff885f66044120, 
  flags = 0
}
crash> struct scatterlist ffff882f62fc7ce0
struct scatterlist {
  page_link = 18446719884486202242, 
  offset = 0, 
  length = 4096, 
  dma_address = 0, 
  dma_length = 0
}

crash> rd ffff882f62fc7c28 22
ffff882f62fc7c28:  ffffffff812b1878 ffff882f33147980   x.+......y.3/...
ffff882f62fc7c38:  ffff882f6aff0028 ffff882ae84cd500   (..j/.....L.*...
ffff882f62fc7c48:  ffff882f33147980 ffff882f6aff0028   .y.3/...(..j/...
ffff882f62fc7c58:  ffff882ae84cd500 ffff882f70846800   ..L.*....h.p/...
ffff882f62fc7c68:  ffff885f738a12a0 ffff882f62fc7cc0   ...s_....|.b/...
ffff882f62fc7c78:  ffffffff812b1d6e ffff88007bd4e000   n.+........{....
ffff882f62fc7c88:  0000000000000000 ffffea0001ef5380   .........S......
ffff882f62fc7c98:  0000000000000000 ffff882f62fc7ce0   .........|.b/...
ffff882f62fc7ca8:  ffffffff00000000 00000000f6275b17   .........['.....
ffff882f62fc7cb8:  000000000000004e ffff882f62fc7d20   N....... }.b/...
ffff882f62fc7cc8:  ffffffffa05245ab ffff885f66044120   .ER..... A.f_...
crash> 
crash> 
crash> 
crash> struct crypto_hash_walk ffff882f62fc7c80
struct crypto_hash_walk {
  data = 0xffff88007bd4e000 struct: page excluded: kernel virtual address:
ffff88007bd4e000  type: "gdb_readmem_callback"
struct: page excluded: kernel virtual address: ffff88007bd4e000  type:
"gdb_readmem_callback"
<Address 0xffff88007bd4e000 out of bounds>, 
  offset = 0, 
  alignmask = 0, 
  pg = 0xffffea0001ef5380, 
  entrylen = 0, 
  total = 0, 
  sg = 0xffff882f62fc7ce0, 
  flags = 0
}

According to the above information, after call shash_compat_update and, we
got one page sized 4k after kmap, which started at virtual address
0xffff88007bd4e000. 
So, the value pass to void sha1_transform_avx2(int *hash, const char* data,
size_t num_blocks ); data = 0xffff88007bd4e000, rounds = 64, which means we
have 64 blocks(4k) to handle.
But the BUFFER_END we calculated out in sha1_avx2_x86_64_asm.S is rounds <<6
+ data + 64 = 64 <<6 + 0xffff88007bd4e000 + 64 = 0xffff88007bd4f040 which
exceed one page.
I think maybe it is the reason why we got the "BUG: unable to handle kernel
paging request at ffff88007bd4f000".
I am not so familiar with the sha1 algorithm, so I email you for your kindly
help, can you give me some suggestion on this issue?



Sincerely

Zhuoyu
