From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Fwd: crypto accelerator driver problems
Date: Tue, 21 Dec 2010 15:43:18 +0330
Message-ID: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
References: <AANLkTikdiSbQ_hAAfQC2P1hFiFAE8Wr5T+O2o1Yts6wH@mail.gmail.com>
 <AANLkTikSfb1W21NxQJ0JzMWX7sqg-2D6HAJpfXTNNAHR@mail.gmail.com> <AANLkTimiZdBMnnc1PqMDEi-FmNuisSj1FcyMfDVS_g2z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:59678 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0LUMNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Dec 2010 07:13:40 -0500
Received: by gxk19 with SMTP id 19so2187056gxk.11
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2010 04:13:39 -0800 (PST)
In-Reply-To: <AANLkTimiZdBMnnc1PqMDEi-FmNuisSj1FcyMfDVS_g2z@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

As some good news and additional information, with the following patch
I no more get
"UDP bad cheksum" error as I mentioned erlier with Iperf in udp mode.
But some times I get the following call trace in dmesg after running
Iperf in UDP mode, more than one time (and ofcourse Iperf stops
transferring data while it uses 100% of CPU cycles.



[  130.171909] mydriver-aes: mydriver Crypto-Engine enabled.
[  134.767846] NET: Registered protocol family 15
[  200.031846] iperf: page allocation failure. order:0, mode:0x20
[  200.031850] Pid: 10935, comm: iperf Tainted: P            2.6.36-zen=
1 #1
[  200.031852] Call Trace:
[  200.031860]  [<ffffffff8108ab39>] ? __alloc_pages_nodemask+0x6d3/0x7=
22
[  200.031864]  [<ffffffff810b454f>] ? virt_to_head_page+0x9/0x30
[  200.031867]  [<ffffffff810afac2>] ? alloc_pages_current+0xa5/0xce
[  200.031869]  [<ffffffff810899ad>] ? __get_free_pages+0x9/0x46
[  200.031872]  [<ffffffff8102bbbf>] ? need_resched+0x1a/0x23
[  200.031876]  [<ffffffff811a10ad>] ? blkcipher_walk_next+0x68/0x2d9
[  200.031882]  [<ffffffffa001dad4>] ? mydriver_cbc_encrypt+0x47/0x9c
[mydriver_aes2]
[  200.031886]  [<ffffffff81454789>] ? ipt_do_table+0x5d8/0x619
[  200.031888]  [<ffffffff811a0871>] ? async_encrypt+0x35/0x3a
[  200.031891]  [<ffffffff811a1e0c>] ? eseqiv_givencrypt+0x341/0x389
[  200.031894]  [<ffffffff813b8bb5>] ? __skb_to_sgvec+0x49/0x1ea
[  200.031897]  [<ffffffff813b8d1e>] ? __skb_to_sgvec+0x1b2/0x1ea
[  200.031899]  [<ffffffff811a8fc8>] ? crypto_authenc_givencrypt+0x60/0=
x7c
[  200.031902]  [<ffffffff814492dd>] ? esp_output+0x320/0x357
[  200.031905]  [<ffffffff814658cd>] ? xfrm_output_resume+0x38d/0x48f
[  200.031908]  [<ffffffff813e1f62>] ? nf_hook_slow+0xc8/0xd9
[  200.031911]  [<ffffffff81416f9f>] ? ip_push_pending_frames+0x2cc/0x3=
28
[  200.031914]  [<ffffffff8143339e>] ? udp_push_pending_frames+0x2c4/0x=
342
[  200.031917]  [<ffffffff814350ca>] ? udp_sendmsg+0x508/0x600
[  200.031919]  [<ffffffff8102bbbf>] ? need_resched+0x1a/0x23
[  200.031923]  [<ffffffff813b3458>] ? sock_aio_write+0xd5/0xe9
[  200.031926]  [<ffffffff8100340e>] ? apic_timer_interrupt+0xe/0x20
[  200.031928]  [<ffffffff810ba2ea>] ? do_sync_write+0xb0/0xf2
[  200.031931]  [<ffffffff8100864b>] ? sched_clock+0x5/0x8
[  200.031934]  [<ffffffff8119c550>] ? security_file_permission+0x18/0x=
67
[  200.031937]  [<ffffffff810bac07>] ? vfs_write+0xbc/0x101
[  200.031939]  [<ffffffff810bad08>] ? sys_write+0x45/0x6e
[  200.031941]  [<ffffffff81002a42>] ? system_call_fastpath+0x16/0x1b
[  200.031942] Mem-Info:
[  200.031944] Node 0 DMA per-cpu:
[  200.031946] CPU    0: hi:    0, btch:   1 usd:   0
[  200.031947] CPU    1: hi:    0, btch:   1 usd:   0
[  200.031949] CPU    2: hi:    0, btch:   1 usd:   0
[  200.031950] CPU    3: hi:    0, btch:   1 usd:   0
[  200.031951] Node 0 DMA32 per-cpu:
[  200.031953] CPU    0: hi:  186, btch:  31 usd:  30
[  200.032016] CPU    1: hi:  186, btch:  31 usd:  23
[  200.032018] CPU    2: hi:  186, btch:  31 usd: 182
[  200.032019] CPU    3: hi:  186, btch:  31 usd: 171
[  200.032023] active_anon:248219 inactive_anon:82742 isolated_anon:7
[  200.032024]  active_file:10553 inactive_file:11106 isolated_file:27
[  200.032025]  unevictable:0 dirty:19 writeback:1881 unstable:0
[  200.032026]  free:2536 slab_reclaimable:2970 slab_unreclaimable:6490
[  200.032026]  mapped:19597 shmem:292 pagetables:12316 bounce:0
[  200.032028] Node 0 DMA free:8012kB min:40kB low:48kB high:60kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15768kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[  200.032036] lowmem_reserve[]: 0 2002 2002 2002
[  200.032039] Node 0 DMA32 free:2132kB min:5704kB low:7128kB
high:8556kB active_anon:992876kB inactive_anon:330968kB
active_file:42212kB inactive_file:44424kB unevictable:0kB
isolated(anon):28kB isolated(file):108kB present:2050992kB mlocked:0kB
dirty:76kB writeback:7524kB mapped:78388kB shmem:1168kB
slab_reclaimable:11880kB slab_unreclaimable:25944kB
kernel_stack:2320kB pagetables:49264kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  200.032050] lowmem_reserve[]: 0 0 0 0
[  200.032059] Node 0 DMA: 1*4kB 1*8kB 0*16kB 0*32kB 1*64kB 0*128kB
1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB =3D 8012kB
[  200.032066] Node 0 DMA32: 1*4kB 0*8kB 1*16kB 0*32kB 1*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 2132kB
[  200.032072] 37527 total pagecache pages
[  200.032074] 15549 pages in swap cache
[  200.032075] Swap cache stats: add 72816, delete 57267, find 8267/847=
7
[  200.032076] Free swap  =3D 3832196kB
[  200.032078] Total swap =3D 4096568kB
[  200.040499] 523951 pages RAM
[  200.040501] 9684 pages reserved
[  200.040502] 231120 pages shared
[  200.040503] 486710 pages non-shared
[  200.040514] BUG: unable to handle kernel NULL pointer dereference at=
 (null)
[  200.040517] IP: [<ffffffffa001d395>] mydriver_transform+0x1a3/0x6a8
[mydriver_aes2]
[  200.040523] PGD 7c3dd067 PUD 41dc067 PMD 0
[  200.040526] Oops: 0000 [#1] PREEMPT SMP
[  200.040528] last sysfs file: /sys/devices/virtual/misc/fuse/dev
[  200.040530] CPU 0
[  200.040531] Modules linked in: ctr twofish_generic twofish_x86_64
twofish_common camellia serpent blowfish cast5 xcbc rmd160
sha512_generic sha256_generic crypto_null af_key mydriver_aes2 fuse
nvidia(P) r8169 iTCO_wdt iTCO_vendor_support
[  200.040542]
[  200.040544] Pid: 10935, comm: iperf Tainted: P
2.6.36-zen1 #1 EP45-UD3P/EP45-UD3P
[  200.040546] RIP: 0010:[<ffffffffa001d395>]  [<ffffffffa001d395>]
mydriver_transform+0x1a3/0x6a8 [mydriver_aes2]
[  200.040550] RSP: 0018:ffff880072c5b898  EFLAGS: 00010246
[  200.040551] RAX: ffff880055a3a030 RBX: 0000000000000680 RCX: 0000000=
0000005f0
[  200.040553] RDX: 0000000000000680 RSI: 0000000000000000 RDI: ffff880=
055a3a030
[  200.040555] RBP: 0000000000000000 R08: 0000000000000680 R09: 0000000=
000000018
[  200.040556] R10: 000000007d078004 R11: 0000000000013234 R12: 0000000=
000000010
[  200.040558] R13: 0000000000000004 R14: 00000000eaef0000 R15: 0000000=
0000005f0
[  200.040561] FS:  0000000041767950(0063) GS:ffff880001a00000(0000)
knlGS:0000000000000000
[  200.040562] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  200.040564] CR2: 0000000000000000 CR3: 000000007409d000 CR4: 0000000=
0000406f0
[  200.040566] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  200.040568] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  200.040570] Process iperf (pid: 10935, threadinfo ffff880072c5a000,
task ffff880006d09000)
[  200.040571] Stack:
[  200.040572]  ffff880006d09000 0000000000000000 ffffffff817854f0
0000000000000020
[  200.040574] <0> 0000000000000000 0000efea72c5b9e8 ffff88007d4a7c58
00000001810afac2
[  200.040577] <0> 0000000000000000 ffff88004d53dc00 ffff880072c5b901
000000000000000f
[  200.040580] Call Trace:
[  200.040585]  [<ffffffff8102bbbf>] ? need_resched+0x1a/0x23
[  200.040588]  [<ffffffffa001db0b>] ? mydriver_cbc_encrypt+0x7e/0x9c
[mydriver_aes2]
[  200.040592]  [<ffffffff811a0871>] ? async_encrypt+0x35/0x3a
[  200.040595]  [<ffffffff811a1e0c>] ? eseqiv_givencrypt+0x341/0x389
[  200.040598]  [<ffffffff813b8bb5>] ? __skb_to_sgvec+0x49/0x1ea
[  200.040600]  [<ffffffff813b8d1e>] ? __skb_to_sgvec+0x1b2/0x1ea
[  200.040603]  [<ffffffff811a8fc8>] ? crypto_authenc_givencrypt+0x60/0=
x7c
[  200.040607]  [<ffffffff814492dd>] ? esp_output+0x320/0x357
[  200.040610]  [<ffffffff814658cd>] ? xfrm_output_resume+0x38d/0x48f
[  200.040613]  [<ffffffff813e1f62>] ? nf_hook_slow+0xc8/0xd9
[  200.040616]  [<ffffffff81416f9f>] ? ip_push_pending_frames+0x2cc/0x3=
28
[  200.040619]  [<ffffffff8143339e>] ? udp_push_pending_frames+0x2c4/0x=
342
[  200.040621]  [<ffffffff814350ca>] ? udp_sendmsg+0x508/0x600
[  200.040623]  [<ffffffff8102bbbf>] ? need_resched+0x1a/0x23
[  200.040627]  [<ffffffff813b3458>] ? sock_aio_write+0xd5/0xe9
[  200.040630]  [<ffffffff8100340e>] ? apic_timer_interrupt+0xe/0x20
[  200.040633]  [<ffffffff810ba2ea>] ? do_sync_write+0xb0/0xf2
[  200.040636]  [<ffffffff8100864b>] ? sched_clock+0x5/0x8
[  200.040639]  [<ffffffff8119c550>] ? security_file_permission+0x18/0x=
67
[  200.040641]  [<ffffffff810bac07>] ? vfs_write+0xbc/0x101
[  200.040643]  [<ffffffff810bad08>] ? sys_write+0x45/0x6e
[  200.040646]  [<ffffffff81002a42>] ? system_call_fastpath+0x16/0x1b
[  200.040647] Code: 83 c0 08 80 7c 24 50 01 75 10 48 89 c7 49 63 cc
48 8b 74 24 48 f3 a4 48 89 f8 48 89 c7 48 8b 74 24 40 41 0f b7 d8 49
63 cf 89 da <f3> a4 4c 8b 2d 62 1d 00 00 48 8b 3d 53 1d 00 00 b1 01 48
8b 74
[  200.040668] RIP  [<ffffffffa001d395>]
mydriver_transform+0x1a3/0x6a8 [mydriver_aes2]
[  200.040671]  RSP <ffff880072c5b898>
[  200.040672] CR2: 0000000000000000
[  200.040733] ---[ end trace ae2865df0a025f7d ]---
[  221.687773] SysRq : Emergency Sync



BUT Iperf in TCP mode has its own problems yet ( the system freezes
with no response ).

Thank in advance,
Hamid.


--- mydriver1	2010-12-21 15:20:17.000000000 +0330
+++ mydriver2	2010-12-21 15:24:18.000000000 +0330
@@ -1,4 +1,3 @@
-
 static int
 mydriver_cbc_decrypt(struct blkcipher_desc *desc,
 		  struct scatterlist *dst, struct scatterlist *src,
@@ -14,18 +13,17 @@ mydriver_cbc_decrypt(struct blkcipher_desc
 	err =3D blkcipher_walk_virt(desc, &walk);
 	op->iv =3D walk.iv;
 =09
-	while((nbytes =3D walk.nbytes)) {
+=09
 		op->src =3D walk.src.virt.addr,
 		op->dst =3D walk.dst.virt.addr;
 		op->mode =3D AES_MODE_CBC;
-		op->len =3D nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len =3D nbytes;
 		op->dir =3D AES_DIR_DECRYPT;
-	=09
 		ret =3D mydriver_transform(op, 0);

 		nbytes -=3D ret;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
-	}
+=09

 	return err;
 }
@@ -45,16 +43,17 @@ mydriver_cbc_encrypt(struct blkcipher_desc
 	err =3D blkcipher_walk_virt(desc, &walk);
 	op->iv =3D walk.iv;
 =09
-	while((nbytes =3D walk.nbytes)) {
+=09
 		op->src =3D walk.src.virt.addr,
 		op->dst =3D walk.dst.virt.addr;
 		op->mode =3D AES_MODE_CBC;
-		op->len =3D nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len =3D nbytes;
 		op->dir =3D AES_DIR_ENCRYPT;
 		ret =3D mydriver_transform(op, 0);
 		nbytes -=3D ret;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
-	}
+=09

 	return err;
 }
+

---------- Forwarded message ----------
=46rom: Hamid Nassiby <h.nassiby@gmail.com>
Date: Sun, Dec 19, 2010 at 4:28 PM
Subject: crypto accelerator driver problems
To: linux-crypto@vger.kernel.org


Hi All,

In a research project, we've developed a crypto accelerator based on Xi=
linx
Virtex5 FPGA family which=C2=A0is connected to PC through PCI-Express s=
lot and is
used by IPSec to offload crypto processing from=C2=A0CPU. The accelerat=
or only
provides AES and DES3_EDE algorithms and I am responsible for providing=
 driver
of the stuff. I inspired much of driver work from geode_aes.c which is
located in "drivers/crypto" subdir of kernel source directory. Both alg=
orithms
are registered as blkcipher providing cbc wrapper "cbc(aes)" just as on=
e that is
registered in geode_aes. Now after months of work, the accelerator is r=
eady to
work (Correctness of hardware operation is assured by direct crypto
test and not by IPSec) and it is time of driver to provide IPSec
access to accelerator. In first
try I could get =C2=A0"ping" through the IPsec tunnel. One end of IPSec=
 tunnel is
equipped by our accelerator and the other end is using kernel native IP=
Sec and
built in AES and DES3_EDE algorithms. Now I am faced with 2 problems:

1. Ping will stop getting reply with packet sizes greater than 1426 Byt=
es
(ping dest_ip -s =C2=A01427). I guessed that it might be MTU problem, b=
ut reducing
mtu with "ifconfig eth1 mtu xxx" or
"echo 1 > /proc/sys/net/ipv4/ip_no_pmtu_disc"
=C2=A0does not solve the problem. Also when I ping each of tunnel ends =
from
another end
simultaneously with "ping other_node_ip=C2=A0 -i 0.001", the kernel han=
gs
out completely.

2. Iperf problem. When I try to measure throughput of the IPSec gateway=
 equipped
by our accelerator ( AES-MD5 ), using iperf in tcp mode, the kernel han=
gs such
that sometimes "Magic SysRq key" does not respond too! And so I could n=
ot trace
the problem anyway. Using iperf in udp mode works but I get "UDP bad ch=
eksum" in
'dmesg' output of other end of tunnel (Native IPSec and built in kernel
algorithms).

Two gateways are connected by a cross cable and no router/switch is loc=
ated
between them to cause mtu problems. In my test pcrypt is not used by no=
w and
booting the kernel with nosmp (so no fear of thread contention) does no=
t change
the situation.

So I request you to help me solve the problem. I bring some parts of dr=
iver
that is changed from geode_aes.c and might give useful information. If
it is required,
I'll post all driver text.
------------------------------ ----------------------------

static struct crypto_alg mydriver_cbc_alg =3D {
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 "cbc(aes)",
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_driver_name =C2=A0 =C2=A0 =C2=A0 =C2=A0=
=3D =C2=A0 =C2=A0 =C2=A0 "cbc-aes-mydriver",
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_priority =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D =C2=A0 =C2=A0 =C2=A0 400,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_flags =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 CRYP=
TO_ALG_TYPE_BLKCIPHER |

CRYPTO_ALG_NEED_FALLBACK,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_init =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 fal=
lback_init_blk,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_exit =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 fal=
lback_exit_blk,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_blocksize =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D =C2=A0 =C2=A0 =C2=A0 AES_MIN_BLOCK_SIZE,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_ctxsize =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 sizeof(struct mydriver_aes_op),
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_alignmask =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D =C2=A0 =C2=A0 =C2=A0 15,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_type =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 &cr=
ypto_blkcipher_type,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_module =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 THIS_MODUL=
E,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_list =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D
LIST_HEAD_INIT(mydriver_cbc_alg.cra_list),
=C2=A0 =C2=A0 =C2=A0 =C2=A0.cra_u =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=
=A0 {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.blkcipher =C2=A0=
 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.min_keysize =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 AES_MIN_KE=
Y_SIZE,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.max_keysize =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 AES_MIN_KE=
Y_SIZE,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.setkey =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D =C2=A0 =C2=A0 =C2=A0 mydriver_setkey_blk,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.encrypt =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D =C2=A0 =C2=A0 =C2=A0 mydriver_cbc_encrypt,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.decrypt =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D =C2=A0 =C2=A0 =C2=A0 mydriver_cbc_decrypt,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.ivsize =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D =C2=A0 =C2=A0 =C2=A0 AES_IV_LENGTH,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0}
};
//---------------
static int
mydriver_cbc_encrypt(struct blkcipher_desc *desc,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct sc=
atterlist *dst, struct scatterlist *src,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned =
int nbytes)
{

=C2=A0 =C2=A0 =C2=A0 =C2=A0struct mydriver_aes_op *op =3D crypto_blkcip=
her_ctx(desc->tfm);
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct blkcipher_walk walk;
=C2=A0 =C2=A0 =C2=A0 =C2=A0int err, ret;

=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(op->keylen !=3D AES_KEYSIZE_128=
))
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return fallback_=
blk_enc(desc, dst, src, nbytes);

=C2=A0 =C2=A0 =C2=A0 =C2=A0blkcipher_walk_init(&walk, dst, src, nbytes)=
;
=C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D blkcipher_walk_virt(desc, &walk);
=C2=A0 =C2=A0 =C2=A0 =C2=A0op->iv =3D walk.iv;

=C2=A0 =C2=A0 =C2=A0 =C2=A0while((nbytes =3D walk.nbytes)) {

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op->src =3D walk=
=2Esrc.virt.addr,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op->dst =3D walk=
=2Edst.virt.addr;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op->mode =3D AES=
_MODE_CBC;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op->len =3D nbyt=
es - (nbytes % AES_MIN_BLOCK_SIZE);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op->dir =3D AES_=
DIR_ENCRYPT;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0//ret =3D mydriver_aes_crypt(op);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D mydriver=
_transform(op, 0);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nbytes -=3D ret;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D blkciphe=
r_walk_done(desc, &walk, nbytes);
=C2=A0 =C2=A0 =C2=A0 =C2=A0}

=C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
}
/*--------- mydriver_transform which makes a buffer containing key, iv,=
 data
with
some additional header that is required by our accelerator, writes the =
buffer
to accelerator by DMA and then reads response from hardware.*/

static inline int mydriver_transform(struct mydriver_aes_op *op, int al=
g)
{

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0req_le=
n, err;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *req_buf =3D =
NULL, *res_buf =3D NULL;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0alg_operation op=
eration;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 my_req_id;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (op->len =3D=3D=
 0)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return 0;

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((op->dir =3D=
=3D AES_DIR_ENCRYPT) ||(op->dir =3D=3D
DES3_DIR_ENCRYPT)){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 operation =3D SH_ENCRYPT;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 my_req_id =3D smp_processor_id();// This ID is
put into our packet and is checked by each thread when the hardware
response is ready to see if the packet is its?
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0operation =3D SH_DECRYPT;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0my_req_id =3D smp_processor_id() + 64;
//uniqueness of ID does not solve problem described in mail :( .
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}



=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D create_r=
equest(alg, op->mode, operation, htonl(my_req_id),
op->key, op->iv, op->src, op->len, &req_buf, &req_len);


=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0printk(KERN_EMERG"mydriver_transform : Error
CreateReuest :
errcode =3D %d\n", err);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0//goto error;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D write_re=
quest(req_buf, req_len);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0printk(KERN_EMERG"mydriver_transform : Error WriteReuest
:
errcode =3D %d\n", err);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0//goto error;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(req_buf);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req_buf =3D NULL=
;

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D read_res=
ponse(&res_buf, /*local_hdr.Length*/my_req_id);

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(op->dst, =
(res_buf + sizeof(struct response_hdr)),
op->len);

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(res_buf);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res_buf =3D NULL=
;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return op->len;
}
//-----------
/* create_request wich builds packet for mydriver_transform */
static inline int create_request(int alg, char mode, char enc_dec, u32
request_id,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char *ke=
y, char *iv, char *data, int datalen,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 **out=
buf, int *outlen)
{
=C2=A0 =C2=A0 =C2=A0 =C2=A0int req_len, n_padding, keylen, blocklen, al=
gid;
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct request_hdr *p_hdr;
=C2=A0 =C2=A0 =C2=A0 =C2=A0char *ptr;

=C2=A0 =C2=A0 =C2=A0 =C2=A0if (alg =3D=3D 0){ //AES Algorithm
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0keylen =3D 16;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blocklen =3D 16;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0algid =3D 4;
=C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (alg =3D=3D 1){ //DES3 Algorithm
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0keylen =3D 24;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blocklen =3D 8;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0algid =3D 3;
=C2=A0 =C2=A0 =C2=A0 =C2=A0}

=C2=A0 =C2=A0 =C2=A0 =C2=A0req_len =3D sizeof(struct request_hdr) + key=
len;
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (keylen !=3D 0 && keylen % 16 =3D=3D 0)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req_len +=3D 8; =
//For request packet to be 128bit aligned
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mode =3D=3D SHAMS_CBC)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req_len +=3D blo=
cklen; // for IV len

=C2=A0 =C2=A0 =C2=A0 =C2=A0n_padding =3D (blocklen - (datalen % blockle=
n)) % blocklen; //padding
data to be multiple of 128 bits.

=C2=A0 =C2=A0 =C2=A0 =C2=A0req_len +=3D (n_padding + datalen);
=C2=A0 =C2=A0 =C2=A0 =C2=A0*outbuf =3D kmalloc(req_len, GFP_ATOMIC);
=C2=A0 =C2=A0 =C2=A0 =C2=A0p_hdr =3D (struct request_hdr *) *outbuf;
=C2=A0 =C2=A0 =C2=A0 =C2=A0*outlen =3D p_hdr->Length =3D req_len;

=C2=A0 =C2=A0 =C2=A0 =C2=A0p_hdr->request_id =3D request_id;
=C2=A0 =C2=A0 =C2=A0 =C2=A0p_hdr->AlgID_Mode_EncDec =3D (enc_dec << 15)=
 | (mode << 12) | algid;
=C2=A0 =C2=A0 =C2=A0 =C2=A0// Filling key
=C2=A0 =C2=A0 =C2=A0 =C2=A0ptr =3D *outbuf + sizeof(struct request_hdr)=
;
=C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(ptr, key, keylen);
=C2=A0 =C2=A0 =C2=A0 =C2=A0ptr +=3D keylen;
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (keylen !=3D 0 && keylen % 16 =3D=3D 0){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(ptr, 0, 8=
);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ptr +=3D 8;
=C2=A0 =C2=A0 =C2=A0 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0// Filling IV
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mode =3D=3D SHAMS_CBC){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(ptr, iv, =
blocklen);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ptr +=3D blockle=
n;
=C2=A0 =C2=A0 =C2=A0 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0// Copy data
=C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(ptr, data, datalen);
=C2=A0 =C2=A0 =C2=A0 =C2=A0ptr +=3D datalen;
=C2=A0 =C2=A0 =C2=A0 =C2=A0// Zeroing padd bits
=C2=A0 =C2=A0 =C2=A0 =C2=A0memset(ptr, 0, n_padding);

=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;

}
//--------------------------------
/* write_request that writes the provided buffer to device */

static inline int write_request(u8 *buff, unsigned int count)
{
unsigned long =C2=A0iflags;
u32 tlp_count, tlp_size;
dma_addr_t dma_addr;
struct x5pcie_dma_desc *desc_table =3D (struct x5pcie_dma_desc *)global=
_bar[0];

/** DMA operations:*/
=C2=A0 =C2=A0 =C2=A0 =C2=A0dma_addr =3D pci_map_single(global_dev, buff=
, count, PCI_DMA_TODEVICE);
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (0 =3D=3D dma_addr) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_EMER=
G"XPCIe_Read: Map error.\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
=C2=A0 =C2=A0 =C2=A0 =C2=A0}

// Do DMA transfer here....
=C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D count /4;//
=C2=A0 =C2=A0 =C2=A0 =C2=A0for (tlp_size =3D 32; tlp_size > 0; tlp_size=
--)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((count % tlp=
_size) =3D=3D 0){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0tlp_count =3D count / tlp_size;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}

=C2=A0 =C2=A0 =C2=A0 =C2=A0tlp_size =3D tlp_count | (tlp_size << 16);
=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsave(&wlock, iflags);
=C2=A0 =C2=A0 =C2=A0 =C2=A0//down(&my_sem);
// =C2=A0 =C2=A0 =C2=A0if (down_interruptible(&my_sem)){
// =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_EMERG "\=
nwrite_request: Error Acquire Semaphore!!");
// =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ERESTARTSYS;
// =C2=A0 =C2=A0 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0writel(cpu_to_le32(tlp_size),&desc_table->rd=
matlpc); =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // read
DMA TLP count: =C2=A0TLPs to transfer
=C2=A0 =C2=A0 =C2=A0 =C2=A0writel(cpu_to_le32(dma_addr),&desc_table->rd=
matlpa); =C2=A0// physical bus
address of DMA able buffer
=C2=A0 =C2=A0 =C2=A0 =C2=A0wmb();
=C2=A0 =C2=A0 =C2=A0 =C2=A0writew(cpu_to_le16(0x0001),(global_bar[0]+6)=
); =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0// read
dma start bit[16] to ddmacr
=C2=A0 =C2=A0 =C2=A0 =C2=A0wmb();
=C2=A0 =C2=A0 =C2=A0 =C2=A0while(readw((global_bar[0]+6)) !=3D 0x0101);
=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(&wlock, iflags);
=C2=A0 =C2=A0 =C2=A0 =C2=A0//up(&my_sem);
=C2=A0 =C2=A0 =C2=A0=C2=A0 // Unmap the DMA buffer so it is safe for no=
rmal access again.
=C2=A0 =C2=A0 =C2=A0 =C2=A0pci_unmap_single(global_dev, dma_addr, count=
, PCI_DMA_TODEVICE);

=C2=A0 =C2=A0 =C2=A0 =C2=A0/** End of dma section*/
=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;

}
//--------------
/* read_response that reads the en/decrypted buffer from device */

static inline int read_response(u8 **buff, =C2=A0u16 my_req_id)
{
=C2=A0 =C2=A0 =C2=A0 =C2=A0dma_addr_t dma_addr;
=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 count, tmp_req_id;
=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long =C2=A0iflags1;//, iflags2;
=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 tlp_count, tlp_size;
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct x5pcie_dma_desc *desc_table =3D (stru=
ct x5pcie_dma_desc
*)global_bar[0];

=C2=A0 =C2=A0 =C2=A0 =C2=A0for(;;){

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsav=
e(&alock, iflags1);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmp_req_id =3D r=
eadw((global_bar[0] + 82 + (fifo_entry * 4)));
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqr=
estore(&alock, iflags1);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if(my_req_id =3D=
=3D tmp_req_id) // Is the provided packet mine?
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;

=C2=A0 =C2=A0 =C2=A0 =C2=A0}

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0count =3D readw(global_bar[0] + 80 + (fifo_entry
* 4));//What is the size of my packet?
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0printk(KERN_EMERG "read_response : my_req_id =3D %d has
count =3D %d\n", my_req_id, count);

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0*buff =3D kmalloc(count, GFP_ATOMIC);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dma_addr =3D pci_map_single(global_dev, *buff, count,
PCI_DMA_FROMDEVICE);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (0 =3D=3D dma_addr){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_EMERG"XPCIe_Read: Map=
 error.\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0count =3D count /4;//
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0for (tlp_size =3D 32; tlp_size > 0; tlp_size--)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((count % tlp_size) =3D=3D 0){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tlp_c=
ount =3D count / tlp_size;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break=
;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0tlp_size =3D tlp_count | (tlp_size << 16);
=C2=A0 =C2=A0 =C2=A0 =C2=A0// =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0down(&my_sem);
// =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (down_interruptible(&my_sem)){
// =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_EMERG "\nread_response: =
Error
Acquire Semaphore!!");
// =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ERESTARTSYS;
// =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0writel(cpu_to_le32(tlp_size),&desc_table->wdmatlpc);
=C2=A0 =C2=A0 =C2=A0 =C2=A0// read DMA TLP count: =C2=A0TLPs to transfe=
r
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0writel(cpu_to_le32(dma_addr),&desc_table->wdmatlpa); =C2=A0//
physical bus address of DMA able buffer
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0wmb();
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0writew(cpu_to_le16(0x0001),(global_bar[0]+4));
=C2=A0 =C2=A0 // read dma start bit[16] to ddmacr
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0wmb();
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0while(readw(global_bar[0]+4) !=3D 0x0101);

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0fifo_entry =3D (fifo_entry + 1) % 9; // 9 : Number of
registers holding request_id and len of FiFo's elements .
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0//spin_unlock_irqrestore(&rlock, iflags2);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0//up(&my_sem);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0pci_unmap_single(global_dev, dma_addr, count,
PCI_DMA_FROMDEVICE);

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return count;

}


Thanks in advance,
Hamid.
